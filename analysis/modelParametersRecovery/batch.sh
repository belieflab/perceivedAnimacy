#!/bin/bash
#SBATCH --mail-type=ALL #send me emails when starting and ending
#SBATCH -t 24:00:00 #24 hours
#SBATCH --mem=32g  #32GB RAM


module load R
Rscript parameter_recovery.R