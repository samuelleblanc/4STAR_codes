function [O3conc H2Oconc O4conc O3resi o3OD] = o3corecalc(starsun,o3coef,o4coef,h2ocoef,wln,tau_OD)
% retrieve o3 and derive fitted spectrum for subtraction
%-------------------------------------------------------
% MS, July, 24, 2014
%-------------------------------------------------------
ODfit = zeros(length(starsun.t),length(starsun.w));
tau_o3o4h2o_subtract = tau_OD;
% subtract baseline
% order2=1;  % order of baseline polynomial fit
% poly3=zeros(length(starsun.w(wln)),length(starsun.UTavg));  % calculated polynomial
% poly3_c=zeros(length(starsun.UTavg),(order2)+1);            % polynomial coefficients
% order_in2=1;
% thresh_in2=0.01;
% % deduce baseline
% for i=1:length(starsun.UTavg)
% % function (fn) can be: 'sh','ah','stq','atq'
% % for gui use (visualization) write:
% % [poly2_,poly2_c_,iter,order,thresh,fn]=backcor(wvis(wln_ind),starsun.tau_aero(goodTime(i),wln_ind));
%         % perform baseline on vertical total OD (rayleigh excluded)
%         [poly3_,poly3_c_,iter,order_lin,thresh,fn] = backcor(starsun.w(wln),tau_ODslant(i,wln),order_in2,thresh_in2,'atq');% backcor(wavelength,signal,order,threshold,function);
%         poly3(:,i)=poly3_;        % calculated polynomials
%         poly3_c(i,:)=poly3_c_';   % polynomial coefficients
% 
%         % plot AOD baseline interpolation and real AOD values
% %                   figure(1111)
% %                   plot(starsun.w(wln),tau_OD(i,wln),'.b','markersize',8);hold on;
% %                   plot(starsun.w(wln),poly3_,'-r','linewidth',2);hold off;
% %                   legend('AOD','AOD baseline');title(num2str(starsun.UTavg(i)));
% %                   pause(0.01);  
% 
% end
%  
%  % assign spectrum, baseline and subtracted spectrum
%      tau_aero=real(poly3);
%  
%      baseline = (tau_aero)';%this is slant
%      spectrum = tau_ODslant(:,wln);
%      spectrum_sub = (spectrum-baseline);%./repmat(starsun.m_aero,1,qqvis);
%  %s

%------------------------------------------------

sc=[];
sc_residual = [];
o3_DU = [];

for i = 1:length(starsun.t)
           
    x0 = [0.3 1 0.5 0.75 0.8 -2 -0.1]; % this is initial guess;o3-300h2o-5000;o4-10000
    y = (tau_OD(i,wln));
    meas = [starsun.w(wln)' y'];
    PAR  = [o3coef(wln) o4coef(wln)*10000 h2ocoef(wln)*10000];
       % Set Options
       
       options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','notify-detailed','TolX',1e-12,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
       
       
       % bounds
           lb = [0 0 0 -10 -10 -10 -10];
           ub = [1 5 1 20 20 20 20];%o3-1000;h2o-10000o4-50000
           
 
       % check spectrum validity for conversion
       ypos = logical(y>=0);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15 && sum(isinf(y))==0
            ylarge=logical(y>=7);
            if sum(ylarge)<10
            [U_,fval,exitflag,output]  = fmincon('O3resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            end
            
                if ~isreal(U_(1)) || U_(1)<0

%                         U_ = [NaN NaN NaN NaN NaN NaN NaN];
%                         sc = [sc; U_];
%                         sc_residual = [sc_residual;NaN];
                U_(1) = NaN;U_(2) = NaN; U_(3) = NaN;
                end
  
             sc = [sc; real(U_)];
             sc_residual = [sc_residual;real(fval)];
                o3_conc_ = (real(U_(1)));%/starsun.m_O3(i); 
                o3_round = round(o3_conc_*100)/100;% this is vertical (tau_aero is slant) in atmxcm
                o3_DU_    = (o3_conc_*1000);%/starsun.m_O3(i); 
                o3_DU_round = round(o3_DU_);
                o3_DU = [o3_DU;o3_DU_];
               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
               % plot fitted figure
             
                   yopt_ =  exp(-(o3coef(wln).*real(U_(1)))).*exp(-(o4coef(wln).*10000*real(U_(2)))).*exp(-(h2ocoef(wln).*10000*real(U_(3))))...
                            .*exp(-(U_(4) + U_(5)*meas(:,1) + U_(6)*meas(:,1).^2 + U_(7)*meas(:,1).^3));
                   yopt  = -log(yopt_);
                   yo3subtractall   =  -log(exp(-(o3coef(wln).*real(U_(1)))).*exp(-(o4coef(wln).*10000*real(U_(2)))).*exp(-(h2ocoef(wln).*10000*real(U_(3)))));
                   yo3subtract   =  -log(exp(-(o3coef(wln).*real(U_(1)))));
                   yo4subtract   =  -log(exp(-(o4coef(wln).*10000*real(U_(2)))));
                   yh2osubtract  =  -log(exp(-(h2ocoef(wln).*10000*real(U_(3)))));
               
               % assign fitted spectrum
                ODfit(i,wln) = yopt;
                % save spectrum to subtract
                tau_o3o4h2o_subtract(i,wln) = -log(exp(-(o3coef(wln).*real(U_(1)))).*exp(-(o4coef(wln).*real(U_(2)))).*exp(-(h2ocoef(wln).*real(U_(3)))));
%                       figure(444);
%                       plot(starsun.w(wln),y,'-b');hold on;
%                       plot(starsun.w(wln),yopt,'--r');hold on;
%                       %plot(starsun.w(wln),-log(Tmodel),'--r');hold off;
%                       plot(starsun.w(wln),yo3subtract,'--g');hold on;
%                       plot(starsun.w(wln),yo4subtract,'--c');hold on;
%                       plot(starsun.w(wln),yh2osubtract,'--m');hold on;
%                       plot(starsun.w(wln),y'-yo3subtractall,':k');hold off;
%                       %plot(starsun.w(wln),tau_aero_subtract(i,wln),'-c');hold on;
%                       %plot(starsun.w(wln),spectrum_sub(i,:),':c');hold on;
%                       %plot(starsun.w(wln),y-tau_aero_subtract(i,wln),'-k');hold on;
%                       %plot(starsun.w(wln),y-spectrum_sub(i,:),':k');hold on;
%                       xlabel('wavelength','fontsize',12);ylabel('total OD','fontsize',12);
%                       legend('measured','calculated (fit)','o3 spectrum to subtract','o4 spectrum to subtract','h2o spectrum to subtract','subtracted spectrum');
%                       title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Altavg(i)) 'm' ' O3= ' num2str(o3_DU_round) '[DU]']);
%                       ymax = yopt + 0.2;
%                       axis([min(starsun.w(wln)) max(starsun.w(wln)) 0 max(ymax)]);
%                       pause(0.0001);
                % subtract fitted spectrum from slant
                % tau_aero_subtract(i,wln) = tau_ODslant(i,wln) - ODfit(i,wln);
                % hold on; plot(starsun.w(wln),yopt,'--g'); legend('measured','calculated (opt)','spectrum to subtract');
       else
          
               U_ = [NaN NaN NaN NaN NaN NaN NaN];
               sc = [sc; U_];
               sc_residual = [sc_residual;NaN];
               o3_DU = [o3_DU;NaN];
           
       end
       
end

%% correct spectrum for subtraction
% subtract baseline
%  order2=1;  % order of baseline polynomial fit
%  poly3=zeros(length(starsun.w(wln)),length(starsun.UTavg));  % calculated polynomial
%  poly3_c=zeros(length(starsun.UTavg),(order2)+1);            % polynomial coefficients
%  order_in2=1;
%  thresh_in2=0.01;
%  % deduce baseline
%  for i=1:length(starsun.UTavg)
%  % function (fn) can be: 'sh','ah','stq','atq'
%  % for gui use (visualization) write:
%  % [poly2_,poly2_c_,iter,order,thresh,fn]=backcor(wvis(wln_ind),starsun.tau_aero(goodTime(i),wln_ind));
%          % perform baseline on vertical total OD (rayleigh excluded)
%          [poly3_,poly3_c_,iter,order_lin,thresh,fn] = backcor(starsun.w(wln),tau_aero_subtract(i,wln),order_in2,thresh_in2,'atq');% backcor(wavelength,signal,order,threshold,function);
%          poly3(:,i)=poly3_;        % calculated polynomials
%          poly3_c(i,:)=poly3_c_';   % polynomial coefficients
%  
%          % plot AOD baseline interpolation and real AOD values
%  %                   figure(1111)
%  %                   plot(starsun.w(wln),tau_OD(i,wln),'.b','markersize',8);hold on;
%  %                   plot(starsun.w(wln),poly3_,'-r','linewidth',2);hold off;
%  %                   legend('AOD','AOD baseline');title(num2str(starsun.UTavg(i)));
%  %                   pause(0.01);  
%  
%  end
%   
%   % assign spectrum, baseline and subtracted spectrum
%       tau_aero=real(poly3);
%   
%       baseline = (tau_aero)';%this is slant
%       spectrum = tau_aero_subtract(:,wln);
%       spectrum_sub = (spectrum-baseline);%./repmat(starsun.m_aero,1,qqvis);

%%
O3conc = o3_DU;
O4conc = 10000*sc(:,2);% scaling back retrieved values sue to scale down of coef
H2Oconc = 10000*sc(:,3);% scaling back retrieved values sue to scale down of coef
O3resi = sc_residual;
o3OD   = ODfit;
%o3subtract=spectrum_sub;




