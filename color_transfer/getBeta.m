function[beta_a, beta_b] = getBeta(test_Im, test_region, reference_Im, reference_region)
	[test_L,test_a,test_b] = rgb2lab(test_Im);
	[reference_L,reference_a,reference_b] = rgb2lab(reference_Im);

	%Get beta_a
	val_test=mean(test_a(find(test_region==0)));
	val_ref=mean(reference_a(find(test_region==0)));
	beta_a = tanh(abs(val_test-val_ref));

	%Get beta_b
	val_test=mean(test_b(find(test_region==0)));
	val_ref=mean(reference_b(find(test_region==0)));
	beta_b = tanh(abs(val_test-val_ref));

return