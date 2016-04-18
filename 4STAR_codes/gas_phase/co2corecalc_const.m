function [CH4conc CO2conc CO2resi co2OD] = co2corecalc_const(s,ch4coef,co2coef,wln,tau_OD,x0)
% retrieve using 1.555-1.630 region (CH4 and CO2)
% const is for constrained by initial guess from
% linear inversion
%------------------------------------------------
% MS, Mar 11, 2014
% MS, July 25, 2014
% MS, 2014-11-17, refined struct names, added output variable
%------------------------------------------------
ODfit = zeros(length(s.t),length(s.w));
tau_co2ch4_subtract = tau_OD;
%------------------------------------------------

sc=[];
sc_residual = [];

for i = 1:length(s.t)
           
    %x0 = [500 500 0.75 0.8 -2]; 
    y = s.rateslant(i,wln);
    meas = [s.w(wln)' y'];
    %y = (tau_OD(i,wln));
    %meas = [s.w(wln)' y'];
    PAR  = [ch4coef(wln) co2coef(wln)];
       % Set Options
       
       options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-6,'Display','notify-detailed','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
       
       
       % bounds
%            lb = [0 0 -10 -10 -10];
%            ub = [1000 1000 20 20 20];
           % use [ch4,co2,const,linear term]
           lb = min(real(x0));
           ub = max(real(x0));
 
       % check spectrum validity for conversion
       ypos = logical(y>=0); ylarge = logical(y>=2);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15 && sum(ylarge)<10 && sum(isinf(y))==0
          
            [U_,fval,exitflag,output]  = fmincon('CH4CO2resi_lin',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            
                if isNaN(U_(1)) || ~isreal(U_(1)) || U_(1)<0

                        U_ = [NaN NaN NaN NaN];% add second order poly
                        sc = [sc; U_];
                        sc_residual = [sc_residual;NaN];
                end
  
                sc = [sc; real(U_)];
                sc_residual = [sc_residual;real(fval)];
                co2_conc_ = (real(U_(2)));%/starsun.m_H2O(i); 
                co2_round = round(co2_conc_*100)/100;
               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
               % plot fitted figure
             
                   yopt_ =  exp(-(ch4coef(wln).*real(U_(1)))).*exp(-(co2coef(wln).*real(U_(2)))).*exp(-(U_(3) + U_(4)*meas(:,1)));
                   yopt  = real(-log(yopt_));
               
               % assign fitted spectrum
               % ODfit(i,wln) = yopt + baseline(i,:)'; %(add subtracted baseline to retrieved fit);
               
               % assign fitted spectrum
                ODfit(i,wln) = yopt;
                % save spectrum to subtract
                tau_co2ch4_subtract(i,wln) = -log(exp(-(ch4coef(wln).*real(U_(1)))).*exp(-(co2coef(wln).*real(U_(2)))));
                      figure(444);
                      plot(starsun.w(wln),y,'-b');hold on;
                      plot(starsun.w(wln),yopt,'--r');hold on;
                      plot(starsun.w(wln),tau_aero_subtract(i,wln),'-c');hold on;
                      plot(starsun.w(wln),y-tau_aero_subtract(i,wln),'-k');hold off;
                      xlabel('wavelength','fontsize',12);ylabel('total OD','fontsize',12);
                      legend('measured','calculated (fit)','spectrum to subtract','subtracted spectrum');
                      title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Altavg(i)) 'm' ' CO2= ' num2str(co2_round) '[atm x cm]']);
                      ymax = yopt + 0.2;
                      axis([min(starsun.w(wln)) max(starsun.w(wln)) 0 max(ymax)]);
                      pause(0.0001);
                % subtract fitted spectrum from slant
                % tau_aero_subtract(i,wln) = tau_ODslant(i,wln) - ODfit(i,wln) + baseline(i,:);
       else
          
               U_ = [NaN NaN NaN NaN];
               sc = [sc; U_];
               sc_residual = [sc_residual;NaN];
           
       end
       
end

%% correct spectrum to subtract
% order2=1;  % order of baseline polynomial fit
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
%   %s


%%

CH4conc = sc(:,1);
CO2conc = sc(:,2);
CO2resi = sc_residual;
co2OD   = ODfit;
%co2subtract=spectrum_sub;
% co2spec = spectrum_sub;




