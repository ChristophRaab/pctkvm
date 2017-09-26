function [E,V] = laplacian_underlying(DATA,lodim,nn,step,stepsbtwnreport,opts,whichweights, usenorm , lpp, name)

% LAPLACIAN_UNDERLYING Implements various laplacian-related algorithms,
% depending on how it's called. 
%
% [E,V] = laplacian_underlying (DATA,lodim,[nn,step,stepsbtwnreport])
%
% DATA is a N x hidim matrix representing N points in R^hidim
% lodim is a positive integer; you want to map the points in DATA
%   to R^lodim.
% nn is the number of nearest neighbors used to create the graph
% step is a value that can be modified to optimize this code's
%   running on your machine.  L2_distance is called on a step x N matrix.
% The number of points processed is reported every step *
%   stepsbtwnreport points processed.
% opts is what is supplied to eigs (type 'help eigs' for details)
%
% V is a vector with the lodim smallest positive eigenvectors.
% if the Laplacian algorithm is used, then 
%   E is a N x lodim matrix represnting the same N points in R^lodim.
% else
%   E is a hidim x lodim matrix such that E'x is the mapping of a point
%   x in R^hidim.
%
%  E(:,i) and V(i) are the i-th smallest positive eigenvectors/values.
%
% Original code by Misha Belkin (misha@cs.uchicago.edu)
% Modified by Dinoj Surendran (dinoj@cs.uchicago.edu), April/May 2004
%
%  whichweights is 1 iff you want to use heatkernel weights,
%            -1 iff you want to use original similarity, i.e. DATA is a N x N similarity matrix
%             0 iff you want to use binary weights
%  usenorm is 1 iff you want to use normalized Laplacians (you should, unless you're using LPP, see next)
%
%  lpp is 1 iff you want to use Locality Preserving Projections.
% 
%  name is the name of the algorithm. 
%
% Default values are generally not used since this function should
% only be called by wrapper functions.

if nargin < 9
   error ('need more arguments. Type help laplacian_underlying for details');
end

if nargin < 10, 
  name = 'Laplacian Algorithm';
  if usenorm
    name = ['Normalized ' name];
  end
  if lpp 
     name = ['Linear Approximation to Laplacian ( = Locality Preserving Projection )'];
  end
  if whichweights == 1
     name = [name ' with Heat Kernel weights'];
  elseif whichweights == 0
     name = [name ' with binary weights'];
  elseif whichweights == -1
     name = [name ' with original similarity weights'];
  end
end  

n=size(DATA,1);
hidim = size(DATA,2);
 
if whichweights == -1
  fprintf (1,'Finding a mapping of %d points in some original space to R^%d\n using the %s\n\n', n, lodim, name, nn);
else
  fprintf (1,'Finding a mapping of %d points in R^%d to R^%d\n using the %s and %d nearest neighbors\n\n', n, hidim, lodim, name, nn);
end

% calculate the adjacency matrix for DATA

if whichweights == 1
  W = heatweights (adjac (DATA, nn,step,stepsbtwnreport));
elseif whichweights == 0
  W = binweights (adjac (DATA, nn,step,stepsbtwnreport));
elseif whichweights == -1
  if size(DATA,1) ~= size(DATA,2)
    error ('If first argument represents similarities, it should be a square matrix');
  end
  W = (DATA+DATA')/2;                           % may as well symmetrize it
else
  error ('whichweights has an unknown option');
end  

Dd = sum(W(:,:),2);
D = spdiags(Dd,0,speye(n));

if usenorm
  Dh = Dd.^-.5;
  Dhalf = spdiags(Dh,0,speye(n));
  L = speye(size(D)) - Dhalf*W*Dhalf; 
else 
  L = D-W; 
end

if lpp 
  DLD = DATA'*L*DATA;
  DDD = DATA'*D*DATA;
  DLD = (DLD + DLD')/2;
  DDD = (DDD + DDD')/2;
  [EE,VV] = eig(DLD,DDD);
else
  [EE,VV] = eigs(L,1+lodim,'SM',opts);      
  
  % ungeneralized eigenvalue problem with normalized Laplacian 
  % (L = I - sqrt(D)*W*sqrt(D)) is equivalent to generalized
  % eigenvalue problem with unnormalized Laplcian (L = D-W)
  %
  % If we had used L=D-W then we'd write
  %  [EE,VV] = eigs(L,D,1+lodim,'SM',opts); 

end

% Dont rely on getting eigenvalues in sorted order.

[Vs,Vi] = sort(diag(VV));          % Vi is indices of sorted
                                   % eigenvalues in ascending order

% smallest eigenvalue for Laplacian Eigenmaps (not LPP) is 0
%  so dont get it

if lpp
  indices = Vi(1:lodim);
else
  indices = Vi(2:1+lodim);         % first eigenvalue should be 0
end

E = EE(:,indices);
V = diag(VV);
V = V(indices);

