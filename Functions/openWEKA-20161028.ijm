// Isabel Winney
// Created 2016-10-24
// Edited 2016-10-28

// Macro to load Trainable WEKA Segmentation program and classification data: 

// Extract the relevant folders from the R input argument:

folders = getArgument;
delimiter = "*";
parts=split(folders, delimiter);
anImageSequence = parts[0];
myClassifier = parts[1];
myInformation = parts[2];

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

openWEKA(anImageSequence, myClassifier, myInformation)