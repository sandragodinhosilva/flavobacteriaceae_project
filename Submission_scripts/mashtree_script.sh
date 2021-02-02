#!/bin/bash
echo "First arg: $1"
echo "Second arg: $2"

#$ -l h_rt=24:00:00
#$ -l h_vmem=10G
#$ -pe smp 2-32


#$ -o /gpfs1/data/msb/silva/job_logs/mashtree/$JOB_NAME-$JOB_ID.out
#$ -e /gpfs1/data/msb/silva/job_logs/mashtree/$JOB_NAME-$JOB_ID.err



task="mashtree"


module load Anaconda3/5.3.0
source activate /data/msb/tools/mashtree/mashtree_conda



# input 1 is the folder containing the genomes
# input 2 is the dnd output tree

# please use full path for the inputs


echo "---> Starting with "$task
date

mashtree --numcpus  "${NSLOTS:-1}" "$1"/* > "$2"


date
echo "---> Finished with"$task
