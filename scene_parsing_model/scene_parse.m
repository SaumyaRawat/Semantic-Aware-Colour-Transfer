function[out,responses]=scene_parse(im)
	tic;
	caffe.set_mode_cpu();
	net_weights = ['FCN_scene_parsing.caffemodel'];
	net_model = ['deploy_16s_LMSun.prototxt'];
	net = caffe.Net(net_model, net_weights, 'test');
	im = imread('image.jpg');
	% prepare oversampled input
	% input_data is Height x Width x Channel x Num
	toc;
	input_data = {prepare_image(im)};

	% do forward pass to get scores
	% scores are now Channels x Num, where Channels == 3
	tic;
	% The net forward function. It takes in a cell array of N-D arrays
	% (where N == 4 here) containing data of input blob(s) and outputs a cell
	% array containing data from output blob(s)
	scores = net.forward(input_data);
	toc;
	responses = scores;
	scores = scores{1};
	[v,out_m]=max(scores,[],3);
	out=fliplr(imrotate(label2rgb(out_m-ones(500,500)),-90));
	% call caffe.reset_all() to reset caffe
	caffe.reset_all();
end
% ------------------------------------------------------------------------
