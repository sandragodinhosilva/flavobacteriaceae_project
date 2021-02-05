library(ComplexHeatmap)
library(circlize)
library(tidyverse)
library(vegan)
library("factoextra")
library(RColorBrewer)
library("FactoMineR")

fig <- function(width, heigth){
     options(repr.plot.width = width, repr.plot.height = heigth)}

dataPA <- read.csv("/home/gomes/silva2/5_Visualization/Mean_FS_byOrigin_flavo/Cazyme_PA_wt_metadata_origin_flavo_mean_Origin.csv", header=T, row.names="Origin")#, row.names="Genus")
data_matrixPA <- dataPA[ , !names(dataPA) %in% c("orfs", "index","Origin","Genus", "Family", "Genome")]
data_matrixPA <- as.matrix(data_matrixPA)
data_matrix_transposePA <- t(data_matrixPA)
data_matrix_transposePA <- as.matrix(data_matrix_transposePA)
#head(data_matrix_transpose)
#data_hellinger <- decostand(data_matrix, method="hellinger")

head(data_matrixPA)

#pdf("heatmap_cazymes.pdf",onefile = T) # width = 8, height = 8,

svg(file="filename2.svg")

#largura, altura:
fig(8, 8)
set.seed(40)

colnames(data_matrix_transposePA) <- c("Marine", "Not Marine")

library("RColorBrewer")
display.brewer.all(colorblindFriendly = TRUE)
#mycol <- colorRampPalette(brewer.pal(10, "RdYlBu"))(256)
mycol <- colorRampPalette(brewer.pal(9, "YlOrRd"))(20)

hmap <- Heatmap(as.matrix(data_matrix_transposePA),
                name = "Mean Presence per Origin",
                col = mycol,
                border=TRUE,
    rect_gp = gpar(col = "white", lwd = 0.2),
                
    heatmap_width = unit(9, "cm"), 
    heatmap_height = unit(9, "cm"),
    
    use_raster = TRUE, 
    raster_device = "png",   
    #raster_by_magick = TRUE,

    row_km = 4, row_km_repeats = 100,
    column_km = 1, column_km_repeats = 100,
                               
   # column_title = "Origin", 
    #column_title_side = "top",  
    #column_title_gp=gpar(fontsize = 8, fontface = "bold"),
    
    column_names_rot = 1,
    column_names_side="top",
    column_names_gp = gpar(fontsize = 8, fontface="bold"), 
    column_names_centered = TRUE,
                
    row_title = "CAZymes", 
    row_title_side="left",
    row_title_gp=gpar(fontsize = 8, fontface = "bold"),                  
    
    row_names_gp = gpar(fontsize = 6),
    
    show_row_names = TRUE,
    show_column_names = TRUE,
                
    cluster_rows = TRUE,
    cluster_columns = TRUE, show_column_dend = FALSE, 
    
    heatmap_legend_param = list(title_gp = gpar(fontsize = 8, fontface = "bold" ), labels_gp = gpar(fontsize = 8),
                                direction = "horizontal", legend_width = unit(3.5, "cm"), labels = c("0%", "50%", "100%"))
                               ) 

draw(hmap,  heatmap_legend_side = "bottom") # merge_legend = FALSE, heatmap_legend_side = "bottom", annotation_legend_side = "right"

dev.off()

unique(metadata[, c("Clan", "Clan_Name")])

set.seed(40)

#pdf("kegg_mean.pdf", width = 8, height = 8)

library("RColorBrewer")
mycol <- colorRampPalette(brewer.pal(3, "Reds"))(2)
#enhancer_col_fun = colorRamp2(c(0, 0.5, 1), c("white", "yellow","red"))

hmap <- Heatmap(as.matrix(data_matrix_transpose),
                name = "Orfs counts",
                col = mycol,
                border=TRUE,
                
    #use_raster = TRUE, 
    #raster_device = "png",   
                
    #width = unit(13, "cm"), 
    #height = unit(18, "cm"),
    #heatmap_width = unit(23, "cm"), 
    #heatmap_height = unit(15, "cm"),

    #row_km = 9, row_km_repeats = 100,
    column_km = 1, column_km_repeats = 100,
                               
    column_title = "Origin", column_title_side = "bottom",  
    column_title_gp=gpar(fontsize = 8, fontface = "bold"),
    column_names_rot = 1,
                
    row_title = "Pfam Clans", row_title_side="left",
    row_title_gp=gpar(fontsize = 8, fontface = "bold"),
                       
    row_names_gp = gpar(fontsize = 6),
    column_names_gp = gpar(fontsize = 8),
    show_row_names = TRUE,
    show_column_names = TRUE,
                
    cluster_rows = TRUE,
    cluster_columns = TRUE,           
               
    heatmap_legend_param = list(title_gp = gpar(fontsize = 8, fontface = "bold" ), labels_gp = gpar(fontsize = 8))
)


hmap = draw(hmap) 

#dev.off()

set.seed(40)

#pdf("kegg_mean.pdf", width = 8, height = 8)

library("RColorBrewer")
mycol <- colorRampPalette(brewer.pal(3, "Reds"))(2)
#enhancer_col_fun = colorRamp2(c(0, 0.5, 1), c("white", "yellow","red"))

hmap <- Heatmap(as.matrix(data_matrix_transposeRelA),
                name = "Orfs counts",
                col = mycol,
                border=TRUE,
                
    #use_raster = TRUE, 
    #raster_device = "png",   
                
    #width = unit(13, "cm"), 
    #height = unit(18, "cm"),
    #heatmap_width = unit(23, "cm"), 
    #heatmap_height = unit(15, "cm"),

    #row_km = 9, row_km_repeats = 100,
    column_km = 1, column_km_repeats = 100,
                               
    column_title = "Origin", column_title_side = "bottom",  
    column_title_gp=gpar(fontsize = 8, fontface = "bold"),
    column_names_rot = 1,
                
    row_title = "Pfam Clans", row_title_side="left",
    row_title_gp=gpar(fontsize = 8, fontface = "bold"),
                       
    row_names_gp = gpar(fontsize = 6),
    column_names_gp = gpar(fontsize = 8),
    show_row_names = TRUE,
    show_column_names = TRUE,
                
    cluster_rows = TRUE,
    cluster_columns = TRUE,           
               
    heatmap_legend_param = list(title_gp = gpar(fontsize = 8, fontface = "bold" ), labels_gp = gpar(fontsize = 8))
)


hmap = draw(hmap) 

#dev.off()

# PerMANOVA - partitioning the euclidean distance matrix by ORIGIN
data2 <- data
data2$Origin <- rownames(data2)
adonis(data_matrix ~ Origin, data = data2, method='eu')

# PerMANOVA - partitioning the euclidean distance matrix by ORIGIN
data2PA <- dataPA
data2PA$Origin <- rownames(data2PA)
adonis(data_matrixPA ~ Origin, data = data2PA, method='eu')

# PerMANOVA - partitioning the euclidean distance matrix by ORIGIN
data2RelA <- dataRelA
data2RelA$Origin <- rownames(data2RelA)
adonis(data_matrixRelA ~ Origin, data = data2RelA, method='eu')
