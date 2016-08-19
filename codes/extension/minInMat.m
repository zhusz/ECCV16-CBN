function [v,i,j] = minInMat(A)

assert(ndims(A) <= 2);
[v,id] = min(A, [], 1);
[v,j] = min(v);
i = id(j);

end

