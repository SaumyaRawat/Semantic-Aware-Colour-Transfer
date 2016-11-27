addpath(genpath('custom_toolboxes'));
tic;
%h = waitbar(0,'Computing response maps.. ')
abacus _path = '/lustre/ameya/Anjali/dip_project/';
I = dir([abacus_path,'dataset/image/*.png']);
M = dir([abacus_path,'dataset/mask/*.png']);
%P = dir('dataset/parsing/*.png');
load ([abacus_path,'mat_files/fcn_data.mat'])

no_of_images = 212;%size(I,1);
for k = 1:no_of_images
    %images(k).org_image = imread(['dataset/image/',I(k).name]);
    %images(k).image = imresize(images(k).org_image,[500 500]);
    %im  = imread(['dataset/image/',I(k).name]);
    %im = imresize(im,[500 500]);
    %images(k).mask = imread(['dataset/mask/',M(k).name]);
    %rough_mask= imread(['dataset/parsing/',P(k).name]);
    %[~,rough_mask,res] = scene_parse(im);
    %images(k).F = res{1};
    for i = 1:size(im,1)
    	for j = 1:size(im,2)
            m1 = min(images(k).F(i,j,:));
            m2 = max(images(k).F(i,j,:));
            images(k).norm_F(i,j,:) = (images(k).F(i,j,:) - m1) / (m2 - m1) ;
            sum1 = sum(images(k).norm_F(i,j,:));
            images(k).norm_F(i,j,:) = images(k).norm_F(i,j,:)/sum1;
            %images(k).norm_F(i,j,:) = (images(k).F(i,j,:) - mean(images(k).F(i,j,:)))/(max(images(k).F(i,j,:))-min(images(k).F(i,j,:)))
        end
    end
    %waitbar(k / size(I,1))
end
%close(h);
save([abacus_path,'mat_files/fcn_data_212.mat'],'images','v7.3')
toc;



