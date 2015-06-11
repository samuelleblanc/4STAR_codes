function [O2_vercol,O4_vercol]=O2_VCY(alt)

%computes O2 vertical column according to height 
% O2_vercol is given in molec/cm2
% enter alt (the base altitude of calculation) in meters
% for example: Ames rooftop = 10 meters

%read input atmosphere
filename='Tropical.asc';
fid=fopen(fullfile(starpaths,filename),'r');
fgetl(fid);
data=fscanf(fid,'%f',[4 inf]);
Altitude=data(1,:)*1000; % convert km to meters
Dens=data(4,:);          % density in molecule/m^3
clear data
fclose(fid);
cumd=fliplr(cumtrapz(fliplr(Altitude),fliplr(-1*Dens)));
O2_VC=interp1(Altitude,cumd,alt);
O2_VC(find(alt<min(Altitude)))=cumd(1);
O2_VC=0.21*O2_VC;
O2_vercol=O2_VC/(100)^2;
cumd4=fliplr(cumtrapz(fliplr(Altitude),fliplr(-1*Dens.^2)));
O4_VC=interp1(Altitude,cumd4,alt);
O4_VC(find(alt<min(Altitude)))=cumd4(1);
O4_VC=0.21^2*O4_VC;
O4_vercol=O4_VC/(100)^5;
