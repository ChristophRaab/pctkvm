function nbrs = findnbrs (M,labels,x,k)

% FINDNBRS finds labels of neighbors for any point in Euclidean space
%
% M is a N x L matrix, dense or sparse, with positions of 
%  N points in R^L. 
% labels is a N-element cell array of labels for each data point 
% x is the label of a point (or a cell array of labels). 
%  Or it can be an integer - the index of the point in labels.
% k is an integer. If it is not supplied then all nbrs are returned.
%  By 'all nbrs' we mean all other nodes if the matrix is dense (which is silly - but accurate)
%  and all nodes at nonzero distance if the matrix is sparse.
%
% nbrs is a structure. If x is a single label
%  nbrs.original is the original label
%  nbrs.labels is a cell array (size at most k) 
%  nbrs.distances is a vector with the corresponding distances
%
% If x is not found then nbrs is set to 0 and returned.
%
% x can also be a cell array of labels or a vector of indices.
%  In this case a cell array of the nbrs structure is returned.
%
% Dinoj Surendran 28 Oct 04 dinoj@cs.uchicago.edu


[N,L] = size(M);

if nargin < 4
  k = N;
end

% query is the index in labels of the point whose neighbors we seek

if ischar (x)
  query = 0;
  for j=1:length(labels)
    if strcmp(x,labels{j})
      query = j;
      break;
    end
  end
  if ~query
    nbrs = 0;
    fprintf (1,'\n[%s] not found\n',x);
    return;
  end
elseif isnumeric(x)
  if length(x) > 1
    for j=1:length(x)
      nbrs{j} = findnbrs (M,labels,x(j),k);
    end
    return;
  elseif x > N or x < 1
    nbrs = 0;
    fprintf (1,'dataset only has %d points, you wanted neighbors of the %d-th point\n', N, x);
    return;
  end
  query = x;
elseif iscell(x)
  for j=1:length(x)
    nbrs{j} = findnbrs (M,labels,x{j},k);
  end
  return;
end

d = L2_distance (M(query,:)',M');
[ds,di] = sort(d);

nbrindices = di(2:k+1);
nbrs.original = labels{query};
nbrs.labels = labels(nbrindices);
nbrs.distances = ds(2:k+1);
