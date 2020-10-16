function [table_AOD,table_SZA,table_fracdiffuse]=readMODIS_MCD43_fracdiffuse_table
%% Details of the program:
% PURPOSE:
%  To read the fractional diffuse amount look up table for transfering the
%  BRDF parameters to an albedo (fraction of white sky vs. black sky)
%
% INPUT:
%  None
%
% OUTPUT:
%  table_AOD:
%  table_SZA:
%  table_fracdiffuse:
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - skyl_lut_bbshortwave.dat (in data_folder)
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, 2019-03-22
% -------------------------------------------------------------------------
version_set('v1.0')

fidrd = fopen(fullfile(getnamedpath('data_folder_github'),'skyl_lut_bbshortwave.dat'));
for i=1:2,
    linetext=fgetl(fidrd);
end
[A,count]=fscanf(fidrd,'%f',[51,inf]);
fclose(fidrd);
table_SZA=A(1,:);
table_fracdiffuse=A(2:51,:);
clear A
table_AOD=[0:0.02:0.98];
return