function [h,filename]=spzen(source, varargin)

% makes a 2-D plot to show 4STAR data.
%
% This code is the same as starchart.m except for the fixed first and third
% input.
% 
% See starchart.m.
% 
% Yohei, 2015/11/09

[h,filename]=starchart(@plot, source, 'starzen.mat', varargin{:});