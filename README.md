# HyperspectralClassification

Project Title: Superpixel-based spectral classification for the detection of head and neck cancer with hyperspectral imaging.

Details: Performed machine learning and image processing techniques to 11 mice each with a large dataset. Applied PCA feature extraction to reduce the number of bands to 2 principal components. Performed image clustering with superpixels to reduce computation. Utilized R-SVM to train the model and classify tumor. Used a leave-one-out cross-validation on 11 mice dataset and obtained an average 93% sensitivity and 85% specificity over 11 mice. Reduced total computation time from days to less than 15 minutes. 

Submitted first author and presented paper at 2016 SPIE Medical Imaging: Precision Medicine conference as an oral talk.
Link: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5028206/

## Basic Overview

<p align="center"><img width = 95% src=""></p>


## Install 
Need to download files and libraries 
SLIC Code: Download the SLIC codes from http://ivrl.epfl.ch/files/content/sites/ivrg/files/supplementary_material/RK_SLICsuperpixels/SLIC_mex.zip
LIBSVM: Make sure to have the libsvm library downloaded and extracted in the folder called Codes. https://www.csie.ntu.edu.tw/~cjlin/libsvm/ or https://www.csie.ntu.edu.tw/~cjlin/libsvm/#matlab

## Run Code
Need to Compile the C file using ```mex slicmex.c```before running the main script below
```
run_script.m 
```

## Output
functions
function_PCA_SVM.m
Combine_Cell_Vector.m
Feature_Stand.m
Superpixel_SLIC.m


GUI Files
gui_interface_v2.m
gui_interface_v2.fig
