# Isabel Winney
# 2016-08-30

# function to extract the folder names and file names for the environment photographs
# that I want to analyse.

filenameExtractor <- function(filepath){
  # INPUTS:       your.filepath = the folder containing all photos and 
  #                               folders of photos to extract.
  #
  # OUTPUTS:      pictures.list = a complete list of photos with their
  #                              folder names given first.
  # ASSUMES:      no loose files in the main folder (every picture is in
  #               a second folder)
  
  folders <- list.files(path = filepath, 
                      include.dirs= FALSE)
  
  # the name of all files under their given filename:
  
  # name per folder
  
  names.vector <- paste("folder", folders, sep="")
  
  for(i in 1:length(folders)){
    
    # extract the list of names:
    
    filepath.folder <- paste(filepath, folders[i], sep="\\")
    
    pictures <- list.files(path = filepath.folder, 
                      include.dirs= FALSE)
    
    # keep the list with a unique name:
    
    a <- paste(folders[i], pictures, sep="\\")
    
    if(i==1){
      
      pictures.list <- a
      
    } else {
      
      pictures.list <- c(pictures.list, a)
      
    }
  
    }
  
  print(paste("I have extracted ", 
              length(pictures.list), 
              " pictures! Is this what you were expecting?",
              sep=""))
  
  return(pictures.list)

}