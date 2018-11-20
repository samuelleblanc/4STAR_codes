function make_for_starflag(s, matname)
%% Program that loads a full starsun to create a much smaller file useful for flagging only
% contains a very limited set of aod values at some distinct wavelengths
% created: Samuel LeBlanc, 2016-09-19, v1.0, Santa Cruz, CA
% modified: SL, 2017-06-03, v1.1, MLO, Hawaii, added specific calls for 2STAR
% modified: SL, 2017-06-13, v1.2, NASA Ames, added another wavelength at
%           620 nm, and saving of notes nad wavelength indices
% modified: CJF, 2017-07-23, v1.3, Added output "g" permitting this to be
% called within starflag
% modified: CJF, 2017-07-23, v1.4, Modified to accept struct or file as input
version_set('v1.4')

% Simple program to load a starsun and save just a few values from it to a
% smaller file used for starflag.

if exist('s','var') && ~isstruct(s)
   matname = s;
   s = load(matname,'w','Alt','Lat','Lon','tau_aero_noscreening','m_aero','t','roll',...
      'rawrelstd','Md','Str','raw','dark','c0','darkstd','QdVlr','QdVtot','ng','program_version','sd_aero_crit','note');
   try;
      fs = load(matname,'flagsCWV','flagsO3','flagsNO2','flagsHCOH');
      s.flagsCWV = fs.flagsCWV; s.flagsO3 = fs.flagsO3; s.flagsNO2 = fs.flagsNO2; s.flagsHCOH = fs.flagsHCOH; 
      gas_note = ' ** created with gas flags';
      gases = true;
   catch;
      disp('gas flags not found')
      gas_note = ' ** does not contain gas flags';
      gases = false;
   end;
elseif exist('s','var') && isstruct(s)
   fld_in= fieldnames(s);
   fld_out = {'w','Alt','Lat','Lon','tau_aero_noscreening','m_aero','t',...
      'roll','rawrelstd','Md','Str','raw','dark','c0','darkstd','QdVlr',...
      'QdVtot','ng','program_version','sd_aero_crit','note'};
   for f = length(fld_in):-1:1
      if ~any(strcmp(fld_in{f},fld_out))
         s = rmfield(s,fld_in{f});
      end
   end
   if isfield(s, 'flagsCWV')
      gas_note = ' ** created with gas flags';
      gases = true;
   else
      gas_note = ' ** does not contain gas flags';
      gases = false;
   end
end

if ~isfield(s, 'falgsCWV');
    gas_note = ' ** does not contain gas flags';
    gases = false; 
end;

[daystr, filen, datatype, instrumentname]=starfilenames2daystr({matname});

% g.Alt = s.Alt; g.Lat=s.Lat; g.Lon=s.Lon; g.t = s.t;
% g.m_aero = s.m_aero; g.rawrelstd = s.rawrelstd; g.Md = s.Md; g.Str = s.Str;
% g.QdVlr = s.QdVlr; g.QdVtot = s.QdVtot; g.ng = s.ng; g.c0=s.c0;
% g.program_version = s.program_version; g.sd_aero_crit=s.sd_aero_crit;
% g.note = s.note;

nm_380 = interp1(s.w,[1:length(s.w)],.38, 'nearest');
nm_500 = interp1(s.w,[1:length(s.w)],.5, 'nearest');
nm_870 = interp1(s.w,[1:length(s.w)],.87, 'nearest');
nm_620 = interp1(s.w,[1:length(s.w)],.62, 'nearest');
nm_452 = interp1(s.w,[1:length(s.w)],.452, 'nearest');
nm_865 = interp1(s.w,[1:length(s.w)],.865, 'nearest');
nm_1040 = interp1(s.w,[1:length(s.w)],1.04, 'nearest');
nm_1215 = interp1(s.w,[1:length(s.w)],1.215, 'nearest');
s.i_wvsl = [nm_380;nm_452;nm_500;nm_620;nm_865;nm_1040;nm_1215];
colsang=[nm_452 nm_865];
s.ang_noscreening=sca2angstrom(s.tau_aero_noscreening(:,colsang), s.w(colsang));
s.aod_380nm = s.tau_aero_noscreening(:,nm_380);
s.aod_452nm = s.tau_aero_noscreening(:,nm_452);
s.aod_500nm = s.tau_aero_noscreening(:,nm_500);
s.aod_620nm = s.tau_aero_noscreening(:,nm_620);
s.aod_865nm = s.tau_aero_noscreening(:,nm_865);
s.aod_1040nm = s.tau_aero_noscreening(:,nm_1040);
try;
    s.aod_1215nm = s.tau_aero_noscreening(:,nm_1215);
    not_nm_1215 = false;
catch;
    disp('No NIR in starsun_for_starflag')
    not_nm_1215 = true;
end;

s.aod_500nm_max=3;
s.m_aero_max=15;

%calculate quantity [1-cos(roll angle)]
if ~strcmp(instrumentname,'2STAR');
s.roll_proxy=1-cos(s.roll*pi/180);
else;
    s.roll_proxy = s.Alt.*0.0;
end;

if not_nm_1215;
    s.raw = [s.raw(:,nm_380),s.raw(:,nm_452),s.raw(:,nm_500),s.raw(:,nm_620),s.raw(:,nm_865),s.raw(:,nm_1040)];
    s.dark = [s.dark(:,nm_380),s.dark(:,nm_452),s.dark(:,nm_500),s.dark(:,nm_620),s.dark(:,nm_8651),s.dark(:,nm_1040)];
    s.darkstd = [s.darkstd(:,nm_380),s.darkstd(:,nm_452),s.darkstd(:,nm_500),...
        s.darkstd(:,nm_620),s.darkstd(:,nm_865),s.darkstd(:,nm_1040)];
    s.nm_380 = 1;g.nm_452 = 2;g.nm_500 = 3;g.nm_620 = 4;g.nm_865 = 5;g.nm_1040 = 6;
else
    s.raw = [s.raw(:,nm_380),s.raw(:,nm_452),s.raw(:,nm_500),s.raw(:,nm_620),s.raw(:,nm_865),s.raw(:,nm_1040),s.raw(:,nm_1215)];
    s.dark = [s.dark(:,nm_380),s.dark(:,nm_452),s.dark(:,nm_500),s.dark(:,nm_620),s.dark(:,nm_865),s.dark(:,nm_1040),s.dark(:,nm_1215)];
    s.darkstd = [s.darkstd(:,nm_380),s.darkstd(:,nm_452),s.darkstd(:,nm_500),...
        s.darkstd(:,nm_620),s.darkstd(:,nm_865),s.darkstd(:,nm_1040),s.darkstd(:,nm_1215)];
    s.nm_380 = 1;s.nm_452 = 2;s.nm_500 = 3;s.nm_620=4;s.nm_865 = 5;s.nm_1040 = 6;s.nm_1215 = 7;
end;
s.save_for_starflag = true;

% if gases; 
%     g.flagsCWV = fs.flagsCWV; g.flagsO3 = fs.flagsO3; g.flagsNO2 = fs.flagsNO2; g.flagsHCOH = fs.flagsHCOH;
% end;

if ~exist('matname','var')
   matname = uiputfile('*.mat','Save mat for starflag');
end
matname = strrep(matname, '_for_starflag.mat','.mat');
f_out = strrep(matname,'.mat', '_for_starflag.mat');
disp(['creating file for smaller size flagging: ' f_out gas_note])
save([getnamedpath('starsun'),f_out],'-struct','s','-mat','-v7.3');
end