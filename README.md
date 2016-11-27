# DIP-Project-Semantic-Aware-Colour-Transfer
* Implementation of the paper : Sky is Not the Limit: Semantic-Aware Sky Replacement
* Github Link: https://github.com/SaumyaRawat/DIP-Project-Semantic-Aware-Colour-Transfer.git
* Report to the project can be found in the repo. 

## Pipeline 
* Label Images with FCN model
* Retrieve images with diverse sky appearances and similar semantic content for replacement
* Replace the sky from the selected image to the target
* Transfer colour between target and source-sky images to match with the new sky

## References 
* Paper : http://www.eecs.harvard.edu/*kalyans/research/skyreplace/SkyReplacement_SIG16.pdf
* Optprop Toolbox : https://in.mathworks.com/matlabcentral/fileexchange/13788-optprop-a-color-properties-toolbox

## Datasets 
* Dataset of the paper : https://dl.dropboxusercontent.com/u/73240677/SIGGRAPH16/database.zip

##NOTE : Code 
* Code requires caffe-cpu
* Mat files present in mat_files (on git-lfs) are required to run the code
* main.m consists of the pipeline execution, name of input image from the dataset provided in the dataset folder is added to file1. 
