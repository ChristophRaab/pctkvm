function [ftmerge] = sumFtResult(ftresult,metricType)
ftmerge = zeros(7,6);

if strcmp(metricType,'err')
    loseIdx = 2;
    winIdx = 1;
    sigLoseIdx = 5;
    sigWinIdx = 4;
else
    loseIdx = 1;
    winIdx = 2;
    sigLoseIdx = 4;
    sigWinIdx = 5;
end

for j = 1:size(ftresult,1)
    
    tmp = ftresult(j,2:end);
    
    if tmp(1) == 1
        ftmerge(j,loseIdx) = ftmerge(j,loseIdx) +1;
    elseif tmp(1) == -1
        ftmerge(j,winIdx) = ftmerge(j,winIdx) +1;
    else
        ftmerge(j,3) = ftmerge(j,3) +1;
    end
    
    
    if tmp(2) == 1
        if tmp(1) == 1
            ftmerge(j,sigLoseIdx) = ftmerge(j,sigLoseIdx) +1;
        elseif tmp(1) == -1
            ftmerge(j,sigWinIdx) = ftmerge(j,sigWinIdx) +1;
        else
            ftmerge(j,6) = ftmerge(j,6) +1;
        end
    end
end


end