function [sdirty,sclean,sdiff]=stardirty(daystr,fname,ask_to_save_fig)
%% PURPOSE:
%   Analysis software for window cleaning effect
%
% CALLING SEQUENCE:
%   [sdirty,sclean,sdiff]=stardirty(daystr)
%
% INPUT:
%   - daystr: the string representing the utc day of the flight
%   - fname: the full path of the file to load containing the dirty and
%            clean measurements
%   - ask_to_save_fig: (optional, default to true) if set to false, then
%   will no ask to save the figure, and will just save
% 
% OUTPUT:
%  - sclean: variable structure for the clean window file
%  - sdirty: variable structure for the dirty window file
%  - sdiff: variable strcture with the differences before and after
%           window cleaning
%  Plots of dirty and clean window differences
%
% DEPENDENCIES:
%  - startup_plotting.m (setup for nice figure plotting, can be safely omitted)
%  - starwrapper.m and required dependencies (updated to handle a single
%  structure, with command toggles)
%  - nanmean and nanstd
%  - save_fig.m (save figures in png and fig)
%  - t2utch.m  (to create decimal utc time from time array)
%  - version_set.m
%
% NEEDED FILES:
%  - dirty and clean window .dat file or star.mat files
%  - starinfo function files
%
% EXAMPLE:
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2016-10-17
% Mdodifed (v1.1): Samuel LeBlanc, Santa Cruz, CA, 2016-10-18
%                   - added value on the plot. and ask to save fig keyword
% -------------------------------------------------------------------------

%% Start of function
version_set('1.1');

%% sanitize input
if ~exist('daystr','var') || isempty(daystr)
    % if not set, then ask the user to specify the starinfo file to get the
    % daystr    
    [f p]=uigetfile('starinfo_*.m','Select the starinfo file to use (also defines the day)');
    daystr = f(end-9:end-2)
end

if ~exist('ask_to_save_fig','var') || isempty(ask_to_save_fig)
    ask_to_save_fig = true;
end
%% Now load the starinfo 
infofile_ = ['starinfo_' daystr '.m'];
infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
s.dummy = '';
if ~exist(infofile_);
    error(['starinfo function file not found stopping... ' infofile_])
end;
try
    s = infofnt(s);
catch
    eval([infofile_(1:end-2),'(s)']);
end

%% get the relevant values in the starinfo
try
    sdirty.UTC = t2utch(s.dirty);
    sclean.UTC = t2utch(s.clean);
catch
    %edit(infofile_)
    error(['No dirty and clean values found in the starinfo file... please edit and rerun:' infofile_])
end

if ~isfield(s,'dirty_type')
    s.dirty_type = 'forj'
end;

sdirty.daystr = datestr(s.dirty(1),'yyyymmdd')
sclean.daystr = datestr(s.clean(1),'yyyymmdd')

%% now read the files
if ~exist('fname','var') || isempty(fname)
    % if not set, then ask the user to specify the starmat file to load
    [f p]=uigetfile('*star*.mat','Select the star.mat file to use that contains the dirty and clean measurements');
    fname = [p f]
else
    [p,n] = fileparts(fname); 
end
sdirty.fname = fname;
sclean.fname = fname;
sdirty.type = s.dirty_type;
sclean.type = s.dirty_type;

s1 = load(fname);
s1 = starwrapper(s1.(['vis_' s.dirty_type]),s1.(['nir_' s.dirty_type]),'verbose',false);
    
%% calculate the mean and stddev of the rate for clean and dirty
sdirty.fl = find(s1.t>=s.dirty(1) & s1.t<=s.dirty(2));
sclean.fl = find(s1.t>=s.clean(1) & s1.t<=s.clean(2));

sdirty.mean=nanmean(s1.rate(sdirty.fl,:));
sclean.mean=nanmean(s1.rate(sclean.fl,:));
sdirty.stdev=nanstd(s1.rate(sdirty.fl,:));
sclean.stdev=nanstd(s1.rate(sclean.fl,:));
  
%% Prepare the structures for saving
sdirty.w = s1.w; sclean.w = s1.w;
sdirty.t = s1.t(sdirty.fl); sclean.t = s1.t(sclean.fl); 
sdiff.w = s1.w;
sdiff.diff = sclean.mean-sdirty.mean;
sdiff.normdiff = sdiff.diff./sclean.mean*100.0;
sdiff.transmit = sdirty.mean./sclean.mean;
sdiff.daystr = daystr;

%% Now plot the appropriate spectra
startup_plotting
figure(1);
ax1=subplot(4,1,1);
plot(s1.w,sdirty.mean,'r',s1.w,sclean.mean,'b')
hold on;
plot(s1.w,sdirty.mean-sdirty.stdev,'r--',...
     s1.w,sdirty.mean+sdirty.stdev,'r.-',...
     s1.w,sclean.mean-sclean.stdev,'b--',...
     s1.w,sclean.mean+sclean.stdev,'b.-');
 hold off;
 legend('Dirty','Clean');
 title(['Dirty and clean average spectra and stddev for ' daystr]);
 ylabel('Rate [cts/ms]');
 %xlabel('Wavelength [\mum]'); 
 xlim([0.4,0.8]);
 grid on;
 
 axr=subplot(4,1,2);
 plot(s1.w,(sclean.mean-sdirty.mean),'r')  
 hold on;
 plot(s1.w,(sclean.mean-(sdirty.mean-sdirty.stdev)),'g.',...
      s1.w,(sclean.mean-(sdirty.mean+sdirty.stdev)),'c.');
 hold off;
 legend('Clean - Dirty','Dirty - std','Dirty + std');
 title(['Difference for flight on' daystr]);
 ylabel('Rate difference [cts/ms]');
 
 ax2=subplot(4,1,3);
 plot(s1.w,(sclean.mean-sdirty.mean)./sclean.mean*100.0,'r')  
 hold on;
 plot(s1.w,(sclean.mean-(sdirty.mean-sdirty.stdev))./sclean.mean*100.0,'g.',...
      s1.w,(sclean.mean-(sdirty.mean+sdirty.stdev))./sclean.mean*100.0,'c.');
 hold off;
 legend('Clean - Dirty','Dirty - std','Dirty + std');
 title(['Normalized difference for flight on ' daystr]);
 ylabel('Rate difference [%]');
 if sdiff.normdiff(600)>8.0;
     ylim([0,20]);
 else
     ylim([0,8]);
 end;
 grid on;
 
 ax4=subplot(4,1,4);
 plot(s1.w,sdirty.mean./sclean.mean,'r')  
 hold on;
 plot(s1.w,(sdirty.mean-sdirty.stdev)./sclean.mean,'g.',...
     s1.w,(sdirty.mean+sdirty.stdev)./sclean.mean,'c.');
 hold off;
 legend('Dirty','Dirty - std','Dirty + std');
 title(['Transmittance of dirt on window for flight on ' daystr]);
 ylabel('Transmittance');
 ylim([0.8,1]);

 xlabel('Wavelength [\mum]'); xlim([0.4,0.8]);
 grid on;
 linkaxes([ax1,axr,ax2,ax4],'x')
 save_fig(1,[p filesep daystr '_dirty_clean_spc'],ask_to_save_fig);
  
 [nul,i]=min(abs(s1.w-0.44));
 disp(['Diff at 440 nm: ' num2str((sdirty.mean(i)-sclean.mean(i))./sclean.mean(i).*100.0)])
 disp(['Std Dev at 440 nm: ' num2str(sdirty.stdev(i)./sclean.mean(i).*100.0)]) 
 
 [nul,i]=min(abs(s1.w-0.65));
 disp(['Diff at 650 nm: ' num2str((sdirty.mean(i)-sclean.mean(i))./sclean.mean(i).*100.0)])
 disp(['Std Dev at 650 nm: ' num2str(sdirty.stdev(i)./sclean.mean(i).*100.0)])
 
 [nul,i]=min(abs(s1.w-0.75));
 disp(['Diff at 750 nm:' num2str((sdirty.mean(i)-sclean.mean(i))./sclean.mean(i).*100.0)])
 disp(['Std Dev at 750 nm: ' num2str(sdirty.stdev(i)./sclean.mean(i).*100.0)])
 
% if nargin > 1; stophere, end;
% savefile=[dir 'ARISE_' flightnum '_stardirty.mat'];
%save(savefile,'sdirty','sclean','program_version');
return;
