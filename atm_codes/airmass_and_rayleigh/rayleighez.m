function [tau_r, tau_r_err]=rayleighez(lambda,press,dec_or_t,lat)

% Computes Rayleigh Scattering according to Bucholtz A., 1995: Appl.
% Optics., Vol. 34, No. 15 2765-2773. 
% lambda has to be in microns, pressure in hPa, dec_or_t either delination
% angle or time in the Matlab format, latitude in degrees (negative
% southern hemisphere). press, dec_or_t and lat must have the same number
% of rows, and just one column.  
% With idx_model_atm, use rayleigh.m instead.
% Yohei, 2012/05/18, after beat\rayleigh.m

% control input
[pp,qq]=size(press);
if qq~=1;
    error('press must be a vertical vector.');
elseif ~isequal(size(dec_or_t), size(press)) || ~isequal(size(dec_or_t), size(lat))
    error('press, t and lat must be in the same size.');
end;

% determine model atmosphere
if dec_or_t>datenum([1901 1 1]); % time given; convert it to dec (used to tell summer from winter)
    jd=dec_or_t+1721058.5;
    ecl_long=ecliptic(jd);
    dec_or_t=equator(jd,ecl_long); % used in Beat's sun.m
end;
latlims=[0 30 50 90]; % note Bucholtz latitudes are 15, 45 and 60 for tropical, midlatitude and subarctics, respectively. See his Table 4.
idx=repmat(6,pp,1); % 6=1962 U.S. Stand Atm
idx(find(abs(lat)>=latlims(1) & abs(lat)<=latlims(2)))=1; % 1=Tropical
idx(find(abs(lat)>latlims(2) & abs(lat)<=latlims(3)))=2; % 2=Midlat Summer
idx(find(idx==2 & dec_or_t.*lat<0))=3; % 3=Midlat Winter
idx(find(abs(lat)>latlims(3) & abs(lat)<=latlims(4)))=4; % 4=Subarc Summer
idx(find(idx==5 & dec_or_t.*lat<0))=5; % 5=Subarc Winter

% calculate Rayleigh scattering
tau_r=repmat(NaN,pp,length(lambda));
for idx_model_atm=1:6;
    ok=find(idx==idx_model_atm);
    if ~isempty(ok)
        tau_r(ok,:)=(press(ok)/1013.25)*rayleigh(lambda,idx_model_atm);
%         tau_r(ok,:)=rayleigh(lambda(:),press(ok),idx_model_atm)';
    end;
end;
% give uncertainties - inherited from the AATS code. From Schmid et al.
% (1996)?
tau_r_err=0.015;       % relative error that reflects the estimated accuracy of pressure measurements 

