function imgmaxv = getMaxv(imgsum)
%GETMAXV Summary of this function goes here
%   Detailed explanation goes here
[row,col] = size(imgsum);
[sortedValues,sortIndex] = sort(imgsum(:),'descend');
for i = 1:1:length(sortedValues)
    [rowi,coli] = ind2sub([row,col],sortIndex(i));
    if      imgsum(rowi-1,coli)<sortedValues(i)/2 && ...
            imgsum(rowi+1,coli)<sortedValues(i)/2 && ...
            imgsum(rowi,coli-1)<sortedValues(i)/2 && ...
            imgsum(rowi,coli+1)<sortedValues(i)/2 && ...
            imgsum(rowi-1,coli-1)<sortedValues(i)/2 && ...
            imgsum(rowi-1,coli+1)<sortedValues(i)/2 && ...
            imgsum(rowi+1,coli-1)<sortedValues(i)/2 && ...
            imgsum(rowi+1,coli+1)<sortedValues(i)/2
        continue
    else
        imgmaxv = sortedValues(i);
        disp(['Max Value: ',num2str(imgmaxv)])
        break
    end
end
end

