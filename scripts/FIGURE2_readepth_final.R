# Anne-Sophie Quatela
# March 2025

getwd() 
setwd("") #Set your working directory

##################### How to make a heatmap showing the read depth per locus for each sample? ###################
library(dplyr)
library(ggplot2)
library(reshape)
# the dataset (.csv file) should be located in the same folder where your R code (.R file) is located. 

###### Explore the dataset you are going to use.
list.files()
readepth_per_locus <- read.delim("FIGURE2_readdepth.csv", sep = ";")
head(readepth_per_locus)
summary(readepth_per_locus)
# I removed a few samples that were misindentified. This is specific to my dataset and should not be blindly applied to another dataset.
which(colnames(readepth_per_locus)=="URAR10") #column 65
which(colnames(readepth_per_locus)=="SOCZ8") #column 76
which(colnames(readepth_per_locus)=="VIOL4") #column 70
which(colnames(readepth_per_locus)=="URUR25") #column 71
which(colnames(readepth_per_locus)=="URAL16") #column 56

# Remove columns above (columns 65, 76, 70, 71, 56)
readepth_per_locus_V2 <- readepth_per_locus[,-c(56,65,70,71,76)]

# Change the format of the dataframe using melt function from the reshape package. This step is crucial!
dt2<-melt(readepth_per_locus_V2)
head(dt2)


###### Create basic heatmap 
plot1<-ggplot(dt2, aes(x=Locus, y=variable, fill= value)) + 
  geom_tile()
plot1

# Create heatmap with 7 levels of read depth
data2 <- dt2 %>%
  # convert state to factor and reverse order of levels
  mutate(Sample=factor(variable,levels=rev(sort(unique(variable))))) %>%
  mutate(countfactor=cut(value,breaks=c(0,0.1,1,4,7,17,31,max(value,na.rm=T)),
                         labels=c("0","0.1-0.99","1-3.99","4-7","7.1-17","17.1-31",">31"))) %>%
  # Change level order
  mutate(countfactor=factor(as.character(countfactor),levels=rev(levels(countfactor))))
#Find row numbers  for which countfactor = NA.
rowsNA <- which(is.na(data2$countfactor)==TRUE)
# Replace NA in column countfactor with 0
data2[rowsNA,5] <- '0'
# Replace locus name only keeping the number
data2$Locus <- gsub('gene-','', data2$Locus) 
data2$Locus <- gsub('-consensus','', data2$Locus)

# Plot the new data
plot2<-ggplot(data2, aes(x=Locus, y=Sample, fill= countfactor)) + 
  geom_tile()
plot2

# Change the content of data$locus: cut "loc":
# indicate until which letter you want to cut (not included):
data3 <- data2
#data3$locus <- substring(data2$locus, 4)
is.character(data3$Locus) #TRUE
colnames(data3)[5] <- "Readdepth"


###### There are several aspects of the basic plot that can be modified. 
# We add tile borders, custom x-axis breaks and custom text sizes. 
library(gridtext)
library(ggtext)
library(RColorBrewer)

plot3 <- ggplot(data3, aes(x=Locus, y=Sample, fill= Readdepth))+
  #add border white colour of line thickness 0.25
  geom_tile(colour="white",size=0.25)+
  #remove extra space
  scale_y_discrete(expand=c(0,0))+
  theme(
    axis.text.y=element_text(size = 8, face = 'bold'),
    axis.text.x=element_text(size=12, face = 'bold'),
    axis.title = element_text(size=13.5, face = 'bold')
  ) +
  theme(
    legend.title=element_text(face="bold"),
    #bold font for legend text
    legend.text=element_text(face="bold"),
    #set thickness of axis ticks
    axis.ticks=element_line(linewidth=0.4), 
    #orient x axis text
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
    #remove plot background
    plot.background=element_blank(),
    #remove plot border
    panel.border=element_blank()) +
  labs(fill="Read depth") + # Change legend title
  scale_fill_manual(values=rev(brewer.pal(7,"YlGnBu")))
plot3


######
# Add another column to data3 with species names, based on the accronym in column 4 called "Sample".
# if data3$Sample == 'VIOL', write in column data$Sp == "<i>S. violascens</i>".
# https://www.marsja.se/r-add-column-to-dataframe-based-on-other-columns-conditions-dplyr/
library(dplyr)
# Add species names to the accronym with function glue from the pqckage glue.
# https://wilkelab.org/ggtext/
library(gridtext)
library(ggtext)
library(RColorBrewer)
library(tidyverse) #not sure I am using it here
library(glue)

data4 <- data3
data5 <- data4 %>%
  mutate(Sp = case_when(
    startsWith(as.character(Sample), "VIOL") ~ "<i>S. violascens</i>",
    startsWith(as.character(Sample), "SOCZ") ~ "<i>S. soczavana</i>",
    startsWith(as.character(Sample), "URAL") ~ "<i>S. uralensis</i>",
    startsWith(as.character(Sample), "URUR") ~ "<i>S. uralensis</i> subsp. <i>uralensis</i>",
    startsWith(as.character(Sample), "URAR") ~ "<i>S. uralensis</i> subsp. <i>arctica</i>",
    startsWith(as.character(Sample), "WA") ~ "<i>S. wahlbergella</i>",
    startsWith(as.character(Sample), "ININ") ~ "<i>S. involucrata subsp. involucrata</i>",
    startsWith(as.character(Sample), "INFU") ~ "<i>S. involucrata subsp. furcata</i>",
    startsWith(as.character(Sample), "INTE") ~ "<i>S. involucrata subsp. tenella</i>"),
    name = glue("{Sp} {Sample}")
    )

plot6 <- ggplot(data5, aes(x=Locus, y=name, fill= Readdepth))+
  #add border white colour of line thickness 0.25
  geom_tile(colour="white",size=0.25)+
  #remove extra space
  scale_y_discrete(expand=c(0,0))+
  theme(
    #axis.text.y=element_text(size = 8, face = 'bold'),
    axis.text.y=element_markdown(size = 8),
    axis.text.x=element_text(size=12), #Add face = 'bold' within element_text() if you want bold text
    axis.title = element_text(size=13.5, face = 'bold')
  ) +
  #theme options
  theme(
    legend.title=element_text(face="bold"),
    #bold font for legend text
    legend.text=element_text(face="bold"),
    #set thickness of axis ticks
    axis.ticks=element_line(linewidth=0.4), 
    #orient x axis text
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
    #remove plot background
    plot.background=element_blank(),
    #remove plot border
    panel.border=element_blank()) +
  labs(y="Samples", fill="Read depth") + # Change legend title
  scale_fill_manual(values=rev(brewer.pal(7,"YlGnBu")))
plot6
