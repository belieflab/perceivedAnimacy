#!/bin/bash
#SBATCH --mail-type=ALL #send me emails when starting and ending
#SBATCH -t 0:10:00 #10 min
#SBATCH --mem=16g  #16GB RAM


module load R
Rscript ../batch_scripts/parameters_recovery_1.R