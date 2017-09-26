function W = adjac (DATA, nn,step,stepsbtwnreport)
  
% ADJAC Make sparse adjacency matrix based on nearest neigbors in Euclidean space
% 
% W = adjac (DATA, nn)
%
%   DATA is a N x hidim matrix representing N points in R^hidim
%   nn is the number of nearest neighbors
%   for each vertex i, for each vertex j that is among i's nn nearest neighbors
%      there is an entry W(i,j) = W(j,i) with the distance in R^hidim
%      between i and j.
%   W(i,i)=0 isnt stored.
%   Each row has (at least) nn nonzero entries. Not necessarily exactly.
%
%   step is a value that can be modified to optimize this code's
%   running on your machine.  L2_distance is called on a step x N matrix.
%
%   The number of points processed is reported every stepsbetweenreport*step
%    points processed.
%
% Original code by Misha Belkin (misha@cs.uchicago.edu)
% Modified by Dinoj Surendran (dinoj@cs.uchicago.edu), April/May 2004
  
if nargin < 2, nn = 10;end
if nargin < 3, step=128;end
if nargin < 4, stepsbtwnreport=5;end
  
n=size(DATA,1);
W=sparse(n,n);

count=0;
for i1=1:step:n
    count=count+1;
    i2 = min(i1+step-1,n);
    XX= DATA(i1:i2,:);  
    dt = L2_distance(XX',DATA');
    
    [Z,I] = sort (dt,2);
    for i=i1:i2
      vals = Z(i-i1+1,2:nn+1);
      
      if length(find(vals==Inf))
	vals
	[i i1 i2]
	count
      end
	
      
      W(i,I(i-i1+1,2:nn+1)) = vals;
      W(I(i-i1+1,2:nn+1),i) = vals';
    end
    if (mod(count,stepsbtwnreport) == 0) 
      disp(sprintf('%d points processed.\n', i2));
    end;
end;

