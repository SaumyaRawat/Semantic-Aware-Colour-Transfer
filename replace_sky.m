addpath(genpath('custom_toolboxes'));
addpath('functions')
tic;
A=imread('input.png');
target = imresize(A, [500 250]);

I = dir('dataset/image/*.png');
M = dir('dataset/mask/*.png');
P = dir('dataset/parsing/*.png');

for k = 1:size(I,1)
    images(k).org_image = imread(['dataset/image/',I(k).name]);
    images(k).image = imresize(images(k).org_image,[500 500]);
    %images(k).mask = imread(['dataset/mask/',M(k).name]);
    %images(k).parsing = imread(['dataset/parsing/',P(k).name]);
    images(k).F = zeros(1,14);
    [~,rough_mask,res] = scene_parse(images(k).image);
    images(k).response_map = res{1};
    response_map = res{1};
    images(k).norm_F = (response_map - min(response_map(:)))/(max(response_map(:))-min(response_map(:)));
end

% Label the input target image 
%[maskIm,responses] = scene_parse(target);
%maskIm = imread('input_mask.png');
%%%%% REMOVED SKY CODE FOR NOW, ITS IN GC_EXAMPLE %%%%%
save('images','image_data.mat')
toc;



