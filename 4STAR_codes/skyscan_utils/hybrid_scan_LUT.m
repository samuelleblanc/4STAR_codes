function hybrid_scan_LUT% Produce a look-up table for every 1-degree of SZA with (dAz, dEl) pairs

% sun_xyz = sph2cart(TH,PHI,1) (Th = azimuth, PHI = elevation = 90-ZA
% Scraps for hybrid mode

% After I get this initial stage working, modify to include overlapping
% shallow angles and a definite dAz = 180 for both legs
% v 0.1

SAZ = 0;
SZA_ = [0:75];
SEL_ = 90-SZA_;
%vector in cartesian coords locating sun
% the negative sign for SAZ corrects to a RH axis system
% Az (north) is not.
[sun.x, sun.y, sun.z] = sph2cart(-SAZ.*pi/180, SEL_.*pi/180,1);
%vector locating point in principle plane 90 degrees from sun
[axi.x, axi.y, axi.z] = sph2cart((180-SAZ).*pi/180, (90-SEL_).*pi/180,1);

SA_set = [-10, -7, -5, -3.5, 3, 3.5, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 25, 30, 35, ...
   40, 45, 50, 60, 70, 80, 90, 100, 120, 140, 160, 180];
target.SA = SA_set;
target.SZA = SZA_;
target.SEL = SEL_;
target.CW.El = NaN(length(SZA_),length(SA_set));
target.CW.dEl = NaN(length(SZA_),length(SA_set));
target.CW.dAz = NaN(length(SZA_),length(SA_set));
target.CW.ddEl = NaN(length(SZA_),length(SA_set));
target.CW.ddAz = NaN(length(SZA_),length(SA_set));
target.CCW.El = NaN(length(SZA_),length(SA_set));
target.CCW.dEl = NaN(length(SZA_),length(SA_set));
target.CCW.dAz = NaN(length(SZA_),length(SA_set));
target.CCW.ddEl = NaN(length(SZA_),length(SA_set));
target.CCW.ddAz = NaN(length(SZA_),length(SA_set));

for za_i = 1:length(SZA_)
   mark.EL = 90-SZA_(za_i);   
   %Determine hybrid angles, CCW leg
   SA_i = 1;
   while mark.EL > 15
      mark_xyz = rotVecAroundArbAxis([sun.x(za_i), sun.y(za_i), sun.z(za_i)], [axi.x(za_i), axi.y(za_i), axi.z(za_i)], SA_set(SA_i));
      [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));
      mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
      mark.EL = mark.PHI_deg; mark.ZA = 90-mark.EL;
      mark.AZ = 360-mark.TH_deg;
      mark.SA = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, mark.AZ);
      target.CCW.El(za_i,SA_i) = mark.EL;
      target.CCW.dEl(za_i,SA_i) = mark.EL - target.SEL(za_i);
      target.CCW.dAz(za_i,SA_i) = mark.AZ;
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
      SA_t(tAz) = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, SAZ + test_Az(tAz));
   end
   [SA_t, ij] = unique(SA_t); test_Az = test_Az(ij);
   if length(unique(SA_t))>1
      Az_set = interp1(SA_t, test_Az, SA_set(SA_i+1:end),'nearest');
   else
      Az_set = test_Az;
   end
   target.CCW.El(za_i,(SA_i+1:end)) = mark.EL;
   target.CCW.dEl(za_i,(SA_i+1:end)) = mark.EL - target.SEL(za_i);
   target.CCW.dAz(za_i,(SA_i+1:end)) = Az_set;
   Az_set(isnan(Az_set)) = [];
   
 
   mark.EL = 90-SZA;
   SA_i = 1;
   while mark.EL > 15
      mark_xyz = rotVecAroundArbAxis([sun.x, sun.y, sun.z], [axi.x, axi.y, axi.z], -SA_set(SA_i));
      [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));
      mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
      mark.EL = mark.PHI_deg; mark.ZA = 90-mark.EL;
      mark.AZ = 360-mark.TH_deg;
      mark.SA = scat_ang_degs(SZA, SAZ, mark.ZA, mark.AZ);
      target.CW.El(za_i,SA_i) = mark.EL;
      target.CW.dEl(za_i,SA_i) = mark.EL - target.SEL(za_i);
      target.CW.dAz(za_i,SA_i) = -mark.AZ;
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
   target.CW.El(za_i,(SA_i+1:end)) = mark.El;
   target.CW.dEl(za_i,(SA_i+1:end)) = mark.El - target.SEL(za_i);
   target.CW.dAz(za_i,(SA_i+1:end)) = Az_set;
   Az_set(isnan(Az_set)) = [];
   for m = 1:length(Az_set)
      mark.SA = scat_ang_degs(SZA, SAZ, mark.ZA, SAZ +Az_set(m)); mark.SA
      % Complete remaining SA with elevation angle changes
   end
end

return