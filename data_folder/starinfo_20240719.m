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
s.ground = [datenum(2024,07,19,22,56,40) datenum(2024,07,20,00,08,00)];
s.loose_aeronet_comparison = true;
%s.langley1 = [datenum(2024,07,19,22,56,40) datenum(2024,07,20,00,08,00)];
%s.langley2 = [datenum(2022,05,09,1,10,00) datenum(2022,05,09,2,40,0)];
%            s.flight=[datenum(2017,8,31,07,59,14) datenum(2017,8,31,15,52,10)]; 
s.aeronet_valid_time = [datenum(2024,7,19,23,13,30) datenum(2024,7,19,23,39,15)];
s.sd_aero_crit=0.01;  
% s.xtra_langleyfilesuffix = 'MLO_May2022_Day9';
             
% Ozone and other gases 
s.O3h=21; %  
s.O3col=0.342; %From SUOMI NPP / OMPS over Ames
Loschmidt= 2.686763e19; %molecules/cm2
s.NO2col=0.035464 % from AURA OMI in DU %7.134e-2*(Loschmidt/1000); %  5.883e-2 DU from Mauna Loa Pandora
% s.dirty = [datenum(2018,10,06,7,35,0) datenum(2018,10,06,7,45,0)];
% s.clean = [datenum(2018,10,06,7,50,49) datenum(2018,10,06,7,58,56)];
% s.ground = [datenum(2022,06,30,13,47,57) datenum(2022,06,30,17,26,28)];
%s.flight = [datenum(2020,07,08,11,00,00) datenum(2020,07,08,23,30,30)];
if isfield(s,'instrumentname')
    if(strcmp(s.instrumentname,'4STAR'))
%         s.t_hg_ar_lamp = [datenum(2022,5,7,19,20,30),datenum(2022,5,7,19,25,30)];
%         s.t_krypton_lamp = [datenum(2022,5,7,19,27,30),datenum(2022,5,7,19,28,45)];
%         s.HgAr_filen = 8;
%         s.Kr_filen = 9;
        
      %           s.ground=[datenum(2019,08,06,18,26,13) datenum(2019,08,06,23,36,30)];
                 
                 %s.AODuncert_constant_extra = 0.01;
    %             flags
         %        s.flagfilename     = '20181027_starflag_man_created20181128_1559by_SL.mat'; 
         %        s.flagacaod = '20181027_flag_acaod_sleblanc_20190509_181214.mat'; 
    %             s.flagfilenameCWV  = '20170831_starflag_CWV_man_created20170903_0109by_MS.mat';
    %             s.flagfilenameO3   = '20170831_starflag_O3_man_created20170903_0136by_MS.mat';
    %             s.flagfilenameNO2  = '20170831_starflag_NO2_man_created20170903_0147by_MS.mat';
    %             s.flagfilenameHCOH = '20170831_starflag_auto_created_for_HCOH_20170902_2338.mat';
    elseif(strcmp(s.instrumentname,'4STARB'))
%s.langley1 = [datenum(2024,07,11,12,32,15) datenum(2024,07,11,16,50,16)];
%                      [datenum(2024,07,10,13,33,00) datenum(2024,07,10,17,39,07)]];
%         s.t_hg_ar_lamp = [datenum(2022,5,7,19,58,30),datenum(2022,5,7,20,02,00)];
%         s.t_krypton_lamp = [datenum(2022,5,7,19,51,30),datenum(2022,5,7,19,55,00)];
%         s.HgAr_filen = 17;
%         s.Kr_filen = 15;
        
     %   s.ground = [datenum(2019,09,27,13,00,00) datenum(2019,09,27,17,13,30)];
     %   s.langley1 = [datenum(2019,09,27,13,30,30) datenum(2019,09,27,17,10,30)];
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
  
if isfield(s, 'Pst') 
    s.Pst(find(s.Pst<10))=1013; %Table Mountain Facility (JPL) pressure https://tmf.jpl.nasa.gov/tmf-weather/
end
% other tweaks 
if isfield(s, 'Lon') & isfield(s, 'Lat') 
    s.Lon(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lat(s.Lon==0 & s.Lat==0)=NaN; 
end 
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg') 
    s.AZ_deg=s.AZstep/(-50); 
end 
 
% notes 
if isfield(s, 'note') 
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']}; 
end 
%push variable to caller
% Bad coding practice to blind-push variables to the caller.  
% Creates potential for clobbering and makes collaborative coding more
% difficult because fields appear in caller memory space undeclared.
varNames=who();
for i=1:length(varNames)
    if ~strcmp(varNames{i},'s')
        assignin('caller',varNames{i},eval(varNames{i}));
    end
end
return
