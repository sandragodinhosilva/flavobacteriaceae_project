#!/bin/bash

# modified by bicalho on 31/07/2020

# 1 /input/path/
# 2 /output/path/

# loading modules
module load gcc/4/8.1-3

#####$ -N $finalname
#$ -l h_rt=20:00:00
#$ -l h_vmem=20G 
#$ -binding linear:1


# output files
#$ -o /data/msb/silva/job_logs/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/$JOB_NAME-$JOB_ID.err


source /data/msb/tools/miniconda/miniconda2/bin/activate
conda activate /data/msb/tools/metawrap/metawrap_env

unset LD_PRELOAD

date

metawrap annotate_bins -o "$2" -b "$1"

