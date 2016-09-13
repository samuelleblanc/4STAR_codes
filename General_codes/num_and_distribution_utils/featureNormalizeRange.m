function [In_norm, mu, range] = featureNormalizeRange(In)

%   featureNormalizeRange Normalizes the features/targets in matrix In
%   (can be input/target values)and returns a normalized version of In where
%   the mean value of each feature (i.e., along a column) is 0 (mean subtracted) and there is a
%   division by the feature (column wise) values range (values will be
%   between -1 and 1)

mu_ = nanmean(In);
mu  = repmat(mu_,size(In,1),1);
% nanfilt = isnan(In);

% range = max(In(nanfilt==0)) - min(In(nanfilt==0));

max_In = max(In);
min_In = min(In);
range_ = max_In - min_In;
range  = repmat(range_,size(In,1),1);

In_norm = (In - mu)./range;

% ============================================================

end
