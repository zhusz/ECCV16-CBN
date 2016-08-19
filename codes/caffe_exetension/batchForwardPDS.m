function output = batchForwardPDS(Proot, GPU_ID, input, P, D, S, iter, verbose, batch_size)

if ~exist('batch_size','var'), batch_size = 64; end;
if ~exist('verbose', 'var'), verbose = 1; end;

if verbose
    fprintf('BatchForwardPDS for %s, %s, %s, %s begins!\n', P, D, S, iter);
end;
caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(GPU_ID);
net = caffe.Net([Proot D '/' S '/network-' P '-' D '-' S '-deploy.prototxt'],...
    [Proot 'Model/m-' P '-' D '-' S '/' P '-' D '-' S '_iter_' iter '.caffemodel'],...
    'test');
if verbose
    tic; output = batchForward(net, input, [],  batch_size); toc;
else
    output = batchForward(net, input, [], batch_size);
end;

end
