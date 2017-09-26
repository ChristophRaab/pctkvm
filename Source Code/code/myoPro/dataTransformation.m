function [Xs,Xt,Ys,Yt] = dataTransformation(dofs)
% dofs ==1: All available DoFs
% dofs ==2: Hand Open / Hand Closed
% dofs ==3: Hand Open / Neutral / Hand Closed
% dofs ==4: Supination / Pronation
% dofs ==5: Supination / Neutral / Pronation
% dofs ==6: Hand Open / Hand Closed / Supination / Pronation

if ~exist('dofs', 'var')
    dofs = 1; %Degrees of Freedom
end
fprintf('Degree of Freedom is set to %1.f\n',dofs);
participant = 'aschulz';%'cprahm';%'keckstein';%'bpaassen';
switch lower(participant)
    case 'aschulz'
        timeStamp   = '_left_2017.01.25';
        %timeStamp   = '_right_2017.01.05';
    case 'bpaassen'
        timeStamp   = '_left_2017.01.25';
        %timeStamp   = '_right_2017.01.24';
    case 'cprahm'
        timeStamp   = '_left_2017.01.27';
        %timeStamp   = '_right_2017.01.27';
    case 'keckstein'
        timeStamp   = '_left_2017.01.27';
        %timeStamp   = '_left_2017.01.27';
end
subFolder   = ['myodata_' participant timeStamp '/'];

% skip the first wpSteps samples from the evaluation woSteps = 30; % this is to communicate that the transitions of the movements % should be removed
model   = 'LVQ';
if ~isequal(lower(model), 'esn')
    woSteps = 1;
end
cutSequences = 1;
nMovesPerSeq = 8;

% load src data
nRuns_src   = 10;
path = [subFolder 'myodata_' participant timeStamp '_']; [X_src, Y_src, fold_idxs_src] = read_cut_emg_data(path, nRuns_src, model, 'src', woSteps, cutSequences, nMovesPerSeq);

% load target data
nRuns_tar   = 4;
[X_tar, Y_tar, fold_idxs_tar] = read_cut_emg_data(path, nRuns_tar, model, 'tar', woSteps, cutSequences, nMovesPerSeq);


if dofs == 1 || dofs == 6
    %Create one dimension label vector based on movement
    Cs = unique(Y_src)';
    Ct = unique(Y_tar)';
    
    if length(Cs) ~= length(Ct)
        error('Class labels do not match!')
    end
    
    if dofs == 6
        Cs = Cs(find(Cs~=0));
        Ct = Ct(find(Ct~=0));
        
    end
    
    Ys = zeros(size(Y_src,1),1);
    n = 1;
    
    for i = Cs
        for j = Cs
            inds = ismember(Y_src,[i j],'rows');
            Ys(inds)= n;
            n=n+1;
        end
    end
    
    Yt = zeros(size(Y_tar,1),1);
    n = 1;
    
    for i = Ct
        for j = Ct
            inds = ismember(Y_tar,[i j],'rows');
            Yt(inds)= n;
            n=n+1;
        end
    end
    
    
    if dofs == 6
        inds = find(Ys~=0);
        Ys= Ys(inds,:);
        Xs = X_src(inds,:);
        
        indt= find(Yt~=0);
        Yt= Yt(indt,:);
        Xt = X_tar(indt,:);
    else
        Xs = X_src; Xt =X_tar;
    end
    
elseif dofs == 2 ||dofs == 4
    
    if dofs == 2
        clm = 1;
    else
        clm =2;
    end
    Y_src = Y_src(:,clm); Y_tar = Y_tar(:,clm);
    ms = ismember(Y_src,[1 -1]);
    inds = find(ms);
    Ys= Y_src(inds,:);
    Xs = X_src(inds,:);
    
    mt = ismember(Y_tar,[1 -1]);
    indt= find(mt);
    Yt= Y_tar(indt,:);
    Xt = X_tar(indt,:);
    
elseif dofs == 3
    Ys = Y_src(:,1); Yt = Y_tar(:,1); Xs = X_src; Xt =X_tar;
elseif dofs == 5
    Ys = Y_src(:,2); Yt = Y_tar(:,2); Xs = X_src; Xt =X_tar;
end

end
