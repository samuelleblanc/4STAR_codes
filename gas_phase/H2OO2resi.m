function resi=H2OO2resi(x0,meas,PAR)
%to determine  states (parameters/unknowns/x0) by minimizing error using fmincon
% meas are measurements
% PAR are additional parameters (e.g. water vapor coef and O2)
% x0 is U initial guess (from coef calculations of water vapot only;ch4 guess is zero)
% modified: July 24 2014
% MS
% MS: 2014/07/25 : added 2nd order poly to fit

% initial parameter values
%----------------------------------------------
wv_acoef = PAR(:,1);
wv_bcoef = PAR(:,2);
o2_coef  = PAR(:,3);

% measured data
%--------------------------
Xdat=meas(:,1);
Ydat=meas(:,2);

% water vapor transmittance model
%---------------------------------
Twmodel =  exp(-wv_acoef.*(x0(:,1)).^wv_bcoef).*exp(-(o2_coef.*x0(:,2)))...
           .*exp(-(x0(:,3) + x0(:,4)*Xdat + x0(:,5)*Xdat.^2));% 2nd order poly added to fit
% adjust objective function if ==zero
Twmodel(Twmodel==0) = 1e-12;
Y_model = -log(Twmodel);

% residual
%-----------------
resi=sum((Y_model-Ydat).^2);