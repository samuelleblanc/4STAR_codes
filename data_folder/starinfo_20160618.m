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

s.flight =[datenum(2016,6,18,17,00,00) datenum(2016,6,18,22,34,43)];  
%s.ground =[datenum('02:37:27') datenum('06:07:07')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
    
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
s.flagfilename    = '20160618_starflag_man_created20160711_1224by_KP_oldformat.mat';
s.flagfilenameO3  = '20160618_starflag_O3_man_created20160713_1346by_MS.mat';
s.flagfilenameCWV = '20160618_starflag_CWV_man_created20160713_1332by_MS.mat';
s.flagfilenameNO2 = '20160618_starflag_NO2_man_created20170611_1144by_MS.mat'
 
% Ozone and other gases 
s.O3h=21; 
%s.O3col=0.300;    % default 
%s.NO2col=2.0e15;  % default.
s.O3col=0.293;    % OMI O3 average along the track, Qin 
s.NO2col=3.16e15;  % OMI NO2 average along the track  
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013;
end; 
if isfield(s, 'Lon') & isfield(s, 'Lat'); 
    s.Lon(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lat(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lon(isnan(s.Lon))       =-118.08;  % tweaks for Palmdale
    s.Lat(s.Lat==0)           =36.61;    % tweaks for Palmdale 
    s.Alt(s.Alt==14)          =840;      % tweaks for Palmdale
    s.Alt(s.Alt==0)           =840;      % tweaks for Palmdale 
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

