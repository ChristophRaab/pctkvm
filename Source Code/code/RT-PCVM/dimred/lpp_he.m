function Y = LPP(X, Kneighbor, ReducedDim)

% X is the original data matrix. Each column vector of X is a data point.
% Kneighbor is the parameter for K-nearest neighbor search.
% It is always set to be 4,5,6, or 7.
% ReducedDim is the dimensionality of the reduced subspace.

    NDimension = size(X, 1)
    NData = size(X, 2)
    
    W = ConstructAdjacencyGraph(X, NData, Kneighbor);
    
    D = diag(sum(W));
    L = D - W;
      
    DPrime = X*D*X';
    LPrime = X*L*X';
    SToPowerMinusHalf = zeros(NDimension, NDimension);

    [U S] = eig(DPrime);
    for i = 1 : length(S)
        if(S(i, i) > 0)
            SToPowerMinusHalf(i, i) = S(i, i)^(-1/2);
        else
            SToPowerMinusHalf(i, i) = 0;
        end
 
    [B dump] = eig(SToPowerMinusHalf*U'*LPrime*U*SToPowerMinusHalf);
    % A is the projection matrix
    A = U * SToPowerMinusHalf * B;
    Y = A(:, 1:ReducedDim)' * X;
end
                
function W = ConstructAdjacencyGraph(X, NData, Kneighbor)
    W = zeros(NData, NData);

    for i = 1 : NData
        for j = 1 : NData
            W(i, j) = norm(X(:, i) - X(:, j));
        end
    end
    [dumb idx] = sort(W, 2); % sort each row

    W = zeros(NData, NData);
    for i = 1 : NData
        for j = 2 : Kneighbor+1
            W(i, idx(i, j)) = 1;
            W(idx(i,j), i) = 1;
        end
    end
end %  function W = ConstructAdjacencyGraph(X, NData)
