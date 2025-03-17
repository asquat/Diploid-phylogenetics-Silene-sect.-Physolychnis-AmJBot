# Anne-Sophie Quatela
# 25th April 2023

# Figure representating normalized pairwise genetic distances to detect allopolyploid samples.

setwd("") #set your working directory

list.files()

# Import dataset with pairwise genetic distances for each locus of each sample.
fulldt1 <- read.csv2("FIGURE3_normalised_pairwise_dist.csv", header = TRUE)
summary(fulldt1)
str(fulldt1)
# Remove sample URUR29, VIOL4, URUR25, URAL16, URAR10, SOCZ8. This is specific to my dataset and should not be applied to any dataset blindly.
fulldt <- fulldt1[ , !(names(fulldt1) %in% c("URUR29", "VIOL4", "URUR25", "URAL16", "URAR10", "SOCZ8"))]


# http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html
library(ggplot2)
library(reshape2)
library(ggrepel)

# Rearrange the dataset 
dtm <- melt(fulldt)
colnames(dtm) <- c('gene', 'sample', 'norm_pd') # Change columns names
as.character(dtm$sample)
dtm[which(dtm$sample=="WAHL2"),]
dtm[which(dtm$sample=="URUR29"),]


###############################
### Import dataset of the AVERAGE pairwise genetic distances per sample.
library(dplyr)
avdt <- read.csv2("FIGURE3_average_normalised_pairwise_dist.csv", sep= ",", header = FALSE)
df1 = data.frame(matrix(nrow = 79, ncol = 2))
colnames(df1) <- c('sample','average_norm_od')
df1$sample <- as.list(avdt[1,])
df1$average_norm_od <- as.list(avdt[2,])
str(df1)
df1$average_norm_od <- as.numeric(df1$average_norm_od)
df1$sample <- as.character(df1$sample)
#Remove row with URUR29
df1[which(df1$sample=='URUR29'),]
df <- df1 %>% filter(!row_number() %in% c(46))
df[which(df$sample=='URUR29'),]


# library(ggExtra)
# library(tidyverse)

### Define custom color scale
# 1. Define two groups in the dataframe: polyploid and diploid.
dtm$group <- "diploid"
dtm[which(dtm$sample=="SOCZ9"),4] <- "polyploid" #P24451_1045
dtm[which(dtm$sample=="INTE2"),4] <- "polyploid" #P24451_1044
dtm[which(dtm$sample=="INFU3"),4] <- "polyploid" #P24451_1040
dtm[which(dtm$sample=="URAL3"),4] <- "diploid"
dtm[which(dtm$sample=="INTE1"),4] <- "polyploid" #P24451_1031
dtm[which(dtm$sample=="ININ"),4] <- "polyploid" #P24451_1025
dtm[which(dtm$sample=="SOCZ7"),4] <- "polyploid" #P24451_1024
dtm[which(dtm$sample=="INFU4"),4] <- "polyploid" #P24451_1022
dtm[which(dtm$sample=="URAR1"),4] <- "diploid"
dtm[which(dtm$sample=="SOCZ6"),4] <- "polyploid" #P24451_1014
dtm[which(dtm$sample=="URAL5"),4] <- "diploid"
dtm[which(dtm$sample=="SOCZ5"),4] <- "polyploid" #P18903_1091
dtm[which(dtm$sample=="SOCZ4"),4] <- "polyploid" #P18903_1082
dtm[which(dtm$sample=="INFU2"),4] <- "polyploid" #P18903_1080
dtm[which(dtm$sample=="SOCZ3"),4] <- "polyploid" #P18903_1076
dtm[which(dtm$sample=="SOCZ2"),4] <- "polyploid" #P18903_1075
dtm[which(dtm$sample=="SOCZ1"),4] <- "polyploid" #P18903_1065
dtm[which(dtm$sample=="INFU1"),4] <- "polyploid" #P18903_1050
dtm[which(dtm$sample=="URAL1"),4] <- "diploid"

# 2. Color by group.
dtm$sample <- as.character(dtm$sample)

### Add species names to the acronyms.
library(ggtext)
library(glue)
dtm2 <- dtm %>%
  mutate(Sp = case_when(
    startsWith(as.character(sample), "VIOL") ~ "<i>S. violascens</i>",
    startsWith(as.character(sample), "SOCZ") ~ "<i>S. soczavana</i>",
    startsWith(as.character(sample), "URAL") ~ "<i>S. uralensis</i>",
    startsWith(as.character(sample), "URUR") ~ "<i>S. uralensis</i> subsp. <i>uralensis</i>",
    startsWith(as.character(sample), "URAR") ~ "<i>S. uralensis</i> subsp. <i>arctica</i>",
    startsWith(as.character(sample), "WA") ~ "<i>S. wahlbergella</i>",
    startsWith(as.character(sample), "ININ") ~ "<i>S. involucrata subsp. involucrata</i>",
    startsWith(as.character(sample), "INFU") ~ "<i>S. involucrata subsp. furcata</i>",
    startsWith(as.character(sample), "INTE") ~ "<i>S. involucrata subsp. tenella</i>"),
    name = glue("{Sp} {sample}")
  )

# Make a basic plot pf the pairwise genetic distance
plotbasic <- ggplot(dtm2, aes(x=norm_pd, y=name, col=group)) + #reorder(sample,norm_pd)
  geom_point(stat='identity', size=1.6) + #, aes(col=mpg_type), size=6)  +
  geom_vline(xintercept=0.5,lwd=0.9,colour="black") + #"#00AFBB" "#FC4E07"
  xlab("Normalized pairwise-distance between haplotypes (%)") +
  ylab("Samples") +
  theme(
    axis.text.y=element_markdown(size = 8, face = 'bold'), #axis.text.y=element_text(size = 8, face = 'bold'),
    axis.text.x=element_text(size=11, face = 'bold'),
    axis.title = element_text(size=12, face = 'bold')
  )
plotbasic

### Add mean genetic distance to the graph in the shape of a black triangle:
# https://stackoverflow.com/questions/52217852/how-to-add-means-to-a-ggplot-geom-point-plot
plot1AVERAGE <- plotbasic + stat_summary(
  geom = "point",
  fun = "mean",
  col = "black", # "#FC4E07"
  size = 3,
  shape = 24,
  fill = "black" # "#FC4E07"
)
plot1AVERAGEcol <- plot1AVERAGE +
  theme(
    legend.text = element_text(size = 13),
    #legend.title = element_text(size = 13)
    legend.title=element_blank()
  ) +
  scale_color_discrete(labels = c("putative diploid", "putative polyploid") )
plot1AVERAGEcol


###############################
### Create graph about the RECOVERY.
cov <- read.csv2("FIGURE3_recovery_avg.csv", header = FALSE)
str(cov)

# Some data rearrangement
dfcov = data.frame(matrix(nrow = 79, ncol = 2))
colnames(dfcov) <- c('sample','recovery')
dfcov$sample <- as.list(cov[1,])
dfcov$recovery <- as.list(as.numeric(cov[2,]))
str(dfcov)
# Remove sample URUR29
dfcov[which(dfcov$sample=='URUR29'),]
dfcov <- dfcov %>% filter(!row_number() %in% c(46))
#Remove sample VIOL4
dfcov[which(dfcov$sample=='VIOL4'),] #row 68
dfcov <- dfcov %>% filter(!row_number() %in% c(68))
#Remove sample "URUR25"
dfcov[which(dfcov$sample=='URUR25'),] #row 68
dfcov <- dfcov %>% filter(!row_number() %in% c(68))
#Remove sample "URAL16"
dfcov[which(dfcov$sample=='URAL16'),] #row 55
dfcov <- dfcov %>% filter(!row_number() %in% c(55))

### As previously, define two groups in the dataframe: polyploid and diploid.
dfcov$group <- "diploid"
dfcov[which(dfcov$sample=="SOCZ9"),3] <- "polyploid" #P24451_1045
dfcov[which(dfcov$sample=="INTE2"),3] <- "polyploid" #P24451_1044
dfcov[which(dfcov$sample=="INFU3"),3] <- "polyploid" #P24451_1040
dfcov[which(dfcov$sample=="URAL3"),3] <- "diploid"
dfcov[which(dfcov$sample=="INTE1"),3] <- "polyploid" #P24451_1031
dfcov[which(dfcov$sample=="ININ"),3] <- "polyploid" #P24451_1025
dfcov[which(dfcov$sample=="SOCZ7"),3] <- "polyploid" #P24451_1024
dfcov[which(dfcov$sample=="INFU4"),3] <- "polyploid" #P24451_1022
dfcov[which(dfcov$sample=="URAR1"),3] <- "diploid"
dfcov[which(dfcov$sample=="SOCZ6"),3] <- "polyploid" #P24451_1014
dfcov[which(dfcov$sample=="URAL5"),3] <- "diploid"
dfcov[which(dfcov$sample=="SOCZ5"),3] <- "polyploid" #P18903_1091
dfcov[which(dfcov$sample=="SOCZ4"),3] <- "polyploid" #P18903_1082
dfcov[which(dfcov$sample=="INFU2"),3] <- "polyploid" #P18903_1080
dfcov[which(dfcov$sample=="SOCZ3"),3] <- "polyploid" #P18903_1076
dfcov[which(dfcov$sample=="SOCZ2"),3] <- "polyploid" #P18903_1075
dfcov[which(dfcov$sample=="SOCZ1"),3] <- "polyploid" #P18903_1065
dfcov[which(dfcov$sample=="INFU1"),3] <- "polyploid" #P18903_1050
dfcov[which(dfcov$sample=="URAL1"),3] <- "diploid"

### As previously, add species names to the acronyms
dfcov2 <- dfcov %>%
  mutate(Sp = case_when(
    startsWith(as.character(sample), "VIOL") ~ "<i>S. violascens</i>",
    startsWith(as.character(sample), "SOCZ") ~ "<i>S. soczavana</i>",
    startsWith(as.character(sample), "URAL") ~ "<i>S. uralensis</i>",
    startsWith(as.character(sample), "URUR") ~ "<i>S. uralensis</i> subsp. <i>uralensis</i>",
    startsWith(as.character(sample), "URAR") ~ "<i>S. uralensis</i> subsp. <i>arctica</i>",
    startsWith(as.character(sample), "WA") ~ "<i>S. wahlbergella</i>",
    startsWith(as.character(sample), "ININ") ~ "<i>S. involucrata subsp. involucrata</i>",
    startsWith(as.character(sample), "INFU") ~ "<i>S. involucrata subsp. furcata</i>",
    startsWith(as.character(sample), "INTE") ~ "<i>S. involucrata subsp. tenella</i>"),
    name = glue("{Sp} {sample}")
  )

### Plot the graph of the RECOVERY.
plotcov2 <- ggplot(data=dfcov2, aes(x=as.character(name), y=as.numeric(recovery), fill=group)) + #, col=group
  geom_bar(width=.5, stat="identity", aes(col=group)) +
  geom_hline(yintercept=50.0,lwd=0.8,colour="black", linetype="dotted")
plotcov2
plotcovbis2 <- plotcov2 + coord_flip()# vertical bar plot
plotcovbis2
plot42 <- plotcovbis2 +
  ylab("Recovery per sample (%)") +
  theme(
    axis.title.y = element_blank(),
    #axis.text.y=element_text(size = 8, face = 'bold'),
    #axis.text.y=element_markdown(size = 8, face = 'bold'),
    axis.text.y=element_blank(),
    #axis.ticks.y=element_blank(),  #remove y axis ticks
    axis.text.x=element_text(size = 11, face = 'bold'),
    axis.title.x = element_text(size=12, face = 'bold')
    )
plot42
plot42_nolegend <- plot42 + theme(legend.position = "none")
plot42_nolegend
str(plot42_nolegend)


###############################
### Merge the two plots in one to create the final figure.
library("gridExtra")
library(ggpubr)
summary3 = ggarrange(plot1AVERAGEcol, plot42_nolegend, ncol=2, nrow=1, common.legend = TRUE, legend="bottom", widths = c(1, 0.3))
summary3
# ggsave(filename = '75samples_FINALFIGURE.jpeg', plot = summary3, device = "jpeg", dpi = 1500, width=14.19, height=12.00)



