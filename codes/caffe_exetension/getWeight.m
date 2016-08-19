% Assumes path to matcaffe has been included
function m = getWeight(net)

n_layer = length(net.layer_names);
m.layer = cell(n_layer, 2);
m.layer_names = net.layer_names;
m.layer_sizes = cell(n_layer,3);
for i = 1:length(net.layer_names)
    m.layer_sizes{i,3} = cell2mat(net.layer_names(i));
    for j = 1:length(net.layer_vec(net.name2layer_index(cell2mat(net.layer_names(i)))).params)
        m.layer{i,j} = net.layer_vec(net.name2layer_index(cell2mat(net.layer_names(i)))).params(j).get_data();
        m.layer_sizes{i,j} = size(m.layer{i,j});
    end;
end;

end


