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

 
s.flight=[datenum(2017,8,7,10,11,11) datenum(2017,8,7,19,56,07)]; 
s.langley = [datenum(2017,8,7,14,20,00) datenum(2017,8,7,19,14,00)];
s.sd_aero_crit=0.01;  %Connor asked to add this line on 8/2/2017
s.langley2 = [datenum(2017,8,7,17,36,20) datenum(2017,8,7,18,44,10)]; % subset of the langley for only the airmasses from 2 to 7 because of divergence of the shorter wavelengths at longer airmasses.
s.xtra_langleyfilesuffix = '_subset_'; 

% Ozone and other gases 
s.O3h=21; %  
s.O3col=0.278; % OMI overhead     
s.NO2col=2.0e15; %  

% flags
s.flagfilename     = '20170807_starflag_man_created_20170917_1502by_SL.mat'; 
s.flagfilenameCWV  = '20170807_starflag_CWV_man_created20170906_1622by_MS.mat';
s.flagfilenameO3   = '20170807_starflag_O3_man_created20170906_1629by_MS.mat';
s.flagfilenameNO2  = '20170807_starflag_NO2_man_created20170906_1633by_MS.mat';
s.flagfilenameHCOH = '20170807_starflag_auto_created_for_HCOH_20170831_0610.mat';
 
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013; % this is for Ames 
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
