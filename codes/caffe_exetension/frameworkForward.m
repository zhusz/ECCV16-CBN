% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function [outer] = frameworkForward(directory,P,D,S,iter,inter,input_indexing_dim,b,verbose,GPU_device)
% Directory should contain the P folder
% Directory should end with a /
% All P/D/S/iter should be string rather than cell structure or number

assert(directory(end) == '/');
if ~exist('verbose','var'), verbose = 0; end;
L = length(inter);
if ~exist('input_indexing_dim','var') || isempty(input_indexing_dim)
    input_indexing_dim = zeros(L,1);
end
if ~exist('b','var') || isempty(b)
    b = 64; % Only accept GPU mode. if net is in CPU then you must be insane to use this function. Directly use net.foward outside!!
end;
if ~exist('GPU_device','var') || isempty('GPU_device')
    GPU_device = 0;
end;

caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(GPU_device);
net = caffe.Net([directory P '/' D '/' S '/network-' P '-' D '-' S '-deploy.prototxt'],...
    [directory P '/Model/m-' P '-' D '-' S '/' P '-' D '-' S '_iter_' iter '.caffemodel'],...
    'test');

outer = batchForward(net, inter, input_indexing_dim, b, verbose);

end

