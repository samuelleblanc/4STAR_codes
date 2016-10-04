%% Details of the program:
% NAME:
%   small_sphere_cal
%
% PURPOSE:
%  Create the calibration for the small sphere
%
% CALLING SEQUENCE:
%   d=small_sphere_cal(daystr, dir, varargin)
%
% INPUT:
%  daystr: input day of calibration in form of a string (yyyymmdd), optional
%  dir: input of directory to se as base, optional
%  varargin:
%
% OUTPUT:
%  d: structure of variables with radiance, radiance std dev, wavelength,
%  response functions
%  - plot of calibrated spectrum of the sphere
%  - text file of calibrated values
%  - .mat file of the calibrated sphere of radiances and 4STAR response
%  - text file of response files
%
% DEPENDENCIES:
%  - save_fig.m (for saving the plots)
%  - startup_plotting.m (for making good looking plots)
%  - startupbusiness.m
%  - starwrapper.m
%  - version_set.m
%  - load_sphere_transfer.m : for choosing and loading the correct sphere transfer cal
%  - small_sphere_select.m : for selecting the right files for each day
%
% NEEDED FILES:
%  - small sphere park files
%  - radiance values of the small sphere
%
% EXAMPLE:
% -- Run the code from command line, for one day, default directory
% >> small_sphere_cal('20140926')
%   applytempcorr set to 0
%   verbose set to 0
%
%   infofile2 =
%
%   starinfo20140926
%
%   C:\Users\sleblan2\Research\4STAR\data\20141002_VIS_C0_refined_Langley_on_C-130_calib_flight_screened_2x_wFORJcorrAODscreened_wunc.dat
%
%   vv =
%
%   2014a
% * output of plots *
% --
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, August 1st, 2014
% Modified: by Samuel LeBlanc, August, 28th, 2014
%           - added a few commens
% Modified (v1.0): by Samuel LeBlanc, NASA Ames, October 10th, 2014
%           - Now handles files that measured background radiation, and
%           sustract the calibration with it.
%           - added version control of this script via version_set
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, October 14th, 2014
%           - handling of rate with radiances
%           - building of new response functions and saving of those files
%           in conjunction with load_sphere_transfer
%           - set flag for use of background data
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, Octoer, 17th, 2014
%           - added call to small_sphere_select, which selects which files
%           to use for every day of calibration, and the range of data
%           within that file via flt
%           - added variables to be used on command line call of daystr and
%           dir.
% Modified (v1.3): by Samuel LeBlanc, NASA Ames, 2014-11-12
%           - changed startup to startup_plotting
% Modified (v1.4): by Samuel LeBlanc, NASA Ames, 2015-04-03
%           - Added example in comments
%           - Changed units of plotting
% -------------------------------------------------------------------------

%% start of function
function d=small_sphere_cal(daystr, dir, varargin)
startup_plotting;
version_set('1.4')

if ~exist('daystr','var');
    daystr='20140804'; % set the default
end;
% setting the standard variables
if ~exist('dir','var'); dir='C:\Users\sleblan2\Research\4STAR\cal\'; end;
l=filesep;

%********************
%% regulate input and read source
%********************

[fnames,flt,fnamesbak,fltbak,isbackground]=small_sphere_select(daystr,dir);
[sourcefile, contents0, savematfile]=startupbusiness('park', fnames,['.' filesep 'tempmatdata.mat'],varargin{:});
load(sourcefile,contents0{:},'program_version');

%% add variables and make adjustments common among all data types. Also
% combine the two structures.
if exist('vis_park_v2'); % special case handling
    vis_park = vis_park_v2; nir_park = nir_park_v2;
end;
s=starwrapper(vis_park, nir_park,'applytempcorr',false,'verbose',false);
for i=1:length(s.t); s.rad(i,:)=s.rate(i,:)./s.skyresp; end;
note = s.note;

%% Get the filtered points and special case of either no filter set, or a filter set to -1 for choosing
if flt(1) == -999;
    flt = [1:length(s.t)];
elseif flt(1) == -1; % Choose the filter bounds
    figure;
    ax1 = subplot(3,1,1);
    plot(s.raw(:,400),'.');
    ylabel('Raw @ 500 nm');
    ax2 = subplot(3,1,2);
    plot(s.rate(:,400),'.');
    ylabel('Rate @ 500 nm');
    ax3 = subplot(3,1,3);    
    plot(s.Str,'.');
    ylabel('Shutter');
    linkaxes([ax1,ax2,ax3],'x');
    istart = input('Enter the starting point number:');
    iend = input('Enter the ending point number:');
    flt = [double(istart):double(iend)];
elseif flt(1) == -2; % Automatic determination of the filter bounds
    disp('Automatic dectection of the file indices from the save file')
    d = [0,s.Str'==2,0];
    startind = strfind(d,[0,1]);
    endind = strfind(d,[1,0])-1;
    flt = [startind(2):endind(2)];
    fltbak = [startind(3):endind(3)];
end;

%% build the mean and standard dev radiance values
rad=nanmean(s.rad(flt(s.sat_time(flt)==0 & s.raw(flt,500)>2000),:));
rad_std=nanstd(s.rad(flt(s.sat_time(flt)==0 & s.raw(flt,500)>2000),:));
nm=s.w*1000.0;

%% build the mean and standard dev rate values
rate=nanmean(s.rate(flt(s.sat_time(flt)==0 & s.raw(flt,500)>2000),:));
rate_std=nanstd(s.rate(flt(s.sat_time(flt)==0 & s.raw(flt,500)>2000),:));

%% Check if there is a background file
if isbackground
    disp('There is a background file')
    [sourcefile, contents0, savematfile]=startupbusiness('park',fnamesbak,['.' filesep 'tempmatdata.mat'], varargin{:});
    s2=load(sourcefile,contents0{:});
    
    % add variables and make adjustments common among all data types. Also
    % combine the two structures.
    sbak=starwrapper(s2.vis_park, s2.nir_park,'applytempcorr',false,'verbose',false);
    for i=1:length(sbak.t); sbak.rad(i,:)=sbak.rate(i,:)./sbak.skyresp; end;
    note = [note; {'*** Background file notes:'}; sbak.note];
    
    % build the mean and standard dev radiance values
    rad_back=nanmean(sbak.rad(fltbak(sbak.sat_time(fltbak)==0),:));
    rad_back_std=nanstd(sbak.rad(fltbak(sbak.sat_time(fltbak)==0),:));
    
    % build the mean and standard dev radiance values
    rate_back=nanmean(sbak.rate(fltbak(sbak.sat_time(fltbak)==0),:));
    rate_back_std=nanstd(sbak.rate(fltbak(sbak.sat_time(fltbak)==0),:));
    
    % remove the background radiation to the calibrated radiance
    rad=rad-rad_back;
    rate=rate-rate_back;
end;

%% plot the resulting radiances
figure(11);
datestr=s.filename{1}(end-24:end-17);
plot(nm,rad,'b-',...
    nm,rad+rad_std,'r.',...
    nm,rad-rad_std,'r.');
title(['Small Sphere radiances from:' datestr]);
xlabel('Wavelength [nm]');
ylabel('Radiance [W m^{-2} \mum^{-1} sr^{-1}]');
legend('Radiance','+std','-std');
fi=[dir datestr '_small_sphere_rad'];
ylim([0 150]);
xlim([300 1700]);
save_fig(11,fi,true);

%% write the radiances to file
units='[W/m^2.sr.um]';
header=['Wavelength [nm]' '   ' 'Radiances ' units '   ' 'standard deviation ' units];
fl=[fi '.dat'];
disp(['writing to ascii file: ' fl])
dlmwrite(fl,header,'delimiter','');
dat=[nm',rad',rad_std'];
dlmwrite(fl,dat,'-append','delimiter','\t','precision',7);

%% save to mat file
disp(['saving to mat file: ' fi])
save(fi, 'rad', 'rad_std', 'nm','program_version','isbackground','units','note');

disp('Display of notes:')
disp(note)
%% set output variables
d.rad=rad;
d.rad_std=rad_std;
d.nm=nm;
d.isbackground=isbackground;

%% output important information
visTint=unique(s.visTint(flt))
nirTint=unique(s.nirTint(flt))
[nul ind1]=min(abs(s.w-0.5));
[nul ind2]=min(abs(s.w-1.2));
disp(['visrate=' num2str(rate(ind1))])
disp(['nirrate=' num2str(rate(ind2))])
disp(['visratestd=' num2str(rate_std(ind1))])
disp(['nirratestd=' num2str(rate_std(ind2))])
for i=1:length(visTint)
    visraw=nanmean(s.raw(flt(s.visTint(flt)==visTint(i) & s.sat_time(flt)==0 & s.Str(flt)==2),ind1));
    disp(['visraw:' num2str(visraw) ' at visTint:' num2str(visTint(i))])
end;
for i=1:length(nirTint)
    nirraw=nanmean(s.raw(flt(s.nirTint(flt)==nirTint(i) & s.sat_time(flt)==0 & s.Str(flt)==2),ind2));
    disp(['nirraw:' num2str(nirraw) ' at nirTint:' num2str(nirTint(i))])
end;
disp(['num=' num2str(length(s.raw(flt,ind1)))])

%% write new response function?
writenew=menu('Do you want to write a new response function?','Yes','No');
if writenew==1;
    tra=load_sphere_transfer(s.t(1),dir);
    % build the response function
    resp=rate./tra.rad;
    resperr=rate_std./tra.rad;
    vis.resp=resp(1:1044);        nir.resp=resp(1045:end);
    vis.resperr=resperr(1:1044);  nir.resperr=resperr(1045:end);
    vis.nm=nm(1:1044);            nir.nm=nm(1045:end);
    vis.rate=rate(1:1044);        nir.rate=rate(1045:end);
    vis.rad=rad(1:1044);          nir.rad=rad(1045:end);
    vis.fname=s.filename{2};      nir.fname=s.filename{1};
    vis.time=s.t;                 nir.time=s.t;
    vis.fname = strrep(vis.fname,'NIR','VIS'); %assure the proper filename
    nir.fname = strrep(nir.fname,'VIS','NIR'); %assure the proper filename
    
    [vis.fresp,nir.fresp]=write_SkyResp_files_2(vis,nir,tra,dir);
    disp('Response function file written');
    save([fi '_responses'],'vis','nir','program_version','tra','note');
    d.resp=resp;
    d.vis=vis; d.nir=nir;
else;
    writenew==0;
end;

end
