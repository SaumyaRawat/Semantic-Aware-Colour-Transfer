clear

%test image
test_Im = im2double(imread('0001im.png'));
test_Im = imresize(test_Im, [500 500]);
test_region = imread('0001.png');
test_region = imresize(test_region, [500 500]);

%Reference images

reference_Im = im2double(imread('0002im.png'));
reference_Im = imresize(reference_Im, [500 500]);
reference_region = imread('0002.png');
reference_region = imresize(reference_region, [500 500]);

test_lab = rgb2lab(test_Im);
reference_lab = rgb2lab(reference_Im);

[beta_a, beta_b] = getBeta(test_lab, test_region, reference_lab, reference_region);
Beta = mean([beta_b beta_a]);

%Luminance transfer
n=0:13;
final=zeros(size(test_Im));
for category=n
	[test_x, test_y] = find(test_region==category);
	[reference_x, reference_y]=find(reference_region==category); 
	%If category not found in test image
	if isempty(test_x)
		continue;
	end

	%If category not found in reference in image
	if isempty(reference_x)
		continue;
	end
	%%%transfer_notmatched()

	%For both matched
	[L,a,b]=transfer_matched(category, Beta, test_lab, test_region, reference_lab, reference_region);
	final(:,:,1)=final(:,:,1)+L;
	final(:,:,2)=final(:,:,2)+a;
	final(:,:,3)=final(:,:,3)+b;
end

v=lab2disp(final);
imshow(v)