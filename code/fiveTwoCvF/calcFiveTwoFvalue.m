function [ f,win,sigWin ] = calcFiveTwoFvalue( errors )
%CALCFIVEXTWOFVALUE CCalculates the f value of a given error matrix for one
% dataset.
% Requires 5x4 error matrix. Required column form: errClass11,
% errClass21, errClass12, errClass22.
% Returns calculated f value. Win == 1 when the first classifier has won, win ==-1
% when the second classifier has won and 0 in case of a tie.
% sigWin is 1 if the win is significant. Test with ten and five
% degrees of freedom. F(10,5) - Distribution
% -----------------------------------------------------------------------
%INPUT:
% errors: 5x4 error matrix of two classifiers in percent.
%OUTPUT:
% f - F value of the 5x2 cv F test
% win - -1,0,1 with respect to the performance
% sigWin - 1 if it is a significant win. 0 if not.

if size(errors) == [5,4]
    % Fold one
    p1 = errors(:,1) - errors(:,2);
    
    % Fold two
    p2 = errors(:,3) - errors(:,4);
    
    % Average fold one
    piAv = (p1 + p2) ./ 2;
    
    
    si = (p1 - piAv).^2 + (p2 - piAv).^2;
    
    sumP1 = sum(p1.^2);
    sumP2 = sum(p2.^2);
    sumP = sumP1 + sumP2;
    sumS = sum(si);
    
    f = (sumP) ./ (2*sumS);
    
    if f > 4.74
        sigWin = 1;
    else
        sigWin = 0;
    end
    
    p1OneWins = find(p1<0);
    p2OneWins = find(p2<0);
    
    oneWins = size(p1OneWins,1) + size(p2OneWins,1);
    
    if oneWins > 5
        win = 1;
    elseif oneWins < 5
        win = -1;
    else
        win = 0;
    end
else
    fprintf('Matrix must have size of (5,2)');
end


end

