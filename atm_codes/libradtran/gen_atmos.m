%% PURPOSE:
%   Generate the atmosphere profile from a sounding, a standard atmospheric
%   profile and the temperatures, pressures, and relative humidity measured
%   onboard the NASA c130
%
% CALLING SEQUENCE:
%   filen = gen_atmos
%
% INPUT:
%   none at command line
% 
% OUTPUT:
%  - plots of profiles of temperature, pressure, and relative humidity
%  - file of atmosheric profile
%
% DEPENDENCIES:
%  - startup_plotting.m
%  - save_fig.m
%  - t2utch.m
%  - magnus.m ; for ideal gas law 
%  - version_set.m
%
% NEEDED FILES:
%  - sounding file
%  - standard atmosphere file
%  - 4STAR star.mat file for that day
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, C130, Lat: 67.45N, Lon: 143.68W, Sep-21, 2014
% Modified (v1.0): By Samuel LeBlanc, NASA Ames, 2015-01-27
%          - changed the startup to startup_plotting
%          - added version control using version_set
% -------------------------------------------------------------------------

%% Start of function
function [filen]=gen_atmos
startup_plotting;
version_set('1.0');

%% load the different files
%4STAR
datestr='20140919';
dir='C:\Users\sleblan2\Research\ARISE\c130\20140919_Flight13\';
fn=[dir datestr 'star.mat'];
s=load(fn);
utc_range=[19.3,22.9];

% combine the 4STAR alt, temp, pressure, rh data
star=combine_star_ZTPRH(s,utc_range);
star.RH=star.RH+100.0;
star.h2o=magnus(star.RH,star.Tst+273.15);%rh2nd(star.RH,star.Tst+273.15,star.Pst);

%standard
std=importdata([dir 'afglss.dat']);
std.z=std.data(:,1).*1000.;
std.p=std.data(:,2);
std.t=std.data(:,3)-273.15;
std.h2o=std.data(:,7);
%std.RH=nd2rh(std.h2o,std.t+273.15,std.p);%convert_humidity(std.p,std.t+273.15,std.h2o./1000.,'mixing ratio','relative humidity');
std.air=std.data(:,4);
std.o3=std.data(:,5);
std.o2=std.data(:,6);
std.co2=std.data(:,8);
std.no2=std.data(:,9);

%sounding
snd=importdata([dir 'sounding_20140919.txt']);
snd.z=snd.data(:,2);
snd.p=snd.data(:,1);
snd.t=snd.data(:,3);
snd.h2o=snd.data(:,6);
snd.RH=snd.data(:,5);

%% prepare for plotting
figure(1);

% Pressure
subplot(2,2,1);
plot(star.Pst,star.Z,'b.',snd.p,snd.z,'r.',std.p,std.z,'go');
xlabel('Pressure [mb]');
ylabel('Altitude [m]');
title('Pressure');
legend('C130','Sounding','Standard');

%Temperature
subplot(2,2,2);
plot(star.Tst,star.Z,'b.',snd.t,snd.z,'r.',std.t,std.z,'go');
xlabel('Temperature [°C]');
ylabel('Altitude [m]');
title('Temperature');
legend('C130','Sounding','Standard');

%Relative Humidity
subplot(2,2,3);
plot(star.RH,star.Z,'b.',snd.RH,snd.z,'r.');%,std.RH,std.z,'go');
xlabel('Relative Humidity [%]');
ylabel('Altitude [m]');
title('Relative Humidity');
legend('C130','Sounding','Standard');

%water vapor mixture
subplot(2,2,4);
plot(star.h2o,star.Z,'b.',snd.h2o,snd.z,'r.',std.h2o,std.z,'go');
xlabel('Water vapor number density [#/cm^-3]');
ylabel('Altitude [m]');
title('Water vapor');
legend('C130','Sounding','Standard');

save_fig(1,[dir,'atm_profiles'],true);


%% Select the correct values, first from c130, then from sounding, then from standard
z1=1800:-200:1000;
z2=900:-100:0;
Z=[std.z(1:end-2);z1';z2'];
% interp star
[star.zz,star.i]=sort(star.Z);
[star.zz,star.ia]=unique(star.zz);
star.i=star.i(star.ia);

star.Tz=interp1(star.zz,star.Tst(star.i),Z);
star.Pz=interp1(star.zz,star.Pst(star.i),Z);
star.Hz=interp1(star.zz,star.h2o(star.i),Z);
% interp snd
snd.Tz=interp1(snd.z,snd.t,Z);
snd.Pz=interp1(snd.z,snd.p,Z);
snd.Hz=interp1(snd.z,snd.h2o,Z);
% interp std
std.Tz=interp1(std.z,std.t,Z);
std.Pz=interp1(std.z,std.p,Z);
std.Hz=interp1(std.z,std.h2o,Z);

% do the temperature first
atm.T=star.Tz; 
it1=find(isnan(atm.T));
atm.T(it1)=snd.Tz(it1);
it2=find(isnan(atm.T));
atm.T(it2)=std.Tz(it2);
atm.T=atm.T+273.15;

% do the Pressure
atm.P=star.Pz;
ip1=find(isnan(atm.P));
atm.P(ip1)=snd.Pz(ip1);
ip2=find(isnan(atm.P));
atm.P(ip2)=std.Pz(ip2);

% do the water vapor
atm.H=star.Hz;
ih1=find(isnan(atm.H));
atm.H(ih1)=snd.Hz(ih1);
ih2=find(isnan(atm.H));
atm.H(ih2)=std.Hz(ih2);

atm.Z=Z./1000.0;
%make the rest
%atm.ratio=atm.P./std.Pz;
atm.air=gas_law(atm.P,atm.T); %interp1(std.z,std.air,Z).*atm.ratio;
atm.air_int=interp1(std.z,std.air,Z);
atm.ratio=atm.air./atm.air_int;
atm.o3=interp1(std.z,std.o3,Z).*atm.ratio;
atm.o2=interp1(std.z,std.o2,Z).*atm.ratio;
atm.co2=interp1(std.z,std.co2,Z).*atm.ratio;
atm.no2=interp1(std.z,std.no2,Z).*atm.ratio;

figure; plot(atm.P,Z); title('Pressure');
figure; plot(atm.T,Z); title('Temperature');
figure; plot(atm.H,Z); title('Water vapor');
figure; plot(atm.air,Z); title('air density');
figure; plot(atm.o3,Z); title('Ozone');
figure; plot(atm.o2,Z); title('Oxygen');
figure; plot(atm.co2,Z); title('Carbon Dioxide');
figure; plot(atm.no2,Z); title('Nitrogen Dioxide');

filen=[dir 'atmos_' datestr '.dat'];
disp(['Writing to file: ' filen]);
head=[{'#    new atmosphere file created from atmosphere based on profiles of c130 on:' datestr},...
      {'# z(km) p(mb)   T(K)    air(cm^-3)  o3(cm^-3)   o2(cm^-3)   h2o(cm^-3)  co2(cm^-3)  no2(cm^-3)'}];
%dlmwrite(filen,head,'/t');
dlmwrite(filen,[atm.Z,atm.P,atm.T,atm.air,atm.o3,atm.o2,atm.H,atm.co2,atm.no2],'\t');

stophere
return;


%% function to combine Z T P & RH of 4STAR modes 
% the altitude(Z), temperature(T), pressure(P), relative humidity(RH), from the different modes 
% of 4star.
function so=combine_star_ZTPRH(s,utc_range);

uu=fieldnames(s)
so.Tst=[0.];
so.Pst=[0.];
so.Z=[0.];
so.RH=[0.];
so.t=[0.];
for u=1:length(uu);
nn=findstr(uu{u},'vis');
    if nn; 
        kk=size(s.(uu{u}));
        if kk(2)==1;
          tt=s.(uu{u}).Tst;  
          so.Tst=[so.Tst,tt'];
          pp=s.(uu{u}).Pst;  
          so.Pst=[so.Pst,pp'];
          rr=s.(uu{u}).RH;   
          so.RH=[so.RH,rr'];
          zz=s.(uu{u}).Alt;  
          so.Z=[so.Z,zz'];
          ti=s.(uu{u}).t;    
          so.t=[so.t,ti'];
        else;
          for i=1:kk(2);
            tt=s.(uu{u})(i).Tst;  
            so.Tst=[so.Tst,tt'];
            pp=s.(uu{u})(i).Pst;  
            so.Pst=[so.Pst,pp'];
            rr=s.(uu{u})(i).RH;   
            so.RH=[so.RH,rr'];
            zz=s.(uu{u})(i).Alt;  
            so.Z=[so.Z,zz'];
            ti=s.(uu{u})(i).t;    
            so.t=[so.t,ti'];
          end;
        end;
    end;
end;
[so.t,is]=sort(so.t(2:end));
so.utc=t2utch(so.t);
if nargin >= 2; 
    it=find(so.utc >= utc_range(1) & so.utc <=utc_range(2));
    is=is(it);
    so.utc=so.utc(it);
    so.t=so.t(it);
end;
so.Tst=so.Tst(is);
so.Pst=so.Pst(is);
so.Z=so.Z(is);
so.RH=so.RH(is);
return;


%% function to calculate the number density from pressure and temperature
function nd=gas_law(p,t);
% p in mb
% T in Kelvin
R = 8.314;           % Joule/mol/Kelvin
Na= 6.02297.*10^23.; % molecules/mol

nd=p./t./R.*Na./10000.0;
return;

return;