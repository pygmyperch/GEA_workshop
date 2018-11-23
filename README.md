# SNPs in population- and phylo-genomics workshop
### University of Canberra 4-6 December 2018



## Genotype-environment association analyses
This workshop will cover the use of redundancy analysis (RDA) in landscape genomics studies of non-model species. 


## Required software: R

```r
Download at: https://www.r-project.org/
```

## Optional software: RStudio
This is not essential, but RStudio provides a nice user interface that helps keep everything organised

```r
Download at: https://www.rstudio.com/products/rstudio/download/
```

## Required R packages: adegenet, vegan, fmsb, psych, packfor
The first four can be installed from CRAN using the following commands in the R console:

```r
install.packages("devtools")
install.packages("adegenet")
install.packages("vegan")
install.packages("fmsb")
install.packages("psych")

```
\
packfor can be more difficult, depending on your system
First try:

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
If you have trouble, you can instead try downloading the package binary to install:

```r
Download the package for either

a.	MacOS/Linux
	http://download.r-forge.r-project.org/src/contrib/packfor_0.0-8.tar.gz

b.	or Windows
	http://download.r-forge.r-project.org/bin/windows/contrib/3.3/packfor_0.0-8.zip


```
\
\
\
Then, run the following command in the R console, replacing "/path/to/" with the file path to your downloaded package:

```r
a.	MacOS/Linux
	install.packages("/path/to/packfor_0.0-8.tar.gz", repos = NULL, type = "source")

b.	or Windows
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
\
\
\
Finally, load data and R code for the tutorial

First, install devtools:

```r
install.packages("devtools")
library("devtools")
```

Then install the package from GitHub

```r
install_github("pygmyperch/GEA_workshop")
library(GEA_workshop)
```














