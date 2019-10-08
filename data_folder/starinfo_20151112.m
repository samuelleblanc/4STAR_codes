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

flight=[datenum('11:04:53') datenum('20:40')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
%!!! landing time to be updated. 
s.flight = flight; 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
 
% Ozone and other gases 
s.O3h=21; 
s.O3col=0.300;  % Yohei's guess, to be updated 
s.NO2col=5e15; % Yohei's guess, to be updated 
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013; 
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

