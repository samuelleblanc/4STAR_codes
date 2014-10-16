%% Details of the program:
% NAME:
%   small_sphere_cal
% 
% PURPOSE:
%  Create the calibration for the small sphere
%
% CALLING SEQUENCE:
%   d=small_sphere_cal(varargin)
%
% INPUT:
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
%  - startup.m (for making good looking plots)
%  - startupbusiness.m
%  - starwrapper.m
%  - version_set.m
%  - load_sphere_transfer.m : for choosing and loading the correct sphere transfer cal
%
% NEEDED FILES:
%  - small sphere park files 
%  - radiance values of the small sphere
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
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, October 14th, 2014
%           - handling of rate with radiances
%           - building of new response functions and saving of those files 
%           in conjunction with load_sphere_transfer
%           - set flag for use of background data
%
% -------------------------------------------------------------------------

%% start of function
function d=small_sphere_cal(varargin)
startup;
version_set('1.1')

% setting the standard variables
dir='C:\Users\sleblan2\Research\4STAR\cal\';
l=filesep;

%********************
%% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('park', 'ask',['.' filesep 'tempmatdata.mat'],varargin{:});
load(sourcefile,contents0{:},'program_version');

%% add variables and make adjustments common among all data types. Also
% combine the two structures.
    s=starwrapper(vis_park, nir_park,'applytempcorr',false,'verbose',false);
    for i=1:length(s.t); s.rad(i,:)=s.rate(i,:)./s.skyresp; end;

%% build the mean and standard dev radiance values
rad=nanmean(s.rad(s.sat_time==0 & s.raw(:,500)>2000,:));
rad_std=nanstd(s.rad(s.sat_time==0 & s.raw(:,500)>2000,:));
nm=s.w*1000.0;

%% build the mean and standard dev rate values
rate=nanmean(s.rate);
rate_std=nanstd(s.rate);

%% Check if there is a background file
isbackground=menu('Is there a background radiation file?','Yes','No');
if isbackground == 1; 
    disp('There is a background file')
    [sourcefile, contents0, savematfile]=startupbusiness('park','ask',['.' filesep 'tempmatdata.mat'], varargin{:});
    s2=load(sourcefile,contents0{:});

    % add variables and make adjustments common among all data types. Also
    % combine the two structures.
    sbak=starwrapper(s2.vis_park, s2.nir_park,'applytempcorr',false,'verbose',false);
    for i=1:length(sbak.t); sbak.rad(i,:)=sbak.rate(i,:)./sbak.skyresp; end;

    % build the mean and standard dev radiance values
    rad_back=nanmean(sbak.rad(sbak.sat_time==0,:));
    rad_back_std=nanstd(sbak.rad(sbak.sat_time==0,:));
    
    % build the mean and standard dev radiance values
    rate_back=nanmean(sbak.rate(sbak.sat_time==0,:));
    rate_back_std=nanstd(sbak.rate(sbak.sat_time==0,:));
    
    % remove the background radiation to the calibrated radiance
    rad=rad-rad_back;
    rate=rate-rate_back;
else; 
    isbackground=0; 
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
units='[W/m^2.sr.um]';
header=['Wavelength [nm]' '   ' 'Radiances ' units '   ' 'standard deviation ' units];
fl=[fi '.dat'];
disp(['writing to ascii file: ' fl])
dlmwrite(fl,header,'delimiter','');
dat=[nm',rad',rad_std'];
dlmwrite(fl,dat,'-append','delimiter','\t','precision',7);

%% save to mat file
disp(['saving to mat file: ' fi])
save(fi, 'rad', 'rad_std', 'nm','program_version','isbackground','units');

%% set output variables
d.rad=rad;
d.rad_std=rad_std;
d.nm=nm;
d.isbackground=isbackground;

%% output important information
visTint=unique(s.visTint)
nirTint=unique(s.nirTint)
[nul ind1]=min(abs(s.w-0.5));
[nul ind2]=min(abs(s.w-1.2));
disp(['visrate=' num2str(rate(ind1))])
disp(['nirrate=' num2str(rate(ind2))])
disp(['visratestd=' num2str(rate_std(ind1))])
disp(['nirratestd=' num2str(rate_std(ind2))])
for i=1:length(visTint)
  visraw=nanmean(s.raw(s.visTint==visTint(i) & s.sat_time==0 & s.Str==2,ind1));
  disp(['visraw:' num2str(visraw) ' at visTint:' num2str(visTint(i))])
end;
for i=1:length(nirTint)
  nirraw=nanmean(s.raw(s.nirTint==nirTint(i) & s.sat_time==0 & s.Str==2,ind2));
  disp(['nirraw:' num2str(nirraw) ' at nirTint:' num2str(nirTint(i))])
end;
disp(['num=' num2str(length(s.raw(:,ind1)))])

%% write new response function?
writenew=menu('Do you want to write a new response function?','Yes','No');
if writenew==1;
    tra=load_sphere_transfer(s.t(1),dir);
    % build the response function
    resp=rate./tra.rad;
    resperr=rate_std./tra.rad;
    vis.resp=resp(513:end);        nir.resp=resp(1:512);
    vis.resperr=resperr(513:end);  nir.resperr=resperr(1:512);
    vis.nm=nm(513:end);            nir.nm=nm(1:512);
    vis.rate=rate(513:end);        nir.rate=rate(1:512);
    vis.rad=rad(513:end);          nir.rad=rad(1:512);
    vis.fname=s.filename{2};       nir.fname=s.filename{1};
    vis.time=s.t;                  nir.time=s.t;
    
    [vis.fresp,nir.fresp]=write_SkyResp_files_2(vis,nir,tra,dir);
    disp('Response function file written');
    save([fi '_responses'],'vis','nir','program_version','tra');
    d.resp=resp;
    d.vis=vis; d.nir=nir;
else;
    writenew==0;
end;

end
