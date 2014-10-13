function [h,filename]=ssvis(source, varargin)

% makes a 2-D scatter plot to show 4STAR data.
%
% This code is the same as starchart.m except for the fixed first and third
% input.
% 
% See starchart.m.
% 
% Yohei, 2013/07/28

[h,filename]=starchart(@scatter, source, 'vis_*', varargin{:});