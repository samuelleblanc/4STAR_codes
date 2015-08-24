function [s,sn]=stdvec(varargin);

% take the standard deviation of the elements in "vector" (can be a matrix
% with dimension pv*qv) between the start and end indices (1 - pv)
% specified by the p*2 matrix "index". See also sumvec.m and varvec.m.

[s0, sn]=varvec(varargin{:});
s = sqrt(s0);
