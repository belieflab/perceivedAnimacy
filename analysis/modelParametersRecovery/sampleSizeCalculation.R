# Remove all of the elements currently loaded in R
rm(list=ls(all=TRUE)) 
# set wording directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# libraries
if (!require(pwr)) {install.packages('pwr')}; library(pwr) 
# multiple regression sample size calculation
# https://med.und.edu/daccota/_files/pdfs/berdc_resource_pdfs/sample_size_r_module.pdf
pwr.f2.test(u=3, f2=0.15, sig.level=0.05, power=0.80)
