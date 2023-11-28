function alm = anet_alm_SA_and_radiance(infile)
% alm = anet_alm_SA_and_radiance(infile)
% Pack data from aeronet alm file into structure with radiance dimensioned
% against time and azimuth angle, and compute scattering angles.
if ~isavar('infile')||~isafile(infile)
    infile = getfullname(['*.alm','*.csv'],'aeronet_sky','Select AERONET AIP ALM file.');
end
alm = rd_anetaip_v3(infile);
fld = fieldnames(alm);
fld(1:13) = [];
for f = 1:length(fld)
    alm.radiance(:,f) = alm.(char(fld(f)));
    alm = rmfield(alm,fld{f});
end
flds = strrep(fld,'pos',''); flds = strrep(flds,'neg_','-'); flds = strrep(flds,'pt','.');
for n = length(flds):-1:1
dAz(n) = sscanf(flds{n},'%f');
end
alm.dAz = dAz;
for n = length(dAz):-1:1
alm.SA(:,n) = scat_ang_degs(alm.Solar_Zenith_Angle_Degrees_, 0.*ones([length(alm.time),1]), alm.Solar_Zenith_Angle_Degrees_, abs(ones(size(alm.time))*dAz(n)));
end

return