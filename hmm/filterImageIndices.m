function [ranks, belief] = filterImageIndices(db_vec, qr, knn, params, belief_prev_T)
%FILTERIMAGEINDICES finds place hypotheses using HMM
    D = yael_L2sqr (single(db_vec), single(qr));
    D = exp(-D./params.sigma);
    
    % Do filtering
    if ~exist('belief_prev_T', 'var')
        [belief, ~] = normalize(params.init_dist .* D);
    else
        
        deviation = std(belief_prev_T);
        if deviation >= params.deviation_thr
            [belief, ~] = normalize(params.init_dist .* D);
        else
            [belief, ~] = normalize((params.E * double(belief_prev_T)) .* D);
        end
        
    end
    [~, ranks] = sort(belief, 'descend');
    ranks = ranks(1:knn);
end

