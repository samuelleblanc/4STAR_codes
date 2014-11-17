%% PURPOSE:
%   Analysis software for window cleaning effect
%
% CALLING SEQUENCE:
%   [sclean,sdirty]=stardirty(flightnum,stops)
%
% INPUT:
%   - flightnum -> flight number as a string, if omitted, interactive
%   method to select files
%   - stops -> if included stops the run before the end of the function
% 
% OUTPUT:
%  - sclean: variable structure for the clean window file
%  - sdirty: variable structure for the dirty window file
%  Plots of dirty and clean window differences
%
% DEPENDENCIES:
%  - startup.m (setup for nice figure plotting, can be safely omitted)
%  - allstarmat.m and the required dependencies
%  - starwrapper.m and required dependencies (updated to handle a single
%  structure, with command toggles)
%  - nanmean and nanstd
%  - save_fig.m (save figures in png and fig)
%  - t2utch.m  (to create decimal utc time from time array)
%  - starpaths.m (updated to sub select folder with respect to flight
%  number)
%  - version_set.m
%
% NEEDED FILES:
%  - dirty window .dat file
%  - clean window .dat file
%
% EXAMPLE:
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, C130, 43.16N 83.25W, Oct-4, 2014
% Modified: by Samuel LeBlanc, Oct-7, 2014
%           - changed the paths, and figures to automatically choose the
%           correct files
% Modified (v1.0): by Samuel LeBlanc, Oct-13, 2014
%           - added version control of this m script with version_set
% -------------------------------------------------------------------------

%% Start of function
function [savefile]=stardirty(flightnum,stops)
version_set('1.0');

%% first select the appropriate files
if nargin < 1;
    % only do the vis spectrometer
    [fdirty pdirty]=uigetfile('*VIS*.dat','Select dirty files');
    [fclean pclean]=uigetfile('*VIS*.dat','Select clean files');
    sdirty.fname=[pdirty fdirty];
    sclean.fname=[pclean fclean];
    dir=pdirty;
    du=strsplit(dir(1:end-1),'_');
    flightnum=du{end};
else;
    dd=starpaths(flightnum,'raw');
    df='C:\Users\sleblan2\Research\ARISE\c130\';
    
    switch flightnum
        case 'TR2'
            sdirty.fname=[dd '20140902_001_VIS_FORJ.dat'];
            sclean.fname=[dd '20140902_001_VIS_FORJ.dat'];
        case '01'
            sdirty.fname=[dd '20140905_005_VIS_FORJ.dat'];
            sclean.fname=[dd '20140905_006_VIS_FORJ.dat'];
        case '02'
            sdirty.fname=[dd '20140906_037_VIS_FORJ.dat'];
            sclean.fname=[dd '20140906_038_VIS_FORJ.dat'];
        case '03'
            sdirty.fname=[dd '20140907_007_VIS_FORJ.dat'];
            sclean.fname=[dd '20140907_008_VIS_FORJ.dat'];
        case '04'
            sdirty.fname=[dd '20140908_019_VIS_FORJ.dat'];
            sclean.fname=[dd '20140908_020_VIS_FORJ.dat'];
        case '06'
            sdirty.fname=[dd '20140911_007_VIS_FORJ.dat'];
            sclean.fname=[starpaths(num2str(str2num(flightnum)+1),'raw') '20140912_010_VIS_ZEN_mod.dat'];
        case '07'
            sdirty.fname=[dd '20140912_009_VIS_ZEN.dat'];
            sclean.fname=[dd '20140912_010_VIS_ZEN_mod.dat'];
        case '08'
            sdirty.fname=[dd '20140914_020_VIS_FORJ.dat'];
            sclean.fname=[dd '20140914_021_VIS_FORJ_mod.dat'];
        case '09'
            sdirty.fname=[dd '20140916_025_VIS_FORJ.dat'];
            sclean.fname=[starpaths(num2str(str2num(flightnum)+1),'raw') '20140916_028_VIS_FORJ.dat'];
        case '10'
            sdirty.fname=[starpaths(num2str(str2num(flightnum)+1),'raw') '20140917_022_VIS_FORJ.dat'];
            sclean.fname=[starpaths(num2str(str2num(flightnum)+1),'raw') '20140917_023_VIS_FORJ.dat'];
        case '11'
            sdirty.fname=[dd '20140918_001_VIS_park.dat'];
            sclean.fname=[dd '20140918_002_VIS_park.dat'];
        case '12'
            sdirty.fname=[dd '20140919_034_VIS_FORJ.dat'];
            sclean.fname=[dd '20140919_035_VIS_FORJ.dat'];   
        case '13'
            sdirty.fname=[dd '20140920_014_VIS_FORJ.dat'];
            sclean.fname=[starpaths(num2str(str2num(flightnum)+1),'raw') '20140921_001_VIS_FORJ.dat'];%'20140920_015_VIS_FORJ.dat'];            
        case '14'
            sdirty.fname=[dd '20140922_013_VIS_park.dat'];
            sclean.fname=[starpaths(num2str(str2num(flightnum)+1),'raw') '20140924_002_VIS_FORJ.dat'];
        case '15'
            sdirty.fname=[dd '20140925_007_VIS_FORJ.dat'];
            sclean.fname=[dd '20140925_008_VIS_FORJ.dat'];
        case '16'
            sdirty.fname=[dd '20141003_024_VIS_FORJ.dat'];
            sclean.fname=[dd '20141003_025_VIS_FORJ.dat'];
        case 'TR3'
            sdirty.fname=[dd '20141005_001_VIS_park.dat'];
            sclean.fname=[dd '20141005_002_VIS_park.dat'];
    end;
    dir=starpaths(flightnum);    
end;

%% now read the files
    tempdirtysavematfile=fullfile(starpaths, 'temporary_dirtybusiness.mat');
    [sourcefiled,contentsd]=allstarmat(sdirty.fname, tempdirtysavematfile);
    tempcleansavematfile=fullfile(starpaths, 'temporary_cleanbusiness.mat');
    [sourcefilec,contentsc]=allstarmat(sclean.fname, tempcleansavematfile);

    dn=strsplit(sdirty.fname,filesep);
    datestr=dn{end}(1:8);
    
    sd=load(tempdirtysavematfile);
    sc=load(tempcleansavematfile);
    sdirty=starwrapper(sd.(contentsd{1}),'applytempcorr',0);
    sclean=starwrapper(sc.(contentsc{1}),'applytempcorr',0);
    
%% calculate the mean and stddev of the rate for clean and dirty
sdirty.fl=find(sdirty.rate(:,500) > 25.5);
sclean.fl=find(sclean.rate(:,500) > 25.5);
if length(flightnum) ==2;
  if flightnum == '09';sclean.fl=find(sclean.rate(1:233,500) > 25.5);end;
  if flightnum == '04';sclean.fl=find(sclean.rate(1:44,500) > 25.5);end;
  if flightnum == '13';sclean.fl=find(sclean.rate(1:13,500) > 25.5);end;
else;
  if flightnum == 'TR2';
      sclean.fl=find(sclean.rate(1:700,500) > 25.5);
      sdirty.utc=t2utch(sdirty.t);
      sdirty.fl=find(sdirty.rate(:,500) > 25.5 & sdirty.AZstep==0 & sdirty.utc>15.0);
  end;
end;
sdirty.mean=nanmean(sdirty.rate(sdirty.fl,:));
sclean.mean=nanmean(sclean.rate(sclean.fl,:));
sdirty.stdev=nanstd(sdirty.rate(sdirty.fl,:));
sclean.stdev=nanstd(sclean.rate(sclean.fl,:));
  
  
%% Now plot the appropriate spectra
startup
figure(1);
ax1=subplot(2,1,1);
plot(sdirty.w,sdirty.mean,'r',sclean.w,sclean.mean,'b')
hold on;
plot(sdirty.w,sdirty.mean-sdirty.stdev,'r--',...
     sdirty.w,sdirty.mean+sdirty.stdev,'r.-',...
     sclean.w,sclean.mean-sclean.stdev,'b--',...
     sclean.w,sclean.mean+sclean.stdev,'b.-');
 hold off;
 legend('Dirty','Clean');
 title(['Dirty and clean average spectra and stddev for ' datestr]);
 ylabel('Rate [cts/ms]');
 xlabel('Wavelength [\mum]'); xlim([0.4,0.8]);
 grid on;
 
 
 ax2=subplot(2,1,2);
 plot(sdirty.w,sdirty.mean./sclean.mean,'r',sclean.w,sclean.mean./sclean.mean,'b')  
 hold on;
 plot(sdirty.w,(sdirty.mean-sdirty.stdev)./sclean.mean,'g.',...
     sdirty.w,(sdirty.mean+sdirty.stdev)./sclean.mean,'c.');
 hold off;
 legend('Dirty','Clean','Dirty - std','Dirty + std');
 title(['Normalized difference for flight #' flightnum]);
 ylabel('Normalized rate');
 ylim([0.96,1.04]);
 xlabel('Wavelength [\mum]'); xlim([0.4,0.8]);
 grid on;
 linkaxes([ax1,ax2],'x')
 save_fig(1,[dir 'ARISE_' flightnum '_dirty_clean_spc']);
  
 [nul,i]=min(abs(sdirty.w-0.44));
 disp(['Diff at 440 nm: ' num2str(sdirty.mean(i)./sclean.mean(i).*100.0-100.0)])
 disp(['Std Dev at 440 nm: ' num2str(sdirty.stdev(i)./sclean.mean(i).*100.0)]) 
 
 [nul,i]=min(abs(sdirty.w-0.65));
 disp(['Diff at 650 nm: ' num2str(sdirty.mean(i)./sclean.mean(i).*100.0-100.0)])
 disp(['Std Dev at 650 nm: ' num2str(sdirty.stdev(i)./sclean.mean(i).*100.0)])
 
 [nul,i]=min(abs(sdirty.w-0.75));
 disp(['Diff at 750 nm:' num2str(sdirty.mean(i)./sclean.mean(i).*100.0-100.0)])
 disp(['Std Dev at 750 nm: ' num2str(sdirty.stdev(i)./sclean.mean(i).*100.0)])
 
 if nargin > 1; stophere, end;
 savefile=[dir 'ARISE_' flightnum '_stardirty.mat'];
save(savefile,'sdirty','sclean','program_version');
return;
