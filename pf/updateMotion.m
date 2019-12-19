function states_new = updateMotion(states,params)
                        
%UPDATEMOTION update noisy motion from dynamic  model 
    states_new = cell(params.num_particles, 1);
    
    for ii = 1 : params.num_particles
        
        % randomly sample velocity
        linear_velocity = mvnrnd(params.loc_mu, diag(params.loc_sigma.^2))';
        angular_velocity = mvnrnd(params.euler_mu, diag(params.euler_sigma.^2))';
        
        loc = states{ii}(1:3);
        rot = states{ii}(4:6);
        
        % update new location
        loc_new = loc + linear_velocity;
        
        % update new orientation
        rot_new = updateRotation(rot, angular_velocity);
        
        % new state
        states_new{ii} = [loc_new ; rot_new];
    end
    
end


function rot_new = updateRotation(rot, angular_velocity, sequence) 
    if ~exist('sequence', 'var')
        sequence = 'XYZ';
    end
    rot_DCM = angle2dcm(rot(1), rot(2), rot(3), sequence);
    vel_DCM = angle2dcm(angular_velocity(1), angular_velocity(2), angular_velocity(3), sequence);
    rot_new_DCM = vel_DCM * rot_DCM;
    [rot_new(1), rot_new(2), rot_new(3)] = dcm2angle(rot_new_DCM, sequence);
    rot_new = rot_new';
end



