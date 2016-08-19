% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function ra = raRandPerm(n,k)
% K can be larger than N

times = ceil(k/n);
ra = zeros(n,times);
for i = 1:times,ra(:,i) = randperm(n)';end;
ra = ra(:)';
ra = ra(1:k);

end
