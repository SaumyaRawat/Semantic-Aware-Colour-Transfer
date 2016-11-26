function [L,a,b]=transfer_matched(category, Beta, test_lab, test_region, reference_lab, reference_region)

	test_L = test_lab(:,:,1);
	test_a = test_lab(:,:,2);
	test_b = test_lab(:,:,3);
	reference_L = reference_lab(:,:,1);

	val_test = mean(test_L(find(test_region==category)));
	val_reference = mean(reference_L(find(reference_region==category)));

	%Get shift in luminance
	desired_mean_L = val_test + Beta*(val_reference-val_test);
	delta = desired_mean_L - val_test;

	%Get chroma of test and train 
	[mu_test, cov_test] = getChroma(category,test_region, test_lab);
	[mu_reference, cov_reference] = getChroma(category,reference_region, reference_lab);

	%Regularise the covariance matrix
	cov_test(find(cov_test<7.5)) = 7.5;

	%Calculate T
	M1 = cov_test^-0.5;
	M2 = cov_test^0.5;
	temp = (M2*cov_reference*M2)^0.5;
	T = M1*temp*M1;

	L = test_L;
	L = L+delta;
	L(find(test_region~=category))=0;
	a = test_a;
	a = a-mu_test(1);
	b = test_b;
	b = b-mu_test(2);

	x1 = T(1,1);
	x2 = T(1,2);
	x3 = T(2,1);
	x4 = T(2,2);

	a = (a*x1) + (b*x2) + mu_reference(1);
	a(find(test_region~=category))=0;
	b = (a*x3) + (b*x4) + mu_reference(2);
	b(find(test_region~=category))=0;

end