function data_out = getMatAccordingToDim(data_in, dim_ID, dim_index) %#ok<STOUT>

nd = ndims(data_in);
assert(length(dim_ID) == 1 && dim_ID <= nd);
dim_index = dim_index(:)';
assert(max(dim_index) <= size(data_in, dim_ID));

st = [];
for i = 1:dim_ID-1
    st = [st ':, ']; %#ok<AGROW>
end;
st = [st '[' num2str(dim_index) '], '];
for i = dim_ID+1: nd
    st = [st ':, ']; %#ok<AGROW>
end;
st = st(1:end-2);
eval(['data_out = data_in(' st ');']);

end

