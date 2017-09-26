function S = heatweights (W, ii1, tm)

% HEATWEIGHTS Creates a similarity matrix based on heat kernel weights
%
% S = heatweights (W, [ii1, tm])
% 
% W is a sparse N x N matrix representing an adjacency graph on N points.
%   W(i,j) is the W(i,j) is the Euclidean distance between the i-th and j-th
%   points if one of the points is among the nearest neighbors
%   Assumes all W(i,i) = 0.
%.
% S(i,j) = exp (- (W(i,j)^2) / t), where 
%     t = tm  multiplied by the mean distance between nearest neighbo
%         
% ii1 should be supplied if you want S(i,i) to equal ii1. It is 0
% by default.
% tm is 4 by default.

if nargin < 2, ii1= 0; end;
if nargin < 3, tm = 4; end;

n=size(W,1);
if size(W,2) ~= n
  error ('W should be square');
end  

[A_i,A_j,A_v] = find (W);
t = tm * mean(A_v); 

S = sparse(A_i,A_j,exp(1).^((-1/t)*(A_v.^2)));
if (size(S,1) < n) | (size (S,2) < n)
  S(n,n) = 0;        % in case there isnt a nonzero entry 
                     % in the n-th row or column of W
end			    
if ii1
   S = S + ii1*speye(n);   % assumes all diagonal entries of W are 0
			   
end