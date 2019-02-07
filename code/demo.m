%% Matlab Demo file for the Probabilistic Transfer Kernel Vector Machine
% Orginal Publication
% Matlab Source code Raab, Christoph ; Schleif, Frank-Michael: 
% Transfer learning for the probabilistic classification vector machine. 
% In: Gammerman, A. ; Vovk, V. ; Luo, Z. ; Smirnov, E. ; Peeters, R. (Hrsg.):
% Proceedings of the Seventh Workshop on Conformal and Probabilistic Prediction and Applications,
%  Proceedings of Machine Learning Research. Bd. 91 : PMLR, 2018, S. 187–200
% http://proceedings.mlr.press/v91/raab18a.html

addpath(genpath('/libsvm'));
addpath(genpath('../data'));
addpath(genpath('../code'));

clear all;

%% Reuters Dataset
options.ker = 'rbf';      % TKL: kernel: 'linear' | 'rbf' | 'lap'
options.eta = 2.0;           % TKL: eigenspectrum damping factor
options.gamma = 1;         % TKL: width of gaussian kernel
options.k = 100;              % JDA: subspaces bases
options.lambda = 1.0;        % JDA: regularization parameter
options.svmc = 10.0;         % SVM: complexity regularizer in LibSVM
options.g = 40;              % GFK: subspace dimension
options.tcaNv = 50;          % TCA: numbers of Vectors after reduction
options.subspaceDim = 80;   %SA: Subspace Dimension
options.theta = 2;          %PCVM: Widht of Kernel

% 
for strData = {'org_vs_people','org_vs_place', 'people_vs_place'} %
    
    for iData = 1:2
        data = char(strData);
        data = strcat(data, '_', num2str(iData));
        load(strcat('../data/Reuters/', data));
        
        fprintf('data=%s\n', data);
        
        Xs=bsxfun(@rdivide, bsxfun(@minus,Xs,mean(Xs)), std(Xs));
        Xt=bsxfun(@rdivide, bsxfun(@minus,Xt,mean(Xt)), std(Xt));

        m = size(Xs, 2);
        n = size(Xt, 2);
        %% SVM
        K = kernel(options.ker, [Xs, Xt], [],options.gamma);
        model = svmtrain(full(Ys), [(1:m)', K(1:m, 1:m)], ['-c ', num2str(options.svmc), ' -t 4 -q 1']);
        [label, acc,scores] = svmpredict(full(Yt), [(1:n)', K(m+1:end, 1:m)], model);
        fprintf('SVM = %.2f%%\n', acc(1));
        
        %% PCVM
        
        model = pcvm_train(Xs',Ys,options.gamma);
        [erate, nvec, label, y_prob] = pcvm_predict(Xs',Ys,Xt',Yt,model);
        fprintf('\nPCVM %.2f%% \n', 100-erate*100)
        
        %% TCA
        nt = length(Ys);
        mt = length(Yt);
        K = tca(Xs',Xt',options.tcaNv,options.gamma,options.ker);
        model = svmtrain(full(Ys),[(1:nt)',K(1:nt,1:nt)],['-s 0 -c ', num2str(options.svmc), ' -t 4 -q 1']);
        [label,acc,scores] = svmpredict(full(Yt),[(1:mt)',K(nt+1:end,1:nt)],model);
        
        fprintf('\nTCA %.2f%% \n',acc(1));
        
        %% JDA
        
        Cls = [];
        [Z,A] = JDA(Xs,Xt,Ys,Cls,options);
        Z = Z*diag(sparse(1./sqrt(sum(Z.^2))));
        Zs = Z(:,1:size(Xs,2));
        Zt = Z(:,size(Xs,2)+1:end);
        K = kernel(options.ker, Z, [],options.gamma);
        model = svmtrain(full(Ys), [(1:m)', K(1:m, 1:m)], ['-c ', num2str(options.svmc), ' -t 4 -q 1']);
        [label, acc,scores] = svmpredict(full(Yt), [(1:n)', K(m+1:end, 1:m)], model);
        fprintf('\nJDA %.2f%% \n',acc(1));
        
        %% GFK
        tic;
        xs = full(Xs');
        xt = full(Xt');
        Ps = pca(xs);
        Pt = pca(xt);
        nullP = null(Ps');
        
        G = GFK([Ps,nullP], Pt(:,1:options.g));
        [label, acc] = my_kernel_knn(G, xs, Ys, xt, Yt);
        acc = full(acc)*100;
        fprintf('\nGFK %.2f%%\n',acc);
        
        
        %% TKL SVM
        tic;
        K = TKL(Xs, Xt, options);
        model = svmtrain(full(Ys), [(1:m)', K(1:m, 1:m)], ['-s 0 -c ', num2str(options.svmc), ' -t 4 -q 1']);
        [labels, acc,scores] = svmpredict(full(Yt), [(1:n)', K(m+1:end, 1:m)], model);
        fprintf('\nTKL %.2f%%\n',acc(1));
        
        
        %% PCTLVM No Theta Est
        
        options.theta =2;
        model = pctkvm_train(Xs',Ys,Xt',options);
        [erate, nvec, label, y_prob] = pctkvm_predict(Ys,Yt,model);
        
        fprintf('\nPCTKVM_Theta %.2f%% \n', 100-erate*100);
        
        %% PCTLVMTheta Est
        options.theta =-1;
        model = pctkvm_train(Xs',Ys,Xt',options);
        [erate, nvec, label, y_prob] = pctkvm_predict(Ys,Yt,model);
        fprintf('\nPCTKVM %.2f%% \n', 100-erate*100);
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
options.theta = 1;           %PCVM: Widht of Kernel


srcStr = {'Caltech10', 'Caltech10', 'Caltech10', 'amazon', 'amazon', 'amazon', 'webcam', 'webcam', 'webcam', 'dslr', 'dslr', 'dslr'};
tgtStr = {'amazon', 'webcam', 'dslr', 'Caltech10', 'webcam', 'dslr', 'Caltech10', 'amazon', 'dslr', 'Caltech10', 'amazon', 'webcam'};

for iData = 1:12
    src = char(srcStr{iData});
    tgt = char(tgtStr{iData});
    data = strcat(src, '_vs_', tgt);
    fprintf('data=%s\n', data);
    load(['../data/OfficeCaltech/' src '_SURF_L10.mat']);
    fts = fts ./ repmat(sum(fts, 2), 1, size(fts, 2));
    Xs = zscore(fts, 1);
    Ys = labels;
    Xs = Xs';
    
    load(['../data/OfficeCaltech/' tgt '_SURF_L10.mat']);
    fts = fts ./ repmat(sum(fts, 2), 1, size(fts,2));
    Xt = zscore(fts, 1);
    Yt = labels;
    Xt = Xt';
    
    m = size(Xs, 2);
    n = size(Xt, 2);
    %% SVM
    K = kernel(options.ker, [Xs, Xt], [],options.gamma);
    model = svmtrain(full(Ys), [(1:m)', K(1:m, 1:m)], ['-c ', num2str(options.svmc), ' -t 4 -q 1']);
    [label, acc,scores] = svmpredict(full(Yt), [(1:n)', K(m+1:end, 1:m)], model);
    fprintf('SVM = %.2f%%\n', acc(1));
    
    %% PCVM
    
    model = pcvm_train(Xs',Ys,options.gamma);
    [erate, nvec, label, y_prob] = pcvm_predict(Xs',Ys,Xt',Yt,model);
    fprintf('\nPCVM %.2f%% \n', 100-erate*100)
    
    %% TCA
    nt = length(Ys);
    mt = length(Yt);
    K = tca(Xs',Xt',options.tcaNv,options.gamma,options.ker);
    model = svmtrain(full(Ys),[(1:nt)',K(1:nt,1:nt)],['-s 0 -c ', num2str(options.svmc), ' -t 4 -q 1']);
    [label,acc,scores] = svmpredict(full(Yt),[(1:mt)',K(nt+1:end,1:nt)],model);
    
    fprintf('\nTCA %.2f%% \n',acc(1));
    
    %% JDA
    
    Cls = [];
    [Z,A] = JDA(Xs,Xt,Ys,Cls,options);
    Z = Z*diag(sparse(1./sqrt(sum(Z.^2))));
    Zs = Z(:,1:size(Xs,2));
    Zt = Z(:,size(Xs,2)+1:end);
    K = kernel(options.ker, Z, [],options.gamma);
    model = svmtrain(full(Ys), [(1:m)', K(1:m, 1:m)], ['-c ', num2str(options.svmc), ' -t 4 -q 1']);
    [label, acc,scores] = svmpredict(full(Yt), [(1:n)', K(m+1:end, 1:m)], model);
    fprintf('\nJDA %.2f%% \n',acc(1));
    
    %% GFK
    tic;
    xs = full(Xs');
    xt = full(Xt');
    Ps = pca(xs);
    Pt = pca(xt);
    nullP = null(Ps');
    
    G = GFK([Ps,nullP], Pt(:,1:options.g));
    [label, acc] = my_kernel_knn(G, xs, Ys, xt, Yt);
    acc = full(acc)*100;
    fprintf('\nGFK %.2f%%\n',acc);
    
    
    %% TKL SVM
    tic;
    K = TKL(Xs, Xt, options);
    model = svmtrain(full(Ys), [(1:m)', K(1:m, 1:m)], ['-s 0 -c ', num2str(options.svmc), ' -t 4 -q 1']);
    [labels, acc,scores] = svmpredict(full(Yt), [(1:n)', K(m+1:end, 1:m)], model);
    fprintf('\nTKL %.2f%%\n',acc(1));
    
    
    %% PCTLVM No Theta Est
    
    options.theta =2;
    model = pctkvm_train(Xs',Ys,Xt',options);
    [erate, nvec, label, y_prob] = pctkvm_predict(Ys,Yt,model);
    
    fprintf('\nPCTKVM_Theta %.2f%% \n', 100-erate*100);
    
    %% PCTLVMTheta Est
    options.theta =-1;
    model = pctkvm_train(Xs',Ys,Xt',options);
    [erate, nvec, label, y_prob] = pctkvm_predict(Ys,Yt,model);
    fprintf('\nPCTKVM %.2f%% \n', 100-erate*100);
end

