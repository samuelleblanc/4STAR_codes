function y = nanmean1(x)

% same as nanmean except when the number of rows is one.

if size(x,1)>1
    y = nanmean(x);
else
    y = x;
end