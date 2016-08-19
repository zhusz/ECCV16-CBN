% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function [v,i,j] = minInMat(A)

assert(ndims(A) <= 2);
[v,id] = min(A, [], 1);
[v,j] = min(v);
i = id(j);

end

