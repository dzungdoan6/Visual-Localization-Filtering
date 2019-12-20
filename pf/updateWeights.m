function weights = updateWeights(states, noisy_loc, noisy_rot, params)
%UPDATEWEIGHTS updates particle's weights based on noisy measurements and
%noisy motion
    Sigma_inv =  inv(params.Sigma); % pre-compute inverse
    weights = zeros(params.num_particles, 1); 
    for ii = 1 : params.num_particles
        o = [noisy_loc ; noisy_rot];
        s = states{ii};
        
        % calculate weight based on the difference between noisy
        % measurements and noisy motions
        diff = (o-s);
        w = exp( -diff' * Sigma_inv * diff );
        
        weights(ii, 1) = w;
    end
end

