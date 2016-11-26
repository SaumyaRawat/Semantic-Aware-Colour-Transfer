D = dir('./*.jpg');

for i=1:size(D,1)
	if D(i).name == '.'
		continue
	end
	I = imread(D(i).name);
	I_crop=imcrop(I, [20 1 400 300]);
	imshow(I_crop)
	
	%I_crop = imresize(I_crop, [450 600]);
	imwrite(I_crop,strcat('cropped_images/',D(i).name));
end