library(ComplexHeatmap)
library(circlize)
library("tidyverse")
library(vegan)
library("factoextra")
library(RColorBrewer)
library("FactoMineR")

fig <- function(width, heigth){
     options(repr.plot.width = width, repr.plot.height = heigth)}

dataPA <- read.csv("merops_PA_metadata_mean_Origin.csv", header=T, row.names="Origin")#, row.names="Genus")

data_matrixPA <- dataPA[ , !names(dataPA) %in% c("orfs", "index","Origin","Genus", "Family", "Genome")]
data_matrixPA <- as.matrix(data_matrixPA)
data_matrix_transposePA <- t(data_matrixPA)
data_matrix_transposePA <- as.matrix(data_matrix_transposePA)


data_matrix_transposePA[data_matrix_transposePA == 0] <- NA

data_matrix_transposePA <- log10(data_matrix_transposePA)

data_matrix_transposePA[is.na(data_matrix_transposePA)] <- -3




svg(file="merops_PA_metadata_mean_Origin.svg")

#largura, altura:
fig(8, 8)
set.seed(40)

colnames(data_matrix_transposePA) <- c("Marine", "Not Marine")

library("RColorBrewer")
display.brewer.all(colorblindFriendly = TRUE)
#mycol <- colorRampPalette(brewer.pal(10, "RdYlBu"))(256)
#mycol <- colorRampPalette(brewer.pal(3, "Reds"))(2)
mycol <- colorRampPalette(brewer.pal(9, "YlOrRd"))(256)



library(viridis)

#mycol <- rev(colorRampPalette(brewer.pal(9, "RdBu"))(20))

hmap <- Heatmap(as.matrix(data_matrix_transposePA),
                name = "Frequency of occurrence",
                #col=viridis(100,direction = 1),
                col = mycol,
                border=TRUE,
    rect_gp = gpar(col = "white", lwd = 0.2),
                
    heatmap_width = unit(6, "cm"), 
    heatmap_height = unit(9, "cm"),
    
    #use_raster = TRUE, 
    #raster_device = "png",   
    #raster_by_magick = TRUE,

    row_km = 8, row_km_repeats = 100,
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
                               direction = "horizontal", legend_width = unit(3.5, "cm")))#, labels = c("0%","",""  ,"100%")) #"50%
                                

draw(hmap,  heatmap_legend_side = "bottom") # merge_legend = FALSE, heatmap_legend_side = "bottom", annotation_legend_side = "right"

dev.off()