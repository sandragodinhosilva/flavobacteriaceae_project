#!/bin/bash

#usage: sh program.sh experiment.accessions
#This script requires as input the accession numbers

#Print header
echo -e "AssemblyAcc\tBioProject\tBioSample\tRunAccessions"

for i in $(cat $1); do ll=$(
	esearch -db assembly -query "$i" | elink -target biosample |\
	elink -target sra | efetch -format docsum |\
	grep -oP "[EDS]RR\d+|SAM\w+|PRJ\w+" | sort | uniq |\
	tr "\n" "," | sed "s/.$//" | perl parse_acc.pl);
echo -e "$i\t$ll"; done

