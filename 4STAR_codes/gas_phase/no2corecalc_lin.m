function [NO2conc, NO2resi, O3conc, O4conc,allvar] = no2corecalc_lin(s,no2coef,o4coef,o3coef,wln,tau_OD)
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
tau_o3o4h2o_subtract = tau_OD;
%------------------------------------------------

sc=[];
scd=[];
sc_residual = [];
no2_DU = [];
recon = [];
res = [];
error = [];

%end
if s.toggle.verbose
    disp('Starting NO2 retrieval loop...')
    upd = textprogressbar(length(s.t));
end
for i = 1:length(s.t)
    
    %    no2 o4 o3 intcpt slope 2nd 3rd    
    x0 = [0.3 1 0.6 0.1 0 0.1 0];
    
    % counts measured (slant total minus Ray)
    y = s.ratetot(i,wln);
    meas = [s.w(wln)' y'];
    lm = meas(:,1);
    PAR  = [no2_298Kcoef(wln) no2coefdiff(wln) o4coef(wln) o3coef(wln) s.c0(wln)'];
    to = [ones(length(wln),1) s.w(wln)' ((s.w(wln)').^2) (s.w(wln)').^3];
%     [Q R] = gram_schmidt(to);
%     no2_on = Q'*no2coef(wln)'*R;
%     gc = [to no2coef(wln) o3coef(wln) (log(s.c0(wln))-log(y))'];
%     gc2 =[so Q(:,2)];
%     [Q,R] = gram_schmidt(gc);
%     [Q2 R2]= gram_schmidt(gc2);
%     A*x = b;
    
    % orthogonalize/normalize
    [qno2 rno2]         = gram_schmidt([to(:,1:3) PAR(:,1)]);no2_norm     = sqrt(no2coef(wln)'*no2coef(wln));
    [qno2diff rno2diff] = gram_schmidt([to(:,1:3) PAR(:,2)]);no2diff_norm = sqrt(no2coefdiff(wln)'*no2coefdiff(wln));
    [qo3  ro3 ]         = gram_schmidt([to(:,1:3) PAR(:,4)]);o3_norm      = sqrt(o3coef(wln)'*o3coef(wln));
    
    % measurement
    b = (log(s.c0(wln)./(y)))';
    [qI   rI]           = gram_schmidt([to(:,1:3) b]);       I_norm       = sqrt(b'*b);
    
    % plot orthonormal cross sections
    figure(1001);
    plot(s.w(wln),qI(:,end),'-k');hold on;
    plot(s.w(wln),qno2(:,end),'-r');hold on;
    plot(s.w(wln),qno2diff(:,end),'-m');hold on;
    plot(s.w(wln),qo3(:,end),'-c');hold on;
    plot(s.w(wln),o4coef(wln)*100000,'-g');hold off;
    legend('diff meas','diff no2 298K','diff no2 220-298K','diff o3','o4');
    
    Abasis = [qno2(:,end) no2coefdiff(wln) qo3(:,end) o4coef(wln) to];%./repmat(scale,length(b),1);
    
    
    % solve
    x = b\Abasis;
    % scale back
    scale = [no2_norm 1 o3_norm 1 1 1 1 1];
    scd_   = x./scale;
    scd    = [scd;scd_];
    recon_=Abasis*x';
    recon=[recon; recon_'];
    res_ = b - recon_;
    res  = [res;res_'];
    xno2 = sc_(1)*no2coef(wln);
    
    figure(11);plot(s.w(wln),b*7,'-k');hold on;
           plot(s.w(wln),(recon_),'--r');
    
%     if issparse(A), [Q,R,e]=qr(A,'vector');
%     else R = triu(qr(A));  [Q,rr,e]=qr(A,'vector'); end
%     x = R\(R'\(A'*b));
%     xno2 = Q*rr(:,5)*x(5);
%     xo4  = Q*rr(:,4)*x(6);
%     xo3  = Q*rr(:,3)*x(7);
%     r = b - A*x;
%     err = R\(R'\(A'*r));
%     error = [error;err'];
%     x = x + err;
    
    figure(1111);
    plot(s.w(wln),b-Abasis(:,[5:end])*(x([5:end]))','-k');hold on;% diff no2 meas
    plot(s.w(wln),xno2,':r');hold off;legend('no2 meas','no2 fit');
%     
%     figure(2222);
%     plot(s.w(wln),b-A(:,[1:5,7])*x([1:5,7]),'-k');hold on;% diff o4 meas
%     plot(s.w(wln),xo4,':r');hold off;legend('o4 meas','o4 fit');
%     
%     figure(333);
%     plot(s.w(wln),b-A(:,[1:6])*x([1:6]),'-k');hold on;% diff o3 meas
%     plot(s.w(wln),xo3,':r');hold off;legend('o3 meas','o3 fit');
%     
%     figure(111);
%     measured = b - (to(:,1)*x(1) + to(:,2)*x(2) + to(:,3)*x(3) + to(:,4)*x(4) + o4coef(wln)*10000*x(6) + o3coef(wln)*x(7));
%     fitted  = x(5)*no2coef(wln)/1000;
%     residual  = measured - fitted;
%     plot(s.w(wln),measured,'-k');hold on;
%     plot(s.w(wln),fitted, '-r');hold on;
%     plot(s.w(wln),residual, ':k');hold off;
%     legend('meas','fit','residual');
%     xlabel('wavelength');ylabel('OD');
%     title([datestr(s.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(s.Alt(i)) 'm' ' VCD NO2= ' num2str(no2du) '[DU]' ' RMS fit = ' num2str(sqrt(sum(err).^2))]);
%     
    
       % Set Options
       
       options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-6,'Display','off','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
       %options = optimset('Algorithm','interior-point','LargeScale','off','TolFun',1e-5,'Display','notify-detailed','TolX',1e-5,'MaxFunEvals',1000);
       
     
       % boundary conditions for slant path
%          lb = [0 0 0 0 -1 -2 -2];
%          ub = [2 5 1 5 0 2 2];% 3rd order% toonoisy results
         lb = [0 0 0 0 -1 -1 -1];
         ub = [10 5 50 5 0 1 1];% 3rd order
 
       % check spectrum validity for conversion
       ypos = logical(y>0);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15 && sum(isinf(y))==0
            signal=logical(y<=10);
            if sum(signal)<10
                    [U_,fval,exitflag,output]  = fmincon('NO2resi_lin',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            end
            
                if ~isreal(U_(1)) || U_(1)<0 %|| (exist(exitflag) && exitflag~=1)
                        U_(1) = NaN;U_(2) = NaN; U_(3) = NaN;
                end
  
                sc = [sc; real(U_)];
                sc_residual = [sc_residual;real(fval)];
                no2_conc_ = (real(U_(1)))/s.m_NO2(i); 
                no2_round = round(no2_conc_*100)/100;% this is vertical (tau_aero is slant) in atmxcm
                no2_DU_    = (no2_conc_);       % conversion to DU
                no2_DU_round = round(no2_DU_*100)/100;
                no2_DU = [no2_DU;no2_DU_];
                
               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
               
               % plot fitted figure
             
                   yfit = (no2coef(wln)/1000).*U_(1)+ 10000*o4coef(wln).*U_(2) + o3coef(wln).*U_(3) + U_(4)*ones(length(lm),1) + U_(5)*(lm) + U_(6)*(lm).^2 + U_(7)*(lm).^3;      
                   ymeas = log(s.c0(wln))-log(y);
                   
                   
                   yno2subtract   = (((no2coef(wln))/1000).*real(U_(1)));
                   yo4subtract    = (o4coef(wln).*100000*real(U_(2)));
                   yo3subtract    = (o3coef(wln).*real(U_(3)));
                   polysubtract   =  U_(4)*ones(length(lm),1) + U_(5)*(lm) + U_(6)*(lm).^2 + U_(7)*(lm).^3;
                   yno2subtractall=  yno2subtract + yo4subtract + yo3subtract;
               
                % assign fitted spectrum
                ODfit(i,wln) = yfit;
                % save spectrum to subtract
                tau_o3o4h2o_subtract(i,wln) = (ymeas'-yno2subtractall)/s.m_NO2(i);%yno2subtractall/s.m_NO2(i);
                %% plot measured and computed fit
                       figure(444);
                       ax(1)=subplot(211);
                       plot(s.w(wln),ymeas,'-b');hold on;
                       plot(s.w(wln),yfit,'--r');hold on;
                       plot(s.w(wln),yno2subtract,'--g');hold on;
                       plot(s.w(wln),yo4subtract,'--c');hold on;
                       plot(s.w(wln),yo3subtract,'--m');hold on;
                       plot(s.w(wln),polysubtract,'-k');hold on;
                       plot(s.w(wln),ymeas'-yno2subtractall,':k');hold off;
                       xlabel('wavelength','fontsize',12);ylabel('total slant OD','fontsize',12);
                       legend('measured','calculated (fit)','no2 spectrum to subtract','o4 spectrum to subtract','o3 spectrum to subtract','aerosol baseline','subtracted spectrum');
                       title([datestr(s.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(s.Alt(i)) 'm' ' VCD NO2= ' num2str(no2_DU_round) '[DU]' ' RMS fit = ' num2str(sqrt(fval))]);
                       ymax = yfit + 0.2;
                       axis([min(s.w(wln)) max(s.w(wln)) 0 max(ymax)]);
%                        ax(2)=subplot(212);
%                        plot(s.w(wln),ymeas'-yo4subtract-yo3subtract-polysubtract,'-b');hold on; % no2 measured
%                        plot(s.w(wln),yno2subtract,'--r');hold on;                               % no2 retrieved
%                        plot(s.w(wln),ymeas'-yo4subtract-yo3subtract-yno2subtract-polysubtract,':k');hold off;% no2 residual
%                        xlabel('wavelength','fontsize',12);ylabel('SC NO_{2} OD','fontsize',12);
%                        legend('NO_{2} measured','NO_{2} fitted','residual','orientation','horizontal');
%                        axis([min(s.w(wln)) max(s.w(wln)) -0.02 0.15]);

                       ax(2)=subplot(212);
                       plot(s.w(wln),ymeas'-yo4subtract-yo3subtract-polysubtract,'-b');hold on; % no2 measured
                       plot(s.w(wln),yno2subtract,'--r');hold on;                               % no2 retrieved
                       plot(s.w(wln),ymeas'-yo4subtract-yo3subtract-yno2subtract-polysubtract,':k');hold off;% no2 residual
                       xlabel('wavelength','fontsize',12);ylabel('SC NO_{2} OD','fontsize',12);
                       legend('NO_{2} measured','NO_{2} fitted','residual','orientation','horizontal');
                       axis([min(s.w(wln)) max(s.w(wln)) -0.02 0.15]);
                       pause(0.0001);
            else

                       U_ = [NaN NaN NaN NaN NaN NaN NaN];
                       sc = [sc; U_];
                       sc_residual = [sc_residual;NaN];
                       no2_DU = [no2_DU;NaN];

       end
   if s.toggle.verbose; upd(i); end;
end

%% save variables
NO2conc = no2_DU;
O4conc  = 10000*sc(:,2); % scaling back retrieved values due to scale down of coef
O3conc  = 10000*sc(:,3); % scaling back retrieved values due to scale down of coef
NO2resi = error(:,5);%sqrt(sc_residual);
% no2OD    = ODfit;
% tau_aero_subtract = yno2subtractall./s.m_NO2;
allvar   = sc;
return;




