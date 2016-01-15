%AATS14_Langley_MLO_2016_multi.m
% based on %AATS14_Langley_MLO_2012_multi.m

%langley3_AATS14_air.m   %formerly
%performs Langley plots for atmospheric window and UV/ozone wavelenths (preliminary).
%play with 1) time interval in prepare.m
%          2) airmass range: min_m_aero, max_m_aero
%          3) standard deviation multiplier for Thompson-tau method: stdev_mult
%          4) Iteratively change the value of O3_col_start in prepare.m until aerosol optical depth spectrum 
%             looks smooth in the 610 nm region. O3 value does not have to be very accurate (try increments of 10 DU)
%             it's just for properly weighting the airmasses
% MS, 2016-01-10, modified to run MLO 2016

clear
close all

%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%change the following three lines to set the airmass range and the allowable standard deviation 
amass_min_mat=[1.3 1.4 1.4 1.4 1.4];
amass_max_mat=[12 12 12 12 12];
stdev_mat=[4 4 3.5 3 2];

amass_min_mat=[6 6 6 6];
amass_max_mat=[12 12 12 12];
stdev_mat=[4 3.5 3 2];

amass_min_mat=[1.3 1.4 1.4 1.4 1.4];
amass_max_mat=[12 12 12 12 12];
stdev_mat=[4 4 3.5 3 2];

amass_min_mat=[1.2 1.3 1.4 1.4 1.4 1.4];
amass_max_mat=[12 12 12 12 12 10];
stdev_mat=[4 4 4 3.5 3 3];

amass_min_mat=[1.8 2.0];
amass_max_mat=[12 12];
stdev_mat=[3 3];

amass_min_mat=[1.3 1.4 1.4 1.4 1.4];
amass_max_mat=[12 12 12 12 12];
stdev_mat=[4 4 3.5 3 2];

amass_min_mat=[1.2 1.3 1.4 1.6 1.8];
amass_max_mat=[8 8 8 8 8];
stdev_mat=[3 3 3 3 3];

amass_min_mat=[1.3 1.4 1.4 1.4 1.4];
amass_max_mat=[12 12 12 12 12];
stdev_mat=[4 4 3.5 3 2];

amass_min_mat=[1.8 1.8 2.0 2.0];
amass_max_mat=[5 5 5 5];
stdev_mat=[3 2 3 2 ];

amass_min_mat=[1.2 1.3 1.4 1.5 1.6 1.7 1.8];
amass_max_mat=[12 12 12 12 12 12 12];
stdev_mat=[3 3 3 3 3 3 3];

% amass_min_mat=[1.6 1.7 1.8];
% amass_max_mat=[ 12 12 12];
% 
amass_min_mat=[1.4];
amass_max_mat=[12];

% amass_min_mat=[1.4];
% amass_max_mat=[12];


stdev_mat=1.8*ones(size(amass_min_mat));

%f_write_text='/Users/meloe/Programs.dir/ReadAATS/ForMLO/Process_MLO_MK_AATS.dir/OutputText/langley_AATS14May2012.txt';
%f_write_text='c:\johnmatlab\AATS14 calibration text file\langley_AATS14_MLOMay2012.txt'; %John
%f_write_text='c:\johnmatlab\AATS14 calibration text file\langley_AATS14_MLODec2012.txt'; %John
%f_write_iter='c:\johnmatlab\AATS14 calibration text file\langley_iteration_AATS14_MLODec2012.txt'; %John
%f_write_text='c:\johnmatlab\AATS14 calibration text file\langley_AATS14_TCAPSFeb2013.txt'; %John
%f_write_iter='c:\johnmatlab\AATS14 calibration text file\langley_iteration_AATS14_TCAPSFeb2013.txt'; %John
f_write_text='C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\AATS_Calib\langley_AATS14_MLOJan2016.txt'; %John
f_write_iter='C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\AATS_Calib\langley_iteration_AATS14_MLOJan2016.txt'; %John

%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%for iconf=1:length(amass_min_mat)
%for iconf=1:size(amass_min_mat,1)

%%clearvars -except iconf amass_min_mat amass_max_mat stdev_mat f_write_text pathname_in filename_in
%%close 1 2 3 4 5 6 7 8 9 10 11 12 13

sMonth=['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

%flag_use_V0='MLOMay06';
%flag_use_V0='meanMLOJanMay06';
%flag_use_V0='interpMLOJanMay06';   use this one for INTEXB
%flag_use_timeinterp_and_Jan06combo='yes'; use this one for INTEXB
flag_use_timeinterp_and_Jan06combo='no';
flag_use_V0='ignore';

%DO NOT execute plot_re4 before running this program

iconf=1;

%prepare;
%prepare_AATS14_SOLVE2_MLO;  
%prepare_ICARTT;  %use for 7/29 airborne langley
%%prepare_AATS14_MLO_2005;  %okay to use this for MLO (JML Aug 2005)...USED THIS AT MLO in May 2006
%prepare_MLO_2012
%AATS14_prepare_2013
%AATS14_prepare_2014

AATS14_prepare_2016

flag_adj_ozone_foraltitude='no';  %set='yes' only for case where ozone is for total column

%following added by Livingston 12/19/2002 to account for altitude in columnar ozone correction
%use previously calculated (Livingston program ozonemdlcalc.m) 5th order polynomial fit to ozone model
%to calculate fraction of total column ozone above each altitude
coeff_polyfit_tauO3model=[8.60377e-007  -3.26194e-005   3.54396e-004  -1.30386e-003  -5.67021e-003   9.99948e-001];
frac_tauO3 = polyval(coeff_polyfit_tauO3model,GPS_Alt);
if strcmp(flag_adj_ozone_foraltitude,'no') frac_tauO3=1; end

tau_NO2=NO2_clima*a_NO2;
tau_O3=O3_col_start*a_O3;
[m,n]=size(m_ray);
%lambda(2001):0.3535 0.3800 0.4490 0.4994 0.5250 0.6057 0.6751 0.7784 0.8645 0.9397 1.0191 1.0594 1.2413 1.5578
%lambda(2002):0.354 
flag_write='yes';
flag_lnVvsm_unfiltered='no';
flag_fit_Vvsmray='no'; %'yes';%
flag_restrict_altitude='no';

wvl_aero=[1 1 1 1 1 1 1 1 1 0 1 1 1 1]; %use to process allchannels
%wvl_aero=[0 0 0 0 0 0 0 0 1 0 0 0 0 0]; %use to process 865 only
%wvl_aero=[0 0 0 0 0 0 0 0 0 0 0 0 0 1]; %use to process only a single channel
%wvl_aero=[0 0 1 0 0 0 0 0 0 0 0 0 0 0]; %use to process only a single channel
idx_wvl_proc=find(wvl_aero==1);

%rel_sd=Sd_volts./data;
%L_SD_aero=prod(rel_sd(wvl_aero=in_m_aero=[2 2 2 2 2 2 2 2 2 2 2 2 2 2];  %general

for iconf=1:length(amass_min_mat)
%for iconf=1:size(amass_min_mat,1)

%clearvars -except iconf amass_min_mat amass_max_mat stdev_mat f_write_text pathname_in filename_in
if iconf>1
    clear aod_instant_calc mean_aod_instant_calc std_aod_instant_calc
    close 1 2 3 4 5 6 7 8 9 11 12 13 14    %only works when using all 13 aero wvls
end

amass_min_use=amass_min_mat(iconf);
amass_max_use=amass_max_mat(iconf);
stdev_mult=stdev_mat(iconf);
min_m_aero=ones(1,14)*amass_min_use;  %general %MIN/ MAX FOR ALL WAVELENGTHS
max_m_aero=ones(1,14)*amass_max_use;  %general
%max_m_aero=[12 12 12 12 12 12 12 12 12 12 12 12 12 12]; %general
%max_m_aero=[11.1 11.1 11.1 11.1 11.1 11.1 11.1 11.1 11.1 11.1 11.1 11.1 11.1 11.1]; 
%max_m_aero=[8 8 8 8 8 8 8 8 8 8 8 8 8 8]; 
%max_m_aero=[25 25 25 25 25 25 25 25 25 25 25 25 25 25]; %general
%min_m_aero=[1.2 1.2 1.2 1.2 1.26 1.2 1.2 1.2 1.2 1.2 1.2 1.2 1.2 1.2]; %use for 5/17/08 MLO where 520 saturates
%min_m_aero=[1.2 1.2 1.2 1.2 1.31 1.2 1.2 1.2 1.2 1.2 1.2 1.2 1.2 1.2]; %use for 5/18/08 MLO where 520 saturates

flag_skip_mrange='no';%'yes';%'no'; 
min_m_skip=-99; max_m_skip=-99;
%min_m_skip=7.7; max_m_skip=10; %use for 11/6/02


%Langley-Plot
channels=1:size(V0');
jwvlpl=0;
ncol=4;
nrow=4;
%Window wavelengths
for ichan=channels(wvl_aero==1);

 if strcmp(flag_fit_Vvsmray,'yes')
  x=m_ray;
  y=data(ichan,:)';
  strxlab='m_{Ray}';
  strylab='lnV';
 else
  x=m_aero;
  y=data(ichan,:)'.*exp(m_ray'.*tau_ray(ichan,:)'+...
                (frac_tauO3.*m_O3)'.*ones(n,m)*tau_O3(ichan)+...
                       m_NO2'.*ones(n,m)*tau_NO2(ichan)+...
                       m_ray'.*tau_O4(ichan)); %V* -MK 
  strxlab='m_{aer}';
  strylab='lnV*';
 end
               
 if strcmp(filename_in,'R05Sep01.AA') & ichan==9
     figure(22)
     plot(UT,y,'b.')
     hold on
     %axis([18.5 18.7 1.3 1.4])
     idx_time_correct = find(UT<=18.58);
     transmission_dirt=7.095/7.21;  %(Voltage before/Voltage after cleaning)
     y(1:idx_time_correct(end))=y(1:idx_time_correct(end))/transmission_dirt;
     plot(UT,y,'r.')
     grid on
 end
 
 y=log(y');

 %Airmass restriction 
 i=find(m_aero<=max_m_aero(ichan) & m_aero>=min_m_aero(ichan));
 x=x(i);
 y=y(i);
 ruse=r(i);
 zp_use=Press_Alt(i);
 pmb_use=press(i);
 UT_use=UT(i)

 %restriction that skips a single range of airmass values
 if strcmp(flag_skip_mrange,'yes')
  i=find(x<min_m_skip | x>max_m_skip);
  x=x(i);
  y=y(i);
  ruse=r(i);
  zp_use=Press_Alt(i);
  pmb_use=press(i);
  UT_use=UT(i)
 end
 
 if strcmp(flag_restrict_altitude,'yes')
  %Altitude restriction for airborne Langley
  %i=find(ruse>6.35); %use for 7/29/04 ICARTT Langley
  %i=find(zp_use>=6.4); %use for 8/2/04 ICARTT Langley
  %i=find(zp_use>=5.78); %use for 8/7/04 ICARTT Langley
  i=find(zp_use>=6.36); %use for 8/8/04 ICARTT Langley
  x=x(i);
  y=y(i); 
 end

 %Fit
 [p,S] = polyfit (x,y,1)
 [y_fit,delta] = polyval(p,x,S);
 a=y-y_fit;

 if strcmp(flag_lnVvsm_unfiltered,'yes')
 figure
 subplot(2,1,1)
 plot(x,y,'g+',x,y_fit);
 title(sprintf('%s %2i.%2i.%2i %8.3f µm    stdevmult:%d',site,day,month,year,lambda(ichan),stdev_mult));
 xlabel(strxlab)
 ylabel(strylab)
 subplot(2,1,2);
 xlabel('m_a')
 ylabel('Residuals')
 plot(x,a,'g+'); 
%  pause
 end

 ln_Vstar=y; %save lnV* values before it throws some away t x lambda -MK 
 maero_save=x;
 
 %Thompson-tau %THROWS DATA POINTS IF OUT OF STDEV_MULT -MK
 while max(abs(a))>stdev_mult*std(a) 
  i=find(abs(a)<max (abs(a)));
  x=x(i);
  y=y(i);
  [p,S] = polyfit (x,y,1)
  [y_fit,delta] = polyval(p,x,S);
  a=y-y_fit;
 end

 ln_V0prime=p(2);
 aod_instant_calc(ichan,:)=-(ln_Vstar-ln_V0prime)./maero_save;
 
 V0_calc(ichan)=exp(p(2))/sundist(day,month,year);
 tau(ichan)=-p(1);
 RSD(ichan)=std(a);
 airmass_min_use(ichan)=x(end);
 airmass_max_use(ichan)=x(1);

 
 
 figure(ichan)
 subplot(2,1,1)
 plot(x,y,'m+')
 hold on
 plot(x,y_fit,'k-','linewidth',2);
 title(sprintf('%s %2i.%2i.%2i %8.3f µm    stdevmult:%3.1f   V0:%7.4f',site,day,month,year,lambda(ichan),stdev_mult,V0_calc(ichan)));
 xlabel(strxlab)
 ylabel(strylab)
 grid on
 subplot(2,1,2);
 plot(x,a,'m.'); 
 xlabel(strxlab)
 ylabel('Residuals')
 grid on
%  pause
 %this is just an example:print('-depsc',sprintf('c:/johnmatlab/MLO_AATS14_langley_plots/%04d/LidarRayNa%04d%02d%02dTempDaily',year,day,sMonth(month,:),mdy(2),mdy([3 1 2])));     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------------------------------------------------------------
%multiple frame Langley plot
%mlimp=[0 3.6];
mlimp=[0 12];
jwvlpl=jwvlpl+1;
figure(200+iconf)
col=mod(jwvlpl-1,ncol);
row=fix((jwvlpl-1)/ncol);
subplot('position',[0.10+col*0.22 0.77-row*0.23 0.18 0.18])
plot(x,y,'m+')
hold on
plot(x,y_fit,'k-','linewidth',2);
ht201=title(sprintf('%2i/%2i/%2i %6.3f µm  sd:%3.1f  V0:%7.4f',month,day,year,lambda(ichan),stdev_mult,V0_calc(ichan)));
set(ht201,'fontsize',6)
if col==0 & row==1
    ylabel(strylab,'fontsize',14)
end
if col==0 & row==3
    xlabel(strxlab,'fontsize',14)
end
set(gca,'xlim',mlimp)
grid on

pfn = strcat('C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\AATS_Calib\figs\','LANG',num2str(year),num2str(month),num2str(day),'\','LnVstarairmass',num2str(amass_min_use),'-',num2str(amass_max_use),'-',num2str(stdev_mult),'-',num2str(year),num2str(month),num2str(day),'.jpg');
S = sprintf('print -djpeg %s',pfn);
eval(S);

%multiple frame residual plot
figure(300+iconf)
col=mod(jwvlpl-1,ncol);
row=fix((jwvlpl-1)/ncol);
subplot('position',[0.10+col*0.22 0.77-row*0.23 0.18 0.18])
plot(x,a,'m.'); 
ht202=title(sprintf('%2i/%2i/%2i %6.3f µm  sd:%3.1f  V0:%7.4f',month,day,year,lambda(ichan),stdev_mult,V0_calc(ichan)));
set(ht202,'fontsize',8)
if col==0 & row==1
    ylabel('Residuals','fontsize',14)
end
if col==0 & row==3
    xlabel(strxlab,'fontsize',14)
end
set(gca,'xlim',mlimp)
grid on

%pfn = strcat('c:\johnmatlab\OutputPics\','LANG',num2str(year),num2str(month),num2str(day),'\','LnVstarairmassRes',num2str(amass_min_use),'-',num2str(amass_max_use),'-',num2str(stdev_mult),'-',num2str(year),num2str(month),num2str(day),'.jpg');
%S = sprintf('print -djpeg %s',pfn);
%eval(S);

%-----------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

mean_aod_instant_calc=mean(aod_instant_calc,2);
std_aod_instant_calc=std(aod_instant_calc,1,2);

if strcmp(flag_fit_Vvsmray,'yes')
    tau_minus_ray = tau' - tau_ray(:,end);  
    tau_minus_rayO3 = tau_minus_ray - tau_O3;
    tau_minus_rayO3NO2 = tau_minus_rayO3 - tau_NO2;
    tau_minus_rayO3NO2O4 = tau_minus_rayO3NO2 - tau_O4(:,end);
    figure
    loglog(lambda(wvl_aero==1),tau(wvl_aero==1),'ko','MarkerSize',7)
    hold on
    loglog(lambda(wvl_aero==1),tau_minus_rayO3(wvl_aero==1),'bd','MarkerSize',7,'MarkerFaceColor','b')
    loglog(lambda(wvl_aero==1),tau_minus_rayO3NO2(wvl_aero==1),'ro','MarkerSize',7,'MarkerFaceColor','r')
    loglog(lambda(wvl_aero==1),tau_minus_rayO3NO2O4(wvl_aero==1),'go','MarkerSize',7,'MarkerFaceColor','g')
    axis([0.3 2.2 1e-4 1])
    set(gca,'fontsize',14)
    set(gca,'xtick',[0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.2,1.4,1.6 1.8 2.0 2.2]);
    title(sprintf('%s %2i.%2i.%2i',site,day,month,year));
    xlabel('Wavelength [µm]','fontsize',16);
    ylabel('Optical Depth','fontsize',16);
    grid on;
    
    fprintf('wvlmicr    tautotal  tau_m_Ray  tau_m_RO3 tau_m_RO3NO2  tau_aer\n')
    for ichan=channels(wvl_aero==1);
      fprintf('%7.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n',lambda(ichan),tau(ichan),tau_minus_ray(ichan),...
        tau_minus_rayO3(ichan),tau_minus_rayO3NO2(ichan),tau_minus_rayO3NO2O4(ichan));
    end
end

min_m_aero_all=min(min_m_aero);
max_m_aero_all=max(max_m_aero);

fidwriter=fopen(f_write_iter,'a+');
fprintf(fidwriter,'%02i/%02i/%4i',month,day,year);
fprintf(fidwriter,'%5.1f %5.1f %5.1f\n',min_m_aero_all,max_m_aero_all,stdev_mult);
fprintf(fidwriter,'wvlmicr    airmass_range    V0_calc    V0_prev   pctdiff_V0  tau_calc   RSD_calc\n');
for ichan=channels(wvl_aero==1);
    V0_pctdiff(ichan)=100*(V0_calc(ichan)-V0(ichan))./V0(ichan);
    fprintf(fidwriter,'%7.4f %9.4f-%7.4f %9.4f %10.4f %10.4f %10.4f %10.4f\n',lambda(ichan),airmass_min_use(ichan),...
        airmass_max_use(ichan),V0_calc(ichan),V0(ichan),V0_pctdiff(ichan),tau(ichan),RSD(ichan));
end
fprintf(fidwriter,'\r\n');
fclose(fidwriter);

%plot aerosol optical depths resulting from slope of Langley plot
figure(500+iconf)
loglog(lambda(wvl_aero==1),tau(wvl_aero==1),'go','MarkerSize',9,'MarkerFaceColor','g')
hold on

% mean_aod_instant_calc=mean(aod_instant_calc,2);
% std_aod_instant_calc=std(aod_instant_calc,1,2);

%AODlim=[.01 1]; %use for TCAPS
AODlim=[.0001 0.1]; %use for MLO

yerrorbar2('loglog',0.3,2.2,AODlim(1),AODlim(2),lambda(wvl_aero==1),mean_aod_instant_calc(wvl_aero==1),std_aod_instant_calc(wvl_aero==1),std_aod_instant_calc(wvl_aero==1),'o',0.25,'b')

axis([0.3 2.2 AODlim(1) AODlim(2)])
set(gca,'xtick',[0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.2,1.4,1.6 1.8 2.0 2.2]);
set(gca,'FontSize',14)
%title(sprintf('%s %2i/%2i/%2i  from Airborne Langley',site,month,day,year),'FontSize',12);
title(sprintf('%s %2i/%2i/%2i',site,month,day,year),'FontSize',12);
xlabel('Wavelength [µm]','FontSize',14);
ylabel('Aerosol Optical Depth','FontSize',14);
grid on;

if strcmp(flag_write,'yes')
%write results from Langley-plot to file
fid=fopen(f_write_text,'a+');
fprintf(fid,'%02i/%02i/%4i',month,day,year);
fprintf(fid,'%5.1f',min_m_aero_all,max_m_aero_all,stdev_mult)
fprintf(fid,'%9.4f',V0_calc,tau,RSD);
fprintf(fid,'\r\n');
fclose(fid);
end
end