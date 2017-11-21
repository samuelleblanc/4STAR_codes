load('C:\Users\sleblan2\Research\ARISE\c130\20140904\20140904starzen.mat');
utc=t2utch(t);
iv=400;
figure(1); clf; subplot(1,2,1);
plot(w*1000.,rad(iv,:)/1000.,'.r')
xlabel('Wavelength [nm]');
xlim([350 1750]);
ylabel('Radiance [W/(m^2 nm sr)]')
title(['20140904 Zenith radiance at: ' num2str(utc(iv)) ' UTC']);

load('C:\Users\sleblan2\Research\ARISE\model\sp_snow_sza65.mat');
hold on
for i=1:24
plot(zenlambda, reshape(sp(i,1,1,:,1),[1,1556]),'Color',[0.7 0.7 1]);
end;

plot(zenlambda, reshape(sp(3,1,1,:,1),[1,1556]),'.g');
plot(zenlambda, reshape(sp(4,1,1,:,1),[1,1556]),'.m');

legend('4STAR measurements','Modelled Liquid radiance over snow')

text(1200, 0.06, 'tau=2','Color','m');
text(400,0.02,'tau=1','Color','g');
plot(w*1000.,rad(iv,:)/1000.,'.r')
hold off;


subplot(1,2,2);

plot(w*1000.,rad(iv,:)/1000.,'.r')
xlabel('Wavelength [nm]');
xlim([350 1750]);
ylabel('Radiance [W/(m^2 nm sr)]')
title(['20140904 Zenith radiance at: ' num2str(utc(iv)) ' UTC']);

hold on
for i=1:24
plot(zenlambda, reshape(sp(i,5,1,:,2),[1,1556]),'Color',[0.7 0.7 1]);
end;

plot(zenlambda, reshape(sp(1,5,1,:,2),[1,1556]),'.g');
plot(zenlambda, reshape(sp(2,5,1,:,2),[1,1556]),'.m');

legend('4STAR measurements','Modelled ice radiance over snow')
hold off;
text(1200, 0.06, 'tau=0.5','Color','m');
text(400,0.02,'tau=0.2','Color','g');
%plot(w*1000.,rad(i,:)/1000.,'.r')
