# Isabel Winney
# Created 20160928

# Script for mapping the bages site and adding polygons to define the study plot areas

# Load libraries:
library(ggmap)
library(ggplot2)

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
  ggtitle("Map of Bages study area")
  

BagesMap


# export map

ggsave("Plots/BagesStudyArea.pdf",
       plot = BagesMap,
       width = 20,
       height = 20,
       units="cm")