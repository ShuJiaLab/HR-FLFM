function [rowout,colout] = getMax(A,rowin,colin)
%GETMAX Summary of this function goes here
%   Detailed explanation goes here
[row,col] = find(A==max(max(A)));
if length(row)~=1
    distance = (row-rowin).^2 + (col-colin).^2;
    [disrow,discol] = min(distance);
    if length(disrow)==1
        rowout = row(disrow);
        colout = col(discol);
    else
        rowout = row(disrow(1));
        colout = col(discol(1));
    end
else
    rowout = row;
    colout = col;
end
end

