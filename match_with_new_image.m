%%%%%% NOTE : drtoolbox should not be a part of the path since the function doesnt work in that case
addpath(genpath('custom_toolboxes'));
addpath('functions')
tic;
A=imread('input.jpg');
target = imresize(A, [500 250]);

%% Select bldg area for the target image whose sky is going to be replaced %%
    %% Use SLIC algo to compute the Superpixels and store in a structure array called Sp %%
    [l, Am, Sp, d] = slic(target, 300, 20, 0, 'mean');
    maskim = drawregionboundaries(l, target);
    %figure('Name','Image for bldg selection','NumberTitle','off')
    %imshow(maskim); %Display the superpixels of the image
    %hold on;

    %%Create a ROI manually that contains the sky region of the image %%
    %h1 = imfreehand;
    %maskIm = h1.createMask;

    [out_im,maskIm] = scene_parse(target);
    
    j = 1; l = 1;
    for i = 1:size(Sp,2)
        row = round (Sp(i).r);
        col = round (Sp(i).c);
        if(maskIm(row,col) == 0) %%Superpixel centre lies inside mask image
            skyPixels(j).row = row; %% stored as y,x NOT x,y
            skyPixels(j).col = col;
            skyPixels(j).L = Sp(i).L;
            skyPixels(j).a = Sp(i).a;
            skyPixels(j).b = Sp(i).b;
            skyPixels(j).stdL = Sp(i).stdL;
            skyPixels(j).stda = Sp(i).stda;
            skyPixels(j).stdb = Sp(i).stdb;
            j = j+1;
        end
        if(maskIm(row,col) ~= 0) %%Superpixel centre lies inside mask image
            Pixels(l).row = row; %% stored as y,x NOT x,y
            Pixels(l).col = col;
            Pixels(l).L = Sp(i).L;
            Pixels(l).a = Sp(i).a;
            Pixels(l).b = Sp(i).b;
            Pixels(l).stdL = Sp(i).stdL;
            Pixels(l).stda = Sp(i).stda;
            Pixels(l).stdb = Sp(i).stdb;
            l = l+1;
        end
    end
    noOfPixels = size(Pixels,2);
    noOfSkypixels = size(skyPixels,2);


%% Create FV for Building
    %% Create a histogram of pixels %%
    %%  create a list of values for each channel %%
    %% L %%
    array_L = zeros(size( Pixels,2),1);
    array_a = zeros(size( Pixels,2),1);
    array_b = zeros(size( Pixels,2),1);
    array_rgb = zeros(size( Pixels,2),3);
    array_xyz = zeros(size( Pixels,2),3);
    array_hsv = zeros(size( Pixels,2),3);
    array_cct = zeros(size( Pixels,2),3);


    for i=1:size( Pixels,2)
        array_L(i,1) =  Pixels(i).L;
        array_a(i,1) =  Pixels(i).a;
        array_b(i,1) =  Pixels(i).b;
        array_rgb(i,:) = [lab2rgb([ Pixels(i).L  Pixels(i).a  Pixels(i).b])];
    end

    array_ycbcr = rgb2ycc(array_rgb);
    array_hsv = rgb2hsv(array_rgb);

    %% YCBCR

    % Normalize to [0, 1]:
    m = min(array_ycbcr);
    range = repmat(max(array_ycbcr) - m,[size(array_ycbcr,1),1]);
    m=repmat(m,[size(array_ycbcr,1),1]);
    array_ycbcr = [array_ycbcr - m] ./ range;

    % Then scale to [x,y]:
    range2 = 1 - ( 3.03 * 10^-4 );
    norm_array_ycbcr = (array_ycbcr.*range2) + ( 3.03 * 10^-4 );


    %% HSV 
    m = min(array_hsv);
    range = repmat(max(array_hsv) - m,[size(array_hsv,1),1]);
    m=repmat(m,[size(array_hsv,1),1]);
    array_hsv = (array_hsv - m) ./ range;

    % Then scale to [x,y]:
    range2 = 1 - ( 3.03 * 10^-4 );
    norm_array_hsv = (array_hsv.*range2) + ( 3.03 * 10^-4 );

    %% CCT
    array_cct = rgb2xyz(array_rgb);
    array_cct = xyz2xy(array_cct);
    array_cct = xy2cct(array_cct);


    %RedFig = figure('Name','Histogram of channel R','NumberTitle','off','Visible','off');
    %Red = histogram(array_rgb(:,1),32,'BinLimits',[0 1],'FaceColor','red','Normalization','probability','Visible','off');

    %GreenFig = figure('Name','Histogram of channel G','NumberTitle','off','Visible','off');
    %Green = histogram(array_rgb(:,2),32,'BinLimits',[0 1],'FaceColor','green','Normalization','probability','Visible','off');

    %BlueFig = figure('Name','Histogram of channel B','NumberTitle','off','Visible','off');
    %Blue = histogram(array_rgb(:,3),32,'BinLimits',[0 1],'FaceColor','blue','Normalization','probability','Visible','off');

     LuminanceFig = figure('Name','Histogram of channel Y(luminance)','NumberTitle','off','Visible','off');
     Luminance = histogram(log2(norm_array_ycbcr(:,1)),32,'BinLimits',[0 1],'FaceColor','blue','Normalization','probability','Visible','off');

     SatFig = figure('Name','Histogram of channel S(Saturation)','NumberTitle','off','Visible','off');
     Sat = histogram(log2(norm_array_hsv(:,2)),32,'BinLimits',[0 1],'FaceColor','blue','Normalization','probability','Visible','off');
    
     CCTFig = figure('Name','Histogram of CCT','NumberTitle','off','Visible','off');
     CCT = histogram(array_cct(:),32,'BinLimits',[1500, 20000],'FaceColor','blue','Normalization','probability','Visible','off');

     %Feature = [ Red.Values  Green.Values  Blue.Values  Luminance.Values  Sat.Values  CCT.Values];
     Feature = [ Luminance.Values  Sat.Values  CCT.Values];

idx=knnsearch(bldgData,Feature,'k',1,'Distance','euclidean'); %Find the most similar image from the database 
cIdx=bldg_assignments(idx); % Find the bldg cluster this new image belongs to

%cIdx =  cluster(gmmDist, Feature);
%disp(cIdx)
cluster_of_new_im = find(bldg_assignments==cIdx); %% Returns all images of that building cluster

sky_assignments_of_bldg_cluster = sky_assignments(cluster_of_new_im);
%% unique skies in this cluster %%
[ uniq_skies, ia, ic] = unique(sky_assignments_of_bldg_cluster);

%%%%%%%%%% choose up to 5 skies to display %%%%%%%%%%%
chosen_sky = 1;
no_of_chosen_skies = 5;
visited = zeros([1,numData]);
jk = 1; end_flag = 0;
options = [];
while chosen_sky<6 && end_flag~=1
    for ind = 1:size(uniq_skies,1)
        a=find(ic==ind);    %gives indices corr to cluster_of_new_im
        z = find(visited==0);
        common = intersect(cluster_of_new_im(a),z);    %any image that has not been compared with target and falls in the same building cluster as target's NN'
        if numel(common) ~= 0
            visited(common(jk)) = 1;
            if pdist2(images(common(jk)).bldgFeature,Feature)<threshold && (images(common(jk)).skySize - noOfSkypixels) < sky_size_thresh
                options(chosen_sky)=common(jk);
                chosen_sky = chosen_sky + 1;
            end
        end
        vis_nodes = find(visited==1);
        if size(vis_nodes,2)>=size(cluster_of_new_im,1)
            no_of_chosen_skies = chosen_sky-1;
            end_flag = 1;
        end
    end
end

%msize = numel(cluster_of_new_im);
%options=cluster_of_new_im(randperm(msize, 4));
%options = ia;
[source,index]=select_image(no_of_chosen_skies,options,images);

%%%%%%%%% replace sky using the chosen image %%%%%%%%%%%
source = imresize(source, [500 500]);
target = imresize(target, [500 500]);
source_sky_mask = (images(options(index)).maskIm==0);
%[~,s_sky_mask] = scene_parse(images(index).image);
%source_sky_mask = (s_sky_mask == 0);
target_sky_mask = (maskIm == 0);
[S,~,~,max_source_region,sr1,sr2,sc1,sc2] = FindLargestRectangles(source_sky_mask,source);
[T,~,~,max_target_region,tr1,tr2,tc1,tc2] = FindLargestRectangles(target_sky_mask,target);
source_sky = imresize(S,[size(T,1) size(T,2)]);
final = target;
final(tr1:tr2,tc1:tc2,:) = source_sky;

%fim=mat2gray(source);
%level=graythresh(fim);
%bwfim=im2bw(fim,level);
%[source_sky,level0]=fcmthresh(fim,0);
%imwrite(source_sky,'sky_segmentation.jpg'); %% mask for source sky
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
figure;imshowpair(target,final,'montage');str = sprintf('Original & Final Image');title(str);

toc;



