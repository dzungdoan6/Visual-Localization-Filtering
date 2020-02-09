function params = makeTransitionMatrix(num_states, params)
%MAKETRANSITIONMATRIX 
    params.E = [];
    for n = num_states
        
        E = sparse(n,n);
        for jj = 1 : n
            upper_bound = min(n, jj+params.Vmax+0.5);
            range = [jj:upper_bound];
            for ii = range
                prob = getProb(jj, ii, params.Vmax);
                if prob ~= 0
                    E(jj,ii) = prob;
                end
            end
        end
        params.E = blkdiag(params.E, E);
    end
   
    for jj = 1 : params.num_states
        E_row = params.E(jj,:);
        E_row = E_row ./ (sum(E_row));
        params.E(jj,:) = E_row;
    end
end

function prob = getProb(jj, ii, Vmax)
    if (ii < jj)
        prob = 0;
    elseif (ii - jj >= 0) && (ii - jj <= Vmax + 0.5)
        prob = 1;
    else
        prob = 0;
    end
end
