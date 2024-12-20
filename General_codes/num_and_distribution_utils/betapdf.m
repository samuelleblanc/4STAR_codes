function y = betapdf(x,a,b)
%BETAPDF Beta probability density function.
%	Y = BETAPDF(X,A,B) returns the beta probability density 
%	function with parameters A and B at the values in X.
%
%	The size of Y is the common size of the input arguments. A scalar input  
%	functions as a constant matrix of the same size as the other inputs.	 
%	References:
%	   [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%	   Functions", Government Printing Office, 1964, 26.1.33.
%	Copyright (c) 1993 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 2013/12/11 06:01:34 $
if nargin < 3, 
   error('Requires three input arguments.');
end
[errorcode x a b] = distchck(3,x,a,b);
if errorcode > 0
    error('The arguments must be the same size or be scalars.');
end
% Initialize Y to zero.
y = zeros(size(x));
% Return NaN for parameter values outside their respective limits.
k1 = find(a <= 0 | b <= 0 | x < 0 | x > 1);
if any(k1)
    y(k1) = NaN * ones(size(k1)); 
end
% Return the beta density function for valid parameters.
k = find(~(a <= 0 | b <= 0 | x < 0 | x > 1));
if any(k)
    y(k) = x(k) .^ (a(k) - 1) .* (1 - x(k)) .^ (b(k) - 1) ./ beta(a(k),b(k));
end
