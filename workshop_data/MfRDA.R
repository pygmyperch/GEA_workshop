# GEA analysis of SNP and environmental data using RDA



# load required packages
library(adegenet)
library(vegan)
library(fmsb)
library(psych)
library(dartR)


# set the working directory to wherever you downloaded the files
setwd("/Users/chrisbrauer/Desktop/workshop/GEAtutorial/")


############################
# 1. Data preparation
############################


# load genlight object
load("Mf5000_gl")
Mf5000.genind <- gl2gi(Mf5000_gl)
Mf5000.genind





# Format SNP data for ordination analysis in vegan
# You want a matrix of allele counts per locus, per individual
# can use population allele frequencies instead

# get allele counts
alleles <- Mf5000.genind@tab
alleles[1:10,1:10]


# get genotypes (counts of reference allele) and clean up locus names
snps <- alleles[,seq(1,ncol(alleles),2)]
colnames(snps) <- locNames(Mf5000.genind)
snps[1:10,1:10]



# check total % missing data
(sum(is.na(snps)))/(dim(snps)[1]*dim(snps)[2])*100

# impute missing data with most common genotype
snps <- apply(snps, 2, function(x) replace(x, is.na(x), as.numeric(names(which.max(table(x))))))

# check % missing data again
(sum(is.na(snps)))/(dim(snps)[1]*dim(snps)[2])*100
snps[1:10,1:10]




# get environmental data
ENV <- read.table("ENV.txt", header = TRUE)
head(ENV)



###################################################################################################

# XY coordinates used to control for spatila structure in the data...
# but due to dendritic network structure, long, lat not a good representation of biological
# distance among sites

# can use MDS (principal coordinates analysis) to generate new coordinates that better 
# reflect the biological relationship among sites
river.distances <- read.table("Mf_riv_dist.txt") 
river.xy <- cmdscale(river.distances, k = 2, eig = FALSE, add = FALSE, x.ret = FALSE)
colnames(river.xy) <- c("X","Y")
river.xy

# expand population coordinates to individual coordinates

pop.map <- as.data.frame(ENV$pop)
colnames(pop.map) <- "pop"

#generate key from popmap and coordinates
key <- cbind(unique(pop.map),river.xy)
pop.map$id  <- 1:nrow(pop.map)

#set coordinates for each individual
r_merge <- function() {merge(pop.map, key, by="pop")}
river.xy <- r_merge()
river.xy <- river.xy[order(river.xy$id), ]
river.xy <- as.matrix(cbind(river.xy$X, river.xy$Y))

###################################################################################################



# we now have our SNP data with no missing genotypes
# to get a feel for the data we can run quick PCA using the rda function
pc <- rda(snps)
plot(pc)


# set some plotting variables to make it easier to interpret (this is a little more custom than it could be...)
#set colours and marker size for plot
site_colvec <- c("limegreen", "darkorange1", "slategrey", "darkturquoise", "slategrey",
                 "gold", "darkturquoise", "darkturquoise", "slategrey", "dodgerblue3", "slategrey", "slategrey", "limegreen", "gold")

site_pch <- c(15, 16, 17, 17, 15, 15, 16, 15, 18, 16, 16, 8, 16, 16)

#set colours and labels for legend
site_leglabs <- c('MBR', 'MDC', 'GGL', 'WAK', 'BEN', 'BOG', 'PEL', 'GWY', 'DUM', 'MIB', 'STG', 'OAK', 'WAR', 'KIL')
site_legcols <- c('darkturquoise', 'darkturquoise', 'darkturquoise', 'limegreen', 'limegreen', 'darkorange1', 'slategrey', 'slategrey', 'slategrey',
                  'slategrey', 'slategrey', 'dodgerblue3', 'gold', 'gold')
site_legpch <- c(16, 15, 17, 16, 15, 16, 16, 15, 17, 18, 8, 16, 16, 15)

# generate labels for each axis
x.lab <- paste0("PC1 (", paste(round((pc$CA$eig[1]/pc$tot.chi*100),2)),"%)")
y.lab <- paste0("PC2 (", paste(round((pc$CA$eig[2]/pc$tot.chi*100),2)),"%)")


# plot PCA

pdf(file = "Mf_PCA.pdf", height = 6, width = 6)
pRDAplot <- plot(pc, choices = c(1, 2), type = "n", xlab=x.lab, ylab=y.lab, cex.lab=1)
with(ENV, points(pc, display = "sites", col = site_colvec[pop], pch = site_pch[pop], cex=0.7, bg = site_colvec[pop]))
legend("topright", legend = site_leglabs, col=site_legcols, pch=site_legpch, pt.cex=1, cex=0.50, xpd=1, box.lty = 0, bg= "transparent")
dev.off()







############################
# 2. Variable selection
############################


# Preliminary analysis to identify environmental variables to retain in final RDA model
# reduce SNP data to PCoAs (you can instead use the whole data set here if you prefer)
snps.bray <- vegdist(snps, method="bray")
snp.pcoa <- cmdscale(snps.bray, k=nrow(snps)-1, eig=T, add=T)
eig <- snp.pcoa$eig/sum(snp.pcoa$eig)
bst <- unname(bstick(length(eig)))
axes <- scores(snp.pcoa)
only <- min(which((eig>bst) == FALSE))
y <- axes[,c(1:only-1)]



# extract predictor variables to matrix
env_var <- as.matrix(ENV[,4:9])



# forward selection of environmental variables
mod0 <- rda(y ~ ., data.frame(env_var), scale= FALSE)
R2.all.env <- RsquareAdj(mod0)$adj.r.squared
sel <- ordistep(rda(y ~ 1, data.frame(env_var)), scope = formula(mod0), scale= FALSE, direction="forward", pstep = 1000)
sel <- attributes(sel$terms)$term.labels

#subsample space to the selected variables
ENV.sel <- env_var[,sel]


# check for obvious correlations between variables
pairs.panels(ENV.sel, scale=T, lm = TRUE)

## reduce variance associated with correlated environmental PCs using VIF analyses
# define backward selection VIF function
vif_func<-function(in_frame,thresh=10,trace=T,...){

  require(fmsb)

  if(class(in_frame) != 'data.frame') in_frame<-data.frame(in_frame)

  #get initial vif value for all comparisons of variables
  vif_init<-NULL
  var_names <- names(in_frame)
  for(val in var_names){
    regressors <- var_names[-which(var_names == val)]
    form <- paste(regressors, collapse = '+')
    form_in <- formula(paste(val, '~', form))
    vif_init<-rbind(vif_init, c(val, VIF(lm(form_in, data = in_frame, ...))))
  }
  vif_max<-max(as.numeric(vif_init[,2]))

  if(vif_max < thresh){
    if(trace==T){ #print output of each iteration
      prmatrix(vif_init,collab=c('var','vif'),rowlab=rep('',nrow(vif_init)),quote=F)
      cat('\n')
      cat(paste('All variables have VIF < ', thresh,', max VIF ',round(vif_max,2), sep=''),'\n\n')
    }
    return(var_names)
  }
  else{

    in_dat<-in_frame

    #backwards selection of explanatory variables, stops when all VIF values are below 'thresh'
    while(vif_max >= thresh){

      vif_vals<-NULL
      var_names <- names(in_dat)

      for(val in var_names){
        regressors <- var_names[-which(var_names == val)]
        form <- paste(regressors, collapse = '+')
        form_in <- formula(paste(val, '~', form))
        vif_add<-VIF(lm(form_in, data = in_dat, ...))
        vif_vals<-rbind(vif_vals,c(val,vif_add))
      }
      max_row<-which(vif_vals[,2] == max(as.numeric(vif_vals[,2])))[1]

      vif_max<-as.numeric(vif_vals[max_row,2])

      if(vif_max<thresh) break

      if(trace==T){ #print output of each iteration
        prmatrix(vif_vals,collab=c('var','vif'),rowlab=rep('',nrow(vif_vals)),quote=F)
        cat('\n')
        cat('removed: ',vif_vals[max_row,1],vif_max,'\n\n')
        flush.console()
      }

      in_dat<-in_dat[,!names(in_dat) %in% vif_vals[max_row,1]]

    }

    return(names(in_dat))

  }

}

# run procedure to remove variables with the highest VIF one at a time until all remaining variables are below 10
keep.env <-vif_func(in_frame=ENV.sel,thresh=10,trace=T)
keep.env  # the retained environmental variables
reduced.env <- subset(as.data.frame(ENV.sel), select=c(keep.env))

# lets have another look
pairs.panels(reduced.env, scale=T, lm = TRUE)


## get spatial coordinates
xy <- as.matrix(cbind(ENV$X, ENV$Y))



############################
# 3. Run analysis
############################


# reduced RDA model using the retained environmental PCs conditioned on the retained spatial variables
Mf.RDA <- rda(snps ~ tempPC1+tempPC2+precipPC2+flowPC2 + Condition(xy), data = reduced.env)
Mf.RDA


# So how much genetic variation can be explained by our environmental model?
RsquareAdj(Mf.RDA)$r.squared

# how much inertia is associated with each axis
screeplot(Mf.RDA)

# calculate significance of the reduced model, marginal effect of each term and significance of each axis
#   (this can take several hours, depending on your computer)
mod_perm <- anova.cca(Mf.RDA, nperm=1000) #test significance of the model
margin_perm <- anova.cca(Mf.RDA, by="margin", nperm=1000)#test marginal effect of each individual term in the model
axis_perm <- anova.cca(Mf.RDA, by="axis", nperm=1000)#test significance of each constrained axis


#generate x and y labels (% constrained variation)
x.lab <- paste0("RDA1 (", paste(round((Mf.RDA$CCA$eig[1]/Mf.RDA$CCA$tot.chi*100),2)),"%)")
y.lab <- paste0("RDA2 (", paste(round((Mf.RDA$CCA$eig[2]/Mf.RDA$CCA$tot.chi*100),2)),"%)")
z.lab <- paste0("RDA3 (", paste(round((Mf.RDA$CCA$eig[3]/Mf.RDA$CCA$tot.chi*100),2)),"%)")



#plot RDA1, RDA2
#pdf(file = "Mf_RDA.pdf", height = 6, width = 6)
pRDAplot <- plot(Mf.RDA, choices = c(1, 2), type="n", cex.lab=1, xlab=x.lab, ylab=y.lab)
with(ENV, points(Mf.RDA, display = "sites", col = site_colvec[pop], pch = site_pch[pop], cex=0.7, bg = site_colvec[pop]))
text(Mf.RDA, "bp",choices = c(1, 2), select = c("tempPC1", "tempPC2", "precipPC2", "flowPC2"), col="blue", cex=0.6)
legend("topleft", legend = site_leglabs, col=site_legcols, pch=site_legpch, pt.cex=1, cex=0.50, xpd=1, box.lty = 0, bg= "transparent")
#dev.off()




##############################
# 4. Identify candidate loci
##############################


# The next section is modified from code written by Brenna Forester available at http://popgen.nescent.org

## obtain list of candidate loci
# calculate coordinates of loci more than 3SD from mean locus scores for each significant RDA axis

locus_scores <- scores(Mf.RDA, choices=c(1:3), display="species")

hist(locus_scores[,1], main="Loadings on RDA1")
hist(locus_scores[,2], main="Loadings on RDA2")
hist(locus_scores[,3], main="Loadings on RDA3")



outliers <- function(x,z){
  lims <- mean(x) + c(-1, 1) * z * sd(x)     # find loadings +/-z sd from mean loading     
  x[x < lims[1] | x > lims[2]]               # locus names in these tails
}



cand1 <- outliers(locus_scores[,1],3)
cand2 <- outliers(locus_scores[,2],3)
cand3 <- outliers(locus_scores[,3],3)




#get total number of candidates
ncand <- length(cand1) + length(cand2) + length(cand3)
ncand

cand1 <- cbind.data.frame(rep(1,times=length(cand1)), names(cand1), unname(cand1))
cand2 <- cbind.data.frame(rep(2,times=length(cand2)), names(cand2), unname(cand2))
cand3 <- cbind.data.frame(rep(3,times=length(cand3)), names(cand3), unname(cand3))

colnames(cand1) <- colnames(cand2) <- colnames(cand3) <- c("axis","snp","loading")

cand <- rbind(cand1, cand2, cand3)
cand$snp <- as.character(cand$snp)

env_mat <- matrix(nrow=(ncand), ncol=4)  # 4 columns for 4 predictors
colnames(env_mat) <- c("tempPC1", "tempPC2", "precipPC2", "flowPC2")


# calculate correlation between candidate snps and environmental variables
for (i in 1:length(cand$snp)) {
  nam <- cand[i,2]
  snp.gen <- snps[,nam]
  env_mat[i,] <- apply(reduced.env,2,function(x) cor(x,snp.gen))
}

cand <- cbind.data.frame(cand,env_mat)  
head(cand)

length(cand$snp[duplicated(cand$snp)])
env_mat <- cbind(cand$axis, duplicated(cand$snp)) 
table(env_mat[env_mat[,1]==1,2])# none on axis 1
table(env_mat[env_mat[,1]==2,2])# 2 duplicates on axis 2
cand <- cand[!duplicated(cand$snp),]

for (i in 1:length(cand$snp)) {
  bar <- cand[i,]
  cand[i,8] <- names(which.max(abs(bar[4:7]))) # gives the variable
  cand[i,9] <- max(abs(bar[4:7]))              # gives the correlation
}

colnames(cand)[8] <- "predictor"
colnames(cand)[9] <- "correlation"

table(cand$predictor) 


