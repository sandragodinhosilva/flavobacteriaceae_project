library(ComplexHeatmap)
library(circlize)
library(tidyverse)
library(vegan)
library("factoextra")
library(RColorBrewer)
library("FactoMineR")

fig <- function(width, heigth){
     options(repr.plot.width = width, repr.plot.height = heigth)}

data <- read.csv("Cazyme_counts_PA_mean_family_genus.csv", header=T, row.names="Genus")
data_matrix <- data[ , !names(data) %in% c("orfs", "index","Origin","Genus", "Family")]
data_matrix <- as.matrix(data_matrix)
data_matrix_transpose <- t(data_matrix)
data_matrix_transpose <- as.matrix(data_matrix_transpose)
#head(data_matrix_transpose)
data_hellinger <- decostand(data_matrix, method="hellinger")

head(data_matrix)

#largura, altura:
fig(8, 8)
set.seed(40)
svg(file="cazymes_per_genus.svg")
#pdf(file = "Cazymes_PA_clan_mean_family_genus.pdf",  width = 10, height = 8, onefile=FALSE)


library("RColorBrewer")
mycol <- colorRampPalette(brewer.pal(9, "YlOrRd"))(20)

metadata <- data.frame(data$Family)
colnames(metadata) <- c('Family')
colours <- list('Family' = c('Flavobacteriaceae' = '#3274a1','Weeksellaceae' = '#e1812c'))


row_ha = HeatmapAnnotation(df = metadata, 
                           col=colours, 
                           show_legend = TRUE,
                           which = 'col',
                           simple_anno_size = unit(0.3, "cm"),
                           annotation_name_gp = gpar(fontsize = 6),
                           annotation_legend_param = list(title_gp = gpar(fontsize = 8,  fontface = "bold"), 
                                                          labels_gp = gpar(fontsize = 8)))


hmap <- Heatmap(as.matrix(data_matrix_transpose),
                name = "Mean Presence per Genus",
                col = mycol,
                border=TRUE,
    
    use_raster = TRUE, 
    raster_device = "png",   
                
    #width = unit(15, "cm"), 
    #height = unit(22, "cm"),
    #heatmap_width = unit(17, "cm"), 
    heatmap_height = unit(17, "cm"),

    row_km = 7, row_km_repeats = 100,
    column_km = 6, column_km_repeats = 100,
                               
    column_title = "Genus", column_title_side = "bottom",  
    column_title_gp=gpar(fontsize = 8, fontface = "bold"),
    
    row_title = "Clans", row_title_side="right",
    row_title_gp=gpar(fontsize = 8, fontface = "bold"),
                       
    row_names_gp = gpar(fontsize = 7),
    column_names_gp = gpar(fontsize = 6),
    
    show_row_names = TRUE,
    show_column_names = TRUE,
    
    #column_names_rot = 45,
    
    cluster_rows = TRUE,
    cluster_columns = TRUE,           
               
    top_annotation=row_ha,  

    heatmap_legend_param = list(title_gp = gpar(fontsize = 8, fontface = "bold" ), labels_gp = gpar(fontsize = 8),
                                direction = "horizontal", legend_width = unit(3.2, "cm"), labels = c("0%", "50%", "100%"))
)

#png(file="ht_list.png")

#map= 
draw(hmap, merge_legend = TRUE)#bottom", annotation_legend_side = "bottom")
dev.off()


dev.off()

data$Genus <- rownames(data)

head(data)

set_plot_dimensions <- function(width_choice, height_choice) {
        options(repr.plot.width=width_choice, repr.plot.height=height_choice)
        }

get_plot <- function(data_FS, data_matrix_FS, files) {
    set_plot_dimensions(8, 7)
    data_matrix_FS.pr <- prcomp(as.matrix(data_matrix_FS), center = TRUE) #scale = TRUE

    n <- 40
    qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
    col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
    #pie(rep(1,n), col=sample(col_vector, n))

    fviz_pca_ind(data_matrix_FS.pr, geom.ind = c("point","text"), 
                 pointshape = 21, pointsize = 2, 
                 label = "ind", labelsize = 3,
                 fill.ind = data_FS$Genus, col.ind = "black", 
                 palette = col_vector, #"jco", 
                 #addEllipses = TRUE, # two few points - we're using means
                 col.var = "black",
                 repel = TRUE, # Avoid text overlapping (like Jitter - deprecated)
                 legend.title = "Genus") +
      
    ggtitle("PCA") +
    theme(plot.title = element_text(hjust = 0.5), legend.position="bottom")                  
}

get_plot_Family <- function(data_FS, data_matrix_FS, files) {
    set_plot_dimensions(4, 3)
    data_matrix_FS.pr <- prcomp(as.matrix(data_matrix_FS), center = TRUE) #scale = TRUE

    n <- 40
    qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
    col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
    #pie(rep(1,n), col=sample(col_vector, n))

    fviz_pca_ind(data_matrix_FS.pr, geom.ind = c("point"), 
                 pointshape = 21, pointsize = 2, 
                 fill.ind = data_FS$Family, col.ind = "black", 
                 palette = col_vector, #"jco", 
                 #addEllipses = TRUE, # two few points - we're using means
                 col.var = "black",
                 repel = TRUE, # Avoid text overlapping (like Jitter - deprecated)
                 legend.title = "Family") +
    
    ggtitle("PCA") +
    theme(plot.title = element_text(hjust = 0.5), legend.position="bottom")                  
}

get_plots_Metrics <- function(data_matrix_FS, x) {
    set_plot_dimensions(4, 2)

    #Principal component analysis
    library("FactoMineR")
    res.pca <- PCA(data_matrix_FS,  graph = FALSE)

    # Visualize eigenvalues/variances
    c <- fviz_screeplot(res.pca, addlabels = TRUE, ylim = c(0, 50)) +
    ggtitle("eigenvalues/variances") +
      theme(plot.title = element_text(hjust = 0.5))

    # Contributions of variables to PC1
    d <- fviz_contrib(res.pca, choice = "var", axes = 1, top = 10)
    # Contributions of variables to PC2
    e <- fviz_contrib(res.pca, choice = "var", axes = 2, top = 10)
    
    plot(c)
    plot(d)
    plot(e)
}

get_plot(data, data_matrix, x) 

get_plot_Family(data, data_matrix, x) 

# PerMANOVA - partitioning the euclidean distance matrix by FAMILY
adonis(data_matrix ~ Family, data = data, method='eu')

#PerMANOVA - partitioning the euclidean distance matrix by GENUS
adonis(data_matrix ~ Genus, data = data, method='eu')

#PerMANOVA - partitioning the euclidean distance matrix by ORIGIN
#adonis(data_matrix ~ Origin, data = data, method='eu')

# PerMANOVA - partitioning the euclidean distance matrix by...
# with hellinger transformed data
adonis(data_hellinger  ~ Genus, data = data, method='eu')
adonis(data_hellinger ~ Genus, data = data, method='eu')
#adonis(data_hellinger ~ Origin, data = data, method='eu')

set.seed(123)
nmds = metaMDS(data_matrix, distance = "bray")
nmds

set_plot_dimensions(5, 4)
stressplot(nmds)

data.scores = as.data.frame(scores(nmds))
data.scores$Genus = data$Genus
data.scores$Family = data$Family
data.scores$Origin = data$Origin

set_plot_dimensions(10, 7)

n <- 50
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
#pie(rep(1,n), col=sample(col_vector, n))

library(ggplot2)

xx = ggplot(data.scores, aes(x = NMDS1, y = NMDS2)) + 
    geom_point(size = 4, aes( shape = Family, colour = Genus))+ 
    theme(axis.text.y = element_text(colour = "black", size = 8), 
    axis.text.x = element_text(colour = "black",  size = 8), 
    legend.text = element_text(size = 7, colour ="black"), 
    legend.position = "right", axis.title.y = element_text(face = "bold", size = 8), 
    axis.title.x = element_text(face = "bold", size = 8, colour = "black"), 
    legend.title = element_text(size = 8, colour = "black", face = "bold"), 
    panel.background = element_blank(), panel.border = element_rect(colour = "black", fill = NA, size = 1.2),
    legend.key=element_blank()) + 
    labs(x = "NMDS1", colour = "Genus", y = "NMDS2", shape = "Family")  + 
    scale_colour_manual(values = col_vector) +
    ggtitle("NMDS FS counts") +
      theme(legend.position="bottom")
 
xx
    
#ggsave("NMDS.svg")
