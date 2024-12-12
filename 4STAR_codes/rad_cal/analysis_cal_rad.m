%% PURPOSE:
%   Analyze the results of radiance calibration of the sky barrel
%   Present a small analysis of nonlinearity and then save the response to
%   an ascii file for use with starzen
%
% CALLING SEQUENCE:
%   rad_cal=analysis_cal_rad
%
% INPUT:
%   - none at command line, interactive file selection
% 
% OUTPUT:
%  - plots of nonlinear analysis
%  - plots of response function fo every lamp number and settings
%  - response function in ascii format of selected times
%
% DEPENDENCIES:
%  - startup_plotting.m
%  - save_fig.m
%  - version_set.m
%  - write_SkyResp_files_2.m
%  - plot_SKYresp.m
%
% NEEDED FILES:
%  - radiance calibration file in .mat format
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, date unknown, 2014
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, 2014-11-12
%                  - modidifed startup to startup_plotting
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, 2015-03-16
%                  - changed the specific response function to write out
%                  - added some comments
% Modified (v1.3): by Samuel LeBlanc, NASA Ames, 2015-04-03
%                  - Slight modifications for testing out responses with 12
%                  pre and post ARISE (20140716 and 20141026)
%
% -------------------------------------------------------------------------

%% Start of function
function rad_cal=analysis_cal_rad
startup_plotting
version_set('1.3');
instrumentname = '4STAR';

%get response function calibration file
[file pname fi]=uigetfile2('*.mat','Find calibration files .mat');
%file='rad_cal.mat'
%pname='C:\Users\Samuel\Research\4STAR\cal\20131120\2013_11_20.4STAR.NASA_Ames.Flynn\'
%date='20131120'
%date='20130506';
%date='20140624';
%date='20140716';
%date='20141024';
%date = '20150915';
date = '20160330';
date = '20170620';
date = '20171102';
date = '20240521'

disp(['Loading the matlab file: ' pname file])
disp(['for Date: ' date])
load([pname file]);


%% Check the linearity of the radiance calibrations with number of lamps
%Build appropriate vectors

if isfield(cal,'Lamps_3');
    vis_resp_lamps=[cal.Lamps_12.vis.mean_resp;cal.Lamps_9.vis.mean_resp;...
        cal.Lamps_6.vis.mean_resp;cal.Lamps_3.vis.mean_resp;...
        cal.Lamps_2.vis.mean_resp;cal.Lamps_1.vis.mean_resp];
    
    vis_std_lamps=[cal.Lamps_12.vis.std_resp;cal.Lamps_9.vis.std_resp;...
        cal.Lamps_6.vis.std_resp;cal.Lamps_3.vis.std_resp;...
        cal.Lamps_2.vis.std_resp;cal.Lamps_1.vis.std_resp];
    
    nir_resp_lamps=[cal.Lamps_12.nir.mean_resp;cal.Lamps_9.nir.mean_resp;...
        cal.Lamps_6.nir.mean_resp;cal.Lamps_3.nir.mean_resp;...
        cal.Lamps_2.nir.mean_resp;cal.Lamps_1.nir.mean_resp];
    
    nir_std_lamps=[cal.Lamps_12.nir.std_resp;cal.Lamps_9.nir.std_resp;...
        cal.Lamps_6.nir.std_resp;cal.Lamps_3.nir.std_resp;...
        cal.Lamps_2.nir.std_resp;cal.Lamps_1.nir.std_resp];
    
    rad_nir=[cal.Lamps_12.nir.rad;...
        cal.Lamps_9.nir.rad;...
        cal.Lamps_6.nir.rad;...
        cal.Lamps_3.nir.rad;...
        cal.Lamps_2.nir.rad;...
        cal.Lamps_1.nir.rad];
    
    rad_vis=[cal.Lamps_12.vis.rad;...
        cal.Lamps_9.vis.rad;...
        cal.Lamps_6.vis.rad;...
        cal.Lamps_3.vis.rad;...
        cal.Lamps_2.vis.rad;...
        cal.Lamps_1.vis.rad];
    sublamps = false;
else;
    vis_resp_lamps=[cal.Lamps_12.vis.mean_resp;cal.Lamps_9.vis.mean_resp;...
        cal.Lamps_6.vis.mean_resp];
    vis_std_lamps=[cal.Lamps_12.vis.std_resp;cal.Lamps_9.vis.std_resp;...
        cal.Lamps_6.vis.std_resp];
    nir_resp_lamps=[cal.Lamps_12.nir.mean_resp;cal.Lamps_9.nir.mean_resp;...
        cal.Lamps_6.nir.mean_resp];
    nir_std_lamps=[cal.Lamps_12.nir.std_resp;cal.Lamps_9.nir.std_resp;...
        cal.Lamps_6.nir.std_resp];
    
    rad_nir=[cal.Lamps_12.nir.rad;...
        cal.Lamps_9.nir.rad;...
        cal.Lamps_6.nir.rad];
    
    rad_vis=[cal.Lamps_12.vis.rad;...
        cal.Lamps_9.vis.rad;...
        cal.Lamps_6.vis.rad];
    sublamps = true;
end;
%% plotting out the results
figure(1);
%colormap jet(1044);
k=semilogx(rad_vis(:,1),vis_resp_lamps(:,1),'-');
hold('on');
cl=jet(1044);
%z=colormap(cl);
for i=220:10:1044
    plot(rad_vis(:,i),vis_resp_lamps(:,i),'x-','Color',cl(i,:));
    plot(rad_vis(:,i),vis_resp_lamps(:,i)+vis_std_lamps(:,i),':','Color',cl(i,:));
    plot(rad_vis(:,i),vis_resp_lamps(:,i)-vis_std_lamps(:,i),':','Color',cl(i,:));
    %cl(:,i)=[1-i/1044 i/1044 0];
end
%hold('off');
title(['Response per intensity of lamps for Vis for cal:' date]);
ylabel('Response [Cts/ms (Wm^-2 sr^-1 um^-1)^-1]');
xlabel('Radiance [Wm^-2 sr^-1 um^-1]');
legend('Response','Standard deviation');
%colormap(cl);
caxis([vis.nm(220) vis.nm(1044)]);
h=colorbar('Ylim', [vis.nm(220) vis.nm(1044)]);
ylabel(h,'Wavelength [nm]');
ff=[pname '\' instrumentname '_' date '_resp_per_lamp_vis'];
save_fig(1,ff,true);


figure(2);
k=semilogx(rad_nir(:,1),nir_resp_lamps(:,1),'-');
hold('on');
cl=jet(512);
%z=colormap(cl);
for i=1:5:505
    plot(rad_nir(:,i),nir_resp_lamps(:,i),'x-','Color',cl(i,:));
    plot(rad_nir(:,i),nir_resp_lamps(:,i)+nir_std_lamps(:,i),':','Color',cl(i,:));
    plot(rad_nir(:,i),nir_resp_lamps(:,i)-nir_std_lamps(:,i),':','Color',cl(i,:));
    %cl(:,i)=[1-i/1044 i/1044 0];
end
%hold('off');
title(['Response per intensity of lamps for NIR for cal:' date]);
ylabel('Response [Cts/ms (Wm^-2 sr^-1 um^-1)^-1]');
xlabel('Radiance [Wm^-2 sr^-1 um^-1]');
legend('Response','Standard deviation');
%colormap(cl);
nm_low = min([nir.nm(1) nir.nm(505)]);nm_high = max([nir.nm(1) nir.nm(505)]); 
caxis([nm_low nm_high]);
h=colorbar('Ylim', [nm_low nm_high]);
ylabel(h,'Wavelength [nm]');
ff=[pname '\' instrumentname '_' date '_resp_per_lamp_nir'];
save_fig(2,ff,true);

%% building the response files
disp('Now prepare for building the response function')

% for 6-lamp cal (to compare with previous cals
% prepare the structures

print_vis.nm=vis.nm;
print_nir.nm=nir.nm;
print_vis.fname=vis.fname;
print_nir.fname=nir.fname;

disp(vis.fname)
disp(nir.fname)

% Select the proper variables for amount of lamps
if date == '20141024';
    ll = 12; % select the lamps-9
    iint_vis = 3; % 8 ms int time
    iint_nir = 3; % 100 ms int time
    lampstr = 'Lamps_12';
    fnum = '005';
    st = '013';
elseif date == '20140716';
    ll = 12; % select the lamps-9
    iint_vis = 3; % 12 ms int time
    iint_nir = 3; % 150 ms int time
    lampstr = 'Lamps_12';
    fnum = '003';
    st = '008';
elseif date =='20160330';
    ll = 12; % select the lamps-12
    iint_vis = 3; % 12 ms int time
    iint_nir = 3; % 150 ms int time
    lampstr = 'Lamps_12';
    fnum = '018';
    st = '024';
elseif date =='20170620';
    ll = 9; % select the lamps-12
    iint_vis = 3; % 12 ms int time
    iint_nir = 3; % 150 ms int time
    lampstr = 'Lamps_9';
    fnum = '009'; % file number to use : for printing the right file
    st = '013'; %last file analysed
    if strcmp(instrumentname,'4STARB');
        ll = 12; % select the lamps-12
        iint_vis = 2; % 12 ms int time
        iint_nir = 2; % 150 ms int time
        lampstr = 'Lamps_12';
        fnum = '013'; % file number to use : for printing the right file
        st = '006'; %last file analysed
    end;
elseif date == '20171102';
    ll = 9; % select the lamps-12
    iint_vis = 3; % 12 ms int time
    iint_nir = 3; % 150 ms int time
    lampstr = 'Lamps_9';
    fnum = '005'; % file number to use : for printing the right file
    st = '006'; %last file analysed
    if strcmp(instrumentname,'4STARB');
        ll = 12; % select the lamps-12
        iint_vis = 2; % 12 ms int time
        iint_nir = 2; % 150 ms int time
        lampstr = 'Lamps_9';
        fnum = '004'; % file number to use : for printing the right file
        st = '006'; %last file analysed
    end;
else
    ll=1; %select the lamps-9
    iint_vis=3;
    iint_nir=3;
    switch ll
        case 12
            if date =='20131120', fnum = '009'; else fnum='006'; end;
            lampstr='Lamps_12';
        case 9
            if date =='20131120', fnum = '010'; else fnum='007'; end;
            lampstr='Lamps_9';
        case 6
            if date =='20131120', fnum = '011'; else fnum='008'; end;
            lampstr='Lamps_6';
        case 3
            if date =='20131120', fnum = '012'; else fnum='001'; end;
            lampstr='Lamps_3';
        case 2
            if date =='20131120', fnum = '013'; else fnum='002'; end;
            lampstr='Lamps_2';
        case 1
            if date =='20131120', fnum = '014'; else fnum='003'; end;
            lampstr='Lamps_1';
        case 0
            if date =='20131120', fnum = '015'; else fnum='004'; end;
            lampstr='Lamps_0';
    end
    
    if date == '20131120'
        st='014' ;
    else
        st='003';
    end
end
print_vis.fname=strrep(print_vis.fname,st,fnum)
print_nir.fname=strrep(print_nir.fname,st,fnum)
print_vis.time=vis.time;
print_nir.time=nir.time;
print_vis.resp=cal.(lampstr).vis.resp(iint_vis,:);
print_nir.resp=cal.(lampstr).nir.resp(iint_nir,:);
print_vis.rad=cal.(lampstr).vis.rad;
print_nir.rad=cal.(lampstr).nir.rad;
print_vis.rate=mean(cal.(lampstr).vis.rate);
print_nir.rate=mean(cal.(lampstr).nir.rate);
print_nir.tint=cal.(lampstr).nir.t_ms(iint_nir);
print_vis.tint=cal.(lampstr).vis.t_ms(iint_vis);

write_SkyResp_files_2(print_vis,print_nir,hiss,pname,lampstr);
disp('file printed');

% plot multiple response functions
% plot for every lamp and integration time
plot_SKYresp(cal,vis,nir,date,pname);

return
