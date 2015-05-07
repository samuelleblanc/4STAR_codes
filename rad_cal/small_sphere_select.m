%% Details of the program:
% NAME:
%   small_sphere_select
% 
% PURPOSE:
%   Utility to select the appropriate files used in calibration with the
%   small integrating spehre (6in). To be used in conjonction with
%   small_sphere_cal.m
%
% CALLING SEQUENCE:
% [fnames,flt,fnamesbak,fltbak,isbackground]=small_sphere_select(daystr,dir)
%
% INPUT:
%  daystr: day string in the form of yyyymmdd
%  dir: directory of where to find calibration files
% 
% OUTPUT:
%  fnames: full file name path for the calibration file (VIS and NIR)
%  flt: filter of only correct selected times in file to use for calibration
%  fnamesbak: full file name path for the background radiation files (VIS and NIR)
%  fltbak: filter of only correct times of the background file
%  isbackground: boolean value indicating if there is a background file 
%
% DEPENDENCIES:
%  - version_set.m : for version control of this script
%  - getfullname_.m : for file path searching
%
% NEEDED FILES:
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, October 17th, 2014
% Modified (v1.1): Samuel LeBlanc, NASA Ames, January 9th, 2015
%                  - bug fix for no default flight date with background
% Modified (v1.2): Samuel LeBlanc, NASA Ames, May 6th, 2015
%                  - bug fix in getfullname_ to getfullname
%
% -------------------------------------------------------------------------

%% start of function
function [fnames,flt,fnamesbak,fltbak,isbackground]=small_sphere_select(daystr,dir)
version_set('1.2');

if ~exist('dir','var'); 
    dir=uigetfolder('','Select folder where calibrations are stored');
end;

switch daystr
    case '20140624'
        fnames={[dir filesep daystr filesep 'small_sphere' filesep daystr '_019_VIS_park.dat'];...
                [dir filesep daystr filesep 'small_sphere' filesep daystr '_019_NIR_park.dat']};
        flt=[12:124];
        isbackground=true;
        fnamesbak={[dir filesep daystr filesep 'Lamps_0' filesep daystr '_017_VIS_park.dat'];...
                   [dir filesep daystr filesep 'Lamps_0' filesep daystr '_017_NIR_park.dat']};
        fltbak=[1:35];
    case '20140716'
        fnames={[dir filesep daystr filesep 'small_sphere' filesep daystr '_010_VIS_park.dat'];...
                [dir filesep daystr filesep 'small_sphere' filesep daystr '_010_NIR_park.dat']};
        flt=[33:109];
        isbackground=true;
        fnamesbak={[dir filesep daystr filesep 'Lamps_0' filesep daystr '_009_VIS_park.dat'];...
                   [dir filesep daystr filesep 'Lamps_0' filesep daystr '_009_NIR_park.dat']};
        fltbak=[1:50];
    case '20140804'
        fnames={[dir filesep daystr filesep daystr '_003_VIS_park.dat'];...
                [dir filesep daystr filesep daystr '_003_NIR_park.dat']};
        flt=[66:378];
        isbackground=false;
        fnamesbak={[dir filesep daystr filesep 'small_sphere' filesep daystr '_010_VIS_park.dat'];...
                   [dir filesep daystr filesep 'small_sphere' filesep daystr '_010_NIR_park.dat']};
        fltbak=flt;
    case '20140825'
        fnames={[dir filesep daystr filesep 'raw' filesep daystr '_003_VIS_park.dat'];...
                [dir filesep daystr filesep 'raw' filesep daystr '_003_NIR_park.dat']};
        flt=[69:545];
        isbackground=false;
        fnamesbak={[dir filesep daystr filesep 'raw' filesep daystr '_003_VIS_park.dat'];...
                   [dir filesep daystr filesep 'raw' filesep daystr '_003_NIR_park.dat']};
        fltbak=flt;
    case '20140914'
        fnames={[dir filesep daystr filesep 'small_sphere' filesep daystr '_028_VIS_park.dat'];...
                [dir filesep daystr filesep 'small_sphere' filesep daystr '_028_NIR_park.dat']};
        flt=[72:144];
        isbackground=false;
        fnamesbak={[dir filesep daystr filesep 'small_sphere' filesep daystr '_028_VIS_park.dat'];...
                   [dir filesep daystr filesep 'small_sphere' filesep daystr '_028_NIR_park.dat']};
        fltbak=[[72:89],[182:185]];
    case '20140919'
        fnames={[dir filesep daystr filesep 'small_sphere' filesep '20140920_017_VIS_park.dat'];...
                [dir filesep daystr filesep 'small_sphere' filesep '20140920_017_NIR_park.dat']};
        flt=[1:213];
        isbackground=true;
        fnamesbak={[dir filesep daystr filesep 'background' filesep '20140920_018_VIS_park.dat'];...
                   [dir filesep daystr filesep 'background' filesep '20140920_018_NIR_park.dat']};
        fltbak=[1:47];
    case '20140926'
        fnames={[dir filesep daystr filesep 'small_sphere' filesep daystr '_004_VIS_park.dat'];...
                [dir filesep daystr filesep 'small_sphere' filesep daystr '_004_NIR_park.dat']};
        flt=[[1:61],[85:260]];
        isbackground=false;
        fnamesbak={[dir filesep daystr filesep 'background' filesep daystr '_005_VIS_park.dat'];...
                   [dir filesep daystr filesep 'background' filesep daystr '_005_NIR_park.dat']};
        fltbak=[1:20];
    case '20141024'
        fnames={[dir filesep daystr filesep 'small_sphere' filesep daystr '_016_VIS_park.dat'];...
                [dir filesep daystr filesep 'small_sphere' filesep daystr '_016_NIR_park.dat']};
        flt=[[17:48],[76:84],[93:101]];
        isbackground=true;
        fnamesbak={[dir filesep daystr filesep 'Lamps_0' filesep daystr '_014_VIS_park.dat'];...
                   [dir filesep daystr filesep 'Lamps_0' filesep daystr '_014_NIR_park.dat']};
        fltbak=[[6:13],[21:26]];
    otherwise
        warning('daystr not found in small_sphere_select, please manually select:');
        fnames=getfullname('*.dat','Select calibration files');
        flt=[-999];
        isbackground=menu('Is there a background radiation file?','Yes','No');
        if isbackground == 1; 
            fnamesbak=getfullname('*.dat','Select background files');
            fltbak=[1:10];
        else; 
            isbackground=0; 
            fnamesbak = '';
            fltbak = [];
        end;
end;
end