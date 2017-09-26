function[]=mergeResult(testType,dataSet);
addpath(genpath('../../result/'));

if ~exist('testType', 'var')
    testType = 'average';% Options: average, fivetwo
end
if ~exist('dataSet', 'var')
    dataSet = 'image';% Options: reuters, image
end
fprintf('Testype is set to %s\n',testType);
fprintf('Dataset is set to %s\n',dataSet);
dirLoc = '../../result/';

if strcmp(testType,'fivetwo')
    dirLoc=strcat(dirLoc,'fivetwo/');
else
    dirLoc=strcat(dirLoc,'average/');
end

D = dir(dirLoc);
files = D(not([D.isdir]));

if size(files,1) < 2
    error('No data for merge found! Wrong directory?');
end

rankTime = [];
rankVec = [];
meanErrors = [];
stdErrors = [];
ormseR = [];
meanAuc = [];
stdAuc = [];
meanAcc = [];
stdAcc = [];
meanTime = [];
stdTime = [];
meanVec = [];
stdVec = [];
ftAuc = zeros(7,6);
ftErr = zeros(7,6);
ftAcc = zeros(7,6);
for i = 1:size(files,1)
    
    load(strcat(dirLoc,files(i).name));
    containsString = regexp(files(i).name,'org_vs_people|org_vs_place|people_vs_place');
    
    if strcmp(dataSet,'reuters') && isempty(containsString)
        continue;
    end
    if strcmp(dataSet,'image') && ~isempty(containsString)
        continue;
    end
    
    
    
    meanErrors = [meanErrors; round(errResult(end-1,:),2)];
    stdErrors =  [stdErrors; round(errResult(end,:),2)];
    
    meanAuc =  [meanAuc; round(aucResult(end-1,:),2)];
    stdAuc =  [stdAuc;round(aucResult(end,:),2)];
    
    meanAcc =  [meanAcc; round(accResult(end-1,:),2)];
    stdAcc =  [stdAcc;round(accResult(end,:),2)];
    
    ormseR = [ormseR; ormse];
    
    meanTime =  [meanTime; round(timeResult(end-1,:),2)];
    stdTime =  [stdTime ;round(timeResult(end-1,:),2)];
    
    meanVec =  [meanVec ; round(nvecResult(end-1,:),2)];
    stdVec =  [stdVec ; round(nvecResult(end,:),2)];
    
    if ~strcmp(testType,'fivetwo')
        continue;
    end
    
    ftTmpAuc = sumFtResult(ftresultAuc,'auc');
    ftAuc = ftAuc + ftTmpAuc;
    
    ftTmpErr = sumFtResult(ftresultErr,'err');
    ftErr = ftErr + ftTmpErr;
    
    ftTmpAcc = sumFtResult(ftresultAcc,'acc');
    ftAcc = ftAcc + ftTmpAcc;
    
    
end

%Due to the fact that GFK has no AUC value
if strcmp(testType,'fivetwo')
    ftAuc = [ftAuc(1:4,:);ftAuc(6:end,:)];
end

meanAuc = [meanAuc(:,1:4),zeros(size(meanAuc,1),1),meanAuc(:,5:end)];
stdAuc = [stdAuc(:,1:4),zeros(size(stdAuc,1),1),stdAuc(:,5:end)];
for i = 1:size(meanTime,1)
    rankTime = [rankTime; tiedrank(meanTime(i,:))];
end

for i = 1:size(meanTime,1)
    rankVec = [rankVec; tiedrank(meanVec(i,:))];
end

meanOrmse = mean(ormseR);
stdOrmse = std(ormseR);
meanTimeRank = mean(rankTime);
meanVecRank  = mean(rankVec);

metricResult = [mean(meanErrors),mean(stdErrors);meanOrmse,stdOrmse;mean(meanAcc),mean(stdAcc);mean(meanAuc),mean(stdAuc)];

name = strcat('../../result/',testType,'_',dataSet,'_Result.mat');

if strcmp(testType,'fivetwo')
    save(name,'ftAcc','ftAuc','ftErr','metricResult','meanAuc','stdAuc','meanErrors','stdErrors','meanAcc','stdAcc','meanOrmse','stdOrmse','ormseR','meanVec','rankVec','meanVecRank','meanTime','rankTime','meanTimeRank','meanOrmse');
else
    save(name,'metricResult','meanAuc','stdAuc','meanErrors','stdErrors','meanAcc','stdAcc','meanOrmse','stdOrmse','ormseR','meanVec','rankVec','meanVecRank','meanTime','rankTime','meanTimeRank','meanOrmse');
end
fprintf('Merged result saved to %s\n',name);
end
