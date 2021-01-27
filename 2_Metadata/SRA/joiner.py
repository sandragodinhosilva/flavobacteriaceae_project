#!/usr/bin/python3
import sys

##################################################################
#   
#   USAGE:
#   merge_expacc_tinder.py file1 file 2
#
##################################################################

file_1 = sys.argv[1]
srr_list = open(file_1,"r")
valid_srr = {}

lines = srr_list.readlines()[1:] #not skiping the header cause in this case
for l in lines:
	l = l.strip()
	fields = l.split("\t")
	srr = fields[0]
	valid_srr[srr] = l

srr_list.close()


file_2 = sys.argv[2]
srr_sra_metadata = open(file_2,"r")

lines = srr_sra_metadata.readlines()[1:] #skipping the header
for l in lines:
	l = l.strip()
	line = l
	fields = l.split("\t")
	runaccessions = fields[3]
	srrs = runaccessions.split(",")
	assembly = fields[0]

	for srr in srrs:
		if srr in valid_srr.keys():
			print(assembly, srr, sep="\t")

srr_sra_metadata.close()


