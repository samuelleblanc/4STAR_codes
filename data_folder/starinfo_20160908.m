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

s.flight=[datenum(2016,9,8,7,05,08) datenum(2016,9,8,15,01,20)]; 
s.high_alt_c0 = [datenum(2016,9,8,10,40,0) datenum(2016,9,8,10,50,0)];
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
s.langley=[[datenum(2016,9,08,7,32,30) datenum(2016,9,08,09,02,20)];...
           [datenum(2016,9,08,09,33,40) datenum(2016,9,08,10,53,20)]]; % first part ends on 9:02:20, second starts at 9:33:40
s.dirty = [datenum(2016,9,09,08,37,00) datenum(2016,9,09,08,39,00)];
s.clean = [datenum(2016,9,09,13,59,00) datenum(2016,9,09,14,02,00)];

s.flagfilename = '20160908_starflag_man_created20170628_2141by_SL.mat'; %'20160908_starflag_man_created20161028_1638_from_starinfo.mat'; 
s.flagfilenameCWV  = '20160908_starflag_CWV_man_created20161017_1454by_MS.mat';
s.flagfilenameO3   = '20160908_starflag_O3_man_created20161017_1455by_MS.mat';
s.flagfilenameNO2  = '20160908_starflag_NO2_man_created20161017_1457by_MS.mat';
s.flagfilenameHCOH = '20160906_starflag_HCOH_man_created20161017_1446by_MS.mat';
s.flagacaod = '20160908_flag_acaod_lebla_20201015_134028.mat'; %old/ R3 '20160908_flag_acaod_sleblanc_20180301_195548.mat';
 
% Ozone and other gases 
s.O3h=21; % 
s.O3col=0.280; %      
s.NO2col=2.0e15; %  
 
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

