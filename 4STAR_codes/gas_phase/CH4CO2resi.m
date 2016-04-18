function resi=CH4CO2resi(x0,meas,PAR)
%to determine  states (parameters/unknowns/x0) by minimizing error using fmincon
% meas are measurements
% PAR are additional parameters (e.g. water vapor coef and CH4 that needs to go
% into the function)
% x0 is U initial guess (from coef calculations of water vapot only;ch4/co2 guess is arbitrary)
% modified: Mar 10 2014
% MS
% MS: July, 24, 2014: added 2nd order polynomial to fit

% initial parameter values
%----------------------------------------------
ch4_coef = PAR(:,1);
co2_coef = PAR(:,2);

% measured data
%--------------------------
Xdat=meas(:,1);
Ydat=meas(:,2);

% transmittance model
%---------------------------------
Tmodel =  exp(-(ch4_coef.*x0(:,1))).*exp(-(co2_coef.*x0(:,2))).*exp(-(x0(:,3) + x0(:,4)*Xdat + x0(:,5)*Xdat.^2));
% adjust objective function if ==zero
Tmodel(Tmodel==0) = 1e-12;
Y_model = -log(Tmodel);

% residual
%-----------------
resi=sum((Y_model-Ydat).^2);