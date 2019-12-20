clear;

%% Dependencies
addpath('libs/yael_matlab_linux64_v438'); % yael
run libs/vlfeat-0.9.21/toolbox/vl_setup % vl_feat

%% Add path
addpath('utils'); % utility codes
addpath('config'); % configuration codes

%% Configure dataset for experiment
route = 'alternate'; % route can be "alternate" or "full"
[dataset_dir, work_dir, sequences, sequence_lengths, ...
    sequence_numbers] = configRobotCar(route);

%% Load PCA and whitening matrices
fprintf('Load PCA and whitening matrices\n');
tic;
pcafn = [work_dir '/dnscnt_RDSIFT_K128_vlad_pcaproj.mat']; 
load(pcafn,'vlad_proj','vlad_lambda');
fea_dim = 4096; % new projected dimension
proj_matrix = single(vlad_proj(:,1:fea_dim)');
whiten_matrix = diag(1./sqrt(vlad_lambda(1:fea_dim)));
clearvars vlad_proj vlad_lambda
fprintf('\t===> Finished in %.2fs\n', toc);

%% Load codebook and index it
fprintf('Load and process codebook\n');
tic;
dictfn = [work_dir '/dnscnt_RDSIFT_K128.mat'];
load(dictfn,'CX');
CX = bsxfun(@rdivide, CX, sqrt(sum((CX.^2),1)) ); % normalize each visual word
codebook_kdtree = vl_kdtreebuild(CX);
k = size(CX, 2);
fprintf('\t===> Finished in %.2fs\n', toc);

%% Do feature extraction
for ii = 1 : sequence_numbers
    fprintf('\n==================================================\n');
    seq = sequences{ii};
    seq_len = sequence_lengths(ii);
    
    info_file = [dataset_dir '/' route '/' seq '.info']; % info file which contains image information
    
    % read info
    info = readInfoFile(info_file, seq_len);
    
    % extract feature
    
    fprintf('Extract features of sequence %s\n', seq);
    feature_file = [work_dir '/' seq '.mat'];
    fprintf('\tFeatures are stored in %s\n', feature_file);
    
    image_dir = [dataset_dir '/' route '/' seq];
    feature_vectors = zeros(fea_dim, seq_len, 'single');
    tic;
    for kk = 1:seq_len
        if mod(kk, 100) == 1, fprintf('Process image %d in %.2f\n', kk, toc); end
        
        image_name = info{kk}.image_name;
        
        image_path = [image_dir '/' image_name];
        fprintf('\t%s\n', image_path);
        
        % extract local features
        img = imread(image_path);
        img=rgb2gray(img);
        img = vl_imdown(img);
        [f, descs] = vl_phow(im2single(img));
        
        % root sift
        descs = single(descs);
        descs= bsxfun(@rdivide, descs, sum(abs(descs),1) + 1e-9 );
        descs= sqrt(descs);
        
        % compute vlad
        num_desc = size(descs, 2);
        nearest_ids = vl_kdtreequery(codebook_kdtree, CX, descs) ;
        assignments = zeros(k, num_desc, 'single');
        assignments(sub2ind(size(assignments), ...
            double(nearest_ids), 1:length(nearest_ids)))= 1;
        v = vl_vlad(descs, CX, assignments, 'NormalizeComponents');
        
        % post-process
        v = proj_matrix * v; % reduce dimension
        v = whiten_matrix * v; % whitening
        v = single(yael_vecs_normalize(v)); % L2-normalize
        
        % store
        feature_vectors(:, kk) = v;
    end
    fprintf(2, 'Save features to %s\n', feature_file);
    tic;
    save(feature_file, 'feature_vectors', '-v7.3');
    fprintf('\t===> Finished in %.2fs\n', toc);
end