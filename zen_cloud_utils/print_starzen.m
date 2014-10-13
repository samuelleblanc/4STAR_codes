%% Details of the function:
% NAME:
%   print_starzen
% 
% PURPOSE:
%   To print to file the zenith sky radiancestaken from a specified flight.
%   Prints in ascii format, to be read by idl, uses the starzen.mat files
%
% CALLING SEQUENCE:
%  print_starzen(filein,fileout)
%
% INPUT:
%  - filein: path of the starsun or starzen file to load - must have the
%            'zen' variable
%  - fileout: path of the ascii save file
% 
% OUTPUT:
%  - ascii file with first row indicating the wavelength. subsequent rows
%    show the radiancesassociated with that wavelength.
%
% DEPENDENCIES:
%  - starwavelength.m - to get the wavelengths of the vis and nir  
%
% NEEDED FILES:
%  - yyyymmddstarzen.mat files
%
% EXAMPLE:
%  >> print_starzen(filein,fileout)
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, July 2nd, 2014
%
% -------------------------------------------------------------------------

%% begin function
function print_starzen(filein,fileout)

%% load the file
load(filein,'rad','w','Alt','Lat','Lon','t');
w=w.*1000;

%% build the time series in utc format
ts=datevec(t);
doy=t-datenum([ts(1,1) 0 0 0 0 0]);
utc=(doy-floor(doy(1)))*24;

%% now start printing to file
fid=fopen(fileout,'w');
fmtstr=repmat('\t %f ',1,length(w));
fspec1=['%% UTC[h] \t Lat \t Lon \t Alt[m] ' fmtstr ' \n'];
fprintf(fid,fspec1,w);
fspec2=['%f \t %f \t %f \t %f ' fmtstr ' \n'];
for i=1:length(utc) 
   if any(~isnan(rad(i,:)))
       fprintf(fid,fspec2,utc(i),Lat(i),Lon(i),Alt(i),rad(i,:));
   end
end
fclose(fid);

return