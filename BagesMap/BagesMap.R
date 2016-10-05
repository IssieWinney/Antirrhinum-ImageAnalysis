# Isabel Winney
# Created 20160928

# Script for mapping the bages site and adding polygons to define the study plot areas

# Load libraries:
library(ggmap)
library(ggplot2)
library(gridExtra)
library(grid)

# Load lat/longs:
latlong <- read.table("Data/BagesLatLong-20160928.txt", header=T)

# Load a map of the area
BagesMap <- get_map(location = c(lon = 2.98, lat = 43.11), zoom = 15)

# Take a look
ggmap(BagesMap)

# add colourblind friendly palate from 
# http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette
# minus the blue ones because they look like the sea.
cbPalette <- c("#999999", "#E69F00", "#009E73", 
               "#F0E442", "#D55E00", "#CC79A7")

BagesMap <- ggmap(BagesMap) + 
  geom_polygon(data = latlong, aes(x = Long, y = Lat, 
                                   group = Site,
                                   fill = factor(Site))) +
  scale_fill_manual(values=cbPalette,
                    name = "Site") +
  xlab("Longitude") +
  ylab("Lattitude") +
  ggtitle("Bages sites")
  

BagesMap

# following Caroline's suggestion on 5/10/2016, add a map of the general
# area in the South of France that covers the field site:

SudMap <- get_map(location = c(lon = 2, lat = 47), zoom = 6)

# Take a look
ggmap(SudMap)

# Add a point for Bages
SudMap <- ggmap(SudMap) + 
  geom_point(aes(x=2.98, y=43.11), 
             pch = 16, cex = 5, color = "orange") +
  geom_point(aes(x=2.98, y=43.11), 
             pch = 4, cex = 4) +
  xlab("Longitude") +
  ylab("Lattitude") +
  ggtitle("Location of Bages")


SudMap

# export map

maps <- arrangeGrob(grobs = list(SudMap, BagesMap), 
                    ncol=2, layout_matrix = rbind(c(1,1,1,1,1,
                                                    2,2,2,2,2,2)))

grid.newpage()
grid.draw(maps)

ggsave("Plots/BagesStudyArea.pdf",
       plot = maps,
       width = 20,
       height = 10,
       units="cm")