function[beta_a, beta_b] = getBeta(test_lab, test_region, reference_lab, reference_region)

	test_a = test_lab(:,:,2);
	test_b = test_lab(:,:,3);

	reference_a = reference_lab(:,:,2);
	reference_b = reference_lab(:,:,3);

	%Get beta_a
	val_test=mean(test_a(find(test_region==0)));
	val_ref=mean(reference_a(find(test_region==0)));
	beta_a = tanh(abs(val_test-val_ref));

	%Get beta_b
	val_test=mean(test_b(find(test_region==0)));
	val_ref=mean(reference_b(find(test_region==0)));
	beta_b = tanh(abs(val_test-val_ref));

end