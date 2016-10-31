# Isabel Winney
# 2016-10-24
# This is the image classifier for Antirrhinum majus images


imageClassifier <- function(data){
  
  # INPUT         data          This is the data frame.
  # OUTPUT        PhotoType     a variable that declares
  #                             that the photo is an e(nvironment photo), 
  #                             l(eaf photo) or f(lower photo).
  # ASSUMPTIONS                 The dataframe already contains counts of the
  #                             black, grey and white pixels within the images
  #                             processed by ImageJ, and the counts of these
  #                             pixels are called environment for environment
  #                             class pixels, whitebox for pixels classed as 
  #                             being within the white photobox that we use in
  #                             the field, and flower for pixels classed as
  #                             flowers.
  
  
  # create somewhere to store the results
  
  output <- array(data = NA, dim = length(data))
  
  for(i in 1:length(data[,1])){
    
    if(data$environment[i]>data$whitebox[i]){
      
      output[i] <- "e"
      
    } else {
      
      if((data$flower[i]/
         (data$flower[i]+data$environment[i]+data$whitebox[i]))>
         0.015){
        
        output[i] <- "f"
        
      } else {
        
        output[i] <- "l"
        
      }
      
    }
    
  }
  
  return(output)
  
}


# example

if(FALSE){
  
  results$ProposedPhotoType <- imageClassifier(results)
  
}