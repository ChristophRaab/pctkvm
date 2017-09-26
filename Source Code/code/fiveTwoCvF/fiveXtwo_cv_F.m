% This script calculates the 5 x 2 cv F test statistic over the 15
% datasets of selected transfer learning methods. This will be repeated 10
% times to get an additional standart deviation. The datasets are generated
% from preprocessed versions of Reuters-21578, Office and
% Caltech-256. 

addpath(genpath('../../libsvm/matlab'));
addpath(genpath('../../data'));
addpath(genpath('../../result'));
addpath(genpath('../../code'));

clear all;
%% Reuters Dataset
options.ker = 'rbf';      % TKL: kernel: 'linear' | 'rbf' | 'lap'
options.eta = 2.0;           % TKL: eigenspectrum damping factor
options.gamma = 1.0;         % TKL: width of gaussian kernel
options.k = 100;              % JDA: subspaces bases
options.lambda = 1.0;        % JDA: regularization parameter
options.svmc = 10.0;         % SVM: complexity regularizer in LibSVM
options.g = 40;              % GFK: subspace dimension
options.tcaNv = 50;          % TCA: numbers of Vectors after reduction
options.theta = -1;

for strData = {'org_vs_people','org_vs_place', 'people_vs_place'} %
    for iData = 1:2
        data = char(strData);
        data = strcat(data, '_',num2str(iData));
        load(strcat('../../data/Reuters/', data));

        fprintf('data=%s\n', data);

        [ftresultErr,ftresultAuc,ftresultAcc,accResult,errResult,aucResult,timeResult,nvecResult,ormse] = fiveXtwo_run( Xs,Xt,Ys,Yt,options,data);


        name = strcat('../../result/fivetwo/fiveTwo_Only',data,'.mat');
        save(name,'ftresultErr','ftresultAuc','ftresultAcc','errResult','accResult','aucResult','timeResult','nvecResult','ormse');
    end
end


clear all;
%% OFFICE vs CALLTECH-256 Dataset
options.ker = 'rbf';         % TKL: kernel: 'linear' | 'rbf' | 'lap'
options.eta = 1.1;           % TKL: eigenspectrum damping factor
options.gamma = 1.0;         % TKL: width of gaussian kernel
options.g = 30;              % GFK: subspace dimension
options.k = 100;              % JDA: subspaces bases
options.lambda = 1.0;        % JDA: regularization parameter
options.svmc = 10.0;         % SVM: complexity regularizer in LibSVM
options.tcaNv = 50;          % TCA: numbers of Vectors after reduction
options.subspaceDim = 80;   %SA: Subspace Dimension
options.theta = 1;

srcStr = {'Caltech10', 'Caltech10', 'Caltech10', 'amazon', 'amazon', 'amazon', 'webcam', 'webcam', 'webcam', 'dslr', 'dslr', 'dslr'};
tgtStr = {'amazon', 'webcam', 'dslr', 'Caltech10', 'webcam', 'dslr', 'Caltech10', 'amazon', 'dslr', 'Caltech10', 'amazon', 'webcam'};


for iData = 1:12
    
    src = char(srcStr{iData});
    tgt = char(tgtStr{iData});
    data = strcat(src, '_vs_', tgt);
    
    load(['../../data/OfficeCaltech/' src '_SURF_L10.mat']);
    fts = fts ./ repmat(sum(fts, 2), 1, size(fts, 2));
    Xs = fts';
    Ys = labels;
    
    
    load(['../../data/OfficeCaltech/' tgt '_SURF_L10.mat']);
    fts = fts ./ repmat(sum(fts, 2), 1, size(fts,2));
    Xt = fts';
    Yt = labels;
    
    fprintf('data=%s\n', data);
    
    [ftresultErr,ftresultAuc,ftresultAcc,accResult,errResult,aucResult,timeResult,nvecResult,ormse]  = fiveXtwo_run( Xs,Xt,Ys,Yt,options,data);
   
    name = strcat('../../result/fivetwo/fiveTwo_Only',data,'.mat');
    save(name,'ftresultErr','ftresultAuc','ftresultAcc','errResult','accResult','aucResult','timeResult','nvecResult','ormse');
    
end




