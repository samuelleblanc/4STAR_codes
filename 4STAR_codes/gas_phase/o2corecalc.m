function [O2conc O2resi o2OD] = o2corecalc(starsun,o2coef,wln,tau_ODslant)
% retrieve using O2 bands (0.68 and 0.76)
%------------------------------------------------
% MS, Mar 11, 2014
% MS, July 25, 2014: added 2nd order poly to fit
%------------------------------------------------
ODfit = zeros(length(starsun.t),length(starsun.w));
tau_aero_subtract = tau_ODslant;
%------------------------------------------------

sc=[];
sc_residual = [];

for i = 1:length(starsun.t)
           
    x0 = [5 0.75 0.8 -2]; 
    y = (tau_ODslant(i,wln));
    meas = [starsun.w(wln)' y'];
    PAR  = [o2coef(wln)*10000];
       % Set Options
       
       options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-6,'Display','notify-detailed','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
       
       
       % bounds
           lb = [0 -10 -10 -10];
           ub = [10 20 20 20];
           
 
       % check spectrum validity for conversion
       ypos = logical(y>=0);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-10 && sum(isinf(y))==0
            ylarge = logical(y>=2);
            if sum(ylarge)<10
            [U_,fval,exitflag,output]  = fmincon('O2resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            end
            
                %if isNaN(U_(1)) || ~isreal(U_(1)) || U_(1)<0
                if ~isreal(U_(1)) || U_(1)<0

%                         U_ = [NaN NaN NaN NaN];
%                         sc = [sc; U_];
%                         sc_residual = [sc_residual;NaN];
                          U_(1) = NaN;
                end
  
                sc = [sc; real(U_)];
                sc_residual = [sc_residual;real(fval)];
                o2_conc_ = (real(U_(1)));%/starsun.m_H2O_avg(i); 
                o2_round = round(o2_conc_*100)/100;
               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
               % plot fitted figure
             
                   yopt_ =  exp(-(o2coef(wln).*real(U_(1)))).*exp(-(U_(2) + U_(3)*meas(:,1) + U_(4)*meas(:,1).^2));
                   yopt  =  real(-log(yopt_));
                   yo2   =  real(-log(exp(-(o2coef(wln).*real(U_(1))))));
               
               % assign fitted spectrum
               ODfit(i,wln) = yopt;
               %ODfit(i,wln) = yopt + baseline(i,:)'; %(add subtracted baseline to retrieved fit);
               % save spectrum to subtract
               tau_aero_subtract(i,wln) = -log(exp(-(o2coef(wln).*real(U_(1)))));
%                    figure(444);
%                    plot(starsun.w(wln),y,'-b');hold on;% measurement
%                    plot(starsun.w(wln),yopt,'--r');hold on;
%                    plot(starsun.w(wln),yo2,'--g');hold on;
%                    plot(starsun.w(wln),y'-yo2,'--k');hold off;
%                    xlabel('wavelength','fontsize',12);ylabel('total OD','fontsize',12);
%                    legend('measured','calculated (opt)','amount to subtract','spectrum after subtraction');
%                    title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Altavg(i)) 'm' ' O2= ' num2str(o2_round) '[atm x cm]']);
%                    ymax = yopt + 0.2;
%                    axis([min(starsun.w(wln)) max(starsun.w(wln)) 0 max(ymax)]);
%                    pause(0.0001);

               % subtract derived amount from total OD
               % tau_aero_subtract(i,wln) = tau_ODslant(i,wln) - ODfit(i,wln) + baseline(i,:);
       else
          
               U_ = [NaN NaN NaN NaN];
               sc = [sc; U_];
               sc_residual = [sc_residual;NaN];
           
       end
       
end

%% correct spectrum to subtract
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
%   %s


%%
O2conc = sc(:,1);
O2resi = sc_residual;
o2OD   = ODfit;
%o2subtract=spectrum_sub;
%o2spec = spectrum_sub;


