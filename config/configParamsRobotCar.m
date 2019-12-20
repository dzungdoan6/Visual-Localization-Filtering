function [params] = configParamsRobotCar(route)
%CONFIGPARAMSROBOTCAR 
    switch route
        case 'alternate'
            % Parameters for initializing particles
            params.sigma_rot_init = diag([0.001, 0.001, 1]);
            params.sigma_loc_init = diag([10, 10, 10]);
            
            % Measurement sigma
            params.Sigma = diag([5 5 5 0.0001 0.0001 0.001]); 
            
             % Motion parameters
            params.euler_mu = [0.001 ; 0.00001 ; 0.01]; % mean
            params.euler_sigma(1) = 0.01; % standard deviation
            params.euler_sigma(2) = 0.00001; % standard deviation
            params.euler_sigma(3) = 0.1; % standard deviation

            params.loc_mu = [0.1 ; 0.1 ; 0.01]; % mean
            params.loc_sigma(1) = 1;  % standard deviation
            params.loc_sigma(2) = 1;  % standard deviation
            params.loc_sigma(3) = 0.1;  % standard deviation

        case 'full'
            error('Full route is coming soon');
    end
    
    
    
end

