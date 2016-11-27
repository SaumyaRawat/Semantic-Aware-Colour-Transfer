%% Compare between decriptors of all images and choose reference image %%
addpath(genpath('custom_toolboxes'))
mat_file = ['mat_files/','descriptor_1']; %check filename
load(mat_file); 
load(['mat_files/','max_rects']); 
no_of_images = size(descriptor,2);

I = dir('dataset/image/*.png');
P = dir('dataset/mask/*.png');
im_index = 1; %check filename

threshold = 0.5;
A=imread('input.png');
target_sky_mask = im2bw(imread('input_mask.png'));
%target_sky_mask = imresize(target_sky_mask,[500 500]);
target = imresize(A, [500 500]);
[~,rough_mask,res] = scene_parse(target);
F = res{1};
for i=1:size(target,1)
    for j=1:size(target,2)
        norm_F(i,j,:) = (F(i,j,:) - min(F(i,j,:)))/(max(F(i,j,:))-min(F(i,j,:)));

%%%%%%%%%% Compute target's descriptor '%%%%%%%%%%%
H = [];
sz = size(target);
m = prod(sz(1:2));
for gx = 1:3
    for gy = 1:3
        x = (floor(sz(1)/3))*gx;
        start_x = ((floor(sz(1)/3))*(gx-1)) + 1;
        y = (floor(sz(2)/3))*gy;
        start_y = ((floor(sz(2)/3))*(gy-1)) + 1;
        grid = norm_F(start_x:x,start_y:y,:); %check filename
        h = zeros(1,14);
        for label = 1:14
            h(label) = (1/m)*sum(sum(grid(:,:,label)));
        end
        H = [H; h];
    end
end
%global_histFig = figure('Name','Histogram','NumberTitle','off','Visible','off');
%global_hist = histogram(target(:,:,:),14,'BinLimits',[0 1],'Normalization','probability','Visible','off');
global_hist = histcounts(target(:,:,:),14);
global_hist = global_hist/max(max(global_hist));
H = [H; global_hist];
target_descriptor = H;

w = waitbar(0,'Finding candidate skies')
%%%%%%%%%% choose up to 5 skies to display %%%%%%%%%%%
chosen_sky = 1;
no_of_chosen_skies = 5;
visited = zeros([1,no_of_images]);
jk = 1; end_flag = 0;
options = [];
[T,~,~,max_target_region,tr1,tr2,tc1,tc2] = FindLargestRectangles((target_sky_mask),A);
t_width = tc2-tc1;
t_height = tr2-tr1;
P_ta = t_width/t_height;
P_ts = t_width*t_height;
end_flag = 0; chosen_sky = 1;
visited = zeros([1,no_of_images]);
semantic_similarity = [];
for k = 1:no_of_images
    source = imread(['dataset/image/',P(k).name]);
    source_sky_mask = im2bw(imread(['dataset/mask/',P(k).name]));
    
    if (max_rects(k).max_source_region == 0)
       continue;
    end
    [S,max_source_region] = [max_rects(k).S max_rects(k).max_source_region];
    [sr1,sr2,sc1,sc2] = max_rects(k).index;
    %% Compute Aspect Ratio and Resolution
    s_width = sc2-sc1;
    s_height = sr2-sr1;
    P_sa = s_width/s_height;
    P_ss = s_width*s_height;
    Q_s = min(P_ts,P_ss)/max(P_ts,P_ss);
    Q_a = min(P_ta,P_sa)/max(P_ta,P_sa);
    semantic_similarity = [semantic_similarity ; max(max(pdist2(descriptor(k).desc,target_descriptor)))];
    if max(max(pdist2(descriptor(k).desc,target_descriptor)))<threshold && Q_s>0.5 && Q_a>0.5
        options(chosen_sky)=k;
        chosen_sky = chosen_sky + 1;
    end
    close(w)
    w = waitbar(k/no_of_images,sprintf('percentage = %2.2f',(k*100)/no_of_images))
    if chosen_sky == 6
        break
    end
end

%[source,index]=select_image(no_of_chosen_skies,options,I);

%%%%%%%%% replace sky using the chosen image %%%%%%%%%%%
%source = imresize(source, [500 500]);
%target = imresize(target, [500 500]);
%source_sky_mask = (images(options(index)).maskIm==0);
%%[~,s_sky_mask] = scene_parse(images(index).image);
%%source_sky_mask = (s_sky_mask == 0);
%target_sky_mask = (maskIm == 0);
%[S,~,~,max_source_region,sr1,sr2,sc1,sc2] = FindLargestRectangles(source_sky_mask,source);
%[T,~,~,max_target_region,tr1,tr2,tc1,tc2] = FindLargestRectangles(target_sky_mask,target);
%source_sky = imresize(S,[size(T,1) size(T,2)]);
%final = target;
%final(tr1:tr2,tc1:tc2,:) = source_sky;

%source_sky=im2double(source_sky);

%figure('Name','Image for source sky selection','NumberTitle','off')
%imshow(source); %Display the superpixels of the image
%hold on;
%h2 = imfreehand;
%source_sky = im2double(h2.createMask);
%source = im2double(source);
%target = im2double(target);

%levels = 7;
%lpyramids_source = laplPyramid(target,levels); 
%lpyramids_target = laplPyramid(source,levels);
%blur_border = imgaussfilt(mat2gray(~source_sky),1.2);

%for k = 1:levels
%    blur_border = imresize(blur_border,[size(lpyramids_source(k).im,1) size(lpyramids_source(k).im,2)]);
%    blended(k).im(:,:,1) = (( (lpyramids_source(k).im(:,:,1)) .* blur_border) + ( (lpyramids_target(k).im(:,:,1)) .* (1-blur_border)))/255;
%    blended(k).im(:,:,2) = (( (lpyramids_source(k).im(:,:,2)) .* blur_border) + ( (lpyramids_target(k).im(:,:,2)) .* (1-blur_border)))/255;
%    blended(k).im(:,:,3) = (( (lpyramids_source(k).im(:,:,3)) .* blur_border) + ( (lpyramids_target(k).im(:,:,3)) .* (1-blur_border)))/255;
%end

%final = reconstruct(blended);
%figure;imshowpair(target,final,'montage');str = sprintf('Original & Final Image');title(str);
