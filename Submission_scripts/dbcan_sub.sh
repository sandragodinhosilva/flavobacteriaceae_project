#!/bin/bash

#loading modules
module load GCCcore/8.3.0 Python/3.7.4 Anaconda3/5.3.0

#load on environment
conda activate /data/msb/tools/dbcan/conda_env

#resources
#$ -l h_rt=50:00:00
#$ -l h_vmem=10G
#$ -binding linear:1

#output files
#$ -o /gpfs1/data/msb/silva/job_logs/dbcan/$JOB_NAME-$JOB_ID.out
#$ -e /gpfs1/data/msb/silva/job_logs/dbcan/$JOB_NAME-$JOB_ID.err

#1 prefix to add to the output files
#2 [inputFile] FASTA format file of either nucleotide (prok) or protein (protein) sequences
#input type
#3 is the output folder

task="dbcan"

echo "---> Starting with "$task
date

run_dbcan.py --db_dir /data/msb/tools/dbcan/db --out_pre "$1" "$2" protein --out_dir "$3"

date
echo "---> Finished with"$task
