function F = O3resi_nonlin(x0,xdata,PAR)
% x0,xdata,y_model',lb,ub,options,PAR (O3resi_nonlin(x0,xdata,ydata,PAR)
% non-linear constrained minimization to retrieve O3 in the 490-680 nm band
% meas are measurements
% PAR are parameters (e.g. o3, o4, water vapor coef and c0 TOA)
% x0 is U initial guess
% Xdat is wavelength grid
% Idat is measured counts (slant)
% I_meas is measured modified by gases absorption to fit TOA
% I_model is TOA counts (i.e. 4STAR's c0)
% ai parameters are for stretch/shift (initial guess)
% bi parameters are for offset (input as initial guess)
% written by Michal Segal, 2015-04-21, NASA Ames
% Modification History:
%----------------------------------------------

% initial parameter values
%----------------------------------------------
o3_coef  = PAR(:,1);
o4_coef  = PAR(:,2);
h2o_coef = PAR(:,3);
c0       = PAR(:,4);
meas     = PAR(:,5);

a0       = x0(:,8);
%a1       = x0(:,9);
%a2       = x0(:,10);
b0       = x0(:,9);
%b1       = x0(:,12);
%b2       = x0(:,13);

% measured data
%--------------------------
lambda=xdata;
Idat  =meas;

% determine delta function (deltaLambda)
delta = a0;% + a1.*lambda + a2.*lambda.^2;

% dtermine offset function
offset = b0;% + b1.*lambda + b2.*lambda.^2;

% implement on measured counts
I_dat0 = interp1(lambda, Idat, lambda+delta,'pchip');
I_dat01= I_dat0 + offset;

% measured and modeled representations
%--------------------------------------
I_meas  = log(I_dat01) + o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(lambda),1) + x0(:,5)*(lambda) + x0(:,6)*(lambda).^2 + x0(:,7)*(lambda).^3;
I_model = log(c0);

figure(101);
plot(lambda,I_model,'-b');hold on;
plot(lambda,log(Idat),'-k'); hold on;
plot(lambda,log(I_dat0),'--k'); hold on;
plot(lambda,log(I_dat01),':k'); hold on;
plot(lambda,I_meas,'--r');hold off;
legend('model','meas original grid','measured shifted grid','measured shift+offset','fitted meas');

% objective Function
%-------------------
F=I_meas;

return;