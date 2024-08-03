function [alm, cimel] = rd_anetalm_v3(filename);
% cimel = rd_anetalm_v3(filename);
% Includes scaling of sky_rad by factor of 10 to yield  W/(m^2 um sr)
if ~exist('filename', 'var')
    filename = getfullname('*.*','cimel');
elseif ~exist(filename,'file')
    filename = getfullname(filename,'cimel');
end
[pname, fname,ext] = fileparts(filename);
fname = [fname,ext];
cimel = rd_anetaip_v3(filename);

flds = fieldnames(cimel); 
flds = flds(foundstr(flds, 'pos')|foundstr(flds,'neg'));
alm = cimel; 
alm = rmfield(alm,flds);

flds_d = strrep(flds,'d','.');
degs = [];
for fld = 1:length(flds_d)
   degs = [degs,sscanf(flds_d{fld},'pos%f')];
   degs = [degs,-1.*sscanf(flds_d{fld},'neg_%f')];
end
degs = unique(degs);
alm.Az_deg = degs;
alm.SA = NaN([length(alm.time), length(alm.Az_deg)]);

alm.sky_rad = NaN([length(alm.time), length(alm.Az_deg)]);
for fld = 1:length(flds_d)
   deg = [sscanf(flds_d{fld},'pos%f'), -1.*sscanf(flds_d{fld},'neg_%f')];
   deg_i = find(degs==deg);
   alm.sky_rad(:,deg_i) = cimel.(flds{fld});
end
alm.sky_rad(alm.sky_rad<-100) = NaN;
% Original units µW/cm^2/sr/nm = mW/cm^2/sr/um
% 1e-3 * 1e4
% Desire radiance units W/(m^2 um sr)

alm.sky_rad = alm.sky_rad.*10;
alm.sky_rad_units = 'W/(m^2 um sr)';
for az = length(alm.Az_deg):-1:1
   alm.SA(:,az) = scat_ang_degs(alm.Solar_Zenith_Angle_Degrees_, 0.*alm.time, ...
      alm.Solar_Zenith_Angle_Degrees_, alm.Az_deg(az).*ones(size(alm.time)));
end
