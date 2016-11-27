function[final] = color_transfer(test_Im,test_region, reference_Im,reference_region, likelihood_test)

	test_Im = imresize(test_Im, [500 500]);
	test_region = imresize(test_region, [500 500]);

	%Reference images
	reference_Im = imresize(reference_Im, [500 500]);
	reference_region = imresize(reference_region, [500 500]);

	test_lab = rgb2lab(test_Im);
	reference_lab = rgb2lab(reference_Im);

	[beta_a, beta_b] = getBeta(test_lab, test_region, reference_lab, reference_region);
	Beta = mean([beta_b beta_a]);

	%Luminance transfer
	n=2:14;
	final=(test_lab);
	for category=n
		[test_x, test_y] = find(test_region==category-1);
		[reference_x, reference_y]=find(reference_region==category-1); 
		%If category not found in test image
		if isempty(test_x)
			continue;
		end

		%If category not found in reference in image
		if isempty(reference_x)
			[L,a,b]=transfer_unmatched(category-1, Beta, test_lab, test_region, reference_lab, reference_region,0);
		else
			[L,a,b]=transfer_matched(category-1, Beta, test_lab, test_region, reference_lab, reference_region,0);
		end
			
		likelihood = likelihood_test(:,:, category);
		final(:,:,1)=final(:,:,1)+likelihood.*L;
		final(:,:,2)=final(:,:,2)+likelihood.*a;
		final(:,:,3)=final(:,:,3)+likelihood.*b;
    end
end