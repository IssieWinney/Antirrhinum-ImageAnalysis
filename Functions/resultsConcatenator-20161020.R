# Isabel Winney
# 2016-10-20

# Results concatenator
# Apparently adding continuously to a results file is 
# a hard task in imageJ/Fiji. This script is to take the
# .txt files produced by imagej and turn them in to a single file.


resultsConcatenator <- function(filepath, output){
  
  # INPUT     filepath    the relative filepath to the folder of
  #                       imageJ result tables that you want to 
  #                       merge.
  # OUTPUT    output      a .txt file named 'output' containing
  #                       your concatenated data.
  # WARNING               DELETES ALL SMALLER RESULT FILES IN THE FOLDER
  
  results <- list.files(path = filepath, 
                      include.dirs= FALSE)
  
  for(i in 1:length(results)){
  
    if(i==1){
    
      allresults <- read.table(paste(filepath, "/", results[i], sep=""),
                                      header=T)
    } else {
    
      tempresults <- read.table(paste(filepath, "/", results[i], sep=""),
                              header=T)
    
      allresults <- rbind(allresults, tempresults)
    
   }

  }
  
  file.remove(paste(filepath, "/", results, sep=""))
  
  write.table(allresults, 
              file = paste(filepath, "/", output, ".txt", sep=""),
              row.names = FALSE,
              sep = "\t")
  
}