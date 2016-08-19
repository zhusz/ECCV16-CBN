% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

clear;
addpath(genpath('../../../matlab'));
addpath(genpath('../../../codes'));
GPU_ID = 0;

img_root = './image_source/';
a = dir([img_root '*.png']);
nameList = {a.name}';
a = dir([img_root '*.jpg']);
nameList = [nameList; {a.name}'];

m = length(nameList);
win_size_top = 256;

images = cell(m,1);
FaceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
bboxVJ = NaN * zeros(m,4);
parfor i = 1:m
    img = imread([img_root nameList{i}]);
    if size(img,3) > 1, img = rgb2gray(img); end;
    img = im2single(img);
    images{i} = img;
    bb = step(FaceDetector,img);
    bb = [bb(:,1) bb(:,1)+bb(:,3) bb(:,2) bb(:,2)+bb(:,4)];
    if ~isempty(bb)
        [~,id] = max( (bb(:,2)-bb(:,1)) .* (bb(:,4)-bb(:,3)) );
        bboxVJ(i,:) = bb(id,:);
    end;
end;
valid = find(~isnan(bboxVJ(:,1)));
[nameList, images, bboxVJ] = indexingData(valid, nameList, images, bboxVJ);
m = length(valid);

ref_simple_face = [([0.4 0.6 0.412 0.588]-0.15)/0.7, ...
    ([0.3 0.3 0.52 0.52]-0.1)/0.7];
ref_simple_face = ref_simple_face * win_size_top;

mean_simple_face = [0.3170,0.6909,0.3411,0.6483,0.3944,0.3892,0.7883,0.7950];
% Statistics for VJ detection box, which is similar to
% https://github.com/zhusz/CVPR15-CFSS/blob/master/getParametricModels.m#L22

p = zeros(m,8);
p(:,1:4) = repmat(bboxVJ(:,1),1,4) + ...
    repmat(mean_simple_face(:,1:4),m,1) .* repmat(bboxVJ(:,2)-bboxVJ(:,1),1,4);
p(:,5:8) = repmat(bboxVJ(:,3),1,4) + ...
    repmat(mean_simple_face(:,5:8),m,1) .* repmat(bboxVJ(:,4)-bboxVJ(:,3),1,4);

T = getTransToSpecific(p, ref_simple_face);

win_size = 16; 
h = zeros([win_size win_size 1 m],'single');
parfor i = 1:m
    img = imtransform(images{i}, T(i), 'bicubic', 'XData', [1 win_size_top], ...
        'YData', [1 win_size_top], 'XYScale', 1);
    img = imresize(img, 16 / 256);
    h(:,:,:,i) = img;
end;

% h is our input
% Begin hallucinating
h4 = CBN(h);

%% view the result
for i = 1:1000, imshow(h4(:,:,:,i)); hold on; pause();end;
