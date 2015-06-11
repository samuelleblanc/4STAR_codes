function [tau_o3 o3vcd tau_no2 no2vcd o4vcd MSEo3DU MSEno2DU] = o3no2corecalc(starsun,c0,vislampc0,nirlampc0,cross_sections)
%[tau_o3 o3vcd tau_no2 no2vcd o4vcd MSEo3DU MSEno2DU] = o3no2corecalc(starsun,c0,cross_sections)
% this function takes averaged raw spectra
% calculated total slant OD and uses
% least square decomposition to solve
% multiple linear equations for no2/o3/h2o/o4
%---------------------------------------------
% written by Michal Segal Sep 11 2012
% modified May 22 2013
% added baseline correction before conversion
% modified May 30 2013
% use second order polynomial and linear term in inversion o3
% 2nd order poly for no2, without polynomial subtraction
% Sep 23 modification - this function is used within:
% gasretrieveo3no2cwv
% Oct 5 2013 added CH2O retrieval using PCA filtered data
%---------------------------------------------------------
showfigure=0;
% calculate slant path OD from data
%-----------------------------------
Loschmidt=2.686763e19;                   % molec/cm3*atm
% choose only vnir range
 wvis = starsun.w(1:1044);
 % confine retrieval range
  if wvis(1)>1
      wvis = wvis/1000;
  end
% choose inversion spectral range
%--------------------------------
 %ifad=find(wvis<=0.490&wvis>=0.430);ifad=ifad';
 ino2=find(wvis<=0.490&wvis>=0.4324);ino2=ino2';
 no2idx = logical(wvis<=0.490 & wvis>=0.4324);
 % original:io3=find(wvis<=0.675&wvis>=0.490);io3=io3';
 %io3=find(wvis<=0.75&wvis>=0.490);io3=io3';
 io3=find(wvis<=0.675&wvis>=0.490);io3=io3';
 %
 
 qqq = size(starsun.spc_avg(:,1:1044),1);
 www = size(wvis,2);
 
 %rateaero_avg    =starsun.spc_avg(:,1:1044)./repmat(starsun.f(1),qqq,length(wvis));
 rateaero_avg    =starsun.rate(:,1:1044)./repmat(starsun.f(1),qqq,length(wvis));
 % total OD slant path
 tau_aero_avg_all=-log(rateaero_avg./repmat(c0',qqq,1));%./repmat(starsun.m_aero,1,ww);
 % total slant path (lamp c0 as reference)
 % caliblamp    = repmat(vislampc0(:,2)',length(starsun.tavg),1);
 %tau_aero_avg_all =-log(rateaero_avg./repmat(vislampc0(:,2)',qqq,1));%./repmat(starsun.m_aero,1,ww);
 % Rayleigh subtracted
 tau_aero_avg_mRay = tau_aero_avg_all - starsun.tau_ray(:,1:www).*repmat(starsun.m_ray,1,www);
 
 %tau_aero_avg_mRay_lamp = tau_aero_avg_all_lamp - starsun.tau_ray(:,1:www).*repmat(starsun.m_ray,1,www);
 %tau_aero_avg = tau_aero_avg_mRay;
  
 % calculate pca for no2 retrieval
 % rateaero_pca_avg     =starsun.spc_pca_avg(:,1:1044)./repmat(starsun.f(1),qqq,length(wvis));
 rateaero_pca_avg     =starsun.pcadata(:,1:1044)./repmat(starsun.f(1),qqq,length(wvis));
 %tau_aero_pca_avg_all =-log(rateaero_pca_avg./repmat(c0',qqq,1));
 % lamp c0
 tau_aero_pca_avg_all =-log(rateaero_pca_avg./repmat(vislampc0(:,2)',qqq,1));
 tau_aero_pca_avg_mRay = tau_aero_pca_avg_all - starsun.tau_ray(:,1:www).*repmat(starsun.m_ray,1,www);
 
 % calculate pca for CH2O retrieval
 %[pcaCH2O pcanoteCH2O] = starPCAgeneral(tau_aero_avg_mRay,starsun.t,starsun.w,[0.3 0.335]);
 
 % load instrument convolved cross-sections
%------------------------------------------
h2oconv = load(fullfile(starpaths,'H2O_1013mbar273K_convTech5.txt'));
o4conv  = load(fullfile(starpaths,'O4_convTech5.txt'));
no2conv_ = load(fullfile(starpaths,'no2_vis4star.txt'));%'NO2_254K_convTech5.txt')); % to be converted back to [atm x cm] no2convQDOAS=load(fullfile(starpaths,'NO2_254K_convTech5.txt'));
     vis.nm = load('visLambda.txt');
     nir.nm = load('nirLambda.txt');
     no2conv = interp1(no2conv_(:,1), no2conv_(:,2), vis.nm,'pchip','extrap');
% load recent cross sections file:
% recentcrosssections=load('20130925cross_sections_uv_vis_swir_Tech5wlnFWHM.mat');no2convrecent=recentcrosssections.no2/Loschmidt;
% o3convrecent=recentcrosssections.o3/Loschmidt;
o3conv  = load(fullfile(starpaths,'O3_223K_convTech5.txt'));
no3conv = load(fullfile(starpaths,'NO3_298KconvTech5.txt'));
HCOHconv= load(fullfile(starpaths,'HCHO_293K4STAR.txt'));
BrOconv = load(fullfile(starpaths,'BrO_243K_AIR4star.txt'));
Glyoxalconv = load(fullfile(starpaths,'Glyoxal_296K_AIR4star.txt'));
OBrOconv    = load(fullfile(starpaths,'OBrOxs4STARconv.txt'));
% o3
H2Oxso3   = h2oconv(io3,2);
O4xso3    = o4conv(io3,2);
NO2xso3   = no2conv(io3);%(no2conv(io3,2));%no2conv(io3,2);
O3xso3    = o3conv(io3,2);
NO3xso3   = no3conv(io3,2);
o3lambda  = wvis(io3);
% no2
H2Oxsno2   = h2oconv(ino2,2);
O4xsno2    = o4conv(ino2,2);
NO2xsno2   = no2conv(no2idx);%(no2conv(ino2,2));%no2conv(ino2,2);
O3xsno2    = o3conv(ino2,2);
NO3xsno2   = no3conv(ino2,2);
no2lambda  = wvis(ino2);
% HCOH
HCOHlambda = HCOHconv(:,1)/1000;
HCOHxs     = HCOHconv(:,2);
% BrO
BrOlambda = BrOconv(:,1)/1000;
BrOxs     = BrOconv(:,2);
% Glyoxal
Glyoxallambda = Glyoxalconv(:,1)/1000;
Glyoxalxs     = Glyoxalconv(:,2);
% OBrO
OBrOlambda = OBrOconv(:,1);
OBrOxs     = OBrOconv(:,2);
% O4
O4xs       = o4conv(:,2);

%
% define basis array:
% all relevant cross sections and zero order polynomial (after baseline
% subtraction) for O3, 2nd order for NO2 (without tau_aero subtraction)
%-----------------------------------------------------------------------
if starsun.t(1)<datenum([2013 1 16 0 0 0])% TCAP summer phase-add NO3
    basiso3 =[ones(length(o3lambda),1) o3lambda'.*ones(length(o3lambda),1) H2Oxso3*Loschmidt O4xso3*(Loschmidt).^2 NO2xso3*Loschmidt O3xso3*Loschmidt];
    basisno2=[ones(length(no2lambda),1) no2lambda'.*ones(length(no2lambda),1) ((no2lambda').^2).*ones(length(no2lambda),1) H2Oxsno2*Loschmidt O4xsno2*(Loschmidt).^2 NO2xsno2*Loschmidt O3xsno2*Loschmidt NO3xsno2*Loschmidt];
%     basiso3 =[ones(length(o3lambda),1) H2Oxso3*Loschmidt O4xso3*(Loschmidt).^2 NO2xso3*Loschmidt O3xso3*Loschmidt NO3xso3*Loschmidt];
%     % o3lambda'.*ones(length(o3lambda),1)
%     basisno2=[ones(length(no2lambda),1) H2Oxsno2*Loschmidt O4xsno2*(Loschmidt).^2 NO2xsno2*Loschmidt O3xsno2*Loschmidt NO3xsno2*Loschmidt];
%     % no2lambda'.*ones(length(no2lambda),1)
% else
elseif starsun.t(1)>=datenum([2013 1 16 0 0 0]) && starsun.t(1)<datenum([2013 6 16 0 0 0]);  % TCAP winter
    basiso3 =[ones(length(o3lambda),1) o3lambda'.*ones(length(o3lambda),1) H2Oxso3*Loschmidt O4xso3*(Loschmidt).^2 NO2xso3*Loschmidt O3xso3*Loschmidt];
    % o3lambda'.*ones(length(o3lambda),1)
    % generic no2 basis (used for TCAP)
    basisno2=[ones(length(no2lambda),1) no2lambda'.*ones(length(no2lambda),1) ((no2lambda').^2).*ones(length(no2lambda),1) H2Oxsno2*Loschmidt O4xsno2*(Loschmidt).^2 NO2xsno2*Loschmidt O3xsno2*Loschmidt];
    %basisno2=[ones(length(no2lambda),1) no2lambda'.*ones(length(no2lambda),1) ((no2lambda').^2).*ones(length(no2lambda),1) H2Oxsno2*Loschmidt O4xsno2*(Loschmidt).^2 NO2xsno2*Loschmidt O3xsno2*Loschmidt];
    % use this for SEAC4RS
elseif starsun.t(1)>datenum([2013 6 16 0 0 0]);  % SEAC4RS
    basiso3 =[ones(length(o3lambda),1) o3lambda'.*ones(length(o3lambda),1) H2Oxso3*Loschmidt O4xso3*(Loschmidt).^2 NO2xso3*Loschmidt O3xso3*Loschmidt];
    basisno2=[ones(length(no2lambda),1) H2Oxsno2*Loschmidt O4xsno2*(Loschmidt).^2 NO2xsno2*Loschmidt O3xsno2*Loschmidt];
    %basisno2=[ones(length(no2lambda),1) no2lambda'.*ones(length(no2lambda),1) H2Oxsno2*Loschmidt O4xsno2*(Loschmidt).^2 NO2xsno2*Loschmidt O3xsno2*Loschmidt];
   
    % add HNO3 and Glyoxal (OBrO is also present in this spectral range)
    % basisno2=[ones(length(no2lambda),1) H2Oxsno2*Loschmidt O4xsno2*(Loschmidt).^2 NO2xsno2*Loschmidt O3xsno2*Loschmidt OBrOxs(ino2)*Loschmidt NO3xsno2*Loschmidt];
    
end
%
%
 
 % perform baseline correction before retrieval
 %---------------------------------------------
 % calculate 2nd order polynomial
 % generic
 %-----------
 if starsun.t(1)<=datenum([2013 6 16 0 0 0]);  
    nonabs = load(fullfile(starpaths,'nonabs.mat'));
    nonabsvisidx = nonabs.idx(1:1044);
    wlnidx = logical(wvis>0.5|(wvis<=0.430&wvis>=0.400));
    nonabsidx = logical(nonabsvisidx & wlnidx');
    if strcmp(datestr(starsun.t(1),'yyyymmdd'),'20120717')
        wlnidx2 = logical(wvis>0.5|(wvis<=0.425&wvis>=0.415));
        nonabsidx2 = logical(nonabsvisidx & wlnidx2');
    end
 nonabsidxconst = zeros(length(wlnidx),1); nonabsidxconst(393:395)=1;nonabsidxconst(621:626)=1;
 % for SEAC4RS data - temp
 %-------------------------
 elseif starsun.t(1)>=datenum([2013 7 1 0 0 0]);  
  nonabs = load('nonabs.mat');
  nonabsvisidx = nonabs.idx(1:1044); nonabsvisidx(394)=1;% from 490 nm
  wlnidx = logical(wvis'>=0.5);wlnidx(394)=1;%407 is for 500, 357 is for 460 nm
  nonabsidx = logical(nonabsvisidx & wlnidx);%zeros(length(wlnidx),1); nonabsidx(393:395)=1;nonabsidx(621:626)=1;%
  nonabsidxconst = zeros(length(wlnidx),1); nonabsidxconst(393:395)=1;nonabsidxconst(621:626)=1;%(621:626)=1;%(631:636)=1;%0.68 (621:626)=1;%0.675%783:787 is 0.75
  %HCOHidx   = logical(wvis<=0.335 & wvis>=0.3);
  %HCOHidx   = logical(wvis<=0.358 & wvis>=0.344);
  HCOHidx   = logical(wvis<=0.324 & wvis>=0.3008);
 end
 % fit polynomial
 order = 3;
 %thresh = 0.001;
 poly_c=zeros(length(starsun.UTHh),(order)+1); 
 poly=zeros(length(wvis),length(starsun.UTHh));
 polydelta=zeros(length(wvis),length(starsun.UTHh));
 tau_aero_avg_sub = zeros(length(starsun.UTHh),length(wvis));
 %poly_cHCOH=zeros(length(starsun.UTHh),(order)+2); 
 poly_cHCOH=zeros(length(starsun.UTHh),(order)); 
 polyHCOH=zeros(length(starsun.UTHh),length(wvis));
 %HCOHidx = no2idx;
 %ch2oODtotal = zeros(length(starsun.UTHh),(sum(HCOHidx)));
 
 
 % perform pca to HCOH region before subtration/retrieval
 %[starsun.HCOHpca starsun.HCOHprojectdata starsun.HCOHprojectc0 starsun.HCOHpcanote] =starPCAgeneral(starsun.rate,starsun.t,starsun.w,[0.3 0.335],starsun.c0);
 %
 for i=1:length(starsun.UTHh)%i=26785:30130
    [p,S] = polyfit(wvis(nonabsidx==1),tau_aero_avg_mRay(i,nonabsidx==1),order);
    [y,delta] = polyval(p,wvis,S);
    poly_c(i,:)=p';
    poly(:,i)=y;
    polydelta(:,i)=delta;
    % perform polynomial subtraction
    tau_aero_avg_sub(i,:) = tau_aero_avg_mRay(i,:)-real(poly(:,i)');
    if tau_aero_avg_sub(i,407) < 0 % 513 is 600 nm;407 is 500 nm; 786 is 800 nm-SEAC4RS data
        % derive const range polynomial basis
        [p,S] = polyfit(wvis(nonabsidxconst==1),tau_aero_avg_mRay(i,nonabsidxconst==1),order-1);
        [y,delta] = polyval(p,wvis,S);
        poly_c(i,:)=[0;p'];
        poly(:,i)=y;
        polydelta(:,i)=delta;
    elseif tau_aero_avg_sub(i,407) < 0 && strcmp(datestr(starsun.t(1),'yyyymmdd'),'20120717')% 513 is 600 nm;407 is 500 nm; 786 is 800 nm
        % derive const range polynomial basis
        [p,S] = polyfit(wvis(nonabsidxconst==1),tau_aero_avg_mRay(i,nonabsidxconst==1),order-1);
        [y,delta] = polyval(p,wvis,S);
        poly_c(i,:)=[0;p'];
        poly(:,i)=y;
        polydelta(:,i)=delta;
    elseif poly(786,i) < 0 % 786 is 800 nm; this is TCAP 2012-07-17
        % derive const range polynomial basis
        [p,S] = polyfit(wvis(nonabsidx2==1),tau_aero_avg_mRay(i,nonabsidx2==1),order-1);
        [y,delta] = polyval(p,wvis,S);
        poly_c(i,:)=[0;p'];
        poly(:,i)=y;
        polydelta(:,i)=delta;
    end
    % subtract correct baseline
    tau_aero_avg_sub(i,:) = tau_aero_avg_mRay(i,:)-real(poly(:,i)');
    % HCOH
    % [polyHCOH_,poly_cHCOH_,iter,~,thresh,fn] = backcor(wvis(HCOHidx),tau_aero_avg_mRay(i,HCOHidx),order+1,thresh,'atq');% backcor(wavelength,signal,order,threshold,function);
    % [polyHCOH_,poly_cHCOH_,iter,~,thresh,fn] = backcor(wvis(HCOHidx),tau_aero_avg_mRay(i,HCOHidx),order-1,thresh,'atq');% backcor(wavelength,signal,order,threshold,function);
    % [polyHCOH_,poly_cHCOH_,iter,~,thresh,fn] = backcorgui(wvis(no2idx),tau_aero_avg_mRay(i,no2idx));
    % polyHCOH(i,HCOHidx)=polyHCOH_;        % calculated polynomials
    % poly_cHCOH(i,:)=poly_cHCOH_';         % polynomial coefficients
    % plot HCOH residual
%        figure(1113)
%        ax(1)=subplot(211);
%        plot(wvis,tau_aero_avg_mRay(i,:),'-.b','markersize',8,'linewidth',2);hold on;
%        plot(wvis(HCOHidx),polyHCOH_,'-r','linewidth',2);hold off;
%        legend('total OD (Rayleigh subtracted)','1st order baseline fit');ylabel('OD');
%        axis([0.346 0.358 0 0.5]);title(datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS'));
%        %axis([0.300 0.324 0 2.5]);title(datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS'));
%        ax(2)=subplot(212);
%        plot(wvis(HCOHidx),tau_aero_avg_mRay(i,HCOHidx)-polyHCOH_','-.c','linewidth',2);hold on;
%        plot(HCOHlambda(HCOHidx),5e18*HCOHxs(HCOHidx),'--r','linewidth',2);hold on;
%        plot(BrOlambda(HCOHidx),5e16*BrOxs(HCOHidx),'--','color',[0.8 0.5 0.5],'linewidth',2);hold on;
%        plot(wvis(HCOHidx),1e45*o4conv(HCOHidx,2),'--','color',[0.2 0.9 0.2],'linewidth',2);hold on;
%        plot(Glyoxallambda(HCOHidx),5e18*Glyoxalxs(HCOHidx),'--','color',[0.2 0.7 0.9],'linewidth',2);hold off;
%        xlabel('wavelength [\mum]');ylabel('OD');
%        legend('OD after baseline subtraction','HCOH xs x 5E18','BrO xs x 5E16','O4 xs x 1E45','Glyoxal xs x 5E18','location','NorthWest');
%        axis([0.346 0.358 0 0.15]);linkaxes(ax,'x');
       %axis([0.300 0.324 0 0.3]);linkaxes(ax,'x');
       %ch2oODtotal(i,:) = tau_aero_avg_mRay(i,HCOHidx)-polyHCOH_';
    %
    % plot AOD baseline interpolation and real AOD values
    
                       figure(111125)
                       plot(wvis,tau_aero_avg_mRay(i,:),'.b','markersize',8);hold on;
                       plot(wvis,y,'-r','linewidth',2);hold on;
                       plot(wvis(nonabsidx==1),y(nonabsidx==1),'.','color',[0.5 0.5 0.5]);hold off;
                       legend('total OD (Rayleigh subtracted)','OD baseline');title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Alt(i)) 'm']);
                       xlabel('wavelength [\mum]','fontsize',12,'fontweight','bold');ylabel('OD [-]','fontsize',12,'fontweight','bold');axis([0.4 1 0 1]);
                       set(gca,'fontsize',12,'fontweight','bold');
                       pause(0.0001);
 end
%  for i=1:10:length(starsun.UTHh)
%  figure(10);
%  %plot(wvis(no2idx),tau_aero_avg_mRay(i,no2idx),     '--b');hold on;
%  plot(wvis(no2idx),ch2oODtotal(i,:),'--g');hold on;
%  plot(wvis(no2idx),1e20*O3xsno2,'--y');hold on;
%  plot(wvis(no2idx),1e44*O4xsno2,'--c');hold on;
%  plot(wvis(no2idx),1e17*NO2xsno2,'--r');hold off;
%  legend('lamp-spectra-subtracted','o3','o4','no2')
%  end 
 
 
% perform polynomial subtraction
% perform subtraction
%  baseline=(real(poly))';
%  spectrum = tau_aero_avg_mRay(:,:);
%  tau_aero_avg_sub = spectrum-baseline;
 
% deduce HCOH
%  gasresidual = tau_aero_avg_mRay-polyHCOH;
%  HCOHod      = real(gasresidual(:,192)); HCOHod(HCOHod<=0)=NaN;HCOHod(starsun.Str==0)=NaN;HCOHod(starsun.Md==0|starsun.Md==7)=NaN;
%  starsun.HCOHod = boxxfilt(starsun.tavg, HCOHod , 60/86400); starsun.HCOHod(idxuse==0)=NaN;
%  figure;plot((starsun.UTavg/24)*86400,starsun.HCOHod,'.m');title(datestr(starsun.t(1),'yyyy-mm-dd'));
%  xlabel('UT [sec]');ylabel('HCOH OD');
%  saveHCOH = [(starsun.UTavg/24)*86400 starsun.HCOHod];
%  filesav = ['HCOHod327' datestr(starsun.t(1),'yyyymmdd') '.dat'];   %192 is 327 nm; 178 is 315 nm

% perform constrained CH2O fit
%-----------------------------
% Set Options
options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','notify-detailed','TolX',1e-6,'MaxFunEvals',500);
% normalize cross sections
Loschmidt=2.686763e19;                   % molec/cm3*atm
norm_ch2o_coef = HCOHxs*Loschmidt;%(HCOHxs - min(HCOHxs))./(max(HCOHxs) - min(HCOHxs));%
norm_Bro_coef  = BrOxs*Loschmidt;%(BrOxs  - min(BrOxs)) ./(max(BrOxs)  - min(BrOxs));%
norm_o4_coef   = O4xs*Loschmidt^2;%(O4xs   - min(O4xs)) ./(max(O4xs)    - min(O4xs));%

PAR = [norm_ch2o_coef(HCOHidx) norm_Bro_coef(HCOHidx) norm_o4_coef(HCOHidx)];

lb = [0 0 0];
ub = [1 1 1];
x0 = [0.2 0.2 0.2];
ch2onorm = [];
Bronorm  = [];
o4norm   = [];
residual = [];
for i=1:length(starsun.t)
    y = ch2oODtotal(i,:);
    meas = y';
    % check spectrum validity for conversion
    ypos = logical(y>=0);
    if ~isNaN(y(1)) && isreal(y) && sum(ypos)>=sum(HCOHidx==1)-2
        [x0norm,fval,exitflag,output]  = fmincon('CH2Oresi',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
        ch2onorm = [ch2onorm;x0norm(1)];
        Bronorm  = [Bronorm; x0norm(2)];
        o4norm   = [o4norm;  x0norm(3)];
        residual = [residual; fval    ];
        yopt_ =  exp(-(norm_ch2o_coef(HCOHidx).*real(x0norm(1)))).*exp(-(norm_Bro_coef(HCOHidx).*real(x0norm(2)))).*exp(-(norm_o4_coef(HCOHidx).*real(x0norm(3))));
        yopt  = -log(yopt_);
%       assign fitted spectrum
        ch2o_round = x0norm(1)*1000;
        wvODfit(i,HCOHidx) = yopt;
%                    figure(444);
%                    plot(starsun.w(HCOHidx),y,'-b');hold on;
%                    plot(starsun.w(HCOHidx),yopt,'--r');hold off;
%                    xlabel('wavelength','fontsize',12);ylabel('total slant OD','fontsize',12);
%                    legend('measured','calculated (opt)');
%                    title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Alt(i)) 'm' ' HCOH (DU)= ' num2str(ch2o_round)]);
%                    ymax = yopt + 0.2;
%                    axis([min(starsun.w(HCOHidx)) max(starsun.w(HCOHidx)) 0 max(ymax)]);
%                    pause(0.0001);
    else
        x0norm = [NaN NaN NaN];
        ch2onorm = [ch2onorm;x0norm(1)];
        Bronorm  = [Bronorm; x0norm(2)];
        o4norm   = [o4norm;  x0norm(3)];
        residual = [residual; NaN    ];
    end
end
ch2o_s = (ch2onorm.*(max(HCOHxs) - min(HCOHxs))) + min(HCOHxs);
basisch2o =PAR;%[ones(sum(HCOHidx),1) PAR];
ccoefch2oavg=[];
RRch2oavg=[];
for k=1:qqq;
coefch2oavg=basisch2o\ch2oODtotal(k,:)';
reconch2oavg=basisch2o*coefch2oavg;
RRch2oavg=[RRch2oavg reconch2oavg];
ccoefch2oavg=[ccoefch2oavg coefch2oavg];
end

%-----------------------------


%  save(filesav,'-ASCII','saveHCOH');
% perform inversion - o3
%-----------------------
ccoefo3avg=[];
RRo3avg=[];
for k=1:qqq;
coefo3avg=basiso3\tau_aero_avg_sub(k,io3)';
recono3avg=basiso3*coefo3avg;
RRo3avg=[RRo3avg recono3avg];
ccoefo3avg=[ccoefo3avg coefo3avg];
end

%
% calculate spectrum OD and ozone cross section
o3spectrum = tau_aero_avg_sub(:,io3)-RRo3avg' + ccoefo3avg(6,:)'*(basiso3(:,6))';   %"measured" accorsing to retrieval
o3fit      = ccoefo3avg(6,:)'*basiso3(:,6)';
o3residual = tau_aero_avg_sub(:,io3)-RRo3avg';

%calculate o3 VCD
%-----------------
 o3VCDavg = real((1000*(ccoefo3avg(6,:))')./starsun.m_O3);    % 1000 converts atmxcm to DU

 % create smooth ozone time-series
 xts = 60/3600;   %60 sec in decimal time
 [o3VCDavgsmooth, sn] = boxxfilt(starsun.UTHh, o3VCDavg, xts);
 o3vcd = real(o3VCDavgsmooth);
 % save o3 OD for further processing
 % tau_o3        = zeros(size(starsun.tau_a_avg,1),size(starsun.tau_a_avg,1,2));
 tau_o3        = real((o3vcd/1000)*(cross_sections.o3));
 

%
% % fit error calculation
% converts residual error from OD to DU
% calculate error over 0.49-0.675 only (to avoid water vapor error)
io3err =find(wvis<=0.675&wvis>=0.490);io3err=io3err';
io3err2=find(wvis(io3)<=0.675&wvis(io3)>=0.490);io3err2=io3err2';
o3Err   = (tau_aero_avg_sub(:,io3err)'-RRo3avg(io3err2,:))./repmat((O3xso3(io3err2)*Loschmidt),1,qqq);    % in atm cm
MSEo3DU = real((1000*(1/length(io3))*sum(o3Err.^2))');                                  % convert from atm cm to DU^2
RMSEo3  = real((sqrt(MSEo3DU)));

%
% no2 retrieval (using PCA filter)
%-----------------------------------
ccoefno2avg=[];
RRno2avg=[];
ccoefno2pcaavg=[];
RRno2pcaavg=[];
for k=1:qqq;
 coefno2avg=basisno2\tau_aero_avg_mRay(k,(ino2))';
 reconno2avg=basisno2*coefno2avg;
 RRno2avg=[RRno2avg reconno2avg];
 ccoefno2avg=[ccoefno2avg coefno2avg];

% pca retrieval
%coefno2pcaavg=basisno2\ch2oODtotal(k,:)';
coefno2pcaavg=basisno2\tau_aero_pca_avg_mRay(k,(ino2))';
reconno2pcaavg=basisno2*coefno2pcaavg;
RRno2pcaavg=[RRno2pcaavg reconno2pcaavg];
ccoefno2pcaavg=[ccoefno2pcaavg coefno2pcaavg];
end
%
%
% plot spectrum OD and no2 cross section
no2spectrum_pca     = tau_aero_pca_avg_mRay(:,(ino2))-RRno2pcaavg' + ccoefno2pcaavg(4,:)'*basisno2(:,4)';% changes from 6 to 4 in basis vector
no2spectrum         = tau_aero_avg_mRay(:,(ino2))-RRno2avg' + ccoefno2avg(4,:)'*basisno2(:,4)';
no2fit_pca          = ccoefno2pcaavg(4,:)'*basisno2(:,4)';  % pca filtered
%
% no2spectrum_pca     = ch2oODtotal-RRno2pcaavg' + ccoefno2pcaavg(4,:)'*basisno2(:,4)';% changes from 6 to 4 in basis vector
% no2fit_pca          = ccoefno2pcaavg(4,:)'*basisno2(:,4)';  % pca filtered
% no2residual_pca     = ch2oODtotal-RRno2pcaavg';
%
no2fit              = ccoefno2avg(4,:)'*basisno2(:,4)';     % non-pca filtered
no2residual_pca     = tau_aero_pca_avg_mRay(:,(ino2))-RRno2pcaavg';
no2residual         = tau_aero_avg_mRay(:,(ino2))-RRno2avg';


% no2 VCD with time
%------------------------
 no2VCDavg    = real((((ccoefno2avg(4,:))*1000)./(starsun.m_NO2)')');
 no2VCDpcaavg = real((((ccoefno2pcaavg(4,:))*1000)./(starsun.m_NO2)')');

% create smooth no2 time-series
 xts = 60/3600;   %60 sec in decimal time
 [no2VCDavgsmoothpca, sn] = boxxfilt(starsun.UTHh, no2VCDpcaavg, xts);
 no2vcdpca = real(no2VCDavgsmoothpca);
 [no2VCDavgsmooth, sn] = boxxfilt(starsun.UTHh, no2VCDavg, xts);
 no2vcd = real(no2VCDavgsmooth);
 
% save tau_no2 - total column for further processing
% tau_no2       = zeros(size(starsun.tau_a_avg,1),size(starsun.tau_a_avg,1,2));
tau_no2         = real((no2vcd/1000)*(cross_sections.no2));

% error
%-------
no2Err   = (tau_aero_pca_avg_mRay(:,(ino2))'-RRno2pcaavg(:,:))./repmat((NO2xsno2*Loschmidt),1,qqq);    % in atm cm
%no2Err   = (ch2oODtotal'-RRno2pcaavg(:,:))./repmat((NO2xsno2*Loschmidt),1,qqq);    % in atm cm
MSEno2DU = real((1000*(1/length(ino2))*sum(no2Err.^2))');                                              % convert from atm cm to DU
RMSEno2  = real(sqrt(real(MSEno2DU)));
%
% calculate o4 VCD
%------------------
%o4VCDavg = ((ccoefno2avg(4,:))/(Loschmidt)^2)./(starsun.m_ray_avg(idxuse==1)')';
o4VCDavg = ((ccoefno2pcaavg(5,:)')./(starsun.m_ray));                                                      % [atm cm]x atm (3/5)
[o4VCDavgsmooth, sn] = boxxfilt(starsun.UTHh, o4VCDavg, xts);
o4vcd = o4VCDavgsmooth;

% filter noisy points
%  o3vcd(idxuse==0)     = NaN;o3vcd(o3vcd<=0)=NaN;o3vcd(o3vcd>=1000)=NaN;
%  no2vcd(idxuse==0)    = NaN;
 o3vcd_=o3vcd;
 no2vcd_=no2vcd;
 o3vcd_ (starsun.flags.bad_aod==1&starsun.flags.unspecified_clouds==1) = NaN;
 no2vcd_(starsun.flags.bad_aod==1&starsun.flags.unspecified_clouds==1) = NaN;
 
%% plots
%--------
if showfigure==1
     % 1. example of total and Rayleigh subtracted OD
     figure(1);
     subplot(211)
     plot(wvis,tau_aero_avg_all(round(qqq/2),:),'.b','markersize',8);
     axis([0.40 0.87 0 1]);ylabel('total OD (include Rayleigh)');
     title(datestr(starsun.t(round(qqq/2)),'yyyy-mm-dd HH:MM:SS'));
     subplot(212)
     plot(wvis,tau_aero_avg_mRay(round(qqq/2),:),'.b','markersize',8);
     axis([0.40 0.87 0 1]);ylabel('total OD (Rayleigh sutracted)');
 
     % 2. plot total OD and subtracted tau_aero
     figure(2);
     ax(1)=subplot(211);
     plot(wvis,tau_aero_avg_mRay(round(qqq/2),:),'.b','markersize',8);
     axis([0.40 1 0 1]);ylabel('total OD','fontsize',14,'fontweight','bold');
     title(datestr(starsun.t(round(qqq/2)),'yyyy-mm-dd HH:MM:SS'));
     ax(2)=subplot(212);
     plot(wvis,tau_aero_avg_sub(round(qqq/2),:),'.g','markersize',8);
     axis([0.40 1 0 1]);ylabel('baseline subtracted OD','fontsize',14,'fontweight','bold');xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');

     % 3. total OD baseline subtracted
     figure (3);
     plot(wvis,tau_aero_avg_sub(i,:),'.g','markersize',8);
     axis([0.40 0.8 0 1]);ylabel('OD [-]','fontsize',12,'fontweight','bold');xlabel('wavelength [\mum]','fontsize',12,'fontweight','bold');
     title(datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS'));
     set(gca,'fontsize',12,'fontweight','bold');legend('baseline subtracted OD');
     
     % 4. plot original vs. reconstruction error - sample spectrum
     figure (4) 
     subplot(211)
     plot(wvis((io3)),tau_aero_avg_sub(round(qqq/2),io3)','--r','linewidth',2);
     ylabel('slant OD');legend('OD sample spectrum');
     title(['O3 spectra and reconstruction errors ' datestr(starsun.t(round(qqq/2)),'yyyy-mm-dd HH:MM:SS')]);
     subplot(212)
     plot(wvis((io3)),tau_aero_avg_sub(round(qqq/2),io3)'-RRo3avg(:,round(qqq/2)),'-b','linewidth',2);
     xlabel('wavelength');ylabel('residual OD');
     legend('O3 reconstruction error (OD-reconstruction)');
     
     % 5. plot fitted versus "measured"
     for i=1:100:length(starsun.t)
         o3vcdround = round(o3vcd(i));
     figure(55)
     plot(wvis((io3)),o3spectrum(i,:),'-k','linewidth',2);hold on;
     plot(wvis((io3)),o3fit(i,:),'-r','linewidth',2);hold on;
     plot(wvis((io3)),o3residual(i,:),':k','linewidth',1.5);hold on;
     %plot(wvis((io3)),1e24*H2Oxso3,'-c','linewidth',1.5);hold on;
     
     xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');
     ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted O_{3} spectrum','residual');
     title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') '  O_{3} [DU] = ' num2str(o3vcdround),'Alt [m]= ',num2str(starsun.Alt(i))]);
     set(gca,'fontsize',12,'fontweight','bold');axis([0.495 0.675 -0.01 0.3]);legend('boxoff');
     %pause;
     end
     % 6. plot o3vcd smooth with time
     figure;
     plot(starsun.UTHh,o3vcd,'ob','markerfacecolor','b','markersize',8);
     ylabel('o3 VCD [DU]');xlabel('time [UT]');axis([14 21 200 400]);
     
     figure;
     ax(1)=subplot(311);plot(starsun.UTHh,o3vcd,'.b');hold on;
     ax(2)=subplot(312);plot(starsun.UTHh,MSEo3DU,'.g');hold on;
     ax(3)=subplot(313);plot(starsun.UTHh,starsun.Alt,'--k');hold on;
     linkaxes(ax,'x');
     % figure; compare smooth vs. non-smooth
     % plot(starsun.UTavg(idxuse==1),o3VCDavg,'.r');hold on;
     % plot(starsun.UTavg(idxuse==1),o3VCDavgsmooth,'.b');legend('original','smooth 60s.');
    
     % 7. plot original vs. reconstruction error - no2
     % no pca
     figure(7);
     subplot(211)
     plot(wvis((ino2)),tau_aero_avg_mRay(round(qqq/2),(ino2)'),'--r','linewidth',2);
     ylabel('slant OD');legend('OD sample spectrum');
     title(['NO2 spectra and reconstruction errors-no PCA ' datestr(starsun.t(round(qqq/2)),'yyyy-mm-dd HH:MM:SS')]);
     subplot(212)
     plot(wvis((ino2)),tau_aero_avg_mRay(round(qqq/2),(ino2))'-RRno2avg(:,round(qqq/2)),'-b','linewidth',2);
     xlabel('wavelength');ylabel('residual OD');
     legend('reconstruction error (OD-reconstruction)');
     % pca
     figure(77);
     subplot(211)
     plot(wvis((ino2)),tau_aero_pca_avg_mRay(round(qqq/2),(ino2)'),'--r','linewidth',2);
     ylabel('slant OD');legend('OD sample spectrum (PCA filtered)');
     title(['NO2 spectra and reconstruction errors-PCA filtered ' datestr(starsun.t(round(qqq/2)),'yyyy-mm-dd HH:MM:SS')]);
     subplot(212)
     plot(wvis((ino2)),tau_aero_pca_avg_mRay(round(qqq/2),(ino2))'-RRno2avg(:,round(qqq/2)),'-b','linewidth',2);
     xlabel('wavelength');ylabel('residual OD');
     legend('reconstruction error (OD-reconstruction)');
     
     % 8. plot fitted and "measured" no2 spectrum
     for i=1:10:length(starsun.t)
         figure(888);
         plot(wvis((ino2)),no2spectrum_pca(i,:),'-k','linewidth',2);hold on;
         plot(wvis((ino2)),no2fit_pca(i,:),'-r','linewidth',2);hold on;
         plot(wvis((ino2)),no2residual_pca(i,:),':k','linewidth',2);hold off;
         xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcdpca(i)),' RMSE = ',num2str(RMSEno2(i))),...
                'fontsize',14,'fontweight','bold');
         ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted NO_{2} spectrum','residual');
         set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
         pause(0.001);
     end
     
     % 9. no2 VCd with time
     figure;
     plot(starsun.UTHh,no2vcd,'ob','markerfacecolor','b','markersize',8);
     ylabel('no2 VCD [DU]');xlabel('time [UT]');axis([14 21 0 1]);
     
     % 10. 
     figure(10);
     plot(starsun.UTHh,no2VCDavg,'db');ylabel('no2 [DU]');hold on;
     plot(starsun.UTHh,no2VCDpcaavg,'dr');ylabel('no2 [DU]');hold on;
     legend('no2-no pca','no2-pca filtered');
     %plot(starsun.UTavg(idxuse==1),no2VCDavgsmooth,'.g');ylabel('no2 [DU]');hold on;


    % figure;
    % plot(starsun.UTavg(idxuse==1),no2VCDavg,'.r');hold on;
    % plot(starsun.UTavg(idxuse==1),no2VCDavgsmooth,'.b');legend('original','smooth 60s.');
end

%% save data files
 
% save into mat file
 gas.UT        = starsun.UTHh;
 gas.t         = starsun.t;
 gas.Alt       = starsun.Alt;
 gas.Pst       = starsun.Pst;
 gas.Lat       = starsun.Lat;
 gas.Lon       = starsun.Lon;
 gas.no2VCDavg = no2vcd_;%no2vcd_;       % in DU
 gas.o3VCDavg  = o3vcd_; %o3vcd_;        % in DU
 gas.no2VCDmseerr = MSEno2DU;  % in DU^2
 gas.o3VCDmseerr  = MSEo3DU;   % in DU^2
 gas.no2VCDrmse   = RMSEno2;   % in DU
 gas.o3VCDrmse    = RMSEo3;    % in DU
 basisno2length = size(basisno2,2);
 basiso3length  = size(basiso3,2);
 if basisno2length==8
     polynumno2=2;
 elseif basisno2length==7
     polynumno2=2;
 elseif basisno2length==6
     polynumno2=1;
 elseif basisno2length==5
     polynumno2=0;
 end
 if basiso3length==7
     polynumo3=2;
 elseif basiso3length==6
     polynumo3=1;
 elseif basiso3length==5
     polynumo3=0;
 end
 %
 gas.note    = strcat('method with 2 baseline options; gases retrieved by least square inversion using ',num2str(order),' order baseline polynomial for ozone and ', num2str(polynumno2),' order polynomial for NO2 and ', ' ',num2str(polynumo3),' order polynomial for o3; smoothing is for 60s;interoplation back to t was using smooth results;c0 correction was used for that day');
 gas.date    = datestr(starsun.t(1),'yyyymmdd');
 gas_matfile = strcat(gas.date,'_4stargases2baseline20140319','.mat');
 save(gas_matfile,'-struct','gas');



return;
      