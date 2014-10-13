%% Details of the program:
% NAME:
%   small_sphere_cal
% 
% PURPOSE:
%  Create the calibration for the small sphere
%
% CALLING SEQUENCE:
%   small_sphere_cal
%
% INPUT:
%  - none
% 
% OUTPUT:
%  - plot of calibrated spectrum of the sphere
%  - text file of calibrated values
%  - .mat file of the calibrated sphere 
%
% DEPENDENCIES:
%  - save_fig.m (for saving the plots)
%  - startup.m (for making good looking plots)
%  - startupbusiness.m
%  - starwrapper.m
%  - version_set.m
%
% NEEDED FILES:
%  - small sphere park files 
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, August 1st, 2014
% Modified: by Samuel LeBlanc, August, 28th, 2014
%           - added a few commens
% Modified (v1.0): by Samuel LeBlanc, NASA Ames, October 10th, 2014
%           - Now handles files that measured background radiation, and
%           sustract the calibration with it.
%           - added version control of this script via version_set
%
% -------------------------------------------------------------------------

%% start of function
function d=small_sphere_cal(varargin)
startup;
version_set('1.0')

% setting the standard variables
dir='C:\Users\sleblan2\Research\4STAR\cal\';
l='\';

%********************
%% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('park', varargin{:});
contents=[];
if isempty(contents0);
    savematfile=[];
    return;
end;
load(sourcefile,contents0{:});

%% add variables and make adjustments common among all data types. Also
% combine the two structures.
    s=starwrapper(vis_park, nir_park,'applytempcorr',false);
    for i=1:length(s.t); s.rad(i,:)=s.rate(i,:)./s.skyresp; end;

%% build the mean and standard dev radiance values
rad=nanmean(s.rad);
rad_std=nanstd(s.rad);
nm=s.w*1000.0;

%% Check if there is a background file
OK=menu('Is there a background radiation file?','Yes','No')
if OK == 1; 
    disp('There is a background file')
    [sourcefile, contents0, savematfile]=startupbusiness('park', varargin{:});
    contents=[];
    if isempty(contents0);
       savematfile=[];
       return;
    end;
    s2=load(sourcefile,contents0{:});

    % add variables and make adjustments common among all data types. Also
    % combine the two structures.
    sbak=starwrapper(s2.vis_park, s2.nir_park,'applytempcorr',false);
    for i=1:length(sbak.t); sbak.rad(i,:)=sbak.rate(i,:)./sbak.skyresp; end;

    % build the mean and standard dev radiance values
    rad_back=nanmean(sbak.rad);
    rad_back_std=nanstd(sbak.rad);
    
    % remove the background radiation to the calibrated radiance
    rad=rad-rad_back;
end;

%% plot the resulting radiances
figure(11);
datestr=s.filename{1}(end-24:end-17);
plot(nm,rad,'b-',...
     nm,rad+rad_std,'r.',...
     nm,rad-rad_std,'r.');
title(['Small Sphere radiances from:' datestr]);
xlabel('Wavelength [nm]');
ylabel('Radiance [W m^{-2} \mum^{-1} sr^{-1}');
legend('Radiance','+std','-std');
fi=[dir datestr '_small_sphere_rad'];
ylim([0 150]);
xlim([300 1700]);
save_fig(11,fi,true);

%% write the radiances to file
header=['Wavelength [nm]' '   ' 'Radiances [W/m^2.sr.um]' '   ' 'standard deviation [W/m^2.sr.um]'];
fl=[fi '.dat'];
disp(['writing to ascii file: ' fl])
dlmwrite(fl,header,'delimiter','');
dat=[nm',rad',rad_std'];
dlmwrite(fl,dat,'-append','delimiter','\t','precision',7);

%% save to mat file
disp(['saving to mat file: ' fi])
save(fi, 'rad', 'rad_std', 'nm','program_version');

d.rad=rad;
d.rad_std=rad_std;
d.nm=nm;

end
