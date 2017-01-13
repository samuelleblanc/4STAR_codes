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

s.flight =[datenum(2016,6,08,23,17,47) datenum(2016,6,9,7,20,49)];  
%s.ground =[datenum('02:37:27') datenum('06:07:07')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
s.dirty = [datenum(2016,6,9,08,31,00) datenum(2016,6,9,08,32,30)];
s.clean = [datenum(2016,6,9,08,58,15) datenum(2016,6,9,09,00,00)];
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
s.flagfilename    = '20160608_starflag_man_created20160718_1706by_CF.mat';%'20160608_starflag_auto_created20160609_1302.mat';
% gases flags
s.flagfilenameCWV   = '20160608_starflag_CWV_man_created20170111_2339by_MS.mat';%'20160608_starflag_CWV_man_created20170110_0356by_MS.mat';
s.flagfilenameO3    = '20160608_starflag_O3_man_created20170110_0401by_MS.mat';
s.flagfilenameNO2   = '20160608_starflag_NO2_man_created20170110_0417by_MS.mat';
s.flagfilenameHCOH  = '20160608_starflag_HCOH_man_created20170110_0432by_MS.mat';
 
% Ozone and other gases 
s.O3h=21; 
s.O3col=0.360;    % Michal's guess based on forecast 
s.NO2col=3.0e16;  % Michal's guess; need to confirm. 
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013;
end; 
if isfield(s, 'Lon') & isfield(s, 'Lat'); 
    s.Lon(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lat(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lon(isnan(s.Lon))       =127.0264; % tweaks for Osan AFB
    s.Lat(s.Lat==0)           =37.0878;  % tweaks for Osan AFB 
    s.Alt(s.Alt==14)          =35.7;  % tweaks for Osan AFB
    s.Alt(s.Alt==0)           =35.7;  % tweaks for Osan AFB 
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

