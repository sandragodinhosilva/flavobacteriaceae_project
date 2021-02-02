#!/bin/bash

# loading modules
module load GCC/7.3.0-2.30  OpenMPI/3.1.1  GDAL/2.2.3-Python-2.7 Anaconda3/5.3.0

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

#1 output from rpsblast
#2 output folder

perl /data/msb/silva/COG/cdd2cog2.pl -r "$1" -c /data/msb/silva/COG/cddid.tbl -f /data/msb/silva/COG/fun.txt -w /data/msb/silva/COG/whog -o "$2"

date

echo "finishing "$task
