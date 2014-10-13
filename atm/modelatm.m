function model_atm=modelatm(dec_or_t,lat)

% Returns model atm for a given declination and latitude.
% Input: 
%     dec_or_t: declinatin or time in matlab expression
%     lat: latitude
% See also rayleighez.m and O2_VCYMS.m
% Yohei, 2013/06/04

if dec_or_t>datenum([1901 1 1]); % time given; convert it to dec (used to tell summer from winter)
    jd=dec_or_t+1721058.5;
    ecl_long=ecliptic(jd);
    dec_or_t=equator(jd,ecl_long); % used in Beat's sun.m
end;
latlims=[0 30 50 90]; % note Bucholtz latitudes are 15, 45 and 60 for tropical, midlatitude and subarctics, respectively. See his Table 4.
model_atm=repmat(6,size(lat)); % 6=1962 U.S. Stand Atm
model_atm(find(abs(lat)>=latlims(1) & abs(lat)<=latlims(2)))=1; % 1=Tropical
model_atm(find(abs(lat)>latlims(2) & abs(lat)<=latlims(3)))=2; % 2=Midlat Summer
model_atm(find(model_atm==2 & dec_or_t.*lat<0))=3; % 3=Midlat Winter
model_atm(find(abs(lat)>latlims(3) & abs(lat)<=latlims(4)))=4; % 4=Subarc Summer
model_atm(find(model_atm==4 & dec_or_t.*lat<0))=5; % 5=Subarc Winter
