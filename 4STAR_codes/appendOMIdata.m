%% Details of the function:
%  NAME:
% appendOMIdata(omidir,daystr,gas)
%----------------------------------
% PURPOSE:
%  - appends OMI gas data (O3 or NO2)
%  - to star.mar file
%  - in future should be ambedded in
%  - allstarmat.m
%    
%
% CALLING SEQUENCE:
%   g=appendOMIdata(daystr,gas)
%
% INPUT:
%  - omidir is the directory where omi files are stored
%  - daystr, e.g., '20140911' as string
%  - gas, i.e, 'o3' or 'no2'
% 
% 
% OUTPUT:
% 
% - generates struct and ASCII file output of
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
% g=appendOMIdata('C:\Users\msegalro.NDC\Campaigns\NAAMES\OMIdata\gridded\',...
%                 '20140911','o3')
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MS), NASA Ames,Nov-25-2015 
% 
% ---------------------------------------------------------------------------
%% routine
function [g] = appendOMIdata(omidir,daystr,gas)

startup_plotting;
   

%% load OMI data file
    
    day = daystr(5:end);
    year= daystr(1:4);
    
    if strcmp(gas,'o3')
        of       = strcat('OMI-Aura_L2G-OMDOAO3G_',year, 'm', day,'*','he5');
    elseif strcmp(gas,'no2')
        of       = strcat('OMI-Aura_L2G-OMNO2G_' , year, 'm', day,'*','he5');
    end
    
    finfo   = dir([omidir,of]);
    fhdfinfo= hdf5info([omidir,finfo.name]);
    
     % read missing value
    
        lat_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Latitude/MissingValue');
        lon_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Longitude/MissingValue');
        amf_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/AirMassFactor/MissingValue');
        cf_m   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/CloudFraction/MissingValue');
        cp_m   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/CloudPressure/MissingValue');
        o3_m   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ColumnAmountO3/MissingValue');
        o3p_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ColumnAmountO3Precision/MissingValue');
        o3g_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/GhostColumnAmountO3/MissingValue');
        qa_m   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ProcessingQualityFlags/MissingValue');
        rms_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/RootMeanSquareErrorOfFit/MissingValue');
        sza_m  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/SolarZenithAngle/MissingValue');
        time_m = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Time/MissingValue');
    
    % read Fill value
    
        lat_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Latitude/_FillValue');
        lon_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Longitude/_FillValue');
        amf_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/AirMassFactor/_FillValue');
        cf_f   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/CloudFraction/_FillValue');
        cp_f   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/CloudPressure/_FillValue');
        o3_f   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ColumnAmountO3/_FillValue');
        o3p_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ColumnAmountO3Precision/_FillValue');
        o3g_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/GhostColumnAmountO3/_FillValue');
        qa_f   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ProcessingQualityFlags/_FillValue');
        rms_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/RootMeanSquareErrorOfFit/_FillValue');
        sza_f  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/SolarZenithAngle/_FillValue');
        time_f = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Time/_FillValue');
    
    %  read data fields
    
        lat  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Latitude');                   lat(lat==lat_m)   = NaN;  lat(lat==lat_f)    = NaN; 
        lon  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Longitude');                  lon(lon==lon_m)   = NaN;  lon(lon==lon_f)    = NaN; 
        amf  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/AirMassFactor');              amf(amf==amf_m)   = NaN;  amf(amf==amf_f)    = NaN; 
        cf   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/CloudFraction');              cf( cf ==cf_m)    = NaN;  cf(cf==cf_f)       = NaN; 
        cp   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/CloudPressure');              cp( cp ==cp_m)    = NaN;  cp(cp==cp_f)       = NaN; 
        o3   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ColumnAmountO3');             o3( o3 ==o3_m)    = NaN;  o3(o3==o3_f)       = NaN; 
        o3p  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ColumnAmountO3Precision');    o3p(o3p==o3p_m)   = NaN;  o3p(o3p==o3p_f)    = NaN; 
        o3g  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/GhostColumnAmountO3');        o3g(o3g==o3g_m)   = NaN;  o3g(o3g==o3g_f)    = NaN; 
        qa   = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/ProcessingQualityFlags');     qa( qa ==qa_m)    = NaN;  qa(qa==qa_f)       = NaN; 
        rms  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/RootMeanSquareErrorOfFit');   rms(rms==rms_m)   = NaN;  rms(rms==rms_f)    = NaN; 
        sza  = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/SolarZenithAngle');           sza(sza==sza_m)   = NaN;  sza(sza==sza_f)    = NaN; 
        time = hdf5read([omidir,finfo.name],'/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/Time');                       time(time==time_m)= NaN;  time(time==time_f) = NaN; 
    
    % save only first level of data (out of 15, most are NaN's)
    
        lat  = squeeze(lat(:,:,1));
        lon  = squeeze(lon(:,:,1));
        amf  = squeeze(amf(:,:,1));
        cf   = squeeze(cf(:,:,1));
        cp   = squeeze(cp(:,:,1));
        o3   = squeeze(o3(:,:,1));
        o3p  = squeeze(o3p(:,:,1));
        o3g  = squeeze(o3g(:,:,1));
        qa   = squeeze(qa(:,:,1));
        rms  = squeeze(rms(:,:,1));
        sza  = squeeze(sza(:,:,1));
        time = squeeze(time(:,:,1));
    
    
 %% load relevanr flight data (from vis_sun)
    
    flfile = strcat(daystr,'star.mat');
    fl     = load([starpaths,flfile]);
    
 %% find closest values in aircraft grid
 
           % create interpolated grid
           
           longrid = lon(:); id = ~isnan(longrid); longrid = longrid(id==1);
           latgrid = lat(:); id = ~isnan(latgrid); latgrid = latgrid(id==1);
           o3grid  = o3(:);  id = ~isnan(o3grid);  o3grid  = o3grid(id==1);
           o3ggrid = o3g(:); id = ~isnan(o3ggrid); o3ggrid = o3ggrid(id==1);
           rmsgrid = rms(:); id = ~isnan(rmsgrid); rmsgrid = rmsgrid(id==1);
           
           
           Fo3  = TriScatteredInterp(double(longrid),...
                                     double(latgrid),...
                                     double(o3grid),'nearest');
           Fo3g = TriScatteredInterp(double(longrid),...
                                     double(latgrid),...
                                     double(o3ggrid),'nearest');
                                 
           Frms = TriScatteredInterp(double(longrid),...
                                     double(latgrid),...
                                     double(rmsgrid),'nearest');
           
           % evaluate at aircraft locations
           
           g.o3omi  = Fo3( fl.vis_sun.Lon,...
                                 fl.vis_sun.Lat);
           g.o3g    = Fo3g(fl.vis_sun.Lon,...
                                 fl.vis_sun.Lat);
           g.rms    = Frms(fl.vis_sun.Lon,...
                                 fl.vis_sun.Lat);
                           
                           
 %% plot 
 
 % define plot boundaries
 latmin = min(fl.vis_sun.Lat(fl.vis_sun.Lat~=0));
 latmax = max(fl.vis_sun.Lat(fl.vis_sun.Lat~=0));
 lonmin = min(fl.vis_sun.Lon(fl.vis_sun.Lon~=0));
 lonmax = max(fl.vis_sun.Lon(fl.vis_sun.Lat~=0));
 
 if strcmp(gas,'o3')
    o3min     = min(o3(lon<=lonmax&lon>=lonmin&lat<=latmax&lat>=latmin));
    o3max     = max(o3(lon<=lonmax&lon>=lonmin&lat<=latmax&lat>=latmin));
    plotparam = o3max + 0.01;
 elseif strcmp(gas,'no2')
    no2min = min(no2(lon<=lonmax&lon>=lonmin&lat<=latmax&lat>=latmin));
    no2max = max(no2(lon<=lonmax&lon>=lonmin&lat<=latmax&lat>=latmin));
    plotparam = no2max + 0.01;
 end
 
 % plot flight path over OMI data
 figure(1)
 
 % air
 plot3(fl.vis_sun.Lon,fl.vis_sun.Lat,repmat(plotparam,length(fl.vis_sun.Lon),1),...
       'o','markersize',10,'color','k','markerFaceColor',[0 0 0]);hold on;
 
 if strcmp(gas,'o3')
     % omi
    surf(double(lon),double(lat),double(o3),'edgecolor','none');hold on;  
    cb=colorbarlabeled('OMI O_{3} [DU]');
    set(gca,'zlim',[o3min,plotparam]);
    caxis([o3min plotparam]);
 elseif strcmp(gas,'no2')
     % omi
    surf(double(lon),double(lat),double(no2),'edgecolor','none');hold on;  
    cb=colorbarlabeled('OMI NO_{2} [DU]');
    set(gca,'zlim',[no2min,plotparam]);
    caxis([no2min plotparam]);
 end
 
 view(2);
 
 % set plot boundaries
 set(gca,'xlim',[lonmin,lonmax]);
 set(gca,'ylim',[latmin,latmax]);
 
 % add labels
 xlabel('Longitude','fontsize',16);
 ylabel('Latitude','fontsize',16);
 title(['OMI ', gas, ' data for ', daystr],'fontsize',16);
 set(gca,'fontsize',16);
 
 % save figure;
  fi1=[strcat(starpaths,'OMIfigs\','omi_',gas,'_','4flight_',daystr)];
  save_fig(1,fi1,false);
  %close(1);
  
 % plot interpolated o3 data on flight path
 
 figure(2);
 scatter3(fl.vis_sun.Lon,fl.vis_sun.Lat,g.o3omi,8,g.o3omi);
 
 if strcmp(gas,'o3')
    cb=colorbarlabeled('OMI O_{3} [DU]');
    set(gca,'zlim',[o3min,plotparam]);
    caxis([o3min plotparam]);
 elseif strcmp(gas,'no2')
    cb=colorbarlabeled('OMI NO_{2} [DU]');
    set(gca,'zlim',[no2min,plotparam]);
    caxis([no2min plotparam]);
 end
 
 view(2);
 
 % set plot boundaries
 set(gca,'xlim',[lonmin,lonmax]);
 set(gca,'ylim',[latmin,latmax]);
 
 % add labels
 xlabel('Longitude','fontsize',16);
 ylabel('Latitude','fontsize',16);
 title(['OMI ', gas, ' data interpolated for flight ', daystr],'fontsize',16);
 set(gca,'fontsize',16);
 
 % save figure;
  fi1=[strcat(starpaths,'OMIfigs\','omi_',gas,'_','interpolated4flight_',daystr)];
  save_fig(2,fi1,false);
 %close(2);
  
  %% save values 
  
  g.mean   = nanmean(g.o3omi);
  g.std    = nanstd( g.o3omi);
  g.median = median( g.o3omi);
  g.max    = mean(   g.o3omi+g.o3g);
  
    
    
    
    