function [out] = rd_nc(file_name)
% function to read a netcdf file and output a structure with the variables 
% of the netcdf 
% simple read that outputs all variables in the file

% written: SL, 2017/04/04

version_set('v1.0')

a = ncinfo(file_name);
name = {''};
for i=1:length(a.Variables);
    name(i) = cellstr(a.Variables(i).Name);
    out.(legalize_fieldname(char(name(i)))) = ncread(file_name,char(name(i)));
end;

