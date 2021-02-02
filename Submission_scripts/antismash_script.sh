#!/bin/bash

# loading modules
module load GCC/7.3.0-2.30  OpenMPI/3.1.1  GDAL/2.2.3-Python-3.6.6 Anaconda3/5.3.0  uge/8.5.5-2
module load JUnit/4.12-Java-1.8

# load conda
conda activate /data/msb/tools/antismash/conda-antismash


#$ -l h_rt=5:00:00
#$ -l h_vmem=10G
#$ -binding linear:1 	# for single core	#

# output files
#$ -o /data/msb/silva/job_logs/antismash/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/antismash/$JOB_NAME-$JOB_ID.err

task="antismash"

date
echo "starting "$task

#1 is the input file
#2 is the output folder
#3 is the 

antismash --genefinding-tool prodigal --cb-knowncluster "$1" --output-dir "$2" 

echo "input file: $1"
echo "output folder: $2"

date
echo "finishing "$task



