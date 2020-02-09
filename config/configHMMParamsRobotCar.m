function params = configHMMParamsRobotCar(num_states, dataset)
%CONFIGPARAMSHMM 
    params.Vmax = 10; % 5
    params.sigma = 0.06; 
    switch dataset.name
        case 'RobotCar'
            
            if strcmp(dataset.route, 'full')
                params.deviation_thr = 0.001; 
            elseif strcmp(dataset.route, 'alternate')
                params.deviation_thr = 0.01;
            end
        otherwise
            error('%s has not been implemented', dataset.name);
    end    
    
    params.num_states = num_states;
    params.init_dist = ones(num_states,1) * (1/num_states);
end

