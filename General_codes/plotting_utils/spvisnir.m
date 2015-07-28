function [h,filename]=spvisnir(source, varargin)

% makes a 2-D plot to show 4STAR data.
%
% This code is the same as starchart.m except for the fixed first and third
% input.
% 
% See starchart.m.
% 
% Yohei, 2013/07/28

[h,filename]=starchart(@plot, source, '*i*_*', varargin{:});