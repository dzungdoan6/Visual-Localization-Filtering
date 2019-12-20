function angle = angularErrorEuler(eul_est, eul_gnd, sequence)
%ANGULARERROREULER 
    if ~exist('sequence', 'var')
        sequence = 'XYZ';
    end
    rotm_est = eul2rotm(eul_est, sequence);
    rotm_gnd = quat2rotm(eul_gnd);
    
    angle = angularErrorRotm(rotm_est, rotm_gnd);
end

