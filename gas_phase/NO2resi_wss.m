function resi=NO2resi_wss(x0,meas,PAR)
%to determine  states (parameters/unknowns/x0) by minimizing error using fmincon
% meas are measurements
% PAR are additional parameters (e.g. o3, o4, water vapor coef and pre-factors of polynomial fit)
% x0 is U initial guess (from coef calculations)
% modified: July 25 2014
% MS

% initial parameter values
%----------------------------------------------
no2_coef  = PAR(:,1);
o4_coef   = PAR(:,2);
o3_coef   = PAR(:,3);
Ashift    = PAR(:,4);
% measured data
%--------------------------
Xdat=meas(:,1);
Ydat=meas(:,2);

% transmittance model
%--------------------
% Tmodel = exp(-(no2_coef.*x0(:,1))).*exp(-(o4_coef.*x0(:,2))).*exp(-(o3_coef.*x0(:,3)))...
%                             .*exp(-(x0(:,4) + x0(:,5)*Xdat +
%                             x0(:,6)*Xdat.^2));% this was original no2
% Tmodel = exp(-(no2_coef.*x0(:,1))).*exp(-(o4_coef.*x0(:,2))).*exp(-(o3_coef.*x0(:,3)))...
%                             .*exp(-(x0(:,4) + x0(:,5)*Xdat)); % this was
%                              for recent no2
Y_model = no2_coef.*x0(:,1) + o4_coef.*x0(:,2) + o3_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*Xdat + x0(:,6)*Ashift;
% adjust objective function if ==zero
% Tmodel(Tmodel==0) = 1e-12;
% Y_model = -log(Tmodel);

% residual
%-----------------
resi=sum((Y_model-Ydat).^2);