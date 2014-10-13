%% Details of the program:
% NAME:
%   struct2netcdf
% 
% PURPOSE:
%   Saves the input structure to netcdf file
%   currently only applies to a single structure
%
% CALLING SEQUENCE:
%  s=struct3netcdf(s,filename)
%
% INPUT:
%  - s: the data structure to be saved (currently works on structure from a
%       starsun file
%  - filename: filename to be saved to
%
% OUTPUT:
%  - s: unmodified structure
%  - netcdf file with all data
%
% DEPENDENCIES:
%  version_set.m
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, August 19th, 2014 - Happy Birthday Mom!
% Modified (v1.0): By Samuel LeBlanc, NASA Ames, Oct-13th, 2014
%          - added version control of this m-script via version_set
% -------------------------------------------------------------------------

%% Start of code
function s=struct2netcdf(s,filename)
version_set('1.0');

if exist(filename,'file')
    disp('file already exists, will delete')
    delete(filename)
end;

disp(['writing netcdf file:' filename])
fields=fieldnames(s);

%operate through each field in the structure
for i=1:length(fields) 
    fs=char(fields(i));    
    %disp([' .. variable: ' fs])
    sz=size_string(s.(fs),fs);
    dtype=class(s.(fs));
    if strcmpi(dtype,'cell') ; disp(['stripping the the cell:' fs]),continue; end;
    if strcmpi(dtype,'logical') ;  
      nccreate(filename,fs,'Datatype','int8','Dimensions',sz,'Format','netcdf4');
      ncwrite(filename,fs,int8(s.(fs)));
    else
      nccreate(filename,fs,'Datatype',dtype,'Dimensions',sz);
      ncwrite(filename,fs,s.(fs));
    end    
end
disp('finished writing netcdf')
return
end


%% function to create the size string used in input of creating the nc variables
function sz=size_string(in,name)
n=size(in);
ns=max(size(n));

for i=1:ns
    sz{2.*i-1}=[name num2str(i)];
    sz{2.*i}=n(i);
end

return
end