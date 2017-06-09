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

s.flight=[datenum(2016,5,3,23,03,08) datenum(2016,5,4,7,17,30)]; !!! to be updated 
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)];   
 
% Ozone and other gases 
s.O3h=21; % Yohei's guess 
% s.O3col=0.300;   % guess     
% s.NO2col=2.0e15; % guess  
s.O3col=0.359;    % OMI O3 average along the track, Qin
s.NO2col=2.96e15;  % OMI NO2 average along the track 

% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
s.flagfilename    = '20160503_starflag_man_created20160509_0026by_MS.mat';
% gases flags
s.flagfilenameCWV   = '20160503_starflag_CWV_man_created20170109_0312by_MS.mat';
s.flagfilenameO3    = '20160503_starflag_O3_man_created20170109_0314by_MS.mat';
s.flagfilenameNO2   = '20160503_starflag_NO2_man_created20170109_0317by_MS.mat';
s.flagfilenameHCOH  = '20160503_starflag_HCOH_man_created20170109_0322by_MS.mat';
 
% AOD uncertainty correction file from Sam 2017-02-01 
s.AODuncert_mergemark_file = '20160503_AOD_merge_marks.mat'; 


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

