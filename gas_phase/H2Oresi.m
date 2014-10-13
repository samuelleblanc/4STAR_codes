function resi=H2Oresi(x0,meas,PAR)
%to determine  states (parameters/unknowns/x0) by minimizing error using fmincon
% meas are measurements
% PAR are additional parameters (e.g. water vapor coef that needs to go
% into the function)
% x0 is U initial guess (from coef calculations)
% modified: Mar 3 2014
% MS
% MS: 2014/07/25 : added 2nd order poly to fit

% initial parameter values
%----------------------------------------------
wv_acoef=PAR(:,1);
wv_bcoef=PAR(:,2);

% measured data
%--------------------------
Xdat=meas(:,1);
Ydat=meas(:,2);

% water vapor transmittance model
%---------------------------------
Twmodel =  exp(-wv_acoef.*(x0(:,1)).^wv_bcoef).*exp(-(x0(:,2) + x0(:,3)*Xdat + x0(:,4)*Xdat.^2));% 2nd order poly added to fit
% adjust objective function if ==zero
Twmodel(Twmodel==0) = 1e-12;
Y_model = -log(Twmodel);

% residual
%-----------------
resi=sum((Y_model-Ydat).^2);