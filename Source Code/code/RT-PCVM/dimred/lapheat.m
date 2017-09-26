function [E,V] = lapheat(DATA,lodim,nn,step,stepsbtwnreport,opts)

% LAPHEAT Laplacian Eigenmaps Algorithm with Heat Kernel weights.
%
% [E,V] = lapbin(DATA,lodim,[nn,step,stepsbtwnreport])
%
% DATA is a N x hidim matrix representing N points in R^hidim
% lodim is a positive integer; you want to map the points in DATA
%   to R^lodim.
% nn is the number of nearest neighbors used to create the graph
%   (10 by default)
% step is a value that can be modified to optimize this code's
%   running on your machine.  L2_distance is called on a step x N matrix.
% The number of points processed is reported every step *
%   stepsbtwnreport points processed.
% opts is what is supplied to eigs (type 'help eigs' for details)
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
% Note that this runs the Normalized Laplacian Eigenmaps algorithm,
% not the suboptimal unnormalized one in the original paper.

if nargin < 3, nn = 10;end
if nargin < 4, step=128;end
if nargin < 5, stepsbtwnreport=5;end
if nargin < 6,
  opts.tol = 1e-9;
  opts.maxit = 200;
  opts.issym=1; 
  opts.disp = 2; 
end

[E,V] = laplacian_underlying(DATA,lodim,nn,step,stepsbtwnreport,opts,1,1,0);

