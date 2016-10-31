# Isabel Winney
# Created 2016-10-31
# Version: training photos

# This is a program to take a folder of images and classify all the images in
# the folder as environment images, leaf images, or flower images.

# You need to start by specifying the filepath to the photos here:

myRoot <- ".\\TrainingImages\\TrainingTheWEKA\\"

PhotoFilepath <- paste(myRoot, "Original-ImageTyping", sep = "")
OutputFilepath <- paste(myRoot, "Resized", sep = "")

# ASSUMPTIONS:
# PhotoFilepath contains only photos within folders - there are no loose photos
# hanging around.
# The photos are all in .JPG format. Note capital letters. They will be outputted
# as png's.

############################################################################
################################## STEP 1 ##################################
############################################################################

# Resize the photos using the photo resize function
# In the below they are resized to 10% of their original size.
# They need to be smaller than 1024 pixels wide to be loaded in 
# step 2.

source("./Functions/BatchResize-20161019.R")
# note that BatchResize calls filenameExtractor.

BatchResize(PhotoFilepath, 0.1, OutputFilepath)


############################################################################
################################## STEP 2 ##################################
############################################################################

# open Fiji
# run script ImageProcessor, adjusting the first five arguments to reference 
# the OutputFilepath that you have just created

############################################################################
################################## STEP 3 ##################################
############################################################################

# now R will concatenate the histogram results in to a single .txt file
# and delete the single files:

source("./Functions/resultsConcatenator-20161020.R")

ResultsFilepath <- paste(myRoot, "ImageProcessing/Results/", sep = "")

resultsConcatenator(ResultsFilepath,"SegmentationResults")


############################################################################
################################## STEP 4 ##################################
############################################################################

# Lastly, the imageClassifier will sort the images in to environment, leaf
# or flower, and write the results to the .txt file:

source("./Functions/imageClassifier-20161028.R")

myResults <- read.table(paste(ResultsFilepath, "SegmentationResults.txt", sep = ""), 
                        header = T)

myResults$ProposedPhotoType <- imageClassifier(myResults)

write.table(myResults, 
            file = paste(ResultsFilepath, "SegmentationResults.txt", sep = ""),
            row.names = FALSE,
            sep = "\t")
