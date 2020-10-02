function fig_paths = compare_star_2_aeronet();
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
% -------------------------------------------------------------------------

%% start of function
version_set('1.1')

%% load the file
fp = getnamedpath('starsun');
[file pname fi]=uigetfile2('*starsun*.mat','Find starsun file for comparison .mat',fp);

disp(['Loading the matlab file: ' pname file])
[daystr, filen, datatype, instrumentname]=starfilenames2daystr({[pname file]});
max_alt_diff = 200.0
max_seconds_diff = 360.0

try; 
    load([pname file],'t','tau_aero_noscreening','w','m_aero','rawrelstd','Alt');
catch;
    load([pname file]);
end;

fp = getnamedpath('starsun');
[afile apname afi]=uigetfile2('*.lev10; *.lev15; *.lev20','Select the aeronet file containing AOD (level 1.0, 1.5, or 2.0)',fp);
a = aeronet_read_lev([apname afile]);

%% filter out the bad aod 4STAR
i = (rawrelstd(:,1) < 0.008)&(tau_aero_noscreening(:,400)<1.5)&(tau_aero_noscreening(:,1503)>(-0.02))&(tau_aero_noscreening(:,400)>0.0)&(Alt>(a.elev-max_alt_diff))&(Alt<(a.elev+max_alt_diff));

%% knnsearch to find the closest times to compare aeronet and 4STAR data
% make sure to only have unique valuesSL331125766198

[t_un,it_un] = unique(t(i));
[idat,datdt] = knnsearch(t_un,a.jd);
iidat = datdt<max_seconds_diff/(3600.0*24.0); % Distance no greater than 60.0 seconds.

it = find(i); 
ii = it(it_un(idat(iidat)));
ia = iidat;

%% match aeronet wvls to 4STAR's
wvls = a.wlen(a.anywlen==1);
a.iw = find(a.anywlen==1);
iw = wvls;
for n=1:length(wvls);
    [nul,in] = min(abs(wvls(n)-w*1000.0));
    iw(n) = in;
end;

%% plot the output and correlate
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
title(['Time trace ' instrumentname ' vs. AERONET for ' a.location ' within ' num2str(max_alt_diff,'%.0f') ' m [Alt] and ' num2str(max_seconds_diff,'%.0f') ' seconds'],'Interpreter','none')
ylabel('AOD');grid;
legend(instrumentname,'AERONET')
colormap(cm)
nms = strtrim(cellstr(num2str(wvls'))');
labels = strread(num2str(wvls,'%5.0f'),'%s');
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
hold off;
apname = getnamedpath('starfig');
fname = fullfile([apname instrumentname '_AERONET_timetrace_' a.location '_' daystr]);
save_fig(gcf(),fname,0);
fig_paths = [fig_paths; [fname '.png']];

% plot the scatter plot of AOD 4STAR vs AOD AERONET, with linear fits and
% differences
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

% Plot the difference between 4STAR AOD and AERONET AOD as a function of
% airmass
figure('pos',[800,50,600,700]);
ax1 = subplot(2,1,1);
plot(mod(t2utch(t(ii)),24),tau_aero_noscreening(ii,iw(1))-a.aot(iidat,a.iw(1)),'+','Color',cm(1,:));
hold on;
for n=2:length(wvls);
    plot(mod(t2utch(t(ii)),24),tau_aero_noscreening(ii,iw(n))-a.aot(iidat,a.iw(n)),'+','Color',cm(n,:));
end;

ylabel(['AOD difference (' instrumentname '-AERONET)']);
xlabel('UTC from start of day [hours]'); xlim([0,24])
grid on;
dtv = datevec(t(ii(1)));
[azi,sza,r] = sun(a.long, a.lat,dtv(3), dtv(2), dtv(1), [0:0.1:24.0],[0:0.1:24.0].*0+288.15,[0:0.1:24.0].*0+950.0);
[ax,h1,h2] = plotyy([0],[0.001],[0:0.1:24.0],sza); 
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