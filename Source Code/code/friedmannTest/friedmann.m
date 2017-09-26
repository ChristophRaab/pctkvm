function[]=friedmann(testType);
addpath(genpath('../../result/'));
addpath(genpath('../../libsvm/matlab'));
addpath(genpath('../../data'));
addpath(genpath('../../code'));
addpath(genpath('../../code/fiveTwoCvF'));

if ~exist('testType', 'var')
    testType = 'fivetwo';% Options: average, fivetwo
end

fprintf('Testype is set to %s\n',testType);

dirLoc = '../../result/';
errorR = [];
aucR = [];
accR = [];
rmseR = [];
mea = [];

if strcmp(testType,'fivetwo')
    dirLoc=strcat(dirLoc,'fivetwo/');
else
    dirLoc=strcat(dirLoc,strcat(testType,'/'));
end


D = dir(dirLoc);
files = D(not([D.isdir]));
for i = 1:size(files,1)
    
    loc = strcat(dirLoc,files(i).name);
    load(loc);
    
    meanErrors= errResult(end-1,:);
    
    mea = [mea;meanErrors];
    rankE = tiedrank(meanErrors);
    errorR = [errorR; rankE];
    
    
    
    meanAuc = aucResult(end-1,:);
    rankA = tiedrank(meanAuc);
    aucR = [aucR; rankA];
    
    rankR = tiedrank(ormse);
    rmseR = [rmseR; rankR];
    
    meanAcc = accResult(end-1,:);
    rankAcc = tiedrank(meanAcc);
    accR = [accR ; rankAcc];
end

friedmanStatisitc = [];

for i={errorR,rmseR,aucR,accR}
    friedmanResult = friedmanTest(i{1});
    friedmanStatisitc = [friedmanStatisitc;friedmanResult];
end

aucR = [aucR(:,1:4),zeros(size(aucR,1),1),aucR(:,5:end)];
meanRanks = [round(mean(errorR),2);  round(mean(rmseR),2); round(mean(aucR),2); round(mean(accR),2)];

% starting at 2 classifier for index on
q = [1.960 2.241 2.394 2.498 2.576 2.638 2.690 2.724 2.773];


N = size(accR,1); %Number of datasets
k = size(accR,2); %Number of classifier

CD =  q(k-1) * sqrt((k*(k+1))/(6*N));

pcvmR = meanRanks(:,end);
comp = meanRanks(:,1:end-1);

diff = comp - pcvmR;

name = strcat('../../result/',testType,'_friedmannResult.mat');
save(name,'friedmanStatisitc','meanRanks','diff','CD','N','k','errorR','aucR','rmseR','accR');
fprintf('Friedmann statistics saved to %s\n',name);
end