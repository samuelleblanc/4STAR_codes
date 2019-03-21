function [xls_fname] = print_skyscan_details_to_xls(s,xls_fname)
%% Details of the program:
% PURPOSE:
%  To print the details of the skyscans to an excel spreadsheet
%
% INPUT:
%  filename of the starsky mat file
%
% OUTPUT:
%  xls spreadsheet
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - starskies.mat file
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, 2019-03-20
% -------------------------------------------------------------------------

version_set('v1.0')

if ~isfile(xls_fname)
    Title_line = {'Date','flight','filenumber','Start Time','End Time','Lat Start','Lat End','Lon Start','Lon End','Alt Start [m]','Alt End [m]','Skyscan type','Lowest Scat. angle [deg]','Highest Scat. angle [deg]','Notes'};
    xlswrite(xls_fname,Title_line,1,'A1');
end

[num,txt,raw] = xlsread(xls_fname);
g = size(raw);



try;
    line = {s.daystr,' ',s.filen,datestr(s.t(1),'HH:MM:SS'),datestr(s.t(end),'HH:MM:SS'),s.Lat(1),s.Lat(end),s.Lon(1),s.Lon(end),s.Alt(1),s.Alt(end),s.datatype,min(s.SA(s.good_sky)),max(s.SA(s.good_sky))};
    try;
        if contains(lastwarn,[s.daystr '_' s.filen '_'])
            ll = lasterror; 
            note = ll.message
        else
           note = ' '; 
        end
    catch;
        note = ' ';
    end;
    line{end+1} = note;
catch;
    line = {' ',' '};
end;
xlswrite(xls_fname,line,1,['A' num2str(g(1)+1)]);


return
