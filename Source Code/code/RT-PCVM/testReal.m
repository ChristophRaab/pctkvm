close all;
clear all;
addpath(genpath('../../libsvm/matlab'));
addpath(genpath('../../data'));
addpath(genpath('../result'));
addpath(genpath('../code'));

options.ker = 'rbf';      % TKL: kernel: | 'rbf' |'srbf | 'lap'
testSize = 1;
% for strData = {'org_vs_people','org_vs_place', 'people_vs_place'} %
%     
%     accResult = [];
%     errResult = [];
%     aucResult = [];
%     timeResult = [];
%     nvecResult = [];
%     
%     for iData = 1:2
%         for i=1:testSize
%             data = char(strData);
%             data = strcat(data, '_', num2str(iData));
%             load(strcat('../data/Reuters/', data));
%             
%             fprintf('data=%s\n', data);
%             Z =full(Xs);
%             X = full(Xt);
%             Z=bsxfun(@rdivide, bsxfun(@minus,Z,mean(Z)), std(Z));
%             X=bsxfun(@rdivide, bsxfun(@minus,X,mean(X)), std(X));
%             Z = Z';X = X';
%             soureIndx = crossvalind('Kfold', Ys, 2);
%             targetIndx = crossvalind('Kfold', Yt, 2);
%             
%             Z = Xs(find(soureIndx==1),:);
%             Ys = Ys(find(soureIndx==1),:);
%             
%             
%             X = Xt(find(targetIndx==1),:);
%             Yt = Yt(find(targetIndx==1),:);
%             
%             options.theta = 2;
%             model = rtpcvm_train(full(Z),full(Ys),full(X),options);
%             [erate, nvec, label, y_prob] = rtpcvm_predict(Yt,model);
%             erate = erate*100;
%             acc = 100-erate;
%             fprintf('\nPCVM %.2f%% \n', acc);
%         end
%     end
% end

%--------------------------------------------------------------------------
options.theta = 1;

src = char('webcam');
tgt = char('Caltech10');
data = strcat(src, '_vs_', tgt);

load(['../../data/OfficeCaltech/' src '_SURF_L10.mat']);
fts = fts ./ repmat(sum(fts, 2), 1, size(fts, 2));
Z = zscore(fts, 1);
Ys = labels;


load(['../../data/OfficeCaltech/' tgt '_SURF_L10.mat']);
fts = fts ./ repmat(sum(fts, 2), 1, size(fts,2));
X = zscore(fts, 1);
Yt = labels;
%

% model = rtpcvm_train(Z,Ys,X,options);
% [erate, nvec, label, y_prob] = rtpcvm_predict(Yt,model);
% erate = erate*100;
% acc = 100-erate;
% fprintf('\nPCVM %.2f%% \n', acc);

%--------------------------------------------------------------------------

options.theta = 2;

for ngData = {'comp_vs_rec','comp_vs_sci','comp_vs_talk','rec_vs_sci','rec_vs_talk','sci_vs_talk'}%
    
    for j=[1,8,14,20,28,32]
        
        data = char(ngData);
        data = strcat(data, '_', num2str(j));
        load(strcat('../../data/20Newsgroup/', data));
        fprintf('data=%s\n', data);
        
        % Z-Transformation
        Xs=bsxfun(@rdivide, bsxfun(@minus,Xs,mean(Xs)), std(Xs));
        Xt=bsxfun(@rdivide, bsxfun(@minus,Xt,mean(Xt)), std(Xt));
        
        Xs = Xs';
        Xt = Xt';
        soureIndx = crossvalind('Kfold', Ys, 2);
        targetIndx = crossvalind('Kfold', Yt, 2);
        
        Z = Xs(find(soureIndx==1),:);
        Ys = Ys(find(soureIndx==1),:);
        
        
        X = Xt(find(targetIndx==1),:);
        Yt = Yt(find(targetIndx==1),:);
        
        model = rtpcvm_train(Z,Ys,X,options);
        [erate, nvec, label, y_prob] = rtpcvm_predict(Yt,model);
        erate = erate*100;
        acc = 100-erate;
        fprintf('\nPCVM %.2f%% \n', acc);
        
    end
end
