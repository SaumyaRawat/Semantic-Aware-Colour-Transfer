
%Load mat file
%load '../dataset/matfiles/images_1.mat'
%clear;
%load temp2_fcn.mat
clearvars -except images
file1='0032.png';
file2='0038.png';
n=32;
test_Im = imread(strcat('../dataset/image/',file1));
test_region = (imread(strcat('../dataset/parsing/',file1)));

reference_Im = imread(strcat('../dataset/image/',file2));
reference_region = (imread(strcat('../dataset/parsing/',file2)));

likelihood_test = images(n).norm_F;
likelihood_test = normalise_F(likelihood_test);
%likelihood_reference = vec;

final=color_transfer(test_Im,test_region, reference_Im,reference_region, likelihood_test);
final = lab2disp(final);
imshow(final)