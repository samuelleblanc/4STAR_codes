function starzen2easy(daystr);

fp = 'C:\Users\sleblanc\Research\NAAMES\starzen\';

s = load([fp daystr 'starzen.mat']);

d.radiance = s.rads./1000.0; 
d.unit = 'W.m^-2.sr^-1.nm^-1';
d.utc = t2utch(s.t_rad);
d.time = s.t_rad;
d.lat = s.Lat(s.iset);
d.lon = s.Lon(s.iset);
d.alt = s.Alt(s.iset);
d.wvl = s.w;

save([fp daystr 'starzen_radiances.mat'],'-struct', 'd', '-mat');

end