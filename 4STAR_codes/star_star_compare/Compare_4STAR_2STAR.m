function fig_names = Compare_4STAR_2STAR(fname_4starsun,fname_2starsun);
%% Details of the program:
% NAME:
%   Compare_4STAR_2STAR
%
% PURPOSE:
%  To generate plots of the comparison between 4STAR and 2STAR
%
% INPUT:
%  fname_4starsun: (optional) the full path of the 4STAR starsun.mat file
%  fname_2starsun: (optional) the full path of the 2STAR starsun.mat file
%
% OUTPUT:
%  many plots comparing 4STAR(s) to 2STAR
%  fig_names: cell array of file names of the saved pngs
%
% DEPENDENCIES:
%  - version_set.m
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun for 4STAR and 2STAR
%  - starinfo for the flight
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Mauna Loa Observatory, 2017-05-31
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%% set wvls to plot:
wvl = [350.0 430.0 450.0 500.0 532.0 601.0 675.0 750.0 875.0 941.0];

%% get the file paths
if nargin<1; % no file path set
    [f1,p1] = uigetfile2('4STAR*starsun.mat','Choose 4STAR starsun file');
    fname_4starsun = [p1 f1];
    [f2,p2] = uigetfile2('2STAR*starsun.mat','Choose 2STAR starsun file');
    fname_2starsun = [p2 f2];
elseif nargin<2;
    [f2,p2] = uigetfile2('2STAR*starsun.mat','Choose 2STAR starsun file');
    fname_2starsun = [p2 f2];
else;
    [p1, f, ext0]=fileparts(fname_4starsun);
end;

[daystr, filen, datatype, instrumentname4]=starfilenames2daystr({fname_4starsun});

%% load the files
disp(['Loading 4STAR file: ' fname_4starsun])
s4 = load(fname_4starsun,'w','t','tau_aero_noscreening','rate','rateaero','c0','m_aero');
disp(['Loading 2STAR file: ' fname_2starsun])
s2 = load(fname_2starsun,'w','t','tau_aero_noscreening','rate','rateaero','c0','m_aero');

%% Run the calculations to create the comparisons.
iw = [];
nw = length(s2.w);
nt = length(s2.t);
tauratio = repmat(NaN,nt,nw); % 4star/2star
rateratio = repmat(NaN,nt,nw);
rateaeroratio = repmat(NaN,nt,nw);
trratio = repmat(NaN,nt,nw);

for ii=1:nw;
    % get the wavelength indices
    [nul,io] = min(abs(s4.w-s2.w(ii)));
    iw(ii)=io;

    % get the differences of tau_aero_noscreening
    tau4s = interp1(s4.t,s4.tau_aero_noscreening(:,io),s2.t);
    taudiff(:,ii) = tau4s-s2.tau_aero_noscreening(:,ii);
    
    % get the ratio of rate signals
    rate4s = interp1(s4.t,s4.rate(:,io),s2.t);
    rateratio(:,ii) = rate4s./s2.rate(:,ii);
    
    % get the ratio of rate_aero signals
    rateaero4s = interp1(s4.t,s4.rateaero(:,io),s2.t);
    rateaeroratio(:,ii) = rateaero4s./s2.rateaero(:,ii);
    
    % get the transmittance ratio
    s4.tr = s4.rate./repmat(s4.c0,length(s4.t),1);
    s2.tr = s2.rate./repmat(s2.c0,nt,1);
    tr4s = interp1(s4.t,s4.tr(:,io),s2.t);
    trratio(:,ii) = tr4s./s2.tr(:,ii); 
end;

%% find the 'clean' noon time point
ti=9/86400;
cc4=408; cc2=50;
nt4=numel(s4.t);
s4.rawstd=NaN(nt4, numel(cc4)); s4.rawmean=NaN(nt4, numel(cc4));
for i=1:nt4;
    rows=find(s4.t>=s4.t(i)-ti/2&s4.t<=s4.t(i)+ti/2);
    if numel(rows)>0;
        s4.ratestd(i,:)=nanstd(s4.rate(rows,cc4),0,1); % stdvec.m seems to have a precision problem.
        s4.ratemean(i,:)=nanmean(s4.rate(rows,cc4),1);
    end;
end;
s4.raterelstd=s4.ratestd./s4.ratemean;

s2.ratestd=NaN(nt, numel(cc2)); s2.ratemean=NaN(nt, numel(cc2));
for i=1:nt;
    rows=find(s2.t>=s2.t(i)-ti/2&s2.t<=s2.t(i)+ti/2);
    if numel(rows)>0;
        s2.ratestd(i,:)=nanstd(s2.rate(rows,cc2),0,1); % stdvec.m seems to have a precision problem.
        s2.ratemean(i,:)=nanmean(s2.rate(rows,cc2),1);
    end;
end;
s2.raterelstd=s2.ratestd./s2.ratemean;

raterelstd_4s = interp1(s4.t,s4.raterelstd,s2.t);
nums = 1:nt;
ifl = find((raterelstd_4s<0.005)&(s2.raterelstd<0.005)&(nums'>60)&(nums'<nt-60));
[nul,inn] = min(s2.m_aero(ifl));
inorm = ifl(inn);



%% Plot the rate ratios, normalized to a point, timeline
fig = figure;
nwl = length(wvl); 
for i=1:nwl; 
    [nul,iw] = min(abs(s2.w.*1000.0-wvl(i)));
    iws(i) = iw;
end;
cm = hsv(nwl);
plot(s2.t,rateratio(:,50).*NaN,'.');
hold on;
plot([s2.t(1) s2.t(end)],[1 1],'--k');
for i=1:nwl;
    plot(s2.t,nanfastsmooth(rateratio(:,iws(i))./rateratio(inorm,iws(i)),60),'.','color',cm(i,:));
end;
dynamicDateTicks;
xlabel('UTC time');
ylabel(['Smoothed Rate ratio ' instrumentname4 '/2STAR' ])
title(['Time series of rate ratio normalized to: ' datestr(s2.t(inorm),13) ' - ' daystr]);
hx = graph2d.constantline(s2.t(inorm));
changedependvar(hx,'x');
ylim([0.95 1.05]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_rateratio_' instrumentname4 'to2STAR_time']));

%% Plot the rate ratios, normalized to a point vs airmass
fig = figure;
plot(s2.m_aero,rateratio(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[1 1],'--k');
for i=1:nwl;
    plot(s2.m_aero,nanfastsmooth(rateratio(:,iws(i))./rateratio(inorm,iws(i)),60),'.','color',cm(i,:));
end;
xlabel('Aerosol Airmass');
ylabel(['Smoothed rate ratio ' instrumentname4 '/2STAR' ])
title(['Rate ratio vs. airmass normalized to: ' datestr(s2.t(inorm),13) ' - ' daystr]);
hx = graph2d.constantline(s2.m_aero(inorm));
changedependvar(hx,'x');
ylim([0.95 1.05]);
grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_rateratio_' instrumentname4 'to2STAR_airmass']));



%% Plot the rateaero ratios, normalized to a point, timeline
fig = figure;
plot(s2.t,rateaeroratio(:,50).*NaN,'.');
hold on;
plot([s2.t(1) s2.t(end)],[1 1],'--k');
for i=1:nwl;
    plot(s2.t,nanfastsmooth(rateaeroratio(:,iws(i))./rateaeroratio(inorm,iws(i)),60),'.','color',cm(i,:));
end;
dynamicDateTicks;
xlabel('UTC time');
ylabel(['Smoothed Rateaero ratio ' instrumentname4 '/2STAR' ])
title(['Time series of rateaero ratio normalized to: ' datestr(s2.t(inorm),13) ' - ' daystr]);
hx = graph2d.constantline(s2.t(inorm));
changedependvar(hx,'x');
ylim([0.95 1.05]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_rateaeroratio_' instrumentname4 'to2STAR_time']));



%% Plot the rateaero ratios, normalized to a point vs airmass
fig = figure;
plot(s2.m_aero,rateaeroratio(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[1 1],'--k');
for i=1:nwl;
    plot(s2.m_aero,nanfastsmooth(rateaeroratio(:,iws(i))./rateaeroratio(inorm,iws(i)),60),'.','color',cm(i,:));
end;
xlabel('Aerosol Airmass');
ylabel(['Smoothed rateaero ratio ' instrumentname4 '/2STAR' ])
title(['Rateaero ratio vs. airmass normalized to: ' datestr(s2.t(inorm),13) ' - ' daystr]);
hx = graph2d.constantline(s2.m_aero(inorm));
changedependvar(hx,'x');
ylim([0.95 1.05]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_rateaeroratio_' instrumentname4 'to2STAR_airmass']));



%% Plot the raw transmittance ratio
fig = figure;
plot(s2.t,trratio(:,50).*NaN,'.');
hold on;
plot([s2.t(1) s2.t(end)],[1 1],'--k');
for i=1:nwl;
    plot(s2.t,nanfastsmooth(trratio(:,iws(i)),60),'.','color',cm(i,:));
end;
dynamicDateTicks;
xlabel('UTC time');
ylabel(['Smoothed Transmittance ratio ' instrumentname4 '/2STAR' ])
title(['Time series of Transmittance ratio - ' daystr]);
hx = graph2d.constantline(s2.t(inorm));
changedependvar(hx,'x');
ylim([0.9 1.1]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_tr_' instrumentname4 'to2STAR_time']));

%% Plot the raw transmittance ratio vs airmass
fig = figure;
plot(s2.m_aero,trratio(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[1 1],'--k');
for i=1:nwl;
    plot(s2.m_aero,nanfastsmooth(trratio(:,iws(i)),60),'.','color',cm(i,:));
end;
xlabel('Airmass');
ylabel(['Smoothed Transmittance ratio ' instrumentname4 '/2STAR' ])
title(['Transmittance ratio vs. Airmass - ' daystr]);
hx = graph2d.constantline(s2.m_aero(inorm));
changedependvar(hx,'x');
ylim([0.9 1.1]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_tr_' instrumentname4 'to2STAR_airmass']));

%% Plot the aod difference
fig = figure;
plot(s2.t,taudiff(:,50).*NaN,'.');
hold on;
plot([s2.t(1) s2.t(end)],[0 0],'--k');
for i=1:nwl;
    plot(s2.t,nanfastsmooth(taudiff(:,iws(i)),60),'.','color',cm(i,:));
end;
dynamicDateTicks;
xlabel('UTC time');
ylabel(['Smoothed differences in AOD ' instrumentname4 '-2STAR' ])
title(['Time series of AOD differences - ' daystr]);
ylim([-0.1 0.1]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_aoddiff_' instrumentname4 'to2STAR_time']));

%% Plot the aod difference vs airmass
fig = figure;
plot(s2.m_aero,taudiff(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[0 0],'--k');
for i=1:nwl;
    plot(s2.m_aero,nanfastsmooth(taudiff(:,iws(i)),60),'.','color',cm(i,:));
end;
xlabel('Airmass');
ylabel(['Smoothed differences in AOD ' instrumentname4 '-2STAR' ])
title(['AOD differences vs. Airmass - ' daystr]);
ylim([-0.1 0.1]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

save_fig(fig,fullfile(p1,'figs',[daystr '_aoddiff_' instrumentname4 'to2STAR_airmass']));

return