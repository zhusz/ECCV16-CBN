function mask = pt2mask(ePnow, win_size_now, sq_half_size)

edge_idx = {18:22, 69:78, 23:27, 79:88, ...
    37:40, [37 42 41 40], 43:46, [43 48 47 46], ...
    89:105, ...
    49:55, 61:65, [61 68 67 66 65], [49 60:-1:55], ...
    1:17};

mask = zeros([win_size_now, win_size_now, length(edge_idx), size(ePnow,1)], 'single');
for j = 1:length(edge_idx)
    edge_sparse = selectPoses(ePnow, edge_idx{j});
    nj = size(edge_sparse, 2) / 2;
    parfor i = 1:size(ePnow,1)
        mask_ij = false(win_size_now,win_size_now);
        sx = edge_sparse(i,1:nj);
        sy = edge_sparse(i,1+nj:2*nj);
        x = interp1(1:nj,sx,1:0.02:nj,'cubic'); x = round(x);
        y = interp1(1:nj,sy,1:0.02:nj,'cubic'); y = round(y);
        assert(length(x) == length(y));
        for k = 1:length(x)
            mask_ij(max(1, y(k)-sq_half_size) : min(win_size_now, y(k)+sq_half_size), ...
                max(1, x(k)-sq_half_size) : min(win_size_now, x(k)+sq_half_size)) = true;
        end;
        mask(:,:,j,i) = mask_ij;
    end;
end;

end
