function [info_cell] = readInfoFile(file_path, num_image)
%READGTAINFO Read *.info file of GTA
    fid = fopen(file_path);
    tic;
    fprintf('\tRead %s ...', file_path);
    info_cell = cell(num_image, 1);
    idx = 1;
    while ~feof(fid)
        % read each line
        line = fgetl(fid);
        
        % parse image name and image path
        tmp = regexp(line, ' ', 'split');
        [root_path, image_name, extension] = fileparts(tmp{1});
        image_name = [image_name extension];
        
        % read 3D location
        loc(1,1) = str2double(tmp{2});
        loc(2,1) = str2double(tmp{3});
        loc(3,1) = str2double(tmp{4});
        
        % read orientation in quartenion
        rot(1,1) = str2double(tmp{5});
        rot(2,1) = str2double(tmp{6});
        rot(3,1) = str2double(tmp{7});
        rot(4,1) = str2double(tmp{8});
        
        % store in cell
        info.root_path = root_path;
        info.image_name = image_name;
        info.loc = loc;
        info.rot = rot;
        
        info_cell{idx} = info;
        idx = idx + 1;
    end
    fclose(fid);
    fprintf('in.... %.2fs\n', toc);
end

