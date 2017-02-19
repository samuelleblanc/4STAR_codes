function out  = nadanan( bad )
% nadanan returns 0 for all values of bad==0 (or false) else NaN
% This function is useful in conjunction with plotting commands to suppress
% certain values without concern for generating empty plotting arguments as
% in >> plot(time, nadana(x<0)+x, 'o'); to suppress plotting values of x < 0
out = zeros(size(bad));
out(bad~=0) = NaN;

return


