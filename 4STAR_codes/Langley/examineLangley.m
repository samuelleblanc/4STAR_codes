% examine Langley
%----------------
% examine Langley for change in AOD
% during Flight (e.g. ARISE)
% can be used seperately or within Langley generation
% for inspection
%----------------------------------------
% MS, 2015-01-20, NASA Ames
%----------------------------------------
function examineLangley

% load *.starsun file
startup_plotting;
[matfolder, figurefolder, askforsourcefolder, author]=starpaths;
dirf = figurefolder;
dir  = matfolder;
% dirf = 'C:\MatlabCodes\figs\'; % directory for saving figures
% dir  = 'C:\MatlabCodes\data\'; % directory for saving output files
plotQA = false;
%%
% load input files
%********************
 dat = getfullname_('*starsun.mat','ARISE','Select starsun Langley file.');

[pname_, fname, ext] = fileparts(dat);
load(dat,'tau_aero','rateaero','m_aero','sza','Alt','Lat','Lon','t','Rh','AZ_deg','AZstep','Headng','sunaz');
daystr = strtok(fname,'s');
% plot diagnostics
%-----------------
savefigure = false;
% plot Lat/Lon with tau_aero
    figure;
    h2=scatter(Lon(~isnan(tau_aero(:,407))), Lat(~isnan(tau_aero(:,407))),6,tau_aero(~isnan(tau_aero(:,407)),407),'filled');
    colorbar;
    ch=colorbarlabeled('500 nm AOD');
    xlabel('Longitude','FontSize',14);
    ylabel('Latitude','FontSize',14);
    set(gca,'FontSize',14);
    caxis([0 0.025]);
    tgood = t(~isnan(tau_aero(:,407)));
    starttstr=datestr(tgood(1), 31);
    stoptstr =datestr(tgood(end), 13);
    grid on;
    title([starttstr ' - ' stoptstr,' ', 'Langley Flight']);
    if savefigure;
        starsas(['star' daystr 'latlonvtau_aero' '.fig, starLangley.m']);
    end;
% plot Lat/Alt with tau_aero
    figure;
    h2=scatter(Alt(~isnan(tau_aero(:,407))), Lat(~isnan(tau_aero(:,407))),6,tau_aero(~isnan(tau_aero(:,407)),407),'filled');
    colorbar;
    ch=colorbarlabeled('500 nm AOD');
    xlabel('Altitude','FontSize',14);
    ylabel('Latitude','FontSize',14);
    set(gca,'FontSize',14);
    caxis([0 0.025]);
    tgood = t(~isnan(tau_aero(:,407)));
    starttstr=datestr(tgood(1), 31);
    stoptstr =datestr(tgood(end), 13);
    grid on;
    title([starttstr ' - ' stoptstr,' ', 'Langley Flight']);
    if savefigure;
        starsas(['star' daystr 'latlonvtau_aero' '.fig, starLangley.m']);
    end;
    
% plot Lat/Lon with time
    t_hr = serial2Hh(t);
    t_cor = find(t_hr<22 & t_hr>0);
    t_hr(t_cor) = t_hr(t_cor) +24;
    figure;
    h2=scatter(Lon(~isnan(tau_aero(:,407))), Lat(~isnan(tau_aero(:,407))),6,t_hr(~isnan(tau_aero(:,407))),'filled');
    colorbar;
    ch=colorbarlabeled('time [hr]');
    xlabel('Longitude','FontSize',14);
    ylabel('Latitude','FontSize',14);
    set(gca,'FontSize',14);
    caxis([26 27]);
    %caxis([min(t_hr) max(t_hr)]);
    tgood = t(~isnan(tau_aero(:,407)));
    starttstr=datestr(tgood(1), 31);
    stoptstr =datestr(tgood(end), 13);
    grid on;
    title([starttstr ' - ' stoptstr,' ', 'Langley Flight']);
    if savefigure;
        starsas(['star' daystr 'latlonvtime' '.fig, starLangley.m']);
    end;
    
    % plot Lat/Lon with airmass
    figure;
    h2=scatter(Lon(~isnan(tau_aero(:,407))), Lat(~isnan(tau_aero(:,407))),6,m_aero(~isnan(tau_aero(:,407))),'filled');
    colorbar;
    ch=colorbarlabeled('airmass');
    xlabel('Longitude','FontSize',14);
    ylabel('Latitude','FontSize',14);
    set(gca,'FontSize',14);
    caxis([2 12]);
    %caxis([min(m_aero(~isnan(tau_aero(:,407)))) max(m_aero(~isnan(tau_aero(:,407))))]);
    tgood = t(~isnan(tau_aero(:,407)));
    starttstr=datestr(tgood(1), 31);
    stoptstr =datestr(tgood(end), 13);
    grid on;
    title([starttstr ' - ' stoptstr,' ', 'Langley Flight']);
    if savefigure;
        starsas(['star' daystr 'latlonvtime' '.fig, starLangley.m']);
    end;