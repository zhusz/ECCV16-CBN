% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function T = getTransViaScaling(scaling_vector,win_size)
%T = getTransViaScaling(scaling_vector,win_size)
%   T: m*1 t_concord
%   scaling_vector: m*1 around 1 (Don't arbitrarily large or small!)
%   win_size: scalar. Note the image must be square!

assert(size(scaling_vector,1)==1 || size(scaling_vector,2)==1);
scaling_vector = scaling_vector(:);
win_cent = win_size / 2;
win_del = win_cent * 2 / 3;

pose_dst = zeros(length(scaling_vector),4);
pose_dst(:,[1 3 4]) = win_cent;
pose_dst(:,2) = win_cent + win_del * scaling_vector;
pose_src = repmat([win_cent win_cent+win_del win_cent win_cent],size(scaling_vector,1),1);

T = getTransPair(pose_src,pose_dst);

end

