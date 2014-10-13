function resi=O2resi(x0,meas,PAR)
% to determine  states (parameters/unknowns/x0) by minimizing error using fmincon
% meas are measurements
% PAR are additional parameters (e.g. o2 abs coef that needs to go into the function)
% x0 is U initial guess from o2 corecalc
% modified: July 23 2014
% MS

% initial parameter values
%----------------------------------------------
o2_coef = PAR(:,1);

% measured data
%--------------------------
Xdat=meas(:,1);
Ydat=meas(:,2);

% water vapor transmittance model
%---------------------------------
Tmodel =  exp(-(o2_coef.*x0(:,1))).*exp(-(x0(:,2) + x0(:,3)*Xdat + x0(:,4)*Xdat.^2));
% adjust objective function if ==zero
Tmodel(Tmodel==0) = 1e-12;
Y_model = -log(Tmodel);

% residual
%-----------------
resi=sum((Y_model-Ydat).^2);