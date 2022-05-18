#!/bin/bash
#SBATCH --mail-type=ALL #send me emails when starting and ending
#SBATCH -t 8:00:00 #8 hour
#SBATCH --mem=32g  #32GB RAM


module load R
Rscript ../batch_scripts/parameters_recovery_30.R