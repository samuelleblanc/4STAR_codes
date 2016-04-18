function resi=CH4CO2resi_lin(x0,meas,PAR)
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
Idat=meas(:,2);
% Xdat=meas(:,1);
% Ydat=meas(:,2);

% transmittance model
%---------------------------------

I_meas  = log(Idat) + ch4_coef.*x0(:,1)+ co2_coef.*x0(:,2) + x0(:,3)*ones(length(Xdat),1) + x0(:,4)*(Xdat);% use second order
I_model = log(c0);%o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*log(Xdat);

% test figure
% figure(101);
% plot(Xdat,I_model,'-b');hold on;
% plot(Xdat,log(Idat),'-k'); hold on;
% plot(Xdat,I_meas,'--r');hold off;
% legend('model','meas','fitted meas');


% Tmodel =  exp(-(ch4_coef.*x0(:,1))).*exp(-(co2_coef.*x0(:,2))).*exp(-(x0(:,3) + x0(:,4)*Xdat));
% % adjust objective function if ==zero
% Tmodel(Tmodel==0) = 1e-12;
% Y_model = -log(Tmodel);

% residual
%-----------------
resi=sum((I_meas - I_model).^2);

%resi=sum((Y_model-Ydat).^2);