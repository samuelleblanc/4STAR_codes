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

% '09:30:25', '19:18:34'
s.flight=[datenum(2017,9,19,09,30,25) datenum(2017,9,19,19,18,34)]; 
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
 s.langley=[datenum(2017,9,19,9,49,00) datenum(2017,9,19,10,9,51);
            datenum(2017,9,19,10,17,31) datenum(2017,9,19,10,20,31);
            datenum(2017,9,19,10,31,26) datenum(2017,9,19,10,35,00)];
 s.sd_aero_crit=0.01;  %Connor asked to add this line on 8/2/2017
 
% Ozone and other gases 
s.O3h=21; % 
s.O3col=0.297; % % guess from OMI daily average over the region (35-55N, 35-55W), as estimated from Giovanni       
s.NO2col=3.4e15; % % % guess from OMI daily average over the region (35-55N, 35-55W), as estimated from Giovanni     

% flags
s.flagfilename = '20170919_starflag_man_created20180602_2253by_KP.mat'; 
%s.flagfilenameO3 = '20160530_starflag_O3_man_created20160701_1630by_MS.mat';
%s.flagfilenameCWV = '20160530_starflag_CWV_man_created20160701_1609by_MS.mat';

 
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

