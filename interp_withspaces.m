%% Details of the program:
% NAME:
%   interp_withspaces
%
% PURPOSE:
%  To create an interpolated array, but only for the segments that have space 
%  between adjacent values no larger than defined. The rest is set to a
%  fill_value
%
% CALLING SEQUENCE:
%   ynew = interp_withspaces(xold,yold,xnew,space,fill_value,varargin)
%
% INPUT:
%  xnew: new x value to which the returned y values correspond
%  yold: old y values
%  xold: old abscissa values correponding to yold
%  space: minimum space allowed between xold values which will be
%     interpolated (default 0.1)
%  fill_value: the spaces that are not interpolated will be filled by this
%     value (default NaN)
%  varargin: other variables used as input to interp1d
%
% OUTPUT:
%  ynew: interpolated with fill spaces of y values
%
% DEPENDENCIES:
%  - version_set.m
%  None
%
% NEEDED FILES:
%  None
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, July, 21st, 2015
%
% -------------------------------------------------------------------------

function ynew = interp_withspaces(xold,yold,xnew,space,fill_value,varargin)
version_set('v1.0');
if (~exist('fill_value'))
    fill_value = nan;
end
if (~exist('space'))
    space = 0.1;
end
ynew = xnew * 0.0 + fill_value;
if length(xold)>1
    xsep = diff(xold);
    iis = find(xsep>space);
    if (~isempty('iis'))
        istart = [1,iis'+1];
        iend = [iis',length(xold)];
        for i=1:length(istart)
           i_tointerp = find((xnew>xold(istart(i))-space/2.0)&((xnew<xold(iend(i))+space/2.0)));
           if (~isempty(i_tointerp))
               ynew(i_tointerp) = interp1(xold,yold,xnew(i_tointerp));
           end
        end
    else
        ynew = interp1(xold,yold,xnew)
    end
else
    [m,i] = min(abs(xnew-xold));
    ynew(i) = yold;
end
end