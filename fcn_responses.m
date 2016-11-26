addpath(genpath('custom_toolboxes'));
addpath('functions')
tic;
h = waitbar(0,'Computing response maps.. ')


I = dir('dataset/image/*.png');
M = dir('dataset/mask/*.png');
P = dir('dataset/parsing/*.png');

for k = 1:size(I,1)
    images(k).org_image = imread(['dataset/image/',I(k).name]);
    images(k).image = imresize(images(k).org_image,[500 500]);
    %images(k).mask = imread(['dataset/mask/',M(k).name]);
    %images(k).parsing = imread(['dataset/parsing/',P(k).name]);
    [~,rough_mask,res] = scene_parse(images(k).image);
    images(k).F = res{1};
    images(k).norm_F = (images(k).F - min(images(k).F(:)))/(max(images(k).F(:))-min(images(k).F(:)));
    waitbar(k / size(I,1))
end
close(h);
% Label the input target image 
%[maskIm,responses] = scene_parse(target);
%maskIm = imread('input_mask.png');
%%%%% REMOVED SKY CODE FOR NOW, ITS IN GC_EXAMPLE %%%%%
save('images','image_data.mat')
toc;



