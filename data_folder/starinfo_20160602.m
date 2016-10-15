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

s.flight =[datenum(2016,6,02,22,57,01) datenum(2016,6,3,7,15,24)];  
%s.ground =[datenum('02:37:27') datenum('06:07:07')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
%s.dirty = [datenum(2016,6,3,08,02,00) datenum(2016,6,3,08,04,00)];
%s.clean = [datenum(2016,6,3,08,05,30) datenum(2016,6,3,08,07,30)];
s.dirty = [datenum(2016,6,4,01,39,00) datenum(2016,6,4,01,41,00)];
s.clean = [datenum(2016,6,4,02,40,15) datenum(2016,6,4,02,42,30)];

% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
s.flagfilename    = '20160602_starflag_man_created20160718_1638by_CF.mat';%'20160602_starflag_auto_created20160714_1702.mat';
s.flagfilenameO3  = '20160602_starflag_O3_man_created20160701_1601by_MS.mat';
s.flagfilenameCWV = '20160602_starflag_CWV_man_created20160701_1549by_MS.mat';
 
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

