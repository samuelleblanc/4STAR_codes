function resi=O3resi(x0,meas,PAR)
%to determine  states (parameters/unknowns/x0) by minimizing error using fmincon
% meas are measurements
% PAR are additional parameters (e.g. o3, o4, water vapor coef and pre-factors of polynomial fit)
% x0 is U initial guess (from coef calculations)
% modified: July 25 2014
% MS

% initial parameter values
%----------------------------------------------
o3_coef  = PAR(:,1);
o4_coef  = PAR(:,2);
h2o_coef = PAR(:,3);
a0 = PAR(:,4);
a1 = PAR(:,5);
a2 = PAR(:,6);
b0 = PAR(:,7);
b1 = PAR(:,8);
b2 = PAR(:,9);

% measured data
%--------------------------
Xdat=meas(:,1);
Ydat=meas(:,2);

% CJF: I think I_meas would take the place of Ydat in the optimization 
delta = a0 + a1.*Xdat + a2.*Xdat.^2;
I_meas = interp1(Xdat, Ydat, Xdat+delta,'pchip');

offset = b0+b1.*Xdat + b2.*Xdat.^2;
I_meas = I_meas + offset;




% ozone band transmittance model
%---------------------------------
% Tmodel = exp(-(o3_coef.*x0(:,1))).*exp(-(o4_coef.*x0(:,2))).*exp(-(h2o_coef.*x0(:,3)))...
%                             .*exp(-(x0(:,4) + x0(:,5)*Xdat + x0(:,6)*Xdat.^2 + x0(:,7)*Xdat.^3));
% Tmodel = exp(-(o3_coef.*x0(:,1))).*exp(-(o4_coef.*x0(:,2))).*exp(-(h2o_coef.*x0(:,3)))...
%                             .*exp(-(x0(:,4) + x0(:,5)*Xdat + x0(:,6)*Xdat.^2));
% Tmodel = exp(-(o3_coef.*x0(:,1))).*exp(-(o4_coef.*x0(:,2))).*exp(-(h2o_coef.*x0(:,3)))...
%                             .*exp(-(x0(:,4) + x0(:,5)*Xdat));


% adjust objective function if ==zero
% Tmodel(Tmodel==0) = 1e-12;
% Y_model = -log(Tmodel);
Y_model = o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*log(Xdat);

% residual
%-----------------
resi=sum((Y_model-Ydat).^2);