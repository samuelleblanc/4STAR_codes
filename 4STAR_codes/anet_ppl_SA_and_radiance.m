function ppl = anet_ppl_SA_and_radiance(ppl)
% alm = anet_ppl_SA_and_radiance(ppl)
% Pack data from aeronet ppl v3 file into structure with radiance dimensioned
% against time and azimuth angle, and compute scattering angles.
if ~isavar('infile')||~isafile(infile)
    infile = getfullname('*.*','aeronet_ppl','Select AERONET AIP PPL file.');
end
ppl = read_cimel_aip_v3(infile);

fld = fieldnames(ppl);
fld(1:10) = [];
for f = 1:length(fld)
    ppl.radiance(:,f) = ppl.(char(fld(f)));
    ppl = rmfield(ppl,fld{f});
end
flds = strrep(fld,'pos',''); flds = strrep(flds,'neg_','-'); flds = strrep(flds,'d','.');
for n = length(flds):-1:1
dZa(n) = sscanf(flds{n},'%f');
end
ppl.dZa = dZa;
ppl.SA = scat_ang_degs(0.*ones(size(dZa)), 0.*ones(size(dZa)), abs(dZa), 0.*ones(size(dZa)))';
for t = length(ppl.time):-1:1
ppl.zen_rad(t) = interp1(ppl.dZa, ppl.radiance(t,:), ppl.Solar_Zenith_Angle_Degrees_(t),'linear');
end
return