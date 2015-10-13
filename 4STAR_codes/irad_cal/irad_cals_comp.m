%% Details of the program:
% NAME:
%   irad_cals_comp
% 
% PURPOSE:
%  Compare the calibration of sun barrel irradiances
%  combined with Langley
%
% CALLING SEQUENCE:
%   irad_cals_comp
%
% INPUT:
%  - none
% 
% OUTPUT:
%  - plot of combined Langley for various dates
%
% DEPENDENCIES:
%  - save_fig.m (for saving the plots)
%  - startup_plotting.m (for making good looking plots)
%
% NEEDED FILES:
%  - combined Langley files in yyyymmdd_scaled_langley.mat format 
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, NASA Ames, August 29th, 2014
%
% -------------------------------------------------------------------------

%% start of function
function irad_cals_comp(varargin)
additionalplots = false;
startup;
% [matfolder, figurefolder, askforsourcefolder, author]=starpaths;
% dirf = figurefolder;
% dir  = matfolder;
% startup
 dir='C:\MatlabCodes\data\';
 dirf='C:\MatlabCodes\figs\';
 ll='\';


%% setup the files to load and load them
dates=['20131122';'20140624';'20140716';'20141024'];
ref1=2;
ref2=4;
files=[dir dates(1,:) '_scaled_langley.mat';...
       dir dates(2,:) '_scaled_langley.mat';...
       dir dates(3,:) '_scaled_langley.mat';...
       dir dates(4,:) '_scaled_langley.mat'];
   
num=length(dates(:,1));
for l=1:num
    fields{l}=['adjc0' dates(l,:)];
    d.(fields{l})=load(files(l,:));
    
end;

% set reference irradiance
irradref1=d.(fields{ref1}).lampc0;
irradref2=d.(fields{ref2}).lampc0;
c0ref1   =d.(fields{ref1}).c0;
c0ref2   =d.(fields{ref2}).c0;
%% plot the adjusted c0 Langley's and their differences
% relative to SEAC4RS adjc0
figure(12); 
set(12,'Position',[20 30 1200 800]);

ax1=subplot(2,1,1);
plot(d.(fields{1}).nm,d.(fields{1}).lampc0);
hold all;
for i=2:num
  plot(d.(fields{i}).nm,d.(fields{i}).lampc0);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('counts');
title('lamp scaled Langleys');
legend(dates);
ylim([0,700]);
xlim([300 1700]);


ax2=subplot(2,1,2);
plot(d.(fields{1}).nm,d.(fields{1}).lampc0./irradref1);
hold all;
for i=2
  plot(d.(fields{i}).nm,d.(fields{i}).lampc0./irradref1);  
end
hold all;
for i=3:num
  plot(d.(fields{i}).nm,d.(fields{i}).lampc0./irradref2);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Ratio of scaled Langleys');
title(['Ratio of scaled Langley compared to: ' dates(ref1,:) 'scaled Langley and ' dates(ref2,:)]);
legend(dates);
ylim([0.9,1.1]);
xlim([300 1700]);
grid on;

fi=[dirf 'scaled_langley_compare2adjc0'];

linkaxes([ax1,ax2],'x');
save_fig(12,fi,true);


% relative to SEAC4RS-MLO c0
figure(13); 
set(13,'Position',[20 30 1200 800]);

ax1=subplot(2,1,1);
plot(d.(fields{1}).nm,d.(fields{ref1}).c0);
hold all;
plot(d.(fields{2}).nm,d.(fields{ref2}).c0);
adjdates=[];
for i=1:num
  plot(d.(fields{i}).nm,d.(fields{i}).lampc0);  
  adjdates = [adjdates; strcat(dates(i,:),'adjc0')];
end
hold off;
xlabel('Wavelength (nm)');
ylabel('counts');
title('lamp scaled Langleys');
legend([strcat(dates(ref1,:),'MLOc0');strcat(dates(ref2,:),'MLOc0');adjdates]);
ylim([0,700]);
xlim([300 1700]);


ax2=subplot(2,1,2);
plot(d.(fields{1}).nm,d.(fields{ref1}).c0./c0ref1);
hold all;
plot(d.(fields{2}).nm,d.(fields{ref2}).c0./c0ref2);
for i=2
  plot(d.(fields{i}).nm,d.(fields{i}).lampc0./c0ref1);  
end
for i=3:num
  plot(d.(fields{i}).nm,d.(fields{i}).lampc0./c0ref2);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Ratio of scaled Langleys');
title(['Ratio of scaled Langley compared to: ' dates(ref1,:) 'MLO c0 and ' dates(ref2,:) ]);
ylim([0.9,1.4]);
xlim([300 1700]);
grid on;

fi=[dirf 'scaled_langley_compare2MLOc0'];
linkaxes([ax1,ax2],'x');
save_fig(13,fi,true);

% compare Sratio for various dates
strcts=[dir dates(1,:) '_Langs_and_Lamps.mat';...
        dir dates(2,:) '_Langs_and_Lamps.mat';...
        dir dates(3,:) '_Langs_and_Lamps.mat';...
        dir dates(4,:) '_Langs_and_Lamps.mat'];

for l=1:num
    Lfields{l}=['L' dates(l,:)];
    d.(Lfields{l})=load(strcts(l,:));
end;

figure(14); 
% VIS
subplot(121);
for i=1:num
  plot(d.(Lfields{i}).Langs_and_lamps.vis.nm,d.(Lfields{i}).Langs_and_lamps.vis.Sratio,...
       '-','linewidth',1.5,'color',[0.2+i/8 0.2 0.2+i/8]);  hold on;
end
errorx_vis = [400 550 700 950];
for i=1:num
  errorbar(errorx_vis(i),d.(Lfields{i}).Langs_and_lamps.vis.SratioAvgMod,...
           d.(Lfields{i}).Langs_and_lamps.vis.SratioStdMod,'s','color',[0.2+i/8 0.2 0.2+i/8],...
           'markerfacecolor',[0.2+i/8 0.2 0.2+i/8],'markersize',16);hold on;
end
xlabel('wavelength');
ylabel('Langley/FEL responsivity ratio');
legend(dates);
ylim([1.0e-4 1.6e-4]);
xlim([300 1000]);
grid on;
% NIR
subplot(122);
for i=1:num
  plot(d.(Lfields{i}).Langs_and_lamps.nir.nm,d.(Lfields{i}).Langs_and_lamps.nir.Sratio,...
       '-','linewidth',1.5,'color',[0.5+i/8 0.2 0.2+i/8]);  hold on;
end
errorx_nir = [1100 1250 1400 1550];
for i=1:num
  errorbar(errorx_nir(i),d.(Lfields{i}).Langs_and_lamps.nir.SratioAvgMod,...
           d.(Lfields{i}).Langs_and_lamps.nir.SratioStdMod,'s','color',[0.5+i/8 0.2 0.2+i/8],...
           'markerfacecolor',[0.5+i/8 0.2 0.2+i/8],'markersize',16);hold on;
end
xlabel('wavelength');
ylabel('Langley/FEL responsivity ratio');
legend(dates);
ylim([1.0e-4 1.8e-4]);
xlim([1000 1700]);
grid on;
fi=[dirf 'compareSratio3'];
save_fig(14,fi,true);


%% plot difference versus absorption xs
if additionalplots
% load xs
BrO  = load('C:\MatlabCodes\data\UVxs\BrO_243K_AIR4star.txt');
Gly  = load('C:\MatlabCodes\data\UVxs\Glyoxal_296K_AIR4star.txt');
form = load('C:\MatlabCodes\data\UVxs\HCHO_293K4STAR.txt');
no2  = load('C:\MatlabCodes\data\UVxs\NO2_254K_convTech5.txt');
OBrO = load('C:\MatlabCodes\data\UVxs\OBrOxs4STARconv.txt');

figure(15);
plot(d.(fields{1}).nm,d.(fields{ref1}).c0./c0ref1);
hold all;
for i=1:num
  plot(d.(fields{i}).nm,d.(fields{i}).lampc0./c0ref1);  
end
hold on;
plot(no2(:,1),1+no2(:,2)*1e17,'.-','color',[0.8 0.7 0.1]);
hold on;
plot(form(:,1),1+form(:,2)*1e19,'.-','color',[0.5 0.5 0.9]);
hold on;
plot(Gly(:,1),1+Gly(:,2)*1e18,'.-','color',[0.3 0 0.3])
hold off;
xlabel('Wavelength (nm)');
ylabel('Ratio of scaled Langleys');
title(['Ratio of scaled Langley compared to: ' dates(ref1,:) 'MLO c0']);
legend([strcat(dates(ref1,:),'MLOc0');adjdates;'NO2-4starconv';'form4starconv';'Gly-4starconv']);
ylim([0.95,1.4]);
xlim([300 500]);
grid on;
fi=[dirf 'scaled_langley_compare2MLOc0_withgases'];
save_fig(15,fi,true);

end
%%

 
   
   