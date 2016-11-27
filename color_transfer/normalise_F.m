%clear; load ../dataset/matfiles/fcn_1.mat
function [vec] = normalise_F(vec)
    for j=1:size(vec,1)
        for k=1:size(vec,2)
            s=0;
            s = sum(vec(j,k,:));
            vec(j,k,:) = vec(j,k,:)./s;            
        end
    end

end
      