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

 
s.flight=[datenum(2017,8,12,08,21,21) datenum(2017,8,12,16,33,39)]; 
%s.langley1 = [datenum(2017,6,8,15,35,00) datenum(2017,6,8,21,10,00)];
s.sd_aero_crit=0.01;  %Connor asked to add this line on 8/2/2017

% Ozone and other gases 
s.O3h=21; %  
s.O3col=0.278; % OMI overhead     
s.NO2col=2.0e15; %   

% flags
s.flagfilename  = '20170812_starflag_man_created20180419_1354by_SL.mat';% based on '20170812_starflag_man_created_20170813_0528by_CF.mat' but further flagged for a few missed points 
s.flagfilenameCWV  = '20170812_starflag_CWV_man_created20170906_1708by_MS.mat';
s.flagfilenameO3   = '20170812_starflag_O3_man_created20170906_1728by_MS.mat';
s.flagfilenameNO2  = '20170812_starflag_NO2_man_created20170906_1738by_MS.mat';
s.flagfilenameHCOH = '20170812_starflag_auto_created_for_HCOH_20170831_0859.mat';
s.flagacaod = '20170812_flag_acaod_sleblanc_20180416_161805.mat';

% Dirty flag file
s.AODuncert_mergemark_file = '20170812_AOD_merge_marks.mat';
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=682; % this is for Ames 
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

