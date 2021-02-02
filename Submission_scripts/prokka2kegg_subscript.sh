#!/bin/bash

# loading modules
module load GCC/7.3.0-2.30  OpenMPI/3.1.1  GDAL/2.2.3-Python-3.6.6 Anaconda3/5.3.0

# load conda
conda activate /data/msb/silva/hmmer_env

#$ -l h_rt=42:30:00
#$ -l h_vmem=40G
#$ -binding linear:1

# output files
#$ -o /data/msb/silva/job_logs/prokka2kegg/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/prokka2kegg/$JOB_NAME-$JOB_ID.err

task="prokka2kegg"

date

echo "starting "$task

#1 is the gbk file
#2 is the output file 

/data/msb/silva/prokka2kegg/prokka2kegg_batch.py -i "$1" -d /data/msb/silva/NEW/3_Annotation/Kegg/idmapping_KO.tab.gz -o  "$2" 

date

echo "finishing "$task
