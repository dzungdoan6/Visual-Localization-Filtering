function [x0, w0] = initParticles(noisy_rot, noisy_loc, params)
%INITPARTICLEFS initializes particles from noisy measurements 
    
    % initialize particles and weights
    x0 = cell(params.num_particles, 1);
    w0 = zeros(params.num_particles, 1);
    
    for ii = 1 : params.num_particles
        
        % initialize particles from Gaussian distribution
        rot_init = mvnrnd(noisy_rot', params.sigma_rot_init);
        loc_init = mvnrnd(noisy_loc', params.sigma_loc_init);
        
        x0{ii} = [loc_init' ; rot_init'];
        w0(ii) = 1 / params.num_particles; % all particles share a same weight
    end
end

