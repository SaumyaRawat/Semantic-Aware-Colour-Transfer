%% This file computes the semantic descriptor and saves in variable descriptor(no_of_images).desc in the desc.mat %%
%reponse_map = 'images_1'; %check filename
reponse_map = 'fcn_1'; %check filename %for atom
mat_file = ['mat_files/',reponse_map];
%mat_file = ['/Neutron9/anjali.shenoy/dip_project/mat_files/',reponse_map];

T = load(mat_file,reponse_map);  
reponse_map = T.(reponse_map);
no_of_images = size(reponse_map,2);
w = waitbar(0,'Computing semantic descriptors')
I = dir('dataset/image/*.png');
%I = dir('/Neutron9/anjali.shenoy/dip_project/dataset/image/*.png');
im_index = 1; %check filename
% Construct Semantic Descriptor
for k = 1:no_of_images
    H = [];
    temp = imread(['dataset/image/',I(im_index).name]);
    %temp = imread(['/Neutron9/anjali.shenoy/dip_project/dataset/image/',I(im_index).name]);
    im = imresize(temp,[500 500]);
    sz = size(im);
    m = prod(sz(1:2));
    for gx = 1:3
        for gy = 1:3
            x = (floor(sz(1)/3))*gx;
            start_x = ((floor(sz(1)/3))*(gx-1)) + 1;
            y = (floor(sz(2)/3))*gy;
            start_y = ((floor(sz(2)/3))*(gy-1)) + 1;
            grid = reponse_map(k).norm_F(start_x:x,start_y:y,:); %check filename
            h = zeros(1,14);
            for label = 1:14
                h(label) = (1/m)*sum(sum(grid(:,:,label)));
            end
            H = [H; h];
        end
    end
    global_histFig = figure('Name','Histogram','NumberTitle','off','Visible','off');
    %global_hist = histogram(im(:,:,:),14,'BinLimits',[0 1],'Normalization','probability','Visible','off');
    global_hist = histcounts(im(:,:,:),14);
    global_hist = global_hist/max(max(global_hist));
    H = [H ; global_hist];
    descriptor(k).desc = H;
    waitbar(k/no_of_images)
    im_index = im_index + 1;
    clear temp, H, im
end
close(w)
save('mat_files/descriptor_1.mat','descriptor')
%save('/Neutron9/anjali.shenoy/dip_project/mat_files/descriptor_1.mat','descriptor') %for atom