clear aclear;
%% Dependencies
addpath('libs/yael_matlab_linux64_v438'); % yael
addpath(genpath('libs/Piotr-toolbox/toolbox-master')); % toolbox from Piotr Dollar

%% Add path
addpath('utils'); % utility codes
addpath('config'); % configuration codes
addpath('pf'); % particle filter codes
addpath('evaluation'); % evaluation codes

%% Configure dataset for experiment
route = 'alternate'; % route can be "alternate" (1km) or "full" (10km)
[dataset_dir, work_dir, sequences, sequence_lengths] = configRobotCar(route);

knn = 20; % number of nearest neighbors for searching

% split database and query sequences
seq_db = sequences(2:end);
seq_len_db = sequence_lengths(2:end);
seq_qr = sequences(1);
seq_len_qr = sequence_lengths(1);

% release unnecessary variables
clearvars sequences sequence_lengths

% parameters for localization
params = configMCVLParamsRobotCar(route);
params.num_particles = 1000;

%% Load database & query
fprintf('\nLoad database\n');
[db_vec, db_info] = loadData([dataset_dir '/' route], work_dir, seq_db, seq_len_db);
assert(size(db_vec, 2) == length(db_info));

fprintf('\nLoad query\n');
[qr_vec, qr_info_gnd] = loadData([dataset_dir '/' route], work_dir, seq_qr, seq_len_qr);
assert(size(qr_vec, 2) == length(qr_info_gnd));


%% Do localization
fprintf('\n========== DO LOCALIZATION ==========\n');
result_info = cell(size(qr_vec, 2), 1); % initialize cell to store predicted poses
tic;
for qr_idx = 1 : size(qr_vec, 2)

    if mod(qr_idx, 100) == 1, fprintf('\tProcess image %d in %.2f\n', qr_idx, toc); end
    
    qr = qr_vec(:,qr_idx);
    
    % Estimate noisy measurement
    [ranks, ~] = yael_nn(db_vec, qr, knn);
    retrieved_info = db_info(ranks);
    
    [noisy_loc, noisy_rot] = poseFromPlaceHypotheses(retrieved_info);
    
    if qr_idx == 1
        [states, weights] = initParticles(noisy_rot, noisy_loc, params);
    else
        % update particle's motions based on dynamic model
        states = updateMotion(states, params);
        
        % update particle's weights
        weights = updateWeights(states, noisy_loc, noisy_rot, params);
        
        % normalize weights
        weights = weights./sum(weights);
        
        % Resample particles based on their weights
        [states, weights, idx] = resample(states, weights, 'systematic_resampling');
    end
    
    % predict camera pose from particles
    [pred_loc, pred_rot] = predictPose(states, weights);
    
    % store result for evaluation
    result_info{qr_idx}.loc = pred_loc;
    result_info{qr_idx}.rot = pred_rot;
    
end

%% Evaluation
fprintf('\n========== DO EVALUATION ==========\n');
assert(length(result_info) == length(qr_info_gnd));
errors = [];
for ii = 1 : length(result_info)
    % calculate errors 
    err_loc = norm(result_info{ii}.loc - qr_info_gnd{ii}.loc);
    err_rot = angularErrorEuler(result_info{ii}.rot', qr_info_gnd{ii}.rot');
    errors = [errors ; [err_loc err_rot]];
end

mean_errors = mean(errors, 1);
median_errors = median(errors, 1);
fprintf('\tMedian error = %.2f m and %.2f deg\n', median_errors(1), median_errors(2));
fprintf('\tMean error = %.2f m and %.2f deg\n', mean_errors(1), mean_errors(2));

%% Plot ground truth and predicted trajectories
plotTrajectory(qr_info_gnd, result_info);
