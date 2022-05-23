#!/bin/bash
#SBATCH --output dsq-job_file-%A_%2a-%N.out
#SBATCH --array 0-99
#SBATCH --job-name dsq-job_file
#SBATCH -p general -c1 --mem-per-cpu=16G -t 6:00:00

# DO NOT EDIT LINE BELOW
/ysm-gpfs/apps/software/dSQ/1.05/dSQBatch.py --job-file /gpfs/ysm/home/sc3228/perceivedAnimacy/analysis/participantModelFit/job_file.txt --status-dir /gpfs/ysm/home/sc3228/perceivedAnimacy/analysis/participantModelFit

