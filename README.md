# SNPs in population- and phylo-genomics workshop
University of Canberra 4-6 December 2018

<br/>
<br/>


## Genotype-environment association analyses
[![Alt text](../master/images/melfu_logo.png)](http://www.molecularecology.flinders.edu.au/)
**Luciano Beheregaray and Chris Brauer**
http://www.molecularecology.flinders.edu.au/

<br/>

This workshop will cover the use of redundancy analysis (RDA) in landscape genomics studies of non-model species. 
Please ensure you have installed the required software and R packages prior to the workshop by following the instructions below.
<br/>
<br/>

## Suggested reading
[Brauer CJ, Unmack PJ, Smith S, Bernatchez L, Beheregaray LB (2018) On the roles of landscape heterogeneity and environmental variation in determining population genomic structure in a dendritic system. *Molecular Ecology* 27, 3484-3497.](../working/docs/Brauer_et_al_2018.pdf)

[Forester BR, Lasky JR, Wagner HH, Urban DL (2018) Comparing methods for detecting multilocus adaptation with multivariate genotype‐environment associations. *Molecular Ecology* 27, 2215–2233.](../working/docs/Forester_et_al_2018.pdf)

[Capblancq T, Luu K, Blum MG, Bazin E (2018) Evaluation of redundancy analysis to identify signatures of local adaptation. *Molecular Ecology Resources*.](../working/docs/Capblancq_et_al_2018.pdf)

<br/>
<br/>

## Required software:
[![Alt text](../master/images/R.png)](https://www.r-project.org/)

## Optional software:
[![Alt text](../master/images/RStudio.png)](https://www.rstudio.com/products/rstudio/download/)

This is not essential, but RStudio provides a nice user interface that helps keep everything organised.

<br/>
<br/>


## Required R packages:

**devtools, adegenet, vegan, fmsb, psych, packfor**

The first five can be installed from CRAN using the following commands in the R console:

```r
install.packages("devtools")
install.packages("adegenet")
install.packages("vegan")
install.packages("fmsb")
install.packages("psych")

```
\
packfor can be more difficult, depending on your system

First, try:

```r
install.packages("packfor", repos="http://R-Forge.R-project.org")

```
You may get a question during the install process:
“Do you want to attempt to install these from sources?”
\
You should answer: y
\
\
\
If you have trouble, you can instead try downloading the package binary to install for either:


[MacOS/Linux](http://download.r-forge.r-project.org/src/contrib/packfor_0.0-8.tar.gz)


[or Windows](http://download.r-forge.r-project.org/bin/windows/contrib/3.3/packfor_0.0-8.zip)
\
\
\
Then, run the following command in the R console, replacing "/path/to/" with the file path to the downloaded package:

MacOS/Linux:
```r
install.packages("/path/to/packfor_0.0-8.tar.gz", repos = NULL, type = "source")

```

Windows:
```r
install.packages("/path/to/packfor_0.0-8.zip", repos = NULL, type = "source")

```

\
Now load the installed packages:
```r
library(adegenet)
library(vegan)
library(fmsb)
library(psych)
library(packfor)

```
<br/>
<br/>

## Finally, load the data and R code for the tutorial

## TO DO

**Check back here soon!**















