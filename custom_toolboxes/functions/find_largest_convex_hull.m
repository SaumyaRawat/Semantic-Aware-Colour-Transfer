function[S,max_area,r1,r2,c1,c2]  = find_largest_convex_hull(mask,image)
	[rows,cols,~] = size(mask);
	
	end_flag = 0; col = 1; start = 0; last = 0;
	while end_flag~=1 && col<=cols
		column = mask(:,col);
		if start==0&&numel(find(column==1))~=0
			start = col;
		elseif start~=0&&numel(find(column==1))==0
			last = col-1;
			end_flag = 1;
		end
		col=col+1;
	end
	c2 = start;
	if last == 0
		last = cols;
	end
	c1 = last;
	
	end_flag = 0; start = 0; last = 0; row = 1;
	while row<=rows&&end_flag~=1
		row_vec = mask(row,:);
		if start==0&&numel(find(row_vec==1))~=0
			start = row;
		elseif start~=0&&numel(find(row_vec==1))==0
			last = row-1;
			end_flag = 1;
		end
		row=row+1;
	end
	r2 = start;
	r1 = last;

	S = image(r2:r1,c2:c1,:);
	max_area = prod(size(S,1),size(S,2));
end