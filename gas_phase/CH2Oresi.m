function resi=CH2Oresi(x0,meas,PAR)
%to determine  states (parameters/unknowns/x0) by minimizing error using fmincon
% meas are measurements
% PAR are additional parameters (e.g. water vapor coef and CH4 that needs to go
% into the function)
% x0 is U initial guess (from coef calculations of water vapot only;ch4/co2 guess is arbitrary)
% modified: Mar 10 2014
% MS

% initial parameter values
%----------------------------------------------
ch2o_coef = PAR(:,1);
Bro_coef  = PAR(:,2);
o4_coef   = PAR(:,3);

% measured data
%--------------------------
%Xdat=meas(:,1);
 Ydat=meas(:,1);

% transmittance model
%--------------------
Twmodel =  exp(-(ch2o_coef.*x0(:,1))).*exp(-(Bro_coef.*x0(:,2))).*exp(-(o4_coef.*x0(:,3)));
% adjust objective function if ==zero
Twmodel(Twmodel==0) = 1e-12;
Y_model = -log(Twmodel);

% residual
%-----------------
resi=sum((Y_model-Ydat).^2);