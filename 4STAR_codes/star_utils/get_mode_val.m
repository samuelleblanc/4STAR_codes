%% PURPOSE:
%   Generates the amount of minutes spanning the measurement period
%   loads one starmat file, and output all the times from the different
%   methods
%
% CALLING SEQUENCE:
%   [m,shut] = get_mode_val(fieldname)
%
% INPUT:
%  - fieldname: yyyymmdd used in starload
% 
% OUTPUT:
%  - m: mode value
%  - shut: predicted shutter value
%
% DEPENDENCIES:
%  version_set.m : to have version control of this m-script
%
% NEEDED FILES:
%  - None
%
% EXAMPLE:
%  ...
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2016-09-28
%
% -------------------------------------------------------------------------

%% Start of function
function [m,shut] = get_mode_val(fieldname);
version_set('v1.0')
% 0=park
% 1=sun tracking %%with quad
% 2=fovp?
% 3=fova?
% 4=skyp
% 5=skya
% 6=FORJ
% 7=cloud scan %%sun tracking without quad, either ephemeris toggle is set or can't get on sun
% 8=zenith
% 9=zenith i thought but now not so sure, maybe it is 8
% 10=cloud scan
if findstr(fieldname,'park')>=0;
    m = 0;
    shut = 1;
elseif findstr(fieldname,'skya')>=0;
    m = 5;
    shut = -1;%any
elseif findstr(fieldname,'skyp')>=0;
    m = 4;
    shut = -1;%any
elseif findstr(fieldname,'sun')>=0;
    m = 1;
    shut = 1;
elseif findstr(fieldname,'zen')>=0;
    m = 8;
    shut = 2;
elseif findstr(fieldname,'cldp')>=0;
    m = 7;
    shut = 2;
elseif findstr(fieldname,'forj')>=0;
    m = 6;
    shut = 2;
elseif findstr(fieldname,'fova')>=0;
    m = 3;
    shut = 2;
elseif findstr(fieldname,'fovp')>=0;
    m = 2;
    shut = 2;
end;
return;