% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function T = getTransViaRotate(theta_vector,win_size)
%T = getTransViaRotate(theta_vector,win_size)
%   T: m*1 t_concord
%   theta_vector: m*1 in degree! Make sure abs(theta)<180
%   win_size: scalar. Note the image must be square!

warning('This function might get non-affine tform');
assert(size(theta_vector,1)==1 || size(theta_vector,2)==1);
theta_vector = theta_vector(:);
win_cent = win_size / 2;
win_del = win_cent * 2 / 3;

pose_src = zeros(length(theta_vector),4);
pose_src(:,[1 3]) = win_cent;
pose_src(:,2) = win_cent + win_del * cosd(theta_vector);
pose_src(:,4) = win_cent + win_del * sind(theta_vector);
pose_dst = [win_cent win_cent+win_del win_cent win_cent];

T = getTransToSpecific(pose_src,pose_dst);

end

