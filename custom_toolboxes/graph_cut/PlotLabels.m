function ih = PlotLabels(L)

	L = single(L);

	bL = imdilate( abs( imfilter(L, fspecial('log'), 'symmetric') ) > 0.1, strel('disk', 1));
	LL = zeros(size(L),class(L));
	LL(bL) = L(bL);
	Am = zeros(size(L));
	Am(bL) = .5;
	ih = imagesc(LL); 
	set(ih, 'AlphaData', Am);
	colorbar;
	colormap 'jet';
end