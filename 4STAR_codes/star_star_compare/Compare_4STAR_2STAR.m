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
s4 = load(fname_4starsun,'w','t','tau_aero_noscreening','rate','rateaero','c0','m_aero','Str');
disp(['Loading 2STAR file: ' fname_2starsun])
s2 = load(fname_2starsun,'w','t','tau_aero_noscreening','rate','rateaero','c0','m_aero');

% sanitize some fields
s2.t(s2.t<734300) = NaN;
s4.t(s4.t<734300) = NaN;

%% Run the calculations to create the comparisons.
iw = [];
nw = length(s2.w);
nt = length(s2.t);
tauratio = repmat(NaN,nt,nw); % 4star/2star
rateratio = repmat(NaN,nt,nw);
rateaeroratio = repmat(NaN,nt,nw);
trratio = repmat(NaN,nt,nw);

%% Load the slit function of 2STAR
slit_2s = importdata(fullfile(starpaths,'2STAR_vis_slit_0.1nm_from_SSFR.dat'));
slit_4s = repmat(0.0,nw,length(s4.w)); % slit values intrpolated for 4STAR wavelength grid


for ii=1:nw;
    % get the wavelength indices
    [nul,io] = min(abs(s4.w-s2.w(ii)));
    iw(ii)=io;
    ww = s2.w(ii)*1000.0+slit_2s(:,1);
    slit_4s(ii,:) = interp1(ww,slit_2s(:,2),s4.w*1000.0,'linear',0.0);
    area = trapz(slit_4s(ii,:));
    slit_4s(ii,:) = slit_4s(ii,:)./area;
    
    % get the differences of tau_aero_noscreening
    ta4 = s4.tau_aero_noscreening; ta4(isnan(ta4))=0.0; ta4(s4.Str~=1)=0.0;
    tau4s_slit = ta4*slit_4s(ii,:)';
    tau4ss = interp1(s4.t(s4.Str==1),tau4s_slit(s4.Str==1,:),s2.t);
    taudiffs(:,ii) = tau4ss-s2.tau_aero_noscreening(:,ii);
   
    tau4s = interp1(s4.t(s4.Str==1),s4.tau_aero_noscreening(s4.Str==1,io),s2.t);
    taudiff(:,ii) = tau4s-s2.tau_aero_noscreening(:,ii);
    
    % get the ratio of rate signals
    r4s = s4.rate; r4s(isnan(r4s))=0.0; r4s(s4.Str~=1)=0.0;
    r4s_slit = r4s*slit_4s(ii,:)';
    rate4ss = interp1(s4.t(s4.Str==1),r4s_slit(s4.Str==1,:),s2.t);
    rateratios(:,ii) = rate4ss./s2.rate(:,ii);
    
    rate4s = interp1(s4.t(s4.Str==1),s4.rate(s4.Str==1,io),s2.t);
    rateratio(:,ii) = rate4s./s2.rate(:,ii);
    
    % get the ratio of rate_aero signals
    ra4s = s4.rateaero; ra4s(isnan(ra4s))=0.0;
    ra4s_slit = ra4s*slit_4s(ii,:)';
    rateaero4ss = interp1(s4.t(s4.Str==1),ra4s_slit(s4.Str==1,:),s2.t);
    rateaeroratios(:,ii) = rateaero4ss./s2.rateaero(:,ii);

    rateaero4s = interp1(s4.t(s4.Str==1),s4.rateaero(s4.Str==1,io),s2.t);
    rateaeroratio(:,ii) = rateaero4s./s2.rateaero(:,ii);
    
    % get the transmittance ratio
    s4.tr = s4.rate./repmat(s4.c0,length(s4.t),1);
    s2.tr = s2.rate./repmat(s2.c0,nt,1);
    tr4 = s4.tr; tr4(isnan(tr4))=0.0;
    tr4_slit = tr4*slit_4s(ii,:)';
    tr4ss = interp1(s4.t(s4.Str==1),tr4_slit(s4.Str==1,:),s2.t);
    trratios(:,ii) = tr4ss./s2.tr(:,ii); 
    
    tr4s = interp1(s4.t(s4.Str==1),s4.tr(s4.Str==1,io),s2.t);
    trratio(:,ii) = tr4s./s2.tr(:,ii); 
    disp([num2str(ii) '/' num2str(nw)])
end;

%% find the 'clean' noon time point
ti=9/86400;
cc4=408; cc2=50;
nt4=numel(s4.t);
s4.rawstd=NaN(nt4, numel(cc4)); s4.rawmean=NaN(nt4, numel(cc4));
for i=1:nt4;
    rows=find(s4.t>=s4.t(i)-ti/2&s4.t<=s4.t(i)+ti/2&s4.Str==1);
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

raterelstd_4s = interp1(s4.t(s4.Str==1),s4.raterelstd(s4.Str==1),s2.t);
nums = 1:nt;
ifl = find((raterelstd_4s<0.005)&(s2.raterelstd<0.005)&(nums'>60)&(nums'<nt-60));
[nul,inn] = min(s2.m_aero(ifl));
inorm = ifl(inn);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting starts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
    [y,ii] = nfsmooth(rateratios(:,iws(i))./rateratios(inorm,iws(i)),60);
    plot(s2.t(ii),y,'.','color',cm(i,:));
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

fname = fullfile(p1,'figs',[daystr '_rateratio_' instrumentname4 'to2STAR_time']);
fig_names = {[fname '.png']};
save_fig(fig,fname);


%% Plot the rate ratios, normalized to a point vs airmass
fig = figure;
plot(s2.m_aero,rateratios(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[1 1],'--k');
for i=1:nwl;
    [y,ii] = nfsmooth(rateratios(:,iws(i))./rateratios(inorm,iws(i)),60);
    plot(s2.m_aero(ii),y,'.','color',cm(i,:));
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

fname = fullfile(p1,'figs',[daystr '_rateratio_' instrumentname4 'to2STAR_airmass']);
fig_names{2} = [fname '.png'];
save_fig(fig,fname);


%% Plot the rateaero ratios, normalized to a point, timeline
fig = figure;
plot(s2.t,rateaeroratios(:,50).*NaN,'.');
hold on;
plot([s2.t(1) s2.t(end)],[1 1],'--k');
for i=1:nwl;
    [y,ii]=nfsmooth(rateaeroratios(:,iws(i))./rateaeroratios(inorm,iws(i)),60);
    plot(s2.t(ii),y,'.','color',cm(i,:));
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

fname = fullfile(p1,'figs',[daystr '_rateaeroratio_' instrumentname4 'to2STAR_time']);
fig_names{3} = [fname '.png'];
save_fig(fig,fname);



%% Plot the rateaero ratios, normalized to a point vs airmass
fig = figure;
plot(s2.m_aero,rateaeroratios(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[1 1],'--k');
for i=1:nwl;
    [y,ii]=nfsmooth(rateaeroratios(:,iws(i))./rateaeroratios(inorm,iws(i)),60);
    plot(s2.m_aero(ii),y,'.','color',cm(i,:));
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

fname = fullfile(p1,'figs',[daystr '_rateaeroratio_' instrumentname4 'to2STAR_airmass']);
fig_names{4} = [fname '.png'];
save_fig(fig,fname);


%% Plot the raw transmittance ratio
fig = figure;
plot(s2.t,trratios(:,50).*NaN,'.');
hold on;
plot([s2.t(1) s2.t(end)],[1 1],'--k');
for i=1:nwl;
    [y,ii]=nfsmooth(trratios(:,iws(i)),60);
    plot(s2.t(ii),y,'.','color',cm(i,:));
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

fname=fullfile(p1,'figs',[daystr '_tr_' instrumentname4 'to2STAR_time']);
fig_names{5} = [fname '.png'];
save_fig(fig,fname);

%% Plot the raw transmittance ratio vs airmass
fig = figure;
plot(s2.m_aero,trratios(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[1 1],'--k');
for i=1:nwl;
    [y,ii] = nfsmooth(trratios(:,iws(i)),60);
    plot(s2.m_aero(ii),y,'.','color',cm(i,:));
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

fname=fullfile(p1,'figs',[daystr '_tr_' instrumentname4 'to2STAR_airmass']);
fig_names{6} = [fname '.png'];
save_fig(fig,fname);



%% Plot the aod difference
fig = figure;
plot(s2.t,taudiffs(:,50).*NaN,'.');
hold on;
plot([s2.t(1) s2.t(end)],[0 0],'--k');
for i=1:nwl;
    [y,ii] = nfsmooth(taudiffs(:,iws(i)),60);
    plot(s2.t(ii),y,'.','color',cm(i,:));
end;
dynamicDateTicks;
xlabel('UTC time');
ylabel(['Smoothed differences in AOD ' instrumentname4 '-2STAR' ])
title(['Time series of AOD differences - ' daystr]);
ylim([-0.1 0.1]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

fname=fullfile(p1,'figs',[daystr '_aoddiff_' instrumentname4 'to2STAR_time']);
fig_names{7} = [fname '.png'];
save_fig(fig,fname);



%% Plot the aod difference vs airmass
fig = figure;
plot(s2.m_aero,taudiffs(:,50).*NaN,'.');
hold on;
plot([s2.m_aero(1) s2.m_aero(end)],[0 0],'--k');
for i=1:nwl;
    [y,ii] = nfsmooth(taudiffs(:,iws(i)),60);
    plot(s2.m_aero(ii),y,'.','color',cm(i,:));
end;
xlabel('Airmass');
ylabel(['Smoothed differences in AOD ' instrumentname4 '-2STAR' ])
title(['AOD differences vs. Airmass - ' daystr]);
ylim([-0.1 0.1]);grid;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

fname = fullfile(p1,'figs',[daystr '_aoddiff_' instrumentname4 'to2STAR_airmass']);
fig_names{8} = [fname '.png'];
save_fig(fig,fname);


%% Plot the transmittance as a carpet plot
fig = figure;
colormap(parula)
imagesc(s2.t,s2.w.*1000.0,trratios',[0.6,1.6]);
dynamicDateTicks
ylabel('Wavelength [nm]');
xlabel('UTC time');
title(['Transmittance ratio ' instrumentname4 '/2STAR - ' daystr])
cb = colorbarlabeled('Transmittance ratio');

fname = fullfile(p1,'figs',[daystr '_tr_carpet_' instrumentname4 'to2STAR_timeseries']);
fig_names{9} = [fname '.png'];
save_fig(fig,fname);

%% Plot the transmittance as a carpet plot vs airmass
fig = figure;
colormap(parula)
imagesc(s2.m_aero,s2.w.*1000.0,trratios',[0.6,1.6]);
ylabel('Wavelength [nm]');
xlabel('Aerosol Airmass');
xlim([0 20]);
title(['Transmittance ratio ' instrumentname4 '/2STAR - ' daystr])
cb = colorbarlabeled('Transmittance ratio');

fname = fullfile(p1,'figs',[daystr '_tr_carpet_' instrumentname4 'to2STAR_airmass']);
fig_names{10} = [fname '.png'];
save_fig(fig,fname);

return

function [xs,ii] = nfsmooth(x,w);
ii = ~isnan(x);
if any(ii);
xs = fastsmooth(x(ii),w,1,1);
else;
    ii = [1 2 3];
    xs = [NaN NaN NaN];
end;
return