function s = starinfo(s)
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t)
   daystr = datestr(s.t(1),'yyyymmdd');
else
   daystr=evalin('caller','daystr');
end

if isfield(s, 'toggle')
    s.toggle = update_toggle(s.toggle);
else
    s.toggle = update_toggle;
end
% 22:52:02   07:00:16
s.flight=[datenum(2016,5,30,22,52,02) datenum(2016,5,31,07,00,16)];
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
s.dirty = [datenum(2016,5,31,07,46,45) datenum(2016,5,31,07,48,45)];
s.clean = [datenum(2016,5,31,08,10,30) datenum(2016,5,31,08,15,00)];

s.flagfilename = '20160530_starflag_man_created20160718_1149by_CF.mat';%20160530_starflag_auto_created20160714_1615.mat'; 
% gases flags
s.flagfilenameCWV   = '20160530_starflag_CWV_man_created20170111_2254by_MS.mat';%'20160530_starflag_CWV_man_created20170109_1112by_MS.mat';
s.flagfilenameO3    = '20160530_starflag_O3_man_created20170111_2301by_MS';%'20160530_starflag_O3_man_created20170109_1120by_MS.mat';
s.flagfilenameNO2   = '20160530_starflag_NO2_man_created20170111_2304by_MS.mat';%'20160530_starflag_NO2_man_created20170109_1123by_MS.mat';
s.flagfilenameHCOH  = '20160530_starflag_HCOH_man_created20170109_1132by_MS.mat';
 

% AOD uncertainty correction file from Connor 
s.AODuncert_mergemark_file = '20160530_AOD_merge_marks.mat';

% Ozone and other gases 
s.O3h=21; % Yohei's guess 
% s.O3col=0.300; % Yohei's guess     
% s.NO2col=2.0e15; % Yohei's guess  
s.O3col=0.330;    % default
s.NO2col=3e15;  % default
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013.25;  
end; 
if isfield(s, 'Lon') & isfield(s, 'Lat'); 
    s.Lon(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lat(s.Lon==0 & s.Lat==0)=NaN; 
end; 
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg'); 
    s.AZ_deg=s.AZstep/(-50); 
end; 
 
% notes 
if isfield(s, 'note'); 
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']}; 
end; 

%push variable to caller
% Bad coding practice to blind-push variables to the caller.  
% Creates potential for clobbering and makes collaborative coding more
% difficult because fields appear in caller memory space undeclared.

varNames=who();
for i=1:length(varNames)
    if ~strcmp(varNames{i},'s')
        assignin('caller',varNames{i},eval(varNames{i}));
    end
end;

return

