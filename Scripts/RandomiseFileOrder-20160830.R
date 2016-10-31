# Isabel Winney
# 2016-08-30

rm(list=ls())

# read in function
source("../../RFunctions/filenameExtractor-20160830.R")

# use to read in photo filenames:

my.path <- "C:\\Users\\User\\Documents\\IssieComputerBackup20160815\\Issie\\Documents\\BAGP2016\\BAGP-Photos2016"

pictureNames <- filenameExtractor(filepath = my.path)

rando.pictureNames <- sample(x = pictureNames,
                             size = length(pictureNames),
                             replace = F)

rando.pictureNames <- data.frame(RandomisedOrder = seq(1, length(randomised$Folder), 1),
                                 FolderPicture = rando.pictureNames)

head(rando.pictureNames)

# so rando.pictureNames is the list of pictures for me to analyse.
# I will use the plant ID in the specific photo and analyse all the
# photos for that plant in one go.

# we can separate the names in to two columns, folder and file,
# using tidyr and dplyr

library(tidyr)
library(dplyr)

randomised <- rando.pictureNames %>% separate(FolderPicture,
                                              c("Folder", "File"),
                                              "\\\\")

head(randomised)
tail(randomised)

# add the column for the plant ID and the column for the picture type:

randomised$PlantID <- NA
randomised$PhotoType <- NA

head(randomised)
tail(randomised)

# now output this list so that I have a fixed list:

write.table(randomised,
            file = "Outputs/randomisation-20160830.txt",
            row.names = FALSE,
            sep = "\t")


# save workspace that produced this randomisation:

save.image("C:/Users/User/ownCloud/Git-Analysis/Antirrhinum-ImageAnalysis/Outputs/REnvironment-20160901.RData")
