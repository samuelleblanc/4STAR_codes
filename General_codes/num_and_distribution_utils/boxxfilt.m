function [yf, sn] = boxxfilt(x, y, xbl)

% function yf = boxxfilt(x, y, xbl)
% Apply a boxcar filter. 
% The filter length, xbl, defines the width of x over which its variable y is filtered.
% x and y must be a vector, either row or column.
% 
% Boxxfilt improved boxfilt's capability of smoothing time series data.
% Boxxfilt, with x as an additional input variable, averages over a
% constant time period even when the target data has varying time intervals
% or NaNs.
% 
% This code works fast, because no iteration is made.
%  
% Example:
%     x=[1:100 201:5:300];
%     y=rand(length(x),10)*10+repmat(x(:),1,10);
%     yf=boxxfilt(x, y, 10);
%     ybf=boxfilt(y(:,5), 11);
%     figure;
%     plot(x, y(:,5), 'ok', x, ybf, '.b', x, yf(:,5), '.r');
%     legend('unfiltered data', 'boxfilt', 'boxxfilt', 2);
% 
% See also BOXFILT and AVEVEC
% Yohei, 2004-11-30.  This code was developed from boxfilt.m.
% Yohei, 2013/07/30, now accepts a matrix y. x must be a vector.

% check the input variables
if min(size(x))~=1; % if x is not a vector
    error('x must be a vector.');
elseif length(x)~=size(y,1);
    if length(x)==size(y,2);
        y=y';
    else
        error('x and y must have the same length.');
    end;
end;
yf=repmat(NaN, size(y));
sn=zeros(size(y));
x=x(:);
y(isfinite(x)==0,:)=NaN;
lok=size(y,1);

% sort y in the ascending order of x
[x1, i]=sort(x);
y1=[zeros(1,size(y,2));y(i,:)];
isfy=isfinite(y1);
y1(isfy==0)=0;

% apply a filter
cs=cumsum(y1);
csisfy=cumsum(isfy);
idx=1:lok;
oka=[1;find(diff(x1)>0)+1];
okd=[find(diff(x1)>0);lok];
minr=interp1(x1(oka), idx(oka), x1-xbl/2, 'linear'); 
minr=ceil(minr); 
minr(find(isnan(minr)==1))=1;
maxr=interp1(x1(okd), idx(okd), x1+xbl/2, 'linear'); 
maxr2=ceil(maxr);
sa=maxr2-maxr;
maxr2(find(sa==0))=maxr2(find(sa==0))+1;
maxr=maxr2;
maxr(find(isnan(maxr)==1))=lok+1;
sn=csisfy(maxr,:)-csisfy(minr,:);
yf=(cs(maxr,:)-cs(minr,:))./sn; % divide the sum of elements by the number of them
