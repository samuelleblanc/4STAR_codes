%% Details of the program:
% NAME:
%  starRespWrite
% 
% PURPOSE:
%  Create the reponse function of the sky barrel
%  Matches the count rates to the HISS (large integrating sphere)
%  calibrated radiances
%
% CALLING SEQUENCE:
%  [fnamevis fnamenir]=starRespWrite()
%
% INPUT:
%  - none at command line, uses interactive user input
% 
% OUTPUT:
%  fnamevis: file name and path for the vis response function file
%  fnamenir: file anem and path for the nir response function file
%  - plot of calibrated spectrum of the sphere
%  - plot of the response functions
%  - .mat file of response function
%  - .dat file of response function per spectrometer
%
% DEPENDENCIES:
%  - save_fig.m (for saving the plots)
%  - startup.m (for making good looking plots)
%  - startupbusiness.m
%  - starwrapper.m
%  - version_set.m
%  - get_hiss.m
%  - starpaths.m : for initial path to calibration files
%
% NEEDED FILES:
%  - 4STAR park files, while staring at the HISS
%  - radiance value files for HISS
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, October 15th, 2014
% Modified:
%
% -------------------------------------------------------------------------

%% start of function
function [fnamevis fnamenir]=starRespWrite()
startup;
version_set('1.0')

%% setting the standard variables
pname=uigetdir(starpaths,'Find folder for calibration files');
dir=pname;
l=filesep;

%% get hiss
fin='C:\Users\sleblan2\Research\4STAR\cal\spheres\HISS\20140606091700HISS.txt'; % default HISS file
hiss = get_hiss(fin);

%% setup the daystr from the directory
daystr=pname(end-7:end);
if daystr(1) ~= '2'; daystr=input('Problem with daystr, Please enter a new one:','s'); end;

%% get the background values
switch daystr
    case '20131121'
        bak.fnum='015'; bak.pp='park'; bak.date=daystr; isbackground=true;
    case '20130506'
        bak.fnum='004'; bak.pp='park'; bak.date='20130507'; isbackground=true;
    case '20140624'
        bak.fnum='017'; bak.pp='park'; bak.date=daystr; isbackground=true;
    case '20140716'
        bak.fnum='009'; bak.pp='park'; bak.date=daystr; isbackground=true;
    otherwise
        warning('Date not recognised, please update starRespWrite'); isbackground=false;
end;
if isbackground;
  bak.lamp_str=('Lamps_0');
  bak.nirname=[pname,filesep,bak.lamp_str,filesep,bak.date,'_',bak.fnum,'_NIR_',bak.pp,'.dat'];
  bak.visname=[pname,filesep,bak.lamp_str,filesep,bak.date,'_',bak.fnum,'_VIS_',bak.pp,'.dat'];
  % get the background data in .mat format
  bak.name=allstarmat({bak.visname;bak.nirname},['.' filesep 'tmpstardata.mat']);
  load(bak.name);
  % process the background data with starwrapper
  s.bak=starwrapper(nir_park,vis_park,'applytempcorr',false,'verbose',false);
  bak.rate=nanmean(s.bak.rate);
end;

%% Now loop through all the lamp values
lamps = [12,9,6,3,2,1]; k=0;

for ll = lamps  
    k = k+1;
    lampstr = ['Lamps_',sprintf('%d',ll)];
    % make sure that the file number is correctly set for each lamp setting, dependent on the day of calibration.
    date=daystr;
    if date=='20131121' | date=='20131120'
      switch ll 
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
      end
      pp='park';
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
      end
      pp='park';
      date='20140716';
    else
        warning('problem! date not recongnised')
    end    
    
    disp(strcat('Getting lamp #',num2str(ll)))
    nirname=[pname,filesep,lampstr,filesep,date,'_',fnum,'_NIR_',pp,'.dat'];
    visname=[pname,filesep,lampstr,filesep,date,'_',fnum,'_VIS_',pp,'.dat'];
    
    %% load the files via allstarmat then process it with starwrapper
    dname=allstarmat({nirname;visname},['.' filesep 'tmpstardat.mat']);
    tmp.(lampstr)=load(dname);
    s.(lampstr)=starwrapper(tmp.(lampstr).nir_park,tmp.(lampstr).vis_park,'applytempcorr',false,'verbose',false);    
    
    %% get the mean and standard deviation of the rate that is not saturated
    s.(lampstr).meanrate=nanmean(s.(lampstr).rate(s.(lampstr).sat_time==0,:));
    s.(lampstr).stdrate=nanstd(s.(lampstr).rate(s.(lampstr).sat_time==0,:));
    
    %% adjust the rate for the background radiation
    if isbackground;
        s.(lampstr).meanrate=s.(lampstr).meanrate-bak.rate;
    end;

    %% calculate the response function
    rad_w=interp1(hiss.nm,hiss.(lower(lampstr)),s.(lampstr).w*1000.0);
    s.(lampstr).resp=s.(lampstr).meanrate./rad_w;
    s.(lampstr).vis.resp=s.(lampstr).resp(513:end); s.(lampstr).vis.nm=s.(lampstr).w(513:end)*1000.0;
    s.(lampstr).nir.resp=s.(lampstr).resp(1:512);   s.(lampstr).nir.nm=s.(lampstr).w(1:512)*1000.0;
    
    if ~exist('vis','var');
      vis.resps=s.(lampstr).vis.resp;
      nir.resps=s.(lampstr).nir.resp;
      vis.lamps={lampstr};
    else;
      vis.resps=[vis.resps;s.(lampstr).vis.resp];
      nir.resps=[nir.resps;s.(lampstr).nir.resp];
      vis.lamps=[vis.lamps {lampstr}];
    end;
end;
%% build the mean and standard dev response values
vis.resp=nanmean(vis.resps);
nir.resp=nanmean(nir.resps([1,2,3],:));
vis.resperr=nanstd(vis.resps);
nir.resperr=nanstd(nir.resps([1,2,3],:));

vis.nm=s.(lampstr).vis.nm;
nir.nm=s.(lampstr).nir.nm;
vis.fname=visname;
nir.fname=nirname;
vis.time=s.(lampstr).t;
nir.time=s.(lampstr).t;
vis.rad=rad_w(513:end);
nir.rad=rad_w(1:512);
vis.rate=s.(lampstr).meanrate(513:end);
nir.rate=s.(lampstr).meanrate(1:512);

%% plot all the responses
figure(2);
ax1=subplot(2,1,1);
plot(ax1,vis.nm,vis.resps); hold on;
plot(ax1,vis.nm,vis.resp,'r.');
hold off;
xlabel(ax1,'Wavelength [nm]');
xlim([300,1000]);
ylabel(ax1,'Response [Cts/ms/W(m^2.sr.um)]');
legend(vis.lamps,'Mean');
%legend('eastoutside');
ax2=subplot(2,1,2);
plot(ax2,nir.nm,nir.resps); hold on;
plot(ax2,nir.nm,nir.resp,'r.');
hold off;
xlabel(ax2,'Wavelength [nm]');
xlim([940 1705]);

save_fig(2,[pname, 'responses']);

%% save the reponse functions
write_SkyResp_files_2(vis,nir,hiss,pname);
disp('file printed');

end