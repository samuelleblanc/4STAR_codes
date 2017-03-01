function [eta, Af]=ONeillFMF(A,Ap);

% calculates the optical fraction of fine-mode particles (eta) and a
% fine-mode Ångstro¨m exponent (Af) after O'Neill et al. [2001, Applied
% Optics].

% set parameters
Ac=-0.15; % given in O'Neill et al. [2001, Applied Optics] near the end of Page 2
% Ac=-0; % given in O'Neill et al. [2001, Applied Optics] near the end of Page 2
Acp=0.0; % near the end of Page 2
a=-0.22; % Page 3, right after equation (7)
b=0.43; % Page 3, right after equation (7)
c=1.4; % Page 3, right after equation (7)

% calculate parameters
bstar=b+2*Ac; % Page 3, right after equation (9)
cstar=c-Acp+(b+a*Ac)*Ac; % Page 3, right after equation (9)
t=A-Ac-(Ap-Acp)./(A-Ac); % Page 2, equation (4)
the_square_bracket=(t+bstar).^2+4*cstar*(1-a); % the square bracket in Page 3, equation (9) 
Af=1/2/(1-a)*((t+bstar)+(the_square_bracket).^(1/2))+Ac; % Page 3, equation (9)
eta=(A-Ac)./(Af-Ac); % Page 2, equation (6)