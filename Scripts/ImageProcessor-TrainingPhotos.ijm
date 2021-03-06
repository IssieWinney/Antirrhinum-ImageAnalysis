// Isabel Winney
// 2016-10-24

// This macro:
// loads a pre-trained WEKA segmentor
// applies that segmentor to a filepath
// saves the output images
// converts these output images to a three-tone image
// measures the frequency of each pixel colour
// and outputs the pixel frequencies to a .txt file

// First, load Trainable WEKA Segmentation program and classification data: 


		
function openWEKA(image, classifier, information){

	// Have to open an image to open WEKA, therefore open the original
	// training sequence:

	run("Image Sequence...", "open=" + image + " sort");

	run("Trainable Weka Segmentation"); 
	wait(200);
	// (you have to wait here or else java does not load properly and everything stops working)

	// load the classifier:
	call("trainableSegmentation.Weka_Segmentation.loadClassifier",
		classifier);
	wait(10000);

	// load the traces:
	call("trainableSegmentation.Weka_Segmentation.loadData", 
		information);

}

myClassifier = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\TrainingSet.model"
myInformation = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\TrainingSet.arff"
anImageSequence = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\Resized\\DSCF0028.jpg"
openWEKA(anImageSequence, myClassifier, myInformation)





// apply the WEKA

function WEKAmyPhotos(inputDir, inputFile, outputDir, outputFile){

	File.makeDirectory(outputDir);

	selectWindow("Trainable Weka Segmentation v3.2.2");
		
	// apply the classifier:
	call("trainableSegmentation.Weka_Segmentation.applyClassifier",
		inputDir, 
		inputFile,
		"showResults=true", 
		"storeResults=false", 
		"probabilityMaps=false",
		"")
	
	// wait for the segmentation to complete. In future, this should be
	// linked to run time.
	wait(150);

	selectWindow("Classification result");
	run("8-bit");
	open("C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\Functions\\LUT-blackwhitegrey.lut");

	saveAs("PNG", outputFile);

	close("Classification result");

}



myInput = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\Resized"
myFolder = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\Processed"
	
setBatchMode(true); 
myList = getFileList(myInput);
for (i = 0; i < myList.length; i++)
	WEKAmyPhotos(myInput, myList[i], myFolder, myFolder+"\\"+myList[i]);
setBatchMode(false);

// close WEKA

selectWindow("Trainable Weka Segmentation v3.2.2");
close();
selectWindow("Resized");
close();

// Then, analyse the segmented photos for pixel frequencies:

function analysePhotoType(filename, filepath){
		
	// make results directory:
	File.makeDirectory(filepath + "Results");
				
	// open the image
		
	open(filepath+"Processed\\"+filename);

	selectWindow(filename);
				
	// save histogram outputs
		
	nBins=3;
				
	// make a histogram of the image
	
	getHistogram(values, counts, nBins); 
		
	newoutput = filepath+"Results\\HistogramOutput" + filename + ".txt";
		
	d=File.open(newoutput); 
		
	print(d, "environment" + "\t" + "whitebox" + "\t" + "flower" + "\t" + "file");
		
	// This is the line that sends the results to output
	print(d, counts[0]+"\t"+counts[1]+"\t"+counts[2]+"\t"+filename);
		
	wait(10);
		
	// close the files
		        
	File.close(d);
		
	close(filename);
		
}


// and now, this batch process is run on all the photos:


// define the location of the segmentation analysis:
filepath = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\"

photoLocation = filepath + "\\processed"

// Recursively run the macro on the segmented images:
setBatchMode(true); 
list = getFileList(photoLocation);
for (i = 0; i < list.length; i++)
	analysePhotoType(list[i], filepath);
setBatchMode(false);



// and now tell the user that everything is finished

Dialog.create("I'm done!"); 
Dialog.addMessage("Step 2 complete. Please move on to step 3."); 
Dialog.show() 