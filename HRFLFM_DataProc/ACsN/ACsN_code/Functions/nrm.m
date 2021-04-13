%    [out] = nrm(in)
%    Normalizes an n-dimensional matrix in
%

function [out] = nrm(in)

in = double(in);

in_max = in;
in_min = in ;

for i = 1:ndims(in)
    in_max = max(in_max);
    in_min = min(in_min);
end

out = (in - in_min)/(in_max- in_min);

end