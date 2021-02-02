#!/bin/bash

# old gtdbtk_v1.3.0.sh edited by Bicalho. Last edition 20/07/2020.

# creating output directory

mkdir -p "$2"gtdbtk_output/

# loading modules

module load   GCC/6.4.0-2.28  OpenMPI/2.1.2 Python/3.6.4


source /gpfs1/data/msb/tools/GTDB/gtdbtk-v1.3.0/bin/activate

# necessary path variable
export GTDBTK_DATA_PATH=/gpfs1/data/msb/tools/GTDB/external_data/release95


# resoruces
#$ -l h_rt=50:00:00
#$ -l h_vmem=60G  -pe smp 2-28


# output files
#$ -o /data/msb/silva/job_logs/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/$JOB_NAME-$JOB_ID.err


gtdbtk  classify_wf --extension  fna  --cpus "${NSLOTS:-1}" --genome_dir "$1"  --out_dir "$2"gtdbtk_output/

