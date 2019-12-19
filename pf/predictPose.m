function [pred_loc, pred_rot] = predictPose(states, weights, sequence)
%PREDICTPOSE predict camera pose from a set of particles     

    if ~exist('sequence', 'var')
        sequence = 'XYZ';
    end
    
    num_particle = length(states); % number of particles
    
    %% predict 3D location from particles
    pred_loc = zeros(3,1);
    for ii = 1 : num_particle
        pred_loc = pred_loc + states{ii}(1:3)*weights(ii);
    end
    
    %% predict orientation from particles
    quat_all = zeros(4, num_particle); % concatenate all particle's orientations
    
    % convert orientation to quartenion
    for ii = 1 : num_particle
        rot_eul = states{ii}(4:6);
        quat_all(:, ii) = eul2quat(rot_eul', sequence)';
    end
    
    % calculate quarternion mean
    qWR_mean = rotqrmean(quat_all);
    
    % convert quartenion back to euler
    pred_rot = quat2eul(qWR_mean', sequence)';
    
end

