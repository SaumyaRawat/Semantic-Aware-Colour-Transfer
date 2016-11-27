 =addpath(genpath('custom_toolboxes'));
tic;
h = waitbar(0,'Computing response maps.. ')
I = dir('dataset/image/*.png');
M = dir('dataset/mask/*.png');
P = dir('dataset/parsing/*.png');
load 'fcn_data.mat'

no_of_images = 212;%size(I,1);
for k = 1:no_of_images
    %images(k).org_image = imread(['dataset/image/',I(k).name]);
    %images(k).image = imresize(images(k).org_image,[500 500]);
    im  = imread(['dataset/image/',I(k).name]);
    im = imresize(im,[500 500]);
    %images(k).mask = imread(['dataset/mask/',M(k).name]);
    %rough_mask= imread(['dataset/parsing/',P(k).name]);
    [~,rough_mask,res] = scene_parse(im);
    images(k).F = res{1};
    for i = 1:size(im,1)
    	for j = 1:size(im,2)
    		images(k).norm_F(i,j,:) = (images(k).F(i,j,:) - min(images(k).F(i,j,:)))/(max(images(k).F(i,j,:))-min(images(k).F(i,j,:)));
            images(k).norm_F(i,j,:) = images(k).norm_F(i,j,:)/sum(images(k).norm_F(i,j,:));
            %images(k).norm_F(i,j,:) = (images(k).F(i,j,:) - mean(images(k).F(i,j,:)))/(max(images(k).F(i,j,:))-min(images(k).F(i,j,:)))
        end
    end
    waitbar(k / size(I,1))
end
close(h);
save('fcn_data.mat','images','v7.3')
toc;



