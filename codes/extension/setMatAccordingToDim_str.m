% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function s = setMatAccordingToDim_str(dim_tot, dim_ID, dim_index)
% output example: (:,:,[1 2 3 4], [2 3 5],:,[3])
% Outside you need to use eval to do this.

% Here dim_ID can be multiple as long as length(dim_ID) == length(dim_index), the former is array and latter is cell strcture

% Remember dim_index must be a cell strcture whose length is identical to
% the array dimID!!!

assert(length(dim_ID) == length(dim_index));
s = '(';
for i = 1:dim_tot
    h = find(dim_ID == i);
    assert(length(h) <= 1);
    if isempty(h)
        s = [s ':,'];
    else
        k = dim_index{h}(:)';
        s = [s '[' num2str(k) '],'];
    end;
end;
s(end) = ')';

end
