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

 
s.ground=[datenum(2018,02,9,16,23,46) datenum(2018,2,9,24,30,04)]; 
%s.langley1 = [datenum(2018,02,09,17,11,00) datenum(2018,02,09,20,30,00)];
s.langley1 = [datenum(2018,02,09,17,46,00) datenum(2018,02,09,20,30,00)]; % For short airmass factor range for short wvl
s.sd_aero_crit=0.01;  %Connor asked to add this line on 8/2/2017
s.xtra_langleyfilesuffix = '_MLOFeb2018_day5_shortwvl';

% Ozone and other gases 
s.O3h=21; %  
s.O3col=0.262; % MLO obs from dobson brewer
s.NO2col=2.0e15; %  
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=674.0; % this is for MLO 
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

