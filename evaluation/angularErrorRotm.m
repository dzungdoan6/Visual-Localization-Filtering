function angle = angularErrorRotm(rotm_est, rotm_gnd)
%ANGULARERRORROTM 
    R = rotm_gnd' * rotm_est;
    trR = trace(R);
    angle = acos((trR - 1)/2);
    angle = rad2deg(angle);
end

