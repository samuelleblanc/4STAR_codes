function fig_paths = compare_star_2_aeronet(fname_starsun,loose_aeronet_comparison);
%% PURPOSE:
%   Compare the 4STAR aod values to a cimel aeronet v1.5 ground site. 
%
% INPUT:
%  - None
% 
% OUTPUT:
%  - figures and a save file
%
% DEPENDENCIES:
%  version_set.m : to have version control of this m-script
%
% NEEDED FILES:
%  - starsun.mat for only the ground sites
%  - aeronet file spanning time of starsun. in either .lev10 or .lev15
%  format
%
% EXAMPLE:
%  ....
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2017-10-20
% Modified (v1.1): Samuel LeBlanc, Santa Cruz, CA, 2020-09-21
%                  Changed pathing to use the getnamedpath starsun and
%                  starfig
%                  Added return of figure path files
% Modified (v1.2): Samuel LeBlanc, Santa Cruz, CA, 2021-04-19
%                  Added supprot for AERONET v3 diret beam files
% Modified (v1.3): Samuel LeBlanc, Santa Cruz, CA, 2022-04-29
%                  Added plotting vs. Azimuth Angle
% Modified (v1.4): Samuel LeBlanc, Santa Cruz, CA, 2021-01-31
%                  Added a toogle for a loose aeronet comparison
% -------------------------------------------------------------------------

%% start of function
version_set('1.4')

%% load the file
fp = getnamedpath('starsun');
if nargin<1;
    [file pname fi]=uigetfile2('*starsun*.mat','Find starsun file for comparison .mat',fp);
    if file==0
        fig_paths = {};
        return
    end
    fname_starsun = [pname file];
end
disp(['Loading the matlab file: ' fname_starsun])
[daystr, filen, datatype, instrumentname]=starfilenames2daystr({fname_starsun});

if nargin<2 % no loose aeronet comparison set, assume false
    loose_aeronet_comparison = 0;
end
if ~loose_aeronet_comparison
    max_alt_diff = 200.0;
    max_seconds_diff = 360.0;
else
    max_alt_diff = 300.0;
    max_seconds_diff = 600.0;
end

try; 
    load(fname_starsun,'t','tau_aero_noscreening','w','m_aero','rawrelstd','Alt','rateaero','c0','note','Az_deg');
catch;
    load(fname_starsun);
end;

fp = getnamedpath('aeronet');
dis = dir([fp daystr(3:end) '*.lev*']);
if length(dis) < 1
	dis = dir([fp daystr '*.lev*']);
end
if length(dis) ~= 1
    if usejava('desktop')
    try
        [afile apname afi]=uigetfile2('*.lev10; *.lev15; *.lev20','Select the aeronet file containing AOD (level 1.0, 1.5, or 2.0)',fp);
    catch
        fig_paths = {};
        disp(['Did not find aeronet files for daystr:' daystr(3:end) ', in folder: ' fp ])
        return
    end
    else
        fig_paths = {};
        disp(['Did not find aeronet files for daystr:' daystr(3:end) ', in folder: ' fp ])
        return
    end

    if afile==0
        fig_paths = {};
        return 
    end
else
    apname = [dis.folder filesep];
    afile = dis.name;
end
a = aeronet_read_lev_v3([apname afile]);

%% filter out the bad aod 4STAR
if ~loose_aeronet_comparison
    i = (rawrelstd(:,1) < 0.008)&(tau_aero_noscreening(:,400)<4.0)&(tau_aero_noscreening(:,1503)>(-0.02))&(tau_aero_noscreening(:,400)>0.0)&(Alt>(a.elev-max_alt_diff))&(Alt<(a.elev+max_alt_diff));
else
    i = (~isnan(tau_aero_noscreening(:,400)))&(~isnan(tau_aero_noscreening(:,1503)))&(tau_aero_noscreening(:,400)>-4.0)&(Alt>(a.elev-max_alt_diff))&(Alt<(a.elev+max_alt_diff));
end
%% knnsearch to find the closest times to compare aeronet and 4STAR data
% make sure to only have unique valuesSL331125766198

[t_un,it_un] = unique(t(i));
[idat,datdt] = knnsearch(t_un,a.jd);
iidat = datdt<max_seconds_diff/(3600.0*24.0); % Distance no greater than 60.0 seconds.

it = find(i); 
ii = it(it_un(idat(iidat)));
ia = iidat;

if length(it)<1;
    warning('No good 4STAR data found to compare, please reevaluate the filtering in compare_star_2_aeronet.m')
end
%% match aeronet wvls to 4STAR's
wvls = a.wlen(a.anywlen==1);
a.iw = find(a.anywlen==1);
iw = wvls;
for n=1:length(wvls);
    [nul,in] = min(abs(wvls(n)-w*1000.0));
    iw(n) = in;
end;

%%%%%%%%%%%%%%
%% plot the time trace output and correlate
% plot of the time series of 4STAR, AERONET, and 4STAR+AERONET
figure('pos',[30,60,1000,800]);
cm = hsv(length(wvls)); cmj = cm.*0.3+0.7;

ax1 = subplot(3,1,3);
plot(t(i),tau_aero_noscreening(i,iw(1)),'o','Color',cm(1,:));
hold on; dynamicDateTicks;
for n=2:length(wvls);
    plot(t(i),tau_aero_noscreening(i,iw(n)),'o','Color',cm(n,:));
end;
title([instrumentname ' ground time trace'])
ylabel([instrumentname ' AOD']); grid; xlabel('Time')

ax2 = subplot(3,1,2);
plot(a.jd,a.aot(:,a.iw(1)),'x','Color',cm(1,:));
hold on; dynamicDateTicks;
for n=2:length(wvls);
    plot(a.jd,a.aot(:,a.iw(n)),'x','Color',cm(n,:));
end;
title(['AERONET time trace, ' a.location ', ' a.level],'Interpreter','none')
ylabel('AERONET AOD'); grid; 

ax3 = subplot(3,1,1);
plot(t(i),tau_aero_noscreening(i,iw(1)),'o','Color',cmj(1,:));
hold on;
plot(a.jd,a.aot(:,a.iw(1)),'x','Color',cmj(1,:));
plot(t(ii),tau_aero_noscreening(ii,iw(1)),'o','Color',cm(1,:));
plot(a.jd(ia),a.aot(ia,a.iw(1)),'x','Color',cm(1,:));
lns = {};
for n=2:length(wvls);
    ln = plot(t(i),tau_aero_noscreening(i,iw(n)),'o','Color',cmj(n,:));
    plot(a.jd,a.aot(:,a.iw(n)),'x','Color',cmj(n,:));
    plot(t(ii),tau_aero_noscreening(ii,iw(n)),'o','Color',cm(n,:));
    plot(a.jd(ia),a.aot(ia,a.iw(n)),'x','Color',cm(n,:));
    lns = {lns{:},ln};
end;

fig_paths = {};

linkaxes([ax1,ax2,ax3],'x');
dynamicDateTicks;
xlim([t(ii(1))-0.0417,t(ii(end))+0.0417]); % limits for the plots plus and minus one hour each side of good 4STAR data
title(['Time trace ' instrumentname ' vs. AERONET for ' a.location ' within ' num2str(max_alt_diff,'%.0f') ' m [Alt] and ' num2str(max_seconds_diff,'%.0f') ' seconds'],'Interpreter','none')
ylabel('AOD');grid;
legend(instrumentname,'AERONET')
colormap(cm)
nms = strtrim(cellstr(num2str(wvls'))');
labels = strread(num2str(wvls,'%5.0f'),'%s');
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
hold off;
if isfolder([getnamedpath('starimg') instrumentname '_' daystr])
    apname = [getnamedpath('starimg') instrumentname '_' daystr filesep];
else
    apname = [getnamedpath('starimg') instrumentname '_' daystr filesep];
    mkdir([getnamedpath('starimg') instrumentname '_' daystr]);
end
fname = fullfile([apname instrumentname '_AERONET_timetrace_' a.location '_' daystr]);
save_fig(gcf(),fname,0);
fig_paths = [fig_paths; [fname '.png']];


%%%%%%%%%%%%%%%
%% plot the scatter plot of AOD 4STAR vs AOD AERONET, with linear fits and differences
figure('pos',[600,50,700,600]);
plot(tau_aero_noscreening(ii,iw(1)),a.aot(iidat,a.iw(1)),'.','Color',cm(1,:));
hold on;
[line,label] = get_linfit(tau_aero_noscreening(ii,iw(1)),a.aot(iidat,a.iw(1)),cm(1,:));
m = rms(tau_aero_noscreening(ii,iw(1))-a.aot(iidat,a.iw(1)));
la =sprintf(',dRMS=%.3f, N=%.0f',m,length(ii));
pln = [line]; lbls = {[label la]};

for n=2:length(wvls);
    plot(tau_aero_noscreening(ii,iw(n)),a.aot(iidat,a.iw(n)),'.','Color',cm(n,:));
    [line,label] = get_linfit(tau_aero_noscreening(ii,iw(n)),a.aot(iidat,a.iw(n)),cm(n,:));
    m = rms(tau_aero_noscreening(ii,iw(n))-a.aot(iidat,a.iw(n))); la =sprintf(',dRMS=%.3f, N=%.0f',m,length(ii));
    pln = [pln(:)',line]; lbls = {lbls{:},[label la]};
end;
yu = max(a.aot(iidat,a.iw(end)));
plot([0,yu],[0,yu],':k')
xlabel([instrumentname ' AOD']);
ylabel(['AERONET AOD at: ' a.location ', ' a.level],'Interpreter','none');
title([instrumentname ' vs. AERONET for ' a.location],'Interpreter','none');
ylim([0,yu]);xlim([0,yu]);
legend(pln,lbls,'location','southeast','FontSize',8)
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile([apname instrumentname '_AERONET_scatter_' a.location '_' daystr]);
save_fig(gcf(),fname,0);
fig_paths = [fig_paths; [fname '.png']];

%%%%%%%%%%%%%%
%% Plot the difference between 4STAR AOD and AERONET AOD as a function of time and airmass
figure('pos',[800,50,600,700]);
ax1 = subplot(2,1,1);
plot(mod(t2utch(t(ii)),24),tau_aero_noscreening(ii,iw(1))-a.aot(iidat,a.iw(1)),'+','Color',cm(1,:));
hold on;
for n=2:length(wvls);
    plot(mod(t2utch(t(ii)),24),tau_aero_noscreening(ii,iw(n))-a.aot(iidat,a.iw(n)),'+','Color',cm(n,:));
end;

new_time = t2utch(t(ii));

ylabel(['AOD difference (' instrumentname '-AERONET)']);
xlabel('UTC from start of day [hours]'); xlim([new_time(1)*0.95,new_time(end)*1.02]);
grid on;
dtv = datevec(t(ii(1)));
[azi,sza,r] = sun(a.long, a.lat,dtv(3), dtv(2), dtv(1), [0:0.1:24.0],[0:0.1:24.0].*0+288.15,[0:0.1:24.0].*0+950.0);
[ax,h1,h2] = plotyy([0],[0.001],[0:0.1:24.0],sza); 
xlim([new_time(1)*0.95,new_time(end)*1.02]);
ylabel(ax(2), 'SZA [^{\circ}]')
hold off;
title(['Difference between ' instrumentname ' and AERONET at: ' a.location],'Interpreter','none')
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

ax2 = subplot(2,1,2);
plot(m_aero(ii),tau_aero_noscreening(ii,iw(1))-a.aot(iidat,a.iw(1)),'+','Color',cm(1,:));
hold on;
get_linfit(m_aero(ii),tau_aero_noscreening(ii,iw(1))-a.aot(iidat,a.iw(1)),cm(1,:));
for n=2:length(wvls);
    plot(m_aero(ii),tau_aero_noscreening(ii,iw(n))-a.aot(iidat,a.iw(n)),'+','Color',cm(n,:));
    get_linfit(m_aero(ii),tau_aero_noscreening(ii,iw(n))-a.aot(iidat,a.iw(n)),cm(n,:));
end;
ylabel(['AOD difference (' instrumentname '-AERONET)']);
xlabel('airmass'); xlim([1,3]);
grid on; hold off;
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile([apname instrumentname '_AERONET_difference_' a.location '_' daystr]);
save_fig(gcf(),fname,0);
fig_paths = [fig_paths; [fname '.png']];

%%%%%%%%%%%%%%%
%% Quantify the C0 changes, and plot the time trace and spectra
% run through the good aod coincidences and make new c0
jidat = find(iidat);
for j=1:length(ii)
    a_aods = interp1(wvls,a.aot(jidat(j),a.iw),w.*1000.0,'pchip');
    c0_A(j,:) = rateaero(ii(j),:) ./ exp(-1.0.*a_aods.*m_aero(ii(j)));
    dc0(j,:) = (c0-c0_A(j,:))./c0.*100.0;
end

figure; 
plot(t(ii),dc0(:,iw(1)),'o-','Color',cm(1,:));
hold on;
plot(t(ii),t(ii).*0.0,'--k');
for n=2:length(wvls)
    plot(t(ii),dc0(:,iw(n)),'o-','Color',cm(n,:));
end
dynamicDateTicks;
xlabel('Time');
ylabel('Diff (c0-c0_from_aeronet)/c0 [%]','Interpreter','none');
title([instrumentname ' c0s to match AERONET AOD at:' a.location],'Interpreter','none')
grid;
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile([apname instrumentname '_AERONET_delta_c0_' a.location '_' daystr]);
save_fig(gcf(),fname,0);
fig_paths = [fig_paths; [fname '.png']];


%  plot ratio of AERONET vs. 4STAR as a function of Azimuth Angle
figure; 
plot(Az_deg(ii),dc0(:,iw(1)),'o-','Color',cm(1,:));
hold on;
plot(Az_deg(ii),Az_deg(ii).*0.0,'--k');
for n=2:length(wvls)
    plot(Az_deg(ii),dc0(:,iw(n)),'o-','Color',cm(n,:));
end
xlabel('Azimuth Angle [degree]');
ylabel('Diff (c0-c0_from_aeronet)/c0 [%]','Interpreter','none');
title([instrumentname ' c0s to match AERONET AOD at:' a.location],'Interpreter','none')
grid;
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile([apname instrumentname '_AERONET_delta_c0_vsAZDeg_' a.location '_' daystr]);
save_fig(gcf(),fname,0);
fig_paths = [fig_paths; [fname '.png']];

%% plot figure of new c0 spectra
figure('pos',[80,50,1000,1000]); 
ax(1) = subplot(3,1,1);
cms = hsv(length(ii)); 
plot(w(1:1044),c0_A(1,1:1044),'o-','Color',cms(1,:));
hold on;
plot(w(1045:end),c0_A(1,1045:end).*10.0,'o-','Color',cms(1,:));
plot(w(1:1044),c0(1:1044),'.','Color','k');
plot(w(1045:end),c0(1045:end).*10.0,'.','Color','k');
labelsd = {datestr(t(ii(1)),'HH:MM:SS')};
for n=2:length(ii)
    plot(w(1:1044),c0_A(n,1:1044),'o','Color',cms(n,:));
    plot(w(1045:end),c0_A(n,1045:end).*10.0,'o','Color',cms(n,:));
    labelsd = {labelsd{:},datestr(t(ii(n)),'HH:MM:SS')};
end
ylabel({'c0 from AERONET';'(10x NIR) [rate/ms]'})
ylim([0,ceil(c0(450).*1.1./100.0)*100.0]);
grid;
title([instrumentname ' new c0 to match AERONET: ' a.location ' - ' daystr],'Interpreter','none')
originalSize1 = get(ax(1), 'Position');
colormap(cms);
cbh = lcolorbar(labelsd,'TitleString','Time','fontweight','bold');
set(ax(1), 'Position', originalSize1);

ax(2) = subplot(3,1,2);
plot(w,dc0(1,:),'.-','Color',cms(1,:));
hold on;
plot(w,w.*0.0,'--k');
for n=2:length(ii)
    plot(w,dc0(n,:),'.-','Color',cms(n,:));
end
ylabel({'Diff';'(c0-c0_from_aeronet)/c0 [%]'},'Interpreter','none');
ylim([-10,10]); grid;

ax(3) = subplot(3,1,3);
plot(w,dc0(1,:),'.-','Color',cms(1,:));
hold on;
plot(w,w.*0.0,'--k');
for n=2:length(ii)
    plot(w,dc0(n,:),'.-','Color',cms(n,:));
end
ylabel('Zoomed c0 Diff [%]');
ylim([-2,2]); grid;

xlabel('Wavelength [{\mu}m]');
linkaxes(ax,'x');
xlim([0.320,1.710]);

cbh.Position(1) = .89-cbh.Position(3);
cbh.Position(4) = 0.8;
cbh.Position(2) = 0.5-cbh.Position(4)/2;
set(ax, {'Position'}, mat2cell(vertcat(ax.Position) .* [1 1 .88, 1], ones(size(ax(:))),4));
fname = fullfile([apname instrumentname '_AERONET_c0_spectra_' a.location '_' daystr]);
save_fig(gcf(),fname,0);
fig_paths = [fig_paths; [fname '.png']];

%% Save the c0s to new file.
filesuffix=[instrumentname '_AODmatch_toAERONET' '_from' a.location]; %_loglogquad';
additionalnotes={['Data C0 built to match AOD from ' instrumentname ' to AERONET spline fit for ' a.location ' within ' ...
    num2str(max_alt_diff,'%.0f') ' m [Alt] and ' num2str(max_seconds_diff,'%.0f') ' seconds, measured on ' daystr '.' ...
    ' Using the AERONET file: ' afile ' as input for this comparison. Date of creation: ' datestr(now)]};
w_vis = w(1:1044);
w_nir = w(1045:end);
vis_c0 = nanmean(c0_A(:,1:1044));
nir_c0 = nanmean(c0_A(:,1045:end));
vis_c0_std = nanstd(c0_A(:,1:1044));
nir_c0_std = nanstd(c0_A(:,1045:end));

visfilename=[daystr '_VIS_C0_' filesuffix '.dat'];
nirfilename=[daystr '_NIR_C0_' filesuffix '.dat'];
disp(['printing to ' getnamedpath('starmat') visfilename])
starsavec0([getnamedpath('starmat') visfilename], fname_starsun, additionalnotes, w_vis, vis_c0, vis_c0_std);
disp(['printing to ' getnamedpath('starmat') nirfilename])
starsavec0([getnamedpath('starmat') nirfilename], fname_starsun, additionalnotes, w_nir, nir_c0, nir_c0_std);

%% Compare the resulting c0s

try
   % get used c0 filename
   for i=1:length(note); if contains(note{i},'VIS_C0'); cofiles = strsplit(note{i}); end; end;
   fig_names = compare_Co_fx({which(cofiles{end}(1:end-1));[getnamedpath('starmat') visfilename]},1);
   for n=1:length(fig_names)
       fig_paths = [fig_paths; fig_names{n}];
   end
catch
    disp('Problem comparing the new C0s')
end
return

function [line,label] = get_linfit(x,y,color)
    p = polyfit(x,y,1);
    xnew = [0.0,x(:)',x(end)*1.2];
    yfit = polyval(p,x);
    yresid = y-yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(y)-1) * var(y);
    rsq = 1 - SSresid/SStotal;
    
    yfitnew = polyval(p,xnew);
    line = plot(xnew,yfitnew,'-','Color',color);

    label = sprintf('y=%.3fx + %.3f, R^2=%.3f',p(1),p(2),rsq);
return

function m = rms(x)
    n = length(x);
    m=sqrt(1/n.*(sum(x.^2)));
return
