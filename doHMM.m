clear;
%% Dependencies
addpath('libs/yael_matlab_linux64_v438'); % yael
addpath(genpath('libs/Piotr-toolbox/toolbox-master')); % toolbox from Piotr Dollar

%% Add path
addpath('utils'); % utility codes
addpath('config'); % configuration codes
addpath('pf'); % particle filter codes
addpath('evaluation'); % evaluation codes
addpath('hmm'); % hmm codes

%% Configure dataset for experiment
dataset.name = 'RobotCar';
dataset.route = 'alternate'; % route can be "alternate" (1km) or "full" (10km)
[dataset_dir, work_dir, sequences, sequence_lengths] = configRobotCar(dataset.route);

KK = 20; % size of place hypotheses

% split database and query sequences
seq_db = sequences(2:end);
seq_len_db = sequence_lengths(2:end);
seq_qr = sequences(1);
seq_len_qr = sequence_lengths(1);

% release unnecessary variables
clearvars sequences sequence_lengths

%% Load database & query
fprintf('\nLoad database\n');
[db_vec, db_info] = loadData_RobotCar([dataset_dir '/' dataset.route], work_dir, seq_db, seq_len_db);
assert(size(db_vec, 2) == length(db_info));

fprintf('\nLoad query\n');
[qr_vec, qr_info_gnd] = loadData_RobotCar([dataset_dir '/' dataset.route], work_dir, seq_qr, seq_len_qr);

assert(size(qr_vec, 2) == length(qr_info_gnd));

%% Setting parameters
% parameters for HMM
params_hmm = configHMMParamsRobotCar(sum(seq_len_db), dataset);
fprintf('\nMake transition matrix\n');
tic;
params_hmm = makeTransitionMatrix(seq_len_db, params_hmm);
params_hmm.E = params_hmm.E'; 
fprintf('\tFinished in %.2fs\n', toc);


%% Do localization
fprintf('\n========== DO LOCALIZATION ==========\n');
result_info = cell(size(qr_vec, 2), 1); % initialize cell to store predicted poses
tic;
for qr_idx = 1 : size(qr_vec, 2)

    if mod(qr_idx, 100) == 1, fprintf('\tProcess image %d in %.2f\n', qr_idx, toc); end
    
    qr = qr_vec(:,qr_idx);
    
    % Compute belief
    if qr_idx == 1
        [ranks, belief] = filterImageIndices(db_vec, qr, KK, params_hmm);
    else
        [ranks, belief] = filterImageIndices(db_vec, qr, KK, params_hmm, belief);
    end
    
    % estimate 6-DoF pose from place hypotheses
    place_hypotheses_info = db_info(ranks);
    [pred_loc, pred_rot] = poseFromPlaceHypotheses(place_hypotheses_info);
    
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

