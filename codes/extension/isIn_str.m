function [TF,TF_idx] = isIn_str(ele,s)
%TF = isIn_str(ele,s)
%   judge if ele is in the set s. return 0 or 1.
%   if ele is an array TF will also be an array.
%   all input are in cell form of strings

% TF = arrayfun(@(x)isempty(find(x==s,1)),ele);
% TF = 1-TF;

ele = ele(:); s = s(:);
TF = NaN * zeros(length(ele),1);
TF_idx = TF;
for i = 1:length(ele)
    id = find(cellfun(@(x)strcmp(x,ele{i}),s));
    if isempty(id)
        TF(i) = 0;
        TF_idx(i) = 0;
    else
        assert(length(id) == 1);
        TF(i) = 1;
        TF_idx(i) = id;
    end;
end;

end

