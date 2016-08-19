% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function T = getTransViaMerge(win_size,varargin)

% T = getTransViaMerge(win_size,T1,T2,...)
% y = T(x) = T_nargin(...(T2(T1(x))))
% T-s can only be similarity transform: rotate, scale, translate x/y
% Note T-s must have strict order: rotate > scale > translate
% rotate and scale only support: based on the center of patch (same win_size).
% otherwise, don't feel suprised to see this function fuck you.

m = length(varargin{1});
n = length(varargin);
for i = 2:n
    assert(m == length(varargin{i}));
end;
x_old = repmat([win_size/2,win_size/2,win_size/2,win_size/2-win_size/3],m,1);
x = transPoseFwd(x_old,varargin{1});
for i = 2:n
    x = transPoseFwd(x,varargin{i});
end;
T = getTransPair(x_old,x);

end
