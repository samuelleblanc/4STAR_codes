%% plot aod_ict
%---------------

ict = ictread('E:\MichalsData\KORUS-AQ\aod_ict\korusaq-4STAR-AOD_DC8_20160601_R1.ict');

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

%% plot_aod_ict_compare
%-----------------------

% load files (2 different c0's)

%dslist={'20160426' '20160501' '20160503' '20160504' '20160506' '20160510' '20160511' '20160512' '20160516' '20160517' '20160519' '20160521' '20160524' '20160526' '20160529' '20160530' '20160601' '20160602' '20160604' '20160608' '20160609' '20160614' '20160617' '20160618'} ; %put one day string
dslist={'20160501' '20160503' '20160504' '20160506' '20160510' '20160511' '20160512' '20160516' '20160517' '20160519' '20160521' '20160524' '20160526' '20160529' '20160530' '20160601' '20160602' '20160604' '20160608' '20160609' '20160614' '20160617' '20160618'} ; %put one day string
%dslist={'20160601','20160604','20160609','20160614','20160617','20160618'} ; %put one day string
dslist={'20160510','20160519','20160602','20160604','20160609'};
path0707 = 'E:\MichalsData\KORUS-AQ\aod_ict\with_0707c0_corrected\';% no deposition correction
path0426 = 'E:\MichalsData\KORUS-AQ\aod_ict\with_0426c0_corrected\';% no deposition correction

for i=1:length(dslist)

    ict0707 = ictread([path0707,'korusaq-4STAR-AOD_DC8_',dslist{:,i},'_R1.ict']);
    ict0426 = ictread([path0426,'korusaq-4STAR-AOD_DC8_',dslist{:,i},'_R2.ict']);
    
    % compare AOD with altitude - no window deposition correction
    
    figure(11);
    ax(1)=subplot(1,2,1);
    plot(ict0426.AOD0452(ict0426.qual_flag==0),ict0426.GPS_Alt(ict0426.qual_flag==0),'.b');hold on;
    plot(ict0426.AOD0501(ict0426.qual_flag==0),ict0426.GPS_Alt(ict0426.qual_flag==0),'.g');hold on;
    plot(ict0426.AOD0781(ict0426.qual_flag==0),ict0426.GPS_Alt(ict0426.qual_flag==0),'.y');hold on;
    plot(ict0426.AOD0865(ict0426.qual_flag==0),ict0426.GPS_Alt(ict0426.qual_flag==0),'.r');hold on;
    plot(ict0426.AOD1020(ict0426.qual_flag==0),ict0426.GPS_Alt(ict0426.qual_flag==0),'.c');hold on;
    plot(ict0426.AOD1559(ict0426.qual_flag==0),ict0426.GPS_Alt(ict0426.qual_flag==0),'.m');hold on;
    plot(zeros(length(ict0426.AOD1559(ict0426.qual_flag==0)),1),ict0426.GPS_Alt(ict0426.qual_flag==0),'--k','linewidth',2);hold off;
    legend('AOD 452 nm - good', 'AOD 500 nm - good', 'AOD 781 nm - good','AOD 865 nm - good','AOD 1020 nm - good','AOD 1559 nm - good');
    axis([-0.05,max(ict0426.AOD0501(ict0426.qual_flag==0)),0 max(ict0426.GPS_Alt(ict0426.qual_flag==0)) ]);
    ylabel('Alt [m]');xlabel('AOD');title([dslist{:,i}, ' with 0426 c0 corrected']);
    
    ax(2)=subplot(1,2,2);
    plot(ict0707.AOD0452(ict0707.qual_flag==0),ict0707.GPS_Alt(ict0707.qual_flag==0),'.b');hold on;
    plot(ict0707.AOD0501(ict0707.qual_flag==0),ict0707.GPS_Alt(ict0707.qual_flag==0),'.g');hold on;
    plot(ict0707.AOD0781(ict0707.qual_flag==0),ict0707.GPS_Alt(ict0707.qual_flag==0),'.y');hold on;
    plot(ict0707.AOD0865(ict0707.qual_flag==0),ict0707.GPS_Alt(ict0707.qual_flag==0),'.r');hold on;
    plot(ict0707.AOD1020(ict0707.qual_flag==0),ict0707.GPS_Alt(ict0707.qual_flag==0),'.c');hold on;
    plot(ict0707.AOD1559(ict0707.qual_flag==0),ict0707.GPS_Alt(ict0707.qual_flag==0),'.m');hold on;
    plot(zeros(length(ict0707.AOD1559(ict0707.qual_flag==0)),1),ict0707.GPS_Alt(ict0707.qual_flag==0),'--k','linewidth',2);hold off;
    legend('AOD 452 nm - good', 'AOD 500 nm - good', 'AOD 781 nm - good','AOD 865 nm - good','AOD 1020 nm - good','AOD 1559 nm - good');
    axis([-0.05,max(ict0707.AOD0501(ict0707.qual_flag==0)),0 max(ict0707.GPS_Alt(ict0707.qual_flag==0)) ]);
    ylabel('Alt [m]');xlabel('AOD');title([dslist{:,i}, ' with 0707 c0 corrected']);
    
    linkaxes(ax,'x');
    
    %set(gcf, 'PaperUnits', 'inches');
    %x_width=7.25 ;y_width=9.125;
    %set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [10, 9.125])
    fi = strcat('E:\MichalsData\KORUS-AQ\aod_ict\aod_ict_figs_June-15-archive\',dslist{:,i},'AOD_per_Alt_compare_c0_corrected');
    save_fig(11,fi,false);
    
    close(11);
    
    % compare AOD and uncertainty (no window deposition correction)
    
    figure(111);
    ax(1) = subplot(2,1,1);
    %0426 c0 
    plot((ict0426.Start_UTC(ict0426.qual_flag==0)/86400)*24,ict0426.AOD0501(ict0426.qual_flag==0),'.b');hold on;
    %0707 c0
    plot((ict0707.Start_UTC(ict0707.qual_flag==0)/86400)*24,ict0707.AOD0501(ict0707.qual_flag==0),'.g');hold on;
    
    % add uncertainty
    plot((ict0426.Start_UTC(ict0426.qual_flag==0)/86400)*24,ict0426.AOD0501(ict0426.qual_flag==0)+ict0426.UNCAOD0501(ict0426.qual_flag==0),':b');
    plot((ict0426.Start_UTC(ict0426.qual_flag==0)/86400)*24,ict0426.AOD0501(ict0426.qual_flag==0)-ict0426.UNCAOD0501(ict0426.qual_flag==0),':b');
    
    % add uncertainty
    plot((ict0707.Start_UTC(ict0707.qual_flag==0)/86400)*24,ict0707.AOD0501(ict0707.qual_flag==0)+ict0707.UNCAOD0501(ict0707.qual_flag==0),':g');
    plot((ict0707.Start_UTC(ict0707.qual_flag==0)/86400)*24,ict0707.AOD0501(ict0707.qual_flag==0)-ict0707.UNCAOD0501(ict0707.qual_flag==0),':g');
    axis([min(ict0707.Start_UTC(ict0707.qual_flag==0)/86400)*24 max(ict0707.Start_UTC(ict0707.qual_flag==0)/86400)*24 0 1]); 
    legend('AOD 500 nm - 0426 c0','AOD 500 nm - 0707 c0');
    xlabel('time [UTC]');ylabel('AOD');
    title([dslist{:,i}]);
    
    ax(2) = subplot(2,1,2);
    plot((ict0707.Start_UTC/86400)*24,ict0707.GPS_Alt,'-k','linewidth',2);legend('GPS-Altitude');
    xlabel('time [UTC]');ylabel('Altitude [m]');
    linkaxes(ax,'x');
    
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [10, 9.125])
    fi = strcat('E:\MichalsData\KORUS-AQ\aod_ict\aod_ict_figs_June-15-archive\',dslist{:,i},'AOD_500nm_timeseries_corrected');
    save_fig(111,fi,false);
    close(111);

end


