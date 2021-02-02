#!/bin/bash

# loading modules
module load GCC/7.3.0-2.30  OpenMPI/3.1.1  GDAL/2.2.3-Python-3.6.6 Anaconda3/5.3.0

# load conda
conda activate /data/msb/silva/hmmer_env

#$ -l h_rt=5:00:00
#$ -l h_vmem=10G
#$ -binding linear:1

# output files
#$ -o /data/msb/silva/job_logs/hmmsearch/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/hmmsearch/$JOB_NAME-$JOB_ID.err

task="hmmsearch"

date

echo "starting "$task

#1 is the output tblout filename
#2 is the database
#3 is the input genome in .faa formt 

hmmsearch --tblout "$1" -E 1e-5 "$2" "$3" 

date

echo "finishing "$task
