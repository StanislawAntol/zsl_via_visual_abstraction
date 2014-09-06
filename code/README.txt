README

This is all of the code for the paper: 
Antol, Stanilaw, Zitnick, C. Lawrence, and Parikh, Devi. 
"Zero-Shot Learning via Visual Abstraction." ECCV 2014. 

To reproduce everything, simply run the runAllCode script.
That script calls the script for each part of the project separately in the 
correct sequence. There are some depencies, so changing the order is not 
recommended. To get started, there are a few things one needs to do.
CreateOptionsGlobal.m in the code/common folder contains all the main 
files/folders/other data that the entire project uses (in multiple places).
Change options.foldersBase{4} to be the directory where all the (non-code) 
data will reside. The input data (downloaded with the code) should be in 
a folder called "input" in this directory (e.g., ../data/input). The project
also used other people's code (see below). This code should all be in the same
directory (e.g., ../../3rd_party) and common/CreateOptionsGlobal.m should be
modified to reflect this directory. Also, to save time (and get around the
downloading code not being very robust) please download the INTERACT dataset 
images from the project website and put it into the folder
data/output/interact_image_collection/full_exp_1/found_imgs .

NOTE: Not tested on Windows, but it should work. Figures are currently 
      exported as eps and then converted into PNG via a linux tool, so
      that will not work. Otherwise, everything else hopefully works.
      
REQUIRED 3RD PARTY CODE

-EXPERIMENTS ONLY
--liblinear SVM code
  (http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/liblinear.cgi?+http://www.csie.ntu.edu.tw/~cjlin/liblinear+zip).
  Version 1.94 used in this project.
  Note: I had modified the liblinear code (as mentioned in their documentation)
  so it can output "probabilities." Thus, you may want to download my code to get
  the same results.
--Piotr Dollar's MATLAB toolbox 
  (http://vision.ucsd.edu/~pdollar/toolbox/piotr_toolbox_V3.25.zip) 
  used to make some of the confusion matrix figures. Version 3.25 was used.
-ALL STEPS IN PIPELINE (from AMT collection to Experiments)
--Yang and Ramanan detector (http://www.ics.uci.edu/~dramanan/software/pose/). 
  Version 1.3 used in this project.
  NOTE: If using 2014a, the YR compile code needs a minor modification.
        Original code says "-o" that needs to be changed to "-output".
--GIST descriptor code 
  (http://people.csail.mit.edu/torralba/code/spatialenvelope/gistdescriptor.zip)
  used for duplicate image removal. Version ?? used in this project.