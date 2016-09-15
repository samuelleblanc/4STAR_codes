% prepare AOD and Ang scatter plots
%------------------------------------

%% load data
s=load('E:\ORACLES\20160914_ORACLES_RF09\4STAR_20160914starsun.mat');


%% plot AOD scatter

figure(1);
scatter(s.Lon,s.Lat,10,s.tau_aero(:,407));colormap(redblue);colorbarlabeled('AOD at 500 nm');
xlabel('Longitude','fontsize',16);
ylabel('Latitude','fontsize',16);
title(datestr(s.t(1),'yyyy-mm-dd'),'fontsize',16);
set(gca,'fontsize',16,'color',[0.8 0.8 0.8]);
caxis([0.1 0.5]);

%% plot AOD scatter between 700-1500 m
alt_thresh = [700 1500];
alt_ind    = find(s.Alt<=alt_thresh(2)&s.Alt>=alt_thresh(1));
figure(2);
scatter(s.Lon(alt_ind),s.Lat(alt_ind),10,s.tau_aero(alt_ind,407));caxis([0.1 0.5]);colormap(redblue);colorbarlabeled('AOD at 500 nm');
xlabel('Longitude','fontsize',16);
ylabel('Latitude','fontsize',16);
title(strcat('AOD between 700-1500 [m] ',datestr(s.t(1),'yyyy-mm-dd')),'fontsize',16);
set(gca,'fontsize',16,'color',[0.8 0.8 0.8]);

%% plot Ang scatter
% calculate Ang at 500 nm
ang = -(2*s.tau_aero_polynomial(:,1)*log(s.w(407)) + s.tau_aero_polynomial(:,2));
figure(3);
scatter(s.Lon,s.Lat,10,ang);colormap(redblue);colorbarlabeled('Angstrom Exponent at 500 nm');
xlabel('Longitude','fontsize',16);
ylabel('Latitude','fontsize',16);
title(datestr(s.t(1),'yyyy-mm-dd'),'fontsize',16);
set(gca,'fontsize',16,'color',[0.8 0.8 0.8]);
caxis([0 2.5]);


%% plot Ang scatter between 700-1500

figure(4);
scatter(s.Lon(alt_ind),s.Lat(alt_ind),10,ang(alt_ind));colormap(redblue);colorbarlabeled('Angstrom Exponent at 500 nm');
xlabel('Longitude','fontsize',16);
ylabel('Latitude','fontsize',16);
title(strcat('Angstrom Exponent between 700-1500 [m] ',datestr(s.t(1),'yyyy-mm-dd')),'fontsize',16);
set(gca,'fontsize',16,'color',[0.8 0.8 0.8]);
caxis([0 2.5]);
