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

 
s.flight=[datenum(2016,9,6,06,53,49) datenum(2016,9,6,14,39,19)]; 
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
% s.langley=[datenum(2016,8,25,17,00,00) datenum(2016,8,25,19,15,00)];
s.dirty = [datenum(2016,9,07,07,47,00) datenum(2016,9,07,08,21,00)];
s.clean = [datenum(2016,9,07,08,33,00) datenum(2016,9,07,08,37,00)];
 
% Ozone and other gases 
s.O3h=21; % 
s.O3col=0.300; % Michal's guess     
s.NO2col=2.0e15; % % 

% flags
s.flagfilename = '20160906_starflag_man_created20160907_0617by_MS.mat'; 
s.flagfilenameCWV  = '20160906_starflag_CWV_man_created20161017_1440by_MS.mat';
s.flagfilenameO3   = '20160906_starflag_O3_man_created20161017_1442by_MS.mat';
s.flagfilenameNO2  = '20160906_starflag_NO2_man_created20161017_1444by_MS.mat';
s.flagfilenameHCOH = '20160906_starflag_HCOH_man_created20161017_1446by_MS.mat';
%s.flagacaod = '20160906_flag_acaod_sleblanc_20180301_192422.mat'; % this one is the original with erroneous low alt flags
s.flagacaod = '20160906_flag_acaod_lebla_20201015_125037.mat';
 
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

