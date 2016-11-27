function[acc_matrix] = imdist(im)
	[rows,cols] = size(im);
	acc_matrix = zeros(rows,cols);
	acc_matrix(1,:) = im(1,:);
	acc_matrix(:,1) = im(:,1);

	for i = 2:rows
	    for j = 2:cols
	        if im(i,j) == 0
	            acc_matrix(i,j) = min([acc_matrix(i-1,j),acc_matrix(i,j-1),acc_matrix(i-1,j-1)])+1;
	        else
	            acc_matrix(i,j) = 0;
	        end
	    end
	end
end