function T = getTransViaXY(XY,win_size)
%T = getTransViaXY(scaling_vector,win_size)
%   T: m*1 t_concord
%   XY: m*2 

m = size(XY,1);
assert(size(XY,2) == 2);
pose_src = zeros(m,4);
parfor i = 1:m
    pose_src(i,4) = norm(XY(i,:));
end;
pose_src = pose_src + win_size / 2;
pose_dst = pose_src + XY(:,[1 1 2 2]);

T = getTransPair(pose_src,pose_dst);

end

