%% Construct feature vectors of dataset %%
%% Using OptProp toolbox by Jerker Wågber %%
addpath(genpath('custom_toolboxes'));
%% Read the image and resize to save computation time %%
D = dir('datasets/misc_dataset/*_*.jpg');
%D = dir('datasets/set/*_*.jpg');
tic;
h = waitbar(0,'Labelling images.. ')
	
%if exist('labelled_images','dir')
%	rmdir('labelled_images','s')
%	mkdir('labelled_images')
%end

for k = 1:size(D,1)
	filename = ['datasets/misc_dataset/',D(k).name];
	%filename = ['datasets/set/',D(k).name];
	im = imread(filename);
	im = imresize(im, [500 250]);
	[out_im,maskIm]=scene_parse(im);
    %if ( sum(maskIm(:) == 0) )>=5
    %    filename = strcat(labelled_images,'/',num2str(i),'.jpg');
    %    imwrite(maskIm,filename,'jpg');
    %end
    %if ( sum(maskIm(:) == 0) )>=5
    	labelled_images(k).image = maskIm;
    %end
    waitbar(k / size(D,1))
end
save('labelled_images.mat','labelled_images');
close(h)
toc;

