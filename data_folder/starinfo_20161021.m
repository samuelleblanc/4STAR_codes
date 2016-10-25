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
%s.flagfilename = '20160902_starflag_man_created20160904_1850by_SL.mat';
s.flagfilenameCWV  = '20161021_starflag_CWV_man_created20161024_1518by_MS.mat';
s.flagfilenameO3   = '20161021_starflag_O3_man_created20161024_1519by_MS.mat';
s.flagfilenameNO2  = '20161021_starflag_NO2_man_created20161024_1520by_MS.mat';
s.flagfilenameHCOH = '20161021_starflag_HCOH_man_created20161024_1522by_MS.mat';
 
s.ground=[datenum(2016,10,21,20,44,56) datenum(2016,10,22,00,14,34)]; 

 
% Ozone and other gases 
s.O3h=21; % 
s.O3col=0.270; % OMI    
s.NO2col=2.0e15; %   
 
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

