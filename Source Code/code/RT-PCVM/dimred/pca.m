function [Y,E] = pca(X,L)

% PCA Principal Components Analysis
%
%       [Y,E] = PCA(X,L) returns the first L principal components of X.
%       X is a NxH matrix representing N points in H dimensions.
%       Y, a NxL matrix, is the projection of X on the first P principal components,
%       E has the L largest eigenvalues
%
%  based on code by Cyril Goutte: http://www.inrialpes.fr/is2/people/goutte/Matlab/pca.m


if (nargin ~= 2)
   error('Need two input arguments');
end

[N,H] = size(X) ;
if (L > H)
  error('PCA can only reduce the number of dimensions');
end

[V,S] = eig(corrcoef(X));

Xz = (X - repmat(mean(X),N,1)) / diag(std(X)) ;
[blah,indices] = sort(-diag(S)');  % sort by decreasing eigenvalues... dont risk Matlab's eig function.
Y = (Xz * V(:,indices) ) ;



Y = Y(:,1:L) ;                 % pick eigenvectors corresponding to largest eigenvalues

E = -blah(1:L);

