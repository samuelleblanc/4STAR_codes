function [HCOHconc, HCOHresi, O3conc, O4conc, NO2conc, BrOconc,allvar] = hcohcorecalc_lin(s,hcohcoef,o4coef,o3coef,no2coef,brocoef,wln,tau_OD)
% [NO2conc, NO2resi, no2OD, tau_aero_subtract,allvar] = no2corecalc_lin(s,no2coef,o4coef,o3coef,wln,tau_OD)
% retrieve no2 and derive fitted spectrum for subtraction
% MS, 2015-04-18, changed function to retrieve using 2nd derivative 
%                 instead of 3rd
% MS, 2015-04-20, changed retrieval to use first order poly
%------------------------------------------------------------------
% MS, July, 24, 2014
% MS, 2015-04-21, modified to use linear contrained fit on rate
%                 instaed od OD
%------------------------------------------------------------------
ODfit = zeros(length(s.t),length(s.w));
tau_subtract = tau_OD;
%------------------------------------------------

sc=[];
sc_residual = [];
hcoh_DU = [];
no2_DU = [];
error = [];

for i = 1:length(s.t)
    
    %    hcoh o4 o3 bro no2 intcpt slope 2nd 3rd    
    x0 = [1e-3 10 0.6 1e-3 1e-3 0.1 0 0.1 0];
    
    % counts measured (slant total minus Ray)
    y = s.ratetot(i,wln);
    meas = [s.w(wln)' y'];
    lm = meas(:,1);
    PAR  = [hcohcoef(wln) o4coef(wln)*100000 o3coef(wln) brocoef(wln) no2coef(wln) s.c0(wln)'];
    
    to = [ones(length(wln),1) s.w(wln)' ((s.w(wln)').^2) (s.w(wln)').^3];
%     [Q R] = gram_schmidt(to);
%     no2_on = Q'*no2coef(wln)'*R;
%     gc = [to no2coef(wln) o3coef(wln) (log(s.c0(wln))-log(y))'];
%     gc2 =[so Q(:,2)];
%     [Q,R] = gram_schmidt(gc);
%     [Q2 R2]= gram_schmidt(gc2);
    
    A = [to PAR(:,1:end-1)];
    b = (log(s.c0(wln))-log(y))';
    if issparse(A), [Q,R,e]=qr(A,'vector');
    else R = triu(qr(A));  [Q,rr,e]=qr(A,'vector'); end
    x = R\(R'\(A'*b));
    xhcoh= Q*rr(:,3)*x(5);
    xo4  = Q*rr(:,6)*x(6);
    xo3  = Q*rr(:,5)*x(7);
    xbro = Q*rr(:,1)*x(8);
    xno2 = Q*rr(:,2)*x(9);
    
    r = b - A*x;
    err = R\(R'\(A'*r));
    error = [error;err'];
    x = x + err;
    
%     figure(1111);
%     plot(s.w(wln),b-A(:,[1:4,6:end])*x([1:4,6:end]),'-k');hold on;% diff hcoh meas
%     plot(s.w(wln),xhcoh,':r');hold off;legend('hcoh meas','hcoh fit');
%     title(['i= ',num2str(i)]);
%     
%     figure(2222);
%     plot(s.w(wln),b-A(:,[1:end-1])*x([1:end-1]),'-k');hold on;% diff hcoh meas
%     plot(s.w(wln),xno2,':r');hold off;legend('no2 meas','no2 fit');
%     title(['i= ',num2str(i)]);
%     
%     figure(3333);
%     plot(s.w(wln),b-A(:,[1:7,9])*x([1:7,9]),'-k');hold on;% diff hcoh meas
%     plot(s.w(wln),xbro,':r');hold off;legend('bro meas','bro fit');
%     title(['i= ',num2str(i)]);
    
       % Set Options
       
       options  = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-6,'Display','notify-detailed','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
       %options = optimset('Algorithm','interior-point','LargeScale','off','TolFun',1e-5,'Display','notify-detailed','TolX',1e-5,'MaxFunEvals',1000);
       
     
       % boundary conditions for slant path
%          lb = [0 0 0 0 -1 -2 -2];
%          ub = [2 5 1 5 0 2 2];% 3rd order% toonoisy results
         lb = [0 0 0 0 0 0 -1 -1 -1];
         ub = [1 50 5 1 1 5 0 1 1];% 3rd order
 
       % check spectrum validity for conversion
       ypos = logical(y>0);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15 && sum(isinf(y))==0
            signal=logical(y<=10);
            if sum(signal)<10
                    [U_,fval,exitflag,output]  = fmincon('HCOHresi_lin',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            end
            
                if ~isreal(U_(1)) || U_(1)<0 %|| (exist(exitflag) && exitflag~=1)
                        U_(1) = NaN;U_(2) = NaN; U_(3) = NaN;
                end
  
                sc = [sc; real(U_)];
                sc_residual = [sc_residual;real(fval)];
                %hcoh_conc_ = (real(U_(1)))/s.m_NO2(i); % convert from atmxcm to DU and slant to vertical
                hcoh_conc_ = ((x(5)))/s.m_NO2(i); % convert from atmxcm to DU and slant to vertical
                no2_conc_  = ((x(9))*1000)/s.m_NO2(i);
                hcoh_round = round(hcoh_conc_*100)/100;% this is vertical (tau_aero is slant) in atmxcm
                hcoh_DU_    = (hcoh_conc_)*1000;       % conversion to DU
                hcoh_DU_round = round(hcoh_DU_*100)/100;
                hcoh_DU = [hcoh_DU;hcoh_DU_];
                no2_DU  = [no2_DU;no2_conc_];
                
               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
               
               % plot fitted figure
             
                   yfit = (hcohcoef(wln)).*U_(1)+ 10000*o4coef(wln).*U_(2) + o3coef(wln).*U_(3) + (no2coef(wln)).*U_(4) +...
                          (brocoef(wln)).*U_(5) + U_(6)*ones(length(lm),1) + U_(7)*(lm) + U_(8)*(lm).^2 + U_(9)*(lm).^3;      
                   ymeas = log(s.c0(wln))-log(y);
                  
                   
                   yhcohsubtract   = (((hcohcoef(wln))).*real(U_(1)));
                   yo4subtract   =  (o4coef(wln).*10000*real(U_(2)));
                   yo3subtract  =  (o3coef(wln).*real(U_(3)));
                   yno2subtract   = (((no2coef(wln))).*real(U_(4)));
                   ybrosubtract   = (((brocoef(wln))).*real(U_(5)));
                   polysubtract  =  U_(6)*ones(length(lm),1) + U_(7)*(lm) + U_(8)*(lm).^2 + U_(9)*(lm).^3;
                   yhcohsubtractall=  yhcohsubtract + yo4subtract + yo3subtract +yno2subtract + ybrosubtract;
               
                % assign fitted spectrum
                ODfit(i,wln) = yfit;
                % save spectrum to subtract
                tau_subtract(i,wln) = (ymeas'-yhcohsubtractall)/s.m_NO2(i);%yno2subtractall/s.m_NO2(i);
                %% plot measured and computed fit
%                        figure(444);
%                        ax(1)=subplot(311);
%                        plot(s.w(wln),ymeas,'-b');hold on;
%                        plot(s.w(wln),yfit,'--r');hold off;
%                        legend('measured','calculated (fit)');
%                        ax(2)=subplot(312);
%                        plot(s.w(wln),yno2subtract,'--g');hold on;
%                        plot(s.w(wln),yo4subtract,'--c');hold on;
%                        plot(s.w(wln),yo3subtract,'--m');hold on;
%                        plot(s.w(wln),polysubtract,'-k');hold on;
%                        plot(s.w(wln),ymeas'-yhcohsubtractall,':k');hold off;
%                        xlabel('wavelength','fontsize',12);ylabel('total slant OD','fontsize',12);
%                        legend('HCOH spectrum to subtract','o4 spectrum to subtract','o3 spectrum to subtract','no2 spectrum to subtract','BrO spectrum to subtract','aerosol baseline','subtracted spectrum');
%                        title([datestr(s.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(s.Alt(i)) 'm' ' VCD HCOH= ' num2str(hcoh_DU_round) '[DU]' ' RMS fit = ' num2str(sqrt(fval))]);
%                        %ymax = yfit + 0.2;
%                        %axis([min(s.w(wln)) max(s.w(wln)) 0 max(ymax)]);
%                        ax(3)=subplot(313);
%                        plot(s.w(wln),ymeas'-yo4subtract-yo3subtract-polysubtract,'-b');hold on; %  measured
%                        plot(s.w(wln),yhcohsubtract,'--r');hold on;                              %  retrieved
%                        plot(s.w(wln),ymeas'-yhcohsubtract - yo4subtract-yo3subtract-yno2subtract-ybrosubtract - polysubtract,':k');hold off;%  residual
%                        xlabel('wavelength','fontsize',12);ylabel('SC HCOH OD','fontsize',12);
%                        legend('HCOH measured','HCOH fitted','residual','orientation','horizontal');
%                        %axis([min(s.w(wln)) max(s.w(wln)) -0.02 0.15]);
% 
%                        pause(0.0001);
            else

                       U_ = [NaN NaN NaN NaN NaN NaN NaN NaN NaN];
                       sc = [sc; U_];
                       sc_residual = [sc_residual;NaN];
                       hcoh_DU = [hcoh_DU;NaN];

       end
       
end

%% save variables
HCOHconc = hcoh_DU;
O4conc  = 10000*sc(:,2); % scaling back retrieved values due to scale down of coef
O3conc  = 10000*sc(:,3); % scaling back retrieved values due to scale down of coef
NO2conc = sc(:,4);%atmxcm slant path
BrOconc = sc(:,5);%atmxcm slant path
HCOHresi= error(:,5);%sqrt(sc_residual);
% no2OD    = ODfit;
% tau_aero_subtract = yno2subtractall./s.m_NO2;
allvar   = sc;
return;




