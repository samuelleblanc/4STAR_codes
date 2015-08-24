% a collection of loose codes for processing SEAC4RS data in field.
% Yohei, 2013/06/17, being modified from TCquickplots.m.
% Yohei, 2013/07/28, some parts have been removed from this code and organized into SEstarbasicplots.m.

%********************
% set variables
%********************
savefigure=true;

%********************
% process data for multiple days
%********************
dslist={'20130802' '20130803' '20130805' '20130806' '20130807' '20130808' '20130812' '20130814' '20130816' '20130818' '20130819' '20130821' '20130823'}; % 20130804star.mat does not have "sun" in any of its data fields.
dslist={'20140513'}; % 20130804star.mat does not have "sun" in any of its data fields.

for i=1:numel(dslist);
    daystr=dslist{i};
    if exist(fullfile(starpaths, [daystr 'starsun.mat']))
        error([daystr 'starsun.mat exists.']);
    end;
    starsun(fullfile(starpaths, [daystr 'star.mat']),fullfile(starpaths, [daystr 'starsun.mat']));
end;

%********************
% plot for multiple days
%********************
daystrlist={'20130706' '20130708' '20130709' '20130710' '20130711' '20130712'};
daystrlist={'20140513'};
clr='ycbgmr'; % the order John used for July 08-12 MLO data

% comparison with aats
for i=1:numel(daystrlist);
    [both(i), ~, aats]=staraatscompare(daystrlist{i});
end;
for j=1:13;
    figure;
    yyall=[];
    for i=1:numel(daystrlist);
        plot(both(i).m_aero, both(i).rateratiotoaats(:,j), '.', 'color',clr(i));
        yyall=[yyall;both(i).rateratiotoaats(:,j)];
        hold on;
    end;
    ggla;
    grid on;
    xlim([0 20]);
    ylim([0.95 1.05]*nanmean(yyall));
    xlabel('Aerosol Airmass Factor');
    ylabel('4STAR/AATS');
    title([num2str(both(1).aatsw(j)*1000, '%0.0f') ' nm']);
    lh=legend(daystrlist);
    set(lh,'fontsize',12,'location','best');
    if savefigure;
        starsas(['star' daystrlist{1} 'thru' daystrlist{end} 'rateratiotoAATSvm_aero' num2str(both(1).aatsw(j)*1000, '%0.0f') 'nmonly.fig, SEquickplots.m'])
    end;
end;

% comparison with aats
figure;
c=408;
for i=1:numel(daystrlist);
    ssl(daystrlist{i}, 'm_aero','rateaero');
    plot(m_aero, rateaero(:,c), '.','color',clr(i));
    hold on;
end;

% transmittance ratio for each day, as a function of temperature
slsun('20130712','w');
for i=1:numel(daystrlist);
    visfilename=fullfile(starpaths,[daystrlist{i} '_VIS_C0_refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x.dat']);
    nirfilename=fullfile(starpaths,[daystrlist{i} '_NIR_C0_refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x.dat']);
    if exist(visfilename) && exist(nirfilename);
        vis=importdata(visfilename);
        nir=importdata(nirfilename);
        c0(i,:)=[vis.data(:,3)' fliplr(nir.data(:,3)')];
    else
        c0(i,:)=NaN(1,1044+512);
    end;
end;
visfilename=fullfile(starpaths,['20130708_VIS_C0_refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x_averagethru20130712.dat']);
nirfilename=fullfile(starpaths,['20130708_NIR_C0_refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x_averagethru20130712.dat']);
vis=importdata(visfilename);
nir=importdata(nirfilename);
c0avg=[vis.data(:,3)' fliplr(nir.data(:,3)')];
for i=1:numel(daystrlist);
    [both(i), ~, aats]=staraatscompare(daystrlist{i});
end;
for i=1:numel(daystrlist);
    if any(isfinite(c0(i,:)))
        res(i).trratio_c0oftheday=both(i).trratio.*repmat(c0avg(both(i).c(2,1:13))./c0(i,both(i).c(2,1:13)),size(both(i).t,1),1);
    end;
end;
figure;
cols=4;
for i=1:numel(daystrlist);
    if any(isfinite(c0(i,:)))
        starload(daystrlist{i},'track');
        for k=1:4;
            T(:,k)=interp1(track.t,track.T1,both(i).t);
            Tsm(:,k)=boxxfilt(both(i).t, interp1(track.t,track.T1,both(i).t), 300/86400);
        end;
        pht(i)=plot(Tsm(:,1), res(i).trratio_c0oftheday(:,cols), '.','color',clr(i));
        hold on;
        clear T Tsm;
    else
        pht(i)=NaN;
    end;
end;
plot(xlim, [1 1], '-k');
ggla;
grid on;
ylim([0.96 1.04]);
xlabel('T1 Elevation Motor Temp., 5 min avg.');
ylabel('4STAR(/C0 of the day)/AATS Tr. Ratio');
title([num2str(both(end).aatsw(cols)*1000, '%0.0f') ' nm']);
lh=legend(pht(isfinite(pht)),daystrlist(isfinite(pht)));
set(lh,'fontsize',12,'location','best');
if savefigure;
    starsas(['star' daystrlist{1} 'thru' daystrlist{end} 'trratioofthedayvT15minavg' num2str(both(1).aatsw(end)*1000, '%0.0f') 'nmonly.fig, SEquickplots.m'])
end;

%********************
% make ad hoc analyses
%********************
% 20130830 - prepare to plot
daystr='20130830';
evalstarinfo(daystr,'flight');
evalstarinfo(daystr,'horilegs');
cols=407;
slsun(daystr, 't','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'rateaero', 'tau_aero', 'tau_aero_noscreening', 'c0', 'm_aero');
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
downloaddir=fullfile(starpaths, '\download\AERONET');
aeronetfilename='130830_130830_SEARCH-Centreville2.lev15'; % '130830_130830_IMPROVE-MammothCave.lev15'
an=importdata(fullfile(downloaddir,aeronetfilename));
an.t=str2num(cell2mat(an.textdata(6:end,3)))+datenum([2012 12 31]);

anunc=[0.02 0.02 0.01 0.01 0.01 0.01 0.01 0.01]; ! check with Tom Ech.
cclist=[4 5 6 7 13 16 18 19];
for cc=1:numel(cclist);
    try
        an.aod(:,cc)=str2num(cell2mat(an.textdata(6:end,cclist(cc))));
    catch;
        an.aod(:,cc)=str2num(char(an.textdata(6:end,cclist(cc))));
    end;
end;
an.aod=fliplr(an.aod);
clear cc cclist;
an.w=fliplr([1640	1020	870	675	500	440	380	340]/1000);
an.note=['Generated on ' datestr(now,31) ' from ' aeronetfilename '.'];
if ~isempty(strfind(aeronetfilename, 'SEARCH-Centreville'));
an.lon=-87.250;
an.lat=32.903;
an.elev=126;
tlim=[horilegs(3,1) horilegs(4,1)]; % this needs to be updated
elseif ~isempty(strfind(aeronetfilename, 'IMPROVE-MammothCave'));
an.lon=-86.148;
an.lat=37.132;
an.elev=235;
tlim=[horilegs(1,2) horilegs(2,2)]; % this needs to be updated
end;
showcols=2:8;
cc=interp1(log(w),1:numel(w),log(an.w),'nearest');

% 20130830 - vertical profile
figure;
[h,filename]=sssun(daystr, 'tau_aero', 'Alt', 24, 't', ...
    'cols',cols,'xlim',[0 0.5],'title',daystr,'savefigure',1);

% 20130830 - vertical profile
figure;
[h,filename]=sssun(daystr, 'tau_aero', 'Alt', 24, 'Lat', ...
    'cols',cols,'xlim',[0 0.5],'title',daystr,'savefigure',1);

% 20130830 - vertical profile
rows=incl(Alt, [0 1000]);
figure;
[h,filename]=sssun(daystr, 'Lon','Lat', 24, 'tau_aero', ...
    'rows',rows,'cols',cols,'clim',[0 0.3],'title',daystr,'savefigure',1);

% 20130830 - comparison with AERONET vertical profile
figure;
[h,filename]=spsun(daystr, 'tau_aero', 'Alt', '.', ...
    'cols',cc(showcols),'tlim',tlim);
hold on;
pha=plot(an.aod(incl(an.t,tlim),showcols), repmat(an.elev,size(incl(an.t,tlim))), 's','markersize',6,'linewidth',2,'markerfacecolor','w');
lstr=setspectrumcolor(pha,an.w(showcols));
axis tight;
ax=axis;
axis([0 ax(2) 0 ax(4)]);
title([daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)]);
xlabel('Aerosol Optical Depth');
filename=['star' daystr datestr(t(1),'HHMMSS') '_' datestr(t(end),'HHMMSS') 'tau_aerovertprof_AERONET' aeronetfilename];
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

% 20130827 - prepare to plot
daystr='20130827';
evalstarinfo(daystr,'flight');
evalstarinfo(daystr,'horilegs');
cols=407;
slsun(daystr, 't','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'rateaero', 'tau_aero', 'tau_aero_noscreening', 'c0', 'm_aero');
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
starload(daystr, 'track');
track.T=[track.T1 track.T2 track.T3 track.T4];
track.P=[track.P1 track.P2 track.P3 track.P4];
bl=60/86400;
for i=1:4;
    track.Tsm(:,i)=boxxfilt(track.t, track.T(:,i), bl);
    track.Psm(:,i)=boxxfilt(track.t, track.P(:,i), bl);
end;
for i=1:4;
    Tsm(:,i)=interp1(track.t, track.Tsm(:,i), t);
    Psm(:,i)=interp1(track.t, track.Psm(:,i), t);
end;
clear i;

% 20130827 - airmass and temperature at high altitude legs
tlim=[horilegs(1,1) horilegs(4,2)]; % this needs to be updated
figure;
[h,filename]=spsun(daystr, 't', Tsm, '-', ...
    't', 'm_ray', '.b', 't', 'm_aero', '.c', ...
    'tlim', tlim, 'savefigure',0);
lh=legend(h, starfieldname2label('T1'), starfieldname2label('T2'), starfieldname2label('T3'), starfieldname2label('T4'), ...
    starfieldname2label('m_ray'), starfieldname2label('m_aero'));
set(lh,'interpreter','none', 'fontsize',12,'location','best');
title(daystr);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

% 20130827 - high altitude legs
tlim=[horilegs(1,1) horilegs(4,2)]; % this needs to be updated
figure;
[h, filename]=spsun(daystr, 't', Alt/100000, '-k', 't', 'tau_aero', '.', ...
    'cols',cols, 'tlim',tlim);
lh=legend(h, 'GPS Alt. (km) /100', [num2str(w(cols)*1000, '%0.0f') ' nm AOD']);
set(lh,'fontsize',12,'location','best');
title(daystr);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

% 20130827 - Langley plot from high altitude horizontal legs
stdev_mult=2:0.5:3; % screening criteria, as multiples for standard deviation of the rateaero.
ok=incl(t,horilegs);
ok2=incl(t,horilegs,m_aero,[5 15.4]);
[data0, od0, residual]=Langley(m_aero(ok),rateaero(ok,cols),stdev_mult,1);
[data2, od2, residual2]=Langley(m_aero(ok2),rateaero(ok2,cols),stdev_mult,1);
k=1;
close;close;
i=1;
cla=starfieldname2label(['T' num2str(i)]);
figure;
[h,filename]=sssun(daystr, 'm_aero', 'rateaero', 24, Tsm(:,i), ...
    'rows', ok, 'cols',cols,'clabel', cla, 'xlim',[0 16], ...
    'yscale','log','ytick',0:10:1000,'ylim', [470 601]);
hold on;
plot(0, c0(cols), '*k','linewidth',2);
ph=plot(xlim, exp(-xlim*od2(k))*data2(k), '-');
lh=legend(ph,'regression for m_aero between 5 and 14');
set(lh,'interpreter','none', 'fontsize',12,'location','northeast');
title(daystr);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

% 20130826 - prepare to plot
daystr='20130826';
evalstarinfo(daystr,'flight');
evalstarinfo(daystr,'horilegs');
cols=[407 1044+40];
slsun(daystr, 't','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'rateaero', 'tau_aero', 'tau_aero_noscreening', 'c0', 'm_aero');
colsang=[332 872];% colsang=[345 658];
ang=sca2angstrom(tau_aero(:,colsang), w(colsang));
ang_noscreening=sca2angstrom(tau_aero_noscreening(:,colsang), w(colsang));

% 20130826 - cloud screening
figure;
[h,filename]=spsun(daystr, 't', tau_aero_noscreening, '.', 't', tau_aero, '.', 't', Alt/1e4, '-k', ...
    't', ang_noscreening/10, '.', 't', ang/10, '.', ...
    'cols', cols, 'ylabel', 'tau_aero', ...
    'filename', ['star' daystr 'tau_aerotseries' ]);
set(h(1:2),'color',[.5 .5 .5]);
set(h(5:6),'color',[.5 .5 .5]);
set(h(7),'color','r');
lh=legend;
set(lh,'visible','off');

% 20130823 - prepare to plot
daystr='20130823';
evalstarinfo(daystr,'flight');
evalstarinfo(daystr,'horilegs');
evalstarinfo(daystr,'vertprof');
cols=407;
slsun(daystr, 't','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'rateaero', 'tau_aero', 'tau_aero_noscreening', 'c0', ...
    'QdVtot', 'QdVlr', 'QdVtb','AZ_deg','pitch','roll');
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
colsang=[332 872];% colsang=[345 658];
ang=sca2angstrom(tau_aero(:,colsang), w(colsang));
ang_noscreening=sca2angstrom(tau_aero_noscreening(:,colsang), w(colsang));

% 20130823 wall
tlim=horilegs(2,:); % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lon', 'Alt', 24, 'tau_aero','cols', cols, ...
    'tlim',tlim, ...
    'xlim', [-94 -90.5], ...
    'ylim', [0 12000], ...
    'clim', [0 0.35], ...
    'clabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130823 wall
tlim=horilegs(2,:); % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'tau_aero', 'Alt', 24, 'Lon','cols', cols, ...
    'tlim',tlim, ...
    'clim', [-94 -90.5], ...
    'ylim', [0 12000], ...
    'xlim', [0 0.35], ...
    'xlabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130823 cloud screening
figure;
[h,filename]=sssun(daystr, 't', 'tau_aero', 24, ang_noscreening, ...
    'cols',cols, 'clim', [0 1.5]);

% 20130823 tracking
rows=incl(Alt, [11000 Inf]);
figure;
[h,filename]=sssun(daystr, QdVlr./QdVtot, 'tau_aero', 24, mod(AZ_deg,360), ...
    'clim',[0 360],'rows',rows, 'cols',cols);
figure;
[h,filename]=spsun(daystr, QdVlr./QdVtot, 'tau_aero_noscreening', '.-', ...
    'rows',rows, 'cols',cols);
figure;
[h,filename]=spsun(daystr, QdVtb./QdVtot, 'tau_aero', '.-', ...
    'rows',rows, 'cols',cols);
figure;
[h,filename]=sssun(daystr, QdVlr./QdVtot, 'tau_aero_noscreening', 24, abs(QdVtb./QdVtot), ...
    'rows',rows, 'cols',cols, 'clim', [0 0.4], 'clabel', 'abs(Quad (T-B)/Total)');
set(h,'linewidth',2);
xlabel('Quad (L-R)/Total');
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

figure;
[h,filename]=spsun(daystr, 't', 'tau_aero_noscreening', '.', ...
    'rows',rows,'cols',cols);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

figure;
[h,filename]=spsun(daystr, 't', abs(roll)/100, '.-', ...
    'rows',rows,'cols',cols);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

figure;
[h,filename]=spsun(daystr, 't', QdVlr./QdVtot, 'k.-', ...
    'rows',rows,'cols',cols);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m']);
end;

figure;
[h,filename]=sssun(daystr, QdVtb./QdVtot, 'tau_aero_noscreening', 24, abs(QdVlr./QdVtot), ...
    'rows',rows, 'cols',cols, 'clim', [0 0.4]);
set(h,'linewidth',2);

% 20130821 - prepare to plot
daystr='20130821';
evalstarinfo(daystr,'flight');
evalstarinfo(daystr,'horilegs');
evalstarinfo(daystr,'vertprof');
cols=407;
slsun(daystr, 't','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'rateaero', 'tau_aero', 'c0');
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);

% 20130821 - vertprofs during a vertical profile
tlim=vertprof(1,:); % this needs to be updated
figure;
[h,filename]=spsun(daystr, 'tau_aero', 'Alt', '.', 'cols', [visc(3:9) nirc(11:13)+1044], ...
    'tlim',tlim, ...
    'xlabel', 'Aerosol Optical Depth', ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130821 - vertprofs in the N-S boundary layer segment
tlim=[vertprof(1,1) t(end)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lat', 'Alt', 24, 'tau_aero','cols', cols, ...
    'tlim',tlim, ...
    'ylim', [0 4200], ...
    'clabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130819 - prepare to plot
daystr='20130819';
evalstarinfo(daystr,'flight');
evalstarinfo(daystr,'horilegs');
evalstarinfo(daystr,'vertprof');
cols=407;
slsun(daystr, 't','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'rateaero', 'tau_aero', 'c0');
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
colsang=[332 872];% colsang=[345 658];
ang=sca2angstrom(tau_aero(:,colsang), w(colsang));

% 20130819 - vertprofs
tlim=vertprof(1,:); % this needs to be updated
figure;
[h,filename]=spsun(daystr, 'tau_aero', 'Alt', '.', 'cols', [visc(3:9) nirc(11:13)+1044], ...
    'tlim',tlim, ...
    'xlabel', 'Aerosol Optical Depth', ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);
if savefigure;
    starsas('star20130816190713202358500nmAODAltitudemLongitude.fig, sssun.m')
end;

% 20130819 - vertprofs
tlim=[vertprof(1)-300/86400 vertprof(2,2)]; % this needs to be updated
tlim=[vertprof(3,1) vertprof(4,2)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'tau_aero', 'Alt', 24, 'Lat','cols', cols, ...
    'tlim',tlim, ...
    'xlabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130819 - vertprofs 
tlim=[vertprof(1)-300/86400 vertprof(2,2)+300/86400]; % this needs to be updated
tlim=[vertprof(3,1) vertprof(4,2)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lat', 'Alt', 24, 'tau_aero','cols', cols, ...
    'tlim',tlim, ...
    'clim', [0 0.8], ...
    'clabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130819 - vertprofs and horizontal legs
tlim=[vertprof(1)-300/86400 vertprof(2,2)+300/86400]; % this needs to be updated
tlim=[vertprof(3,1) vertprof(4,2)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lat', 'Alt', (tau_aero*50).^2, ang,'cols', cols, ...
    'tlim',tlim, ...
    'clim', [0 2], ...
    'clabel', ['Angstrom Exponent ' num2str(w(colsang(1))*1000, '%0.0f') 'nm/' num2str(w(colsang(2))*1000, '%0.0f') 'nm'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',0);
hold on;
lms=[0.2 0.5 0.8]; % legend marker size
lstr={[num2str(w(cols)*1000,'%0.0f') ' nm AOD']};
for i=1:3;
    sh(i)=plot(-100,0,'o','markersize', lms(i)*50);
    hold on;
    lstr{i+1}=num2str(lms(i)');
end;
sh(i+1)=plot(-100,0,'.','color',[0.99 0.99 0.99], 'markersize',1, 'visible','off');
lh=legend(sh([end 1:end-1])', lstr');
set(lh,'fontsize',12,'location','best');
if savefigure;
    starsas(['star' daystr datestr(tlim(1),'HHMMSS') datestr(tlim(end),'HHMMSS') num2str(w(cols)*1000, '%0.0f') 'nmAngAltLat.fig, sssun.m'])
end;

% 20130819 - vertprofs during horizontal legs
tlim=[vertprof(1)-300/86400 vertprof(2,2)+300/86400]; % this needs to be updated
tlim=[vertprof(3,1) vertprof(4,2)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, ang, 'Alt', 24, 'Lat', 'cols', cols, ...
    'tlim',tlim, ...
    'xlim', [0 2.5], ...
    'clabel', ['Angstrom Exponent ' num2str(w(colsang(1))*1000, '%0.0f') 'nm/' num2str(w(colsang(2))*1000, '%0.0f') 'nm'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',0);
if savefigure;
    starsas(['star' daystr datestr(tlim(1),'HHMMSS') datestr(tlim(end),'HHMMSS') num2str(w(cols)*1000, '%0.0f') 'nmAngAltLat.fig, sssun.m'])
end;

% 20130819 - vertprofs during horizontal legs
event=1;cevent=2;
if event==1;
    tlim=[vertprof(1) vertprof(2,2)]; % this needs to be updated
    rows=incl(t, tlim, Lat, [44 45], Alt, [1000 2300]);
    ax=[-105 -104 43.8 44.8];
elseif event==2;
    tlim=[vertprof(3,1) vertprof(4,2)]; % this needs to be updated
    rows=incl(t, tlim, Lat, [37 37.5], Alt, [0 2000]);
    ax=[-101 -99 36.6 37.9];
end;
if cevent==1;
    cc='tau_aero';
    cstr=[num2str(w(cols)*1000, '%0.0f') ' nm PRELIMINARY AOD'];
    cl=[0.4 0.8];
elseif cevent==2;
    cc=ang;
    cstr=[num2str(w(cols)*1000, '%0.0f') ' nm PRELIMINARY Angstrom Exponent'];
    cl=[1.8 2.5];
end;
figure;
h=spvis(daystr, 'Lon','Lat', '-');
set(h,'linewidth',1,'marker','none','color',[.5 .5 .5]);
lh=legend;
set(lh,'visible','off');
axis(ax);
hold on;
[h,filename]=sssun(daystr, 'Lon', 'Lat', 64, cc, 'cols', cols, ...
    'rows',rows, ...
    'title',[daystr ' ' datestr(t(rows(1)),13) ' - ' datestr(t(rows(end)),13)], ...
    'clim', cl, 'clabel', cstr, ...
    'savefigure',0);
set(h,'linewidth',2);
if savefigure;
    starsas([filename '.fig, SEquickplots.m'])
end;

% 20130819 - spectra
tlim=[vertprof(1) vertprof(2,2)]; % this needs to be updated
rows=incl(t, tlim, Lat, [44 45], Alt, [1000 2300]);
figure;
h=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
ylim([0.01 2]);
ylabel('Optical Depth');
title([daystr ' ' datestr(t(rows(1)),13) ' - ' datestr(t(rows(end)),13) ' Average']);
filename=['star' daystr datestr(t(rows(1)),'HHMMSS') '_' datestr(t(rows(end)),'HHMMSS') 'tau_aerospectra'];
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;

% 20130819 - spectra
tlim=[vertprof(3,1) vertprof(4,2)]; % this needs to be updated
rows=incl(t, tlim, Lat, [37 37.5], Alt, [0 2000]);
figure;
h=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
ylim([0.01 2]);
ylabel('Optical Depth');
title([daystr ' ' datestr(t(rows(1)),13) ' - ' datestr(t(rows(end)),13) ' Average']);
filename=['star' daystr datestr(t(rows(1)),'HHMMSS') '_' datestr(t(rows(end)),'HHMMSS') 'tau_aerospectra'];
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;

% 20130816 - prepare to plot
daystr='20130816';
evalstarinfo(daystr,'flight');
evalstarinfo(daystr,'horilegs');
evalstarinfo(daystr,'vertprof');
cols=407;
slsun(daystr, 't','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'rateaero', 'tau_aero', 'c0');
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
starload(daystr, 'track');
track.T=[track.T1 track.T2 track.T3 track.T4];
track.P=[track.P1 track.P2 track.P3 track.P4];
bl=60/86400;
for i=1:4;
    track.Tsm(:,i)=boxxfilt(track.t, track.T(:,i), bl);
    track.Psm(:,i)=boxxfilt(track.t, track.P(:,i), bl);
end;
for i=1:4;
    Tsm(:,i)=interp1(track.t, track.Tsm(:,i), t);
    Psm(:,i)=interp1(track.t, track.Psm(:,i), t);
end;

% 20130816 - temperature and transmittance
tr=rateaero./repmat(c0,size(t));
tlim=[flight(1) vertprof(1)]; % this needs to be updated
rows=incl(t,tlim);
figure;
plot(Tsm(rows,:), tr(rows,cols), '.');
hold on
plot(Tst(rows), tr(rows,cols), '.k');
ggla;
grid on;
ylim([0.9 1]);
xlabel(['Temperature (^oC) smoothed over ' num2str(bl*86400) 's (not Tst)']);
ylabel([num2str(w(cols)*1000, '%0.0f') ' nm Transmittance']);
lh=legend(starfieldname2label('T1'),starfieldname2label('T2'), ...
    starfieldname2label('T3'),starfieldname2label('T4'), ...
    'Tst');
set(lh,'fontsize',12,'location','best');
title([daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)]);
filename=['star' daystr datestr(tlim(1),'HHMMSS') '_' datestr(tlim(end),'HHMMSS') 'Tr' num2str(w(cols)*1000, '%0.0f') 'nmTrvTsm'];
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;

% 20130816 - vertprofs during horizontal legs
tlim=[vertprof(1) horilegs(end)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'tau_aero', 'Alt', 24, 'Lon','cols', cols, ...
    'tlim',tlim, ...
    'clim',[-104.2 -103.6], ...
    'xlabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'xlim',[0 0.55], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',0);
colormap(flipud(jet));
if savefigure;
    starsas('star20130816190713202358500nmAODAltitudemLongitude.fig, sssun.m')
end;

% 20130816 - map colorcoded with 500 nm AOD, for <4 km alt
tlim=[vertprof(1) horilegs(end)]; % this needs to be updated
altlim=[0 4000];
rows=incl(t, tlim, Alt, altlim);
figure;
[h,filename]=sssun(daystr, 'Lon', 'Lat', 24, 'tau_aero','cols', cols, ...
    'rows',rows, ...
    'xlim', [-104.2 -103.5], ...
    'clabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13) ', Alt. ' num2str(altlim(1)) ' - ' num2str(altlim(end)) ' m'], ...
    'savefigure',savefigure);

% 20130816 - vertprofs colorcoded with time
tlim=[vertprof(1) horilegs(end)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lon', 'Alt', 24, 't',...
    'tlim',tlim, ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130816 - vertprofs colorcoded with AOD
tlim=[vertprof(1) horilegs(end)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lon', 'Alt', 24, 'tau_aero',...
    'cols',cols, ...
    'tlim',tlim, ...
    'xlim', [-104.4 -103.5], ...
    'clabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130816 - map colorcoded with 500 nm AOD, for a constant alt
tlim=horilegs(3,:); % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lon', 'Lat', 24, 'tau_aero','cols', cols, ...
    'tlim',tlim, ...
    'xlim', [-104.2 -103.5], ...
    'clabel', [num2str(w(cols)*1000, '%0.0f') ' nm AOD'], ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130816 - one horizontal leg
tlim=horilegs(3,:); % this needs to be updated; tlim=[datenum('2013/08/16 19:49:45') horilegs(3,2)]; % this needs to be updated
figure;
[h,filename]=spsun(daystr, 'Lon', 'tau_aero', '.', ...
    'cols',[visc(3:9) nirc(11:13)+1044], ...
    'tlim',tlim, ...
    'xlim', [-104.4 -103.5], ...
    'ylabel', 'Aerosol Optical Depth', ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130816 - spectra, for <4 km alt
tlim=[vertprof(1) horilegs(end)]; % this needs to be updated
altlim=[0 4000];
lonlim=-104.15:0.2:-103.55;
clr=hsv(numel(lonlim)-1);
figure;
for i=1:numel(lonlim)-1;
    rows=incl(t, tlim, Alt, altlim,Lon,lonlim(i:i+1));
    h(:,i)=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
    hold on;
    set(h(1,i),'color',clr(i,:));
    lstr{i}=['Lon=[' num2str(lonlim(i)) '^o ' num2str(lonlim(i+1)) '^o]'];
end;
set(h(2:end,:),'color', [.5 .5 .5]);
ylim([0.01 1]);
lh=legend(h(1,:), lstr);
set(lh,'fontsize',12,'location','best');
title([daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13) ', Alt. ' num2str(altlim(1)) ' - ' num2str(altlim(end)) ' m']);
filename=['star' daystr datestr(tlim(1),'HHMMSS') '_' datestr(tlim(end),'HHMMSS') 'tau_aerospectra'];
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;

% 20130814 - prepare to plot
daystr='20130814';
evalstarinfo(daystr,'horilegs');
cols=407;
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);

% 20130814 - vertprofs during horizontal legs
tlim=[horilegs(1) horilegs(end)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lat', 'Alt', 24, 'tau_aero','cols', cols, ...
    'clim',[0 0.3], 'xlim',[34.5 37], ...
    'ylim',[0 8000], ...
    'clabel', [num2str(w(cols)*1000,'%0.0f') ' nm AOD'], ...
    'tlim',tlim, ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130814 - vertprofs during horizontal legs
tlim=[horilegs(1) horilegs(end)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'tau_aero', 'Alt', 24, 'Lat','cols', cols, ...
    'xlim',[0 0.32], 'clim',[34.5 37], ...
    'xlabel', [num2str(w(cols)*1000,'%0.0f') ' nm AOD'], ...
    'tlim',tlim, ...
    'title',[daystr ' ' datestr(tlim(1),13) ' - ' datestr(tlim(end),13)], ...
    'savefigure',savefigure);

% 20130814 - average spectra for horizontal legs
for i=1:size(horilegs,1);
    figure;
    rows=incl(t, horilegs(i,:));
    h=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
    ylim([0.01 1]);
    ylabel('Optical Depth');
    title([daystr ' ' datestr(horilegs(i,1),13) ' - ' datestr(horilegs(i,2),13) ' Average']);
    filename=['star' daystr datestr(horilegs(i,1),'HHMMSS') '_' datestr(horilegs(i,2),'HHMMSS') 'tau_aerospectra'];
    if savefigure;
        starsas([filename '.fig, ' mfilename '.m'])
    end;
end;

% 20130813 - prepare to plot
daystr='20130813';
starload(daystr, 'track');
track.T=[track.T1 track.T2 track.T3 track.T4];
track.P=[track.P1 track.P2 track.P3 track.P4];
bl=60/86400;
for i=1:4;
    track.Tsm(:,i)=boxxfilt(track.t, track.T(:,i), bl);
    track.Psm(:,i)=boxxfilt(track.t, track.P(:,i), bl);
end;
for i=1:4;
    Tsm(:,i)=interp1(track.t, track.Tsm(:,i), t);
    Psm(:,i)=interp1(track.t, track.Psm(:,i), t);
end;
evalstarinfo(daystr,'groundcomparison');
cols=407;
aatsgoodviscols=[1:7 9];
aatsgoodnircols=[11 13]; % "You should ignore AATS 1.2 um." says Phil, Aug. 13, 2013.
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
[both, ~, aats]=staraatscompare(daystr);
both.rows=incl(both.t, tlim);
for i=1:size(both.trratio,2);
    trratiosm(:,i)=boxxfilt(both.t,both.trratio(:,i),bl);
end;
clear i;

% 20130813 - Tr ratio v. UTC, Temperature or air mass
xlist={'t' 'T1' 'm_aero'};
xlist={'t'};
for k=xlist;
    if isequal(k{:}, 'T1');
        param=Tsm(:,1);
        xstr=[starfieldname2label('T1') ', smoothed over ' num2str(bl*86400) 's'];
    else
        eval(['param=' k{:} ';']);
        xstr=starfieldname2label(k{:});
    end;
    figure;
    ph=plot(param(incl(t, groundcomparison)), trratiosm(incl(t, groundcomparison),1:13), '.');
    hold on;
    plot(xlim, [1 1], '-k');
    lstr=setspectrumcolor(ph, w(both.c(2,1:13)));
    for i=1:13;
        texty(ph(i), [num2str(w(both.c(2,i))*1000, '%0.0f') ' nm'], round(numel(t)*0.1));
    end;
    set(ph(10), 'markersize',1,'visible','off');
    set(ph([8 12]), 'markersize',1);
    ggla;
    grid on;
    ylim([0.9 1.1]);
    lh=legend(ph, lstr);
    set(lh,'fontsize',12,'location','best','visible','off');
    xlabel(xstr);
    ylabel(['Tr. Ratio, 4STAR/AATS, smoothed over ' num2str(bl*86400) 's']);
    title([daystr ' ' datestr(groundcomparison(1), 13) ' - ' datestr(groundcomparison(end), 13)]);
    if savefigure;
        starsas(['star' daystr 'trratiov' k{:} '.fig, ' mfilename '.m'])
    end;
end;

% 20130812 - prepare to plot
daystr='20130812';
evalstarinfo(daystr,'horilegs');
cols=407;
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);

% 20130812 - vertprofs during horizontal legs
tlim=[horilegs(2,1) horilegs(3,2)]; % this needs to be updated
figure;
[h,filename]=sssun(daystr, 'Lon', 'Alt', 24, 'tau_aero','cols', cols,'tlim',tlim,'title',[daystr ', ' num2str(w(cols)*1000,'%0.0f') ' nm']);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;

% 20130812 - vertprofs during horizontal legs
figure;
[h,filename]=sssun(daystr, 'tau_aero', 'Alt', 24, 'Lon',...
    'xlim',[0 0.12], 'cols', cols,'tlim',tlim,'title',[daystr ', ' num2str(w(cols)*1000,'%0.0f') ' nm']);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;

% 20130812 - vertprofs during horizontal legs
figure;
[h,filename]=spsun(daystr, 'tau_aero', 'Alt', '.',...
    'cols', [visc(3:9) nirc(11:13)+1044],'tlim',tlim,'title',daystr);
lstr=setspectrumcolor(h, w([visc(3:9) nirc(11:13)+1044]));
lh=legend(h,lstr);
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;

% 20130812 - average spectra for horizontal legs
for i=1:size(horilegs,1);
    figure;
    rows=incl(t, horilegs(i,:));
    h=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
    ylim([0.01 1]);
    ylabel('Optical Depth');
    title([daystr ' ' datestr(horilegs(i,1),13) ' - ' datestr(horilegs(i,2),13) ' Average']);
    filename=['star' daystr datestr(horilegs(i,1),'HHMMSS') '_' datestr(horilegs(i,2),'HHMMSS') 'tau_aerospectra'];
    if savefigure;
        starsas([filename '.fig, ' mfilename '.m'])
    end;
end;

% 20130808 - prepare to plot
daystr='20130808';
slsun(daystr, 't','w', 'Pst', 'Tst', ...
    'aerosolcols','viscols','nircols', ...
    'raw', 'rateaero', 'tau_aero', 'tau_aero_polynomial', 'c0');
tr=rateaero./repmat(c0,size(t));
cols=407;
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
evalstarinfo(daystr,'transect');
evalstarinfo(daystr,'horileg');
evalstarinfo(daystr,'vertprof');
starload(daystr, 'track');
track.T=[track.T1 track.T2 track.T3 track.T4];
track.P=[track.P1 track.P2 track.P3 track.P4];
bl=60/86400;
for i=1:4;
    track.Tsm(:,i)=boxxfilt(track.t, track.T(:,i), bl);
    track.Psm(:,i)=boxxfilt(track.t, track.P(:,i), bl);
end;
for i=1:4;
    Tsm(:,i)=interp1(track.t, track.Tsm(:,i), t);
    Psm(:,i)=interp1(track.t, track.Psm(:,i), t);
end;
clear i;

% 20130808 - photon countes correlation with alt, T, P or something
figure;
ph=plot(t,tr(:,cols),'k.', t,raw(:,cols)/28100,'.', t,Tst/1000+1, '.r',t,Pst/5000+0.9, 'c.',...
   'linewidth',3);
set(ph(2),'color',[.5 .5 .5]);
ylim([0.9 1]);
ggla;
grid on;
lh=legend([num2str(w(cols)*1000, '%0.0f') ' nm transmittance'], ...
[num2str(w(cols)*1000, '%0.0f') ' nm raw counts/28100'],...
'Tst(degC)/1000+1','Pst(hPa)/5000+0.9');
set(lh,'fontsize',12,'location','best');
xlabel('UTC');
title(daystr);
dateticky('x','keeplimits');
if savefigure;
    starsas(['star' daystr num2str(w(cols)*1000, '%0.0f') 'nmTrtseries.fig, ' mfilename '.m'])
end;

% 20130808 - photon countes correlation with alt, T, P or something
figure;
ph=plot(Tsm,tr(:,cols),'.');
xlim([-20 5]);
ylim([0.9 1]);
set(ph([2 3 4]), 'markersize',1, 'visible','off');
ggla;
grid on;
xlabel(starfieldname2label('T1'));
ylabel([num2str(w(cols)*1000, '%0.0f') ' nm transmittance']);
title(daystr);
if savefigure;
    starsas(['star' daystr num2str(w(cols)*1000, '%0.0f') 'nmTrtseriesvT1.fig, ' mfilename '.m'])
end;

% 20130808 - East-West transects over the Gulf of Mexico
figure;
ang=polyfit2ang(0.5,tau_aero_polynomial(:,1),tau_aero_polynomial(:,2),tau_aero_polynomial(:,3));
[h,filename]=sssun(daystr, 'Lon', 'Alt', tau_aero*1000, ang, 'cols',cols,'rows',incl(t, transects),'title',daystr,'clim',[-0.5 2]); 
tau_aero_polynomial(:,1);
ch=colorbarlabeled('Angstrom Exponent at 500 nm');
hold on; % start adding a legend for marker size
lms=[0.1 0.2 0.3]; % legend marker size 
lstr={[num2str(w(cols)*1000,'%0.0f') ' nm AOD']};
for i=1:3;
    sh(i)=plot(-100,0,'o','markersize', lms(i)*50);
    lstr{i+1}=num2str(lms(i)');
end;
sh(i+1)=plot(-100,0,'.','color',[0.99 0.99 0.99], 'markersize',1, 'visible','off');
lh=legend(sh([end 1:end-1])', lstr');
set(lh,'fontsize',12,'location','best'); % end adding a legend for marker size
if savefigure;
    starsas([filename 'tau_aeroang500nm.fig, ' mfilename '.m']);
end;

% 20130808 - leg average spectra
for i=1:size(horileg,1);
    figure;
    rows=incl(t, horileg(i,:));
    h=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
    ylim([0.01 1]);
    ylabel('Optical Depth');
    title([daystr ' ' datestr(horileg(i,1),13) ' - ' datestr(horileg(i,2),13) ' Average']);
    filename=['star' daystr datestr(horileg(i,1),'HHMMSS') '_' datestr(horileg(i,2),'HHMMSS') 'tau_aerospectra'];
    if savefigure;
        starsas([filename '.fig, ' mfilename '.m'])
    end;
end;

% 20130808 - vertprofs
for i=1:size(vertprof,1);
    figure;
    [h,filename]=spsun(daystr, 'tau_aero', 'Alt', '.', 'cols',[visc(3:9) nirc(11:13)+1044],'tlim',vertprof(i,:),'title',daystr,'clim',[-0.5 2]);
    lstr=setspectrumcolor(h, w([visc(3:9) nirc(11:13)+1044]));
    lh=legend(h,lstr);
    set(lh,'fontsize',12,'location','northeast');
    xlabel('Aerosol Optical Depth');
    xlim([0 0.32]);
    ylim([0 7000]);
    title([daystr ' ' datestr(vertprof(i,1),13) ' - ' datestr(vertprof(i,2),13)]);
    filename=['star' daystr datestr(vertprof(i,1),'HHMMSS') '_' datestr(vertprof(i,2),'HHMMSS') 'tau_aerospectra'];
    if savefigure;
        starsas([filename '.fig, ' mfilename '.m'])
    end;
end;

% 20130806, smoke (above clouds) - prepare to plot
dslist={'20130806' '20130807'};
evalstarinfo(dslist{1}, 'smoke'); % get the time period
slsun(dslist{1},'t','w','m_aero', 'tau_aero','aerosolcols', 'viscols', 'nircols');
rows=incl(t, smoke);
col=407;
c0corrfactor=load(fullfile(starpaths, ['star' dslist{1} 'c0corrfactor.dat']));
tau_aero_scaled=tau_aero+(1./m_aero)*log(c0corrfactor);

% 20130806, smoke (above clouds) - Altitude time series, color-coded with 500 nm AOD
xy={'Lon','Lat'; 't','Alt'};
for k=1:size(xy,1);
    figure;
    for i=1:numel(dslist);
        spvis(dslist{i},xy{k,:},'.');
        hold on;
    end;
    for i=1:numel(dslist);
        [h,filename]=sssun(dslist{i}, xy{k,:}, 24, 'tau_aero', 'cols', col, 'clim', [0 0.3]);
        set(h,'linewidth',2);
    end;
    ch=colorbarlabeled([num2str(w(col)*1000,'%0.0f') ' nm AOD']);
    lh=legend;
    set(lh,'string', {'in or below clouds'; 'Zenith mode'; 'Sky Scan A'; 'Sky Scan P'})
    if savefigure;
        starsas(['star' daystr filename(5:end) '.fig'])
    end;
end;

% 20130806, smoke (above clouds) - average spectra against wavelength
ylist={'tau_aero'; 'tau_aero_scaled'};
for k=1:size(ylist,1);
    eval(['y=' ylist{k} ';']);
    figure;
    h=starplotspectrum(w, nanmean(y(rows,:),1), aerosolcols, viscols, nircols);
    ylim([0.01 1]);
    ylabel('Optical Depth');
    title([dslist{1} ' ' datestr(smoke(1), 13) ' - ' datestr(smoke(2), 13) ' Average']);
    if savefigure;
        starsas(['star' dslist{1} datestr(smoke(1), 'HHMMSS') datestr(smoke(2), 'HHMMSS') ylist{k} 'spectra.fig'])
    end;
end;

% 20130806, smoke (above clouds) - map color-coded with 500-nm AOD
xy={'Lon','Lat'; 't','Alt'};
for k=1:size(xy,1);
    figure;
    h0=spvis(dslist{1}, xy{k,:},'.', ...
        'tlim',smoke,'cols',col);
    set(h0,'markersize',3);
    lh=legend;
    set(lh,'visible','off');
    hold on;
    [h,filename]=sssun(dslist{1}, xy{k,:},24,'tau_aero', ...
        'tlim',smoke,'cols',col,'clim', [0 0.8]);
    set(h,'linewidth',2);
    if k==2;
        ylim([0 1300]);
    end;
    ch=colorbarlabeled([num2str(w(col)*1000,'%0.0f') ' nm AOD']);
    title([dslist{1} ' ' datestr(smoke(1), 13) ' - ' datestr(smoke(2), 13)]);
    if savefigure;
        starsas(['star' dslist{1} datestr(smoke(1), 'HHMMSS') datestr(smoke(2), 'HHMMSS') filename(5:end) '.fig'])
    end;
end;

figure;
[h,filename]=sssun(dslist{1}, 't','Alt',24,'tau_aero', ...
    'tlim',smoke,'cols',col);
if savefigure;
    starsas(['star' dslist{1} datestr(smoke(1), 'HHMMSS') datestr(smoke(2), 'HHMMSS') filename(5:end) '.fig'])
end;


% for 20130618 and 20130619 SARP flights: obtain reference tau aero because no calibration is available
refdaystr='20130618';
evalstarinfo(refdaystr, 'highalt');
ssl(refdaystr,'t','tau_aero','w','Alt','aerosolcols','viscols','nircols');
ok=incl(t, highalt);
tau_aero_ref=nanmean(tau_aero(ok,:));

% plot the 20130618 high altitude reference tau aero, just to see what it
% is like against the TCAP winter cal
figure;
tlim=highalt;
ok=incl(t, tlim);
h=starplotspectrum(w, tau_aero(ok,:), aerosolcols, viscols, nircols);
hold on
href=starplotspectrum(w, tau_aero_ref, aerosolcols, viscols, nircols);
set(gca,'yscale','linear');
set(href(1),'visible','off');
set(href(2),'color','b');
set(href(3),'color','r');
ylim([-1 1]*0.3);
hold on
plot(xlim, [0 0], '-k');
starttstr=datestr(tlim(1),13);
stoptstr=datestr(tlim(2),13);
ylabel('Optical Depth');
lh=legend([href(2)], 'average');
set(lh,'fontsize',12,'location','best');
title([refdaystr ' the ' num2str(nanmean(Alt(ok)), '%0.0f') ' \pm ' num2str(nanstd(Alt(ok)), '%0.0f') ' m leg ' starttstr ' - ' stoptstr]);
if savefigure;
    starsas('20130618highalt_tau_aero.fig, SEquickplots.m')
end;

% plot a 20130618 low altitude tau aero
figure;
tlim=horilegs(end,:);
ok=incl(t, tlim);
h=starplotspectrum(w, tau_aero(ok,:), aerosolcols, viscols, nircols);
set(h, 'color', [.5 .5 .5]);
hold on;
% h2=starplotspectrum(w, nanmean(tau_aero(ok,:))-tau_aero_ref, aerosolcols, viscols, nircols);
h2=starplotspectrum(w, tau_aero(ok,:)-repmat(tau_aero_ref,size(ok)), aerosolcols, viscols, nircols);
set(gca,'yscale','linear');
ylim([-1 1]*0.3);
starttstr=datestr(tlim(1),13);
stoptstr=datestr(tlim(2),13);
ylabel('Optical Depth');
title([refdaystr ' avg over the ' num2str(nanmean(Alt(ok)), '%0.0f') ' \pm ' num2str(nanstd(Alt(ok)), '%0.0f') ' m leg ' starttstr ' - ' stoptstr]);
lh=legend([h(2) h2(2)], 'TCAP winter cal', 'high alt subtracted');
set(lh,'fontsize',12,'location','best');
if savefigure;
    starsas('20130618lowalt_tau_aero.fig, SEquickplots.m')
end;

% 20130618 4STAR AATS comparison wavelength by wavelength, with the high alt ref (see above) subtracted
[both, ~, aats]=staraatscompare(daystr);
for ii=1:13;
    figure;
    %     ph=plot(both.t(rowsground),both.tau_aero_noscreening(rowsground,c(ii)), '.b',aats.t,aats.tau_aero(ii,:), '.');
    ph=plot(both.t(rowsground),both.tau_aero_noscreening(rowsground,c(ii)), '.b', ...
        both.t(rowsground),both.tau_aero_noscreening(rowsground,c(ii))-repmat(tau_aero_ref(c(ii)),size(rowsground)), '.b', ...
        aats.t,aats.tau_aero(ii,:), '.');
    set(ph(1),'color',[0.5 0.5 0.5]);
    set(ph(end),'color',[0 0.5 0],'markersize',12);
    ggla;
    grid on;
    xl=xlim;
    xlim([max([xl(1) floor(t(1))]) min([xl(2) floor(t(end))])])
    datetick('x','keeplimits');
    xlabel('Time');
    yl=ylim;
    ylim([max([yl(1) 0]) min([yl(2) 0.3])]);
    ylabel('tau_aero_noscreening','interpreter','none');
    title(daystr);
    lh=legend(ph, ['4STAR ' num2str(both.w(c(ii))*1000, '%0.2f') ' nm'],...
        '4STAR - high alt',...
        ['AATS ' num2str(aats.w(ii)*1000, '%0.2f') ' nm']);
    set(lh,'fontsize',12,'location','best');
    if savefigure;
    starsas(['star' daystr 'AATStau_aero_' num2str(aats.w(ii)*1000, '%0.0f') 'nm.fig'])
    end;
end

% 20130618 4STAR AATS comparison in spectra, with the high alt ref (see above) subtracted
for i=1:size(groundcomparison,1);
    tlim=groundcomparison(i,:);
    ok=incl(t, tlim);
    figure;
    h=starplotspectrum(w, tau_aero(ok,:), aerosolcols, viscols, nircols);
    h=findobj(gca,'type','line');
    set(h, 'color', [.5 .5 .5]);
    hold on;
    h2=starplotspectrum(w, tau_aero(ok,:)-repmat(tau_aero_ref,size(ok)), aerosolcols, viscols, nircols);
    hold on;
    ah=plot(aats.w, nanmean(aats.tau_aero(:,incl(aats.t,tlim)),2)', '.', 'markersize',12,'color', [0 0.5 0])
    set(gca,'yscale','linear');
    ylim([-1 1]*0.3);
    starttstr=datestr(tlim(1),13);
    stoptstr=datestr(tlim(2),13);
    ylabel('Optical Depth');
    title([refdaystr ' on the ground ' starttstr ' - ' stoptstr]);
    lh=legend([h(2) h2(2) ah], 'TCAP winter cal', 'high alt subtracted', 'AATS-14');
    set(lh,'fontsize',12,'location','best');
    if savefigure;
        starsas(['star' daystr datestr(tlim(1),'HHMMSS') datestr(tlim(2),'HHMMSS') 'ground_tau_aero.fig, SEquickplots.m'])
    end;
end;

%********************
% old codes inherited from TCAP
%********************
% raw counts
figure;
shn=starplot(s, {'t', 'raw', '.', 'markersize',12}, 'all', c);
if isequal(datatype, 'nir_sun');
    hold on;
    shv=starplot(vis_sun, {'t', 'raw', '.', 'markersize',12}, 'all', visc(3:8));
    gg=findobj(gca,'color', [.5 .5 .5]);
    set(gg,'visible','off');
    hold on;
    ph=plot(s.t, s.Alt*10, '.', 'color',[.5 .5 .5]);
    lstr=setspectrumcolor([shv(:,2); shn(:,2)], [vis_sun.w(visc(3:8)) nir_sun.w(c)])
    lstr=[lstr {'Alt. (m) * 10'}];
    lh=legend([shv(:,2); shn(:,2); ph], lstr);
    set(lh,'fontsize',12,'location','best');
    axis tight
end;
if savefigure;
    starsas(get(gcf,'filename'));
end;

% count rate
figure;
starplot(s, {'t', 'rate', '.', 'markersize',12}, 'all', c);
if savefigure;
    starsas(get(gcf,'filename'));
end;

% tau aero noscreening
figure;
shn=starplot(s, {'t', 'tau_aero_noscreening', '.', 'markersize',12}, 'all', c);
if isequal(datatype, 'nir_sun');
    hold on;
    shv=starplot(vis_sun, {'t', 'tau_aero_noscreening', '.', 'markersize',12}, 'all', visc(3:8));
    gg=findobj(gca,'color', [.5 .5 .5]);
    set(gg,'visible','off');
    hold on;
    ph=plot(s.t, s.Alt/10000, '.', 'color',[.5 .5 .5]);
% [ph, ax] = superimposealt(s.t, s.Alt)
    lstr=setspectrumcolor([shv(:,2); shn(:,2)], [vis_sun.w(visc(3:8)) nir_sun.w(c)]);
    lstr=[lstr {'Alt. (km) / 10'}];
    lh=legend([shv(:,2); shn(:,2); ph], lstr);
    set(lh,'fontsize',12,'location','best');
    axis tight
end;
if savefigure;
    if isequal(datatype, 'nir_sun');
        starsas(['star' daystr '_999_VISandNIR_SUN_Time_tau_aero_noscreening.fig']);
    else
        starsas(['star' daystr '_999_VIS_SUN_Time_tau_aero_noscreening.fig']);
    end;
end;
% vis_sun.tod=-log(vis_sun.rate./repmat(data0total,size(vis_sun.t)))./repmat(vis_sun.m_aero,size(vis_sun.w));


% tau aero on alt
figure;
cc=447;
daystr=starfilenames2daystr(s.filename,1);
cl=find(rem(s.flag(:,cc)*10,1)*10-rem(s.flag(:,cc)*100,1)*100>0);
plot(s.t(cl),s.Alt(cl),'o','color','k', 'markersize',3);
hold on;
noncl=ones(size(s.t));
noncl(cl)=0;
noncl(isfinite(s.tau_aero(:,cc))==1 | s.Str==0)=0;
plot(s.t(noncl==1),s.Alt(noncl==1),'x','color','k', 'markersize',12);
addi=load(fullfile(starpaths, [daystr 'star.mat']));
if isfield(addi, 'vis_zen');
    plot(addi.vis_zen.t, addi.vis_zen.Alt, '+', 'color', [.5 .5 .5],'markersize',6);
end;
if isfield(addi, 'vis_skya');
    addis=addi.vis_skya;
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            plot(addis(i).t, addis(i).Alt, '>', 'color', [.5 .5 .5],'markersize',6);
        end;
    end;
end;
if isfield(addi, 'vis_skyp');
    addis=addi.vis_skyp;
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            plot(addis(i).t, addis(i).Alt, '^', 'color', [.5 .5 .5],'markersize',6);
        end;
    end;
end;
cstr=['tau aero at ' upper(datatype(1:3)) ' #' num2str(cc) ' (' num2str(s.w(cc)*1000, '%0.1f') ' nm)'];
cstr='PRELIMINARY 532nm AOD';
[sh,filename]=scattery(s.t, 'Time', ...
    s.Alt, 'Altitude (m)', ...
    ones(size(s.t))*24, '', ...
    s.tau_aero(:,cc), cstr);
datetick('x','keeplimits');
yl=ylim;
ylim([0 yl(2)]);
cax=caxis;
if cax(2)<0.1;
    caxis([0 0.1]);
else
    caxis([0 0.300001]);
end;
title(daystr);
if savefigure
    starsas(['star' daystr filename '.fig, TCquickplots.m']);
end;
        
daystr='20120717';
air=load(fullfile(starpaths, [daystr 'air.mat']));
load(fullfile(starpaths, [daystr 'starsun.mat']), 't','w','Alt','tau_aero','flag','Str','tau_aero_polynomial');
cc=447;
ang=(-2)*tau_aero_polynomial(:,1)*log(w)-repmat(tau_aero_polynomial(:,2),1,length(w));
cc=407;
figure;
cl=find(rem(flag(:,cc)*10,1)*10-rem(flag(:,cc)*100,1)*100>0);
ph=plot(air.t,air.GPS_MSL_Alt,'-',t(cl),Alt(cl),'o','color','k', 'markersize',3);
set(ph(1),'color',[.5 .5 .5], 'linewidth',3);
hold on;
noncl=ones(size(t));
noncl(cl)=0;
noncl(isfinite(tau_aero(:,cc))==1 | Str==0)=0;
plot(t(noncl==1),Alt(noncl==1),'x','color','k', 'markersize',6);
addi=load(fullfile(starpaths, [daystr 'star.mat']));
if isfield(addi, 'vis_zen');
    plot(addi.vis_zen.t, addi.vis_zen.Alt, '+', 'color', [.5 .5 .5],'markersize',6);
end;
if isfield(addi, 'vis_skya');
    addis=addi.vis_skya;
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            plot(addis(i).t, addis(i).Alt, '>', 'color', [.5 .5 .5],'markersize',6);
        end;
    end;
end;
if isfield(addi, 'vis_skyp');
    addis=addi.vis_skyp;
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            plot(addis(i).t, addis(i).Alt, '^', 'color', [.5 .5 .5],'markersize',6);
        end;
    end;
end;
% cstr='PRELIMINARY 532nm AOD';
% cstr='532 nm AOD';
% [sh,filename]=scattery(t, 'Time', ...
%     Alt, 'Altitude (m)', ...
%     ones(size(t))*24, '', ...
%     tau_aero(:,cc), cstr);
% cstr=['PRELIMINARY ' num2str(w(cc)*1000,'%0.0f') ' nm Angstrom Exponent'];
cstr=[num2str(w(cc)*1000,'%0.0f') ' nm Angstrom Exponent'];
[sh,filename]=scattery(t, 'Time', ...
    Alt, 'Altitude (m)', ...
    ones(size(t))*24, '', ...
    ang(:,cc), cstr);
datetick('x','keeplimits');
yl=ylim;
ylim([0 yl(2)]);
cax=caxis;
if cax(2)<0.1;
    caxis([0 0.1]);
else
    caxis([0 0.300001]);
end;
title(daystr);
if savefigure
    versionn=11;
    starsas(['star' daystr filename 'v' num2str(versionn) '.fig, TCquickplots.m']);
end;


% angstrom (VIS and NIR combined)
max(abs(nir_sun.t-vis_sun.t))*86400
[a2,a1,a0,ang,curvature]=polyfitaod([vis_sun.w(visc(3:9)) nir_sun.w(nirc(11:13))],[vis_sun.tau_aero_noscreening(:,visc(:,3:9)) nir_sun.tau_aero_noscreening(:,nirc(11:13))]);

% mean spectra
figure;
meanalt=zeros(size(horilegs,1),1);
for i=1:size(horilegs,1);
    xl=horilegs(i,:);
    % xl=xlim;
    vis_sun.rows=incl(vis_sun.t,xl);
    nir_sun.rows=incl(nir_sun.t,xl);
    if ~isempty(vis_sun.rows);
    lh(:,i)=loglog(vis_sun.w, nanmean(vis_sun.tau_aero(vis_sun.rows,:)), 'b.', ...
        nir_sun.w, nanmean(nir_sun.tau_aero(nir_sun.rows,:)), '.', ...
        'markersize',6);
    meanalt(i)=nanmean(vis_sun.Alt(vis_sun.rows));
    end;
    hold on;
%     set(lh(2),'color', [1 0.5 0]);
    grid on;
    ylim([0.01 1]);
    gglwa;
    ylabel('tau aero');
end;
cc=mean(horilegs,2);
cstr='Time';
cc=meanalt;
cstr='Altitude (m)';
recolor(lh(1,:), cc);
recolor(lh(2,:), cc);
ch=colorbarlabeled(cstr);
% datetick(ch,'y','keeplimits');
starttstr=datestr(horilegs(1,1), 30);
stoptstr=datestr(horilegs(end,2), 30);
title([ daystr ' Horizontal Leg Averages']);
if savefigure;
    starsas(['star' starttstr stoptstr(10:end) 'tau_aero_meanspectrum' formalizefieldname(cstr) '.fig']);
end;

% title([datestr(xl(1), 31) ' - ' datestr(xl(2), 13) ', Alt. (m) = ' num2str(nanmean(vis_sun.Alt(vis_sun.rows)), '%0.2f')]);
% starttstr=datestr(xl(1), 30);
% stoptstr=datestr(xl(2), 30);
% if savefigure;
%     starsas(['star' starttstr stoptstr(10:end) 'tau_aero_meanspectrum.fig']);
% end;

% multiple spectra
xl=horileg(4,:);
vis_sun.rows=incl(vis_sun.t,xl);
nir_sun.rows=incl(nir_sun.t,xl);
figure;
lh=loglog(vis_sun.w, vis_sun.tau_aero(vis_sun.rows,:), '.', ...
    nir_sun.w, nir_sun.tau_aero(nir_sun.rows,:), '.', ...
    'markersize',12);
lh=reshape(lh,numel(lh)/2,2);
ll=recolor(lh(:,1), vis_sun.t(vis_sun.rows));
ll=recolor(lh(:,2), nir_sun.t(nir_sun.rows));
grid on;
ylim([0.01 1]);
gglwa;
ylabel('tau aero');
title([datestr(xl(1), 31) ' - ' datestr(xl(2), 13) ', Alt. (m) = ' num2str(nanmean(vis_sun.Alt(vis_sun.rows)), '%0.2f')]);
starttstr=datestr(xl(1), 30);
stoptstr=datestr(xl(2), 30);
if savefigure;
    starsas(['star' starttstr stoptstr(10:end) 'tau_aero_noscreening_meanspectrum.fig']);
end;

% 3d color - take long
figure;
sh=scatter3(vis_sun.Lon(vis_sun.rows), ...
    vis_sun.Lat(vis_sun.rows), ...
    vis_sun.Alt(vis_sun.rows), ...
    ones(size(vis_sun.rows))*36, ...
    vis_sun.tau_aero_noscreening(vis_sun.rows,408), 'filled');
xlabel('Longitude');
ylabel('Latitude');
zlabel('Altitude (m)');
set(gca,'linewidth',1,'fontsize',12);
ch=colorbarlabeled('tau aero noscreening');
title(daystr);
starttstr=datestr(xl(1), 30);
stoptstr=datestr(xl(2), 30);
caxis([0.65 0.86]);
if savefigure;
    starsas(['star' starttstr stoptstr(10:end) '3dflighttrack_color_tau_aero_noscreening.fig']);
end;

% another 3d color - take long
figure;
cc=408;
sh=scatter3(vis_sun.Lon(vis_sun.rows), ...
    vis_sun.Lat(vis_sun.rows), ...
    vis_sun.Alt(vis_sun.rows), ...
    markersize(vis_sun.tau_aero_noscreening(vis_sun.rows,cc)*100), ...
    ang(vis_sun.rows,2), 'filled');
xlabel('Longitude');
ylabel('Latitude');
zlabel('Altitude (m)');
set(gca,'linewidth',1,'fontsize',12);
ch=colorbarlabeled(['Angstrom Exponent at VIS#' num2str(cc)]);
title(daystr);
starttstr=datestr(xl(1), 30);
stoptstr=datestr(xl(2), 30);
caxis([1 1.5]);
if savefigure;
    starsas(['star' starttstr stoptstr(10:end) '3dflighttrack_color_AngstromExponentVIS' num2str(cc) '.fig']);
end;


% another 3d color TSI neph - take long
daystr='20120713a';
nephfile=fullfile(starpaths, 'download',[daystr '.nephA.txt']);

s=importdata(nephfile);
s.t=s.textdata(2:end,1);
s.t=datenum(s.t(:))-datenum('0:0:0')+datenum([str2num(daystr(1:4)) str2num(daystr(5:6)) str2num(daystr(7:8))]);
s.ts=s.data(:,1:3);
s.bs=s.data(:,4:6);
s.press=s.data(:,7);
s.temp=s.data(:,8);
s.rh=s.data(:,9);
s.alt=interp1(vis_sun.t,vis_sun.Alt,s.t);
s.lon=interp1(vis_sun.t,vis_sun.Lon,s.t);
s.lat=interp1(vis_sun.t,vis_sun.Lat,s.t);
s.ang=sca2angstrom(s.ts,[45 55 70]);

figure;
cc=408;
sh=scatter3(s.lon(s.rows), ...
    s.lat(s.rows), ...
    s.alt(s.rows), ...
    markersize(s.ts(s.rows,2)), ...
    s.ang(s.rows), 'filled');
xlabel('Longitude');
ylabel('Latitude');
zlabel('Altitude (m)');
set(gca,'linewidth',1,'fontsize',12);
ch=colorbarlabeled(['Angstrom Exponent']);
title(daystr);
starttstr=datestr(xl(1), 30);
stoptstr=datestr(xl(2), 30);
caxis([1 2.5]);
if savefigure;
    starsas(['TCTSIneph' starttstr stoptstr(10:end) '.fig']);
end;

% map
figure;
starplot2dflighttrack(vis_sun, savefigure); % re-do this with track file, or use longer lines below to include non-Sun segments.
% figure;
% ph1=plot(s.Lon,s.Lat, '.', vis_zen.Lon, vis_zen.Lat, '^', 'color',[.5 .5 .5]);
% set(ph1(2),'markersize',3);
% hold on;
% rows=(1:length(s.t))';
% [sh,filename]=scattery(s.Lon(rows), 'Longitude', ...
%     s.Lat(rows), 'Latitude', ...
%     ones(size(rows))*24, '', ...
%     s.t, 'Time');
% rows=(1:length(vis_zen.t))';
% [sh2,filename2]=scattery(vis_zen.Lon(rows), 'Longitude', ...
%     vis_zen.Lat(rows), 'Latitude', ...
%     ones(size(rows))*6, '', ...
%     vis_zen.t, 'Time' , 'marker','^');
% ch=colorbarlabeled('Time');
% datetick(ch,'y');
% title([daystr ' ' memo]);
% if savefigure;
%     starsas(['star' daystr 'LonLat.fig'])
% end;

% Langley plots (0420) (see below for data masks)
figure;
!!! Revise the line below. starplotLangley.m was updated after this code was developed. 
starplotLangley(vis_sun, savefigure);
figure;
!!! Revise the line below. starplotLangley.m was updated after this code was developed. 
starplotLangley(nir_sun, savefigure);

% FORJ (0418)
s=vis_sun;
cols=[369 502];
figure;
plot(s.t,s.AZ_deg, '.b')
xl=xlim;
% rows=incl(s.t,xl);
rows2=intersect(rows, find(s.m_aero>0 & sum(isfinite(s.rate),2)>size(s.rate,2)/2));
[dummy,noonrow]=min(s.m_aero(rows2));
noonrow=rows2(noonrow);
clear rows2;
s.AZmod360=mod(s.AZ_deg,360);
s.ratepernoon=s.rate./repmat(s.rate(noonrow,:),size(s.rate,1),1);
s.rateperquadtotal=s.rate./repmat(s.QdVtot,1,size(s.rate,2));
s.rateperquadtotalpernoon=s.rateperquadtotal./repmat(s.rateperquadtotal(noonrow,:),size(s.rate,1),1);

figure;
s.AZsm=boxxfilt(s.t,s.AZ_deg,10/86400);
s.dAZsmdt=[diff(s.AZsm);0];
plot(s.t,mod(s.AZ_deg(:,:),360), '.','color',[.5 .5 .5]);
hold on;
[sh,filename]=scattery(s.t(rows),'Time', ...
    mod(s.AZ_deg(rows,:),360),'AZ deg mod 360', ...
    ones(size(rows))*24, '', ...
    s.dAZsmdt(rows), 'dAZ_{sm}/dt (deg/s)', ...
    'clim',[-2 2]);
set(gca,'ylim',[-5 365], 'ytick',0:90:360);
datetick('x','keeplimits');
daystr=starfilenames2daystr(s.filename,0);
daystrcombined0=unique(daystr,'rows')';
daystrcombined=strcat(daystrcombined0', ',')';
daystrcombined=strcat(daystrcombined(:))';
title(daystrcombined(1:end-1));
if savefigure;
    starsas(['star' strcat(daystrcombined0(:))' filename '.fig'])
end;

figure;
[h,filename]=starplot(s, {'t', 'ratepernoon', '.'}, rows, cols);
hold on
plot(xlim, [1 1], '-k');
if savefigure;
    starsas(['star' filename '.fig']);
end;

figure;
[h,filename]=starplot(s, {'AZ_deg', 'ratepernoon', '.'}, rows, cols);
ylabel(['Count Rate, ' datestr(s.t(noonrow),13) '=1']);
hold on
plot(xlim, [1 1], '-k');
if savefigure;
    starsas(['star' filename '.fig']);
end;

figure;
[h,filename]=starplot(s, {'AZmod360', 'ratepernoon', '.'}, rows, cols);
xlabel('AZ deg mod 360');
set(gca,'xlim',[-5 365], 'xtick',0:90:360);
ylabel(['Count Rate, ' datestr(s.t(noonrow),13) '=1']);
hold on
plot(xlim, [1 1], '-k');

figure;
[h,filename]=starplot(s, {'AZ_deg', 'rateperquadtotalpernoon', '.'}, rows, cols);
ylabel(['Count Rate per Quad Total, ' datestr(s.t(noonrow),13) '=1']);
hold on
plot(xlim, [1 1], '-k');

figure;
[h,filename]=starplot(s, {'AZmod360', 'rateperquadtotalpernoon', '.'}, rows, cols);
xlabel('AZ deg mod 360');
set(gca,'xlim',[-5 365], 'xtick',0:90:360);
ylabel(['Count Rate per Quad Total, ' datestr(s.t(noonrow),13) '=1']);
hold on
plot(xlim, [1 1], '-k');

figure;
[h,filename]=starscatter(s, ...
    {'AZmod360', 'rate', '', 'dAZsmdt', 'xlim',[-5 365], 'xtick',0:90:360, 'clim', [-2 2]}, ...
    rows, cols);
if savefigure;
    starsas(['star' filename '.fig'])
end;

figure;
[h,filename]=starscatter(s, ...
    {'AZmod360', 'ratepernoon', '', 'dAZsmdt', 'xlim',[-5 365], 'xtick',0:90:360, 'clim', [-2 2]}, ...
    rows, cols);
ylabel(['Count Rate, ' datestr(s.t(noonrow),13) '=1']);
if savefigure;
    starsas(['star' filename '.fig'])
end;


figure;
[h,filename]=starscatter(s, ...
    {'AZmod360', 'rateperquadtotalpernoon', '', 'dAZsmdt', 'xlim',[-5 365], 'xtick',0:90:360, 'clim', [-2 2]}, ...
    rows, cols);
ylabel(['Count Rate per Quad Total, ' datestr(s.t(noonrow),13) '=1']);
if savefigure;
    starsas(['star' filename '.fig'])
end;

figure;
[h,filename]=starscatter(s, ...
    {'t', 'AZ_deg', '', 't'}, ...
    rows, cols);
ch=colorbarlabeled('Time');
datetick(ch,'y','keeplimits');
if savefigure;
    starsas(['star' filename '.fig'])
end;

figure;
[h,filename]=starscatter(s, ...
    {'t', 'AZ_deg', '', 'dAZsmdt'}, ...
    rows, cols);
caxis([-2 2]);
if savefigure;
    starsas(['star' filename '.fig'])
end;

figure;
[h,filename]=starscatter(s, ...
    {'AZmod360', 'rateperquadtotalpernoon', '', 't', 'xlim',[-5 365], 'xtick',0:90:360}, ...
    rows, cols);
ylabel(['Count Rate per Quad Total, ' datestr(s.t(noonrow),13) '=1']);
if savefigure;
    starsas(['star' filename '.fig'])
end;

figure;
xx=s.AZmod360;
xstr='AZ deg mog 360';
yy=s.rateperquadtotalpernoon(:,cols);
ystr='rateperquadtotalpernoon';
[sh,filename]=scattery(xx(rows),xstr, ...
    yy(rows,:),ystr, ...
    ones(size(rows))*24, '', ...
    s.dAZsmdt(rows), 'dAZ_{sm}/dt (deg/s)', ...
    'clim',[-2 2]);
if event==2;
    set(gca,'xlim',[-5 365], 'xtick',0:90:360);
end;
hold on;
plot(xlim, [1 1], '-k');
title([daystr ' ' memo ', ' num2str(s.w(cols)*1000, '%0.1f') ' nm']);
if savefigure;
    sssssas(['star' daystr filename '.fig'])
end;


% 20120420
tlim=[datenum('2012-04-20 13:22:30') datenum('2012-04-20 13:31:20')
    datenum('2012-04-20 13:32:00') datenum('2012-04-20 13:36:30')
    datenum('2012-04-20 13:36:50') datenum('2012-04-20 13:37:30')
    datenum('2012-04-20 13:37:45') datenum('2012-04-20 13:38:25')
    datenum('2012-04-20 13:44:00') datenum('2012-04-20 13:48:20')
    datenum('2012-04-20 13:59:05') datenum('2012-04-20 14:07:33')
    datenum('2012-04-20 14:08:25') datenum('2012-04-20 14:16:15')
    datenum('2012-04-20 14:18:40') datenum('2012-04-20 14:33:40')
    datenum('2012-04-20 14:35:20') datenum('2012-04-20 14:39:05')
    datenum('2012-04-20 14:49:00') datenum('2012-04-20 14:52:00')
    datenum('2012-04-20 14:52:10') datenum('2012-04-20 15:25:30')
    datenum('2012-04-20 15:30:20') datenum('2012-04-20 15:35:00')
    datenum('2012-04-20 15:37:00') datenum('2012-04-20 15:41:10')
    datenum('2012-04-20 15:42:50') datenum('2012-04-20 15:45:30')
    datenum('2012-04-20 15:48:50') datenum('2012-04-20 16:04:00')];

[visc,nirc]=starchannelsatAATS;
rows=incl(vis_sun.t,tlim);
rows=intersect(incl(vis_sun.t,tlim), incl(vis_sun.am, [0 12]));

datatype='nir_sun';
eval(['s=' datatype ';']);
[s.V0, s.od]=Langley(s.am(rows),s.rate(rows,:));
s.odi=-log(s.rate./repmat(s.V0,pp,1))./repmat(s.am,1,size(s.w,2));

figure;
!!! Revise the line below. starplotLangley.m was updated after this code was developed. 
starplotLangley(s, 0, rows, visc(3:8));
figure;
!!! Revise the line below. starplotLangley.m was updated after this code was developed. 
starplotLangley(s, 0, rows);
% 
% 
% pp=size(s.rate,1);
% [visc,nirc]=starchannelsatAATS;
% clear cols;
% if isequal(datatype, 'vis_sun');
%     cols=visc(3:8);
%     xl=[100 1200];
% elseif isequal(datatype, 'nir_sun');
%     cols=nirc(11:13);
%     xl=[900 1800];
% end;

figure;
starplot(s, {'w', 'V0', '.'}, 1);
hold on;
gglwa;

figure;
[h,filename]=starplot(s, {'t', 'odi', '.'},'all',nirc(11:13));
ylabel('Total Optical Depth');
if savefigure;
    starsas(['star20120420_999_' upper(datatype) '_totalopticaldepth.fig, TCquickplots.m']);
end;

% vertical profiles
figure;
[h,filename]=starplot(s, {'t','Alt', '.'},rows);
if savefigure;
    starsas([filename '.fig, TCquickplots.m']);
end;

rows=incl(s.t, [datenum('2012-04-20 16:13:46') datenum('2012-04-20 16:25:55')]);
figure;
[h,filename]=starplot(s, {'od','Alt','.'}, rows, cols);
lstr=setspectrumcolor(h(:,2), s.w(cols));
lh=legend(h(:,2), lstr);
set(lh,'fontsize',12,'location','northeast');
xlabel('Total Optical Depth');
if savefigure;
    starsas([filename '.fig, TCquickplots.m']);
end;

bl=10/86400;
int=20;
bl=1700:int:6500;ext=repmat(NaN,size(s.rate));
for i=1:qq;
    if numel(bl)==1;
        s.odsm(:,i)=boxxfilt(s.t,s.od(:,i),bl);
    else
        [medi, variab, sn]=binfcn('nanmean', s.Alt(rows), s.od(rows,i), bl, 1);
        if sum(isfinite(medi))>=2;
            smod0=interp1((bl(1:end-1)+bl(2:end))/2,medi,s.Alt(rows), 'spline');
            ext(rows(1:end-1),i)=(-diff(smod0)./diff(s.Alt(rows))*1e6);
        end;
    end;
end;
figure;
ph=plot(ext(rows,visc(3:8)), s.Alt(rows), '.');
hold on
plot([0 0],[min(bl) max(bl)],  '-k');
lstr=setspectrumcolor(ph, s.w(visc(3:8)));
lh=legend(ph,lstr);
set(lh,'fontsize',12,'location','best');
ggla;
if savefigure;
    starsas(['star' daystr 'extinctionprofile.fig, TCquickplots.m']);
end;

figure;
[h,filename]=starplot(s, {'dodsmdalt','Alt2','.'}, rows, cols);
lstr=setspectrumcolor(h(:,2), s.w(cols));
lh=legend(h(:,2), lstr);
set(lh,'fontsize',12,'location','northeast');
xlabel('Extinction Coefficient (Mm^{-1})');
if savefigure;
    starsas([filename '.fig, TCquickplots.m']);
end;




% 20120619 G1 test flight out of PASCO
mtau= nanmean(vis_sun.tau_aero_noscreening(rows,:));
vis_sun.tau_aero_minusmean=NaN(size(vis_sun.rate));
vis_sun.tau_aero_minusmean(rows,:)=vis_sun.tau_aero_noscreening(rows,:)-repmat(mtau,size(rows));

ii=1:100:length(rows);
ii=(1:length(rows))';

cc=repmat(vis_sun.RHprecon(rows(ii))/5*100,1,length(vis_sun.w));
cc=vis_sun.RHprecon(rows(ii))/5*100;
cstr='RH (%)'; %'RHprecon/5*100%';

% cc=repmat(vis_sun.t(rows(ii)),1,length(vis_sun.w));
% cstr='Time';

figure;
lines = plot(vis_sun.w*1000,flipud(vis_sun.tau_aero_minusmean(rows(ii),:)),'-');
recolor(lines,flipud(cc));
% set(gca,'ytick',-0.05:0.01:0.05, 'ylim',[-0.05 0.05]);
hold on
plot(xlim, [0 0], '-k');
ylabel('\Deltatau aero');
gglwa;
grid on;
ch=colorbarlabeled(cstr);
datetick(ch,'y','keeplimits');
title(starfilenames2daystr(vis_sun.filename, 1))
if savefigure;
     starsas(['star' starfilenames2daystr(vis_sun.filename, 1) 'deltatauaero.fig']);
end;
%

figure;
[sh,filename]=scattery(repmat(vis_sun.w*1000,size(rows(ii))),'Wavelength (nm)', ...
    vis_sun.tau_aero_minusmean(rows(ii),:), '\Deltatau_aero',...
    24*ones(length(rows(ii)), length(vis_sun.w)), '', ...
    cc,cstr,...
    'xscale','log','ylim',[-0.05 0.05]);



% reading from Excel
% get the t0 7 columns; Ts the 2 columns; RHprecon 1 column
t=datenum([t0(:,1:6)])+t0(:,7)/1000/86400;
Tbox=Ts(:,1)*100-273.15;
Tprecon=Ts(:,2)*23-30;
figure;
plot(t,RHprecon*20,t,Tprecon,t,Tbox,'linewidth',2);
lh=legend('RH precon','Temperature precon','Temperature box');
set(lh,'fontsize',12,'location','best');
xlabel('Time');
ylabel('RH (%) or Temperature (^oC)');
datetick('x','keeplimits');
ggla;
grid on;
if savefigure;
    starsas('201206##_###_VIS_SUN_RHandTtseries.fig');
end;



% HSRL data
daystr='20120709';
file=fullfile(starpaths, 'download',[daystr '_F1_sub.h5']);
h5disp(file);
varnamelist={'532_ext' 'Altitude' 'AOT_hi' 'AOT_lo'};
hsrl=hsrlread(file,varnamelist); 
% hsrl.t=[];
% varnamelist={'gps_alt' 'gps_lat' 'gps_lon' 'gps_time' 'UTCtime2'};   
% for i=1:length(varnamelist)
%     varname=varnamelist{i};
%     data = h5read(file, ['/ApplanixIMU/' varname]);
%     eval(['hsrl.' formalizefieldname(varname) '= data;']);
% end;
% hsrl.t=(hsrl.gps_time/24+datenum([str2num(daystr(1:4)) str2num(daystr(5:6)) str2num(daystr(7:8))]))';
% for i=1:length(varnamelist)
%     varname=varnamelist{i};
%     data = h5read(file, ['/DataProducts/' varname]);
%     eval(['hsrl.' formalizefieldname(varname) '= data;']);
% end;
% hsrl.filename=file;


figure;
plot(hsrl.t, hsrl.AOT_hi, 'hr', hsrl.t, hsrl.AOT_lo, 'hm');
datetick('x','keeplimits');
grid on;
hold on;
plot(vis_sun.t, vis_sun.tau_aero_noscreening(:,447), '.','color',[0 0.5 0]);
xlabel('Time');
ylabel('AOD at 532 nm');
title(daystr);
ggla;
lh=legend('HSRL2 AOT_hi','HSRL2 AOT_lo', '4STAR VIS#447');
set(lh,'fontsize',12,'interpreter','none','location','best');
if savefigure;
    starsas(['star' daystr 'HSRLAOTcomparison.fig, TCquickplots.m']);
end;

% PREDE signal vs SZA
daystr='20120716';
load(['F:\work\4star\data\' daystr 'prede.mat'])
tvec=datevec(prede.t);
[azimuth, altitude,r]=sun(repmat(prede.lon,size(prede.t)), repmat(prede.lat,size(prede.t)),tvec(:,3), tvec(:,2), tvec(:,1), rem(prede.t,1)*24,repmat(288.15,size(prede.t)),repmat(1013.25,size(prede.t)));
figure;
ph=plot(90-altitude, prede.signal, 'p');
lstr=setspectrumcolor(ph, prede.lambda);
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
xlabel('Solar Zenith Angle');
ylabel('PRDE Signal');
ggla;
grid on;
title(daystr);
if savefigure;
    starsas(['TC' daystr 'PREDEsignalvSZA.fig'])
end;

% PREDE comparison
for i=1:6;
figure;
pp=plot(prede.time,prede.aod(i,:), '-',vis_sun.t,vis_sun.tau_aero_noscreening(:,visc(i)),'.');
ylim([0 .5]);
xlabel('Time');
ylabel('AOD');
title([daystr ', ' num2str(prede.wl(i)) ', ' num2str(vis_sun.w(visc(i))*1000,'%0.2f') ' nm']);
ggla;
end


figure;
pp=plot(prede.time,prede.aod(1:6,:), 'p',vis_sun.t,vis_sun.tau_aero_noscreening(:,visc(1:6)),'.');
xlabel('Time');
ylabel('AOD');
lstrp=setspectrumcolor(pp(1:6), prede.wl(1:6)');
lstr=setspectrumcolor(pp(7:12), vis_sun.w(visc(1:6)));
lh=legend(pp(1:6), lstrp);
title(daystr);
datetick('x','keeplimits');
ggla;
if savefigure;
    starsas(['star' daystr 'PREDEcomparisontseries.fig']);
end;


% 20120722 Langley flights - adjust for the FORJ
rows0=incl(vis_sun.t,langley);
rows1=incl(vis_sun.t,langley,vis_sun.flag(:,408), [0 0]);
!!! Revise the line below. Langley.m was updated after this code was developed. 
[data0, od,rows]=Langley(vis_sun.m_aero(rows0), vis_sun.rateaero(rows0,408), 2);
s=vis_sun;
s.AZmod360=mod(s.AZ_deg,360);
!!! Revise the line below. Langley.m was updated after this code was developed. 
[s.c0r, s.odr]=Langley(s.m_aero(rows0(rows)), s.rateaero(rows0(rows),:));
ratefit=exp(-1*s.m_aero*s.odr+repmat(log(s.c0r),size(s.t)));
forjcorrectionfactor=ratefit./s.rateaero;
xbins=0:30:360;
xbins2=(xbins(1:end-1)+xbins(2:end))/2;
xx=0:0.1:360;
qq=size(s.w,2);
s.forjcorrectionfactor=NaN(length(xx),qq);
clear medi;
for i=1:qq;
    [medi(:,i), variab, sn]=binfcn('nanmean', s.AZmod360(rows1), forjcorrectionfactor(rows1,i), xbins);
    if sum(isfinite(medi(:,i)))>1
        s.forjcorrectionfactor(:,i)=interp1([xbins2-360 xbins2 xbins2+360], repmat(medi([1:end],i)',1,3), xx, 'spline');
    end;
end;
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(s.t);
[daystr,filen,datatype]=starfilenames2daystr(s.filename,1);
if isequal(upper(datatype(1:3)),'VIS')
    c=visc(1:9);
elseif isequal(upper(datatype(1:3)),'NIR');
    c=nirc(11:13);
end;
figure;
ph=plot(xbins2, medi(:,c), 's','linewidth',2);
hold on;
ph2=plot(xx, s.forjcorrectionfactor(:,c), '-');
lstr=setspectrumcolor(ph, s.w(c));
lstr=setspectrumcolor(ph2, s.w(c));
ggla;
set(gca,'xlim',[-5 360], 'xtick',0:90:360);
grid on;
plot(xlim, [1 1], '-k');
xlabel('AZ deg mod 360');
ylabel({'Correction Factor';'(fitted/measured 500.8 nm aerosol count rate, /ms)'})
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
title(daystr);
if savefigure;
    starsas(['star' daystr  upper(datatype(1:3)) 'FORJcorrectionfactor.fig, TCquickplots.m']);
end;

cfi=round(s.AZmod360*10)+1;
if isequal(upper(datatype(1:3)),'VIS')
cf=forjcorrectionfactor(cfi,:);
elseif isequal(upper(datatype(1:3)),'NIR')
cf=forjcorrectionfactornir(cfi,:);
end;

% copied to TCmakearchive.m.
% % % % archive files
% % % daystr=starfilenames2daystr(vis_sun.filename,1);
% % % [visc,nirc,viscrange,nircrange]=starchannelsatTCAPArchive(vis_sun.t);
% % % tosave=[round((vis_sun.t-floor(vis_sun.t(1)))*86400) vis_sun.Lat vis_sun.Lon vis_sun.Alt vis_sun.tau_aero(:,visc(1:9)) nir_sun.tau_aero(:,nirc(10:13))];
% % % tosave(isfinite(tosave)==0 | imag(tosave)~=0)=-9999;
% % % savefilename=fullfile(starpaths, ['4STAR_G1_' daystr '_RA.ict']);
% % % if exist(savefilename);
% % %     error([savefilename ' exists.']);
% % % end;
% % % fmt=['%u ' repmat('%6.3f ',1,16)];
% % % fmt=[fmt(1:end-1) '\n'];
% % % fid=fopen(savefilename,'w');
% % % fprintf(fid, fmt, tosave');
% % % fclose(fid);
% % % 
% re-run starsun.m.
dslist={'20120707' '20120709' '20120713' '20120714' '20120715' '20120717' '20120718' '20120721' '20120722' '20120723' '20120725' '20120730'};
dslist={'20120707' '20120709' '20120713' '20120714' '20120715' '20120717' '20120718' '20120721' '20120722' '20120723' '20120725' '20120822' '20120722Langley' '20120707ground' '20120708ground' '20120709ground' '20120710ground' '20120711ground' '20120713ground' '20120714ground' '20120715ground' '20120717ground' '20120718ground' '20120721ground' '20120722ground' '20120723ground' '20120725ground'}; % synch with TCmakegroundstar.m.};
for i=1:length(dslist);
    starfile=fullfile(starpaths, [dslist{i} 'star.mat']);
    starsunfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
    if exist(starsunfile);
        error([starsunfile ' exists.']);
    end;
    starsun(starfile, starsunfile);
    disp(dslist{i});
end;
% % % 
% % % for i=1:length(dslist);
% % %     starfile=fullfile(starpaths, [dslist{i} 'star.mat']);
% % %     starsunfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
% % %     load(starsunfile);
% % %     
% % %     daystr=dslist{i};
% % %     tosave=[round((vis_sun.t-floor(vis_sun.t(1)))*86400) vis_sun.Lat vis_sun.Lon vis_sun.Alt vis_sun.tau_aero(:,visc(1:9)) nir_sun.tau_aero(:,nirc(10:13))];
% % %     tosave(isfinite(tosave)==0 | imag(tosave)~=0)=-9999;
% % %     savefilename=fullfile(starpaths, ['4STAR_G1_' daystr '_RA.ict']);
% % %     if exist(savefilename);
% % %         error([savefilename ' exists.']);
% % %     end;
% % %     fmt=['%u ' repmat('%6.3f ',1,16)];
% % %     fmt=[fmt(1:end-1) '\n'];
% % %     fid=fopen(savefilename,'w');
% % %     fprintf(fid, fmt, tosave');
% % %     fclose(fid);
% % %     
% % %     
% % %     disp(dslist{i});
% % % end;

for i=length(dslist):-1:1;
    starfile=fullfile(starpaths, [dslist{i} 'star.mat']);
    starsunfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
    load(starsunfile);

    disp(size(vis_sun.t))
    disp(size(nir_sun.t))
figure;plot(vis_sun.t,(vis_sun.t-nir_sun.t)*86400, '.');title(daystr);datetick('x','keeplimits');
end;

% converts the starsun contents from structures to variables
% TO BE ARRANGED IN starsun.m
for i=1:length(dslist);
    starfile=fullfile(starpaths, [dslist{i} 'star.mat']);
    starsunfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
    starsunfile2=fullfile(starpaths, [dslist{i} 'starsun_structures.mat']);
    if exist(starsunfile2);
        error([starsunfile2 ' exists.']);
    end;
    copyfile(starsunfile,starsunfile2);
    load(starsunfile);
    p=length(vis_sun.t);
    if p~=length(nir_sun.t) || max(abs(vis_sun.t-nir_sun.t))*86400>0.02
        warning(['Different time arrays in ' starsunfile '.']);
    end;
    t=vis_sun.t;
    nirt=nir_sun.t;
    w=[vis_sun.w nir_sun.w];
    save(starsunfile, 't', 'nirt', 'w', '-mat');
    fn=fieldnames(vis_sun);
    for ff=1:length(fn);
        if size(vis_sun.(fn{ff}),1)==p && ~ isequal(fn{ff},'t')
            newvar=[vis_sun.(fn{ff}) nir_sun.(fn{ff})];
            eval([fn{ff} '=newvar;']);
            save(starsunfile, fn{ff}, '-mat','-append');
            clear(fn{ff})
        end;
    end;    
    c0=[vis_sun.c0 nir_sun.c0];
    fwhm=[vis_sun.fwhm nir_sun.fwhm];
    ng=vis_sun.ng;
    O3h=vis_sun.O3h;
    O3col=vis_sun.O3col;
    sd_aero_crit=vis_sun.sd_aero_crit;
    filename=[vis_sun.filename nir_sun.filename];
    note=[vis_sun.note nir_sun.note];
    save(starsunfile, 'c0', 'fwhm', 'filename', 'O3h', 'O3col', 'sd_aero_crit', 'note', '-mat','-append');
    fn=fieldnames(vis_sun_misc);
    for ff=1:length(fn);
        if size(vis_sun_misc.(fn{ff}),1)==p && ~ isequal(fn{ff},'t')
            newvar=[vis_sun_misc.(fn{ff}) nir_sun_misc.(fn{ff})];
            eval([fn{ff} '=newvar;']);
            save(starsunfile, fn{ff}, '-mat','-append');
            clear(fn{ff})
        else
            disp(fn{ff});
        end;
    end;    
    tau_NO2=[vis_sun_misc.tau_NO2 nir_sun_misc.tau_NO2];
    tau_O2=[vis_sun_misc.tau_O2 nir_sun_misc.tau_O2];
    tau_CO2_CH4_N2O=[vis_sun_misc.tau_CO2_CH4_N2O nir_sun_misc.tau_CO2_CH4_N2O];
    save(starsunfile, 'tau_NO2', 'tau_O2', 'tau_CO2_CH4_N2O', '-mat','-append');
    clear vis_sun nir_sun vis_sun_misc nir_sun_misc;
end;


% read AERONET file
aeronetfile='D:\4star\data\120701_120731_ARM_Barnstable_MA_lev10.csv';
an=importdata(aeronetfile, ',');

an.t=an.data(:,1)+datenum([2011 12 31]);
an.aod=an.data(:,9:-1:2);
an.w=fliplr([1640	1020	870	675	500	440	380	340]/1000);
note=['Generated on ' datestr(now,31) ' from ' '120701_120731_ARM_Barnstable_MA_lev10.csv.'];
% % save('D:\4star\data\raw\120701_120731_ARM_Barnstable_MA_lev10.mat', 'note','-mat','-append')
% ti=10/86400;
% times=[an.t-ti/2 an.t+ti/2];
% 
% s=merge(starfile,{'tau_aero_noscreening' 'Alt' 'Lon' 'Lat'}, times, 'nanmean');

% AERONET 4STAR comparison
starfile=fullfile(starpaths, '20120725starsun_GroundandFlight.mat');
aeronetfile='D:\4star\data\120701_120731_ARM_Barnstable_MA_lev10.mat';
an=load(aeronetfile)
c=round(interp1(w,1:length(w),an.w));
load(fullfile(starpaths, '20120725starsun_GroundandFlight.mat'),'t','w''visfilen','tau_aero_noscreening','tau_aero');
gr=find(visfilen<=7 | visfilen>=30); % on ground on 20120725
ti=10/86400;
times=[an.t-ti/2 an.t+ti/2];
s.tau_aero_noscreening=NaN(size(times,1),size(tau_aero_noscreening,2));
s.tau_aero=NaN(size(times,1),size(tau_aero,2));
for i=1:size(times,1);
    rows=incl(t, times(i,:), visfilen, [0 7;30 Inf]);
    if ~isempty(rows)
        s.tau_aero_noscreening(i,:)=nanmean1(tau_aero_noscreening(rows,:));
        s.tau_aero(i,:)=nanmean1(tau_aero(rows,:));
    end;
end;
s.t=mean(times,2);

figure;
h=plot(t(gr), tau_aero_noscreening(gr,c), '.');
lstr=setspectrumcolor(h, [w(c)]);
hold on
ah=plot(an.t,an.aod, 's','linewidth',2);
lstr=setspectrumcolor(ah, [an.w]);
lh=legend(ah, lstr);
set(lh,'fontsize',12,'location','best');
ylim([0 0.3]);
ggla;
daystr=starfilenames2daystr(filename);
title(daystr);
if savefigure;
    starsas(['star' daystr 'AERONETcomptseries.fig, TCquickplots.m']);
end;

figure;
xl=[0.01 1];
ph=loglog(an.aod, s.tau_aero(:,c), 'o','markersize',sqrt(24),'linewidth',2);
hold on;
plot(xl,xl,'-k');
lstr=setspectrumcolor(ph, an.w);
axis([xl xl]);
ggla;
grid on;
xlabel('CIMEL AOD');
ylabel('4STAR AOD');
lh=legend(ph,lstr);
set(lh,'fontsize',12,'location','best');
title(daystr);
if savefigure;
    starsas(['star' daystr 'AERONETcompt.fig, TCquickplots.m']);
end;

figure;
xl=[0.01 1];
ph=semilogx(an.aod, s.tau_aero(:,c)-an.aod, 'o','markersize',sqrt(24),'linewidth',2);
hold on;
plot(xl,[0 0],'-k');
lstr=setspectrumcolor(ph, an.w);
xlim(xl);
ggla;
grid on;
xlabel('CIMEL AOD');
ylabel('4STAR-CIMEL AOD');
lh=legend(ph,lstr);
set(lh,'fontsize',12,'location','best');
title(daystr);
if savefigure;
    starsas(['star' daystr 'AERONETcompdist.fig, TCquickplots.m']);
end;


for i=1:size(times,1);
    rows=incl(t, times(i,:), t, xl);
    s.tau_aero_noscreening(i,:)=nanmean(tau_aero_noscreening(rows,:));
end;
s.t=mean(times,2);





% Tint tests 20120907
daystr='20130618';
load(fullfile(starpaths, [daystr 'starsun.mat']));
[both, ~, aats]=staraatscompare(daystr);
[~,noonrow]=max(find(both.t<=mean([tinttesttlims(2,1) tinttesttlims(1,2)])));
[both, ~, aats]=staraatscompare(daystr,noonrow);
tinttesttlims; % get from starinfo20120907.m.
vistintlims=[2.5:5:97.5];
vistintlims2=[5:5:95];
viscountlims=10.^(0:0.1:5);
viscountlims2=mean([viscountlims(1:end-1); viscountlims(2:end)]);
viscountlims2=sqrt(viscountlims(1:end-1).*viscountlims(2:end));
visfig=figure;
viscountfig=figure;
vistfig=figure;
visc=find(both.c(2,:)<=1044);
nirc=find(both.c(2,:)>1044);
Tint=NaN(size(both.raterelativeratiotoaats));
Tint(:, visc)=repmat(visTint,1,length(visc));
Tint(:, nirc)=repmat(nirTint,1,length(nirc));
for i=2:size(tinttesttlims,1);
    ok=incl(both.t,tinttesttlims(i,:));
    for cc=1:10;
        [medi(:,cc), variab(:,:,cc), sn(:,cc)]=...
            binfcn('nanmean', Tint(ok,cc), both.raterelativeratiotoaats(ok,cc), vistintlims, 10);
        [cmedi(:,cc), cvariab(:,:,cc), csn(:,cc)]=...
            binfcn('nanmean', both.rate(ok,both.c(2,cc)).*Tint(ok,cc), both.raterelativeratiotoaats(ok,cc),  viscountlims, 10);
    end;
    [tmedi, tvariab, tsn]=...
        binfcn('nanmean', Tint(ok), both.t(ok), vistintlims, 10);
    figure(visfig);
    if i==1 | i==3; % ascending Tint
        ph=plot(vistintlims2, medi, '.-','markersize',12);
        lstr=setspectrumcolor(ph, aats.w(1:10));
        lh=legend(ph,lstr);
    else; % descending Tint
        ph=plot(vistintlims2, medi, '.:','markersize',12);
        lstr=setspectrumcolor(ph, aats.w(1:10));
    end;
    hold on;
    figure(viscountfig);
    if i==1 | i==3; % ascending Tint
        phc=plot(viscountlims2, cmedi, '.-','markersize',12);
        lstrc=setspectrumcolor(phc, aats.w(1:10));
        lhc=legend(phc,lstrc);
    else; % descending Tint
        phc=plot(viscountlims2, cmedi, '.:','markersize',12);
        lstrc=setspectrumcolor(phc, aats.w(1:10));
    end;
    hold on;
    figure(vistfig);
    if i==1 | i==3; % ascending Tint
        pht=plot(tmedi, medi, '.-', 'markersize', 12);
        lstrt=setspectrumcolor(pht, aats.w(1:10));
        lht=legend(pht,lstrt);
    else; % descending Tint
        pht=plot(tmedi, medi, '.:', 'markersize', 12);
        lstrt=setspectrumcolor(pht, aats.w(1:10));
    end;
    hold on;
    clear medi variab sn cmedi cvariab csn tmedi tvariab tsn;
end;
figure(visfig);
ylim([0.94 1.04]);
plot(xlim, [1 1], '-k');
ggla;
grid on;
xlabel('Tint (ms)');
ylabel(['4STAR/AATS, ' datestr(both.t(both.noonrow),13) '=1']);
title(daystr);
set(lh,'fontsize',12,'location','best');
if savefigure;
    starsas(['star' daystr 'VISraterelativeratiotoAATSvTint_expanded.fig, TCquickplots.m']);
end;

figure(viscountfig);
ylim([0.94 1.04]);
plot(xlim, [1 1], '-k');
ggla;
grid on;
xlabel('4STAR Counts (raw-dark)');
ylabel(['4STAR/AATS, ' datestr(both.t(both.noonrow),13) '=1']);
title(daystr);
set(lhc,'fontsize',12,'location','best');
if savefigure;
    starsas(['star' daystr 'VISraterelativeratiotoAATSvCounts.fig, TCquickplots.m']);
end;

figure(vistfig);
ggla;
grid on;
plot(xlim, [1 1], '-k');
datetick('x','keeplimits');
set(lht,'fontsize',12,'location','best');
if savefigure;
    starsas(['star' daystr 'VISraterelativeratiotoAATSvtseries_expanded.fig, TCquickplots.m']);
end;

% TCAP map
dslist={'20120709' '20120713' '20120714' '20120715' '20120717' '20120718' '20120721' '20120722' '20120723' '20120725'};
clr=flipud(hsv(numel(dslist)));
clr=clr([5 7 9 1 3 6 4 2 10 8 ],:);
% for i=1:length(dslist)
% files(i)={fullfile(starpaths, [dslist{i} 'air.mat'])};
% end;
% merge(files, {'Lat' 'Lon'});
[matfolder,figfolder]=starpaths;
open(fullfile(figfolder,'fig','TCAPmap.fig'));
hold on;
for i=1:length(dslist)
    files(i)={fullfile(starpaths, [dslist{i} 'air.mat'])};
    load(files{i});
    if isequal((dslist{i}(7:8)),'22');
        a=find(t<=datenum([2012 7 22 18 0 0]));
        b=find(t>=datenum([2012 7 22 18 0 0]));
        mh(i)=plot(Lon(a),Lat(a),'.','color',clr(i,:));
        cal20120722=plot(Lon(b),Lat(b),'.','color',[.5 .5 .5]);
    else;
    mh(i)=plot(Lon,Lat,'.','color',clr(i,:));
    end;
    lstr(i)={['Jul ' dslist{i}(7:8)]};
end;
lh=legend([mh(1:8) cal20120722 mh(9:end)],[lstr(1:8) {'calibration'} lstr(9:end)]);
set(lh,'fontsize',12,'location','northwest');
if savefigure;
    starsas('TCAPmapflighttracks.fig, TCquickplots.m');
end;

axis([-71. -69.5 41.4 42.3001]);
plot(-70.28,41.67,'p',-70.049,42.030,'p','markersize',24,'markeredgecolor','k','markerfacecolor','w','linewidth',3); % the second coordinate from an AERONET highland file
text(-70.28,41.67-0.05,'Airport','verticalalignment','cap','horizontalalignment','center','fontsize',24);
text(-70.05,42.030-0.06,'Ground Station','verticalalignment','cap','horizontalalignment','center','fontsize',24);
if savefigure;
    starsas('TCAPmapflighttracks_expanded.fig, TCquickplots.m');
end;

% tau aero spectra with AATS
daystr='20120907';
load(fullfile(starpaths, [daystr 'starsun.mat']),'tau_aero_noscreening', 'tau_aero', 't', 'w', 'm_aero', 'sza');
visc=1:1044;
nirc=(1:512)+1044;
aats=load(fullfile(starpaths, [daystr 'aats.mat']));
tlim=[datenum('21:30:00') datenum('22:00:00')]-datenum('0:0:0')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
ok=incl(t,tlim);
aats.t=aats.UT'/24+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
aats.ok=incl(aats.t,tlim);
figure;
h=loglog(w(visc), nanmean(tau_aero(ok,visc)), '.b', ...
    w(nirc), nanmean(tau_aero(ok,nirc)), '.', ...
    aats.lambda, nanmean(aats.tau_aero(:,aats.ok)'), '.', ...
    'markersize',12);
set(h(2),'color',[1 0.5 0]);
set(h(3),'color',[0 0.5 0], 'markersize',24);
lh=legend('4STAR VIS','4STAR NIR','AATS');
set(lh,'fontsize',12,'location','best');
ggla4aod;
ylim([0.01 1]);
title([daystr ', ' datestr(tlim(1),13) ' - ' datestr(tlim(2),13)]);
starttstr=datestr(tlim(1),30);
stoptstr=datestr(tlim(2),30);
if savefigure;
    starsas(['starAATS' daystr starttstr(10:end) '_' stoptstr(10:end) 'avgtau_aerospectra.fig']);
end;
    

% extinction profile - deciphering ext_profile_ave.m.
daystr='20120722';
nep=load(fullfile(starpaths, [daystr 'nep.mat']));
load(fullfile(starpaths, [daystr 'starsun.mat']), 't','w', 'Alt', 'tau_aero');
    starinfofile=fullfile(starpaths, ['starinfo' daystr '.m']);
    s=importdata(starinfofile);
    s1=s(strmatch('spiral',s)); 
    eval(s1{:});
    tlim=spiral(1,:); % tlim=langley
    ok=incl(t,tlim);
    nep.ok=incl(nep.t,tlim);
    nep.alt=interp1(t,Alt,nep.t);
[viscc,nircc]=starchannelsatAATS;
cc=[viscc(1:9) nircc(11:13)+1044]; !!! note the 10th channels is omitted
altbins=200:50:6300;
% altbins2=(altbins(1:end-1)+altbins(2:end))/2;
tau_aero_mean=NaN(numel(altbins)-1,size(tau_aero,2));
r_mean=NaN(numel(altbins)-1,size(tau_aero,2));
variab=NaN(numel(altbins)-1,2,size(tau_aero,2));
sn=NaN(numel(altbins)-1,size(tau_aero,2));
nephcc=interp1(w,1:numel(w),[0.45 0.55 0.70],'nearest');
ii=nephcc(2);wstr='550nm';
% hsrlcc=interp1(w,1:numel(w),[0.355 0.532 1.064],'nearest');
% ii=hsrlcc(2);wstr='532nm';
% ii=407;wstr='500nm';
% ii=cc;wstr='aatswavelengths';
for c=ii;
[tau_aero_mean(:,c), variab(:,:,c), sn(:,c)]=binfcn('nanmean', Alt(ok), tau_aero(ok,c), altbins', 1);
[r_mean(:,c), variab(:,:,c), sn(:,c)]=binfcn('nanmean', Alt(ok), Alt(ok), altbins', 1);
end;
vali=find(isfinite(tau_aero_mean(:,ii))==1);
pp=csaps(r_mean(vali,ii)/1000,tau_aero_mean(vali,ii),0.9995);
tau_aero_spline = fnval(pp,r_mean(vali,ii)/1000);
ext_coeff=-fnval(fnder(pp),r_mean(vali,ii)/1000)*1e3;
figure;
ph=plot(ext_coeff, r_mean(vali,ii), '.-','markersize',12);
lstr=setspectrumcolor(ph,w(ii));
xlim([-200 500])
ylim([0 2500]);
 lh=legend(ph,lstr);
set(lh,'fontsize',12,'location','best');
ggla;
xlabel('Extinction Coefficient (Mm^{-1})');
ylabel('Altitude');
grid on;
title([daystr ', ' datestr(tlim(1),13) ' - ' datestr(tlim(2),13)]);
starttstr=datestr(tlim(1),30);
stoptstr=datestr(tlim(2),30);
if savefigure;
    starsas(['starAATS' daystr starttstr(10:end) '_' stoptstr(10:end) 'ext' wstr 'vertprof.fig, TCquickplots.m']);
end;

 figure;
 ph0=plot(tau_aero(ok,ii), Alt(ok), '.','markersize',6,'color',[.5 .5 .5]);
 hold on
 ph=plot(tau_aero_mean(:,ii), r_mean(:,ii), '.','markersize',6);
ph= plot(tau_aero_spline, r_mean(vali,ii), 'or')
lstr=setspectrumcolor(ph,w(ii));
lh=legend(ph,lstr);
set(lh,'fontsize',12,'location','best');
ggla;
xlabel(['tau aero averaged over ' num2str(unique(diff(altbins))) ' m']);
ylabel('Altitude');
grid on;
title([daystr ', ' datestr(tlim(1),13) ' - ' datestr(tlim(2),13)]);
starttstr=datestr(tlim(1),30);
stoptstr=datestr(tlim(2),30);
if savefigure;
    starsas(['starAATS' daystr starttstr(10:end) '_' stoptstr(10:end) 'tau_aero_mean' wstr 'vertprof.fig, TCquickplots.m']);
end;

% 09/17 test data
Roy_records=[2485 2765 2800 2814 2836 2859 2865 2895 3050 3085 3190 3210 3225 3271 3310 3333 3460 3566 3594 3677 3704 3745 3810 3857];


% 0722 Langley - calculating C0 by applying the 2x screening at each
% wavelength. Up to this point the screening was made at a mid-visible (500
% nm?) single pixel, and applied across wavelengths.
for k=1:2;
    if k==1;
        s=vis_sun;
    elseif k==2;
        s=nir_sun;
    end;
    qq=size(s.w,2);
    data0=NaN(1,qq);
    od=NaN(1,qq);
    percentiles=NaN(qq,2);
    rowsall=zeros(max(ok),qq); 
    for ii=1:qq
!!! Revise the line below. Langley.m was updated after this code was developed. 
        [data0(ii), od(ii),rows]=Langley(s.m_aero(ok), s.rateaero(ok,ii), 2);
        ra1=data0(ii).*exp(s.m_aero(ok)*(-od(ii)));
        percentiles(ii,:)=[prctile(ra1./s.rateaero(ok,ii),33/2) prctile(ra1./s.rateaero(ok,ii),100-33/2)];
        rowsall(rows,ii)=1;
        disp(ii);
    end;
    s.data0=data0;
    s.od_iteration=od;
    s.percentiles=percentiles;
    s.rowsall=rowsall;
    if k==1;
        vis_sun=s;
    elseif k==2;
        nir_sun=s;
    end;
end;
save('d:\4star\data\20120722Langley_C0_longeriteration.mat','vis_sun','nir_sun','-mat');

rows408=find(vis_sun.rowsall(:,408)==1);
rows408=ok(rows408);
!!! Revise the line below. Langley.m was updated after this code was developed. 
[vis_sun.data0408, vis_sun.od408]=Langley(vis_sun.m_aero(rows408), vis_sun.rateaero(rows408,:));
!!! Revise the line below. Langley.m was updated after this code was developed. 
[nir_sun.data0408, nir_sun.od408]=Langley(nir_sun.m_aero(rows408), nir_sun.rateaero(rows408,:));
ra1=repmat(vis_sun.data0408,size(ok)).*exp(vis_sun.m_aero(ok)*(-vis_sun.od408));
vis_sun.percentiles408=[prctile(ra1./vis_sun.rateaero(ok,:),33/2)' prctile(ra1./vis_sun.rateaero(ok,:),100-33/2)'];
ra1=repmat(nir_sun.data0408,size(ok)).*exp(nir_sun.m_aero(ok)*(-nir_sun.od408));
nir_sun.percentiles408=[prctile(ra1./nir_sun.rateaero(ok,:),33/2)' prctile(ra1./nir_sun.rateaero(ok,:),100-33/2)'];

for j=1:2;
    if j==1;
        warivis=1;
        warinir=.1;
        yl=[0 1000];
    elseif j==2;
        warivis=visc0;
        warinir=nirc0;
        yl=[0.94 1.06];
    end;
    figure;
    sh=semilogx(visw, visc0./warivis, '.',...
        visw,vis_sun.data0./warivis, '.',...
        visw,visc00707./warivis, '.', ...
        nirw, nirc0./warinir, '.',...
        nirw,nir_sun.data0./warinir, '.',...
        nirw,nirc00707./warinir, '.');
    for i=1:3;
        set(sh(i+3),'color',get(sh(i),'color'));
    end;
    ylim(yl);
    gglwa;
    if j==1;
    ylabel('C0 (/ms)');
        lh=legend('20120722 screened 2x at 500.8 nm','20120722 screened 2x at each wavelength', '20120707',' ','NIR C0*10',' ');
    elseif j==2;
    ylabel('C0 (/ms) Ratio');
        lh=legend('20120722 screened 2x at 500.8 nm','20120722 screened 2x at each wavelength', '20120707');
    end;
        set(lh,'fontsize',12,'location','best');
    grid on;
if savefigure;
    starsas(['star2012072220120707refinedLangleyC0screenings' num2str(j) '.fig, TCquickplots.m']);
end;
end
figure;
sh1=semilogx(visw,1./vis_sun.percentiles408(:,1), '.',...
    visw,1./vis_sun.percentiles408(:,2), '.',...
nirw,1./nir_sun.percentiles408(:,1), '.',...
nirw,1./nir_sun.percentiles408(:,2), '.', ...
'color','b');
hold on;
sh2=semilogx(visw,1./vis_sun.percentiles(:,1), '.',...
    visw,1./vis_sun.percentiles(:,2), '.',...
nirw,1./nir_sun.percentiles(:,1), '.',...
nirw,1./nir_sun.percentiles(:,2), '.', ...
'color',[0 0.5 0]);
ylim([0.94 1.06]);
gglwa;
grid on;
ylabel('16.5-83.5 prctiles of rateaero ratio to regression');
lh=legend([sh1(1) sh2(1)],'20120722 screened 2x at 500.8 nm','20120722 screened 2x at each wavelength');
set(lh,'fontsize',12,'location','best');
if savefigure;
    starsas(['star2012072220120707refinedLangleyC0screeningsFORJimpact.fig, TCquickplots.m']);
end;



% new O4
daystr='20120722';
load(fullfile(starpaths, [daystr 'Langleystarsun_newO4O2.mat']), 't', 'm_aero', 'rateaero', 'flag','w', 'aerosolcols','viscols','nircols');
infofile=fullfile(starpaths, ['starinfo' daystr '.m']);
    s=importdata(infofile);
    s1=s(strmatch('langley',s));
    eval(s1{:});
rows0=incl(t, langley);
!!! Revise the line below. Langley.m was updated after this code was developed. 
[~, ~,rows]=Langley(m_aero(rows0),rateaero(rows0,408),2);
rows=rows0(rows);
!!! Revise the line below. Langley.m was updated after this code was developed. 
[data0, od,rows]=Langley(m_aero(rows),rateaero(rows,:));

figure;
h=starplotspectrum(w, data0, [], viscols, nircols);
hold on
holdvis=plot(oldvisc0.data(:,2)/1000',oldvisc0.data(:,3)', 'color', get(h(2),'color'));
holdnir=plot(oldnirc0.data(:,2)/1000',oldnirc0.data(:,3)', 'color', get(h(3),'color'));
% holdvis=starplotspectrum(oldvisc0.data(:,2)/1000',oldvisc0.data(:,3)', [], 1:size(oldvisc0.data(:,2),1), []);
hold on;
% holdnir=starplotspectrum(oldnirc0.data(:,2)/1000',oldnirc0.data(:,3)', [], [], 1:size(oldnirc0.data(:,2),1));
set(h(2),'color','b');
set(h(3),'color','r');
set(gca,'yscale','linear','ylim',[0 1000]);
ylabel('C0');
title([daystr])
oldvisc0=importdata(fullfile(starpaths, '20120722_VIS_C0_refined_Langley_on_G1_second_flight_screened_2x.dat'));
oldnirc0=importdata(fullfile(starpaths, '20120722_NIR_C0_refined_Langley_on_G1_second_flight_screened_2x.dat'));


% mlim=[1.2 12]; % the range of airmass factor. This may be different from the airmass flags applied for other purposes (e.g., data archival).
%     rows=incl(sum(flag,2), [0 0], m_aero, mlim);
%     [pp,qq]=size(rateaero);
% 
% [s.odr, s.c0r, std_about_regression, std_of_slope]...
%     =regressm(s.m_aero(rows),log(s.rateaero(rows,:)));
% s.odr=-s.odr;
% s.c0r=exp(s.c0r);


% 20130109 LED FORJ test
cols=524:616;
rpq=sum(s.rate(:,cols),2)./s.QdVtot;
yy=rpq./repmat(rpq(ok(end),:),size(s.t));
ystr=['Count Rate (/ms, ' num2str(w(cols(1))*1000,'%0.0f') '-' num2str(w(cols(end))*1000,'%0.0f') 'nm summed) / QdTot'];

yy=sum(s.rate(:,cols),2)./repmat(sum(s.rate(ok(end),cols),2),size(s.t));
ystr=['Count Rate (/ms, ' num2str(w(cols(1))*1000,'%0.0f') '-' num2str(w(cols(end))*1000,'%0.0f') 'nm summed), ' datestr(s.t(ok(end)),13) '=1'];

yy=s.raterelativeratiotoaats(:,4);
ystr=['4STAR Count Rate / AATS Voltage (' datestr(s.t(s.noonrow),13) '=1)'];
figure;
% dAZdt=[diff(s.AZstep/50)./diff(s.t)/86400; 0];
% [sh,filename]=scattery(mod(s.AZstep(ok)/50,360), 'AZ deg mod 360', ...
%     yy(ok), ystr, ...
%     ones(size(ok))*24, '', ...
%     dAZdt(ok), 'dAZ/dt (deg/s)', ...
%     'ylim',[0.98 1.02], 'clim',[-2 2]);
dAZdt=[diff(s.AZ_deg)./diff(s.t)/86400; 0];
[sh,filename]=scattery(mod(s.AZ_deg(ok),360), 'AZ deg mod 360', ...
    yy(ok), ystr, ...
    ones(size(ok))*24, '', ...
    dAZdt(ok), 'dAZ/dt (deg/s)', ...
    'ylim',[0.94 1.06], 'clim',[-2 2]);
set(gca,'xtick',[0:30:360], 'xlim',[-5 365]);
hold on;
plot(xlim, [1 1], '-k');
title('20130108');

% TCAP 2
daystr='20130227';
load(fullfile(starpaths, [daystr 'starsun.mat']));
[visc,nirc]=starchannelsatAATS(nanmean(t));
c=[viscols(visc(isfinite(visc)==1)) nircols(nirc(isfinite(nirc)==1))];
addi=load(fullfile(starpaths, [daystr 'star.mat']));

figure;
[sh,filename]=scattery(Lon, 'Longitude', ...
    Lat, 'Latitude', ...
    ones(size(t))*24, '', ...
    t, 'UTC');
lstr={'SUN'};
hold on;
if isfield(addi, 'vis_zen');
    [sh1,filename]=scattery(addi.vis_zen.Lon, 'Longitude', ...
        addi.vis_zen.Lat, 'Latitude', ...
        ones(size(addi.vis_zen.t))*72, '', ...
        addi.vis_zen.t, 'UTC', ...
        'marker','+');
    sh=[sh; sh1(1)];
    lstr=[lstr {'ZEN'}];
end;
if isfield(addi, 'vis_skya');
    addis=addi.vis_skya;
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            [sh1,filename]=scattery(addis(i).Lon, 'Longitude', ...
                addis(i).Lat, 'Latitude', ...
                ones(size(addis(i).t))*72, '', ...
                addis(i).t, 'UTC', ...
                'marker','>');
        end;
    end;
    sh=[sh; sh1(1)];
    lstr=[lstr {'SKYA'}];
end;
if isfield(addi, 'vis_skyp');
    addis=addi.vis_skyp;
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            [sh1,filename]=scattery(addis(i).Lon, 'Longitude', ...
                addis(i).Lat, 'Latitude', ...
                ones(size(addis(i).t))*72, '', ...
                addis(i).t, 'UTC', ...
                'marker','^');
        end;
    end;
    sh=[sh; sh1(1)];
    lstr=[lstr {'SKYP'}];
end;
if isfield(addi, 'vis_forj');
    [sh1,filename]=scattery(addi.vis_forj.Lon, 'Longitude', ...
        addi.vis_forj.Lat, 'Latitude', ...
        ones(size(addi.vis_forj.t))*72, '', ...
        addi.vis_forj.t, 'UTC', ...
        'marker','o');
    sh=[sh; sh1(1)];
    lstr=[lstr {'FORJ'}];
end;
lh=legend(sh, lstr);
set(lh,'fontsize',12,'location','best');
ch=colorbarlabeled('UTC');
datetick(ch,'y','keeplimits');
title(daystr);
if savefigure;
    starsas(['star' daystr filename '.fig, TCquickplots.m']);
end;

figure;
ph=plot(t, m_ray, '.b', t, m_aero, '.c',t, Alt/1000, 'k.');
lstr={'Rayleigh Airmass','Aerosol Airmass','SUN'};
hold on;
if isfield(addi, 'vis_zen');
    ph1=plot(addi.vis_zen.t, addi.vis_zen.Alt/1000, '+', 'color', [.5 .5 .5],'markersize',6);
    lstr=[lstr {'ZEN'}];
    ph=[ph; ph1(1)];
end;
if isfield(addi, 'vis_skya');
    addis=addi.vis_skya;
    lstr=[lstr {'SKYA'}];
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            ph1=plot(addis(i).t, addis(i).Alt/1000, '>', 'color', 'c','markersize',6);
        end;
    end;
    ph=[ph; ph1(1)];
end;
if isfield(addi, 'vis_skyp');
    addis=addi.vis_skyp;
    lstr=[lstr {'SKYP'}];
    for i=1:length(addis);
        if ~isempty(addis(i).t);
            ph1=plot(addis(i).t, addis(i).Alt/1000, '^', 'color', 'c','markersize',6);
        end;
    end;
    ph=[ph; ph1(1)];
end;
if isfield(addi, 'vis_forj');
    ph1=plot(addi.vis_forj.t, addi.vis_forj.Alt/1000, 'o', 'color', [1 .5 0],'markersize',6);
    lstr=[lstr {'FORJ'}];
    ph=[ph; ph1(1)];
end;
ggla;
xlabel('UTC');
ylabel('Altitude (km) or Airmass Factor');
ylim([0 10]);
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
pos=get(gcf,'position');
set(gcf,'position',[1 53 1280 590]);
datetick('x','keeplimits');
set(gcf,'position',pos);
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'Altairmassestseries.fig, TCquickplots.m']);
end;

figure;
ph=plot(t, Pst, '.');
ggla;
xlabel('UTC');
ylabel('Pst (hPa)');
pos=get(gcf,'position');
set(gcf,'position',[1 53 1280 590]);
datetick('x','keeplimits');
set(gcf,'position',pos);
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'Psttseries.fig, TCquickplots.m']);
end;

figure;
ph=plot(t, Tst, '.');
ggla;
xlabel('UTC');
ylabel('Tst (^oC)');
pos=get(gcf,'position');
set(gcf,'position',[1 53 1280 590]);
datetick('x','keeplimits');
set(gcf,'position',pos);
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'Tsttseries.fig, TCquickplots.m']);
end;

figure;
plot(t,RHprecon_percent,'.',t,Tprecon_C,'.',t,Tbox_C,'.');
lh=legend('RH precon','Temperature precon','Temperature box');
set(lh,'fontsize',12,'location','best');
xlabel('UTC');
ylabel('RH (%) or Temperature (^oC)');
ylim([0 30]);
lh=legend('RH precon (%)', 'Tprecon (^oC)', 'Tbox (^oC)');
set(lh,'fontsize',12,'location','best');
datetick('x','keeplimits');
ggla;
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'TandRHtseries.fig, TCquickplots.m']);
end;

figure;
ph=plot(t,raw(:,c), '.');
lstr=setspectrumcolor(ph, w(c));
xlabel('UTC');
ylabel('Raw Count');
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
datetick('x','keeplimits');
ggla;
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'rawcounttseries.fig, TCquickplots.m']);
end;

figure;
ph=plot(t,rate(:,c), '.');
lstr=setspectrumcolor(ph, w(c));
xlabel('UTC');
ylabel('Count Rate (/ms)');
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
datetick('x','keeplimits');
ggla;
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'ratetseries.fig, TCquickplots.m']);
end;

figure;
ph=plot(t,rateaero(:,c), '.');
lstr=setspectrumcolor(ph, w(c));
xlabel('UTC');
ylabel('Count Rate (/ms) adjusted for Aerosols');
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
datetick('x','keeplimits');
ggla;
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'rateaerotseries.fig, TCquickplots.m']);
end;

figure;
ph=plot(t,tau_aero_noscreening(:,c), '.');
lstr=setspectrumcolor(ph, w(c));
xlabel('UTC');
ylabel('tau aero noscreening');
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
datetick('x','keeplimits');
ggla;
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'tau_aero_noscreeningtseries.fig, TCquickplots.m']);
end;

figure;
ph=plot(t,tau_aero(:,c), '.');
lstr=setspectrumcolor(ph, w(c));
set(ph(10),'markersize',1,'visible','off');
xlabel('UTC');
ylabel('tau aero');
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
datetick('x','keeplimits');
ggla;
grid on;
title(daystr);
if savefigure;
    starsas(['star' daystr 'tau_aerotseries.fig, TCquickplots.m']);
end;

figure; % Langley
% ok=incl(t, [datenum([2013 2 4 19 0 0]) Inf]);
ok=incl(t, langley);
ph=plot(m_aero(ok),rateaero(ok,c), '.');
lstr=setspectrumcolor(ph, w(c));
xlabel('Aerosol Airmass Factor');
ylabel('Count Rate (/ms) adjusted for Aerosols');
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
ggla;
grid on;
axis([0 15 -2 1000]);
set(ph([1 2 9:end]), 'visible','off','markersize',1);
starttstr=datestr(langley(1), 31);
stoptstr=datestr(langley(2), 13);
title([daystr ', ' starttstr ' - ' stoptstr]);
if savefigure;
    starsas(['star' daystr 'rateaerovairmass.fig, TCquickplots.m']);
end;

% prepare for FORJ plots
dAZdt=[diff(AZ_deg)./diff(t)/86400;0];
rows=(1:numel(t))';
cols=c(4);
ref=nanmean(rateaero(rows, cols));
ref=rateaero(474, cols);

% plot FORJ
figure; 
plot(t,AZ_deg, '.b')
xlabel('UTC');
ylabel('AZ deg');
ggla;
grid on;
title(daystr);
datetick('x','keeplimits');
if savefigure;
    starsas(['star' daystr 'AZdegtseries.fig, TCquickplots.m']);
end;

figure;
plot(t,mod(AZ_deg,360), '.b')
xlabel('UTC');
ylabel('AZ deg mod 360');
set(gca,'ylim',[-5 365], 'ytick',0:90:360);
ggla;
grid on;
title(daystr);
datetick('x','keeplimits');
if savefigure;
    starsas(['star' daystr 'AZdegmod360tseries.fig, TCquickplots.m']);
end;

figure;
[sh,filename]=scattery(mod(AZ_deg(rows,:),360),'AZ deg mod 360', ...
rateaero(rows,cols)./repmat(ref,size(rows)), 'Count Rate (/ms) for Aerosols', ...    
ones(size(rows))*24, '', ...
    dAZdt(rows), 'dAZ/dt (deg/s)', ...
    'clim',[-2 2]);
set(gca,'xlim',[-5 365], 'xtick',0:30:360, 'ylim', [0.94 1.06]);
lh=legend([num2str(w(cols)*1000, '%0.1f') 'nm']);
set(lh,'fontsize',12,'location','best');
hold on
plot(xlim, [1 1], '-k');
title(daystr);
if savefigure;
    starsas(['star' daystr 'relativerateaero' num2str(w(cols)*1000, '%0.0f') 'nmvAZdegmod360.fig, TCquickplots.m']);
end;

figure;
[sh,filename]=scattery(t(rows), 'UTC', ...
mod(AZ_deg(rows,:),360),'AZ deg mod 360', ...
ones(size(rows))*24, '', ...
rateaero(rows,cols)./repmat(ref,size(rows)), 'Count Rate (/ms) for Aerosols', ...    
    'clim',[0.98 1.02]);
set(gca,'ylim',[-5 365], 'ytick',0:30:360);
title(daystr);
datetick('x','keeplimits');
if savefigure;
    starsas(['star' daystr 'AZdegmod360tseriescolorrelativerateaero' num2str(w(cols)*1000, '%0.0f') 'nm.fig, TCquickplots.m']);
end;

% rerun
dslist={'20130204' '20130205' '20130207' '20130212' '20130213' '20130214' '20130215' '20130218' '20130219' '20130220' '20130221' '20130223' '20130225' '20130226' '20130227'};
for i=1:length(dslist);
    starfile=fullfile(starpaths, [dslist{i} 'star.mat']);
    starsunfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
    if exist(starsunfile);
        error([starsunfile ' exists.']);
    end;
    starsun(starfile, starsunfile);
    disp(dslist{i});
end;

% count the number of tau aero and other stats on data availability
figure
for i=1:length(dslist);
    starsunfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
    if exist(starsunfile);
load(starsunfile, 't','Pst','Alt');
plot(t,Alt,'.k');
hold on;
    end;end;
ylim([-20 60]);

for i=1:length(dslist);
    starfile=fullfile(starpaths, [dslist{i} 'star.mat']);
    starsunfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
    sunminutes=0;
    skycounts=0;
    zenminutes=0;
    clear vis_skya vis_skyp vis_zen
    if exist(starsunfile);
        load(starsunfile, 'tau_aero','t','visfilen','Alt');
        difft=[diff(t);0];
        ok=find([diff(visfilen);-1]==0 & isfinite(tau_aero(:,408))==1 & Alt>30);
        sunminutes=round(sum(difft(ok))*60*24);
    end;
    load(starfile,'vis_skya','vis_skyp','vis_zen');
    if exist('vis_skya');
        for ii=1:numel(vis_skya);
            if ~isempty(vis_skya(ii).t);
                %                     disp(vis_skya(ii).filename)
                skycounts=skycounts+1;
            end;
        end;
    end;
    if exist('vis_skyp');
        for ii=1:numel(vis_skyp);
            if ~isempty(vis_skyp(ii).t);
                %                     disp(vis_skyp(ii).filename)
                skycounts=skycounts+1;
            end;
        end;
    end;
    if exist('vis_zen');
        difft=[diff(vis_zen.t);0];
        ok=find([diff(vis_zen.filen);-1]==0 & vis_zen.Alt>30);
        zenminutes=round(sum(difft(ok))*60*24);
    end;
    disp([num2str(sunminutes) ', ' num2str(skycounts) ', ' num2str(zenminutes)]);
    disp(dslist{i});
end;