## plot candidate snps identified using MfRDA.R tutorial
# code below is modified from tutorial written by Brenna Forester available at http://popgen.nescent.org


sel <- cand$snp
env <- cand$predictor
env[env=="tempPC1"] <- 'red'
env[env=="tempPC2"] <- 'gold'
env[env=="precipPC2"] <- 'dodgerblue3'
env[env=="flowPC2"] <- 'lightblue'

# color by predictor:
col.pred <- rownames(Mf.RDA$CCA$v) # pull the SNP names

for (i in 1:length(sel)) {           # color code candidate SNPs
  foo <- match(sel[i],col.pred)
  col.pred[foo] <- env[i]
}

col.pred[grep("SNP",col.pred)] <- '#f1eef6' # non-candidate SNPs
empty <- col.pred
empty[grep("#f1eef6",empty)] <- rgb(0,1,0, alpha=0) # transparent
empty.outline <- ifelse(empty=="#00FF0000","#00FF0000","gray32")
bg <- c('red','gold','dodgerblue3','lightblue')


# axes 1 & 2
pdf(file = "Mf_RDA_loci_12.pdf", height = 6, width = 6)
plot(Mf.RDA, type="n", scaling=3, xlim=c(-1,1), ylim=c(-1,1))
points(Mf.RDA, display="species", pch=21, cex=1, col="gray32", bg=col.pred, scaling=3)
points(Mf.RDA, display="species", pch=21, cex=1, col=empty.outline, bg=empty, scaling=3)
text(Mf.RDA, scaling=3, display="bp", col="blue", cex=0.6)
legend("bottomleft", legend=c("tempPC1", "tempPC2", "precipPC2", "flowPC2"), bty="n", col="gray32", pch=21, cex=1, pt.bg=bg)
dev.off()

# axes 1 & 3
pdf(file = "Mf_RDA_loci_13.pdf", height = 6, width = 6)
plot(Mf.RDA, type="n", scaling=3, xlim=c(-1,1), ylim=c(-1,1), choices=c(1,3))
points(Mf.RDA, display="species", pch=21, cex=1, col="gray32", bg=col.pred, scaling=3, choices=c(1,3))
points(Mf.RDA, display="species", pch=21, cex=1, col=empty.outline, bg=empty, scaling=3, choices=c(1,3))
text(Mf.RDA, scaling=3, display="bp", col="blue", cex=0.6, choices=c(1,3))
legend("bottomleft", legend=c("tempPC1", "tempPC2", "precipPC2", "flowPC2"), bty="n", col="gray32", pch=21, cex=1, pt.bg=bg)
dev.off()

# axes 2 & 3
pdf(file = "Mf_RDA_loci_23.pdf", height = 6, width = 6)
plot(Mf.RDA, type="n", scaling=3, xlim=c(-1,1), ylim=c(-1,1), choices=c(2,3))
points(Mf.RDA, display="species", pch=21, cex=1, col="gray32", bg=col.pred, scaling=3, choices=c(2,3))
points(Mf.RDA, display="species", pch=21, cex=1, col=empty.outline, bg=empty, scaling=3, choices=c(2,3))
text(Mf.RDA, scaling=3, display="bp", col="blue", cex=0.6, choices=c(2,3))
legend("bottomleft", legend=c("tempPC1", "tempPC2", "precipPC2", "flowPC2"), bty="n", col="gray32", pch=21, cex=1, pt.bg=bg)
dev.off()




# pca based on candidate snps
cansnps <- snps[,c(cand$snp)]
cand.pca <- rda(cansnps)
x.lab <- paste0("PC1 (", paste(round((cand.pca$CA$eig[1]/cand.pca$tot.chi*100),2)),"%)")
y.lab <- paste0("PC2 (", paste(round((cand.pca$CA$eig[2]/cand.pca$tot.chi*100),2)),"%)")


pdf(file = "Mf_canpca.pdf", height = 6, width = 6)
pRDAplot <- plot(cand.pca, choices = c(1, 2), type = "n", xlab=x.lab, ylab=y.lab, cex.lab=1)
with(ENV, points(cand.pca, display = "sites", col = site_colvec[pop], pch = site_pch[pop], cex=0.7, bg = site_colvec[pop]))
legend("topright", legend = site_leglabs, col=site_legcols, pch=site_legpch, pt.cex=1, cex=0.50, xpd=1, box.lty = 0, bg= "transparent")
dev.off()





