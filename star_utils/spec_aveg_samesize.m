
function [starsun_out] = spec_aveg_samesize(starsun,tavg)
%----------------------------------------------------------
% this function averages .rate 4STAR spectra (normalized)
% for a defined period (10 sec, 3 sec etc.) and returns 
% averaged spectra plus its corresponding time and features
% this version keeps number of original rows unchanged
% good for starsun version combined vis_sun, nir_sun
%----------------------------------------------------------
% define NaN's for darks
% rate2=starsun.rate;
% rate2(starsun.Str~=1,:)=NaN;
% starsuns.normspc = rate2;
% for ii=1:size(starsun.rate,2)
%     starsuns.normspc(:,ii)=boxxfilt(starsun.t, rate2(:,ii), tavg/86400); 
% end

% You are right; replace == with ~=. rate2(starsun.Str~=1,:)=NaN;

%sza2=starsun.sza; sza2(Str==1,:)=NaN; starsuns.szas= boxxfilt(starsun.t, sza2, 10/86400);
% all data
        starsuns.normspc    = starsun.rate;                starsuns.normspc(starsun.Str~=1,:)   =NaN;
        starsuns.normspcpca = starsun.pcadata;             starsuns.normspcpca(starsun.Str~=1,:)=NaN;
        %starsuns.normspc   = starsun.rate_noFORJcorr;      starsuns.normspc(starsun.Str~=1,:)   =NaN;
        starsuns.ts         = starsun.t;                   %starsuns.ts(starsun.Str~=1)          =NaN;
        starsuns.szas       = starsun.sza;                 %starsuns.szas(starsun.Str~=1)        =NaN;
        starsuns.m_O3       = starsun.m_O3;                %starsuns.m_O3(starsun.Str~=1)        =NaN;
        starsuns.m_NO2      = starsun.m_NO2;               %starsuns.m_NO2(starsun.Str~=1)       =NaN;
        starsuns.m_H2O      = starsun.m_H2O;               %starsuns.m_H2O(starsun.Str~=1)       =NaN;
        starsuns.m_aero     = starsun.m_aero;              %starsuns.m_aero(starsun.Str~=1)      =NaN;
        starsuns.m_ray      = starsun.m_ray;               %starsuns.m_ray(starsun.Str~=1)       =NaN;
        starsuns.Lats       = starsun.Lat;                 %starsuns.Lats(starsun.Str~=1)        =NaN;
        starsuns.Lons       = starsun.Lon;                 %starsuns.Lons(starsun.Str~=1)        =NaN;
        starsuns.Alts       = starsun.Alt;                 %starsuns.Alts(starsun.Str~=1)        =NaN;
        starsuns.Press      = starsun.Pst;                 %starsuns.Press (starsun.Str~=1)      =NaN;
        starsuns.tau_aero   = starsun.tau_aero;            starsuns.tau_aero(starsun.Str~=1,:)  =NaN;
        starsuns.tau_ray    = starsun.tau_ray;             %starsuns.tau_ray(starsun.Str~=1,:)   =NaN;
        starsuns.dvlr       = starsun.QdVlr;               %starsuns.dvlr(starsun.Str~=1)        =NaN;
    
     
% convert serialtime to UT - already sorted
 [starsun.UTHh] = serial2Hh(starsun.t);

% averaging spectra
% set averaging every tavg seconds
    
 for kk=1:size(starsun.rate,2)
        %starsun.normspc(:,kk)     =boxxfilt(starsun.t, starsuns.normspc(:,kk), tavg/86400); 
        starsun.spc_avg(:,kk)      =boxxfilt(starsun.t, starsuns.normspc   (:,kk), tavg/86400); 
        starsun.spc_pca_avg(:,kk) = boxxfilt(starsun.t, starsuns.normspcpca(:,kk), tavg/86400); 
        starsun.tau_a_avg(:,kk)   = boxxfilt(starsun.t, starsuns.tau_aero  (:,kk), tavg/86400); 
        starsun.tau_ray_avg(:,kk) = boxxfilt(starsun.t, starsuns.tau_ray   (:,kk), tavg/86400);
 end
 
% calculate STD for spc_avg to filter later
% extend vector (beg and end)
spc_avg_         = [starsun.spc_avg(1,:); starsun.spc_avg; starsun.spc_avg(end,:)];
starsun.spc_std  = zeros(size(starsun.rate,1),size(starsun.rate,2));
    % "running" STD over tavg seconds
    ikk=0;
    for ik = 1:(length(spc_avg_)-2)
        starsun.spc_std(ik,:) = nanstd(spc_avg_(ik:tavg+ikk,:));
        ikk=ikk+1;
    end


% average over 1-D
        starsun.UTavg         = boxxfilt(starsun.t, starsun.UTHh       , tavg/86400); 
        starsun.tavg          = boxxfilt(starsun.t, starsuns.ts        , tavg/86400); 
        starsun.Latavg        = boxxfilt(starsun.t, starsuns.Lats      , tavg/86400); 
        starsun.Lonavg        = boxxfilt(starsun.t, starsuns.Lons      , tavg/86400); 
        starsun.Altavg        = boxxfilt(starsun.t, starsuns.Alts      , tavg/86400); 
        starsun.Presavg       = boxxfilt(starsun.t, starsuns.Press     , tavg/86400); 
        starsun.sza_avg       = boxxfilt(starsun.t, starsuns.szas      , tavg/86400); 
        starsun.m_O3_avg      = boxxfilt(starsun.t, starsuns.m_O3      , tavg/86400); 
        starsun.m_NO2_avg     = boxxfilt(starsun.t, starsuns.m_NO2     , tavg/86400); 
        starsun.m_H2O_avg     = boxxfilt(starsun.t, starsuns.m_H2O     , tavg/86400); 
        starsun.m_aero_avg    = boxxfilt(starsun.t, starsuns.m_aero    , tavg/86400); 
        starsun.m_ray_avg     = boxxfilt(starsun.t, starsuns.m_ray     , tavg/86400); 
        starsun.dvlr_avg      = boxxfilt(starsun.t, starsuns.dvlr      , tavg/86400); 
   
   
   
 % transfer averaged data into vis/nir structs
 starsun_out = starsun;

    
 return;
 