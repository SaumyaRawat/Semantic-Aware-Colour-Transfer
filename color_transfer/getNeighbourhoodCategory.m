function[category] = getNeighbourhoodCategory(category, test_region)
	temp = test_region;
	temp(find(temp~=category))=0;
	[x,y] = find(temp);

	contour = bwtraceboundary(temp,[x y],'E' ); 
	contourimage = zeros(size(temp));
	contourind = sub2ind(size(contourimage),contour(:,1),contour(:,2))
	contourimage(contourind) = 1;
	mask = bwmorph(contourimage,'dilate');

	neighbourhood = mask.* test_region;
	neighbour_category = mode(neighbourhood(:));

end