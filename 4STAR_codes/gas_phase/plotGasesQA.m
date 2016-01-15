function plotGasesQA(daystr)
%---------------------------------------------
% routine to plot some QA plots to assess gases retrievals;
%--------------------------------------------------------------------------

% Michal Segal-Rozenhaimer, 2016-01-11, MLO

% upload files and read
%----------------------
g = load(strcat(starpaths,daystr,'starsun.mat'));

% plots
%------
Loschmidt=2.686763e19; %molecules/cm2

% 1. gas traces with time
% O3
figure(1);
ax(1)=subplot(211); plot(serial2Hh(g.t),g.gas.o3,'or');
ylabel('O_{3} [DU]');title(daystr);
ax(2)=subplot(212); plot(serial2Hh(g.t),g.gas.o3resi,'om');
hold on;
plot(serial2Hh(g.t),g.m_O3,'-c','linewidth',2);
xlabel('time'); ylabel('O_{3} residual');
linkaxes(ax,'x');

figure(2);
ax(1)=subplot(211); plot(serial2Hh(g.t),g.gas.o3Inv,'or');
ylabel('O_{3} Inverse [DU]');title(daystr);
ax(2)=subplot(212); plot(serial2Hh(g.t),g.gas.o3resiInv,'om');
hold on;
plot(serial2Hh(g.t),g.m_O3,'-c','linewidth',2);
xlabel('time'); ylabel('O_{3} Inverse residual');
linkaxes(ax,'x');

% NO2
figure(3);
ax(1)=subplot(211); plot(serial2Hh(g.t),g.gas.no2,'or');
ylabel('NO_{2} [DU]');
ax(2)=subplot(212); plot(serial2Hh(g.t),g.gas.no2resi,'om');
xlabel('time'); ylabel('NO_{2} residual');

% 2. plot traces with airmass

% O3
figure(11);
ax(1)=subplot(211); plot(g.m_O3,g.gas.o3,'or');
ylabel('O_{3} [DU]');title(daystr);
ax(2)=subplot(212); plot(g.m_O3,g.gas.o3resi,'om');
xlabel('airmass'); ylabel('O_{3} residual');
linkaxes(ax,'x');

figure(22);
ax(1)=subplot(211); plot(g.m_O3,g.gas.o3Inv,'or');
ylabel('O_{3} Inverse [DU]');title(daystr);
ax(2)=subplot(212); plot(g.m_O3,g.gas.o3resiInv,'om');
xlabel('airmass'); ylabel('O_{3} Inverse residual');
linkaxes(ax,'x');

% 3. plot traces with track_err

o3Start = interp1(g.w,[1:length(g.w)],0.490,  'nearest');
o3End   = interp1(g.w,[1:length(g.w)],0.6823, 'nearest');

o3TrackErr = nanmean(g.track_err(:,o3Start:o3End),2);

% O3
figure(111);
ax(1)=subplot(211); plot(o3TrackErr,g.gas.o3,'or');
ylabel('O_{3} [DU]');title(daystr);
ax(2)=subplot(212); plot(o3TrackErr,g.gas.o3resi,'om');
xlabel('tracking err'); ylabel('O_{3} residual');
linkaxes(ax,'x');

figure(222);
ax(1)=subplot(211); plot(o3TrackErr,g.gas.o3Inv,'or');
ylabel('O_{3} Inverse [DU]');title(daystr);
ax(2)=subplot(212); plot(o3TrackErr,g.gas.o3resiInv,'om');
xlabel('tracking err'); ylabel('O_{3} Inverse residual');
linkaxes(ax,'x');


% plot best fit vs. inversion

figure;
plot(serial2Hh(s.t),O3conc,'or');hold on;
plot(serial2Hh(s.t),o3vcd_smooth,'ob');
legend('best fit-no no2','inversion-no no2');
xlabel('time');ylabel('o3 [DU]');

% add 

% plot best fit vs. inversion

% figure;
% plot(serial2Hh(s.t),O3conc,'or');hold on;
% plot(serial2Hh(s.t),o3vcd_smooth,'ob');hold on;
% plot(serial2Hh(s.t),g.gas.o3Inv,'.g');hold on;
% legend('best fit-no no2','inversion-no no2','inversion-original');
% xlabel('time');ylabel('o3 [DU]');
% 
% % compare smooth to no smooth with inversion
% figure;
% plot(serial2Hh(s.t),o3VCD,'ob');hold on;
% plot(serial2Hh(s.t),o3vcd_smooth,'.r');hold on;
% legend('inversion-no smooth','inversion-smooth');
% xlabel('time');ylabel('o3 [DU]');

% figure;
% ax(1)=subplot(211)
% plot(serial2Hh(s.t),s.cwv.cwv940m1,'ob');hold on;
% plot(serial2Hh(s.t),s.cwv.cwv940m2,'oc');hold on;
% ylabel('cwv');
% ax(2)=subplot(212)
% plot(serial2Hh(s.t),s.cwv.cwv940m1std,'ob');hold on;
% plot(serial2Hh(s.t),s.cwv.cwv940m2resi,'oc');hold on;
% xlabel('time');ylabel('cwv');
% linkaxes(ax,'x');
% legend('cwv1','cwv2');

%no2- region 1
 gas.no2Inv    = no2vcdpca_smooth;%NO2conc;%in [DU]
    gas.no2resiInv= RMSEno2;%sqrt(NO2resi);
   
   gas.no2  = NO2conc;%in [DU]
   gas.no2resi= NO2resi;
   
% NO2
figure;
ax(1)=subplot(211); plot(serial2Hh(s.t),gas.no2,'or');
ylabel('NO_{2} [DU]-480-515 best fit');
ax(2)=subplot(212); plot(serial2Hh(s.t),gas.no2resi,'om');
xlabel('time'); ylabel('NO_{2} residual');

figure;
ax(1)=subplot(211); plot(serial2Hh(s.t),gas.no2Inv,'or');
ylabel('NO_{2} [DU]-480-515 inversion');
ax(2)=subplot(212); plot(serial2Hh(s.t),gas.no2resiInv,'om');
xlabel('time'); ylabel('NO_{2} residual');
linkaxes(ax,'x');




