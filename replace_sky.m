%% Compare between decriptors of all images and choose reference image %%
function[rough_mask,I_rep,I_ref,ref_region,norm_F,ref_im_name] = replace_sky(A,target_sky_mask,descriptor,max_rects)
    addpath(genpath('custom_toolboxes'))
    I = dir('dataset/image/*.png');
    P = dir('dataset/mask/*.png');
    target_sky_mask = im2bw(target_sky_mask);
    im_index = 1; %check filename
    threshold = 1.9;
    no_of_images = size(descriptor,2);
    %A=imread('input.png');
    %target_sky_mask = im2bw(imread('input_mask.png'));
    %target_sky_mask = imresize(target_sky_mask,[500 500]);
    target = imresize(A, [500 500]);
    [~,rough_mask,res] = scene_parse(target);
    F = res{1};
    for i=1:size(target,1)
        for j=1:size(target,2)
            m1 = min(F(i,j,:));
            m2 = max(F(i,j,:));
            norm_F(i,j,:) = (F(i,j,:) - m1) / (m2 - m1) ;
            sum1 = sum(norm_F(i,j,:));
            norm_F(i,j,:) = norm_F(i,j,:)/sum1;
        end
    end

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

    %%%%%%%%%% choose up to 5 skies to display %%%%%%%%%%%
    %w = waitbar(0,'Finding candidate skies')
    chosen_sky = 1;
    no_of_chosen_skies = 5;
    visited = zeros([1,no_of_images]);
    jk = 1; end_flag = 0;
    options = [];
    [~,~,~,max_target_region,tr1,tr2,tc1,tc2] = FindLargestRectangles((target_sky_mask),A);
    t_width = tc2-tc1;
    t_height = tr2-tr1;
    P_ta = t_width/t_height;
    P_ts = t_width*t_height;
    end_flag = 0; chosen_sky = 1;
    visited = zeros([1,no_of_images]);
    semantic_similarity = [];
    found = 0;

    for k = 1:no_of_images
        val = norm(descriptor(k).desc - target_descriptor);
        semantic_similarity = [semantic_similarity ; val];
    end

    [ASorted AIdx] = sort(semantic_similarity);

    for jk = 2:no_of_images
        k = AIdx(jk);
        source = imread(['dataset/image/',P(k).name]);
        source_sky_mask = im2bw(imread(['dataset/mask/',P(k).name]));

        if (max_rects(k).max_source_region == 0)
           continue;
        end
        S = max_rects(k).region; 
        max_source_region = max_rects(k).max_source_region;
        sr1 = max_rects(k).index(1);
        sr2 = max_rects(k).index(2);
        sc1 = max_rects(k).index(3); 
        sc2 =  max_rects(k).index(4);
        %% Compute Aspect Ratio and Resolution
        s_width = sc2-sc1;
        s_height = sr2-sr1;
        P_sa = s_width/s_height;
        P_ss = s_width*s_height;
        Q_s = min(P_ts,P_ss)/max(P_ts,P_ss);
        Q_a = min(P_ta,P_sa)/max(P_ta,P_sa);
        if Q_s>0.5 && Q_a>0.5
            options(chosen_sky)=k;
            chosen_sky = chosen_sky + 1;
        end
        if chosen_sky >= 5
            break
        end
    end
    if chosen_sky~=1
        [index]=select_image(4,options,I);
    end
    source = imread(['dataset/image/',I(options(index)).name]);
    ref_im_name = I(options(index)).name;
    %%%%%%%%% replace sky using the chosen image %%%%%%%%%%%
    S = max_rects(options(index)).region;
    [T,tmax_area,tr1,tr2,tc1,tc2]  = find_largest_convex_hull(target_sky_mask,A);
    source_sky = imresize(S,[size(T,1) size(T,2)]);
    I_rep = A;
    for i = 1:size(I_rep,1)
        for j=1:size(I_rep,2)
            if(target_sky_mask(i,j)==1)
                I_rep(i,j,:) = source_sky(i,j,:);
            end
        end
    end
    I_ref = source;
    [~,ref_region,~] = scene_parse(I_ref);
    %figure;imshowpair(target,I_rep,'montage');str = sprintf('Original & Final Image');title(str);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end