% quick program to load up zenith radiances and plot them vs. integration
% times.
clear
%% load up the files
dir='C:\Users\sleblan2\Research\4STAR\SEAC4RS\';
a=[dir '20130913\20130913starzen_2.mat'];
b=[dir '20130916\20130916starzen.mat'];
c=[dir '20130830\20130830starzen.mat'];

s1=load(a);
s2=load(b);
s3=load(c);

%% get the histograms of integration times
[s1.vhist s1.vcenters]=hist(s1.visTint,20);
[s2.vhist s2.vcenters]=hist(s2.visTint,20);
[s3.vhist s3.vcenters]=hist(s3.visTint,20);

[s1.nhist s1.ncenters]=hist(s1.nirTint,20);
[s2.nhist s2.ncenters]=hist(s2.nirTint,20);
[s3.nhist s3.ncenters]=hist(s3.nirTint,20);


%% histogram plots
figure(1);
subplot(2,1,1)
plot(s1.vcenters,s1.vhist./sum(s1.vhist),'+');
hold on;
plot(s2.vcenters,s2.vhist./sum(s2.vhist),'ro');
plot(s3.vcenters,s3.vhist./sum(s3.vhist),'g.');

plot(s1.vcenters,s1.vhist./sum(s1.vhist),'b');
plot(s2.vcenters,s2.vhist./sum(s2.vhist),'r');
plot(s3.vcenters,s3.vhist./sum(s3.vhist),'g');
hold off;
title('Vis spectrometer');
legend('20130913','20130916','20130830');
xlabel('Integration Times (ms)');
ylabel('Normalized counts');

subplot(2,1,2);
plot(s1.ncenters,s1.nhist./sum(s1.nhist),'+');
hold on;
plot(s2.ncenters,s2.nhist./sum(s2.nhist),'ro');
plot(s3.ncenters,s3.nhist./sum(s3.nhist),'g.');

plot(s1.ncenters,s1.nhist./sum(s1.nhist),'b');
plot(s2.ncenters,s2.nhist./sum(s2.nhist),'r');
plot(s3.ncenters,s3.nhist./sum(s3.nhist),'g');
hold off;
title('NIR spectrometer');
legend('20130913','20130916','20130830');
xlabel('Integration Times (ms)');
ylabel('Normalized counts');

%% scatter plot of integration times
figure(2);
subplot(2,1,1)
scatter(s1.visTint,s1.rad(:,500)./1000,'b+');
hold on;
scatter(s2.visTint,s2.rad(:,500)./1000,'ro');
scatter(s3.visTint,s3.rad(:,500)./1000,'g.');
hold off;
title('Vis spectrometer');
legend('20130913','20130916','20130830');
xlabel('Integration Times (ms)');
ylabel('Radiance at 574 nm (Wm^{-2} sr^{-1} nm^{-1})');
grid on;


subplot(2,1,2)
scatter(s1.nirTint,s1.rad(:,1190)./1000,'b+');
hold on;
scatter(s2.nirTint,s2.rad(:,1190)./1000,'ro');
scatter(s3.nirTint,s3.rad(:,1190)./1000,'g.');
hold off;
title('NIR spectrometer');
legend('20130913','20130916','20130830');
xlabel('Integration Times (ms)');
ylabel('Radiance at 1199 nm (Wm^{-2} sr^{-1} nm^{-1})');
grid on;

%% proportion of saturated pixels vs. integration time
figure(3);
subplot(2,1,1);
plot(s1.visTint, s1.sat_time,'b+');
hold on;
plot(s2.visTint, s2.sat_time,'ro');
plot(s3.visTint, s3.sat_time,'g.');
hold off;
title('VIS Saturation per integration time');
xlabel('Integration Times (ms)');
legend('20130913','20130916','20130830');
ylim([-0.1,1.1]);
grid on;

subplot(2,1,2);
plot(s1.nirTint, s1.sat_time,'b+');
hold on;
plot(s2.nirTint, s2.sat_time,'ro');
plot(s3.nirTint, s3.sat_time,'g.');
hold off;
title('NIR Saturation per integration time');
xlabel('Integration Times (ms)');
legend('20130913','20130916','20130830');
ylabel('Saturation');
ylim([-0.1,1.1]);
grid on;