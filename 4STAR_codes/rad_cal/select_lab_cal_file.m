%% PURPOSE:
%   Return some details of the files used for radiance calibrations in the
%   lab
%
% CALLING SEQUENCE:
%   [date fnum pp] = select_lab_cal_file(date,ll)
%
% INPUT:
%   date: string of day to identify which lab cal is used in format yyyymmdd
%   ll: lamp number currently being investigated
%
% OUTPUT:
%   date: same as input, ** may be modified if explicitly indicated in file
%   fnum: file number for each lamp
%   pp: suffix of the file (park or track)
%
% DEPENDENCIES:
%   - version_set.m
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): by Samuel LeBlanc, NASA Ames, May 6th, 2015
%                 - ported over from Radiance_cals_4STAR.m
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, Nov. 10th, 2015
%                  - update to match the lab cals from 20150915 
% -------------------------------------------------------------------------

function [date fnum pp] = select_lab_cal_file(date,ll)
version_set('v1.1');
if date=='20131121' | date=='20131120'
    switch ll %% make sure that the file number is correctly set for each lamp setting, dependent on the day of calibration.
        case 12
            fnum = '009';
        case 9
            fnum = '010';
        case 6
            fnum = '011';
        case 3
            fnum = '012';
        case 2
            fnum = '013';
        case 1
            fnum = '014';
        case 0
            fnum = '015';
    end
    pp='park';
elseif date=='20130506' | date=='20130507'
    switch ll
        case 12
            fnum = '006';pp='park';date='20130506';
        case 9
            fnum = '007';pp='park';date='20130506';
        case 6
            fnum = '008';pp='park';date='20130506';
        case 3
            fnum = '001';pp='park';date='20130507';%pp='FORJ';
        case 2
            fnum = '002';pp='park';date='20130507';%pp='FORJ';
        case 1
            fnum = '003';pp='park';date='20130507';%pp='FORJ';
        case 0
            fnum = '004';pp='park';date='20130507';%pp='FORJ';
    end
elseif date=='20140624' | date=='20140625'
    switch ll
        case 12
            fnum = '010';
        case 9
            fnum = '011';
        case 8
            fnum = '012';
        case 6
            fnum = '013';
        case 3
            fnum = '014';
        case 2
            fnum = '015';
        case 1
            fnum = '016';
        case 0
            fnum = '017';
    end
    pp='park';
    if date=='20140625';
        warning('Date being modified to match files')
    end;
    date='20140624';
elseif date=='20140716' | date=='20140717'
    switch ll
        case 12
            fnum = '003';
        case 9
            fnum = '004';
        case 6
            fnum = '005';
        case 3
            fnum = '006';
        case 2
            fnum = '007';
        case 1
            fnum = '008';
        case 0
            fnum = '009';
    end
    pp='park';
    if date=='20140717';
        warning('Date being modified to match files')
    end;
    date='20140716';
elseif date=='20141024' | date=='20141025'
    switch ll
        case 12
            fnum = '005';
        case 9
            fnum = '009';
        case 6
            fnum = '010';
        case 3
            fnum = '011';
        case 2
            fnum = '012';
        case 1
            fnum = '013';
        case 0
            fnum = '014';
    end
    pp='park';
    if date=='20141025';
        warning('Date being modified to match files')
    end;
    date='20141024';
elseif date=='20150915' | date=='20150916'
    switch ll
        case 12
            fnum = '007';
        case 9
            fnum = '008';
        case 6
            fnum = '009';
        case 3
            fnum = '010';
        case 2
            fnum = '011';
        case 1
            fnum = '012';
        case 0
            fnum = '013';
    end
    pp='park';
    if date=='20150916';
        warning('Date being modified to match files')
    end;
    date='20150915';
    
else
    disp('problem! date not recongnised')
end

return