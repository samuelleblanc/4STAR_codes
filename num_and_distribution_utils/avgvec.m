function [s,sn]=avgvec(vector, index)

% take the average of the elements in "vector" (can be a matrix with dimension
% pv*qv) between the start and end indices (1 - pv) specified by the p*2
% matrix "index". See also sumvec, stdvec.m and varvec.m.
 
[s,sn]=sumvec(vector, index);
s=s./sn;