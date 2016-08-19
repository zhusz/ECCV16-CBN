function createH5DataTest(confirm_current_project)

directory = pwd;
directory_split = strsplit(directory, '/');
P = directory_split{end-1};
D = directory_split{end};

% ====================================================== %
assert(strcmp(P,confirm_current_project)); % in case you are operating in a wrong dir
% The current directory should be in the D one
% load(['Mat/' D '_info_root.mat'], 'batch_sample_tot','var_name','testing_sample_tot');
load(['Mat/' D '_info_root.mat'], 'H5Info');
var_name = H5Info.var_name;
batch_sample_tot = H5Info.batch_sample_tot;
testing_sample_tot = H5Info.testing_sample_tot;

var_name = sort(var_name);
datum_name = var_name;
for i = 1:length(datum_name), datum_name{i} = ['/' datum_name{i}]; end;
datum = cell(length(datum_name),1);
for i = 1:length(var_name)
    eval(['load(''Mat/' D '_test.mat'', ''' var_name{i} ''');']);
    eval(['datum{i} = ' var_name{i} ';']);
    eval(['clear ' var_name{i} ';']);
end;
M = testing_sample_tot;
chunksz = 64;
verbose = 1;
setName = 'test';
clear var_name testing_sample_tot;
% ====================================================== %

data_root = ['../Data/d-' D '/'];
data_root_forPrint = ['examples/' P '/Data/d-' D '/'];
mkdir(data_root);
h5_count = 0;
datum_size = cell(length(datum),1);
for i = 1:length(datum), datum_size{i} = size(datum{i}); disp(datum_size{i}); end;
fid = fopen([data_root P '-' D '-' setName '.txt'],'w');

for batch = 1: ceil(M / chunksz)
    if batch == 1 || accumulated_h5_size >= batch_sample_tot % NEEDS MODIFYING!!!
        h5_count = h5_count + 1;
        h5_fn = [P '-' D '-' setName '-' num2str(h5_count) '.h5'];
        fprintf(fid,'%s\n',[data_root_forPrint h5_fn]);
        create_new_h5file(data_root, h5_fn,datum_name,datum_size,chunksz);
        accumulated_h5_size = 0;
    end;

    current_sample_ID = (batch-1) * chunksz;
    % Note current_sample_ID always refers to the input data
    % If we change to a new HDF5 file, the current_sample_ID does NOT go
    % back to 1!!!
    for i = 1:length(datum)
        batch_datum = getMatAccordingToDim(datum{i},ndims(datum{i}),...
            current_sample_ID+1:min(current_sample_ID+chunksz, M));
        accumulated_h5_size = writeToHDF5(data_root, h5_fn, batch_datum, datum_name{i}, i);
    end;
    %FUNCTION OF CREATEH5 SHOULD BE SEPARATED!!!
    if verbose
        fprintf('Finished Batch ID = %d in the h5 file ID = %d.\n', batch, h5_count);
    end;
end;

fclose(fid);

end

function create_new_h5file(data_root, h5_fn,datum_name,datum_size,chunksz)

if exist([data_root h5_fn], 'file')
    delete([data_root h5_fn]);
    warning(['H5 file ' h5_fn ' has existed!']);
end;
len = length(datum_name); assert(len == length(datum_size));
for i = 1:len
    h5create([data_root h5_fn],datum_name{i},[datum_size{i}(1:end-1) Inf],...
        'Datatype', 'single', 'ChunkSize', [datum_size{i}(1:end-1) chunksz]);
end;

end

function accumulated_h5_size = writeToHDF5(data_root, h5_fn, batch_datum, batch_datum_name, datum_ID)

info = h5info([data_root h5_fn]);
equalAssert(ndims(batch_datum),length(info.Datasets(datum_ID).Dataspace.Size));
for i = 1:ndims(batch_datum)-1
    equalAssert(size(batch_datum,i),info.Datasets(datum_ID).Dataspace.Size(i));
end;
startLoc = ones(1,ndims(batch_datum));
startLoc(end) = info.Datasets(datum_ID).Dataspace.Size(end) + 1;
h5write([data_root h5_fn], batch_datum_name, single(batch_datum), startLoc, size(batch_datum));
info = h5info([data_root h5_fn]);
accumulated_h5_size = info.Datasets(datum_ID).Dataspace.Size(end);

end

