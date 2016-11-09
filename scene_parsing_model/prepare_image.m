function[crops_data]=prepare_image(im)
% ------------------------------------------------------------------------

	IMAGE_DIM = 500;
	CROPPED_DIM = 500;

	% Convert an image returned by Matlab's imread to im_data in caffe's data
	% format: W x H x C with BGR channels
	im_data = im(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
	im_data = permute(im_data, [2, 1, 3]);  % flip width and height
	im_data = single(im_data);  % convert from uint8 to single
	im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');  % resize im_data
	mean = ones(IMAGE_DIM,IMAGE_DIM,3);
	mean(:,:,1) = mean(:,:,1)*104.00698793;
	mean(:,:,2) = mean(:,:,2)*116.66876762;
	mean(:,:,3) = mean(:,:,3)*122.67891434;

	im_data = im_data - mean;

	% oversample (4 corners, center, and their x-axis flips)
	crops_data = zeros(CROPPED_DIM, CROPPED_DIM, 3, 1, 'single');
	indices = [0 IMAGE_DIM] + 1;
    crops_data(:, :, :, 1) = im_data(1:CROPPED_DIM, 1:CROPPED_DIM, :);
end