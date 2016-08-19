function TF = isIn(ele,s)
%TF = isIn(ele,s)
%   judge if ele is in the set s. return 0 or 1.
%   if ele is an array TF will also be an array.

TF = arrayfun(@(x)isempty(find(x==s,1)),ele);
TF = 1-TF;

end

