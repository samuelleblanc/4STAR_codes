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

 s.flight=[datenum(2016,9,18,7,04,25) datenum(2016,9,18,15,03,30)]; 
 s.high_alt_c0 = [datenum(2016,9,18,8,23,0) datenum(2016,9,18,8,31,0)];

% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
 s.langley=[datenum(2016,9,18,7,20,20) datenum(2016,9,18,8,33,00)];
s.dirty = [datenum(2016,9,18,15,20,00) datenum(2016,9,18,15,23,30)];
s.clean = [datenum(2016,9,18,15,39,00) datenum(2016,9,18,15,42,20)];
 
% Ozone and other gases 
s.O3h=21; % 
s.O3col=0.300; % Michal's guess     
s.NO2col=2.0e15; % % 

% flags
s.flagfilename = '20160918_starflag_man_created20160920_1358by_SL.mat'; 
s.flagfilenameCWV  = '20160918_starflag_CWV_man_created20161017_2117by_MS.mat';
s.flagfilenameO3   = '20160918_starflag_O3_man_created20161017_2118by_MS.mat';
s.flagfilenameNO2  = '20160918_starflag_NO2_man_created20161017_2123by_MS.mat';
s.flagfilenameHCOH = '20160918_starflag_HCOH_man_created20161017_2125by_MS.mat';
s.flagacaod = '20160918_flag_acaod_sleblanc_20180302_141235.mat';

 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=680.25;  
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

