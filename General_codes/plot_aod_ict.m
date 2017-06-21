% plot aod_ict
%--------------

ict = ictread('D:\MichalsData\KORUS-AQ\aod_ict\korusaq-4STAR-AOD_DC8_20160601_R1.ict');

% AOD 500 nm - all
% AOD 500 nm - good (qual_flag==0)
% Altitude

figure(1);
ax(1) = subplot(3,1,1);
plot((ict.Start_UTC/86400)*24,ict.AOD0501,'.b');legend('AOD 500 nm - all');
xlabel('time [UTC]');ylabel('AOD');title(ict.note);
ax(2) = subplot(3,1,2);
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD0501(ict.qual_flag==0),'.g');hold on;
% add uncertainty
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD0501(ict.qual_flag==0)+ict.UNCAOD0501(ict.qual_flag==0),':k');
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD0501(ict.qual_flag==0)-ict.UNCAOD0501(ict.qual_flag==0),':k');
legend('AOD 500 nm - good','AOD 500 nm - unc');
xlabel('time [UTC]');ylabel('AOD');
ax(3) = subplot(3,1,3);
plot((ict.Start_UTC/86400)*24,ict.GPS_Alt,'-k');legend('GPS-Altitude');
xlabel('time [UTC]');ylabel('Altitude [m]');
linkaxes(ax,'x');

% AOD wavelength dependent several wavelengths
figure(2)
%ax(4) = subplot(4,1,4);
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD0452(ict.qual_flag==0),'.b');hold on;
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD0501(ict.qual_flag==0),'.g');hold on;
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD0781(ict.qual_flag==0),'.y');hold on;
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD0865(ict.qual_flag==0),'.r');hold on;
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD1020(ict.qual_flag==0),'.c');hold on;
plot((ict.Start_UTC(ict.qual_flag==0)/86400)*24,ict.AOD1559(ict.qual_flag==0),'.m');hold off;
legend('AOD 452 nm - good', 'AOD 500 nm - good', 'AOD 781 nm - good','AOD 865 nm - good','AOD 1020 nm - good','AOD 1559 nm - good');
axis([min((ict.Start_UTC(ict.qual_flag==0)/86400)*24) max((ict.Start_UTC(ict.qual_flag==0)/86400)*24) min(ict.AOD0501(ict.qual_flag==0)),max(ict.AOD0501(ict.qual_flag==0))]);
xlabel('time [UTC]');ylabel('AOD');title(ict.note);




