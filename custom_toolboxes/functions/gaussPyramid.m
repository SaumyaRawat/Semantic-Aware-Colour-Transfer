function [pyramids] = gaussPyramid(im, levels)

sigma = 0.5;
for i = 1:levels
	if i == 1
		A = imgaussfilt(im,sigma);
		pyramids(i).im = A;
	else
		prev_image = pyramids(i-1).im;
		B = imgaussfilt(prev_image,sigma);
		B2 = imresize( B, [size(prev_image,1)/2 size(prev_image,2)/2] );
        %B1 = B(:,1:2:size(prev_image,2),:); %horizontal downsampling
        %B2 = B1(1:2:size(prev_image,1),:,:); % vertical downsampling
        pyramids(i).im = B2;
    end
end