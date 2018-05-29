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

s.flight=[datenum(2018,05,15,15,11,00) datenum(2018,5,15,00,27,00)]; 
%s.langley1 = [datenum(2018,02,15,17,11,00) datenum(2018,02,15,20,15,00)];
s.sd_aero_crit=0.01;  %Connor asked to add this line on 8/2/2017
%s.xtra_langleyfilesuffix = '_MLOFeb2018_day11';
%s.calreflector_time = [datenum(2018,2,10,20,37,0),datenum(2018,2,10,21,30,0)];

% Ozone and other gases 
s.O3h=21; %  
s.O3col=0.261; % MLO obs from dobson brewer
s.NO2col=2.0e15; %  
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013.0; % this is measured at MLO
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

