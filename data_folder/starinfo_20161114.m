function s = starinfo(s)
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t)
   daystr = datestr(s.t(1),'yyyymmdd');
else
   daystr=evalin('caller','daystr');
end

if isfield(s, 'toggle')
    disp('it went to the first one')
    s.toggle = update_toggle(s.toggle);
else
    disp('it went to the second one')
    s.toggle = update_toggle;
end
disp(s.toggle)
s.langley=[datenum(2016,11,14,16,54,32) datenum(2016,11,14,19,17,40)];  %whole thing: datenum(2016,11,11,16,52,25) datenum(2016,11,11,22,05,00)
langley1=[datenum(2016,11,14,16,54,32) datenum(2016,11,14,19,17,40)];% langley1=[datenum(2016,9,10,05,20,00) datenum(2016,9,10,06,52,00)]; %full langley-- airmass ~15?

% Ozone and other gases 
s.O3h=21; % 
s.O3col=0.300; % Michal's guess     
s.NO2col=2.0e15; % % 
 
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