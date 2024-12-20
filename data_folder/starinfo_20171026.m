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

 
s.ground=[datenum(2017,10,26,14,44,03) datenum(2017,10,26,23,48,03)]; 
%s.flight=[datenum(2017,10,26,14,44,03) datenum(2017,10,26,23,48,03)];
s.langley1 = [datenum(2017,10,26,14,50,00) datenum(2017,10,26,17,30,00)]; %approximately air mass 12-2 during this period...
 s.sd_aero_crit=0.01;  %Connor asked to add this line on 8/2/2017
% Ozone and other gases 
s.O3h=21; %  
s.O3col=0.253; % estimated average from OMI over northern CA, from Giovanni 
s.NO2col=4.4e15; % estimated average from OMI over northern CA, from Giovanni 
 
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

