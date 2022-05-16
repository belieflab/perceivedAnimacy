#!/bin/bash
#SBATCH --mail-type=ALL #send me emails when starting and ending
#SBATCH -t 3:00:00 #3 hours
#SBATCH --mem=16g  #16GB RAM


module load R
Rscript explore_passiveStim_v3.R
