%% Details of the function:
%  NAME:
% g=processOMIdata(Lat,Lon,daystr,gas)
%----------------------------------
% PURPOSE:
%  - interpolates OMI gas data (O3 or NO2)
%  - to Lat/Lon in star.mar/SUN file
%  - this routine runs within taugases.m
%    
%
% CALLING SEQUENCE:
%   g=processOMIdata(Lat,Lon,daystr,gas)
%
% INPUT:
%  - Lat/Lon is aircraft data from s struct
%  - daystr, e.g., '20140911' as string
%  - gas is gas string, 'O3' or 'NO2'
% 
% 
% OUTPUT:
% 
% - generates OMI interpolated data along a flight path
%   locations and times are based on vis_sun
%
%
% DEPENDENCIES:
%
% NEEDED FILES/INPUT:
% - currently need to have star.mat/s file for the flight date
% - this is a function within taugases, so data comes from starwrapper.m
% - OMI gridded files of NO2/O3, e.g., OMI-Aura_L2G-OMDOAO3G_2015m1123_v003-2015m1124t061518.he5
%   or OMI-Aura_L2G-OMNO2G_2015m1123_v003-2015m1124t180119.he5
%   from website: http://avdc.gsfc.nasa.gov/index.php?site=2045907950
%   OMNO2-L2G or OMDOASO3-L2G
%
%
% EXAMPLE:
% g=processOMIdata(Lat,Lon,'20140911','O3')
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MS), NASA Ames,Nov-25-2015 
% MS, 2015-11-30, modified from appendOMIdata to be embedded in taugases
% MS, 2015-11-30, modified from processOMIdataO3 to include both gases
% ---------------------------------------------------------------------------
%% routine
function [g] = processOMIdata(Lat,Lon,daystr,gas)

%% load OMI data file

    %  - omidir is the directory where omi files are stored, under
    %    starpaths
    omidir = 'OMIdata\';
    day = daystr(5:end);
    year= daystr(1:4);
    
    if strcmp(gas,'O3')
            of      = strcat('OMI-Aura_L2G-OMDOAO3G_',year, 'm', day,'*','he5');
            finfo   = dir([starpaths,omidir,of]);
            prefix  = [starpaths,omidir,finfo.name];
            path    = '/HDFEOS/GRIDS/ColumnAmountO3/Data Fields/';
    elseif strcmp(gas,'NO2')
            of      = strcat('OMI-Aura_L2G-OMNO2G_' , year, 'm', day,'*','he5');
            finfo   = dir([starpaths,omidir,of]);
            prefix  = [starpaths,omidir,finfo.name];
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
    
        lat  = hdf5read(prefix,strcat(path,'Latitude'));                   lat(lat==lat_m)   = NaN;  lat(lat==lat_f)    = NaN; 
        lon  = hdf5read(prefix,strcat(path,'Longitude'));                  lon(lon==lon_m)   = NaN;  lon(lon==lon_f)    = NaN; 
        
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
    
        lat  = squeeze(lat(:,:,1));
        lon  = squeeze(lon(:,:,1));
        
        if strcmp(gas,'O3')
        
                o3   = squeeze(o3(:,:,1));     o3 = o3(:);
                o3p  = squeeze(o3p(:,:,1));    o3p= o3p(:);
                o3g  = squeeze(o3g(:,:,1));    o3g=o3g(:);
                rms  = squeeze(rms(:,:,1));    rms=rms(:);
                
                % QA
                % ?
                param = o3(:);
        
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
           
           longrid    = lon(:); id = ~isnan(longrid);       longrid = longrid(id==1);
           latgrid    = lat(:); id = ~isnan(latgrid);       latgrid = latgrid(id==1);
           paramgrid  = param;  id = ~isnan(longrid);       paramgrid  = paramgrid(id==1);
           
           Fparam  = TriScatteredInterp(double(longrid),...
                                        double(latgrid),...
                                        double(paramgrid),'nearest');
           
           
           % evaluate at aircraft locations
           
           g.omi  = Fparam(   Lon,...
                              Lat);
                          
           % add additional parameters for NO2
           
           if strcmp(gas,'NO2')
               
               paramS  = paramS(id==1);
               paramT  = paramT(id==1);
               
               FparamS  = TriScatteredInterp(double(longrid),...
                                        double(latgrid),...
                                        double(paramS),'nearest');
               FparamT  = TriScatteredInterp(double(longrid),...
                                        double(latgrid),...
                                        double(paramT),'nearest');
                                    
               g.omino2S  = FparamS(   Lon,...
                                       Lat);
               g.omino2T  = FparamT(   Lon,...
                                       Lat);
               
           end
  
  return;
  
    
    
    
    