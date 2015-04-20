function [NO2conc NO2resi no2OD tau_aero_subtract] = no2corecalc(starsun,no2coef,o4coef,o3coef,wln,tau_OD,nm_startpca,nm_endpca)
% retrieve no2 and derive fitted spectrum for subtraction
%-------------------------------------------------------
% MS: July, 26, 2014: NO2 fit (430-490 nm region)
% MS, 2015-04-15, added nm_startpca, nm_endpca to define
%                 wavelength boundaries of pca filtered
%                 spectra
%                 corrected bug to subtract tau_ray
%                 used first order polynomial as basis (instead of 2nd)
%----------------------------------------------------------------------
ODfit = zeros(length(starsun.t),length(starsun.w));
tau_no2_subtract = tau_OD;
%------------------------------------------------

sc=[];
sc_residual = [];
no2_DU = [];

for i = 1:length(starsun.t)
           
    %x0 = [0.3 1 0.3 0.05 -0.1 0.5]; % this is initial guess (-2 for 6th element -0.1 for 7th element)
    x0 = [0.3 1 0.3 0.05 -0.1];     % this is initial guess (-2 for 6th element -0.1 for 7th element)
    if size(tau_OD,2)<1556 && nargin > 6
         y = (tau_OD(i,nm_startpca:nm_endpca));
    elseif size(tau_OD,2)<1556
        y = (tau_OD(i,:));
    else
        y = (tau_OD(i,wln));
    end
    meas = [starsun.w(wln)' y'];
    PAR  = [no2coef(wln)/1000 o4coef(wln)*100000 o3coef(wln)];
       % Set Options
       
       options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','notify-detailed','TolX',1e-12,'MaxFunEvals',1000);%optimset('Algorithm','sqp','TolFun',1e-12);%optimset('MaxIter', 400);
       
       
       % bounds
            lb = [0 0 0.2 -2 -2];
            ub = [2 5 1 2 2];
%            lb = [0 0 0.2 -2 -2 -2];
%            ub = [0.2 5 0.5 2 2 2];%this is with o4 *10000
           
 
       % check spectrum validity for conversion
       ypos = logical(y>=0);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15 && sum(isinf(y))==0
            ylarge = logical(y>=5);
            if sum(ylarge)<10
            [U_,fval,exitflag,output]  = fmincon('NO2resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            end
                if ~isreal(U_(1)) || U_(1)<0

%                         U_ = [NaN NaN NaN NaN NaN NaN NaN];
%                         sc = [sc; U_];
%                         sc_residual = [sc_residual;NaN];
                          U_(1) = NaN; U_(2) = NaN; U_(3) = NaN; U_(4) = NaN; U_(5) = NaN; 
                end
  
             sc = [sc; real(U_)];
             sc_residual = [sc_residual;real(fval)];
                no2_conc_ = (real(U_(1)));%/starsun.m_O3_avg(i); % this is already DU
                %no2_round = round(no2_conc_*100)/100;% this is slant in atmxcm
                no2_DU_    = (no2_conc_)/starsun.m_NO2(i); %no2_DU_round = round(no2_DU_);
                no2_DU = [no2_DU;no2_DU_];
               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
               % plot fitted figure
             
%                    yopt_ =  exp(-(((no2coef(wln))/1000).*real(U_(1)))).*exp(-(o4coef(wln).*10000*real(U_(2)))).*exp(-(o3coef(wln).*real(U_(3))))...
%                             .*exp(-(U_(4) + U_(5)*meas(:,1) + U_(6)*meas(:,1).^2));
                   yopt_ =  exp(-(((no2coef(wln))/1000).*real(U_(1)))).*exp(-(o4coef(wln).*100000.*real(U_(2)))).*exp(-(o3coef(wln).*real(U_(3))))...
                            .*exp(-(U_(4) + U_(5)*meas(:,1)));
                   yopt  = -log(yopt_);
                   yno2subtractall   =  -log(exp(-((no2coef(wln)/1000).*real(U_(1)))).*exp(-(o4coef(wln).*100000.*real(U_(2)))).*exp(-(o3coef(wln).*real(U_(3)))));
                   yno2subtract   =  -log(exp(-((no2coef(wln)/1000).*real(U_(1)))));
                   yo4subtract   =  -log(exp(-(o4coef(wln).*100000.*real(U_(2)))));
                   yo3subtract  =  -log(exp(-(o3coef(wln).*real(U_(3)))));
                   linesubtract = -log(exp(-(U_(4) + U_(5)*meas(:,1))));
                   
                   if size(tau_OD,2)<1556 && nargin >6
                       tau_no2_subtract(i,nm_startpca:nm_endpca)   = y'-yno2subtractall;
                   elseif size(tau_OD,2)<1556
                       tau_no2_subtract(i,:)   = y'-yno2subtractall;
                   else
                       tau_no2_subtract(i,wln) = y'-yno2subtractall;
                   end
               
               % assign fitted spectrum to subtract
                ODfit(i,wln) = yno2subtractall;
                % save spectrum to subtract
                %tau_aero_subtract(i,wln) = -log(exp(-(no2coef(wln).*real(U_(1)))).*exp(-(o4coef(wln).*real(U_(2)))).*exp(-(o3coef(wln).*real(U_(3)))));
%                 if ~isNaN(U_(1))
%                          figure(444);
%                          plot(starsun.w(wln),y,'-b');hold on;
%                          %plot(starsun.w(wln),-log(Tmodel),'--c');hold on;
%                          plot(starsun.w(wln),yopt,'--r');hold on;
%                          plot(starsun.w(wln),yno2subtract,'--g');hold on;
%                          plot(starsun.w(wln),yo4subtract,'--c');hold on;
%                          plot(starsun.w(wln),yo3subtract,'--m');hold on;
%                          %plot(starsun.w(wln),y'-yno2subtractall,':k');hold off;
%                          %plot(starsun.w(wln),-log(exp(-(U_(4) + U_(5)*meas(:,1)))),':y');hold on;
%                          %plot(starsun.w(wln),y'-linesubtract,':m');hold on;
% %                          plot(starsun.w(wln),y'-linesubtract - yo4subtract*5,':c');hold on;
% %                          plot(starsun.w(wln),y'-linesubtract - yo4subtract - yo3subtract,':y');hold on;
% %                          plot(starsun.w(wln),y'-linesubtract - yno2subtract,':g');hold on;
%                         plot(starsun.w(wln),y'-yno2subtract - yo4subtract - yo3subtract,':k');hold off;
%                         xlabel('wavelength','fontsize',12);ylabel('total OD','fontsize',12);
%                         legend('measured','calculated (fit)','no2 spectrum to subtract','o4 spectrum to subtract','o3 spectrum to subtract','subtracted spectrum');
%                         title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Alt(i)) 'm' ' NO2= ' num2str(no2_DU_) '[DU]']);
%                         ymax = yopt + 0.2;
%                         axis([min(starsun.w(wln)) max(starsun.w(wln)) 0 max(ymax)]);
%                         pause(0.0001);
%                 end
                % subtract fitted spectrum from slant
                % tau_aero_subtract(i,wln) = tau_ODslant(i,wln) - ODfit(i,wln);
                % hold on; plot(starsun.w(wln),yopt,'--g'); legend('measured','calculated (opt)','spectrum to subtract');
       else
          
               U_ = [NaN NaN NaN NaN NaN];
               sc = [sc; U_];
               sc_residual = [sc_residual;NaN];
               no2_DU = [no2_DU;NaN];
               
               if size(tau_OD,2)<1556
                    tau_aero_subtract(i,:) = NaN(1,length(wln));
               else
                    tau_aero_subtract(i,wln) = NaN(1,length(wln));
               end
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
NO2conc = no2_DU;
NO2resi = sc_residual;
no2OD   = ODfit;
%no2subtract=spectrum_sub;




