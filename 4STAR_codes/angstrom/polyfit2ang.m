function [A,Ap,curvature,ext]=polyfit2ang(lambda,a2,a1,a0)

% Returns modified Angstrom exponent at "lambda" (a vector containing
% wavelengths in um). Input "a2" and "a1" are John's second order
% polynomial fit parameters... get them from polyfitaod.m for example.
% Ap is the slope of modified Angstrom exponent that O'Neill uses. See polyfit2FMF.m. 
% curvature is 2a2, or -Ap. 
% ext can be calculated if a0 is given as input. 
% Yohei, this note made on 2010/03/17, code made earlier.

A=(-2)*a2(:)*log(lambda(:)')-repmat(a1(:),1,length(lambda));
curvature=2*a2;
Ap=(-2)*repmat(a2(:),1,length(lambda)); 
% 20091010, this is correct, John has convinced me. 
%20091003, now I think this is wrong, as this is dA/dln(lambda). 
% Ap=(-2)*repmat(a2(:),1,length(lambda))./lambda; 
% 20091003, this is dA/d(lambda).
if nargout>=4
    if nargin<4;
        error('Extinction not calculated. Give a0.');
    else
        ext=exp(a2*log(lambda).^2+a1*log(lambda)+repmat(a0,size(lambda)));
    end
end;