function [w, mad, abs_dev] = madf1(A, thresh);
%[w, mad, abs_dev] = MADF1(A, thresh);
% Requires A, threshold optional
% Marks maximum deviant as not good, if abs_dev exceeds MAD by more than thresh

if ~exist('thresh','var')
    thresh = 6;
end

A_bar = zeros(size(A));
mad = A_bar;
abs_dev = A_bar;
w = true(size(A));
goodA = find(isfinite(A));
if length(A(goodA))>0
%    A_bar = exp(mean(log(A(goodA)))); %geometric mean
   A_bar = mean(A(goodA));
   abs_dev(goodA) = abs(A(goodA)-A_bar);
   mad = mean(abs_dev(goodA));
   [maxa, maxi] = max(abs_dev(goodA));
   %%
   w(goodA(maxi)) = maxa<=(thresh*mad);
   %%
end

