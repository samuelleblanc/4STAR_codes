function [s,sn]=sumvec(vector, index)

% take the sum of the elements in "vector" (can be a matrix with dimension
% pv*qv) between the start and end indices (1 - pv) specified by the p*2
% matrix "index". See also stdvec.m and varvec.m.
 
[s,sn]=varvec(vector, index, NaN);