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

s.flight=[datenum(2016,5,6,22,59,19) datenum(2016,5,7,7,02,31)]; !!! to be updated 
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
s.dirty = [datenum(2016,5,7,7,33,00) datenum(2016,5,7,7,43,00)];
s.clean = [datenum(2016,5,7,8,02,30) datenum(2016,5,7,8,07,00)];
 
% Ozone and other gases 
s.O3h=21; % Yohei's guess 
s.O3col=0.300; % Yohei's guess     
s.NO2col=2.0e15; % Yohei's guess  

% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
s.flagfilename    = '20160506_starflag_man_created20160509_0102by_MS.mat';
% gases flags
s.flagfilenameCWV   = '20160504_starflag_CWV_man_created20170109_0416by_MS.mat';
s.flagfilenameO3    = '20160504_starflag_O3_man_created20170109_0418by_MS.mat';
s.flagfilenameNO2   = '20160504_starflag_NO2_man_created20170109_0422by_MS.mat';
s.flagfilenameHCOH  = '20160504_starflag_HCOH_man_created20170109_0428by_MS.mat';

 
 
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

