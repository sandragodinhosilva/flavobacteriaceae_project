#!/bin/bash

# loading modules
module load GCC/7.3.0-2.30  OpenMPI/3.1.1  GDAL/2.2.3-Python-3.6.6 Anaconda3/5.3.0

# load conda
conda activate /data/msb/silva/COG_env

#$ -l h_rt=5:00:00
#$ -l h_vmem=5G
#$ -binding linear:1

# output files
#$ -o /data/msb/silva/job_logs/cdd2cog/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/cdd2cog/$JOB_NAME-$JOB_ID.err

task="cdd2cog"

date

echo "starting "$task

#1 is the faa file
#2 ouput file (rps-blast.out) 

rpsblast -query "$1" -db /data/msb/silva/COG/Cog -out "$2" -outfmt 6 -evalue 1e-5

date

echo "finishing "$task
