#!/bin/bash

# loading modules
module load   GCC/7.3.0-2.30  OpenMPI/3.1.1 ANTLR/2.7.7-Python-3.6.6

conda activate /data/msb/tools/big-scape/conda-bigscape

#$ -l h_rt=40:00:00
#$ -l h_vmem=40G
#$ -pe smp 8-28  	# for multi-core

# output files
#$ -o /data/msb/silva/job_logs/bigscape/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/bigscape/$JOB_NAME-$JOB_ID.err

task="bigscape"

date
echo "starting "$task

#1 is the input
#2 is the output 

python /data/msb/tools/big-scape/BiG-SCAPE/bigscape.py -c "${NSLOTS:-1}" --mibig -i "$1" -o "$2" 


date
echo "finishing "$task



