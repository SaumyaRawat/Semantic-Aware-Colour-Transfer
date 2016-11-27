function [mu, cov_mat] = getChroma(category, region, lab_im)
	%Returns chroma of an image segment as num_pixels x 2 matrix
	lab_a = lab_im(:,:,1);
	lab_b = lab_im(:,:,2);
	chroma_a = lab_a(find(region==category));
	chroma_b = lab_b(find(region==category));
	chroma = [chroma_a chroma_b];

	mu = mean(chroma);
	cov_mat=cov(chroma);


end