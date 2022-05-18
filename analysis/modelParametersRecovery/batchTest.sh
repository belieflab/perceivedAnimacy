#!/bin/bash
#SBATCH --mail-type=ALL #send me emails when starting and ending
#SBATCH -t 0:01:00 #1 min
#SBATCH --mem=1g  #1GB RAM


module load R
Rscript test.R