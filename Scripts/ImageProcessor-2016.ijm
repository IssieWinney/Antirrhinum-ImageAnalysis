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

	myClassifier = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingSet.model"
	myInformation = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\TrainingSet.arff"
	anImageSequence = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\ResizedImages\\Original-ImageTyping_P1000932.jpg"
	openWEKA(anImageSequence, myClassifier, myInformation)





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
				open("C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\LUT-blackwhitegrey.lut");

				saveAs("PNG", outputFile);

				close("Classification result");
		}

	myInput = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\20160517\\Resized"
	myFolder = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\20160517\\Processed"
	
	setBatchMode(true); 
	myList = getFileList(myInput);
	for (i = 0; i < myList.length; i++)
	        WEKAmyPhotos(myInput, myList[i], myFolder, myFolder+"\\"+myList[i]);
	setBatchMode(false);


// Then, analyse the segmented photos for pixel frequencies:

		function analysePhotoType(filename, filepath, output){
		
				// open the image
		
				open(filepath+filename);

				// this WEKA image is in RGB, and we need 8 bit greyscale.
				// however, when we run statistical region merging on
				// 8 bit greyscale, the flower regions are not different
				// enough from the background and the result is that too
				// few pixels are assigned as flower pixels and we cannot
				// distinguish flowers from leaves.

				// however, if we first convert to 16 bit greyscale (or 32,
				// both work well), we have a greater pixel range and so
				// enough difference between the flower and background to
				// distinguish the flower pixels. We can then convert back
				// to 8 bit, and retain the colour separation for SRM:

				run("16-bit");
				run("8-bit");
		
				// convert the image to three main colours
		
				run("Statistical Region Merging", "q=3 showaverages");
		
				selectWindow(filename);
		
				close(filename);
		
				selectWindow(filename + " (SRM Q=3.0)");
				
				// save histogram outputs
		
				nBins=3;
				
				getHistogram(values, counts, nBins); 
		
				newoutput = output + filename + ".txt";
		
				d=File.open(newoutput); 
		
				print(d, "environment" + "\t" + "whitebox" + "\t" + "flower" + "\t" + "file");
		
		        // This is the line that sends the results to output
		        print(d, counts[0]+"\t"+counts[1]+"\t"+counts[2]+"\t"+filename);
		
		        wait(10);
		
		        // close the files
		        
				File.close(d);
		
				close(filename + " (SRM Q=3.0)");
		
		}

// and now, this batch process is run on all the photos taken in 2016:


// define the location of the saved segmented images:
	rootpath = "C:\\Users\\User\\ownCloud\\Git-Analysis\\Antirrhinum-ImageAnalysis\\TrainingImages\\20160517\\"
	filepath = rootpath+"Processed\\"
// and the location for saving the output data:
	output = rootpath+"Results\\HistogramOutput"

// Recursively run the macro on the segmented images:
	setBatchMode(true); 
	list = getFileList(filepath);
	for (i = 0; i < list.length; i++)
	        analysePhotoType(list[i], filepath, output);
	setBatchMode(false);
