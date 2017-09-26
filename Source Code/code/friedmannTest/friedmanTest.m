function [ friedmanResult] = friedmanTest(ranks)
%FRIEDMANTEST This function calculates the improved Friedman test statistic
% by: Iman, Ronald & Davenport, James. (1980).
% Approximations of the critical region of the Friedman statistic.
% Communications in Statistics-Theory and Methods. 9. 571-595.
% Implementation idea adopted from:
% Janez Demšar. 2006.
% Statistical Comparisons of Classifiers over Multiple Data Sets.
% J. Mach. Learn. Res. 7 (December 2006), 1-30.
% Implementation by: Christoph Raab (2017)
% -------------------------------------------------------------------------
% INPUT: Ranks from the k classifier over N datasets as Nxk matrix.
%        At least 2 Columns and 2 Rows
% OUTPUT: pFriedman: Confidence Probabilisitc for rejecting null Hyopthesis
%         fFriedman: f Value from Friemand test statistic. F-Distributed
%         df and ddf: degrees of freedom for this statistic


N = size(ranks,1);
k = size(ranks,2);

if k < 2 && N < 2
    error('Friedman Test needs at least 2 rows and columns');
end


xsf = (12*N)/(k*(k+1)) * (sum(mean(ranks).^2)- (k*(k+1)^2)/4);
df = k-1;
ddf = (k-1)*(N-1);
fFriedman = ((N-1)*xsf) / (N*(k-1)-xsf);
pFriedman = round(1 - fcdf(fFriedman,df,ddf),2);
critValue = finv(0.95,df,ddf);

if fFriedman >= critValue
    fprintf('Null Hypothesis is rejected with f: %.2f\n',fFriedman);
    fprintf('Probability of wrongly rejet the Null Hypothesis: %.2f\n',pFriedman);
else
    fprintf('Null Hypothesis is obtained with f: %.2f\n',fFriedman);
end
friedmanResult = [pFriedman,fFriedman,df,ddf ];
end

