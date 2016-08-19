function h4 = CBN(h,GPU_ID)

if ~exist('GPU_ID','var'), GPU_ID = 7; end;
win_size_top = 256;
ref_simple_face = win_size_top * [([0.4 0.6 0.412 0.588]-0.15)/0.7, ...
    ([0.3 0.3 0.52 0.52]-0.1)/0.7];

m = size(h,4);
assert(m > 1); % Have problems if m == 1, in funcction batchForward the 
% blob might be squeezed out and hard to identify the number of samples.
% If you really want to test only one image, repeat it twice.

h = reshape(imresize(h, 2), [32 32 1 m]); 
h = batchForwardPDS('../',GPU_ID,{h},'sr1','D432','ndc_24fnc','1000000'); h = h{1};
h = reshape(imresize(h, 2), [64 64 1 m]); 
h = batchForwardPDS('../',GPU_ID,{h},'sr1','D464','ndc_12fnc','1000000'); h = h{1};
p = batchForwardPDS('../',7,{h(5:50,10:55,:,:)},'sr1','D80','pnt_222','1100000');
p = p{1}' * 46;
p(:,1:5) = p(:,1:5) + 9;
p(:,6:10) = p(:,6:10) + 4;
p = p * 4;
h = reshape(imresize(h, 4), [256 256 1 m]);
T = getTransToSpecific(selectPoses(p, [1 2 4 5]), ref_simple_face);
parfor i = 1:m
    h(:,:,:,i) = imtransform(h(:,:,:,i), T(i), 'bicubic', 'XData', [1 win_size_top], ...
        'YData', [1 win_size_top], 'XYScale', 1);
end;

h0 = reshape(imresize(h, 16 / 256), [16 16 1 m]);
h1 = reshape(imresize(h0, 2), [32 32 1 m]); 
h1 = batchForwardPDS('../',GPU_ID,{h1},'sr1','D432','ndc_24fnc','1000000'); h1 = h1{1};
h2 = reshape(imresize(h1, 2), [64 64 1 m]); 
h2 = batchForwardPDS('../',GPU_ID,{h2},'sr1','D464','ndc_12fnc','1000000'); h2 = h2{1};
p = batchForwardPDS('../',7,{h2(5:56,7:58,1,:)},'sr1','D81','pnt_222','2860000'); p = p{1};
p = p' * 52;
p(:,1:size(p,2)/2) = p(:,1:size(p,2)/2) + 6;
p(:,1+size(p,2)/2:end) = p(:,1+size(p,2)/2:end) + 4;
p1 = p;
mask1 = pt2mask(p1 / 2, 32, 1);
input1 = reshape(imresize(h0, 2), [32 32 1 m]); 
h1 = batchForwardPDS('../',GPU_ID,{input1,mask1},'sr1','D432','jnt_24fnc','210000'); h1 = h1{1};

input2 = cat(3,reshape(imresize(h1, 2), [64 64 1 m]),reshape(imresize(input1, 2), [64 64 1 m]));
h2 = batchForwardPDS('../',GPU_ID,{input2},'sr1','D464_3B','ndc_12fnc','1000000'); h2 = h2{1};
p = batchForwardPDS('../',GPU_ID,{h2(5:56,7:58,1,:)},'sr1','D82','pnt_222','1000000'); p = p{1};
p = p' * 52;
p(:,1:size(p,2)/2) = p(:,1:size(p,2)/2) + 6;
p(:,1+size(p,2)/2:end) = p(:,1+size(p,2)/2:end) + 4;
p2 = p;
mask2 = pt2mask(p2, 64, 3);
h2 = batchForwardPDS('../',GPU_ID,{input2,mask2},'sr1','D464_3B','jnt_12fnc', '230000'); h2 = h2{1};

input3 = reshape(imresize(h2, 2), [128 128 1 m]);
h3 = batchForwardPDS('../',GPU_ID,{input3},'sr1','D4128_5C','ndc_12fnc','740000'); h3 = h3{1};
p = batchForwardPDS('../',GPU_ID,{h3(9:112,13:116,:,:)},'sr1','D83','pnt_222','2000000'); p = p{1};
p = p' * 104;
p(:,1:size(p,2)/2) = p(:,1:size(p,2)/2) + 12;
p(:,1+size(p,2)/2:end) = p(:,1+size(p,2)/2:end) + 8;
p3 = p;

mask3 = pt2mask(p3 * 1, 128, 5);
input3 = reshape(imresize(h2, 2), [128 128 1 m]);
h3 = batchForwardPDS('../',GPU_ID,{input3,mask3},'sr1','D4128_5C','msk_12fnc','1530000'); h3 = h3{1};
mask4 = pt2mask(p3 * 2, 256, 7);
input4 = reshape(imresize(h3, 2), [256 256 1 m]);
h4 = batchForwardPDS('../',GPU_ID,{input4,mask4},'sr1','D4256_7C','msk_12fnc','70000',1,16); h4 = h4{1};

end
