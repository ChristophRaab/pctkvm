function [XLO,EVALUES] = isomap_graph (E,L,numlandmarks)

% ISOMAP 
%  This code based on the original code IsomapII.m by Tenenbaum, 
%   de Silva, and Langford (2000) available at isomap.stanford.edu
%  It is not as general as their code, but is faster.
%
% E is N x N sparse matrix representing a N-vertex graph
% L is number of dimensions you want X mapped to
%  numlandmarks is the number of landmarks (see IsomapII.m in 
%    the original code. It should also be at least L.
%    By default it is L+2.
%
% To speed the code up:
%  On Linux, have the file some_dijkstra.mexglx in the matlab path
%    If you dont have it ready, create it with "mex some_dijkstra.c"
%  On Windows, have the file dijkstra.dll in the path
%
% Bugs? Suggestions? email dinoj@cs.uchicago.edu

if nargin < 3
  numlandmarks = L+2;
end

N = size(E,1);
E = max(E,E');

[blocks,dag] = components(E);
if max(blocks) > 1
  error ('graph not connected, will deal with this later');
end

% better to choose random landmarks instead of first few... but cant implement this yet
% landmarks = unique(ceil(N*rand(1,2*numlandmarks)));
% landmarks = landmarks(1:numlandmarks);

landmarks = 1:numlandmarks;

if isunix & (3==exist('dijkstra_singlesource.mexglx'))
  for i = 1:length(landmarks)
     D(i,:) = (dijkstra_singlesource(E,landmarks(i)))'  ;,   
  end
else
  D = dijkstra(E, landmarks);    
end

% D is a numlandmarks x N matrix, 
% D(i,j) is the distance from the i-th landmark to every point j


if (numlandmarks==N)
     opt.disp = 0; 
     [vec, val] = eigs(-.5*(D.^2 - sum(D.^2)'*ones(1,N)/N - ones(N,1)*sum(D.^2)/N + sum(sum(D.^2))/(N^2)), L, 'LM', opt); 
else
     % D2 = (D.^2)';
     % subB = -.5*(D2 - repmat(sum(D2,2)/nl,1,nl) - repmat(sum(D2,1)/N,N,1) + sum(sum(D2))/(N*nl));
     % clear D2;
     % the line below is about 50% slower... but needs less memory than the alternative above
     % ... it is over 10 times faster when the above alternative goes to disk.
     % ... the crossover point is when the algorithm below is a couple of seconds, so that's ok.

     subB = -.5*(D'.^2 - sum(D.^2)'*ones(1,numlandmarks)/numlandmarks - ones(N,1)*sum(D'.^2)/N+sum(sum(D'.^2))/(N*numlandmarks));

     opt.disp = 0; 
     [alpha,beta] = eigs(subB'*subB, L, 'LM', opt); 

     EVALUES = beta.^(1/2); 
     XLO = subB*alpha*inv(EVALUES); 
     clear subB alpha beta; 
end

[EVALUES,sorted] = sort(-real(diag(EVALUES)));
EVALUES = -EVALUES;

XLO = XLO(:,sorted) .* (ones(N,1)*sqrt(EVALUES')) ;       % multiply eigenvectors by sqrt(eigenvalue)





