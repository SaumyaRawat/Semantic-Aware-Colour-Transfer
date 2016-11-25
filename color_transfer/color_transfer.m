clear

%test image
test_Im = im2double(imread('0001im.png'));
[test_L,test_a,test_b] = rgb2lab(test_Im);
test_region = imread('0001.png');

%Reference images

reference_Im = im2double(imread('0002im.png'));
[reference_L,reference_a,reference_b] = rgb2lab(reference_Im);
reference_region = imread('0002.png');

[beta_a, beta_b] = getBeta(test_Im, test_region, reference_Im, reference_region);

%Luminance transfer
n=0:13
for category=n
	%n
end