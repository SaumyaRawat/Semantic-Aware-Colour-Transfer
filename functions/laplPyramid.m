function [lpyramids] = laplPyramid(im, levels)
pyramids = gaussPyramid(im,levels);
i=levels;
while i > 0
	if i == levels
        lpyramids(i).im = pyramids(i).im;
    else
    	prev_image = pyramids(i+1).im;
    	output_size = [ size(pyramids(i).im,1) size(pyramids(i).im,2) ]; 
		prev_image_expand = imresize(prev_image, output_size);
	    diff = pyramids(i).im - prev_image_expand;
        lpyramids(i).im = diff;
    end
    i = i - 1;
end

%for i = 1:levels
%	figure;
%	imshow( lpyramids(i).im );
%end

end