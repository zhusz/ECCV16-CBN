% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function ind = selectPosesIdx(len,sub,d)

if nargin<3
    d = 2;
end
assert(mod(len,d)==0);
gap = len/d;
ind = [];
sub = sub(:)';
for i = 1:d
    ind = [ind sub + (i-1)*gap];
end

end

