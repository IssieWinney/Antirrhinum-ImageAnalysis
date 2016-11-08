# Isabel Winney
# 2016-10-20

# training R to categorise the histogram outputs:

# so how do I go from histogram outputs to categorised data?

# source my function for turning the imageJ outputs in to 
# a single .txt file:
source("./Functions/resultsConcatenator-20161020.R")

# run it on the outputs:
resultsConcatenator("TrainingImages/TrainingTheWEKA/Results","TrainingImages")

# read in the resulting table:
results <- read.table("TrainingImages/TrainingTheWEKA/Results/TrainingImages.txt",
                      header = TRUE)

results



# add the answers (just as a list for this small file):
results$answers <- c("e","e","e",
                     "f","l","e",
                     "f","l","l",
                     "e","e","e",
                     "e","l","l")

results
str(results)

# how do I classify environment photos from the others?:
plot(y = results$environment, x = factor(results$answers))
plot(y = results$whitebox, x = factor(results$answers))
plot(y = results$flower, x = factor(results$answers))



results

# great!

#######################################################
#######################################################

### so the next question: does this work on some other photos???
# Let's take the first day of fieldwork from this year and find
# out:

resultsConcatenator("TrainingImages/20160517/Results","TestImages")

results2 <- read.table("TrainingImages/20160517/Results/TestImages.txt",
                      header = TRUE)
head(results2)

# are the counts so clear?

hist(results2$environment)
hist(results2$whitebox)
hist(results2$flower)

# well it looks promising. What are the answers?


answers <- read.table("./Data/ManuallyAssignedPhotoTypes-20161024.txt",
                      header=T)

head(answers)
str(answers)


head(results2)

# now I need to match my results and answers by filename:

# extract some pure filenames, without the folder references:

names(results2) <- c("environment", "whitebox", "flower", "fileFolder")

results2$File <- gsub("20160517_", "", results2$fileFolder)
results2$File <- gsub("20160518_", "", results2$File)

head(results2)

answers$File <- gsub(".JPG", ".png", answers$File)

answers.20160517 <- subset(answers, answers$Folder==20160517)

head(answers.20160517)

# how big is a flower?

# generally over 3000 pixels, but how much of the image is this? 

results2$imagesize <- results2$environment + results2$whitebox + results2$flower

results2$imagesize

results2$propFlower <- results2$flower / results2$imagesize

hist(results2$propFlower)

# So, if a flower is generally 1.5% of an image,
# I can use the threshold 0.015 to classify whether an
# image is of a flower or not.

# put this value in the image classifier and see whether the images
# are classified correctly:

source("./Functions/imageClassifier-20161028.R")

results2$ProposedPhotoType <- imageClassifier(results2)

# now merge the two data frames:
results3 <- merge(results2, answers.20160517)

head(results3)

# how many photos are classified correctly? (a mean of 
# 1 means that all photos are correctly classified):
mean(results3$PhotoType==results3$ProposedPhotoType)

# how different are the different categories from this time
# to the photos before?

plot(y = results3$environment, x = factor(results3$PhotoType))
plot(y = results3$whitebox, x = factor(results3$PhotoType))
plot(y = results3$flower, x = factor(results3$PhotoType))



#######################################################
#######################################################

# So this appears to work at a small scale. But what is not
# in the sample is an example of a photo marked 'other', and
# what is not in the classification script is a tolerance to
# say that photos not fitting any classes are marked as uncertain.

head(answers)
table(answers$PhotoType)
# so in this larger sample, I know that I have 23 'other' photos.
# so, if I scale up the image classifier to all these photos, 
# what do I have?


# results in another script!