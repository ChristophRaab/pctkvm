function [E,V] = lapsim(DATA,lodim)

% LAPHEAT Laplacian Eigenmaps Algorithm with similarity weights.
%
% [E,V] = lapbin(DATA,lodim,[nn,step,stepsbtwnreport])
%
% DATA is a N x N SPARSE matrix  ; DATA(i,j) is positive if i and j are
%   similar points, higher means more similarity.
% lodim is a positive integer; you want to map the points in DATA
%   to R^lodim.
% 
% E is a N x lodim matrix represnting the same N points in R^lodim.
% V is a vector with the lodim smallest positive eigenvectors.
% 
%  E(:,i) and V(i) are the i-th smallest positive eigenvectors/values.
%
% Original code by Misha Belkin (misha@cs.uchicago.edu)
% Modified by Dinoj Surendran (dinoj@cs.uchicago.edu), April/May 2004
%
%  Implements algorithm in Belkin & Niyogi Dec 2001 pages 4-5.
%

% May as well send these arguments in, they wont be used anyway

if nargin < 3, nn = 10;end
if nargin < 4, step=128;end
if nargin < 5, stepsbtwnreport=5;end
if nargin < 6,
  opts.tol = 1e-9;
  opts.maxit = 200;
  opts.issym=1; 
  opts.disp = 2; 
end

[E,V] = laplacian_underlying(DATA,lodim,nn,step,stepsbtwnreport,opts,-1,1,0);

