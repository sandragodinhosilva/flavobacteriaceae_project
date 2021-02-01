#!/usr/bin/env python3
# -*- coding: utf-8 -*-

###############################################################################
#### Goal: Work on BiG-SCAPE results                     				#######
#### Usage: python bigscape_converter.py  path/to/directory_wt_all_files/  ####
###############################################################################

import argparse
import sys
parser=argparse.ArgumentParser(
    description='''Work on BiG-SCAPE results.''',
    epilog=""" """)

__author__ = 'Sandra Godinho Silva (sandragodinhosilva@gmail.com)'
__version__ = '0.2'
__date__ = 'June 25, 2020'

parser.add_argument('inputDirectory', help='Path to the input directory where all files are')

inputDirectory = sys.argv[1]

# import standard Python modules
import os
import pandas as pd

#curdir = inputDirectory
os.chdir("/home/gomes/silva2/3_Annotation/bigscape/")
curdir = os.getcwd()
 
def GetClans(curdir):
    """
    Find folder with clans.
    """
    clans_paths=[]
    for subdir, dirs, files in os.walk(curdir):
        for file in files:
            if "clans" in file:
                clans_paths.append(os.path.join(subdir, file))
    return clans_paths #list of clan files to parse

def ConcatenateClansFiles(clans_paths):
    """
    For every BGC get info on its class, clan and family.
    """
    df_all = pd.DataFrame() #create empty dataframe
    for file_path in clans_paths:
        file_name = os.path.basename(file_path)
        file_name = file_name.split("_")[0]
        df_clan = pd.read_csv(file_path, header=None, sep='\n', skiprows=1)
        df_clan = df_clan[0].str.split('\t', expand=True)
        df_clan = df_clan.assign(Class=file_name)[['Class'] + df_clan.columns.tolist()] # add info regarding bigcape class
        df_all = pd.concat([df_all, df_clan], sort=False) #join each BGC to main dataframe
        filter = df_all.iloc[:,1].str.contains("BGC") #remove possible MIBIG entries
        df_all = df_all[~filter]
    df_all.columns = ["Class","BGC_name", "Clan", "Family"]
    return df_all #dataframe with class, clan and family for all BGCs


def GetPfamsPF(curdir):
    """
    Get the sequence/vector of Pfams per BGC and 
    get length of this vector of pfams (count Pfams).
    """
    d_pf={} #empty dictionary
    d_counts ={} #empty dictionary
    for subdir, dirs, files in os.walk(curdir):
        if "pfs" in subdir:
            file_path = os.path.join(subdir)
    for subdir, dirs, files in os.walk(file_path):
        for file in files:
            if "BGC" in file: #discard BGCs from MIBIG (they aren't from our dataset)
                pass
            else:
                with open(os.path.join(subdir,file)) as f:
                    lines = f.readlines()
                    count = len(str(lines).split(" "))
                    bgc_name = str(file).split("_")[0:2]
                    bgc_name =("_").join(bgc_name)
                    d_counts[bgc_name]= lines[0].split(" ")
                    d_pf[bgc_name]=[lines, count]
    df_pfams_pf = pd.DataFrame.from_dict(d_pf, orient='index') #transform dictionary into dataframe
    df_pfams_pf = df_pfams_pf.reset_index()
    df_pfams_pf.columns = ["BGC", "Pfam_vector", "Pfam_vector_length"]
    return df_pfams_pf, d_counts #datafrane with Pfam vector and dictionary for the count table

def GetPfamsPFD(curdir):
    """
    Open file already converted by the bigscape algorithm from domtable.
    Get the Pfam descriptors.
    """
    d_pfd={}
    for subdir, dirs, files in os.walk(curdir):
        if "pfd" in subdir:
            file_path = os.path.join(subdir)
    for subdir, dirs, files in os.walk(file_path):
        for file in files:
            if "BGC" in file: #discard BGCs from MIBIG (they aren't from our dataset)
                pass
            else:
                bgc_name = str(file).split("_")[0:2]
                bgc_name =("_").join(bgc_name)
                df_pfd = pd.read_csv(os.path.join(subdir,file), header=None, sep="\t")
                df_pfd.columns = ["Cluster name", "(per-domain) score", 
                "gene id (if present)"," envelope coordinate from", "envelope coordinate to (of the domain prediction, in amino acids)", 
                "pfam id", "pfam descriptor", "start coordinate gene", "end coordinate gene", "internal cds header"]
                l_descriptor = df_pfd["pfam descriptor"].tolist()
                l_descriptor = ';'.join(l_descriptor)
                d_pfd[bgc_name]=l_descriptor
    df_pfams_pfd = pd.DataFrame.from_dict(d_pfd, orient='index')
    df_pfams_pfd = df_pfams_pfd.reset_index()
    df_pfams_pfd.columns = ["BGC", "Pfam_descriptor"]
    return df_pfams_pfd #dataframe with Pfam descriptors

def GetNetworkAnno(curdir):
    """
    Get the annotation file for every class.
    """
    for subdir, dirs, files in os.walk(curdir):
        for file in files:
            if "Network_Annotations_Full.tsv" in file:
                file_path = os.path.join(subdir, file)
                network_anno = pd.read_csv(file_path,header=None, sep='\n')
                network_anno = network_anno[0].str.split('\t', expand=True)
                network_anno.columns = network_anno.iloc[0] #change column names
                network_anno = network_anno.iloc[1:]
                network_anno.drop(columns=["Description", "Organism", "Taxonomy"], inplace=True)
                network_anno = network_anno[~network_anno["BGC"].str.contains("BGC")]
    return network_anno #dataframe with generic information on all BGCs

def JoinAll(df_all, network_anno, df_pfams_pf, df_pfams_pfd):
    """
    Join all the information. Every BGC will have information on: class, clan, 
    family, vector of pfams, length of pfam vector and pfam descriptors.
    """
    new_df = pd.merge(df_all, network_anno, how="left", left_on="BGC_name", right_on="BGC")
    #two = new_df["BGC_name"].str.split("_", expand=True).iloc[:,0:2]
    #new_df["BGC_name"] = ("_").join(two) #simplify name to afterwards join with pfams dfs
    l1 = new_df["BGC_name"].str.split("_", expand=True).iloc[:,0:2]
    new_df["Genome"]=l1.apply(lambda two: '_'.join(two.dropna().astype(str).values), axis=1)
    new_df2 = pd.merge(new_df, df_pfams_pf, how="left", left_on="Genome", right_on="BGC")
    new_df3 = pd.merge(new_df2, df_pfams_pfd, how="left", left_on="Genome", right_on="BGC")
    new_df3.rename(columns={"BGC_x":"BGC_full"}, inplace=True)
    new_df3 = new_df3[['Genome', 'BGC_full','Class', 'BiG-SCAPE class',
                       'Product Prediction', 'Clan', 'Family',
                       'Pfam_vector', "Pfam_vector_length", "Pfam_descriptor"]]
    #new_df2=new_df2.dropna(axis=0) #uncoment to remove rows with NA
    return new_df3 #final dataframe

clans_paths = GetClans(curdir)
df_all = ConcatenateClansFiles(clans_paths)
df_pfams_pf, d_counts = GetPfamsPF(curdir)
df_pfams_pfd = GetPfamsPFD(curdir)
network_anno = GetNetworkAnno(curdir)
final_df = JoinAll(df_all, network_anno, df_pfams_pf, df_pfams_pfd)


from collections import Counter
df_counts_pfams = pd.DataFrame({k:Counter(v) for k, v in d_counts.items()}).fillna(0).astype(int)
df_counts_pfams = df_counts_pfams.T.reset_index()
df_counts_pfams = df_counts_pfams.replace(" ","")
df_counts_pfams.rename(columns={"index":"BGC_name"}, inplace=True)
df_counts_pfams.to_csv("Pfams_bgcs_counts.csv", sep=",", index=False)

final_df.to_csv("Clans_and_families.csv", index=False)