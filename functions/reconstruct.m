function [img] = reconstruct(lpyramids)
	for i = length(lpyramids)-1:-1:1
		lpyramids(i).im = lpyramids(i).im+imresize(lpyramids(i+1).im,[ size(lpyramids(i).im,1) size(lpyramids(i).im,2) ]);
	end
	img = lpyramids(1).im;
end