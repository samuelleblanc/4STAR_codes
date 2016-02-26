function [O3conc,H2Oconc,O4conc,O3resi,o3OD,allvar] = o3corecalc_lin_adj_4poly(s,o3coef,o4coef,h2ocoef,wln,tau_OD,x0)
% retrieve o3 and derive fitted spectrum for subtraction
% x0 is initial guess from linear inversion
%
% MS, 2015-04-18, changed function to retrieve using 2nd derivative 
%                 instead of 3rd
% MS, 2015-04-20, changed retrieval to use first order poly
%------------------------------------------------------------------
% MS, July, 24, 2014
% MS, 2015-04-21, modified to use linear contrained fit on rate
%                 instaed od OD
% MS, 2015-10-21, converted O4 and H2O to be in vertical amount
% MS, 2016-01-29, adjusted routine takes input the linear inversion
%                 values and subtracts baseline
%------------------------------------------------------------------
ODfit = zeros(length(s.t),length(s.w));
tau_o3o4h2o_subtract = tau_OD;
%------------------------------------------------

sc=[];
sc_residual = [];
o3_DU = [];

for i = 1:length(s.t)
    
    % 3nd order initial guess:o3-300h2o-5000;o4-10000      
    %x0 = [0.3 1 0.5 0.1 0 0.1 0]; 
    
    % counts measured (slant total minus Ray)
    %y = s.ratetot(i,wln);
    % counts measured (slant total)
    y = s.rateslant(i,wln);% this is total, not ray subtracted
    meas = [s.w(wln)' y'];
    lm = meas(:,1);
    %PAR  = [o3coef(wln) o4coef(wln)*10000 h2ocoef(wln)*10000 s.c0(wln)'];
    PAR  = [o3coef(wln) o4coef(wln) h2ocoef(wln) s.c0(wln)'];%s.kurO3
    %PAR  = [o3coef(wln) o4coef(wln)*10000 h2ocoef(wln)*10000 300*s.kurO3'];
    
       % Set Options
       
       %options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','notify-detailed','TolX',1e-12,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
        options = optimset('Algorithm','interior-point','LargeScale','off','TolFun',1e-4,'Display','notify-detailed','TolX',1e-4,'MaxFunEvals',1000);
        %options = optimset('Algorithm','levenberg-marquardt');
       
     
       % boundary conditions for slant path
         lb = [0 0 0 0 -1 -1 -1];
         ub = [5 50 10 5 0 1 1];% 3rd order
         
         lb = min(real(x0));
         ub = max(real(x0));
         %ub = [5 50 10 5 0 2 2];% 3rd order
         %ub = [10 50 10 5 0 2 2];% 3rd order
 
       % check spectrum validity for conversion
       ypos = logical(y>0);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15 && sum(isinf(y))==0
            signal=logical(y<=10);
            if sum(signal)<10
                                if isreal(x0(i,:))

                                    [U_,fval,exitflag,output]  = fmincon('O3resi_lin_4poly',x0(i,:),[],[],[],[],lb,ub, [], options, meas,PAR);
                %                     % testing nonlinear option
                %                     x0 = [x0,0,0];
                %                     
                %                     [U_,fval,exitflag,output]  = fmincon('O3resi_nonlin',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
                %                     [U_,fval,resnorm,exitflag,output] = lsqcurvefit(@(x0)O3resi_lin_LM(x0,meas,PAR),x0,lm,y',[],[],options); 

                            %end

                                if ~isreal(U_(1)) || U_(1)<0 %|| (exist(exitflag) && exitflag~=1)
                                        U_(1) = NaN;U_(2) = NaN; U_(3) = NaN;
                                end

                                sc = [sc; real(U_)];
                                sc_residual = [sc_residual;real(fval)];
                                o3_conc_ = (real(U_(1)))/s.m_O3(i); 
                                o3_round = round(o3_conc_*100)/100;% this is vertical (tau_aero is slant) in atmxcm
                                o3_DU_    = (o3_conc_*1000);       % conversion to DU
                                o3_DU_round = round(o3_DU_);
                                o3_DU = [o3_DU;o3_DU_];

                               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

                               % plot fitted figure

                %                    yfit = o3coef(wln).*U_(1)+ o4coef(wln).*U_(2) + h2ocoef(wln).*U_(3) + U_(4)*ones(length(lm),1) + U_(5)*(lm) + U_(6)*(lm).^2 + U_(7)*(lm).^3 + U_(8)*(lm).^4;    
                %                    %yfit = o3coef(wln).*U_(1)+ 10000*o4coef(wln).*U_(2) + 10000*h2ocoef(wln).*U_(3) + U_(4)*ones(length(lm),1) + U_(5)*(lm) + U_(6)*(lm).^2;
                %                    ymeas = log(s.c0(wln))-log(y);
                %                   
                %                    
                %                    yo3subtract   =  (o3coef(wln).*real(U_(1)));
                %                    yo4subtract   =  (o4coef(wln).*real(U_(2)));
                %                    yh2osubtract  =  (h2ocoef(wln).*real(U_(3)));
                %                    polysubtract  =  U_(4)*ones(length(lm),1) + U_(5)*(lm) + U_(6)*(lm).^2 + U_(7)*(lm).^3 + U_(8)*(lm).^3;
                %                    yo3subtractall=  yo3subtract + yo4subtract + yh2osubtract;
                %                
                %                 % assign fitted spectrum
                %                 ODfit(i,wln) = yfit;
                %                 % save spectrum to subtract
                %                 tau_o3o4h2o_subtract(i,wln) = yo3subtractall/s.m_O3(i);
                %                 %% plot measured and computed fit
                %                        figure(444);
                %                        ax(1)=subplot(211);
                %                        plot(s.w(wln),ymeas,'-b');hold on;
                %                        plot(s.w(wln),yfit,'--r');hold on;
                %                        plot(s.w(wln),yo3subtract,'--g');hold on;
                %                        plot(s.w(wln),yo4subtract,'--c');hold on;
                %                        plot(s.w(wln),yh2osubtract,'--m');hold on;
                %                        plot(s.w(wln),polysubtract,'-k');hold on;
                %                        plot(s.w(wln),ymeas'-yo3subtractall,':k');hold off;
                %                        xlabel('wavelength','fontsize',12);ylabel('total slant OD','fontsize',12);
                %                        legend('measured','calculated (fit)','o3 spectrum to subtract','o4 spectrum to subtract','h2o spectrum to subtract','aerosol baseline','subtracted spectrum');
                %                        title([datestr(s.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(s.Alt(i)) 'm' ' VCD O3= ' num2str(o3_DU_round) '[DU]' ' RMS fit = ' num2str(sqrt(fval))]);
                %                        ymax = yfit + 0.2;
                %                        axis([min(s.w(wln)) max(s.w(wln)) 0 max(ymax)]);
                % 
                %                        ax(2)=subplot(212);
                %                        plot(s.w(wln),ymeas'-yo4subtract-yh2osubtract-polysubtract,'-b');hold on;% o3 measured
                %                        plot(s.w(wln),yo3subtract,'--r');hold on;                               % o3 retrieved
                %                        plot(s.w(wln),ymeas'-yo4subtract-yh2osubtract-yo3subtract-polysubtract,':k');hold off;% o3 residual
                %                        xlabel('wavelength','fontsize',12);ylabel('SC O_{3} OD','fontsize',12);
                %                        legend('O_{3} measured','O_{3} fitted','residual','orientation','horizontal');
                %                        axis([min(s.w(wln)) max(s.w(wln)) -0.02 0.15]);
                %                        pause(0.0001);

                             else

                               U_ = [NaN NaN NaN NaN NaN NaN NaN];
                               sc = [sc; U_];
                               sc_residual = [sc_residual;NaN];
                               o3_DU = [o3_DU;NaN];

                             end % if isreal x0   
            else
               U_ = [NaN NaN NaN NaN NaN NaN NaN];
               sc = [sc; U_];
               sc_residual = [sc_residual;NaN];
               o3_DU = [o3_DU;NaN];
               
           end     % test if values are not too high (clouds/instrument issues)
           
       else
          
               U_ = [NaN NaN NaN NaN NaN NaN NaN];
               sc = [sc; U_];
               sc_residual = [sc_residual;NaN];
               o3_DU = [o3_DU;NaN];
           
       end
       
end

%% save variables
O3conc  = o3_DU;
O4conc  = sc(:,2)./s.m_ray; % scaling back retrieved values due to scale down of coef
H2Oconc = sc(:,3)./s.m_H2O;% scaling back retrieved values due to scale down of coef
O3resi  = sqrt(sc_residual);
o3OD    = ODfit;
allvar  = sc;
return;




