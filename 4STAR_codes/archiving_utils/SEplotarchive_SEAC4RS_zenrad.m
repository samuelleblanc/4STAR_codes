%% Details of the program:
% NAME:
%   SEplotarchive_SEAC4RS_zenrad
%
% PURPOSE:
%  To generate plots of zenith radiance spectra from archive files in ict
%  format
%
% CALLING SEQUENCE:
%   SEplotarchive_SEAC4RS_zenrad
%
% INPUT:
%  none
%
% OUTPUT:
%  plots 
%
% DEPENDENCIES:
%  - version_set.m
%  - startup_plotting
%  - ICARTTreader.m
%  - ...
%
% NEEDED FILES:
%  - list of completed ict archive files
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, March 19th, 2015
% Modified (v1.1): Samuel LeBlanc, Santa Cruz, CA, 2015-07-20
%                  - ported from ARISE to SEAC4RS, path changes
%
% -------------------------------------------------------------------------

function SEplotarchive_SEAC4RS_zenrad
version_set('v1.1')
startup_plotting;

%% prepare variables
ICTdir = 'C:\Users\sleblan2\Research\SEAC4RS\starzen_ict\';
prefix='SEAC4RS-4STAR-ZENRAD'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='0'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'DC8';

%% prepare list of details for each flight
dslist={'20130806' '20130808' '20130812' '20130814' '20130816' '20130819' '20130821' '20130823' '20130826' '20130827' ...
        '20130830' '20130902' '20130904' '20130906' '20130909' '20130911' '20130913' '20130916' '20130918' '20130921' '20130923'} ; %put one day string
%Values of jproc: 1=archive 0=do not archive
jproc=[         1          0          0          1          0          0          1          1          0          1  ...
                1          1          1          1          0          1          1          1          1          1          1 ] ; %set=1 to process

%% prepare pptx export
exportToPPTX('new', ...
    'Title','SEAC4RS_RAD_ZEN_archive', ...
    'Author','Samuel LeBlanc');
exportToPPTX('addslide');
exportToPPTX('addtext','SEAC4RS 4STAR Zenith Radiance archival','Position',[5-4,3.75-3,8,6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',36);
exportToPPTX('addtext',['by Samuel LeBlanc  ' date],'Position',[3.42,3.75-1,2.83,4],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',24);

%% run through each flight, load and process
idx_file_proc=find(jproc==1);
for i=idx_file_proc
    %% get the flight time period
    daystr=dslist{i};
    disp(['on day:' daystr])
    
    %% get the current ict file to load
    fl = ls([ICTdir prefix '_' platform '_' daystr '_R' rev '.ict']);
    if isempty(fl)
        filepath = getfullname([ICTdir '*' daystr '*.ict']);
    else
        filepath = [ICTdir fl];
    end
    
    %% Read the ict file
    data = ICARTTreader(filepath);
    names = fieldnames(data);
    
    %% Plot anciliary data
    figure(1); % added data
    set(gcf,'Position',[100,100,1200,800]);
    ax1 = subplot(4,1,1);
    plot(data.Start_UTC, data.Start_UTC/3600.,'k.'); hold on;
    plot(data.Start_UTC, data.UTC,'r.'); hold off;
    legend('Start UTC (converted from seconds)','Saved UTC','Location','SouthEast');
    set(gca, 'XTickLabel', [])
    set(ax1,'Position',[0.1,0.76,0.85,0.2]);
    grid;
    ylabel('UTC [Hours]')
    title(['Archived Extra variables in file:' fl],'interpreter','none')
    ax2 = subplot(4,1,2);
    plot(data.Start_UTC, data.GPS_Alt,'r.')
    set(gca, 'XTickLabel', [])
    set(ax2,'Position',[0.1,0.54,0.85,0.2]);
    grid;
    ylabel('Altitude [m]')
    ax3 = subplot(4,1,3);
    plot(data.Start_UTC, data.Latitude,'r.')
    set(gca, 'XTickLabel', [])
    set(ax3,'Position',[0.1,0.32,0.85,0.2]);
    grid;
    ylabel('Latitude [°]')
    ax4 = subplot(4,1,4);
    plot(data.Start_UTC, data.Longitude,'r.')
    set(ax4,'Position',[0.1,0.1,0.85,0.2]);
    grid;
    ylabel('Longitude [°]')
    
    xlabel('Start UTC [seconds]');

    linkaxes([ax1,ax2,ax3,ax4],'x');
    xlim([nanmin(data.Start_UTC),nanmax(data.Start_UTC)])

    figname = [ICTdir daystr '_UTC_alt_lat_lon'];
    save_fig(1,figname,false)
    set(gcf,'color','w');
    exportToPPTX('addslide');
    exportToPPTX('addtext',daystr,'Position',[0,0,10,4],'HorizontalAlignment','center');
    exportToPPTX('addpicture',1,'Scale','maxfixed');
    
    %% Plot radiances
    figure(2);
    set(gcf,'Position',[100,100,1200,700]);
    num = 23;
    set(0,'DefaultAxesColorOrder',jet(num))
    plot(data.UTC,data.RADMAX,'k.')
    [fpath fl] = fileparts(filepath);
    title(['Archived radiances in file:' fl],'interpreter','none')
    hold all;
    for i = 8:length(names)
       plot(data.UTC,data.(names{i}),'.')        
    end
    hold off;
    xr = [nanmin(data.Start_UTC/3600.0),nanmax(data.Start_UTC/3600.0)];
    if isfinite(xr(1));
        xlim(xr);
    end;
    xlabel('UTC [Hours]')
    ylabel('Radiances [Wm^{-2}sr^{-1}nm^{-1}]')
    legend(names{7:end},'Location','NorthEastOutside')
    grid;
    
    figname = [ICTdir daystr '_RAD_ict'];
    save_fig(2,figname,false)
    set(gcf,'color','w');
    exportToPPTX('addslide');
    exportToPPTX('addtext',daystr,'Position',[0,0,10,4],'HorizontalAlignment','center');
    exportToPPTX('addpicture',2,'Scale','maxfixed');
end

exportToPPTX('saveandclose',[ICTdir 'SEAC4RS_4STAR_ZENRAD_' datestr(now,'yyyymmdd')]);

end