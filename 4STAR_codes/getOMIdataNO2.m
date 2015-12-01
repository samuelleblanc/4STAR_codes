%% Details of the function:
%  NAME:
% getOMIdataNO2(omidir,daystr)
%----------------------------------
% PURPOSE:
%  - get OMI gas data (NO2)
%  - for further comparison
%  - this routine runs manually or within
%  - a compare function of 4star and OMI
%    
%
% CALLING SEQUENCE:
%   g=getOMIdataNO2(daystr,gas)
%
% INPUT:
%  - omidir is the directory where omi files are stored
%  - daystr, e.g., '20140911' as string
% 
% 
% OUTPUT:
% 
% - generates struct output of
%   OMI interpolated data along a flight path
%   locations and times are based on vis_sun
%
%
% DEPENDENCIES:
% - startup_plotting
% - save_fig
%
% NEEDED FILES/INPUT:
% - currently need to have star.mat file for the flight date
%   later this will be generated within allstarmat
% - OMI gridded files of NO2/O3, e.g., OMI-Aura_L2G-OMDOAO3G_2015m1123_v003-2015m1124t061518.he5
%   or OMI-Aura_L2G-OMNO2G_2015m1123_v003-2015m1124t180119.he5
%   from website: http://avdc.gsfc.nasa.gov/index.php?site=2045907950
%   OMNO2-L2G or OMDOASO3-L2G
%
%
% EXAMPLE:
% g=getOMIdata('C:\Users\msegalro.NDC\Campaigns\NAAMES\OMIdata\gridded\',...
%                 '20140911')
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MS), NASA Ames,Nov-25-2015 
% Modified: 2015-11-30 based on appendOMIdata for O3 only; compare purposes
% ---------------------------------------------------------------------------
%% routine
function [g] = getOMIdataNO2(omidir,daystr)

startup_plotting;
   

%% load OMI data file
    
    day = daystr(5:end);
    year= daystr(1:4);
    
    
    of       = strcat('OMI-Aura_L2G-OMNO2G_' , year, 'm', day,'*','he5');
    
    finfo   = dir([omidir,of]);
    fhdfinfo= hdf5info([omidir,finfo.name]);
    
     % read missing value
    
        lat_m        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Latitude/MissingValue');
        lon_m        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Longitude/MissingValue');
        cf_m         = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudFraction/MissingValue');
        cp_m         = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudPressure/MissingValue');
        no2_m        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2/MissingValue');
        no2s_m       = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Std/MissingValue');
        no2strat_m   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Strat/MissingValue');
        no2stratS_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2StratStd/MissingValue');
        no2trop_m    = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Trop/MissingValue');
        no2tropS_m   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2TropStd/MissingValue');
        sza_m        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/SolarZenithAngle/MissingValue');
        time_m       = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Time/MissingValue');
    
    % read Fill value
    
        lat_f        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Latitude/_FillValue');
        lon_f        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Longitude/_FillValue');
        cf_f         = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudFraction/_FillValue');
        cp_f         = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudPressure/_FillValue');
        no2_f        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2/MissingValue');
        no2s_f       = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Std/MissingValue');
        no2strat_f   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Strat/MissingValue');
        no2stratS_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2StratStd/MissingValue');
        no2trop_f    = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Trop/MissingValue');
        no2tropS_f   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2TropStd/MissingValue');
        sza_f        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/SolarZenithAngle/_FillValue');
        time_f       = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Time/_FillValue');
    
    %  read data fields
    
        lat        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Latitude');                   lat(lat==lat_m)   = NaN;  lat(lat==lat_f)    = NaN; 
        lon        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Longitude');                  lon(lon==lon_m)   = NaN;  lon(lon==lon_f)    = NaN;  
        cf         = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudFraction');              cf( cf ==cf_m)    = NaN;  cf(cf==cf_f)       = NaN; 
        cp         = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudPressure');              cp( cp ==cp_m)    = NaN;  cp(cp==cp_f)       = NaN; 
        no2        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2');            no2(no2==no2_m)   = NaN;  no2(no2==no2_f)    = NaN;
        no2s       = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Std');         no2s(no2s==no2s_m)= NaN;  no2s(no2s==no2s_f) = NaN;
        no2strat   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Strat');       no2strat(no2strat==no2strat_m)=NaN; no2strat(no2strat==no2strat_f) = NaN;
        no2stratS  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2StratStd');    no2stratS(no2stratS==no2stratS_m)=NaN; no2stratS(no2stratS==no2stratS_f) = NaN;
        no2trop    = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Trop');        no2trop(no2trop==no2trop_m)=NaN; no2trop(no2trop==no2trop_f) = NaN;
        no2tropS   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2TropStd');     no2tropS(no2tropS==no2tropS_m)=NaN; no2tropS(no2tropS==no2tropS_f) = NaN;
        sza        = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/SolarZenithAngle');           sza(sza==sza_m)   = NaN;  sza(sza==sza_f)    = NaN; 
        time       = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Time');                       time(time==time_m)= NaN;  time(time==time_f) = NaN; 
    
    % save only first level of data (out of 15, most are NaN's)
    
        lat  = squeeze(lat(:,:,1));
        lon  = squeeze(lon(:,:,1));
        cf   = squeeze(cf(:,:,1));
        cp   = squeeze(cp(:,:,1));
        no2        = squeeze(no2(:,:,1));           
        no2s       = squeeze(no2s(:,:,1));         
        no2strat   = squeeze(no2strat(:,:,1));     
        no2stratS  = squeeze(no2stratS(:,:,1));    
        no2trop    = squeeze(no2trop(:,:,1));      
        no2tropS   = squeeze(no2tropS(:,:,1));     
        sza  = squeeze(sza(:,:,1));
        time = squeeze(time(:,:,1));
    
    
 %% load relevanr flight data (from vis_sun)
    
    flfile = strcat(daystr,'star.mat');
    fl     = load([starpaths,flfile]);
    
 %% find closest values in aircraft grid
 
           % create interpolated grid
           
           longrid = lon(:); id = ~isnan(longrid); longrid = longrid(id==1);
           latgrid = lat(:); id = ~isnan(latgrid); latgrid = latgrid(id==1);
           no2grid  = no2(:);id = ~isnan(longrid);  no2grid= no2grid(id==1);
           no2stratgrid  = no2strat(:);id = ~isnan(longrid);  no2stratgrid= no2stratgrid(id==1);
           no2tropgrid   = no2trop(:);id = ~isnan(longrid);   no2tropgrid = no2tropgrid(id==1);
           
           
           Fno2  = TriScatteredInterp(double(longrid),...
                                     double(latgrid),...
                                     double(no2grid),'nearest');
           Fno2strat  = TriScatteredInterp(double(longrid),...
                                     double(latgrid),...
                                     double(no2stratgrid),'nearest');
           Fno2trop  = TriScatteredInterp(double(longrid),...
                                     double(latgrid),...
                                     double(no2tropgrid),'nearest');
          
           
           % evaluate at aircraft locations
           
           g.no2omi  = Fno2( fl.vis_sun.Lon,...
                                 fl.vis_sun.Lat);
           g.no2stratomi  = Fno2strat( fl.vis_sun.Lon,...
                                 fl.vis_sun.Lat);
           g.no2tropomi  = Fno2trop( fl.vis_sun.Lon,...
                                 fl.vis_sun.Lat);
           
                           
 %% plot 
 no2Scale=2.686763e19/1000; %molecules/cm2
 % define plot boundaries
 latmin = min(fl.vis_sun.Lat(fl.vis_sun.Lat~=0));
 latmax = max(fl.vis_sun.Lat(fl.vis_sun.Lat~=0));
 lonmin = min(fl.vis_sun.Lon(fl.vis_sun.Lon~=0));
 lonmax = max(fl.vis_sun.Lon(fl.vis_sun.Lat~=0));
 
 
 no2min     = min(no2(lon<=lonmax&lon>=lonmin&lat<=latmax&lat>=latmin));
 no2max     = max(no2(lon<=lonmax&lon>=lonmin&lat<=latmax&lat>=latmin));
 plotparam  = no2max + 0.00001;
 
 
 % plot flight path over OMI data
 figure(1)
 
 % air
    plot3(fl.vis_sun.Lon,fl.vis_sun.Lat,repmat(plotparam,length(fl.vis_sun.Lon),1),...
        'o','markersize',10,'color','k','markerFaceColor',[0 0 0]);hold on;
 
 % omi
    surf(double(lon),double(lat),double(no2),'edgecolor','none');hold on;  
    cb=colorbarlabeled('OMI NO_{2} [molec/cm^{2}]');
    set(gca,'zlim',[no2min,plotparam]);
    caxis([no2min plotparam]);
 
 
 view(2);
 
 % set plot boundaries
 set(gca,'xlim',[lonmin,lonmax]);
 set(gca,'ylim',[latmin,latmax]);
 
 % add labels
 xlabel('Longitude','fontsize',16);
 ylabel('Latitude','fontsize',16);
 title(['OMI NO_{2} ', ' data for ', daystr],'fontsize',16);
 set(gca,'fontsize',16);
 
 % save figure;
  fi1=[strcat(starpaths,'OMIfigs\','omi_no2_','4flight_',daystr)];
  save_fig(1,fi1,false);
  %close(1);
  
 % plot interpolated o3 data on flight path
 
 figure(2);
    scatter3(fl.vis_sun.Lon,fl.vis_sun.Lat,g.no2omi,8,g.no2omi);
 
    cb=colorbarlabeled('OMI NO_{2} [molec/cm^{2}]');
    set(gca,'zlim',[no2min,plotparam]);
    caxis([no2min plotparam]);
 
 view(2);
 
 % set plot boundaries
 set(gca,'xlim',[lonmin,lonmax]);
 set(gca,'ylim',[latmin,latmax]);
 
 % add labels
 xlabel('Longitude','fontsize',16);
 ylabel('Latitude','fontsize',16);
 title(['OMI NO_{2} ', ' data interpolated for flight ', daystr],'fontsize',16);
 set(gca,'fontsize',16);
 
 % save figure;
  fi1=[strcat(starpaths,'OMIfigs\','omi_no2_,','interpolated4flight_',daystr)];
  save_fig(2,fi1,false);
 %close(2);
  
  %% save values 
  
  g.mean   = nanmean(g.no2omi);
  g.std    = nanstd( g.no2omi);
  g.median = nanmedian( g.no2omi);
  g.trop   = nanmean( g.no2tropomi);
  g.strat  = nanmean( g.no2stratomi);
  
  return;  
    
    
    