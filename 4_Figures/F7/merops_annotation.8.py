__author__ = 'Sandra Godinho Silva (sandragodinhosilva@gmail.com)'
__version__ = '0.8'
__date__ = 'November 27, 2020'

# import standard Python modules
import os
import pandas as pd
import numpy as np
import re
from collections import Counter

###############################################################################
print("Starting... ")

#curdir = inputDirectory
os.chdir("/home/gomes/silva2/Merops/Merops_results")
curdir = os.getcwd()
###############################################################################
#Step 1: parse Blastp files

entries = os.listdir(curdir)
# list tblout files
tblout_files =[]
for filename in entries:
	if "_merops.txt" in filename:
		tblout_files.append(filename)

d = {}
record_genomes_used = []
	
for file in tblout_files:
	name = file.replace("_merops.txt", "")
	record_genomes_used.append(name)
	out = name + "_merops_out.txt"
	#out2 = name + "_virulence_out2.txt"
	if out2 not in entries:
		protein2hit_dict = {}
		protein2bit_dict = {}
		with open(curdir + "/" + file, 'r') as f:
			lines = f.readlines()
			for line in lines:
				line = line.rstrip() # This removes the whitespace at the end of the line
				if line.startswith("#"): # We only want to analyze lines with HMMER matches, so we can pass on all the lines that start with a #
					pass
				else:
					newline = re.sub("\s+", "\t", line) # Now we can replace the whitespace in the lines with tabs, which are easier to work with. 
					tabs = newline.split("\t") # And now we can create a list by splitting each line into pieces based on where the tabs are. 
					hit = tabs[1]             
					query = tabs[0] # The first item in the line is the query protein. We can assign the variable "query" to it. 
					bit_score = tabs[11] # The fifth item is the bit score. We can assign the variable "bit_score" to it. 
					if float(bit_score) < 50:
						pass
					else:
						if query in protein2bit_dict: # If query is in prtein2bit_dict, it means we have seen this protein before, so now we want to see what bit score it had to the previous hit. 
							if protein2bit_dict[query] > float(bit_score):
								pass
							else: 
								protein2bit_dict[query] = float(bit_score)
								protein2hit_dict[query] = hit
						else:
							protein2bit_dict[query] = float(bit_score)
							protein2hit_dict[query] = hit
				with open(out, "w") as outputfile: 
					outputfile.write("Query\tHit\tScore\n")
					for proteins in protein2hit_dict:
						outputfile.write(proteins + "\t" + protein2hit_dict[proteins] + "\t" + str(protein2bit_dict[proteins]) +"\n")
				outputfile.close()
				l = []
				for proteins in protein2hit_dict:
					l.append(protein2hit_dict[proteins])
					d[name] = l
		print("File " + str(out) + " was created.")
		f.close()
	else:
	   pass
###############################################################################
entries = list()
for (dirpath, dirnames, filenames) in os.walk(curdir):
	entries += [os.path.join(dirpath, file) for file in filenames]


 # for count table
d_files={}
for filename in entries:
	if filename.endswith("_merops_out.txt"):
		name = os.path.basename(filename)
		name = name.replace("_merops_out.txt","")
		d_files[name] = []
		d_files[name].append(filename)

d_track = {}
for k, files in d_files.items():
	print(k)
	print(files)
	d_track[k]=[]
	for file in files:
		d_count=[]
		with open(file) as f:
			c=0
			c_ko =0
			lines = f.readlines()
		for line in lines[1:]:
			c+=1
			line = line.rstrip() # This removes the whitespace at the end of the line
			tabs = line.split("\t") # And now we can create a list by splitting each line into pieces based on where the tabs are.         
			query = tabs[0]
			d_count.append(tabs[1])
		d_track[k]=d_count



df_types = pd.DataFrame({k:Counter(v) for k, v in d_track.items()}).fillna(0).astype(int)

df_types.to_csv("/home/gomes/silva2/Merops/merops_counts.csv")

###############################################################################
#sed -n '/>/p' merops_scan.txt > merops_scan2.txt
with open('/home/gomes/silva2/Merops/merops_scan2.txt', 'r') as file:
    # read a list of lines into data
    data = file.readlines()
    d=[]
    for line in data:
        new_line=[]
        newline = line.rstrip() # This removes the whitespace at the end of the line
        tabs = line.split(" - ") 
        code = tabs[0].replace(">","")
        print(code)
        part2 = tabs[1].split(" (") 
        name = part2[0]
        print(name)
        part3 = part2[1].split(") ")
        organism= part3[0].replace("{","").replace("}","").replace(")","")
        print(organism)
        part4= "".join(part3[1:])
        rest = part4.split("~")[0]
        try:
            source = part4.split("~")[1].replace("source ","")
        except:
            source = np.nan
        print(source)

        new_line.append(code)
        new_line.append(name)
        new_line.append(organism)        
        new_line.append(rest)
        new_line.append(source)
        d.append(new_line)

        
df = pd.DataFrame.from_dict(d)
df.columns=["ID","name","organism","desc","source"]
df.to_csv('/home/gomes/silva2/Merops/merops_ids.csv', index=False)
