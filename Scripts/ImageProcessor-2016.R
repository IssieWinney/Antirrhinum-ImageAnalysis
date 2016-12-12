# Isabel Winney
# Created 2016-10-28

# This is a program to take a folder of images and classify all the images in
# the folder as environment images, leaf images, or flower images.

# You need to start by specifying the filepath to the photos
# and the year that you are analysing here:

myRoot <- "C:/Users/Isabel/Documents/BAGP2016/"
year <- 2016

PhotoFilepath <- paste(myRoot, "BAGP-Photos2016", sep = "")
OutputFilepath <- paste(myRoot, "ImageProcessing/2016/Resized", sep = "")

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

# create directories for files.
dir.create(paste(myRoot, "ImageProcessing/", sep = ""))
dir.create(paste(myRoot, "ImageProcessing/", year, sep = ""))

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

ResultsFilepath <- paste(myRoot, "ImageProcessing", year, "Results", sep = "/")

resultsConcatenator(ResultsFilepath,"SegmentationResults")


############################################################################
################################## STEP 4 ##################################
############################################################################

# Lastly, the imageClassifier will sort the images in to environment, leaf
# or flower, and write the results to the .txt file:

source("./Functions/imageClassifier-20161028.R")

myResults <- read.table(paste(ResultsFilepath, "SegmentationResults.txt", sep = "/"), 
                        header = T)

myResults$ProposedPhotoType <- imageClassifier(myResults)

write.table(myResults, 
            file = paste(ResultsFilepath, "SegmentationResults.txt", sep = ""),
            row.names = FALSE,
            sep = "\t")


############################################################################
############################ Percentage correct ############################
############################################################################

# for 2016, I have manually assigned about half of the photo types.
# So using this data, how reliable is the segmentation?

answers <- read.table("./Outputs/randomisationPlusInfo-20160830.txt",
                      header=T)

names(myResults) <- c("environment", "whitebox", "flower", "fileFolder", "ProposedType")

head(myResults)
head(answers)
tail(answers)

# make a variable to match files between the two data frames:
answers$fileFolder <- paste(answers$Folder, answers$File, sep = "_")
answers$fileFolder <- gsub(".JPG", ".png", answers$fileFolder)

# match:
all.answers <- merge(myResults, answers)

head(all.answers)

# output so that I can use these classifications:

write.table(all.answers, 
            file = "./Outputs/randomisationPlusClassification-20161125.txt",
            row.names = FALSE,
            sep = "\t")


# how many photos are classified correctly? (a mean of 
# 1 means that all photos are correctly classified):
mean(all.answers$PhotoType[is.na(all.answers$PhotoType)==FALSE]==all.answers$ProposedType[is.na(all.answers$PhotoType)==FALSE])

# 98.95%. Wow. How many of the misclassified photos are actually typw 'o' photos?

all.answers[which(all.answers$PhotoType!=all.answers$ProposedType),]
# all the 'o's, but also quite a few leaf/flower mistakes. Would this be prevented if I
# had a fourth category, that defined leaves from flowers?

# another option is to flag suspicious cases. A suspicious case could be:
# more than four leaves in a row (suggesting a misclassified flower or environment).
# a single environment photo (suggesting a random misclassification).
# a single leaf photo (suggesting a random misclassification).

# and I should probably remove the photos that I know were not work photos,
# like the group photos and the spider photos...




#############################################################################
#############################################################################

# 2016-12-12
# now I have assigned all the plant IDs and written corrected photo types for
# the whole data set, so I can work out my true total error for 2016.

allAnswers <- read.table("./Outputs/randomisationPlusClassificationPlusManualIDs-20161125.txt",
                      header=T)


head(allAnswers)

# the column ProposedType is fully complete to a point, and after that point it only contains
# the photo types where the proposed photo type does not match the real photo type.

# so, complete this column

for(i in 1:length(allAnswers[,1])){
  if(is.na(allAnswers$PhotoType[i])==TRUE){
    
    # if NA is written in the PhotoType Column, the image classifier is correct
    allAnswers$TrueType[i] <- levels(allAnswers$ProposedType)[allAnswers$ProposedType[i]]
    
  } else {
    
    # if something is written in the PhotoType column, either it is the manually
    # assigned type, or the proposed photo type was incorrect
    allAnswers$TrueType[i] <- levels(allAnswers$PhotoType)[allAnswers$PhotoType[i]]
    
  }
}

head(allAnswers)
tail(allAnswers)


# ok, now what percentage were misclassified:

mean(allAnswers$TrueType==allAnswers$ProposedType)

# 98.97%. Which photos?

allAnswers[which(allAnswers$TrueType!=allAnswers$ProposedType),]

# if we get rid of o samples, what is the percentage incorrect?

minusO <- subset(allAnswers, allAnswers$TrueType!="o")

summary(minusO)

mean(minusO$TrueType==minusO$ProposedType)

# 99.1%! Woooohooooooo!


allAnswers[which(allAnswers$TrueType=="o"),]
