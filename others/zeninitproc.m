function zeninitproc
% initial processing procedure of 4star zenith measurements
% read starzen; flip swir wln
%----------------------------------------------------------
clear all;close all;
% read in wavelengths from c0
tmp  = importdata('20130212_VIS_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214.dat');
tmp1 = importdata('20130212_NIR_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214.dat');

visw  = tmp.data(:,2);
nirw = tmp1.data(:,2);

% load data for analysis
%% load data

 defaultpath='C:\';
 [filename,filepath]=uigetfile(defaultpath,'Choose starsun .mat File', 0,0); 
 zen = load([filepath,filename]);
% concatanate vis nir data
nir_zen = fliplr(zen.nir_zen.raw);
zen.raw_all = cat(2,zen.vis_zen.raw,nir_zen);
zen.w = cat(1,visw,nirw);   % in [nm]

[p,q]=size(zen.raw_all);
zen.UT = serial2Hh(zen.vis_zen.t);

% add SZA, cosine airmass
for i=1:length(zen.vis_zen.t)
[zen_, az_, soldst_, ha_, dec_, el_, am_] = sunae(zen.vis_zen.Lat(i), zen.vis_zen.Lon(i), zen.vis_zen.t(i));
zenith(i)=zen_;
az(i)=az_;
soldst(i)=soldst_;
ha(i)=ha_;
dec(i)=dec_;
el(i)=el_;
am(i)=am_;  % this is Rayleigh airmass
end
zen.airmass=am';
zen.SZA=zenith';
% test figure
figure;
plot(zen.w,zen.raw_all,'.');title('raw counts');

% time-series
figure;
plot(zen.UT,zen.raw_all(:,386),'.');title('raw counts');

% deleting shutter close/open edge values
% transition region
shut = zen.nir_zen.Str==0;
sun = zen.nir_zen.Str==1;
sky = zen.nir_zen.Str==2;

edge = [false; zen.nir_zen.Str(1:end-1)~=zen.nir_zen.Str(2:end)];
%sky = zen.nir_zen.Str==2;
sky(edge) = false;% whenever edge is true we will assign sky false edge of a shutter
figure;
%plot(zen.UT,zen.raw_all(:,386),'.r');title('raw counts');hold on;
plot(zen.UT(sky==1),zen.raw_all(sky==1,386),'.b');hold on;

% sky(edge) = false;
% sun(edge) = false;
%
recs = [1:length(zen.nir_zen.t)];
figure; plot(recs(sky), zen.vis_zen.raw(sky,386),'ko',...
    recs(edge), zen.vis_zen.raw(edge,386),'r.');
zoom('on');





% even if the shutter is 2 and is edge--> not zen sky
% choose saturation wavelength filter (500 nm)
satw = 495;%407;570 nm = 495;
% plot test spectra
% filter for saturation
isat = logical(zen.raw_all(:,satw)<=55000);
figure;
plot(zen.w,zen.raw_all(isat,:),'.');title('non-saturated raw counts');
%plot 670 nm /1600 nm with time ( for Str==2)
figure;
plot(zen.UT(zen.vis_zen.Str==2),zen.raw_all(zen.vis_zen.Str==2,620),'.b');hold on;
plot(zen.UT(zen.vis_zen.Str==2),zen.raw_all(zen.vis_zen.Str==2,1471),'.g');
legend('670 nm','1600 nm');
% Feb-19 case
idxsamp = 283:942;
UTsamp  =zen.UT(idxsamp);
Tintsampvis = zen.vis_zen.Tint(idxsamp);
Tintsampnir = zen.nir_zen.Tint(idxsamp);
% chose only 350 m case study
Altsamp = zen.vis_zen.Alt(idxsamp); Altsampi = logical(Altsamp<=355&Altsamp>=345);
SZAsamp = zen.SZA(idxsamp); SZAsampi = logical(SZAsamp<=54.1&SZAsamp>=53.9);

raw_all_samp = zen.raw_all(idxsamp,:);
% chose dark instances
darkmode  = zen.vis_zen.Str(idxsamp)==0&raw_all_samp(:,407)<500;
darkcount = mean(raw_all_samp(darkmode==1,:));
darkcountmat = repmat(darkcount,length(idxsamp),1);
figure;
plot(zen.w,darkcount);%raw_all_samp(darkmode==1,:)
% divide by integration time
iwvis = length(1:1044);
iwnir = length(1045:1556);
rate_vis = (raw_all_samp(:,1:1044))./repmat(Tintsampvis,1,iwvis);
rate_nir = (raw_all_samp(:,1045:1556))./repmat(Tintsampnir,1,iwnir);
rate_all = cat(2,rate_vis,rate_nir);

% plot 350 flight leg spectra
figure;
plot(zen.w,rate_all(Altsampi==1,:),'.');title(strcat('selected rate data (flight altitude of 350m) from ',datestr(zen.vis_zen.t(1),'yyyy-mm-dd')));

% divide by instrument convolved Guymer TOA spectrum
% Transmittance = pi*intensity/TOA*cos(SZA)
%
% filter for "spikes"
goodidx = rate_all(:,620)<100 | rate_all(:,620)>1000;
%
[TOA] = starGueymar;
TOAmat = repmat(TOA',length(idxsamp),1);
SZAsamprad = deg2rad(SZAsamp);
SZAmat = repmat(SZAsamprad,1,iwvis+iwnir);
transmittance = pi*rate_all./(TOAmat.*cos(SZAmat));
transmin = 0;
transmaxvis = max(max(transmittance(:,1:1044)));
transmaxnir = max(max(transmittance(:,1045:1556)));

normtransmittancevis = (transmittance(:,1:1044) - transmin)/(transmaxvis - transmin);
normtransmittancenir = (transmittance(:,1045:1556) - transmin)/(transmaxnir - transmin);

normtransmittance = cat(2,normtransmittancevis,normtransmittancenir);%(transmittance - transmin)/(transmax - transmin);

% plot norm transmittance goodidx transmittances for 350 m flight leg
figure;
plot(zen.w,normtransmittance,'-');xlabel('wavelength');ylabel('Transmittance (normalized to min-max)');axis([200 1700 0 1]);

% plot time-series
figure;
plot(UTsamp(Altsampi==1&goodidx==1),normtransmittance(Altsampi==1&goodidx==1,621),'.-b');

% chose wavelength to compare with LUT
% wln: 515, 670, 1560, 1600, 1640
% ind: 426, 621, 1440, 1471, 1503

% plot 670 nm with time
figure;
plot(UTsamp(Altsampi==1),rate_all(Altsampi==1,620),'.g');xlabel('time [UT]');ylabel('zenith mode rate for 670 nm');

% filter 2 on transmittance plain
goodidx2 = normtransmittance(:,621)>=0.1;
%
% plot time-series after second filtering
% 
figure;
plot(UTsamp(Altsampi==1&goodidx==1&goodidx2==1),normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,621),'.-b');hold on;
plot(UTsamp(Altsampi==1&goodidx==1&goodidx2==1),normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,1440),'.-g');hold on;
plot(UTsamp(Altsampi==1&goodidx==1&goodidx2==1),normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,1471),'.-r');hold on;

%
% plot normalized transmittance
figure;
plot(zen.w,normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,:),'-');xlabel('wavelength');ylabel('Transmittance (normalized to min-max)');axis([200 1700 0 1]);


% plot 1600 vs. 670
figure;
plot(normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,621),normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,1471),'o','color','g','markerfacecolor','g','markersize',8);
axis([0 0.6 0 0.6]);xlabel('Tranmittance at 670 nm','fontsize',14,'fontweight','bold');
ylabel('Tranmittance at 1600 nm','fontsize',14,'fontweight','bold');set(gca,'fontsize',14,'fontweight','bold');

transmittancedata = [normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,426),normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,621) ,normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,1440),...
                     normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,1471),normtransmittance(Altsampi==1&goodidx==1&goodidx2==1,1503)];

transfilename = 'transmittance20130219.txt';
save(transfilename,'-ASCII','transmittancedata');















% raw_all_samp = zen.raw_all(idxsamp,:);
Strsamp       = zen.vis_zen.Str(idxsamp);
Strsampshut   = zen.vis_zen.Str(idxsamp)==0;
Strsampskyshut= zen.vis_zen.Str(idxsamp)==2;


Strsampshut(2:end) = Strsampshut(1:end-1)&Strsampshut(2:end); % widens border of ‘false’ values in the “positive” direction
Strsampshut(1:end-1) = Strsampshut(1:end-1)&Strsampshut(2:end); % widens border of ‘false’ values in the “negative” direction
Strsampskyshut(2:end) = Strsampskyshut(1:end-1)&Strsampskyshut(2:end);
Strsampskyshut(1:end-1) = Strsampskyshut(1:end-1)&Strsampskyshut(2:end);

% goodidx      = logical(raw_all_samp(:,407)>1000 & raw_all_samp(:,495)>1000);
figure;% plot darks
plot(zen.w,raw_all_samp(Altsampi==1&iraw_all_sampdata==0,:),'.');
title(strcat('selected raw data (str==0) from ',datestr(zen.vis_zen.t(1),'yyyy-mm-dd')));
xlabel('wavelength');ylabel('raw counts');


% try to filter/separate darks and measurements
% high darks are generally the result of the shutter not closing either quickly enough or completely.  
% we need to flag the shutter position with several Boolean (true/false)
% fields.  To eliminate problems with the shutter transition.

skyshut = zen.vis_zen.Str==2;
shut    = zen.vis_zen.Str==0;
%Shutter motion is not very clean.  Need to strip some adjacent records on both ends.
shut(2:end) = shut(1:end-1)&shut(2:end); % widens border of ‘false’ values in the “positive” direction
shut(1:end-1) = shut(1:end-1)&shut(2:end); % widens border of ‘false’ values in the “negative” direction
skyshut(2:end) = skyshut(1:end-1)&skyshut(2:end);
skyshut(1:end-1) = skyshut(1:end-1)&skyshut(2:end);

Strsampskyshut     = (skyshut(idxsamp(Altsampi==1)));%Strsampskyshut19case = Strsampskyshut(Strsampskyshut(Altsampi==1));
Strsampshut        = shut(idxsamp);
% Sometimes the shutter actually gets stuck in an intermediate position, 
% neither truly open nor closed.  In this case I typically look at the magnitude 
% of signal near a pixel that will have plenty of signal from real sky and define 
% and adhoc test to flag conditions when the measured counts exceed normal dark counts.  
% Not very satisfying but we do what we must.







figure;% plot darks
plot(zen.UT(zen.vis_zen.Str==0),zen.raw_all(zen.vis_zen.Str==0,407),'.');




