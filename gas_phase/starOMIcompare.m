%% Details of the function:
% NAME:
%   starOMIcompare(campaign)
% 
% PURPOSE:
%   compare 4STAR retrieved values
%   with OMI daily gridded values
%   along flight path
% 
%
% CALLING SEQUENCE:
%  function [s] = starOMIcompare
%
% INPUT:
%  - campaign is campaign name string, e.g. 'ARISE'
% 
% 
% OUTPUT:
%  - yyyymmddstarOMIsummar.mat: statistics summary file
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%
% NEEDED FILES:
%  - flight starsun.mat files
%  - OMI gridded L2 no2/o3 hdf files
%
% EXAMPLE:
%  - [s] = starOMIcompare('ARISE');
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, NASA Ames, Feb-18, 2015
%
% -------------------------------------------------------------------------
%% function routine
function [s] = starOMIcompare(campaign)
%---------------------------------------------------------
%% regulate input
plotting  = false;% this is default
direcOMI  = input('OMI files directory:'         ,'s');
dirdata   = input('starsun files main directory:','s');

%% select dates for each campaign
if strcmp(campaign,'TCAP')
      ds  ={'20130617' '20130618' '20130619' '20130620'};
elseif strcmp(campaign,'SEAC4RS')
      ds  ={'20130617' '20130618' '20130619' '20130620'};
elseif strcmp(campaign,'ARISE')
      %ds  ={'20140901' '20140902' '20140904' '20140905'};
       ds  ={'20140904'};
end

% loop over relevant days
for ii=1:length(ds);

% OMI o3
o3file  = strcat(direcOMI,filesep, 'OMI-Aura_L2G-OMTO3G_',ds{:,ii}(1:4),'m',ds{:,ii}(5:8),'_*');
o3in    = strcat(direcOMI,filesep,ls(o3file));

% OMI no2
no2file = strcat(direcOMI,filesep,'OMI-Aura_L2G-OMNO2G_',ds{:,ii}(1:4),'m',ds{:,ii}(5:8),'_*');
no2in   = strcat(direcOMI,filesep,ls(no2file));

% load 4star
starfile = strcat(dirdata,filesep,ds{:,ii},filesep,ds{:,ii},'starsunfinal.mat');
star     = load(starfile,'t','Lat','Lon','Alt','Pst','tau_aero','gas','m_O3','m_NO2','flags');
disp(['loading:',starfile]);

% str title for plotting
str_file4STARflight=strcat('file4STAR-flight',ds{:,ii});
str_fileOMIozone   =ls(o3file);
str_fileOMINO2     =ls(no2file);

% define goodindex times and locations
  lonminval = min(star.Lon);
  lonmaxval = max(star.Lon);
  latminval = min(star.Lat);
  latmaxval = max(star.Lat);
  tplot = serial2Hh(star.t); tplot(tplot<10) = tplot(tplot<10)+24;
  maxUT     = max(tplot);
  minUT     = min(tplot);

% assign o3/no2 VCD
  o3VCD   = star.gas.o3;
  o3RMSE  = star.gas.o3resi;
  no2VCD  = star.gas.no2;
  no2RMSE = star.gas.no2resi;

% filter data according to RMSE and flags 
  o3RMSE(o3RMSE<0|o3RMSE>10)    =NaN; o3MSEthresh  = 3;
  no2RMSE(no2RMSE<0|no2RMSE>0.5)=NaN; no2MSEthresh = 0.1;
  idxuse_o3 =(find(star.Lon>=lonminval & star.Lon<=lonmaxval...
               &   star.Lat>=latminval & star.Lat<=latmaxval...
               &   tplot>=minUT & tplot<=maxUT...
               & o3RMSE<=o3MSEthresh & o3VCD>=150 & o3VCD <=500));
  idxuse_no2 =(find(star.Lon>=lonminval & star.Lon<=lonmaxval...
               & star.Lat>=latminval & star.Lat<=latmaxval...
               & tplot>=minUT & tplot<=maxUT...
               & no2RMSE<=no2MSEthresh & no2VCD>=0 & no2VCD <=10));

% assign o3/no2 values
  star.o3    =o3VCD(idxuse_o3);
  star.o3rmse=real(o3RMSE(idxuse_o3));
  star.no2=no2VCD(idxuse_no2);
  star.no2rmse=real(no2RMSE(idxuse_no2));
            
% read aux data from star file
% this is separated due to different thresholds in RMS filtering
    
    UTuse_o3=tplot(idxuse_o3);               UTuse_no2=tplot(idxuse_no2);
    zkmuse_o3=(1/1000)*star.Alt(idxuse_o3);  zkmuse_no2=(1/1000)*star.Alt(idxuse_no2);
    latuse_o3=star.Lat(idxuse_o3);           latuse_no2=star.Lat(idxuse_no2);
    lonuse_o3=star.Lon(idxuse_o3);           lonuse_no2=star.Lon(idxuse_no2);
    presuseo3=star.Pst(idxuse_o3);           presuseno2=star.Pst(idxuse_no2);

% assign larger range for general flight path plots
if length(UTuse_o3)>length(UTuse_no2)
    UTuse = UTuse_o3; zkmuse = zkmuse_o3;   latuse = latuse_o3; lonuse = lonuse_o3;
else
    UTuse = UTuse_no2; zkmuse = zkmuse_no2; latuse = latuse_no2; lonuse = lonuse_no2;
end

% plot flight parameters
figure(101)
subplot(4,1,1)
plot(lonuse,latuse,'.')
set(gca,'fontsize',16)
%set(gca,'xlim',maplonlim,'ylim',maplatlim)
grid on
xlabel('Longitude (deg)','fontsize',20)
ylabel('Latitude (deg)','fontsize',20)
subplot(4,1,2)
plot(UTuse,zkmuse,'.')
set(gca,'fontsize',16)
grid on
ylabel('Altitude (km)','fontsize',20)
subplot(4,1,3)
plot(UTuse,latuse,'.')
set(gca,'fontsize',16)
%set(gca,'ylim',maplatlim)
grid on
ylabel('Latitude (deg)','fontsize',20)
subplot(4,1,4)
plot(UTuse,lonuse,'.')
set(gca,'fontsize',16)
%set(gca,'ylim',maplonlim)
grid on
ylabel('Longitude (deg)','fontsize',20);title(ds{:,ii});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  begin aircraft track plot    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot limits
lonlims_plt=[min(lonuse) max(lonuse)];
timecrit=[minUT maxUT];
msize=4;
colorlevels=[0 1 1; 0 0 1; 0 1 0; 1 1 0; 1 .65 .4; 1 0 1;1 0 0;0.8 0.2 0.2;0.5 0.5 0.5];%;0 0 0]; % cyan,blue,green,yellow,orange,magenta,red,brown,gray
zcrit=[0.25 0.5 1:2:8];
% plot altitude during flight
figure(71)
cm=colormap(colorlevels);
jp=find(zkmuse<=zcrit(1));
if ~isempty(timecrit)
    jp=find(zkmuse<=zcrit(1) & UTuse>=timecrit(1) & UTuse<=timecrit(2));
end
plot(lonuse(jp),latuse(jp),'o','color',cm(1,:),'markersize',msize,'markerfacecolor',cm(1,:))
hold on
for i=2:length(zcrit),
    jp=find(zkmuse>zcrit(i-1) & zkmuse<=zcrit(i));
    if ~isempty(timecrit)
        jp=find(zkmuse>zcrit(i-1) & zkmuse<=zcrit(i) & UTuse>=timecrit(1) & UTuse<=timecrit(2));
    end
    plot(lonuse(jp),latuse(jp),'o','color',cm(i,:),'markersize',msize,'markerfacecolor',cm(i,:))
end
jp=find(zkmuse>zcrit(end));
if ~isempty(timecrit)
    jp=find(zkmuse>zcrit(end) & UTuse>=timecrit(1) & UTuse<=timecrit(2));
end
plot(lonuse(jp),latuse(jp),'o','color',cm(length(zcrit),:),'markersize',msize,'markerfacecolor',cm(length(zcrit),:))
%plot(lonuse(jp),latuse(jp),'o','color',cm(length(zcrit)+1,:),'markersize',msize,'markerfacecolor',cm(length(zcrit)+1,:))
hold on
grid on
set(gca,'fontsize',20)
xlabel('Longitude [deg]','fontsize',24)
ylabel('Latitude [deg]','fontsize',24)
set(gca,'xlim',lonlims_plt);
title(sprintf('Flight Track: %s  %6.3f-%6.3f UT',str_file4STARflight,timecrit(1),timecrit(2)),'fontsize',14)
ylims=get(gca,'ylim');
ntim=length(latuse);
itim=[1:ntim];
if ~isempty(timecrit)
    itim=find(UTuse>=timecrit(1)&UTuse<=timecrit(2));
    ntim=length(itim);
end
dely=0.02*(ylims(2)-ylims(1));
for j=1:floor(ntim/10):ntim,
    i=itim(j);
    plot(lonuse(i),latuse(i),'o','markersize',10,'MarkerFacecolor','b')
    ht=text(lonuse(i),latuse(i)-dely,sprintf('%5.2f',UTuse(i)));
    set(ht,'fontsize',16,'color','b') %'fontweight','bold',
end
xlimits=get(gca,'xlim');
ylimits=get(gca,'ylim');
cb=colorbar;
%set(cb,'yticklabel',[0 zcrit inf],'fontsize',16)
set(cb,'yticklabel',[0 zcrit],'fontsize',16)
cbpos=get(cb,'Position');
ht2=text(xlimits(2)+0.015*(xlimits(2)-xlimits(1)),ylimits(1)+0.03*(ylimits(2)-ylimits(1)),'Altitude [km]');
set(ht2,'fontsize',16)
%%%%%%%%%%%%%%%%%%%%%%  End aircraft track plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx4STAR_crit_o3 =idxuse_o3;
idx4STAR_crit_no2=idxuse_no2;
maplonlim=[lonminval lonmaxval];
maplatlim=[latminval latmaxval];

%% compare O3
%------------

 [OMIO3_latgridsav,OMIO3_longridsav,lat_OMIO3,lon_OMIO3,ixtrk_OMIO3,iytrk_OMIO3,ozoneDU_OMI,CloudFraction_OMI,CloudPressure_OMI,UVAerosolIndex_OMI,...
    ozoneDU_OMI_vect,CloudFraction_OMI_vect,CloudPressure_OMI_vect,UVAerosolIndex_OMI_vect,...
    idx4STAR_ingrid_O3,lat_OMIO3_center,lon_OMIO3_center,lat_OMIO3_corner,lon_OMIO3_corner]=...
    determine_OMIo3grid_gridcells(o3in,str_file4STARflight,maplonlim,maplatlim,star.Lat,star.Lon,idx4STAR_crit_o3);

% convert NaN cloudF to 2 (i.e. high value)
% CloudFraction_OMI(isnan(CloudFraction_OMI)) = 2;
goodO3 = logical(CloudFraction_OMI_vect<=0.1&ozoneDU_OMI_vect>200);
meanO3 = mean(ozoneDU_OMI_vect(goodO3==1));

    % polynomial fit coefficients for ozone profile shape
    % new (2011 McPeters Climatology): 
    if     strcmp(campaign,    'TCAP')
        coeff_polyfit_tauO3modelz=[ -1.87868e-007  5.86304e-006    -9.22926e-005    1.32155e-3   -2.10909e-2     1.00005]; %Mid-Lat-summer(July)
       %coeff_polyfit_tauO3model=[5.78038e-007  -2.49196e-005   3.74087e-004  -1.85068e-003  -9.77087e-003   1.00538e+000];%Mid-Lat-winter(Feb)
    elseif strcmp(campaign,'SEAC4RS')
       %coeff_polyfit_tauO3model=[8.60377e-007  -3.26194e-005   3.54396e-004  -1.30386e-003  -5.67021e-003   9.99948e-001];% US1976
        coeff_polyfit_tauO3modelz=[ -1.87868e-007  5.86304e-006    -9.22926e-005    1.32155e-3   -2.10909e-2     1.00005]; % Mid-Lat-summer(July)
    elseif strcmp(campaign,   'ARISE')
        % need to add arctic coef!!!
        coeff_polyfit_tauO3modelz=[5.78038e-007  -2.49196e-005   3.74087e-004  -1.85068e-003  -9.77087e-003   1.00538e+000];%Mid-Lat-winter(Feb)
    end

    % calculate z* from pressure
    % Z* = 16 x log(1013/P)
    % where P is pressure in hPa (and the log is base 10)

    zstar = 16*log10(1013./presuseo3);

    % frac_O3 = polyval(coeff_polyfit_tauO3model,zkmuse_o3);%!!! change to z* based on Pressure
    % frac_O3 = polyval(coeff_polyfit_tauO3model,zkmuse_o3);%!!! change to z* based on Pressure
    % o34STAR_scaled=o3_4STAR./frac_O3;

    frac_O3zstar = polyval(coeff_polyfit_tauO3modelz,zstar);
    o34STARz_scaled=star.o3./frac_O3zstar;
    %
    % assign correct values
    o34STAR_scaled = o34STARz_scaled;
    
    %ozoneDU_OMI_vect_scaled = mean(ozoneDU_OMI_vect(12:21))*0.9594;
    ozonelim=[250 300];
    figure(501)
    ax1=subplot(2,1,1);
    plot(OMIO3_longridsav,OMIO3_latgridsav,'--','color','k','linewidth',2)
    set(gca,'fontsize',16)
    ylabel('Latitude (deg)','fontsize',20)
    hold on
    scatter(lonuse_o3,latuse_o3,20,star.o3,'filled')
    title(sprintf('%s   %s   4STAR O_{3} not scaled by altitude',str_fileOMIozone,str_file4STARflight),'fontsize',12)
    caxis(ozonelim);
    for i=1:size(OMIO3_latgridsav,2),
        ht=text(lon_OMIO3(i),lat_OMIO3(i),sprintf('%6.1f',ozoneDU_OMI_vect(i)));
        set(ht,'fontsize',12)
    end
    yt=[ozonelim(1):10:ozonelim(2)];
    hcb=colorbar%('East');
    set(hcb,'fontsize',14, 'ytick', yt, 'yticklabel', num2str(yt'))
    %xlimits=get(gca,'xlim');
    %ylimits=get(gca,'ylim');
    %ht3=text(xlimits(2)-0.1*(xlimits(2)-xlimits(1)),ylimits(1)-0.3*(ylimits(2)-ylimits(1)),'O_{3}[DU]');
    %set(ht3,'fontsize',14)
    ax2=subplot(2,1,2);
    plot(OMIO3_longridsav,OMIO3_latgridsav,'--','color','k','linewidth',2)
    set(gca,'fontsize',16)
    xlabel('Longitude (deg)','fontsize',20)
    ylabel('Latitude (deg)','fontsize',20)
    hold on
    scatter(lonuse_o3,latuse_o3,20,o34STAR_scaled,'filled')
    % code that turnes zero values to white
    idx_zero=find(star.o3==0);
    Cval=ones(length(idx_zero),3);
    %scatter(lonuse(idx_zero),latuse(idx_zero),20,Cval,'filled') %replaces zero values with white markers
    plot(lonuse_o3(idx_zero),latuse_o3(idx_zero),'kx');
    %---------------------------------------------
    title(sprintf('4STAR ozone scaled by altitude',str_file4STARflight),'fontsize',14)
    caxis(ozonelim);
    for i=1:size(OMIO3_latgridsav,2),
        ht=text(lon_OMIO3(i),lat_OMIO3(i),sprintf('%6.1f',ozoneDU_OMI_vect(i)));
        set(ht,'fontsize',12)
    end
    yt=[ozonelim(1):10:ozonelim(2)];
    hcb=colorbar%('East');
    set(hcb,'fontsize',14, 'ytick', yt, 'yticklabel', num2str(yt'))
    linkaxes([ax1 ax2],'x')

    ozonelim=[250 300];
    figure(502)
    plot(OMIO3_longridsav,OMIO3_latgridsav,'--','color','k','linewidth',2)
    set(gca,'fontsize',16)
    xlabel('Longitude (deg)','fontsize',20)
    ylabel('Latitude (deg)','fontsize',20)
    hold on
    scatter(lonuse_o3,latuse_o3,20,o34STAR_scaled,'filled')
    % code that turnes zero values to white
    idx_zero=find(o34STAR_scaled==0);
    Cval=ones(length(idx_zero),3);
    %scatter(lonuse(idx_zero),latuse(idx_zero),20,Cval,'filled') %replaces zero values with white markers
    plot(lonuse_o3(idx_zero),latuse_o3(idx_zero),'kx');
    %---------------------------------------------
    title(sprintf('%s   %s   4STAR O_{3} scaled by altitude',str_fileOMIozone,str_file4STARflight),'fontsize',12)
    caxis(ozonelim);
    for i=1:4:size(OMIO3_latgridsav,2),
        ht=text(lon_OMIO3(i),lat_OMIO3(i),sprintf('%6.1f',ozoneDU_OMI_vect(i)));
        set(ht,'fontsize',12)
    end
    yt=[ozonelim(1):10:ozonelim(2)];
    hcb=colorbar;
    set(hcb,'fontsize',14, 'ytick', yt, 'yticklabel', num2str(yt'))
    xlimits=get(gca,'xlim');
    ylimits=get(gca,'ylim');
    ht3=text(xlimits(2)-0.19*(xlimits(2)-xlimits(1)),ylimits(2)+0.022*(ylimits(2)-ylimits(1)),' 4STAR O_{3}[DU]');
    set(ht3,'fontsize',14)
%
%==================== end ozone compare ======================

%% NO2 compare
%-------------

[OMINO2_latgridsav,OMINO2_longridsav,lat_OMINO2,lon_OMINO2,ixtrk_OMINO2,iytrk_OMINO2,lat_OMINO2_center,lon_OMINO2_center,lat_OMINO2_corner,lon_OMINO2_corner,...
    NO2_OMI_map,NO2std_OMI_map,NO2strat_OMI_map,NO2stratstd_OMI_map,NO2trop_OMI_map,NO2tropstd_OMI_map,NO2CloudFraction_OMI_map,NO2CloudPressure_OMI_map,...
    NO2_OMI,NO2std_OMI,NO2strat_OMI,NO2stratstd_OMI,NO2trop_OMI,NO2tropstd_OMI,NO2CloudFraction_OMI,NO2CloudPressure_OMI,idx4STAR_ingrid_NO2]...
    =determine_OMIno2grid_gridcells(no2in,str_file4STARflight,maplonlim,maplatlim,star.Lat,star.Lon,idx4STAR_crit_no2);

goodNO2 = logical(NO2CloudFraction_OMI<=0.1);
meanNO2tot = mean(NO2_OMI(goodNO2==1));
meanNO2s   = mean(NO2strat_OMI(goodNO2==1));
meanNO2t   = mean(NO2trop_OMI(goodNO2==1));

if mode==1
    no24STAR_plot=no2_4STARs*2.6868e+016;%convert from DU to molec/cm2;when molec/cm2 multiply by 1e-15, so this is then in units of [10^15 molec/cm^2]
    NO2lim=[1 10];
    figure(511)
    plot(OMINO2_longridsav,OMINO2_latgridsav,'--','color','k','linewidth',2)
    set(gca,'fontsize',16)
    xlabel('Longitude (deg)','fontsize',20)
    ylabel('Latitude (deg)','fontsize',20)
    hold on
    scatter(lonuse_no2,latuse_no2,20,no24STAR_plot,'filled')
    % code that turnes zero values to white/black
    idx_zero=find(no24STAR_plot==0);
    Cval=ones(length(idx_zero),3);
    %scatter(lonuse(idx_zero),latuse(idx_zero),20,Cval,'filled') %replaces zero values with white markers
    plot(lonuse_no2(idx_zero),latuse_no2(idx_zero),'kx');
    %---------------------------------------------
    title(sprintf('%s   %s',str_fileOMINO2,str_file4STARflight),'fontsize',12)
    caxis(NO2lim);
    for i=1:size(OMINO2_latgridsav,2),
        ht=text(lon_OMINO2(i),lat_OMINO2(i),sprintf('%6.1f',NO2_OMI(i)*1e-15));
        set(ht,'fontsize',12)
    end
    yt=[NO2lim(1):0.5:NO2lim(2)];
    hcb=colorbar;
    set(hcb,'fontsize',14, 'ytick', yt, 'yticklabel', num2str(yt'))
    xlimits=get(gca,'xlim');
    ylimits=get(gca,'ylim');
    ht5=text(xlimits(2)-0.18*(xlimits(2)-xlimits(1)),ylimits(2)+0.022*(ylimits(2)-ylimits(1)),'4STAR NO_{2}[10^{15} molec/cm^2]');
    set(ht5,'fontsize',14)
end
%==================== end NO2 processing ======================

%============ start averaging flight in OMI grid ==============

%modify the following for calculating mean, std. with OMI grid cells
%
%=============================== O3 ==============================%
% scaled values
%-------------------------
 for kp=1:length(ozoneDU_OMI_vect),
        if any(idx4STAR_ingrid_O3(:,kp))
            % replace scaled values w non-scaled values and constrain alt
            idxuse4STAR_O3            = (idx4STAR_ingrid_O3(:,kp)==1 & o34STAR_scaled'>0 & o3_4STARmse'<=3 & o3_4STARmse'>0);% & zkmuse_o3'<=0.1);
            n4STARs_pts_in_O3OMIcell(kp)= sum(idxuse4STAR_O3);
            
            meanO3UT_4STAR (:,kp)       = nanmean(UTuse_o3(idxuse4STAR_O3==1));
            stdO3UT_4STAR (:,kp)        = nanstd(UTuse_o3(idxuse4STAR_O3==1));
            meanO3_4STAR(:,kp)         = nanmean (o34STAR_scaled(idxuse4STAR_O3==1));
%             minO3_4STAR(:,kp)          = min     ([1e6;o3_4STAR(idxuse4STAR_O3==1)]);
%             maxO3_4STAR(:,kp)          = max     ([1e-6;o3_4STAR(idxuse4STAR_O3==1)]);
            stdO3_4STAR(:,kp)          = nanstd  (o34STAR_scaled(idxuse4STAR_O3==1)); 
            zkmO3avg_4STAR(:,kp)        = nanmean (zkmuse_o3(idxuse4STAR_O3==1));
            zkmO3std_4STAR(:,kp)        = nanstd  (zkmuse_o3(idxuse4STAR_O3==1)); 
            lonO3avg_4STAR(:,kp)        = nanmean (lonuse_o3(idxuse4STAR_O3==1));
            lonO3std_4STAR(:,kp)        = nanstd  (lonuse_o3(idxuse4STAR_O3==1)); 
            latO3avg_4STAR(:,kp)        = nanmean (latuse_o3(idxuse4STAR_O3==1));
            latO3std_4STAR(:,kp)        = nanstd  (latuse_o3(idxuse4STAR_O3==1)); 
        end
 end
%
% scaled values
%----------------
  for kp=1:length(ozoneDU_OMI_vect),
         if any(idx4STAR_ingrid_O3(:,kp))
             idxuse4STAR_O3            = (idx4STAR_ingrid_O3(:,kp)==1 & o34STAR_scaled'>0);% & zkmuse_o3<=0.1);
             n4STARpts_in_O3OMIcell(kp)= sum(idxuse4STAR_O3);
             
             meanO3_4STARs(:,kp)        = nanmean (o34STAR_scaled(idxuse4STAR_O3==1));
%              minO3_4STAR(:,kp)         = min     ([1e6;o3_4STAR(idxuse4STAR_O3==1)]);
%              maxO3_4STAR(:,kp)         = max     ([1e-6;o3_4STAR(idxuse4STAR_O3==1)]);
             stdO3_4STARs(:,kp)         = nanstd  (o34STAR_scaled(idxuse4STAR_O3==1));          
         end
   end
%==================================================================%    
%=============================== NO2 ==============================%

 for kp=1:length(NO2_OMI),
        if any(idx4STAR_ingrid_NO2(:,kp))
            idxuse4STAR_NO2            = (idx4STAR_ingrid_NO2(:,kp)==1 & no24STAR_plot'>0 & no2_4STARmse'<=4e-5 & no2_4STARmse'>0);% & zkmuse_no2<=0.1);
            n4STARpts_in_NO2OMIcell(kp)= sum(idxuse4STAR_NO2);
            meanNO2UT_4STAR (:,kp)     = nanmean(UTuse_no2(idxuse4STAR_NO2==1));
            stdNO2UT_4STAR (:,kp)      = nanmean(UTuse_no2(idxuse4STAR_NO2==1));
            meanNO2_4STAR(:,kp)        = nanmean (no24STAR_plot(idxuse4STAR_NO2==1));
%             minNO2_4STAR(:,kp)         = min  ([1e6;no2_4STARs(idxuse4STAR_NO2==1)]);
%             maxNO2_4STAR(:,kp)         = max  ([1e-6;no2_4STARs(idxuse4STAR_NO2==1)]);
            stdNO2_4STAR(:,kp)         = nanstd  (no24STAR_plot(idxuse4STAR_NO2==1));  
            zkmNO2avg_4STAR(:,kp)      = nanmean (zkmuse_no2(idxuse4STAR_NO2==1));
            zkmNO2std_4STAR(:,kp)      = nanstd  (zkmuse_no2(idxuse4STAR_NO2==1)); 
            lonNO2avg_4STAR(:,kp)      = nanmean (lonuse_no2(idxuse4STAR_NO2==1));
            lonNO2std_4STAR(:,kp)      = nanstd  (lonuse_no2(idxuse4STAR_NO2==1)); 
            latNO2avg_4STAR(:,kp)      = nanmean (latuse_no2(idxuse4STAR_NO2==1));
            latNO2std_4STAR(:,kp)      = nanstd  (latuse_no2(idxuse4STAR_NO2==1)); 
        end
  end
%==================================================================%    
%
%========================== calculate statistics===================%
if ~isempty(ozoneDU_OMI_vect)
      o3ind = ~isNaN(meanO3_4STAR)&ozoneDU_OMI_vect>200;%CloudFraction_OMI_vect<0.1;
      rmsdiff_O3s = sqrt(sum((meanO3_4STARs(o3ind==1)-ozoneDU_OMI_vect(o3ind==1)).^2)/length(meanO3_4STARs(o3ind==1)));
      rmsdiff_O3  = sqrt(sum((meanO3_4STAR(o3ind==1)-ozoneDU_OMI_vect(o3ind==1)).^2)/length(meanO3_4STAR(o3ind==1)));
      bias_O3s=sum(meanO3_4STARs(o3ind==1)-ozoneDU_OMI_vect(o3ind==1))/length(meanO3_4STARs(o3ind==1));
      bias_O3 =sum(meanO3_4STAR(o3ind==1)-ozoneDU_OMI_vect(o3ind==1))/length(meanO3_4STAR(o3ind==1));
      [r1s,p1s]=corrcoef(real(ozoneDU_OMI_vect(o3ind==1)),real(meanO3_4STARs(o3ind==1)));
      
      [r1,p1]=corrcoef(real(ozoneDU_OMI_vect(o3ind==1)),real(meanO3_4STAR(o3ind==1)));
      if length(r1)>1
      rsq_O3=r1(1,2).^2;
      rsq_O3s=r1s(1,2).^2;
      else
      rsq_O3=NaN;
      rsq_O3s = NaN;
      end
      
else
    rmsdiff_O3s = NaN; rmsdiff_O3 = NaN; bias_O3s = NaN; bias_O3 = NaN; rsq_O3s = NaN; rsq_O3 = NaN;
    n4STARs_pts_in_O3OMIcell = NaN; meanO3UT_4STAR = NaN; stdO3UT_4STAR = NaN; meanO3s_4STAR = NaN;
            minO3s_4STAR = NaN; maxO3s_4STAR = NaN; stdO3s_4STAR = NaN; zkmO3avg_4STAR = NaN; 
            zkmO3std_4STAR = NaN; lonO3avg_4STAR = NaN; lonO3std_4STAR = NaN; latO3avg_4STAR = NaN;
            latO3std_4STAR = NaN; n4STARpts_in_O3OMIcell = NaN; meanO3_4STAR = NaN; minO3_4STAR = NaN;
            maxO3_4STAR = NaN; stdO3_4STAR = NaN; 
end
%
if ~isempty(NO2_OMI)
      no2ind = ~isNaN(meanNO2_4STAR);
      rmsdiff_NO2 = sqrt(sum((meanNO2_4STAR(no2ind==1)-NO2_OMI(no2ind==1)).^2)/length(meanNO2_4STAR(no2ind==1)));
      bias_NO2=sum(NO2_OMI(no2ind==1)-meanNO2_4STAR(no2ind==1))/length(meanNO2_4STAR(no2ind==1));
      [r1n,p1n]=corrcoef(real(NO2_OMI(no2ind==1)),real(meanNO2_4STAR(no2ind==1)));
      if length(r1n)>1
      rsq_NO2=r1n(1,2).^2;
      else
      rsq_NO2=NaN;
      end
else
      rmsdiff_NO2 = NaN; bias_NO2 = NaN; rsq_NO2 = NaN;
       n4STARpts_in_NO2OMIcell = NaN; meanNO2UT_4STAR = NaN; stdNO2UT_4STAR  = NaN; meanNO2_4STAR = NaN;
       minNO2_4STAR = NaN; maxNO2_4STAR = NaN; stdNO2_4STAR  = NaN; zkmNO2avg_4STAR = NaN; zkmNO2std_4STAR = NaN;
       lonNO2avg_4STAR = NaN; lonNO2std_4STAR = NaN; latNO2avg_4STAR = NaN; latNO2std_4STAR = NaN;
end

%--------------------------------------------------------------------
  % save data into .mat (NO2 and O3)
  % save for each date
  flightdate = strcat('flight',ds{ii},'Data');
  avg4STAR_OMI.OMIo3.(flightdate)       = ozoneDU_OMI_vect;
  avg4STAR_OMI.OMIo3cloudfrac.(flightdate)= CloudFraction_OMI_vect;
  avg4STAR_OMI.OMIo3cloudpres.(flightdate)= CloudPressure_OMI_vect;
  avg4STAR_OMI.OMIuvAI.(flightdate)     = UVAerosolIndex_OMI_vect;
  avg4STAR_OMI.OMIo3Flag.(flightdate)   = AlgorithmFlags_OMI_vect;
  avg4STAR_OMI.STARo3sAvg.(flightdate)  = meanO3_4STARs;
  avg4STAR_OMI.STARo3sStd.(flightdate)  = stdO3_4STARs;
  avg4STAR_OMI.STARo3Avg.(flightdate)   = meanO3_4STAR;
  
  avg4STAR_OMI.STARo3Std.(flightdate)   = stdO3_4STAR;
  avg4STAR_OMI.OMIno2tot.(flightdate)   = NO2_OMI;
  avg4STAR_OMI.OMIno2cloudfrac.(flightdate)= NO2CloudFraction_OMI;
  avg4STAR_OMI.OMIno2cloudpres.(flightdate)= NO2CloudPressure_OMI;
  avg4STAR_OMI.OMIno2strat.(flightdate) = NO2strat_OMI;
  avg4STAR_OMI.OMIno2trop.(flightdate)  = NO2trop_OMI;
  avg4STAR_OMI.STARno2Avg.(flightdate)  = meanNO2_4STAR;
  
  avg4STAR_OMI.STARno2Std.(flightdate)  = stdNO2_4STAR;
  avg4STAR_OMI.n4STARs_pts_in_O3OMIcell.(flightdate)  = n4STARs_pts_in_O3OMIcell;
  avg4STAR_OMI.n4STARspts_in_O3OMIcell.(flightdate)   = n4STARpts_in_O3OMIcell;
  avg4STAR_OMI.n4STARpts_in_NO2OMIcell.(flightdate)   = n4STARpts_in_NO2OMIcell;
  avg4STAR_OMI.rmsdiff_O3s.(flightdate) = rmsdiff_O3s;
  avg4STAR_OMI.rmsdiff_O3.(flightdate)  = rmsdiff_O3;
  avg4STAR_OMI.bias_O3s.(flightdate)    = bias_O3s;
  avg4STAR_OMI.bias_O3.(flightdate)     = bias_O3;
  avg4STAR_OMI.rsq_O3s.(flightdate)     = rsq_O3s;
  avg4STAR_OMI.rsq_O3.(flightdate)      = rsq_O3;
  avg4STAR_OMI.rmsdiff_NO2.(flightdate) = rmsdiff_NO2;
  avg4STAR_OMI.bias_NO2.(flightdate)    = bias_NO2;
  avg4STAR_OMI.rsq_NO2.(flightdate)     = rsq_NO2;
  % time data
  avg4STAR_OMI.tO3avg_4STAR.(flightdate)      = meanO3UT_4STAR;
  avg4STAR_OMI.tO3std_4STAR.(flightdate)      = stdO3UT_4STAR;
  avg4STAR_OMI.tNO2avg_4STAR.(flightdate)     = meanNO2UT_4STAR;
  avg4STAR_OMI.tNO2std_4STAR.(flightdate)     = stdNO2UT_4STAR;
  % alt data
  avg4STAR_OMI.zkmO3avg_4STAR.(flightdate)      = zkmO3avg_4STAR;
  avg4STAR_OMI.zkmO3std_4STAR.(flightdate)      = zkmO3std_4STAR;
  avg4STAR_OMI.zkmNO2avg_4STAR.(flightdate)     = zkmNO2avg_4STAR;
  avg4STAR_OMI.zkmNO2std_4STAR.(flightdate)     = zkmNO2std_4STAR;
  % lon data
  avg4STAR_OMI.lonO3avg_4STAR.(flightdate)      = lonO3avg_4STAR;
  avg4STAR_OMI.lonO3std_4STAR.(flightdate)      = lonO3std_4STAR;
  avg4STAR_OMI.lonNO2avg_4STAR.(flightdate)     = lonNO2avg_4STAR;
  avg4STAR_OMI.lonNO2std_4STAR.(flightdate)     = lonNO2std_4STAR;
  % lat data
  avg4STAR_OMI.latO3avg_4STAR.(flightdate)      = latO3avg_4STAR;
  avg4STAR_OMI.latO3std_4STAR.(flightdate)      = latO3std_4STAR;
  avg4STAR_OMI.latNO2avg_4STAR.(flightdate)     = latNO2avg_4STAR;
  avg4STAR_OMI.latNO2std_4STAR.(flightdate)     = latNO2std_4STAR;
  % OMI time
  % avg4STAR_OMI.OMIoverpassUT.(flightdate)     = UTdechr_OMI;
  
  % clear stat variables
  clear idxuse4STAR_O3
  clear n4STARs_pts_in_O3OMIcell
  clear meanO3s_4STAR
  clear minO3s_4STAR
  clear maxO3s_4STAR
  clear stdO3s_4STAR
  clear zkmO3avg_4STAR
  clear zkmO3std_4STAR
  clear meanO3UT_4STAR
  clear stdO3UT_4STAR
  clear lonO3avg_4STAR
  clear lonO3std_4STAR
  clear latO3avg_4STAR
  clear latO3std_4STAR
  
  clear n4STARpts_in_O3OMIcell
  clear meanO3_4STAR
  clear minO3_4STAR
  clear maxO3_4STAR
  clear stdO3_4STAR 
  
  clear idxuse4STAR_NO2
  clear n4STARpts_in_NO2OMIcell
  clear meanNO2_4STAR
  clear minNO2_4STAR
  clear maxNO2_4STAR
  clear stdNO2_4STAR
  clear meanNO2UT_4STAR
  clear stdNO2UT_4STAR
  clear zkmNO2avg_4STAR
  clear zkmNO2std_4STAR
  clear meanNO2UT_4STAR
  clear stdNO2UT_4STAR
  clear lonNO2avg_4STAR
  clear lonNO2std_4STAR
  clear latNO2avg_4STAR
  clear latNO2std_4STAR
  
  close(71)
  close(501)
  close(502)
  close(511)
  close(443)
  close(444)
  close(453)
  close(454)
  close(101)
  
  
end

%% save
s = avg4STAR_OMI;
fi = strcat(campaign,ds{1,:},'_',ds{end,:},'starOMIcompare.mat');
save(fi,'-struct','avg4STAR_OMI');

%% plot
if plotting
% compare statistics
%--------------------
% 1. 4STAR/OMI above 3 km and for low altitude (all)
% 2. only all column comparisons
% 3. delta NO2 vs. delta t
%
% plot each day (all data) 4STAR vs. OMI
figure(111)
for pp=1:(length(ds))
    subplot(2,(length(ds))/2,pp)
    no2ind = ~isNaN(avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data')));
    errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data'))(no2ind==1),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data'))(no2ind==1),...
             avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data'))(no2ind==1),'og','markerfacecolor','g','markersize',6);hold on;
    plot([1e14:1e14:10e15],[1e14:1e14:10e15],'--b','linewidth',3);hold off;set(gca,'fontsize',12,'fontweight','bold');
    h1=text(4e14,9e15,ds{pp});
    set(h1,'FontSize',12,'fontweight','bold','Color','k')
    if pp==1
        ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
    elseif pp==6
        ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
    end
    if pp>5
        xlabel('OMI total NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
    end
    axis([1e14 10e15 1e14 10e15]);
end
% plot high altitude and all column
% figure(222)
% for pp=1:(length(ds))
%     subplot(2,(length(ds))/2,pp)
%     errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data')),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data')),...
%              avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data')),'og','markerfacecolor','g','markersize',6);hold on;
%     altind = avg4STAR_OMI.zkmNO2avg_4STAR.(strcat('flight',ds{pp},'Data'))<=0.3;
%     errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data'))(altind==1),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data'))(altind==1),...
%              avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data'))(altind==1),'o','color',[0.2 0.1 0.9],'markerfacecolor',[0.2 0.1 0.9],'markersize',6);hold on;
%     stdind = avg4STAR_OMI.zkmNO2std_4STAR.(strcat('flight',ds{pp},'Data'))<=0.2;
%     errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data'))(stdind==1),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data'))(stdind==1),...
%              avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data'))(stdind==1),'o','color',[0.9 0.1 0.2],'markerfacecolor',[0.9 0.1 0.2],'markersize',4);hold on;
%     legend('All Data','Data at Altitude (avg.) < 300 m','Data at Altitude SD. < 200 m');
%     plot([1e14:1e14:10e15],[1e14:1e14:10e15],'--b','linewidth',3);hold on;
%     set(gca,'fontsize',12,'fontweight','bold');
%     
%     h1=text(4e14,9e15,ds{pp});
%     set(h1,'FontSize',10,'fontweight','bold','Color','k')
%     if pp==1
%         ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
%     elseif pp==6
%         ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
%     end
%     if pp>5
%         xlabel('OMI total NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
%     end
%     axis([1e14 10e15 1e14 10e15]);
% end
% %
% plot all data (excluding 20120714)
colorfig=[0 1 1; 0 0 1; 0 1 0; 1 1 0; 1 .65 .4; 1 0 1;1 0 0;0.8 0.2 0.2;0.5 0.5 0.5;0.5 0.2 0.1];
no2rmsdiffall = [];
no2biasall  = [];
figure(333)
set(0,'defaultaxescolororder',colorfig);
for pp=[1:8];
    no2ind = ~isNaN(avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data')));
    plot(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data')),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data')),'d',...
        'color',colorfig(pp,:),'markerfacecolor',colorfig(pp,:),'markersize',6);hold on;
    set(gca,'fontsize',12,'fontweight','bold');
    %legend_(pp)=([ds(pp)]); 
    h1(pp)=text(4e14,9e15-(pp-1)*0.5e15,ds{pp});
    set(h1(pp),'FontSize',10,'fontweight','bold','Color',colorfig(pp,:))
    % save data array for each
    no2rmsdiff    = avg4STAR_OMI.rmsdiff_NO2.(strcat('flight',ds{pp},'Data'));
    no2rmsdiffall = [no2rmsdiffall no2rmsdiff];
    no2bias       = avg4STAR_OMI.bias_NO2.(strcat('flight',ds{pp},'Data'));
    no2biasall    = [no2biasall no2bias];
end
DUconvert = 2.7e16;
rmsdiffplot = nanmean(no2rmsdiffall);rmsdiffplotDU = rmsdiffplot/DUconvert;
biasplot    = nanmean(no2biasall);   biasplotDU = biasplot/DUconvert;

% write values on plot
h1=text(2.5e15,9e14,['RMS diff = ',sprintf('%4.2e',rmsdiffplot),', molec/cm^{2}, ',sprintf('%4.2f',rmsdiffplotDU),'DU']);
set(h1,'FontSize',12,'fontweight','bold','Color',[1 1 1])
h2=text(2.5e15,1.5e15,['Bias = ',sprintf('%4.2e',biasplot),', molec/cm^{2}, ',sprintf('%4.2f',biasplotDU),'DU']);
set(h2,'FontSize',12,'fontweight','bold','Color',[1 1 1])
plot([1e14:1e14:10e15],[1e14:1e14:10e15],'--','color',[1 1 1],'linewidth',3);hold on;
axis([1e14 10e15 1e14 10e15]);
xlabel('OMI total NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold','color','k');
ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold','color','k');
set(gca,'linewidth',2,'color',[0.8 0.1 0.6]);
%
% plot only below 100 m
colorfig=[0 1 1; 0 0 1; 0 1 0; 1 1 0; 1 .65 .4; 1 0 1;1 0 0;0.8 0.2 0.2;0.5 0.5 0.5;0.5 0.2 0.1];
no2rmsdiffalllow = [];
no2biasalllow  = [];
figure(3333)
set(0,'defaultaxescolororder',colorfig);
for pp=[1:8];
    no2ind = logical(avg4STAR_OMI.zkmNO2avg_4STAR.(strcat('flight',ds{pp},'Data'))<=0.3)% & avg4STAR_OMI.zkmNO2std_4STAR.(strcat('flight',ds{pp},'Data'))<=0.05);
    errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data'))(no2ind==1),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data'))(no2ind==1),avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data'))(no2ind==1),'d',...
        'color',colorfig(pp,:),'markerfacecolor',colorfig(pp,:),'markersize',6);hold on;
    set(gca,'fontsize',12,'fontweight','bold');
    %legend_(pp)=([ds(pp)]); 
    h1(pp)=text(4e14,9e15-(pp-1)*0.5e15,ds{pp});
    set(h1(pp),'FontSize',10,'fontweight','bold','Color',colorfig(pp,:))
    % save data array for each
    no2rmsdifflow    = avg4STAR_OMI.rmsdiff_NO2.(strcat('flight',ds{pp},'Data'));
    no2rmsdiffalllow = [no2rmsdiffalllow no2rmsdifflow];
    no2biaslow       = avg4STAR_OMI.bias_NO2.(strcat('flight',ds{pp},'Data'));
    no2biasalllow    = [no2biasalllow no2biaslow];
end
DUconvert = Loschmidt/1000;
rmsdiffplotlow = nanmean(no2rmsdiffalllow);rmsdiffplotDUlow = rmsdiffplotlow/DUconvert;
biasplotlow    = nanmean(no2biasalllow);   biasplotDUlow = biasplotlow/DUconvert;

% write values on plot
h1=text(2.5e15,9e14,['RMS diff = ',sprintf('%4.2e',rmsdiffplotlow),' molec/cm^{2}, ',sprintf('%4.2f',rmsdiffplotDUlow),'DU']);
set(h1,'FontSize',12,'fontweight','bold','Color',[1 1 1])
h2=text(2.5e15,1.5e15,['Bias = ',sprintf('%4.2e',biasplotlow),' molec/cm^{2}, ',sprintf('%4.2f',biasplotDUlow),'DU']);
set(h2,'FontSize',12,'fontweight','bold','Color',[1 1 1])
plot([1e14:1e14:10e15],[1e14:1e14:10e15],'--','color',[1 1 1],'linewidth',3);hold on;
axis([1e14 10e15 1e14 10e15]);
xlabel('OMI total NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold','color','k');
ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold','color','k');
set(gca,'linewidth',2,'color',[0.8 0.1 0.6]);

% plot time variability
figure(555)
for pp=1:(length(ds))
    subplot(2,(length(ds))/2,pp)
    errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data')),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data')),...
             avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data')),'og','markerfacecolor','g','markersize',6);hold on;
    timeind = abs(avg4STAR_OMI.tNO2avg_4STAR.(strcat('flight',ds{pp},'Data'))-avg4STAR_OMI.OMIoverpassUT.(strcat('flight',ds{pp},'Data')))<=1.0;
    errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data'))(timeind==1),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data'))(timeind==1),...
             avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data'))(timeind==1),'o','color',[0.9 0.1 0.9],'markerfacecolor',[0.9 0.1 0.9],'markersize',6);hold on;
    lonind = avg4STAR_OMI.lonNO2std_4STAR.(strcat('flight',ds{pp},'Data'))<=0.05;
    errorbar(avg4STAR_OMI.OMIno2tot.(strcat('flight',ds{pp},'Data'))(lonind==1),avg4STAR_OMI.STARno2Avg.(strcat('flight',ds{pp},'Data'))(lonind==1),...
             avg4STAR_OMI.STARno2Std.(strcat('flight',ds{pp},'Data'))(lonind==1),'o','color',[0.9 0.5 0.2],'markerfacecolor',[0.9 0.5 0.2],'markersize',6);hold on;
    legend('All Data','\DeltaT (OMI-4STAR) < 60 min.','Longitude SD. < 0.05^{o}');
    plot([1e14:1e14:10e15],[1e14:1e14:10e15],'--b','linewidth',3);hold on;
    set(gca,'fontsize',12,'fontweight','bold');
    
    h1=text(4e14,9e15,ds{pp});
    set(h1,'FontSize',10,'fontweight','bold','Color','k')
    if pp==1
        ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
    elseif pp==6
        ylabel('4STAR NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
    end
    if pp>5
        xlabel('OMI total NO2 [molec/cm^{2}]','fontsize',14,'fontweight','bold');
    end
    axis([1e14 10e15 1e14 10e15]);
end
%
% plot O3 results
% plot each day (all data) 4STAR vs. OMI
figure(666)
for pp=1:(length(ds))
    subplot(2,(length(ds))/2,pp)
    errorbar(avg4STAR_OMI.OMIo3.(strcat('flight',ds{pp},'Data')),real(avg4STAR_OMI.STARo3Avg.(strcat('flight',ds{pp},'Data'))),...
             avg4STAR_OMI.STARo3Std.(strcat('flight',ds{pp},'Data')),'oc','markerfacecolor','c','markersize',6);hold on;
    plot([250:10:450],[250:10:450],'--b','linewidth',3);hold off;
    h1=text(255,370,ds{pp});
    set(h1,'FontSize',12,'fontweight','bold','Color','k')
    if pp==1
        ylabel('4STAR O3 [DU]','fontsize',14,'fontweight','bold');
    elseif pp==5
        ylabel('4STAR O3 [DU]','fontsize',14,'fontweight','bold');
    end
    if pp>4
        xlabel('OMI total O3 [DU]','fontsize',14,'fontweight','bold');
    end
    axis([250 450 250 450]);set(gca,'fontsize',12,'fontweight','bold');
end
%

% plot only all column instances

% plot high altitude and all column
figure(777)
for pp=1:(length(ds))
    subplot(2,(length(ds))/2,pp)
    errorbar(avg4STAR_OMI.OMIo3.(strcat('flight',ds{pp},'Data')),avg4STAR_OMI.STARo3Avg.(strcat('flight',ds{pp},'Data')),...
             avg4STAR_OMI.STARo3Std.(strcat('flight',ds{pp},'Data')),'oc','markerfacecolor','c','markersize',6);hold on;
    altind = avg4STAR_OMI.zkmO3avg_4STAR.(strcat('flight',ds{pp},'Data'))<=0.1&avg4STAR_OMI.zkmO3std_4STAR.(strcat('flight',ds{pp},'Data'))<=0.1;
    errorbar(avg4STAR_OMI.OMIo3.(strcat('flight',ds{pp},'Data'))(altind==1),avg4STAR_OMI.STARo3Avg.(strcat('flight',ds{pp},'Data'))(altind==1),...
             avg4STAR_OMI.STARo3Std.(strcat('flight',ds{pp},'Data'))(altind==1),'o','color',[0.9 0.1 0.2],'markerfacecolor',[0.9 0.1 0.2],'markersize',6);hold on;
    legend('All Data','Data at Altitude (avg.) < 100 m');
    plot([250:10:450],[250:10:450],'--b','linewidth',3);hold on;
    set(gca,'fontsize',12,'fontweight','bold');
    
    h1=text(250,370,ds{pp});
    set(h1,'FontSize',10,'fontweight','bold','Color','k')
    if pp==1
        ylabel('4STAR O3 [DU]','fontsize',14,'fontweight','bold');
    elseif pp==6
        ylabel('4STAR O3 [DU]','fontsize',14,'fontweight','bold');
    end
    if pp>5
        xlabel('OMI total O3 [DU]','fontsize',14,'fontweight','bold');
    end
    axis([250 450 250 450]);
end

% refine RMS diff and bias of ozone according to alt<300m
% plot all and results only for total column

% ozone all
% plot all data
colorfig=[0 1 1; 0 0 1; 0 1 0; 1 1 0; 1 .65 .4; 1 0 1;1 0 0;0.8 0.2 0.2];%;0.5 0.5 0.5;0.5 0.2 0.1];
o3rmsdiffall = [];
o3biasall  = [];
figure(3333)
set(0,'defaultaxescolororder',colorfig);
for pp=[1:8];
    stdind = avg4STAR_OMI.OMIo3cloudfrac.(strcat('flight',ds{pp},'Data'))<=0.2;%avg4STAR_OMI.STARo3Std.(strcat('flight',ds{pp},'Data'))<=10&
%     plot(avg4STAR_OMI.OMIo3.(strcat('flight',ds{pp},'Data')),avg4STAR_OMI.STARo3Avg.(strcat('flight',ds{pp},'Data')),'d',...
%         'color',colorfig(pp,:),'markerfacecolor',colorfig(pp,:),'markersize',6);hold on;
    errorbar(avg4STAR_OMI.OMIo3.(strcat('flight',ds{pp},'Data')),avg4STAR_OMI.STARo3Avg.(strcat('flight',ds{pp},'Data')),avg4STAR_OMI.STARo3Std.(strcat('flight',ds{pp},'Data')),'d',...
        'color',colorfig(pp,:),'markerfacecolor',colorfig(pp,:),'markersize',6);hold on;
    set(gca,'fontsize',12,'fontweight','bold');
    %legend_(pp)=([ds(pp)]); 
    h1(pp)=text(260,430-(pp-1)*10,ds{pp});
    set(h1(pp),'FontSize',10,'fontweight','bold','Color',colorfig(pp,:))
    % save data array for each
    o3rmsdiff    = avg4STAR_OMI.rmsdiff_O3.(strcat('flight',ds{pp},'Data'));
    o3rmsdiffall = [o3rmsdiffall o3rmsdiff];
    o3bias       = avg4STAR_OMI.bias_O3.(strcat('flight',ds{pp},'Data'));
    o3biasall    = [o3biasall o3bias];
end

rmsdiffplot = nanmean(o3rmsdiffall);
biasplot    = nanmean(o3biasall);  

% write values on plot
h1=text(350,260,['RMS diff = ',sprintf('%4.2f',rmsdiffplot),' [DU] ']);
set(h1,'FontSize',12,'fontweight','bold','Color','k')
h2=text(350,275,['Bias = ',sprintf('%4.2f',biasplot),' [DU] ']);
set(h2,'FontSize',12,'fontweight','bold','Color','k')
plot([250:10:450],[250:10:450],'--','color','k','linewidth',3);hold on;
axis([250 450 250 450]);
xlabel('OMI total O_{3} [DU]','fontsize',14,'fontweight','bold','color','k');
ylabel('4STAR O_{3} (scaled) [DU]','fontsize',14,'fontweight','bold','color','k');
set(gca,'linewidth',2,'color','k');set(gca,'color',[1 1 1]);

% save NO2 stratospheric data
starNO2strat = real([avg4STAR_OMI.STARno2Avg.flight20130214Data avg4STAR_OMI.STARno2Avg.flight20130228Data]);
starNO2stratStd = real([avg4STAR_OMI.STARno2Std.flight20130214Data avg4STAR_OMI.STARno2Std.flight20130228Data]);
starNO2alt      = real([avg4STAR_OMI.zkmNO2avg_4STAR.flight20130214Data avg4STAR_OMI.zkmNO2avg_4STAR.flight20130228Data]);
starOMIstrat = [avg4STAR_OMI.OMIno2strat.flight20130214Data avg4STAR_OMI.OMIno2strat.flight20130228Data];
no2sind = logical(starNO2alt>6);
rmsdiff_NO2s = sqrt(sum((starNO2strat(no2sind==1)-starOMIstrat(no2sind==1)).^2)/length(starNO2strat(no2sind==1)));
bias_NO2s=sum(starNO2strat(no2sind==1)-starOMIstrat(no2sind==1))/length(starNO2strat(no2sind==1));

figure;

h=errorbar(starOMIstrat(no2sind==1),starNO2strat(no2sind==1),starNO2stratStd(no2sind==1),'d','color',[0.9 0.2 0.5],'markerfacecolor',[0.9 0.2 0.5],'markersize',10);hold on;
%yerrorbar2('linear',1.5e15, 3e15, 5e15, 3e15, starOMIstrat(no2sind==1), y, l,u,symbol,teewidth,colorsym);hold on;
%set(h,'whiskers',3);
plot([1.5e15:0.5e15:3e15],[1.5e15:0.5e15:3e15],'--','color','k','linewidth',3);hold on;
axis([1.5e15 3e15 1.5e15 3e15]);
xlabel('OMI Stratospheric NO_{2} [molec/cm^{2}]','fontsize',14,'fontweight','bold','color','k');
ylabel('4STAR NO_{2} (from Langley flights) [molec/cm^{2}]','fontsize',14,'fontweight','bold','color','k');
set(gca,'linewidth',2,'color','k');set(gca,'color','none');set(gca,'fontsize',14','fontweight','bold');
% write values on plot
h1=text(2.0e15,1.7e15,['RMS diff = ',sprintf('%4.2e',rmsdiff_NO2s),' [molec/cm^{2}], ',sprintf('%4.3f',rmsdiff_NO2s/(Loschmidt/1000)),' [DU]']);
set(h1,'FontSize',12,'fontweight','bold','Color','k')
h2=text(2.0e15,2e15,['Bias = ',sprintf('%4.2e',bias_NO2s),' [molec/cm^{2}], ',sprintf('%4.3f',bias_NO2s/(Loschmidt/1000)),' [DU]']);
set(h2,'FontSize',12,'fontweight','bold','Color','k');

TCAPIIno2s.star    = starNO2strat;
TCAPIIno2s.starStd = starNO2stratStd;
TCAPIIno2s.omi     = starOMIstrat;
TCAPIIno2s.bias    = bias_NO2s;
TCAPIIno2s.rmsdiff = rmsdiff_NO2s;

no2sfilename = 'TCAPIIno2strat.mat';
save(no2sfilename,'-struct','TCAPIIno2s');
%
% errorbar plots:
% yerrorbar2(axestype,xmin, xmax, ymin, ymax, x, y, l,u,symbol,teewidth,colorsym)
% yerrorbar2('loglog',0.3,2.2,ylim37(1),ylim37(2),lambda(wvl_aero==1),tau_a27_mean(wvl_aero==1),tau_a27_std(wvl_aero==1),tau_a27_std(wvl_aero==1),'o',0.25,'k')

end;%if plotting

return;


