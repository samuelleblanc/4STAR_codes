function [rawrelstd,rawstd,rawmean] = starrawrelstd(t,valid,raw,datatype,instrumentname,twindow);
%% Details of the program:
% NAME:
%   starrawrelstd
%
% PURPOSE:
%  To generate the 2STAR plots for quicklooks
%
% INPUT:
%  t: time array in matlab time format
%  valid: array to use for only valid points, usually shutter, is used when ==1
%  raw: raw counts array
%  datatype: string with the data type (i.e. 'vis_sun')
%  instrumentname: string with the instrumentname (defaults to 4STAR)
%  twindow: time window to average in seconds (defaults to 9 seconds)
%
% OUTPUT:
%  rawrelstd: relative standard deviation of the raw counts
%  rawstd: moving standard deviation of the raw counts
%  rawmean: moving mean of the raw counts
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  None
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Mauna Loa Observatory, 2017-06-03
%                 based on the starwrapper codes
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%% Sanitize inputs
if nargin<6;
    twindow = 9.0;
    if nargin<5;
        instrumentname='4STAR';
        if nargin<4;
            error('Not enough inputs to calculate rawrelstd')
        end;
    end;
end;
pp=numel(t);

%% get the parameters for the calculation
ti=twindow/86400;
if ~strcmp(instrumentname,'2STAR');
    if strmatch('vis', lower(datatype(1:3)));
        cc=408;
    elseif strmatch('nir', lower(datatype(1:3)));
        cc=169;
    else;
        cc=[408 169+1044];
    end;
else;
    cc=61;
end;
rawstd=NaN(pp, numel(cc));
rawmean=NaN(pp, numel(cc));

for i=1:pp;
    rows=find(t>=t(i)-ti/2&t<=t(i)+ti/2 & valid==1);
    if numel(rows)>0;
        rawstd(i,:)=nanstd(raw(rows,cc),0,1); % stdvec.m seems to have a precision problem.
        rawmean(i,:)=nanmean(raw(rows,cc),1);
    end;
end;
rawrelstd=rawstd./rawmean;


return;