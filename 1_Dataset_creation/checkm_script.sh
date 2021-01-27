#!/bin/bash

# old  sub_script.sh edited by Bicalho and S.G.Silva
# Last version 07-07-2020.

# 1 /location/of/folder/with/bins/
# 2 /location/of/output/folder/
# the output file will be output_checkm.tsv

# creating output folder
mkdir -p "$2"checkm_output/

# loading modules
module load GCCcore/8.3.0 Python/3.7.4

#$ -l h_rt=50:00:00
#$ -l h_vmem=15G
###$ -binding linear:1 	# for single core	#
#$ -pe smp 4-28  	# for multi-core

# output files
#$ -o /data/msb/silva/job_logs/$JOB_NAME-$JOB_ID.out
#$ -e /data/msb/silva/job_logs/$JOB_NAME-$JOB_ID.err

task=""

date
echo "starting "$task

source /data/msb/tools/checkm/new_install/checkm/bin/activate

command
checkm lineage_wf -t "${NSLOTS:-1}" --tab_table -x fna -f "$2"checkm_output/output_checkm.tsv "$1" "$2"checkm_output/

date
echo "finishing "$task
