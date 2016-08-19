% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function newImages = transImagesFwd(oldImages,T,rows,cols)
%newImages = transImagesFwd(oldImages)
%   images are all cell array.

m = length(oldImages);
if m~=length(T),error('size(oldImages,1) must equal to length(T)!');end;

if 0 % (m<100) || (matlabpool('size')==0)
    newImages = arrayfun(@(i)imtransform(oldImages{i},T(i),'XData',...
        [1 cols],'YData',[1 rows],'XYScale',1),1:m,'UniformOutput',false);
    if (m>=100)
        warning('Please launch matlabpool to speed up your program!');
    end
else
    newImages = cell(m,1);
    parfor i = 1:m
        img = imtransform(oldImages{i},T(i),'XData',...
            [1 cols],'YData',[1 rows], 'XYScale', 1);
        if size(img,1) ~= rows || size(img,2) ~= cols
            error('Now it is not allowed to imresize after imtransform!');
            newImages{i} = imresize(img, [rows, cols]);
        else
            newImages{i} = img;
        end;
    end
end
for i = 1:m, if size(newImages{i},1)~=rows || size(newImages{i},2)~=cols, newImages{i} = imresize(newImages{i},[rows,cols]);end;end;

end

