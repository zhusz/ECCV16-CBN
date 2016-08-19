% Assumes path to matcaffe has been included
function m = getNetB(net)


n_layer = length(net.layer_names);
n_blob = length(net.blob_names);
m.layer = cell(n_layer, 2);
m.blob = cell(n_blob, 1);
m.L = cell(n_layer,1);
m.F = cell(n_blob,1);
m.layer_names = net.layer_names;
m.blob_names = net.blob_names;
m.layer_sizes = cell(n_layer,3);
m.blob_sizes = cell(n_blob,2);
for i = 1:length(net.layer_names)
    m.layer_sizes{i,3} = cell2mat(net.layer_names(i));
    for j = 1:length(net.layer_vec(net.name2layer_index(cell2mat(net.layer_names(i)))).params)
        m.layer{i,j} = net.layer_vec(net.name2layer_index(cell2mat(net.layer_names(i)))).params(j).get_diff();
        m.layer_sizes{i,j} = size(m.layer{i,j});
    end;
    if length(net.layer_vec(net.name2layer_index(cell2mat(net.layer_names(i)))).params) == 2
        n_nextLayerChannel = size(m.layer{i,2},1); assert(1 == size(m.layer{i,2},2));
        m.L{i} = [reshape(m.layer{i,1},[length(m.layer{i,1}(:))/n_nextLayerChannel, n_nextLayerChannel])' m.layer{i,2}];
    end;
end;
for i = 1:length(net.blob_names)
    m.blob{i} = net.blob_vec(net.name2blob_index(cell2mat(net.blob_names(i)))).get_diff();
    m.blob_sizes{i,1} = size(m.blob{i});
    m.blob_sizes{i,2} = cell2mat(net.blob_names(i));
    n_sample = m.blob_sizes{i,1}(end);
    m.F{i} = reshape(m.blob{i}, [length(m.blob{i}(:)) / n_sample, n_sample]);
end;



end


