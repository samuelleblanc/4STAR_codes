function starzen_to_netcdf(prefix, platform, HeaderInfo, specComments, NormalComments, revComments,daystr,rev,ncdir,starzen)

%ICARTTwriter(prefix, platform, HeaderInfo, specComments, NormalComments, revComments, daystr,Start_UTCs,data,info,form,rev,ICTdir)

%% Details of the program:
% NAME:
%   starzen_to_netcdf
%
% PURPOSE:
%  To generate archive files in the netcdf format for the starzen radiances 
%
% CALLING SEQUENCE:
%   starzen_to_netcdf(file_name_out,starzen)
%
% INPUT:
%  file_name_out: full path and file name of the netcdf file
%  starzen: full path of the starzen.mat file to save
%
% OUTPUT:
%  plots and ict file
%
% DEPENDENCIES:
%  - version_set.m
%  - t2utch.m
%  - ICARTTwriter.m
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined
%  - flagfile
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2019-09-30
% Modified
% -------------------------------------------------------------------------



end