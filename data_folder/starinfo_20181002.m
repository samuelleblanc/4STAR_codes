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

%s.langley1 = [datenum(2018,9,22,17,01,00) datenum(2018,9,22,19,10,00)]; %put in if condition below if different for different 4STARs
%            s.flight=[datenum(2017,8,31,07,59,14) datenum(2017,8,31,15,52,10)]; 
s.sd_aero_crit=0.01;  
s.dirty = [datenum(2018,10,02,16,8,29) datenum(2018,10,02,16,14,27)];
s.clean = [datenum(2018,10,02,16,16,43) datenum(2018,10,02,16,21,18)];

%Dirty window correction
s.AODuncert_mergemark_file = '20181002_AOD_merge_marks.mat';
             
% Ozone and other gases 
s.O3h=21; %  
s.O3col=0.275; %I think 270 DU was what  the dobson ozone was this morning?   
s.NO2col=2.0e15; %  

if isfield(s,'instrumentname')
    if(strcmp(s.instrumentname,'4STAR'))
                 s.flight=[datenum(2018,10,02,7,00,59) datenum(2018,10,02,15,17,41)];
                 
                 s.AODuncert_constant_extra = 0.04;
    %             flags
                 s.flagfilename     = '20181002_starflag_man_created20181004_1448by_SL.mat'; 
    %             s.flagfilenameCWV  = '20170831_starflag_CWV_man_created20170903_0109by_MS.mat';
    %             s.flagfilenameO3   = '20170831_starflag_O3_man_created20170903_0136by_MS.mat';
    %             s.flagfilenameNO2  = '20170831_starflag_NO2_man_created20170903_0147by_MS.mat';
    %             s.flagfilenameHCOH = '20170831_starflag_auto_created_for_HCOH_20170902_2338.mat';
    elseif(strcmp(s.instrumentname,'4STARB'))
    %             s.flight=[datenum(2017,8,31,07,59,14) datenum(2017,8,31,15,52,10)];
    %             % flags
    %             s.flagfilename     = '20170831_starflag_man_created20180512_1333by_KP.mat'; 
    %             s.flagfilenameCWV  = '20170831_starflag_CWV_man_created20170903_0109by_MS.mat';
    %             s.flagfilenameO3   = '20170831_starflag_O3_man_created20170903_0136by_MS.mat';
    %             s.flagfilenameNO2  = '20170831_starflag_NO2_man_created20170903_0147by_MS.mat';
    %             s.flagfilenameHCOH = '20170831_starflag_auto_created_for_HCOH_20170902_2338.mat';
    end
end
% window deposition
%s.AODuncert_constant_extra = 0.2;
  
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013.25; %WFF
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

