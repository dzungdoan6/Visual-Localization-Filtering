function [db_vec, db_info] = loadData_RobotCar(dataset_dir, work_dir, ...
    seq_db, seq_len_db)
%LOADDATABASE_ROBOTCAR loads feature vectors and information (location and
%orientation) database of Oxford RobotCar
    
    db_vec = [];
    db_info = {};
    for ii = 1 : length(seq_db)
        seq = seq_db{ii};
        seq_len = seq_len_db(ii);
        fprintf('\n\tLoad %s with length of %d\n', seq, seq_len);
        fea_file = [work_dir '/' seq '.mat'];
        info_file = [dataset_dir '/' seq '.info'];
        load(fea_file, 'feature_vectors');
        db_vec = [db_vec feature_vectors];
        info = readInfoFile(info_file, seq_len);
        db_info = [db_info ; info];
    end
end

