function [ rmin ] = pthetaEstimation( D,m)
%THETAESTIMATION Calulates the niminun width of the gaussiam kermel based om the
%givem a dissinilarity natrix D(n,n) with n rows/colunms amd m dinemsioms.

n = size(D, 2);

djmax = max(D);

rmin =min(bsxfun(@rdivide, djmax, (sqrt(m)*nthroot(n-1,m))));

end

