function [tau_CO2 tau_CH4] = calcCO2CH4starOD(cross_sections,model_atm,Alt)
% modified from John's readplot_LTRNMDLATM3.pro
% for 4star
% Michal Segal Sep 26 2013
%-----------------------------------------------
% clear
% clear global
% close all

global ALT PMATM TMATM H2OPPMV CO2PPMV O3PPMV N2OPPMV CH4PPMV
global ZKMMDL PMBMDL TMKMDL H2OMDL H2OGM3MDL CO2MDL O3MDL N2OMDL CH4MDL
global H2Opercm3MDL CO2percm3MDL O3percm3MDL N2Opercm3MDL CH4percm3MDL airpercm3
global PZERO TZERO AVOGAD ALOSMT GASCON PLANK BOLTZ CLIGHT ADCON
global ALZERO AVMWT AIRMWT AMWT

IDMDL=strvcat('TROPICAL','MIDLAT SUMMER','MIDLAT WINTER',...
   	'SUBARC SUMMER','SUBARC WINTER','1976 U.S. STAND');

%absorption coeffs for 4star
abscoeff_percubcm_CO2=(cross_sections.co2)';
abscoeff_percubcm_N2O=ones(length(cross_sections.co2),1);
abscoeff_percubcm_CH4=(cross_sections.ch4)';

imodelatm=[model_atm:model_atm];%[1:1];%[5:5]; %[1:6];
LTRNMDLATM3_revised_nov2004(imodelatm)

scale_CO2=392./330.; %increase CO2 conc by 18.6%...to be consistent with MLO temporal trend
if scale_CO2>1
    CO2percm3MDL=scale_CO2*CO2percm3MDL;    % scaling CO2 profile
end

%following added Nov 2004
%plot multiframe gas number density profiles
legstr=[];
for imod=imodelatm(1):imodelatm(end); %1:length(imodelatm),
    legstr=[legstr;IDMDL(imod,:)];
end
colorsym=['co-';'bo-';'go-';'ro-';'mo-';'ko-'];
zmin=0;
zmax=50;

% integrate profile in altitude
% CO2 optical depth
%figure(9)
cmflip=1e5*flipud(ZKMMDL'); %convert km to cm
% orient landscape
% subplot(1,3,1)
for imod=1:length(imodelatm),
    CO2flip=flipud(CO2percm3MDL(:,imod));
    CO2_nopercm2 = -cumtrapz(cmflip,CO2flip);            %integrate and convert to no/cm2
    %optdepth_CO2=abscoeff_percubcm_CO2*CO2_nopercm2';    % plot only 1433 nm (1346)
    %plot(optdepth_CO2(1346,:),flipud(ZKMMDL'),colorsym(imod,:),'linewidth',1.5)
    %hold on
end
% axis([0 1e-3 0 12]);
% xlabel(['CO2 Optical Depth at ',num2str(cross_sections.wln(1346)),'nm'],'fontsize',10)
% ylabel('Altitude [km]','fontsize',14)
% set(gca,'FontSize',12)
% % set(gca,'xtick',[0:0.0002:0.001])
% grid on
% hleg=legend(legstr);
% set(hleg,'fontsize',10)
% ht1=text(3e-04,9.5,5,sprintf('CO_{2} increased by %4.1f%%',100*(scale_CO2-1)));
% set(ht1,'backgroundcolor','y','edgecolor','k')
% set(ht1,'fontsize',11)
% N2O optical depth
subplot(1,3,2)
for imod=1:length(imodelatm),
    N2Oflip=flipud(N2Opercm3MDL(:,imod));
    N2O_nopercm2 = -cumtrapz(cmflip,N2Oflip);           %integrate and convert to no/cm2
%     optdepth_N2O=abscoeff_percubcm_N2O*N2O_nopercm2';   % so far no NO2 xs exist
%     plot(optdepth_N2O(1346,:),flipud(ZKMMDL'),colorsym(imod,:),'linewidth',1.5)
%     hold on
end
% axis([0 1e-3 0 12]);
% xlabel(['N2O Optical Depth at ',num2str(cross_sections.wln(1346)),'nm'],'fontsize',10)
% set(gca,'FontSize',12)
% % set(gca,'xtick',[0:0.0002:0.001])
% grid on
% CH4 optical depth
% subplot(1,3,3)
for imod=1:length(imodelatm),
    CH4flip=flipud(CH4percm3MDL(:,imod));
    CH4_nopercm2 = -cumtrapz(cmflip,CH4flip);           %integrate and convert to no/cm2
%     optdepth_CH4=abscoeff_percubcm_CH4*CH4_nopercm2';   % 1640 nm is 1503 in index
%     plot(optdepth_CH4(1503,:),flipud(ZKMMDL'),colorsym(imod,:),'linewidth',1.5)
%     hold on
end
%axis([0 1e-3 0 12]);
% set(gca,'xtick',[0:0.0002:0.001])
% xlabel(['CH4 Optical Depth at ',num2str(cross_sections.wln(1503)),'nm'],'fontsize',10)
% set(gca,'FontSize',12)
% grid on


% colorsym_fit=['cx--';'bx--';'gx--';'rx--';'mx--';'kx--'];
% zplot=[0:0.5:15];
% plot CO2/CH4 profile fits (5th order polynomial)
% figure(10)
% orient landscape
zuse=flipud(ZKMMDL');
izuse=find(zuse<=15);
% CO2
%subplot(121)
% axis([0 2.2e-3 0 15]);
% set(gca,'xtick',[0:0.0002:0.0022])
% set(gca,'ytick',[0:2:14])
% xlabel('Amount (CO{_2} [molec/cm^{3}]','fontsize',14)
% ylabel('Altitude [km]','fontsize',14)
% set(gca,'FontSize',14)
% grid on

% legstr2=[legstr;'prof           ';'5th order fit  '];
% gold   =[ 0.961 0.796 0.122 ];
% redish =[ 0.960 0.679 0.100 ];
[PfitCO2,SfitCO2] = polyfit(zuse(izuse),CO2_nopercm2(izuse),5);
general_CO2_fit=polyval(PfitCO2,zuse(izuse));
% plot(CO2_nopercm2(izuse),zuse(izuse),'d','markeredgecolor',gold,'markerfacecolor',gold,'linewidth',2)
% hold on
% plot(general_CO2_fit,zuse(izuse),':','color',gold,'linewidth',2)
% hleg=legend(legstr2);
% set(hleg,'fontsize',10)
% 
% fitstr=sprintf('fit coeff:\n %12.3e z^{5}\n %12.3e z^{4}\n %12.3e z^{3}\n %12.3e z^{2}\n %12.3e z\n %12.3e',PfitCO2)
% htfit=text(1.8e-03,10,fitstr);
% set(htfit,'fontsize',12)
% 
% ht=text(1.2e-03,14,sprintf('CO_{2} increased by %4.1f%%',100*(scale_CO2-1)));
% set(ht,'backgroundcolor','y','edgecolor','k')
% set(ht,'fontsize',12);
% xlabel('CO_{2} Number Density [no/cm^{3}]','FontSize',12)
% ylabel('Altitude [km]','FontSize',12)
% set(gca,'FontSize',11)
% grid on

% CH4
% subplot(122)
% 
% legstr2=[legstr;'prof           ';'5th order fit  '];
% orange =[ 0.960 0.679 0.100 ];
[PfitCH4,SfitCH4] = polyfit(zuse(izuse),CH4_nopercm2(izuse),5);
general_CH4_fit=polyval(PfitCH4,zuse(izuse));
% plot(CH4_nopercm2(izuse),zuse(izuse),'d','markeredgecolor',orange,'markerfacecolor',orange,'linewidth',2)
% hold on
% plot(general_CH4_fit,zuse(izuse),':','color',orange,'linewidth',2)
% hleg=legend(legstr2);
% set(hleg,'fontsize',10)
% 
% fitstr=sprintf('fit coeff:\n %12.3e z^{5}\n %12.3e z^{4}\n %12.3e z^{3}\n %12.3e z^{2}\n %12.3e z\n %12.3e',PfitCH4);
% htfit=text(1.8e-03,10,fitstr);
% set(htfit,'fontsize',12);
% xlabel('CH_{4} Number Density [no/cm^{3}]','FontSize',12);
% ylabel('Altitude [km]','FontSize',12);
% set(gca,'FontSize',11);
% grid on;

% calculate tau_CO2/CH4 for each altitude
%-----------------------------------------
CO2amount=zeros(length(Alt),1);
CH4amount=zeros(length(Alt),1);
for ideg=1:6,
    CO2amount = CO2amount + PfitCO2(ideg)*(Alt/1000).^(6-ideg);
    CH4amount = CH4amount + PfitCH4(ideg)*(Alt/1000).^(6-ideg);
end

tau_CO2 = CO2amount*cross_sections.co2;
tau_CH4 = CH4amount*cross_sections.ch4;


%interpolate to get atmos density every km 
% zkminterp=[26:50];
% dens_interp = exp(INTERP1(ZKMMDL,log(atmo_density_nopercm3),zkminterp));
% figure(3)
% semilogx(dens_interp,zkminterp,'ro')
% hold on
% semilogx(atmo_density_nopercm3(idxplt),ZKMMDL(idxplt),'bo-')
% axis([-inf 3e+19 zmin zmax])
% xlabel('Number Density [no/cm^{3}]','FontSize',12)
% ylabel('Altitude [km]','FontSize',12)
% set(gca,'FontSize',11)
% grid on

