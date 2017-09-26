function [X, Y, fold_idxs_src] = read_cut_emg_data(path, nRuns, model, origin, woSteps, cutSequences, nMovesPerSeq)

X = [];
Y = [];

%srcDataSets = [1 2 3 5 6 7 8 9 10];
dataSets = 1:nRuns;
for r = dataSets
    dataSrc = load([path int2str(r) '_' origin '.mat'], ...
        'X_logVar', 'targets');
    
    % remove the intermediate states from the data for LVQ and LinReg
    if isequal(lower(model), 'lvq') || isequal(lower(model), 'linreg') || isequal(lower(model), 'elm')
        addr_vec = (abs(dataSrc.targets) <= 0.001) + (abs(dataSrc.targets) >= 0.99);
        addr_vec = logical(min(addr_vec, [], 2));
        X_tmp    = dataSrc.X_logVar(addr_vec, :);
        Y_tmp    = round(dataSrc.targets(addr_vec, :));
    else
        X_tmp    = dataSrc.X_logVar;
        Y_tmp    = dataSrc.targets;
    end
    
    lookAhead = 20;
    if isequal(lower(model), 'lvq') || isequal(lower(model), 'linreg')
        lookAhead = 10;
    end
    if cutSequences
        % split the sequences in patches of individual movements
        startIdx = [];
        endIdx   = [];
        idx      = 60;
        while idx+lookAhead<size(Y_tmp,1)
            % find the starting point of the curves
            if all(abs(Y_tmp(idx,:)) <= 0.01) && any(abs(Y_tmp(idx+lookAhead,:)) > 0.5)
                startIdx = [startIdx idx-(lookAhead-6+woSteps-1)];
                % find also the end of the curves
                for idxE=idx+lookAhead:idx+120
                    if any(abs(Y_tmp(idxE,:)) > 0.5) && all(abs(Y_tmp(idxE+lookAhead,:)) <= 0.01)
                        endIdx = [endIdx idxE+lookAhead];
                        idx    = idxE+20;
                        break;
                    end
                end
            else
                idx = idx+1;
            end
        end
    else
        startIdx = 1;
        endIdx   = size(dataSrc.targets,1);
    end
    
%     % check these points
%     figure; hold on
%     plot(dataSrc.targets)
%     plot(startIdx, zeros(size(startIdx,1)), 'go');
%     plot(endIdx, zeros(size(endIdx,1)), 'ro');


    currS = size(X,1);
    for idx = 1:numel(startIdx)
        %fold_idxs_src{nMovesPerSeq*(r-1)+idx} = size(X,1)+1:size(X,1)+size(X_tmp,1);
        fold_idxs_src{nMovesPerSeq*(r-1)+idx} = currS+startIdx(idx):currS+endIdx(idx);
        
    end

    X            = [X; X_tmp];
    Y            = [Y; Y_tmp];
end

