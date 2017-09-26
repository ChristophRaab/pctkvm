% % This script calculates the error, accuracy and auc values over the 222
% % subsets of selected transfer learning methods. This will be repeated 10
% % times to get an additional standart deviation. The datasets are generated
% % from preprocessed versions of Reuters-21578, 20-Newsgroup, Office and
% % Caltech-256.
%
addpath(genpath('../libsvm/matlab'));
addpath(genpath('../../data'));
addpath(genpath('../../result'));
addpath(genpath('../../code'));
u = 1;
result = [];

%% Reuters Dataset
% for strData = {'org_vs_people','org_vs_place', 'people_vs_place'}
% 
%     data = char(strData);
%     data = strcat(data, '_', num2str(1));
%     load(strcat('../../data/Reuters/', data));
% 
%     Xs=bsxfun(@rdivide, bsxfun(@minus,Xs,mean(Xs)), std(Xs));
%     Xt=bsxfun(@rdivide, bsxfun(@minus,Xt,mean(Xt)), std(Xt));
% 
%     mmdV = mmd(Xs',Xt',1);
%     result(u,1)= mmdV;
% 
%     [KLest, Hest, KL_means, H_means, N]=kl_estimation(full(Xs'),full(Xt'),1,1,0,10);
%     result(u,2)= KLest;
% 
%     fprintf('data=%s\n', data);
%     u = u+1;
% 
% end
% name = strcat('../../result/divergencies/reuter_mmd_kl_',char(strData),'.mat');
% save(name,'result');

%% OFFICE vs CALLTECH-256 Dataset
srcStr = {'Caltech10', 'Caltech10', 'Caltech10', 'amazon', 'amazon', 'amazon', 'webcam', 'webcam', 'webcam', 'dslr', 'dslr', 'dslr'};
tgtStr = {'amazon', 'webcam', 'dslr', 'Caltech10', 'webcam', 'dslr', 'Caltech10', 'amazon', 'dslr', 'Caltech10', 'amazon', 'webcam'};
result = [];
u = 1;
for iData = 1:12
    
    src = char(srcStr{iData});
    tgt = char(tgtStr{iData});
    data = strcat(src, '_vs_', tgt);
    
    load(['../../data/OfficeCaltech/' src '_SURF_L10.mat']);
    fts = fts ./ repmat(sum(fts, 2), 1, size(fts, 2));
    Xs = fts;
    
    
    load(['../../data/OfficeCaltech/' tgt '_SURF_L10.mat']);
    fts = fts ./ repmat(sum(fts, 2), 1, size(fts,2));
    Xt = fts;
%     
%     Xs=bsxfun(@rdivide, bsxfun(@minus,Xs,mean(Xs)), std(Xs));
%     Xt=bsxfun(@rdivide, bsxfun(@minus,Xt,mean(Xt)), std(Xt));
%     
%     mmdV = mmd(Xs,Xt,1);
%     result(u,1)= mmdV;
%     
%     [KLest, Hest, KL_means, H_means, N]=kl_estimation(full(Xs),full(Xt),1,1,0,10);
%     result(u,2)= KLest;
    
    fprintf('data=%s\n', data);
    
    u = u+1;
end
name = strcat('../../result/divergencies/image_mmd_kl_',data,'.mat');
save(name,'result');
