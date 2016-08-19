% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function [selectedPose,ind] = selectPoses(pose,sub,d)

if nargin<3
    d = 2;
end;
ind = selectPosesIdx(size(pose,2),sub,d);
selectedPose = pose(:,ind);

end

