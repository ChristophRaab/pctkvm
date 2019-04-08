% % This script visualizes the problem of transfer learning with and synthetic
% % gaussian dataset
% Orginal space
Z= [randn(100,3); randn(100,3)+2];
Ys = [ones(100,1); ones(100,1)*2];

X= [randn(100,3)-5; randn(100,3)-7];
Yt = [ones(100,1)*3; ones(100,1)*4];

D = [Z;X];
Y = [Ys;Yt];
color_1 = [0 1 0]; % yellow: source label1
color_2 = [0 0 1];  %magenta: source label2
color_3 = [0 1 0]; %green: target label3
color_4 = [0 0 1]; %blue: target label4

cmap = [color_1; color_2; color_3;color_4];
label = cmap(Y,:);
 
figure;
scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
print("Homogenoues_Transfer_Problem","-depsc","-r1000")
Z = zscore(Z,1); X = zscore(X,1);

D = [Z;X];
Y = [Ys;Yt];
figure;
scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
print("Domain_Adaptation","-depsc","-r1000")


Z= randn(200,3)+2;
Ys = ones(200,1);

X= randn(200,3);
Yt = ones(200,1)*2;


D = [Z;X];
Y = [Ys;Yt];
cmap = [color_1; color_2;];
label = cmap(Y,:);

figure;
scatter3(D(:,1),D(:,2),D(:,3),ones(size(Y))*25,label);
print("Traditional Problem","-depsc","-r1000")
