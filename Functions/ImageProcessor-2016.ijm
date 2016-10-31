// Isabel Winney
// 2016-10-24

// This macro:
// loads a pre-trained WEKA segmentor
// applies that segmentor to a filepath
// saves the output images
// converts these output images to a three-tone image
// measures the frequency of each pixel colour
// and outputs the pixel frequencies to a .txt file

// please check definitions for the following first:

// these are the links to the classifier, .model and .arff files, and the initial 15 training images:

myClassifier = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\TrainingSet.model"
myInformation = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\TrainingSet.arff"
anImageSequence = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingTheWEKA\\ResizedImages\\Original-ImageTyping_P1000932.jpg"

// HERE, DEFINE THE FOLDER WHERE R SAVED THE RESIZED FILES AND WHERE EVERYTHING WILL BE STORED:
rootpath = "C:\\Users\\User\\Documents\\BAGP2016\\ImageProcessing\\"

// where is the LUT
myLUT = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\Functions\\LUT-blackwhitegrey.lut"


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

// This macro loads Trainable WEKA Segmentation program and classification data: 
		
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

// then, segment the photos:

function WEKAmyPhotos(inputDir, inputFile, outputDir, outputFile, LUT){

	// make directory to store the output images	
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

	// convert the colour result to an 8 bit greyscale image, which is
	// converted to more distinct black/white/grey values with a custom
	// lookup table:
	selectWindow("Classification result");
	run("8-bit");
	open(LUT);
	saveAs("PNG", outputFile);

	// clean up
	close("Classification result");

}



// Last, analyse the segmented photos for pixel frequencies:

function analysePhotoType(filename, filepath, output){

		// make the output directory

		File.makeDirectory(output);
		
		// open the image
		
		open(filepath+"\\"+filename);
				
		// save histogram outputs
		
		nBins=3;
				
		getHistogram(values, counts, nBins); 
		
		newoutput = output + "\\HistogramOutput" + filename + ".txt";
		
		d=File.open(newoutput); 
		
		print(d, "environment" + "\t" + "whitebox" + "\t" + "flower" + "\t" + "file");
		
        // This is the line that sends the results to output
        print(d, counts[0]+"\t"+counts[1]+"\t"+counts[2]+"\t"+filename);
		
        wait(10);
		
        // close the files
		        
		File.close(d);
		close(filename);

}



////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

// now, where are the resized files, and where will the processed files go:
myInput = rootpath+"Resized"
myFolder = rootpath+"Processed"

// and the location for saving the histogram data:
output = rootpath+"Results"

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

// begin the segmentation!
openWEKA(anImageSequence, myClassifier, myInformation)


setBatchMode(true); 
myList = getFileList(myInput);
for (i = 0; i < myList.length; i++)
        WEKAmyPhotos(myInput, myList[i], myFolder, myFolder+"\\"+myList[i], myLUT);
setBatchMode(false);


setBatchMode(true); 
list = getFileList(myFolder);
for (i = 0; i < list.length; i++)
        analysePhotoType(list[i], myFolder, output);
setBatchMode(false);
