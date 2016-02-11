% simple 4star-aats comparison

% load aats
aats=load('C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\mat_files\20160114aats.mat');

% load 4star
star=load('20160114starsun_wFORJcorr_meanc0.mat','tau_aero','tau_aero_noscreening','m_aero','t','AZstep','w');
%star=load('20160113starsunFORJcorrected1.mat','tau_aero','m_aero','t','AZstep','w');
% compute AZ
az = mod((star.AZstep)/18000,360);

% plot tau_aero at 500 nm (channel 4 for aats and 407 for 4star)
figure;
plot(aats.UT,aats.tau_aero(4,:),'ob');hold on;
plot(serial2Hh(star.t),star.tau_aero_noscreening(:,407),'.g');
legend('aats','4star');
xlabel('time');ylabel(' 500 nm AOD');title(datestr(star.t(1),'yyyy-mm-dd'));
axis([min(aats.UT) max(aats.UT) 0 0.03]);

% interpolate 4star to aats
starInterp = interp1(serial2Hh(star.t),star.tau_aero_noscreening(:,407),aats.UT);

figure;
plot(aats.UT,starInterp-aats.tau_aero(4,:),'.g');hold on;
plot(aats.UT,zeros(length(aats.UT),1),'--k','linewidth',2);
xlabel('time');ylabel('500 nm AOD difference (4STAR-AATS-14)');
title(datestr(star.t(1),'yyyy-mm-dd'));
axis([min(aats.UT) max(aats.UT) -0.01 0.01]);

% plot difference tau_aero at 500 nm (channel 4 for aats and 407 for 4star)

% interpolate 4star to aats

starInterp = interp1(serial2Hh(star.t),star.tau_aero_noscreening(:,407),aats.UT);

figure;
plot(aats.UT,starInterp-aats.tau_aero(4,:),'.g');hold on;
plot(aats.UT,zeros(length(aats.UT),1),'--k','linewidth',2);
xlabel('time');ylabel('500 nm AOD difference (4STAR-AATS-14)');
title(datestr(star.t(1),'yyyy-mm-dd'));
axis([min(aats.UT) max(aats.UT) -0.01 0.01]);

% plot tau_aero at 452 nm (channel 4 for aats and 407 for 4star)
figure;
plot(aats.UT,aats.tau_aero(3,:),'ob');hold on;
plot(serial2Hh(star.t),star.tau_aero_noscreening(:,347),'.g');
legend('aats','4star');
xlabel('time');ylabel(' 452 nm AOD');title(datestr(star.t(1),'yyyy-mm-dd'));
axis([min(aats.UT) max(aats.UT) 0 0.03]);

% plot difference tau_aero at 452 nm (channel 4 for aats and 407 for 4star)

% interpolate 4star to aats

starInterp = interp1(serial2Hh(star.t),star.tau_aero_noscreening(:,347),aats.UT);

figure;
plot(aats.UT,starInterp-aats.tau_aero(3,:),'.g');hold on;
plot(aats.UT,zeros(length(aats.UT),1),'--k','linewidth',2);
xlabel('time');ylabel('452 nm AOD difference (4STAR-AATS-14)');
title(datestr(star.t(1),'yyyy-mm-dd'));
axis([min(aats.UT) max(aats.UT) -0.02 0.02]);




% plot difference tau_aero at multiple wavelengths
% aats: 0.3545	0.38	0.452	0.5005	0.5207	0.6052	0.6751	0.7805	0.8645	0.94	1.0191	1.2356	1.5584	2.1391

aatsind = [1 2 4 5 7];
starind = [226 227; 
           257 259;
           407 408;
           432 434;
           626 628];

starinterp = zeros(length(aats.UT),length(aatsind));

for i=1:length(aatsind)
    starinterp(:,i) = interp1(serial2Hh(star.t),nanmean(star.tau_aero(:,starind(i,1):starind(i,2)),2),aats.UT);
end

% plot differences on same figure
colorlist_ = varycolor(120);
colorlist  = colorlist_(120:-15:1,:);
figure;
for i=1:length(aatsind)
        plot(aats.UT,starinterp(:,i)'-aats.tau_aero(aatsind(i),:),'.','color',colorlist(i,:));hold on;
        
end
        plot(aats.UT,zeros(length(aats.UT),1),'--k','linewidth',2);hold off;
        legend('354 nm','380 nm','500 nm','520 nm','675 nm');
        xlabel('time');ylabel('AOD difference (4STAR-AATS-14)');
        title(datestr(star.t(1),'yyyy-mm-dd'));
        axis([min(aats.UT) max(aats.UT) -0.04 0.04]);




