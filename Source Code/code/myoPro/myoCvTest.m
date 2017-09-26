clear all;
close all;

for dof =1:6
    dofResult = [];
    dofResultTime=[];
    for i=1:5
        
        tmp=[];
        timeTmp=[];
        [Xs,Xt,Ys,Yt] = dataTransformation(dof);
        
        Xs=bsxfun(@rdivide, bsxfun(@minus,Xs,mean(Xs)), std(Xs));
        Xt=bsxfun(@rdivide, bsxfun(@minus,Xt,mean(Xt)), std(Xt));

         
        
        options.ker = 'rbf';
        options.eta = 1.5;
        options.gamma = 0.5;
        options.svmc = 10.0;
        options.theta = 1.1;
        
        soureIndx = crossvalind('Kfold', Ys, 2);
        targetIndx = crossvalind('Kfold', Yt, 2);
        
        Xs1 = Xs(find(soureIndx==1),:);
        Ys1 = Ys(find(soureIndx==1),:);
        
        
        Xt1 = Xt(find(targetIndx==1),:);
        Yt1 = Yt(find(targetIndx==1),:);
        
        m = size(Xs1, 1);
        n = size(Xt1, 1);
        
        model = rtpcvm_train(Xs1,Ys1,Xt1,options);
        [erate, nvec, label, y_prob] = rtpcvm_predict(Yt1,model);
        
        tic;
        K = kernel(options.ker, [Xs1', Xt1'], [],options.gamma);
        model = svmtrain(full(Ys1), [(1:m)', K(1:m, 1:m)], ['-c ', num2str(options.svmc), ' -t 4 -q 1']);
        [label, acc,scores] = svmpredict(full(Yt1), [(1:n)', K(m+1:end, 1:m)], model);
        timeTmp =[timeTmp toc];
        tmp = [tmp acc(1)];
        tic;
        K = TKL(Xs1', Xt1', options);
        model = svmtrain(full(Ys1), [(1:m)', K(1:m, 1:m)], ['-s 0 -c ', num2str(options.svmc), ' -t 4 -q 1']);
        [labels, acc,scores] = svmpredict(full(Yt1), [(1:n)', K(m+1:end, 1:m)], model);
        timeTmp =[timeTmp toc];
        tmp = [tmp acc(1)];
         
        options.ker = 'srbf';
        tic;
        options.theta =-1;
        model = pctkvm_train(Xs1,Ys1,Xt1,options);
        [erate, nvec, label, y_prob] = pctkvm_predict(Ys1,Yt1,model);
        timeTmp =[timeTmp toc];
        tmp = [tmp (1-erate)*100];
        
        options.theta = 0.5;
        tic;
        model = pctkvm_train(Xs1,Ys1,Xt1,options);
        [erate, nvec, label, y_prob] = pctkvm_predict(Ys1,Yt1,model);
        timeTmp =[timeTmp toc];
        tmp = [tmp (1-erate)*100];
        
        Xs2 = Xs(find(soureIndx==2),:);
        Ys2 = Ys(find(soureIndx==2),:);
        
        
        Xt2 = Xt(find(targetIndx==2),:);
        Yt2 = Yt(find(targetIndx==2),:);
        
        
        
        m = size(Xs2, 1);
        n = size(Xt2, 1);
        
        options.ker = 'rbf';
        tic;
        K = kernel(options.ker, [Xs2', Xt2'], [],options.gamma);
        model = svmtrain(full(Ys2), [(1:m)', K(1:m, 1:m)], ['-c ', num2str(options.svmc), ' -t 4 -q 1']);
        [label, acc,scores] = svmpredict(full(Yt2), [(1:n)', K(m+1:end, 1:m)], model);
        timeTmp =[timeTmp toc];
        tmp = [tmp acc(1)];
        
        tic;
        K = TKL(Xs2', Xt2', options);
        model = svmtrain(full(Ys2), [(1:m)', K(1:m, 1:m)], ['-s 0 -c ', num2str(options.svmc), ' -t 4 -q 1']);
        [labels, acc,scores] = svmpredict(full(Yt2), [(1:n)', K(m+1:end, 1:m)], model);
        timeTmp =[timeTmp toc];
        tmp = [tmp acc(1)];
        
        options.ker = 'srbf';
        tic;
        options.theta =-1;
        model = pctkvm_train(Xs1,Ys1,Xt1,options);
        [erate, nvec, label, y_prob] = pctkvm_predict(Ys2,Yt2,model);
        timeTmp =[timeTmp toc];
        tmp = [tmp (1-erate)*100];

        
        options.theta = 0.5;
        tic;
        model = pctkvm_train(Xs2,Ys2,Xt2,options);
        [erate, nvec, label, y_prob] = pctkvm_predict(Ys2,Yt2,model);
        timeTmp =[timeTmp toc];
        tmp = [tmp (1-erate)*100];
     
        
        dofResult = [dofResult;tmp];
        dofResultTime=[dofResultTime;timeTmp ];
    end
    name = strcat('../../result/myoCv/','myPro','_',dof,'_Result.mat');
    save(name,'dofResult','dofResultTime');
end

