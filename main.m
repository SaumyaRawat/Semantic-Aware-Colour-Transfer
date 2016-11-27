
clearvars -except images

addpath(genpath('custom_toolboxes'))

%%%% MAT FILES %%%%
load(['mat_files/','descriptor_212']); 
load(['mat_files/','max_rects']); 

file1='0160.png'; %% Input image from the dataset/image folder

input = imread(['dataset/image/',file1]);
input_mask = imread(['dataset/mask/',file1]);

[input_region,I_replaced,reference_Im,reference_region,norm_F,ref_im_name] = replace_sky(input,input_mask,descriptor,max_rects);
final=color_transfer(I_replaced,uint8(input_region), reference_Im,uint8(reference_region), norm_F);
final = lab2disp(final);

filename=sprintf('documents/images/%s_%s.jpg', file1, ref_im_name); %% Saved as <input_image>_<reference_image>
imwrite(final,filename);

figure;
subplot(1,3,1)
imshow(input)
title('input')
subplot(1,3,2)
imshow(reference_Im)
title('reference')
subplot(1,3,3)
imshow(final)
title('output')