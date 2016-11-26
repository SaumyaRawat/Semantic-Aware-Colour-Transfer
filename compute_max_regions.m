%% Compare between decriptors of all images and choose reference image %%
addpath(genpath('/Neutron9/anjali.shenoy/dip_project/custom_toolboxes'))

I = dir('/Neutron9/anjali.shenoy/dip_project/dataset/image/*.png');
M = dir('/Neutron9/anjali.shenoy/dip_project/dataset/mask/*.png');

no_of_images = size(I,2);
%w = waitbar(0,'Computing max sky areas')
for k = 1:no_of_images
    source = imread(['/Neutron9/anjali.shenoy/dip_project/dataset/image/',M(k).name]);
    source_sky_mask = im2bw(imread(['/Neutron9/anjali.shenoy/dip_project/dataset/mask/',M(k).name]));
    if isempty(find(source_sky_mask==0))
        max_rects(k).max_source_region = 0;
       continue;
    end
    [S,~,~,max_source_region,sr1,sr2,sc1,sc2] = FindLargestRectangles((source_sky_mask),source);
    max_rects(k).max_source_region = max_source_region;
    max_rects(k).index = [sr1,sr2,sc1,sc2];
    max_rects(k).region = S;
    k
    %waitbar(k/no_of_images,sprintf('percentage = %2.2f',(k*100)/no_of_images))
end
%save('max_rects.mat','max_rects')
save('/Neutron9/anjali.shenoy/dip_project/mat_files/max_rects.mat','max_rects')
%close(w)
