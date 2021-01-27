setwd("/home/gomes/silva/Task_Metadata/sandra/01_edirect_scripts/ncbi_fungal_assembly_id_to_srr_id/02_srr_to_sradb")

library(DBI)  #A database interface for communication between R and relational database management systems
library(RSQLite)  #Embeds the 'SQLite' database engine in R and provides an interface compliant with the 'DBI' package
library(SRAdb)    #A compilation of metadata from NCBI SRA and tools

#SRAdb allows accessing data in SRA by finding it first. 
#Also determines availability of sequence files and to download files of interest.

#experiment accessions (SRX, ERX or DRX) and run accessions (SRR, ERR or DRR)

#SRA is a continuously growing repository. So the SRAdb SQLite file is updated regularly.
#Then, the 1st step is to get the SRAdb SQLite  file from the online location. 
#download and uncompress steps are done with a single command, getSRAdbFile.

# Downloading SRAdb file if it does not exist
if (!file.exists("SRAmetadb.sqlite")) sra_dbname <- getSRAdbFile() else sra_dbname <- "SRAmetadb.sqlite"

#Then, create a connection for later queries. The standard DBI functionality as imple-
#mented in RSQLite function dbConnect makes the connection to the database.
sra_con <- dbConnect(dbDriver("SQLite"), sra_dbname)

# Import 'srr_wgs_ids.txt' as a vector
srr_list <- read.csv('srr_ids.txt', header = FALSE)
srr_list <- as.vector(srr_list[[1]])

# Map srr_list ids to the respective "run_accession" in "sra" table
#sprintf returns a character vector containing a combination of text and variable values
for (i in 1:length(srr_list)){
  sra_row <- dbGetQuery(sra_con, sprintf("select * from sra where run_accession = '%s' limit 1", srr_list[i]))

# Combine rows
if (i == 1){sra_df <- sra_row}
else {sra_df <- rbind.data.frame(sra_df, sra_row)}
}

# Removing line breaks in free text columns
# I have identified that some columns with free text inside have unexpected break lines and that was causing problems in the final file
sra_df$read_spec <- gsub("\r?\n|\r", "", sra_df$read_spec)
sra_df$sample_attribute <- gsub("\r?\n|\r", "", sra_df$sample_attribute)
sra_df$description <- gsub("\r?\n|\r", "", sra_df$description)

# Removing columns where all the values are NA
filtered_df <- sra_df[,colSums(is.na(sra_df))<nrow(sra_df)]

filtered_df <- subset(filtered_df, library_strategy == "WGS" & library_source == "GENOMIC")

# Write to a file
write.table(filtered_df, "flavo_reads_dataset.txt", sep = "\t", eol = "\n", row.names = F, col.names = T)
