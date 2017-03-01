function [eta, Af, A, Ap]=polyfit2FMF(lambda,a2,a1)

% Starting from second-order polynomial fit to the AOD, calculates the
% optical fraction of fine-mode particles (eta) and a fine-mode Ångstro¨m
% exponent (Af) after O'Neill et al. [2001, Applied Optics]. 

[A,Ap]=polyfit2ang(lambda,a2,a1);
[eta, Af]=ONeillFMF(A,Ap);