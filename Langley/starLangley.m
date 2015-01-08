% A collection of loose codes related to 4STAR Langley calibration. Core
% computation is done in Langley.m, and saving in starsavec0.m.
%
% Yohei, 2012/01/23, 2013/02/19
% Michal, 2015-01-07, added version_set (v 1.0) for version control of this
% script
% Michal, 2015-01-07, added an option to plot Langley with Azdeg
%                     changed version to 1.1
version_set('1.1');

%********************
% set parameters
%********************
daystr='20141002';
stdev_mult=2:0.5:3; % screening criteria, as multiples for standard deviation of the rateaero.
col=408; % for screening. this should actually be plural - code to be developed
cols=[225   258   347   408   432   539   627   761   869   969]; % for plots
savefigure=0;

%********************
% generate a new cal
%********************
if isequal(daystr, '20120722'); % TCAP July 2012
    source='20120722Langleystarsun.mat';
elseif isequal(daystr, '20141002')
    source='20141002starsun_wupdatedForj.mat';
else
    source=[daystr 'starsun.mat'];
end;
file=fullfile(starpaths, source);
load(file, 't', 'w', 'rateaero', 'm_aero','AZstep','Lat','Lon');
AZ_deg_   = AZstep/(-50);
AZ_deg    = mod(AZ_deg_,360); AZ_deg = round(AZ_deg);

starinfofile=fullfile(starpaths, ['starinfo' daystr(1:8) '.m']);
s=importdata(starinfofile);
s1=s(strmatch('langley',s));
eval(s1{:});
ok=incl(t,langley);
[data0, od0, residual]=Langley(m_aero(ok),rateaero(ok,col),stdev_mult,1);
for k=1:numel(stdev_mult);
    ok2=ok(isfinite(residual(:,k))==1);
    [c0new(k,:), od(k,:), residual2, h]=Langley(m_aero(ok2),rateaero(ok2,:), [], cols);
    lstr=setspectrumcolor(h(:,1), w(cols));
    lstr=setspectrumcolor(h(:,2), w(cols));
    hold on;
    h0=plot(m_aero(ok), rateaero(ok,cols), '.','color',[.5 .5 .5]);
    chi=get(gca,'children');
    set(gca,'children',flipud(chi));
    ylabel('Count Rate (/ms) for Aerosols');
    starttstr=datestr(langley(1), 31);
    stoptstr=datestr(langley(2), 13);
    title([starttstr ' - ' stoptstr ', Screened STDx' num2str(stdev_mult(k), '%0.1f')]);
    if savefigure;
        starsas(['star' daystr 'rateaerovairmass' num2str(stdev_mult(k), '%0.1f') 'xSTD.fig, starLangley.m']);
    end;
end;

% plot 500 nm count rate with Az_deg
for k=1;
    figure;
    h2=scatter(Lon(ok), Lat(ok),6,AZ_deg(ok),'filled');
    colorbar;
    ch=colorbarlabeled('AZdeg');
    xlabel('Longitude','FontSize',14);
    ylabel('Latitude','FontSize',14);
    set(gca,'FontSize',14);
    set(gca,'XTick',[-163:0.5:-159]); set(gca,'XTickLabel',[-163:0.5:-159]);
    starttstr=datestr(langley(1), 31);
    stoptstr=datestr(langley(2), 13);
    grid on;
    title([starttstr ' - ' stoptstr ', Screened STDx' num2str(stdev_mult(k), '%0.1f')]);
    if savefigure;
        starsas(['star' daystr 'rateaerovairmass_az' num2str(stdev_mult(k), '%0.1f') 'xSTD.fig, starLangley.m']);
    end;
end;
% plot Lat/Lon with Az_deg
for k=1;
    figure;
    h1=scatter(m_aero(ok), rateaero(ok,cols(4)),6,AZ_deg(ok),'filled');
    colorbar;
    ch=colorbarlabeled('AZdeg');
    xlabel('aerosol Airmass','FontSize',14);
    ylabel('Count Rate (/ms) for Aerosols','FontSize',14);
    set(gca,'FontSize',14);
    set(gca,'XTick',[0:2:14]); set(gca,'XTickLabel',[0:2:14]);
    starttstr=datestr(langley(1), 31);
    stoptstr=datestr(langley(2), 13);
    y = rateaero(ok,cols(4));
    ylim([min(y(:)) max([max(y(:)) data0])]);
    grid on;
    title([starttstr ' - ' stoptstr ', Screened STDx' num2str(stdev_mult(k), '%0.1f')]);
    if savefigure;
        starsas(['star' daystr 'rateaerovairmass_az' num2str(stdev_mult(k), '%0.1f') 'xSTD.fig, starLangley.m']);
    end;
end;

% % show 501 nm only
% set(h0([1 2 3 5 6:10],:),'visible','off','linestyle','none')
% set(h([1 2 3 5 6:10],:),'visible','off','linestyle','none')
% yy=get(gco,'ydata');
% xx=get(gco,'xdata');
% plot(xx, yy.*(100-0.8)/100, '--','color', get(gco,'color'))
% xlabel('Airmass Factor for Aerosols');
% ylabel('Count Rate (/millisecond) for Aerosols');
% title([datestr(langley(1),31) ' - ' datestr(langley(2),13)]);
% if savefigure;
%     versionn=11;
%     starsas(['star' daystr 'Langleyplot501nm_v' num2str(versionn) '.fig, starLangley.m']);
% end;

%********************
% estimate unc
%********************
if isequal(daystr, '20130212') || isequal(daystr, '20130214'); % TCAP February
    c22v=importdata(fullfile(starpaths, '20130212_VIS_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone.dat'));
    c22n=importdata(fullfile(starpaths, '20130212_NIR_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone.dat'));
    c22.data=[c22v.data;c22n.data];
    c7v=importdata(fullfile(starpaths, '20130214_VIS_C0_refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone.dat'));
    c7n=importdata(fullfile(starpaths, '20130214_NIR_C0_refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone.dat'));
    c7.data=[c7v.data;c7n.data];
    unc=abs(c7.data(:,3)./c22.data(:,3)-1)/2; % +/-0.8% FORJ impact and the deviation of the July 7 cal from the July 22.
    unc_TCAP1=sqrt((0.8/100).^2+unc.^2); % +/-0.8% FORJ impact and the deviation of the July 7 cal from the July 22.
    c0unc=c0new.*unc';
elseif isequal(daystr, '20120722'); % TCAP July 2012
    c22v=importdata(fullfile(starpaths, '20120722_VIS_C0_refined_Langley_on_G1_second_flight_screened_2x_withOMIozone.dat'));
    c22n=importdata(fullfile(starpaths, '20120722_NIR_C0_refined_Langley_on_G1_second_flight_screened_2x_withOMIozone.dat'));
    c22.data=[c22v.data;c22n.data];
    c7v=importdata(fullfile(starpaths, '20120707_VIS_C0_refined_Langley_on_G1_second_flight_screened_2x_withOMIozone.dat'));
    c7n=importdata(fullfile(starpaths, '20120707_NIR_C0_refined_Langley_on_G1_second_flight_screened_2x_withOMIozone.dat'));
    c7.data=[c7v.data;c7n.data];
    unc=sqrt((1.6/100).^2+(c7.data(:,3)./c22.data(:,3)-1).^2); % 1.6% FORJ impact and the deviation of the July 7 cal from the July 22.
    c0unc=c0new.*unc';
end;

%********************
% compare with a previous cal
%********************
% set parameters
daystr0='20120722';
filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity';
daystr0='20130212';
filesuffix='refined_Langley_on_G1_second_flight_screened_2x';
filesuffix='refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone';
% read the previous cal
visfilename=[daystr0 '_VIS_C0_' filesuffix '.dat'];
nirfilename=[daystr0 '_NIR_C0_' filesuffix '.dat'];
if exist(fullfile(starpaths,visfilename))
    a=importdata(fullfile(starpaths,visfilename));
    b=importdata(fullfile(starpaths,nirfilename));
    c00=[a.data(:,3)' b.data(:,3)'];
    c00w=[a.data(:,2)' b.data(:,2)']/1000;
    viscols=1:1044;
    nircols=1044+(1:512);
    factor=[ones(size(viscols)) ones(size(nircols))*10];
    % plot
    figure;
    h0=starplotspectrum(c00w, abs(c00).*factor, [], viscols, nircols);
    set(h0(2:3),'color',[.5 .5 .5]);
    hold on;
    clr=[0 0 1;0 .5 0; 1 0 0];
    lstr=repmat({},numel(stdev_mult)+1,1);
    for k=1:numel(stdev_mult);
        h(:,k)=starplotspectrum(w, abs(c0new(k,:)).*factor, [], viscols, nircols);
        hold on;
        set(h(2:3,k),'color',clr(k,:));
        lstr(k)={[daystr ', ' num2str(stdev_mult(k),'%0.1f') 'xSTD']};
    end;
    lstr=[lstr {daystr0}];
    set(gca,'yscale','linear','ylim',[0 1000]);
    lh=legend([h(3,:) h0(3)],lstr);
    set(lh,'fontsize',12,'location','northeast');
    ylabel('C0 (/ms)');
    if savefigure;
        starsas(['star' daystr 'C0spectra.fig, starLangley.m']);
    end;
    figure;
    sh=semilogx(w,(abs(c0new)-repmat(abs(c00),size(stdev_mult(:))))./repmat(abs(c00),size(stdev_mult(:)))*100, '.');
    for k=1:numel(stdev_mult);
        set(sh(k),'color',clr(k,:));
    end;
    gglwa;
    hold on
    plot(xlim, [0 0], '-k');
    grid on;
    ylabel('relative C0 change (new-old)/old *100%');
    % lh=legend(['Relative change (%) since ' daystr0]);
    % set(lh,'fontsize',12,'location','northeast');
    lh=legend(sh,lstr(1:end));
    set(lh,'fontsize',12,'location','best');
    title(['relative C0 change (%) since ' daystr0]);
    if savefigure;
        starsas(['star' daystr 'C0spectraratio.fig, starLangley.m']);
    end;
end;

%********************
% save new c0
%********************
k=1; % select one of the multiple screening criteria (stdev_mult), or NaN (see below).
if isnumeric(k) && k>=1; % save results from the screening/regression above
    c0unc=NaN(size(w)); % put NaN for uncertainty - to be updated later
    % filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozone';
    % filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity';
    % filesuffix='refined_Langley_on_G1_second_flight_screened_2x';
    % additionalnotes='Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging.';
    filesuffix='refined_Langley_on_C-130_calib_flight_screened_2x_wFORJcorr';
    % additionalnotes='Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging.';
    additionalnotes=['Data outside ' num2str(stdev_mult(k), '%0.1f') 'x the STD of 501 nm Langley residuals were screened out.'];
    % additionalnotes='Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging. The Langley results were lowered by 0.8% in order to represent the middle FORJ sensitivity.';
elseif isequal(k, 'addunc'); % add unc to an existing c0 file
    daystr='20120722';
    originalfilesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity'
    filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity_updatedunc'
    for kk=1:2;
        if kk==1;
            spec='VIS';
        elseif kk==2;
            spec='NIR';
        end;
        a=importdata(fullfile(starpaths, [daystr '_' spec '_C0_' originalfilesuffix '.dat']));
        if kk==1;
            w=a.data(:,2)';
            c0new=a.data(:,3)';
        elseif kk==2;
            w=[w a.data(:,2)'];
            c0new=[c0new a.data(:,3)'];
        end;
    end;
    source='20120722Langleystarsun.mat';
    c0unc=c0new.*unc_TCAP1';
    additionalnotes='Uncertainty was given by combining 0.8% FORJ impact and difference/2 between Feb 12 and 14 2013 air Langley results. Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging. The Langley results were lowered by 0.8% in order to represent the middle FORJ sensitivity.';
    k=1;
    viscols=(1:1044)';
    nircols=1044+(1:512)';
elseif ~isfinite(k); % save after averaging
    daystr='20130212';
    originalfilesuffix='refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone';
    daystr2='20130214';
    originalfilesuffix2='refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone';
    for kk=1:2;
        if kk==1;
            spec='VIS';
        elseif kk==2;
            spec='NIR';
        end;
        filesuffix=[originalfilesuffix '_averagedwith20130214'];
        a=importdata(fullfile(starpaths, [daystr '_' spec '_C0_' originalfilesuffix '.dat']));
        b=importdata(fullfile(starpaths, [daystr2 '_' spec '_C0_' originalfilesuffix2 '.dat']));
        if kk==1;
            w=(a.data(:,2)'+b.data(:,2)')/2;            
            c0new=(a.data(:,3)'+b.data(:,3)')/2;
            c0unc=(a.data(:,4)'+b.data(:,4)')/2;
        elseif kk==2;
            w=[w (a.data(:,2)'+b.data(:,2)')/2];            
            c0new=[c0new (a.data(:,3)'+b.data(:,3)')/2];
            c0unc=[c0unc (a.data(:,4)'+b.data(:,4)')/2];
        end;
    end;
    source='(SEE ORIGINAL FILES FOR SOURCES)';
    additionalnotes=['Average of the ' daystr ' and ' daystr2 ' Langley C0, ' originalfilesuffix ' and ' originalfilesuffix2 '.'];
    k=1;
    viscols=(1:1044)';
    nircols=1044+(1:512)';
end;
visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);
starsavec0(visfilename, source, additionalnotes, w(viscols), c0new(k,viscols), c0unc(:,viscols));
starsavec0(nirfilename, source, additionalnotes, w(nircols), c0new(k,nircols), c0unc(:,nircols));
% be sure to modify starc0.m so that starsun.m will read the new c0 files.

%********************
% save invalid c0
%********************
if now==datenum([2013 1 25 6 36 0]); % record keeping
    daystr='99999999';
    filesuffix='invalid';
    visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
    nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);
    additionalnotes='';
    starsavec0(visfilename, source, additionalnotes, w(viscols), ones(size(viscols))*-1, ones(size(viscols))*-1);
    starsavec0(nirfilename, source, additionalnotes, w(nircols), ones(size(nircols))*-1, ones(size(nircols))*-1);
end;
