% This script evalutes the rotational transfer idea with the SVM as
% baseliner.
% BETA VERSION


options.gamma = 1;
options.ker = 'rbf';      % TKL: kernel: 'linear' | 'rbf' | 'lap'
options.svmc = 10.0;



for ngData = {'comp_vs_rec','comp_vs_sci','comp_vs_talk','rec_vs_sci','rec_vs_talk','sci_vs_talk'}%
    
    for j=[1,8,14,20,28,32]
        
        data = char(ngData);
        data = strcat(data, '_', num2str(j));
        load(strcat('../../data/20Newsgroup/', data));
        fprintf('data=%s\n', data);
        
        % Z-Transformation
        Xs=bsxfun(@rdivide, bsxfun(@minus,Xs,mean(Xs)), std(Xs));
        Xt=bsxfun(@rdivide, bsxfun(@minus,Xt,mean(Xt)), std(Xt));
        
        Z = Xs';
        X = Xt';
        soureIndx = crossvalind('Kfold', Ys, 2);
        targetIndx = crossvalind('Kfold', Yt, 2);
        
        Z = Z(find(soureIndx==1),:);
        Ys = Ys(find(soureIndx==1),:);
        
        
        X = X(find(targetIndx==1),:);
        Yt = Yt(find(targetIndx==1),:);
        
        if size(Z,1) > size(X,1)
            
            
            indxYs1 = find(Ys==1);
            indxYs2 = find(Ys==-1);
            
            s1 = size(indxYs1,1);
            s2 = size(indxYs2,1);
            
            if (s1 >= round(size(X,1)/2)) &&(s2 >= round(size(X,1)/2))
                s1 = round(size(X,1)/2); s2 = round(size(X,1)/2);
            elseif s1 < round(size(X,1)/2)
                labelDiff = abs(size(X,1)-s1);
                s2 =s2+labelDiff;
            elseif s2 < round(size(X,1)/2)
                labelDiff = abs(size(X,1)-s2);
                s1  = labelDiff+size(indxYs1,1);
            end
            
            
            Z1 = Z(indxYs1,:);
            C1 = cov(Z1');
            [v,e] = eigs(C1,s1);
            Z1 = (Z1' * v)';
            
            Z2 = Z(indxYs2,:);
            C2 = cov(Z2');
            [v,e] = eigs(C2,s2);
            Z2 = (Z2' * v)';
            
            Z = [Z1;Z2];
            Ys = [ones(size(Z1,1),1);ones(size(Z2,1),1)*-1];
            
        else
            
            ZX = zeros(size(X));
            ZX(1:size(Z,1),1:size(Z,2)) = Z;
            Z = ZX;
            nullLabels = size(X,1)-size(Ys,1);
            addTrainLabels = randi([0 1], nullLabels,1);
            addTrainLabels(find(addTrainLabels==0)) = -1;
            Ys = [Ys;addTrainLabels];
            
        end
        
        [~,ZS,~] = svd(Z,'econ');
        [U,S,V] = svd(full(X),'econ');
        Z = U*ZS*V';
        
        m = size(Z, 1);
        n = size(X, 1);
        
        K = kernel(options.ker, [Z', X'], [],options.gamma);
        model = svmtrain(full(Ys), [(1:m)', K(1:m, 1:m)], ['-c ', num2str(options.svmc), ' -t 4 -q 1']);
        [label, acc,scores] = svmpredict(full(Yt), [(1:n)', K(m+1:end, 1:m)], model);
        
        
    end
end
    
    
