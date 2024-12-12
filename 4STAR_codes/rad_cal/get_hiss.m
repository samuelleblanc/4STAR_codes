%% PURPOSE:
%   Gets the calibrated radiance values for the HISS
%   The large integrating sphere with multiple number of lamps and lamp setting 
%   Found at NASA Ames Research Center, used for calibration of eMAS
%
% CALLING SEQUENCE:
%   [archi] = get_hiss(in)
%
% INPUT:
%   - in: input file name of HISS.txt calibrated radiance values
%         if omitted user input is required to find appropriate file 
% 
% OUTPUT:
%  - archi: structure of calibrated lamp radiances for each number of lamps
%  - plots of the calibrated radiance values for each lamp number and
%    settings
%
% DEPENDENCIES:
%  - version_set.m : for version control of this file
%
% NEEDED FILES:
%  - 20140606091700HISS.txt (or newer calibrated radiance file)
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: Connor Flynn, date unknown, PNNL
% Modified (v1.0): by Samuel LeBlanc, NASA Ames, Oct 13th, 2014
%          - ported to newest radiance calibration file
%          - added comments and version control
% Modified v1.1: by Samuel LeBlanc, NASA Ames, 2016-09-29
%          - added control over nuber of header lines for 2016 version.
% MOdified v1.2: by Samuel LeBlanc, NASA Ames, 2017-11-07
%          - added getnamedpath for easier locating of files
% Modified v1.3: by Samuel LeBlanc, NASA Ames, 2022-04-12
%          - changed special rules for file type 20170803
% Modified v1.4: by Samuel LeBlanc, Santa Cruz, 2024-06-20
%          - Added special rule for .csv file from Alok Shresta (for 2024-05-21)
% -------------------------------------------------------------------------

%% Start of function
function [archi] = get_hiss(in)
version_set('1.4');

% 4STAR radiance cal after TCAP2 and before SEAC4RS
% Source:    Hiss                                        (ARC High Output Sphere)                                                                           
% Date:      6/5/13                                                                                                                   
% Units:     Radiance in W/(m^2.sr.um)                                                  
% Inst:      OL 750                                                                                                                   
% Std:       20121203-h99056-lampcal.xlsx                                                                                                                   
% Tech:      Cooper                                                                                                                   
% Loc:       ARC                                                                                                                      
% Dist:      40.61                                                                                                                    
% Diam:      25.37                                                                                                                    
% Temp:                                                                                                                               
% RH:                                                                                                                                 
% Notes:                                                                                                                              
% Data:      Wavelength (nm), Radiance in W/(m^2.sr.um), % (k=2) uncertainty                                                                                                                 
%                                                                                                                                     
%            12 lamps   9 lamps    8 lamps    7 lamps    6 lamps    5 lamps    4  lamps   3 lamps    2 lamps    1 lamps    0.5 lamps  12 lamps uncertainty
% 300        11.46      7.95       6.84       5.70       4.57       3.43       2.33       1.24       0.84       0.48       0.27       6.04%

%%
if ~exist('in','var')
%    in = ['D:\case_studies\radiation_cals\spheres\HISS\20130605124300HISS.txt'];
    savePath = pwd;
    cd(getnamedpath('rad_cal_dir'));
   [fin nin]=uigetfile('*.txt; *.csv','Select a calibrated radiance file of Sphere');
   in=strcat(nin,fin);
   cd(savePath);
   %      in = getfullname(in,'radcals','Select a calibrated radiance file of Sphere');
else
    while ~exist(in,'file')
        in = getfullname(in,'radcals','Select a calibrated radiance file of Sphere');
    end
    
end
fid = fopen(in);
if fid>2
    
    [pname, fname, ext] = fileparts(in);
    fname = [fname, ext];
    date=fname(1:8);
    dd=str2num(date);
    hlines = 15;
    if dd==20160121.0 || dd==20170803.0
        hlines=16;
    end
    if dd<20140604.0
      %C = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f\n ','HeaderLines',15,'Delimiter','\n'); %%*[^\n]
      %C=textscan(fid,'%f %f %f %f %f %f %f %f %f %*[^\n]','HeaderLines',15);
      C=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]','HeaderLines',hlines);
      fclose(fid);
      archi.fname = fname;
      archi.nm = C{1};
      archi.lamps_12 = C{2};
      archi.lamps_9 = C{3};
      archi.lamps_8 = C{4};
      archi.lamps_7 = C{5};
      archi.lamps_6 = C{6};
      archi.lamps_5 = C{7};
      archi.lamps_4 = C{8};
      archi.lamps_3 = C{9};
      archi.lamps_2 = C{10};
      archi.lamps_1 = C{11};
      archi.lamps_p5 = C{12};
      archi.units = 'W/(m^2.sr.um)';
      archi.lamps_12_pct = C{9}./100;
      figure; plot(archi.nm, [archi.lamps_12,archi.lamps_9,archi.lamps_8,archi.lamps_7,archi.lamps_6,archi.lamps_5,...
        archi.lamps_4,archi.lamps_3,archi.lamps_2,archi.lamps_1,archi.lamps_p5],'-');
    legend('12 lamps','9 lamps','8 lamps','7 lamps','6 lamps','5 lamps','4 lamps','3 lamps','2 lamps','1 lamp','0.5 lamp');
    elseif dd>20170802.0 && dd<20240510.0
      C=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f','HeaderLines',hlines,'Delimiter','\n');
      fclose(fid);
      archi.fname = fname;
      archi.nm = C{1};
      archi.lamps_12 = C{2};       archi.lamps_9 = C{5};      archi.lamps_8 = C{6};
      archi.lamps_7 = C{7};      archi.lamps_6 = C{8};      archi.lamps_5 = C{9};
      archi.lamps_4 = C{10};      archi.lamps_3 = C{11};      archi.lamps_2 = C{12};
      archi.lamps_1 = C{13};      archi.lamps_p5 = C{14};
      archi.units = 'W/(m^2.sr.um)';
      %archi.lamps_12_pct = C{9}./100;
            figure; plot(archi.nm, [archi.lamps_12,archi.lamps_9,archi.lamps_8,archi.lamps_7,archi.lamps_6,archi.lamps_5,...
        archi.lamps_4,archi.lamps_3,archi.lamps_2,archi.lamps_1],'-');
    legend('12 lamps','9 lamps','8 lamps','7 lamps','6 lamps','5 lamps','4 lamps','3 lamps','2 lamps','1 lamp','0.5 lamp');
    elseif strcmp(ext,'.csv')
      C=textscan(fid,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f','HeaderLines',hlines,'Delimiter','\n');
      fclose(fid);
      archi.fname = fname;
      archi.nm = C{1};
      archi.lamps_12 = C{14};       archi.lamps_11 = C{13};      
      archi.lamps_10 = C{12};       archi.lamps_9 = C{11};      archi.lamps_8 = C{10};
      archi.lamps_7 = C{9};      archi.lamps_6 = C{8};      archi.lamps_5 = C{7};
      archi.lamps_4 = C{6};      archi.lamps_3 = C{5};      archi.lamps_2 = C{4};
      archi.lamps_1 = C{3};      archi.lamps_p5 = C{2};
      archi.units = 'W/(m^2.sr.um)';
      %archi.lamps_12_pct = C{9}./100;
            figure; plot(archi.nm, [archi.lamps_12,archi.lamps_11,archi.lamps_10,archi.lamps_9,archi.lamps_8,archi.lamps_7,archi.lamps_6,archi.lamps_5,...
        archi.lamps_4,archi.lamps_3,archi.lamps_2,archi.lamps_1],'-');
    legend('12 lamps','11 lamps','10 lamps','9 lamps','8 lamps','7 lamps','6 lamps','5 lamps','4 lamps','3 lamps','2 lamps','1 lamp','0.0 lamp');
    set(gca,'ColorOrder','factory')
    else
      C=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]','HeaderLines',hlines);
      fclose(fid);
      archi.fname = fname;
      archi.nm = C{1};
      archi.lamps_12 = C{2};
      archi.lamps_9 = C{5};
      archi.lamps_8 = C{6};
      archi.lamps_7 = C{7};
      archi.lamps_6 = C{8};
      archi.lamps_5 = C{9};
      archi.lamps_4 = C{10};
      archi.lamps_3 = C{11};
      archi.lamps_2 = C{12};
      archi.lamps_1 = C{13};
      %archi.lamps_p5 = C{12};
      archi.units = 'W/(m^2.sr.um)';
      %archi.lamps_12_pct = C{9}./100;
            figure; plot(archi.nm, [archi.lamps_12,archi.lamps_9,archi.lamps_8,archi.lamps_7,archi.lamps_6,archi.lamps_5,...
        archi.lamps_4,archi.lamps_3,archi.lamps_2,archi.lamps_1],'-');
    legend('12 lamps','9 lamps','8 lamps','7 lamps','6 lamps','5 lamps','4 lamps','3 lamps','2 lamps','1 lamp');
    end;


    title(['Calibrated radiances from ',fname],'interp','none');
    xlabel('wavelength [nm]');
    ylabel(archi.units,'interp','none');
    if ~exist([pname, filesep,fname, '.png'],'file')
        saveas(gcf,[pname, filesep,fname, '.png']);
    end
else
    archi = [];
end
return

%%