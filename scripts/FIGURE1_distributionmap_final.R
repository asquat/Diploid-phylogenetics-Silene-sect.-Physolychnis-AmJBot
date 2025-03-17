# Anne-Sophie Quatela
# March 2025

# Set your working directory
setwd("")

### Read your input data
samples <- read.csv("FIGURE1_samples.csv", sep = ";")
str(samples)

library(maps)
library(ggplot2)
library(ggalt)


### Create the distribution map
# 1. Create a map of the world
world <- map_data("world")

# 2. Create a subset of the world map, focusing on the northern hemisphere. 
# Select the range of longitude and latitudes that you are interested in. 
NHmap <- subset(world, world$lat>35) # Keep all longitudes and latitude above 35 °, i.e. a part of the northern hemisphere.

# 3. Plot the the subset of the map, i.e. northern hemisphere.
map <- ggplot() + geom_polygon(data = NHmap, aes(x=long, y = lat, group = group), colour="black", fill="white") +
  theme(axis.line = element_line(colour = "white"),
        axis.ticks=element_blank(), 
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())
map

# 4. Add data points to map with value affecting color (species)
map_data_coloured <- map +
  geom_point(data=samples, aes(x=LongDD, y=LatDD, colour=species), size=3, alpha=I(0.9))
map_data_coloured

# 5.  Change the color attributed to species, which consequently changes the color of the dots
library(ggtext)
map_data_coloured +
  scale_color_manual(values=c("#006600", "#FFFF00", "#9933FF", "#FF6633", "#66CC00", "#00ABFD", "#F763E0"), 
                     labels = c("<i>Silene involucrata</i>", "<i>Silene soczavana</i>", "<i>Silene uralensis</i>", "<i>Silene uralensis</i> subsp. <i>arctica</i>", "<i>Silene uralensis</i> subsp. <i>uralensis</i>", "<i>Silene violascens</i>", "<i>Silene wahlbergella</i>")) +
  theme(legend.text = element_markdown(size = 11),
        legend.title = element_blank(),
        legend.position = "bottom")
