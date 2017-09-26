function [ ftresultErr,ftresultAuc,ftresultAcc,accResult,errResult,aucResult,timeResult,nvecResult,ormse] = fiveXtwo_run( Xs,Xt,Ys,Yt,options,data)
%FIVEXTWO_RUN Summary of this function goes here
%   Detailed explanation goes here
foldOneErr = [];
foldTwoErr = [];
foldOneAuc = [];
foldTwoAuc = [];
foldOneAcc = [];
foldTwoAcc = [];
ftresultErr = [];
ftresultAuc = [];
ftresultAcc = [];
timeResult = [];
nvecResult = [];

% Z-Transformation
Xs=bsxfun(@rdivide, bsxfun(@minus,Xs,mean(Xs)), std(Xs));
Xt=bsxfun(@rdivide, bsxfun(@minus,Xt,mean(Xt)), std(Xt));


Xs = Xs';
Xt = Xt';

% parfor (i=1:5,5)
for i=1:5
    soureIndx = crossvalind('Kfold', Ys, 2);
    targetIndx = crossvalind('Kfold', Yt, 2);
    
    Xs1 = Xs(find(soureIndx==1),:);
    Ys1 = Ys(find(soureIndx==1),:);
    
    
    Xt1 = Xt(find(targetIndx==1),:);
    Yt1 = Yt(find(targetIndx==1),:);
    
    
    [ accTmp,errTmp,aucTmp,timeTmp,nvecTmp ] = tlfun(Xs1',Xt1',Ys1,Yt1,options,data);
    foldOneErr = [foldOneErr;errTmp];
    foldOneAuc = [foldOneAuc;aucTmp];
    foldOneAcc = [foldOneAcc;accTmp];
    timeResult = [timeResult;timeTmp]; nvecResult = [nvecResult; nvecTmp];
    
    
    Xs2 = Xs(find(soureIndx==2),:);
    Ys2 = Ys(find(soureIndx==2),:);
    
    
    Xt2 = Xt(find(targetIndx==2),:);
    Yt2 = Yt(find(targetIndx==2),:);
    
    [accTmp,errTmp,aucTmp,timeTmp,nvecTmp ]  = tlfun(Xs2',Xt2',Ys2,Yt2,options,data);
    foldTwoErr = [foldTwoErr;errTmp];
    foldTwoAuc = [foldTwoAuc;aucTmp];
    foldTwoAcc = [foldTwoAcc;accTmp];
    timeResult = [timeResult;timeTmp]; nvecResult = [nvecResult; nvecTmp];
    
end


onePcvmtkl = foldOneErr(:,end);
twoPcvmtkl = foldTwoErr(:,end);

onePcvmtklAuc = foldOneAuc(:,end);
twoPcvmtklAuc = foldTwoAuc(:,end);

onePcvmtklAcc = foldOneAcc(:,end);
twoPcvmtklAcc = foldTwoAcc(:,end);

for i =1: size(foldOneErr,2)-1
    [f,win,sigWin] = calcFiveTwoFvalue( [onePcvmtkl, foldOneErr(:,i),twoPcvmtkl,foldTwoErr(:,i) ]);
    ftresultErr = [ftresultErr; f win sigWin];
    
    [f,win,sigWin] = calcFiveTwoFvalue( [abs(onePcvmtklAuc-1), abs(foldOneAuc(:,i)-1),abs(twoPcvmtklAuc-1),abs(foldTwoAuc(:,i)-1) ]);
    ftresultAuc = [ftresultAuc; f win sigWin];
    
    [f,win,sigWin] = calcFiveTwoFvalue( [abs(onePcvmtklAcc-1), abs(foldOneAcc(:,i)-1),abs(twoPcvmtklAcc-1),abs(foldTwoAcc(:,i)-1) ]);
    ftresultAcc= [ftresultAcc; f win sigWin];
end

errResult = [foldOneErr; foldTwoErr]; aucResult = [foldOneAuc; foldTwoAuc]; accResult = [foldOneAcc; foldTwoAcc];
ormse = sqrt(mean(errResult.^2));
errResult = [errResult; mean(errResult); std(errResult)];
aucResult = [aucResult; mean(aucResult); std(aucResult)];
accResult = [accResult; mean(accResult); std(accResult)];
timeResult = [timeResult; mean(timeResult); std(timeResult)];
nvecResult = [nvecResult; mean(nvecResult); std(nvecResult)];
end

