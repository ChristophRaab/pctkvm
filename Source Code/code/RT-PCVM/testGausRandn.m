% This script visualizes the problem of transfer learning with and synthetic
% gaussian dataset

close all;

Z= [randn(100,3); randn(100,3)+2];
Ys = [ones(100,1); ones(100,1)*2];

X= [randn(100,3)-5; randn(100,3)-6];
Yt = [ones(100,1)*1; ones(100,1)*2];

D = [Z;X];
Y = [Ys;Yt];
color_1 = [1 1 0]; % yellow: source label1
color_2 = [1 0 1];  %magenta: source label2
color_3 = [0 1 0]; %green: target label3
color_4 = [0 0 1]; %blue: target label4

cmap = [color_1; color_2; color_3;color_4];
label = cmap(Y,:);

figure;
scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
title('Dataset with two Domains')

Z = zscore(Z,1); X = zscore(X,1);

% Z =  tsne(Z,'Algorithm','barneshut','Distance','euclidean','NumDimensions',2);
% X =  tsne(X,'Algorithm','barneshut','Distance','euclidean','NumDimensions',2);
%  
% Z = zscore(Z,1); X = zscore(X,1);
% D = [Z;X];
% Y = [Ys;Yt];
% figure;
% scatter(D(:,1),D(:,2),ones(size(Y))*25,label);
% title('Normalized Dataset with two Domains')
% 
% [U,S,V] = svd(X);
% [~,ZS,~] = svd(Z);
% Z = U*ZS*V';
% 
% D = [Z;X];
% figure;
% scatter(D(:,1),D(:,2),ones(size(Y))*25,label);
% title('Rotation with two Domains')

% model = svmtrain(Y(1:200,:),Z, ['-c 10', ' -t 2']);
% [label, acc,scores] = svmpredict(Y(201:end,:),X, model);
% 
% Orginal space
% Z= [randn(100,3); randn(100,3)+2];
% Ys = [ones(100,1); ones(100,1)*2];
% 
% X= [randn(100,3)-5; randn(100,3)-6];
% Yt = [ones(100,1)*3; ones(100,1)*4];
% 
% D = [Z;X];
% Y = [Ys;Yt];
% color_1 = [1 1 0]; % yellow: source label1
% color_2 = [1 0 1];  %magenta: source label2
% color_3 = [0 1 0]; %green: target label3
% color_4 = [0 0 1]; %blue: target label4
% 
% cmap = [color_1; color_2; color_3;color_4];
% label = cmap(Y,:);
% 
% figure;
% scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
% title('Dataset with two Domains')
% 
% Z = zscore(Z,1); X = zscore(X,1);
% 
% D = [Z;X];
% Y = [Ys;Yt];
% figure;
% scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
% title('Normalized Dataset with two Domains')
% 
% [U,S,V] = svd(X);
% [~,ZS,~] = svd(Z);
% Z = U*ZS*V';
% 
% D = [Z;X];
% figure;
% scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
% title('Rotation with two Domains')
% 
% Reduced Subspace


%% TWO Labels

Z= [randn(100,3); randn(100,3)+2];
Ys = [ones(100,1); ones(100,1)*2];

X= [randn(100,3)-5; randn(100,3)-6];
Yt = [ones(100,1); ones(100,1)*2];

D = [Z;X];
Y = [Ys;Yt];
color_1 = [1 1 0]; % yellow: source label1
color_2 = [1 0 1];  %magenta: source label2
color_3 = [0 1 0]; %green: target label1
color_4 = [0 0 1]; %blue: target label2

cmap = [color_1; color_2;];
label = cmap(Y,:);

figure;
scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
title('Dataset with two Domains')

Z = zscore(Z,1); X = zscore(X,1);
D = [Z;X];
Y = [Ys;Yt];
figure;
scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
title('Normalized Dataset with two Domains')

[U,S,V] = svd(X);
[~,ZS,~] = svd(Z);
Z = U*ZS*V';

D = [Z;X];
figure;
scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
title('Rotation with two Domains')

