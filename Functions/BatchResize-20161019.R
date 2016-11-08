# Isabel Winney
# 2016-10-18

# This script is for loading, resizing, and outputting jpeg images.
# It is to enable batch resizing of image files prior to WEKA segmentation.
# WEKA segmentation requires a maximum file size of 1024 pixels.

BatchResize <- function(folder, size, output.loc){
  
  # INPUTS:       folder        this is the folder containing your folders
  #                             of photos. As of 2016-10-31, this folder can contain
  #                             loose files.
  #               size          this is the end size that you want the photos
  #                             to be relative to their initial size, and is a
  #                             value between 0 and 1, where 1 is 100% of original
  #                             size.
  #               output.loc    name of the output folder you want to create within
  #                             the input folder.
  #
  # OUTPUTS:      ResizedImages a sub-folder of the original directory containing
  #                             the resized images.

  
  
  necessary.packages <- "imager"
  package.present <- necessary.packages %in% installed.packages()[,"Package"]
  
  if(package.present == FALSE){
    
    stop("Please install package imager before continuing")
    
  } else {
    
    # load imager package:
    library("imager")
    
    # load function to read file names
    source("./Functions/filenameExtractor-20160830.R")
    
    # read in file names
    filenames <- filenameExtractor(folder)
    
    # remove any non-jpeg files
    picturenames <- filenames[grep(".JPG", filenames)]
    
    # make filepaths for saving files:
    savefiles1 <- gsub("\\\\", "_", picturenames)
    
    savefiles <- gsub(".JPG", ".png", savefiles1)
    
    ##########################################################
    # files in a single folder now have file extension .png_ so we
    # must correct this if necessary:
    
    problem.savefile <- grep(".png_", savefiles)
    
    if(length(problem.savefile)>1){
      
      savefiles <- gsub(".png_", ".png", savefiles)
      
      # files in picturenames are also incorrect, so we
      # can remove the final \\ here:
      
      picturenames <- gsub(".JPG\\\\", ".JPG", picturenames)
      
    } else {}
    ###########################################################
    
    # make folder/s for saving files:
    dir.create(output.loc)
    
    for(i in 1:length(picturenames)){
      
      # load image i
      jpeg1 <- load.image(paste(folder, picturenames[i], sep="\\"))
      
      # resize image
      resized1 <- resize(jpeg1,
                         round(width(jpeg1)*size),
                         round(height(jpeg1)*size))
      
      # output resized image to file
      imager::save.image(resized1, 
                         paste(output.loc, savefiles[i], sep="\\"))
      
    }
    
  }
  
  print(paste("In the end, I have resized ",
              length(savefiles),
              " for you :)"))
  
  system('CMD /C "ECHO Step 1 has finished: please move on to step 2 && PAUSE"', 
         invisible=FALSE, wait=FALSE)
  
}

# example of use:
if(FALSE){
  BatchResize("TrainingImages", 0.1, "ResizedImages")
  
  # will resize all jpeg photos within folder TrainingImages and 
  # output the new photos to a new folder within TrainingImages called
  # ResizedImages.
}