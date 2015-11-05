function s = starinfo(s)
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t)
   daystr = datestr(s.t(1),'yyyymmdd');
else
   daystr=evalin('caller','daystr');
end

toggle = update_toggle;
if isfield(s, 'toggle')
   toggle = catstruct(s.toggle, toggle);
end
s.toggle = toggle;

% flight=[datenum('17:15:00') datenum('25:17')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight=[datenum('00:00:00') datenum('01:17')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
%  
% No good time periods ([start end]) and memo for all pixels 
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost. 
% daystr=mfilename; 
% daystr=daystr(end-7:end); 
% No good time periods ([start end]) for specific pixels 
s.ng=s.ng; 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
 
% Ozone and other gases 
s.O3h=21; 
s.O3col=0.287; 
s.NO2col=3e15; 
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013; 
end; 
if isfield(s, 'Lon') & isfield(s, 'Lat'); 
    ng=[find(s.Lon==0 & s.Lat==0); find(abs(s.Lon)>180); find(abs(s.Lat)>90)]; 
    s.Lon(ng)=NaN; 
    s.Lat(ng)=NaN; 
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

