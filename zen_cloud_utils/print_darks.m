%% Details of the function:
% NAME:
%   print_darks
% 
% PURPOSE:
%   To print to file a subseries of darks taken from a specified flight.
%   Prints in ascii format, to be read by idl, uses the starsun.mat or the 
%   starzen.mat files
%
% CALLING SEQUENCE:
%  print_darks(filein,fileout)
%
% INPUT:
%  - filein: path of the starsun or starzen file to load - must have the
%            'dark' variable
%  - fileout: path of the ascii save file
% 
% OUTPUT:
%  - ascii file with first row indicating the wavelength. subsequent rows
%    show the dark count associated with that wavelength.
%
% DEPENDENCIES:
%  - starwavelength.m - to get the wavelengths of the vis and nir  
%
% NEEDED FILES:
%  - yyyymmddstarsun.mat or yyyymmddstarzen.mat files
%
% EXAMPLE:
%  >> print_darks(filein,fileout)
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, June 27th, 2014
%
% -------------------------------------------------------------------------

%% start function
function print_darks(filein,fileout)

nd=1000; % max number of darks wanted

%% load the file
load(filein,'dark','w','visTint','nirTint');
w=w.*1000;

%% make rate values for dark

for i=1:1556 
  if i<1044, tint=nirTint; else tint=visTint; end;
  dak(:,i)=dark(:,i)./tint;
end

%% Prepare new matrix with subset of darks
ld=length(dak(:,1))
if ld>nd
   xd=ceil(ld/nd);
   dk=dak(1:xd:ld,:);
else
   dk=dak; 
end



%% now start printing to file
dlmwrite(fileout,w,'delimiter','\t');
dlmwrite(fileout,dk,'delimiter','\t','-append');

return