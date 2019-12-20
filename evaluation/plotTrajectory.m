function plotTrajectory(info_gnd, info_pred)
%PLOTTRAJECTORY plots ground truth and predicted trajectories
    assert(length(info_gnd) == length(info_pred));
    
    figure;
    
    % stack ground truth and predicted locations
    x_pred = [];
    y_pred = [];
    
    x_gnd = [];
    y_gnd = [];
    for ii = 1 : length(info_gnd)
        x_pred = [x_pred ; info_pred{ii}.loc(1)];
        y_pred = [y_pred ; info_pred{ii}.loc(2)];

        x_gnd = [x_gnd ; info_gnd{ii}.loc(1)];
        y_gnd = [y_gnd ; info_gnd{ii}.loc(2)];
    end
    
    plot(x_gnd, y_gnd, 'Color', 'green', 'Marker',  'x', 'MarkerSize', 1, 'LineWidth', 4);
    hold on;
    
    plot(x_pred, y_pred, 'Color', 'red', 'Marker',  'o', 'MarkerSize', 1, 'LineWidth', 2);
    hold on;
    
    
    legend('ground truth', 'prediction');
    axis square
    axis off
end

