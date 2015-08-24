% 4STAR related lines for quick data processing, prior to the 2014 Alaska
% campaign.

%********************
% 20140407, 20140408
%********************
% 20140407, 20140408 - prepare data
daystr='20140407';
[both, ~, aats]=staraatscompare(daystr);
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

% 20140407, 20140408 - temperature test
% note the special temp sensors for this day
figure;
cols=4;
ph=plot(Tsm(:,1), both.raterelativeratiotoaats(:,cols), '.');
hold on;
plot(xlim, [1 1], '-k');
lstr=setspectrumcolor(ph, both.aatsw(cols));
ggla;
xlabel('T1 Sun Barrel Temperature (^oC)');
ylabel('4STAR C / AATS V');
ylabel(ystr);
ylim([0.96 1.04]);
grid on;
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
title([daystr ', ' num2str(both.bl*86400) 's avg']);
set(ph([1 2 10 14]), 'markersize',1,'visible','off');
if savefigure;
    starsas(['star' daystr 'raterelativeratiovT1.fig, ALquickplots.m']);
end;

%********************
% 20140318, 20140320, 20140324, diffuser on and off tests with AATS 
%********************
% prepare data
daystrlist={'20140318' '20140320' '20140324' '20140325'};
daystrlist={'20140324'};
daystrliststr=[];
for i=1:numel(daystrlist);
    [both(i), ~, aats]=staraatscompare(daystrlist{i});
    daystrliststr=[daystrliststr daystrlist{i} ' and '];
end;

% plot rate ratio (not normalized)
figure;
cols=4;
plot(both(1).t, both(1).rateratiotoaats(:,cols), '.', 'color', [.5 .5 .5]);
hold on;
plot(both(2).t-2, both(2).rateratiotoaats(:,cols), '.r');
ggla;
xlabel('Time of the day');
datetick('x','keeplimits');
ylabel('4STAR C / AATS V');
ylim([0 1500]);
grid on;
lh=legend(daystrlist);
set(lh,'fontsize',12,'location','best');
title(daystrliststr(1:end-5));
if savefigure;
    starsas(['star' strcat(daystrlist{:}) 'Rateratiotseries.fig, ALquickplots.m']);
end;

% plot rate ratio after normalizing, at one wavelength
figure;
cols=4;
plot(both(1).t, both(1).raterelativeratiotoaats(:,cols), '.', 'color', [.5 .5 .5]);
hold on;
plot(both(2).t-2, both(2).raterelativeratiotoaats(:,cols), '.r');
plot(xlim, [1 1], '-k');
ggla;
xlabel('Time of the day');
datetick('x','keeplimits');
ylabel('4STAR C / AATS V');
ylim([0.96 1.04]);
grid on;
lh=legend(daystrlist);
set(lh,'fontsize',12,'location','best');
title(daystrliststr(1:end-5));
if savefigure;
    starsas(['star' strcat(daystrlist{:}) 'Raterelativeratiotseries.fig, ALquickplots.m']);
end;

% plot rate ratio after normalizing, at all AATS aerosol channels
figure;
i=1;
ph=plot(both(i).t, both(i).raterelativeratiotoaats, '.');
hold on;
plot(xlim, [1 1], '-k');
lstr=setspectrumcolor(ph, both(i).aatsw);
ggla;
xlabel('UTC');
datetick('x','keeplimits');
ystr=['4STAR Count Rate / AATS Voltage (' datestr(both(i).t(both(i).noonrow),13) '=1)'];
ylabel(ystr);
ylim([0.96 1.04]);
grid on;
lh=legend(ph, lstr);
set(lh,'fontsize',12,'location','best');
title([daystrlist{i} ', ' num2str(both(i).bl*86400) 's avg']);
set(ph([1 2 10 14]), 'markersize',1,'visible','off');
if savefigure;
    starsas(['star' daystrlist{i} 'Raterelativeratiotseries.fig, ALquickplots.m']);
end;

% plot 4STAR rate and AATS data after normalizing, at all AATS aerosol channels
figure;
i=1;
cols=[1:9 11:13];
isf=sum(isfinite(aats.starvisrateratio),2);
isfok=find(isf==max(isf)); % This method does not always avoid NaN, but almost always.
%         isfok=find(isf==max(isf) & sum(s.flag,2)==0); % This method does not always avoid NaN, but almost always.
[dummy, aats.noonrow]=min(aats.m_ray(isfok)); % find solar noon
aats.noonrow=isfok(aats.noonrow);
ph=plot(aats.t, aats.data(:,cols).*repmat(aats.starvisrateratio(aats.noonrow,cols),size(aats(i).t)), '-', ...
    both(i).t, both(i).rate(:,both(i).c(2,cols)), '-');
hold on;
lstr=setspectrumcolor(ph((1:numel(cols))+numel(cols)), both(i).aatsw(cols));
for cc=1:numel(cols);
    set(ph(cc), 'color', get(ph(cc+numel(cols)),'color')/2+0.5);
end;
ggla;
xlabel('UTC');
datetick('x','keeplimits');
ystr=['4STAR C (norm''d at ' datestr(both(i).t(both(i).noonrow),13) ') or AATS Voltage'];
ylabel(ystr);
grid on;
lh=legend(ph((1:numel(cols))+numel(cols)), lstr);
set(lh,'fontsize',12,'location','best');
title([daystrlist{i} ', ' num2str(both(i).bl*86400) 's avg']);
if savefigure;
    starsas(['star' daystrlist{i} 'RateandAATSdatatseries.fig, ALquickplots.m']);
end;

% plot 4STAR rate and AATS data after normalizing, at all AATS aerosol channels
figure;
i=1;
cols=[1:9 11:13];
isf=sum(isfinite(aats.starvisrateratio),2);
isfok=find(isf==max(isf)); % This method does not always avoid NaN, but almost always.
%         isfok=find(isf==max(isf) & sum(s.flag,2)==0); % This method does not always avoid NaN, but almost always.
[dummy, aats.noonrow]=min(aats.m_ray(isfok)); % find solar noon
aats.noonrow=isfok(aats.noonrow);
ph=semilogy(aats.m_aero, aats.data(:,cols).*repmat(aats.starvisrateratio(aats.noonrow,cols),size(aats(i).t)), '-', ...
    both(i).m_aero, both(i).rate(:,both(i).c(2,cols)), '-');
hold on;
lstr=setspectrumcolor(ph((1:numel(cols))+numel(cols)), both(i).aatsw(cols));
for cc=1:numel(cols);
    set(ph(cc), 'color', get(ph(cc+numel(cols)),'color')/2+0.5);
end;
ggla;
xlabel('Aerosol Airmass Factor');
ystr=['4STAR C or AATS Voltage (norm''d at ' datestr(both(i).t(both(i).noonrow),13) ')'];
ylabel(ystr);
grid on;
lh=legend(ph((1:numel(cols))+numel(cols)), lstr);
set(lh,'fontsize',12,'location','best');
title([daystrlist{i} ', ' num2str(both(i).bl*86400) 's avg']);
if savefigure;
    starsas(['star' daystrlist{i} 'RateandAATSdatavm_aero.fig, ALquickplots.m']);
end;


