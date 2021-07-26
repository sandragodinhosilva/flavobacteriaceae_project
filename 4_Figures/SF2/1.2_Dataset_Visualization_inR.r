#setwd("/home/gomes/silva2/")

library(ggplot2)
library(grid)
library(gridExtra)
library(plyr)
library(dplyr)
library(ggpubr)

fig <- function(width, heigth){
     options(repr.plot.width = width, repr.plot.height = heigth)}

data <- read.csv("../../1_Dataset_creation/Dataset.csv", header=T, row.names="Genome_ID")

data <- as.data.frame(lapply(data, unlist))
data <- data %>% arrange(Quality_score)
data$Classification_f = factor(data$Classification_quality, levels=c("High","Medium","Low"))
head(data,2)

data$Classification_f <- factor(data$Classification_f, labels = c("High quality: 1957 genomes","Medium quality: 409 genomes","Low quality: 314 genomes"))

svg("Try.svg",width=5,height=4.2)
fig(4, 4)

g <- ggplot(data, aes(x=Completeness, y=scaf_N50,  
                       fill=Strain_heterogeneity, colour=Classification_quality, size=Contamination))+
  geom_point(shape=21) +
  guides(color=FALSE) + #remove legend for Classification
  scale_color_discrete(breaks=c("High","Medium","Low"), aes(fillcolour="black")) +
  scale_size_continuous(range=c(1,6)) +
  labs(y="Scaffold N50 length", x="Completeness (%)",
       subtitle = "Total: 2680 genomes",
       fill = "Strain \nheterogeneity (%) \n", size="Contamination (%)")+
  facet_wrap(Classification_f~., nrow=3, scales="free_y")+#, labeller=label_parsed) +     
  
  theme(panel.background = element_rect(fill = "#eaeaf2", colour = "#eaeaf2",
                                size = 2, linetype = "solid"),   
        plot.title = element_text(size = 11),
        plot.subtitle= element_text(size=8, hjust = 0.5, margin=unit(c(1,0,1.5,0),"mm")),
        legend.title = element_text(size=8),
        axis.title = element_text(size=8, colour="black"),
        axis.text.x = element_text(size=6, colour = "black"),
        axis.text.y = element_text(size=6, colour = "black", margin = margin(0, 0, 0, 0.2, "cm")),
        legend.text = element_text(size=6),
        strip.text.x = element_text(size= 7, color = "black",  hjust=0.5, margin = margin(0.05, 0.15, .05, 0, "cm")), #change title of facet
        strip.background = element_rect(size=0.5, linetype="solid") #color="black", fill="#FC4E07"
           ) +    
    scale_y_continuous(expand = expansion(mult = c(0.15, 0.15))) 

print(g)

ggsave("try", device="svg", dpi=300)

dev.off()

dev.off()

data <- read.csv("All_info.csv", header=T, row.names="Assembly.accession")
data_df <- as.data.frame(lapply(data, unlist))
head(data,2)




#at least 5 genomes with location:
geo <- read.csv("Geographic_location.csv",row.names="Assembly.accession") 
geo <- as.data.frame(lapply(geo, unlist))
fd.geo <- data.frame(table(geo$Geographic.location..country.or.region.))
df <-fd.geo[order(-fd.geo$Freq),]
df$Var1<-factor(df$Var1, levels=df$Var1[order(df$Freq, decreasing=TRUE)])

fig(6.7, 2.5)
ggplot(data=df, aes(x=Var1, y=Freq)) +
  geom_bar(stat="identity", fill=geo["MAG"]) + #fill ="#306692"
  labs(y="Count", x="",
       title= "Geographic location") +
  theme(plot.title = element_text(size = 11),
        axis.text.x = element_text(size=6, angle = 45, hjust=1, color="black"),
        axis.text.y = element_text(size=6, colour = "black", margin = margin(0, 0, 0, 0.2, "cm")),
        axis.title = element_text(size=8, colour="black"),    
       )
#ggsave("Geographic_location", device="png")


host <- read.csv("Host.csv",row.names="Assembly.accession") 
df <- as.data.frame(lapply(host, unlist))

fd.host <- data.frame(table(df$Host.resumed))
df <-fd.host[order(-fd.host$Freq),]
df$Var1<-factor(df$Var1, levels=df$Var1[order(df$Freq, decreasing=TRUE)])

fig(4, 2.5)
ggplot(data=df, aes(x=Var1, y=Freq)) +
  geom_bar(stat="identity", fill ="#306692") +
  labs(y="Count", x="",
       title= "Host") +
  theme(plot.title = element_text(size = 11),
        axis.text.x = element_text(size=6, angle = 45, hjust=1, color="black"),
        axis.text.y = element_text(size=6, colour = "black", margin = margin(0, 0, 0, 0.2, "cm")),
        axis.title = element_text(size=8, colour="black"),    
       )

host <- read.csv("Seq.csv",row.names="Assembly.accession") 
df <- as.data.frame(lapply(host, unlist))

fd.host <- data.frame(table(df$Sequencing.platform.resumed))
df <-fd.host[order(-fd.host$Freq),]
df$Var1<-factor(df$Var1, levels=df$Var1[order(df$Freq, decreasing=TRUE)])

fig(2.5, 2.7)
ggplot(data=df, aes(x=Var1, y=Freq)) +
  geom_bar(stat="identity", fill ="#306692") +
  labs(y="Count", x="",
       title= "Sequencing platform") +
  theme(plot.title = element_text(size = 11),
        axis.text.x = element_text(size=6, angle = 45, hjust=1, color="black"),
        axis.text.y = element_text(size=6, colour = "black", margin = margin(0, 0, 0, 0.2, "cm")),
        axis.title = element_text(size=8, colour="black"),    
       )

# 2680 genomes
df <- data.frame(
  group = c("Flavobacteriaceae", "Weeksellaceae"),
  value = c(1923, 757))
#head(df)

#largura, altura:
fig(2, 2.5)
bp <- ggplot(df, aes(x="", y=value, fill=group, width=1)) +
            geom_bar(width = 1, stat = "identity") + 
            coord_polar("y", start=0) +
        
        labs(y="", x="", fill="Family",
           title= "Taxonomical distribution") +

        #guides(fill=guide_legend(override.aes=list(colour=NA))) +

        theme_classic() +
        theme(plot.title = element_text(size = 11, hjust=0.5,margin=unit(c(0,0,0,0), "mm")), #c(t, r, b, l),
              legend.position="bottom",
              legend.title = element_text(size=8),
              legend.text = element_text(size=7),
              legend.margin=margin(-35,0,0,0),
              #legend.box.margin=margin(-10,-10,-10,-10),
              
              axis.line = element_blank(),
              axis.text = element_blank(),
              axis.ticks = element_blank()
             ) +

        geom_text(aes(label = paste0(round(value))), position = position_stack(vjust = 0.5), color = "white", size=4) +

        scale_fill_manual(values=c("#33658A", "#E67E22")) #+
   
bp      + guides(fill=guide_legend(nrow=2,byrow=TRUE))
