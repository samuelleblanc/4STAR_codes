% sun_xyz = sph2cart(TH,PHI,1) (Th = azimuth, PHI = elevation = 90-ZA
% Scraps for hybrid mode

[SZA, SAZ] = sunae(45, -120, now+8/24); 
SAZ = 0;
SZA = [0:75];
SEL = 90-SZA;
[sun.x, sun.y, sun.z] = sph2cart(-SAZ.*pi/180, SEL.*pi/180,1); 
[axi.x, axi.y, axi.z] = sph2cart((180-SAZ).*pi/180, (90-SEL).*pi/180,1); 

SA_set = [3, 3.5, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 25, 30, 35, ...
   40, 45, 50, 60, 70, 80, 90, 100, 120, 140, 160, 180];
mark.EL = 90-SZA;

%Determine hybrid angles, CCW leg
SA_i = 1;
while mark.EL > 15
   mark_xyz = rotVecAroundArbAxis([sun.x, sun.y, sun.z], [axi.x, axi.y, axi.z], SA_set(SA_i));
   [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));  
   mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
   mark.EL = mark.PHI_deg; mark.ZA = 90-mark.EL;
   mark.AZ = 360-mark.TH_deg;
   mark.SA = scat_ang_degs(SZA, SAZ, mark.ZA, mark.AZ);
   if mark.EL >15
      SA_i = SA_i +1;
   end      
end
% Compute SA for Az up to 180 at this fixed ZA
% then interpolate to find Az for the target Aeronet SA_set.
last_Az= ceil(mod(SAZ - mark.AZ,360)); 
test_Az = last_Az:1:180;
SA_t = zeros(size(test_Az));
for tAz = 1:length(test_Az)
   SA_t(tAz) = scat_ang_degs(SZA, SAZ, mark.ZA, SAZ + test_Az(tAz));
end
Az_set = interp1(SA_t, test_Az, SA_set(SA_i+1:end),'nearest');
Az_set(isnan(Az_set)) = [];
for m = 1:length(Az_set)
   mark.SA = scat_ang_degs(SZA, SAZ, mark.ZA, SAZ +Az_set(m)); mark.SA
   % Complete remaining SA with elevation angle changes
end

SA_set = -1.*SA_set;
mark.EL = 90-SZA;
SA_i = 1;
while mark.EL > 15
   mark_xyz = rotVecAroundArbAxis([sun.x, sun.y, sun.z], [axi.x, axi.y, axi.z], SA_set(SA_i));
   [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));  
   mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
   mark.EL = mark.PHI_deg; mark.ZA = 90-mark.EL;
   mark.AZ = 360-mark.TH_deg;
   mark.SA = scat_ang_degs(SZA, SAZ, mark.ZA, mark.AZ);
   if mark.EL >15
      SA_i = SA_i +1;
   end      
end

% Now repeat the interpolation piece above but for the 

% Compute SA for Az up to 180 at this fixed ZA
% then interpolate to find Az for the target Aeronet SA_set.
last_Az= SAZ - mark.AZ;
last_Az= floor(mod(SAZ - mark.AZ,360)-360); 
test_Az = last_Az:-1:-180;
SA_t = zeros(size(test_Az));
for tAz = 1:length(test_Az)
   SA_t(tAz) = scat_ang_degs(SZA, SAZ, mark.ZA, SAZ + test_Az(tAz));
end
Az_set = interp1(SA_t, test_Az, abs(SA_set(SA_i+1:end)),'nearest');
Az_set(isnan(Az_set)) = [];
for m = 1:length(Az_set)
   mark.SA = scat_ang_degs(SZA, SAZ, mark.ZA, SAZ +Az_set(m)); mark.SA
   % Complete remaining SA with elevation angle changes
end
