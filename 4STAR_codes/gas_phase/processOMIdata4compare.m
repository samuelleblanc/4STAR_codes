%% Details of the function:
%  NAME:
% g=processOMIdata4compare(daystr,gas)
%--------------------------------------------
% PURPOSE:
%  - interpolates OMI gas data (O3 or NO2)
%  - to Lat/Lon in yyyymmdd_gas_summary.mat file
%  - and compare to processed 4STAR gas data
%  - yyyymmdd_gas_summary.mat file
%    
%
% CALLING SEQUENCE:
%   g=processOMIdata4compare(daystr,gas)
%
% INPUT:
%  - Lat/Lon is aircraft data
%  - daystr, e.g., '20140911' as string
%  - gas is gas string, 'O3' or 'NO2'
% 
% 
% OUTPUT:
% 
% - generates OMI interpolated data along a flight path
%   locations and times are based on vis_sun and compare
%   plots
%
%
% DEPENDENCIES:
%
% NEEDED FILES/INPUT:
% - yyyymmdd_gas_summary.mat file for the flight date
% - this is a function within taugases, so data comes from starwrapper.m
% - OMI gridded files of NO2/O3, e.g., OMI-Aura_L2G-OMDOAO3G_2015m1123_v003-2015m1124t061518.he5
%   or OMI-Aura_L2G-OMNO2G_2015m1123_v003-2015m1124t180119.he5
%   from website: http://avdc.gsfc.nasa.gov/index.php?site=2045907950
%   OMNO2-L2G or OMDOASO3-L2G
%
%
% EXAMPLE:
% g=processOMIdata4compare('20140911','O3')
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MS), NASA Ames,Nov-25-2015 
% MS, 2015-11-30, modified from appendOMIdata to be embedded in taugases
% MS, 2015-11-30, modified from processOMIdataO3 to include both gases
% MS, 2016-04-27, modified from processOMIdata.m routine
% ---------------------------------------------------------------------------
%% routine
function [g] = processOMIdata4compare(daystr,gas)

%% load OMI data file

    %  - omidir is the directory where omi files are stored, under
    %    starpaths
    omidir = 'C:\matlab\OMIdata\';
    day = daystr(5:end);
    year= daystr(1:4);
    
    if strcmp(gas,'O3')
            of      = strcat('OMI-Aura_L2G-OMDOAO3G_',year, 'm', day,'*','he5');
            finfo   = dir([omidir,of]);
            prefix  = [omidir,finfo.name];
            path    = '/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/';
    elseif strcmp(gas,'NO2')
            of      = strcat('OMI-Aura_L2G-OMNO2G_' , year, 'm', day,'*','he5');
            finfo   = dir([omidir,of]);
            prefix  = [omidir,finfo.name];
            path    = '/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/';
    end
    
    
    
    %fhdfinfo= hdf5info([omidir,finfo.name]);
    
     % read missing value
     
        lat_m  = hdf5read(prefix,strcat(path,'Latitude/MissingValue'));
        lon_m  = hdf5read(prefix,strcat(path,'Longitude/MissingValue'));
     
     if strcmp(gas,'O3')
        
        o3_m   = hdf5read(prefix,strcat(path,'ColumnAmountO3/MissingValue'));
        o3p_m  = hdf5read(prefix,strcat(path,'ColumnAmountO3Precision/MissingValue'));
        o3g_m  = hdf5read(prefix,strcat(path,'GhostColumnAmountO3/MissingValue'));
        rms_m  = hdf5read(prefix,strcat(path,'RootMeanSquareErrorOfFit/MissingValue'));
        
     elseif strcmp(gas,'NO2')
         
        no2_m        = hdf5read(prefix,strcat(path,'ColumnAmountNO2/MissingValue'));
        no2s_m       = hdf5read(prefix,strcat(path,'ColumnAmountNO2Std/MissingValue'));
        no2strat_m   = hdf5read(prefix,strcat(path,'ColumnAmountNO2Strat/MissingValue'));
        no2stratS_m  = hdf5read(prefix,strcat(path,'ColumnAmountNO2StratStd/MissingValue'));
        no2trop_m    = hdf5read(prefix,strcat(path,'ColumnAmountNO2Trop/MissingValue'));
        no2tropS_m   = hdf5read(prefix,strcat(path,'ColumnAmountNO2TropStd/MissingValue'));
        
     end
    
    % read Fill value
    
        lat_f  = hdf5read(prefix,strcat(path,'Latitude/_FillValue'));
        lon_f  = hdf5read(prefix,strcat(path,'Longitude/_FillValue'));
        
    if strcmp(gas,'O3')
        
        o3_f   = hdf5read(prefix,strcat(path,'ColumnAmountO3/_FillValue'));
        o3p_f  = hdf5read(prefix,strcat(path,'ColumnAmountO3Precision/_FillValue'));
        o3g_f  = hdf5read(prefix,strcat(path,'GhostColumnAmountO3/_FillValue'));
        rms_f  = hdf5read(prefix,strcat(path,'RootMeanSquareErrorOfFit/_FillValue'));
        
    elseif strcmp(gas,'NO2')
        
        no2_f        = hdf5read(prefix,strcat(path,'ColumnAmountNO2/_FillValue'));
        no2s_f       = hdf5read(prefix,strcat(path,'ColumnAmountNO2Std/_FillValue'));
        no2strat_f   = hdf5read(prefix,strcat(path,'ColumnAmountNO2Strat/_FillValue'));
        no2stratS_f  = hdf5read(prefix,strcat(path,'ColumnAmountNO2StratStd/_FillValue'));
        no2trop_f    = hdf5read(prefix,strcat(path,'ColumnAmountNO2Trop/_FillValue'));
        no2tropS_f   = hdf5read(prefix,strcat(path,'ColumnAmountNO2TropStd/_FillValue'));
        
    end
        
    
    %  read data fields
    
        lat_o  = hdf5read(prefix,strcat(path,'Latitude'));                   lat_o(lat_o==lat_m)   = NaN;  lat_o(lat_o==lat_f)    = NaN; 
        lon_o  = hdf5read(prefix,strcat(path,'Longitude'));                  lon_o(lon_o==lon_m)   = NaN;  lon_o(lon_o==lon_f)    = NaN; 
        
        if strcmp(gas,'O3')
            
                o3   = hdf5read(prefix,strcat(path,'ColumnAmountO3'));             o3( o3 ==o3_m)    = NaN;  o3(o3==o3_f)       = NaN; 
                o3p  = hdf5read(prefix,strcat(path,'ColumnAmountO3Precision'));    o3p(o3p==o3p_m)   = NaN;  o3p(o3p==o3p_f)    = NaN; 
                o3g  = hdf5read(prefix,strcat(path,'GhostColumnAmountO3'));        o3g(o3g==o3g_m)   = NaN;  o3g(o3g==o3g_f)    = NaN; 
                rms  = hdf5read(prefix,strcat(path,'RootMeanSquareErrorOfFit'));   rms(rms==rms_m)   = NaN;  rms(rms==rms_f)    = NaN; 
        
        elseif strcmp(gas,'NO2')
            
                no2        = hdf5read(prefix,strcat(path,'ColumnAmountNO2'));         no2( no2==no2_m) = NaN;                     no2(no2==no2_f) = NaN;
                no2s       = hdf5read(prefix,strcat(path,'ColumnAmountNO2Std'));      no2s(no2s==no2s_m) = NaN;                   no2s(no2s==no2s_f) = NaN;
                no2strat   = hdf5read(prefix,strcat(path,'ColumnAmountNO2Strat'));    no2strat(no2strat==no2strat_m) = NaN;       no2strat(no2strat==no2strat_f) = NaN;
                no2stratS  = hdf5read(prefix,strcat(path,'ColumnAmountNO2StratStd')); no2stratS(no2stratS==no2stratS_m) = NaN;    no2stratS(no2stratS==no2stratS_f) = NaN;
                no2trop    = hdf5read(prefix,strcat(path,'ColumnAmountNO2Trop'));     no2trop(no2trop==no2trop_m) = NaN;          no2trop(no2trop==no2trop_f) = NaN;
                no2tropS   = hdf5read(prefix,strcat(path,'ColumnAmountNO2TropStd'));  no2tropS(no2tropS==no2tropS_m) = NaN;       no2tropS(no2tropS==no2tropS_f) = NaN;
                
        end
        
    % save only first level of data (out of 15, most are NaN's)
    % and apply threshold for saving good values
    
        lat_o  = squeeze(lat_o(:,:,1));
        lon_o  = squeeze(lon_o(:,:,1));
        
        if strcmp(gas,'O3')
        
                o3   = squeeze(o3(:,:,1));     o3 = o3(:);
                o3p  = squeeze(o3p(:,:,1));    o3p= o3p(:);
                o3g  = squeeze(o3g(:,:,1));    o3g=o3g(:);
                rms  = squeeze(rms(:,:,1));    rms=rms(:);
                 
                
                % QA
                % ?
                param  = o3;
                paramG = o3g;
        
        elseif strcmp(gas,'NO2')
            
                no2        = squeeze(no2(:,:,1));          no2 = no2(:); 
                no2s       = squeeze(no2s(:,:,1));         no2s=no2s(:);
                no2strat   = squeeze(no2strat(:,:,1));     no2strat=no2strat(:);
                no2stratS  = squeeze(no2stratS(:,:,1));    no2stratS=no2stratS(:);
                no2trop    = squeeze(no2trop(:,:,1));      no2trop=no2trop(:);
                no2tropS   = squeeze(no2tropS(:,:,1));     no2tropS=no2tropS(:);
                
                % QA
                
                no2(    no2s>=2e15)=NaN;      % this is 0.075 DU
                no2trop(no2tropS>=0.5e16)=NaN;% this is 0.187 DU
                
                param = no2;
                paramS= no2strat;
                paramT= no2trop;
            
        end
        
    
    
    
 %% find closest values in aircraft grid
 
           % create interpolated grid
           
           longrid    = lon_o(:); id = ~isnan(longrid);       longrid = longrid(id==1);
           latgrid    = lat_o(:); id = ~isnan(latgrid);       latgrid = latgrid(id==1);
           paramgrid  = param;  id = ~isnan(longrid);       paramgrid  = paramgrid(id==1);
           
           Fparam  = TriScatteredInterp(double(longrid),...
                                        double(latgrid),...
                                        double(paramgrid),'nearest');
           
           
           % evaluate at aircraft locations
           
           % load 4star flight and gas data
            
           flfile = strcat(daystr,'_gas_summary.mat');
           star   = load([starpaths,flfile]);
   
           
           g.omi   = Fparam(   star.lon,...
                              star.lat);
       
                          
           % add additional parameters
           if strcmp(gas,'O3')
               
               paramG   = paramG(id==1);
               FparamG  = TriScatteredInterp(double(longrid),...
                                        double(latgrid),...
                                        double(paramG),'nearest');
               g.omio3G = FparamG(   star.lon,...
                                       star.lat);
               
           elseif strcmp(gas,'NO2')
               
               paramS  = paramS(id==1);
               paramT  = paramT(id==1);
               
               FparamS  = TriScatteredInterp(double(longrid),...
                                        double(latgrid),...
                                        double(paramS),'nearest');
               FparamT  = TriScatteredInterp(double(longrid),...
                                        double(latgrid),...
                                        double(paramT),'nearest');
                                    
               g.omino2S  = FparamS(   star.lon,...
                                       star.lat);
               g.omino2T  = FparamT(   star.lon,...
                                       star.lat);
               
           end
           
           
           
           %% add plots
           
           
           
           
           if strcmp(gas,'O3')
               
               % plot omi
               figure;
               scatter3(Lon,Lat,g.omi,20,g.omi,'filled');
               xlabel('lon');ylabel('lat');zlabel('omi O3');
               
               figure;
               scatter3(star.lon,star.tUTC,g.omi,20,g.omi,'filled');
               xlabel('lon');ylabel('tUTC');zlabel('omi O3');
               
               % scale 4star
               coeff_polyfit_tauO3modelz=[ -1.87868e-007  5.86304e-006    -9.22926e-005    1.32155e-3   -2.10909e-2     1.00005];%Mid-Lat-summer(July)

               %pst=star.pst;
               zstar = star.alt/1000;%16*log10(1013./presuseo3);% zstar needs to be in km
               frac_o3_star = polyval(coeff_polyfit_tauO3modelz,zstar);
               o3star_scaled=star.o3DU./frac_o3_star;
                
               % omi compare
               % 124.4531, 32.8711, 130.6055, 38.9355
               figure(333);
               %scatter3(g.omi(star.sza<=60),o3star_scaled(star.sza<=60),star.alt(star.sza<=60)/1000,20,star.alt(star.sza<=60)/1000,'fill');%for 20160426
               scatter3(g.omi(star.alt<=1000),o3star_scaled(star.alt<=1000),star.alt(star.alt<=1000)/1000,20,star.alt(star.alt<=1000)/1000,'fill');
               xlabel('OMI O3 interpolated to flight path [DU]');ylabel('4STAR O_{3} [DU] scaled');zlabel('Altitude [km]');
               axis([220 300 220 300 0 11]);
               colorbarlabeled('km');
               title(daystr);view(2);

               savepath = 'C:\Users\msegalro.NDC\Campaigns\KORUS_AQ\figures\';
               save_fig(333,[savepath,'staromiO3compare_',daystr],false);
               
               % time series
               figure(3331)
               if strcmp(daystr,'20160426')
                   tplot = star.tUTC;
                   tplot(tplot<10) = tplot(tplot<10)+24;
               end
               tplot = star.tUTC;
               subplot(211);
               plot(tplot,star.o3DU,'or','markerfacecolor',[0.2 0.7 0.3],'markersize',6);hold on;
               %plot(star.tUTC,star.alt/100,'.k','linewidth',2);
               legend('O_{3} [DU]','Altitude/100 [meters]');
               ylabel('VCD');
               axis([min(tplot) max(tplot) min(star.o3DU) max(star.o3DU)]);
               subplot(212);
               plot(tplot,star.o3resiDU,'or','markerfacecolor',[0.2 0.7 0.3],'markersize',6);hold on;
               ylabel('residual');xlabel('time [UTC]');
               
               savepath = 'C:\Users\msegalro.NDC\Campaigns\KORUS_AQ\figures\';
               save_fig(333,[savepath,'starO3timeseries_',daystr],false);
              
           
           elseif strcmp(gas,'NO2')
               
               % plot omi
               figure;
               scatter3(star.lon,star.lat,g.omi,20,g.omi,'filled');
               xlabel('lon');ylabel('lat');zlabel('omi NO2');
               colorbar;
               
               figure;
               scatter3(star.lon,star.lat,g.omino2T,20,g.omi,'filled');
               xlabel('lon');ylabel('lat');zlabel('omi tropospheric NO2');
               colorbar;
               
               figure;
               scatter3(star.lon,star.lat,g.omino2S,20,g.omino2S,'filled');
               xlabel('lon');ylabel('lat');zlabel('omi stratospheric NO2');
               colorbar;
               
               figure;
               scatter3(star.lon,star.tUTC,g.omino2S,20,g.omino2S,'filled');
               xlabel('lon');ylabel('tUTC');zlabel('omi stratospheric NO2');
               colorbar;
               
               figure;
               scatter3(star.lon,1/cosd((star.sza)),g.omino2S,20,g.omino2S,'filled');
               xlabel('lon');ylabel('m');zlabel('omi stratospheric NO2');
               colorbar;axis([-140 -125 3 5 0 5e15])
               
               figure(4441)
               if strcmp(daystr,'20160426')
                   tplot = star.tUTC;
                   tplot(tplot<10) = tplot(tplot<10)+24;
               end
               subplot(211);
               plot(tplot,star.no2DU,'oy','markerfacecolor',[0.2 0.7 0.3],'markersize',6);hold on;
               %plot(star.tUTC,star.alt/100,'.k','linewidth',2);
               legend('NO_{2} [DU]','Altitude/100 [meters]');
               ylabel('VCD');title(daystr);
               axis([min(tplot) max(tplot) 0 1]);
               subplot(212);
               plot(tplot,star.no2err_molec_cm2,'or','markerfacecolor',[0.2 0.7 0.3],'markersize',6);hold on;
               ylabel('residual');xlabel('time [UTC]');
               
               savepath = 'C:\Users\msegalro.NDC\Campaigns\KORUS_AQ\figures\';
               save_fig(4441,[savepath,'starNO2timeseries_',daystr],false);
              
               
               % choose no2 param
               %if strcmp(daystr,'20160426')
               %    omi_in = g.omino2S;
               %else
                   omi_in = g.omi;
               %end
               
               figure(444);
               scatter3(omi_in(star.sza<=60),star.no2_molec_cm2(star.sza<=60),star.alt(star.sza<=60)/1000,20,star.alt(star.sza<=60)/1000,'fill');
               xlabel('OMI NO2 interpolated to flight path [DU]');ylabel('4STAR NO_{2} [DU]');zlabel('Altitude [km]');
               axis([0 5e16 0 5e16 0 11]);
               colorbarlabeled('km');
               title(daystr);view(2);

               savepath = 'C:\Users\msegalro.NDC\Campaigns\KORUS_AQ\figures\';
               save_fig(444,[savepath,'staromiNO2compare_',daystr],false);
               
               
           end
           
           % prepare general plot
           
             % define plot boundaries
             latmin = min(star.lat(star.lat~=0));
             latmax = max(star.lat(star.lat~=0));
             lonmin = -140;%min(star.lon(star.lon~=0));
             lonmax = -125;%max(star.lon(star.lon~=0));

             path_param = param(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin);
             path_paramG= paramG(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin);
             %path_paramS= paramS(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin);
             
             
             pmin     = min(param(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin));
             pmax     = max(param(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin));
             
             % create omi constrained grid
             longrid_cont = longrid(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin);
             latgrid_cont = latgrid(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin);
             param_cont   = paramgrid(longrid<=lonmax&longrid>=lonmin&latgrid<=latmax&latgrid>=latmin);
             
             figure;
             hp=scatter2Pcolor(double(longrid_cont),double(latgrid_cont),double(param_cont));
             set(hp,'edgecolor','none');
             hold on;
             scatter(star.lon,star.lat,60,star.o3DU,'linewidth',0.1);

            if strcmp(gas,'O3')
                
                figure (333)
                % create subplot
                % subplot1(1,2,'Gap',[0.02 0.02]);
                % subplot1(1)
                % load boundry data
                load coast
                % [65 80],[-160 -145]
                m_proj('mercator','long',[lonmin lonmax],'lat',[latmin latmax]);
                axesm('MapProjection','mercator','MapLatLimit',[latmin latmax],'MapLonLimit',[lonmin lonmax]);
                set(gcf,'Color', 'white')
                framem
                m_coast('patch',[0.7 0.7 0.7]);
                % display boundry information
                hp = plotm(lat,long,'k');
                set(hp,'LineWidth',2.0); 
                
                % plot omi
                hp=pcolorm(double(longrid_cont),double(latgrid_cont),double(param_cont));
                set(hp,'edgecolor','none');
                
                m_grid('box','fancy','tickdir','in');hold all;
                scatterm(star.lat,star.lon,20,star.o3DU,'fill');
                xlabel('Longitude','FontSize',12);
                ylabel('Latitude','FontSize',12);

                scatterm(latgrid,longrid,60,paramgrid,'fill');
                %set(gca,'Visible','off');
                cmin = pmin - 50;
                cmax = pmin + 50;
                caxis([cmin cmax]);colorbarlabeled(' ');
                colormap('jet');
                h=plotm(sall.vis_sun.Lat,sall.vis_sun.Lon,'-k','linewidth',2);
                scatterm(star.lat,star.lon,20,star.o3DU,'fill','markeredgecolor','k','linewidth',0.1);
                scatterm(star.lat,star.lon,20,star.o3DU,'fill');
                xlabel('Longitude','FontSize',12);
                ylabel('Latitude','FontSize',12);

                
                
                 figure(1)

                 % air
                 plot3(Lon,Lat,repmat(plotparam,length(Lon),1),...
                       'o','markersize',10,'color','k','markerFaceColor',[0 0 0]);hold on;

                 % omi
                 surf(double(lon_o),double(lat_o),double(o3),'edgecolor','none');hold on;  
                 cb=colorbarlabeled('OMI O_{3} [DU]');
                 set(gca,'zlim',[o3min,plotparam]);
                 caxis([o3min plotparam]);

                 view(2);

                 % set plot boundaries
                 set(gca,'xlim',[lonmin,lonmax]);
                 set(gca,'ylim',[latmin,latmax]);

                 % add labels
                 xlabel('Longitude','fontsize',16);
                 ylabel('Latitude','fontsize',16);
                 title(['OMI O_{3} ', ' data for ', daystr],'fontsize',16);
                 set(gca,'fontsize',16);

                
                
                
            elseif strcmp(gas,'NO2')
                
            end
  
  return;
  
    
    
    
    