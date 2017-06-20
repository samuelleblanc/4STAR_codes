function [xs,ii] = nfsmooth(x,w);
% function to do a fast smooth on data with nan 
% x is data, w is window, outputs smooth xs, and ii are the non nan indices
ii = ~isnan(x);
if any(ii);
xs = fastsmooth(x(ii),w,1,1);
else;
    ii = [1 2 3];
    xs = [NaN NaN NaN];
end;
return