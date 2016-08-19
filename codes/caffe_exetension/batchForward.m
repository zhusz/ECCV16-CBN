function [outer,whole_blob_firstBatch] = batchForward(net, inter, input_indexing_dim,b,verbose)
% If some input object is not splitted by sample index, you should put a -1 (or any other negative value into input_indexing_dim)
% When input_indexing_dim is noted with 0, it indicates it uses the default last dim as the indexing dim)

% Note we only care about the output of the network here.
% Typically, if you want to watch the data blobs you only need to watch the first batch and observe it via our second output or outside this function by yourself
% If you really want to see the blob of one typically layer throughout all the data, you can modify the deploy prototxt and add that layer as another output blob. (Here we note you can really add additional free layer in the deploy prototxt regardless whether the origianl model has been trained)
% (insert a dummy concat layer at the bottom of the deploy prototxt)

if ~exist('verbose','var'), verbose = 0; end;
L = length(inter);
if ~exist('input_indexing_dim','var') || isempty(input_indexing_dim)
    input_indexing_dim = zeros(L,1);
end
for i = 1:L
    if input_indexing_dim(i) == 0
        input_indexing_dim(i) = ndims(inter{i});
    end;
end
assert(all(input_indexing_dim > 0));
first_dim = find(input_indexing_dim > 0, 1, 'first');
m = size(inter{first_dim},input_indexing_dim(first_dim));
for i = first_dim:L
    if input_indexing_dim(i) > 0
        assert(m == size(inter{i},input_indexing_dim(i)));
    end;
end;

if ~exist('b','var') || isempty(b)
    b = 64; % Only accept GPU mode. if net is in CPU then you must be insane to use this function. Directly use net.foward outside!!
end;
s = ceil(m / b);
for i = 1:s
    if mod(i,verbose) == 0, fprintf('Batch forward processing Batch %d / %d.\n', i, s); end;
    now = inter;
    dim_extract_index = (i-1)*b+1 : min(m, i*b);
    if length(dim_extract_index) == b
        dim_extract_index_throwin = dim_extract_index;
    else
        dim_extract_index_throwin = [dim_extract_index ones(1,b-length(dim_extract_index))];
    end;
    for j = 1:L
        if input_indexing_dim(j) > 0
            now{j} = getMatAccordingToDim(now{j}, input_indexing_dim(j), dim_extract_index_throwin);
        end;
    end;
    temp_out = net.forward(now);
    if i == 1
        outer = cell(length(temp_out), 1);
        for j = length(outer):-1:1
            output_indexing_dim(j) = ndims(temp_out{j}); % for now like this
            assert(size(temp_out{j},output_indexing_dim(j)) == b);
            sz = size(temp_out{j});
            sz(output_indexing_dim(j)) = m;
            outer{j} = zeros(sz);
        end;
        if nargout == 2
            whole_blob_firstBatch = getNet(net);
        end;
    end;
    for j = 1:length(temp_out)
        temp_out{j} = getMatAccordingToDim(temp_out{j},output_indexing_dim(j),1:length(dim_extract_index));
        eval(['outer{j}' setMatAccordingToDim_str(ndims(outer{j}), output_indexing_dim(j),{dim_extract_index}) ...
            ' = temp_out{j};']);
    end;
end;

end

