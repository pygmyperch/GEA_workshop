# Genotype-environment association analyses
### SNPs in population- and phylo-genomics workshop
Centre for Biodiversity Analysis, 4-6 December 2018

<br/>
<br/>


___
[![Alt text](../master/images/melfu_logo.png)](http://www.molecularecology.flinders.edu.au/)



#### http://www.molecularecology.flinders.edu.au/&nbsp; &nbsp; [![Alt text](../master/images/fb3.png)](https://www.facebook.com/molecularecologylab/)&nbsp; &nbsp; &nbsp; &nbsp; Luciano Beheregaray&nbsp; [![Alt text](../master/images/mail2.png)](mailto:luciano.beheregaray@flinders.edu.au)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Chris Brauer&nbsp; [![Alt text](../master/images/mail2.png)](mailto:chris.brauer@flinders.edu.au)&nbsp; &nbsp; [![Alt text](../master/images/twitter2.png)](https://twitter.com/pygmyperch)
___
<br/>

Identifying the genetic and evolutionary basis of local adaptation is a key focus in evolutionary biology. Genotype-environment association (GEA) analyses are used to identify candidate adaptive loci by testing for direct associations between allele frequencies and environmental variables. These methods are increasingly applied in landscape genomics studies, particularly as genome-wide data becomes more accessible for non-model species. This workshop will cover the use of a multivariate ordination GEA approach, redundancy analysis (RDA), for identifying candidate loci from SNP data. 


<br/>
<br/>

## Suggested reading
[Brauer CJ, Unmack PJ, Smith S, Bernatchez L, Beheregaray LB (2018) On the roles of landscape heterogeneity and environmental variation in determining population genomic structure in a dendritic system. *Molecular Ecology* **27**, 3484-3497.](../master/docs/Brauer_et_al_2018.pdf)

[Forester BR, Lasky JR, Wagner HH, Urban DL (2018) Comparing methods for detecting multilocus adaptation with multivariate genotype‐environment associations. *Molecular Ecology* **27**, 2215–2233.](../master/docs/Forester_et_al_2018.pdf)

[Capblancq T, Luu K, Blum MG, Bazin E (2018) Evaluation of redundancy analysis to identify signatures of local adaptation. *Molecular Ecology Resources*.](../master/docs/Capblancq_et_al_2018.pdf)

<br/>
<br/>

# Please ensure you have installed the required software and R packages prior to the workshop by following the instructions below.

<br/>

## Required software:
[![Alt text](../master/images/R.png)](https://www.r-project.org/)

## Optional software:
[![Alt text](../master/images/RStudio.png)](https://www.rstudio.com/products/rstudio/download/)

This is not essential, but RStudio provides a nice user interface that helps keep everything organised.

<br/>
<br/>


## Required R packages:

# **UPDATE: due to several installation issues, *packfor* is no longer required**

**adegenet, vegan, fmsb, psych**

The first four can be installed from CRAN using the following commands in the R console:

```r
install.packages("adegenet")
install.packages("vegan")
install.packages("fmsb")
install.packages("psych")

```
\
**packfor no longer required, sorry for any inconvenience**

\
Now check to see that the installed packages load:
```r
library(adegenet)
library(vegan)
library(fmsb)
library(psych)


```
<br/>
<br/>

## The data and R code for the tutorial will be available to download at the workshop
















