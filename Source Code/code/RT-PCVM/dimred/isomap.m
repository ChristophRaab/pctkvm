function [XLO,EVALUES] = isomap (X,L,nnn,numlandmarks,blocksize)


% ISOMAP implements a specialized version of Isomap (TdSL 2000)
%
%  X is N x H matrix representing N points in R^H
%  L is number of dimensions you want X mapped to
%  nnn is the number of nearest neighbors used to create the graph.
%    It should be at least L. By default it is L+1.
%  numlandmarks is the number of landmarks (see IsomapII.m in 
%    the original code. It should also be at least L.
%    By default it is nnn+1.
%  XLO is N x L matrix representing same N points in R^L
%  EVALUES has the corresponding L largest eigenvalues.
% 
%  This code based on the original code IsomapII.m by Tenenbaum, 
%   de Silva, and Langford (2000) available at isomap.stanford.edu
%  It is not as general as their code, but is faster.
%
%  It is customized for points initially in Euclidean space.
%  If you've already got a sparse nearest-neighbor graph matrix 
%  created with the right number of nearest neighbors, dont used this 
%  function. Use isomap_graph.m
%
%  It will fail if the graph created is not connected.
% 
% To speed the code up:
%  On Linux, have the file some_dijkstra.mexglx in the matlab path
%    If you dont have it ready, create it with "mex some_dijkstra.c"
%  On Windows, have the file dijkstra.dll in the path
%
% Bugs? Suggestions? email dinoj@cs.uchicago.edu
%
% If you're running this on Linux and have the data still on disk
% you may want to use the cover tree algorithm. Email me about that 
% if you do.

if nargin < 3
  nnn = L+1;
end
if nargin < 4
  numlandmarks = nnn + 1;
end  


if ischar(X)
  if (2 ~= exist(X))
     error (sprintf ('The file %s cannot be found',X));
  end
  if isunix & (2==exist('nngraph'))
    tmpfile = sprintf ('%s_nn%d', X, nnn);

    cmd = sprintf ('./nngraph %d %s > %s', nnn, X, tmpfile);
    unix(cmd);

    tmp = load(tmpfile);
    N = max(max(tmp(:,1:2)));

    E = sparse(tmp(:,1),tmp(:,2),tmp(:,3),N,N);
  else
    X = load(X);
    N = size(X,1);
    if nargin>=5
      E = adjac(X,nnn,blocksize);
    else
      E = adjac(X,nnn);
    end
  end
else
  if nargin>=5
    E = adjac(X,nnn,blocksize);
  else
    E = adjac(X,nnn);
  end
  N = size(X,1);
end

[XLO,EVALUES] = isomap_graph (E,L,numlandmarks);
