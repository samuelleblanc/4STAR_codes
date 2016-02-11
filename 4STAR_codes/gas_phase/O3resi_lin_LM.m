function I_meas=O3resi_lin_LM(x0,meas,PAR)
% linear constrained minimization to retrieve O3 in the 490-680 nm band
% meas are measurements
% PAR are additional parameters (e.g. o3, o4, water vapor coef and c0 TOA)
% x0 is U initial guess
% Xdat is wavelength grid
% Idat is measured counts (slant)
% I_meas is measured modified by gases absorption to fit TOA
% I_model is TOA counts (i.e. 4STAR's c0)
% written by Michal Segal, 2015-04-21, NASA Ames
% Modification History:

% initial parameter values
%----------------------------------------------
o3_coef  = PAR(:,1);
o4_coef  = PAR(:,2);
h2o_coef = PAR(:,3);
c0       = PAR(:,4);

% measured data
%--------------------------
Xdat=meas(:,1);
Idat=meas(:,2);

% meas and model representations
%---------------------------------

I_meas  = log(Idat) + o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*(Xdat) + x0(:,6)*(Xdat).^2 + x0(:,7)*(Xdat).^3;
%I_meas  = log(Idat) -( o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*(Xdat) + x0(:,6)*(Xdat).^2);
I_model = log(c0);%o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*log(Xdat);

%test figure
figure(101);
plot(Xdat,I_model,'-b');hold on;
plot(Xdat,log(Idat),'-k'); hold on;
plot(Xdat,I_meas,'--r');hold off;
legend('model','meas','fitted meas');

return;