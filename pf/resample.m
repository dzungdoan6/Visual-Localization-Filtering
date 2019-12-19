function [xk, wk, idx] = resample(xk, wk, resampling_strategy)

    if ~exist('resampling_strategy', 'var')
        resampling_strategy = 'multinomial_resampling';
    end

    Ns = length(wk);  % Ns = number of particles

    % wk = wk./sum(wk); % normalize weight vector (already done)

    switch resampling_strategy
       case 'multinomial_resampling'
          with_replacement = true;
          idx = randsample(1:Ns, Ns, with_replacement, wk);
    %{
          THIS IS EQUIVALENT TO:
          edges = min([0 cumsum(wk)'],1); % protect against accumulated round-off
          edges(end) = 1;                 % get the upper edge exact
          % this works like the inverse of the empirical distribution and returns
          % the interval where the sample is to be found
          [~, idx] = histc(sort(rand(Ns,1)), edges);
    %}
       case 'systematic_resampling'
          % this is performing latin hypercube sampling on wk
          edges = min([0 cumsum(wk)'],1); % protect against accumulated round-off
          edges(end) = 1;                 % get the upper edge exact
          u1 = rand/Ns;
          % this works like the inverse of the empirical distribution and returns
          % the interval where the sample is to be found
          [~, idx] = histc(u1:1/Ns:1, edges);
       % case 'regularized_pf'      TO BE IMPLEMENTED
       % case 'stratified_sampling' TO BE IMPLEMENTED
       % case 'residual_sampling'   TO BE IMPLEMENTED
       otherwise
          error('Resampling strategy not implemented')
    end;

    %xk = xk(:,idx);                    % extract new particles
    xk = xk(idx);
    wk = repmat(1/Ns, Ns, 1);          % now all particles have the same weight

return;  % bye, bye!!!
