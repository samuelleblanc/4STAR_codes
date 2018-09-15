function hybrid_scan_LUT% Produce a look-up table for every 1-degree of SZA with (dAz, dEl) pairs

% sun_xyz = sph2cart(TH,PHI,1) (Th = azimuth, PHI = elevation = 90-ZA
% Scraps for hybrid mode

% After I get this initial stage working, modify to include overlapping
% shallow angles and a definite dAz = 180 for both legs
% v 0.2
% Possibly working but no output yet.

SAZ = 0;
SZA_ = (0.5:0.5:90);
SEL_ = 90-SZA_;
%sun.xyz is vector locating sun in cartesian coords
% the negative sign for SAZ corrects Az(0=north) frame to a RH axis system
[sun.x, sun.y, sun.z] = sph2cart(-SAZ.*pi/180, SEL_.*pi/180,1);
%axi is vector locating point in principle plane 90 degrees from sun
[axi.x, axi.y, axi.z] = sph2cart((180-SAZ).*pi/180, (90-SEL_).*pi/180,1);

SA_set = [-10, -7, -5, -3.5, 3, 3.5, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 25, 30, 35, ...
   40, 45, 50, 60, 70, 80, 90, 100, 120, 140, 160, 180];
target.SA = SA_set;
target.SZA = SZA_;
target.SEL = SEL_;
target.CW.SA = NaN(length(SZA_),length(SA_set));
target.CW.El = NaN(length(SZA_),length(SA_set));
target.CW.dEl = NaN(length(SZA_),length(SA_set));
target.CW.dAz = NaN(length(SZA_),length(SA_set));
target.CW.ddEl = NaN(length(SZA_),length(SA_set));
target.CW.ddAz = NaN(length(SZA_),length(SA_set));
target.CCW.SA = NaN(length(SZA_),length(SA_set));
target.CCW.El = NaN(length(SZA_),length(SA_set));
target.CCW.dEl = NaN(length(SZA_),length(SA_set));
target.CCW.dAz = NaN(length(SZA_),length(SA_set));
target.CCW.ddEl = NaN(length(SZA_),length(SA_set));
target.CCW.ddAz = NaN(length(SZA_),length(SA_set));

for za_i = 1:length(SZA_)
   mark.EL = 90-SZA_(za_i);   
   %Determine hybrid angles, CCW leg
   SA_i = 1;
   % Rotate until below El angle of 15 degrees
   while mark.EL > 15
      % Rotate vector at sun about orthogonal axis in PPL by desired SA_set
      mark_xyz = rotVecAroundArbAxis([sun.x(za_i), sun.y(za_i), sun.z(za_i)], [axi.x(za_i), axi.y(za_i), axi.z(za_i)], SA_set(SA_i));
      [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));
      % Convert to degrees.
      mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
      % Convert theta and phi to El, Za, Az
      mark.EL = mark.PHI_deg; mark.ZA = 90-mark.EL;
      mark.AZ = 360-mark.TH_deg;
      % Compute SA to confirm.  This should agree with rotated angle SA_set
      mark.SA = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, mark.AZ);
      % Store the result
      target.CCW.SA(za_i,SA_i) = mark.SA;
      target.CCW.El(za_i,SA_i) = mark.EL;
      target.CCW.dEl(za_i,SA_i) = SEL_(za_i)-mark.EL;
      target.CCW.dAz(za_i,SA_i) = mark.AZ;
      if mark.EL >15
         SA_i = SA_i +1;
      end
   end
   %Now complete the rest of the desired scattering angles as an Almucantar

   last_Az= ceil(mod(mark.AZ-SAZ,180));
   test_Az = last_Az:0.5:179.5;
   % Compute SA for Az up to 180 at this fixed ZA
   % then interpolate to find Az for the target Aeronet SA_set.
   SA_t = zeros(size(test_Az));
   for tAz = 1:length(test_Az)
      SA_t(tAz) = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, SAZ + test_Az(tAz));
   end
   Az_set = interp1(SA_t, test_Az, SA_set(SA_i+1:end),'nearest');
   Az_set(isnan(Az_set)) = [];
   for aa = 1:length(Az_set)
      target.CCW.SA(za_i,SA_i+aa) = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, Az_set(aa));
      target.CCW.El(za_i,SA_i+aa) = mark.EL;
      target.CCW.dEl(za_i,SA_i+aa) = mark.EL - SEL_(za_i);
      target.CCW.dAz(za_i,SA_i+aa) = Az_set(aa);
   end
   target.CCW.SA(SA_i+aa+1) = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, 180);
   target.CCW.El(za_i,SA_i+aa+1) = mark.EL;
   target.CCW.dEl(za_i,SA_i+aa+1) = mark.EL - SEL_(za_i);
   target.CCW.dAz(za_i,SA_i+aa+1) = 180;
   
  
   %Determine hybrid angles, CCW leg
   mark.EL = 90-SZA_(za_i);
   SA_i = 1;
   % Rotate until below El angle of 15 degrees
   while mark.EL > 15
      % Rotate vector at sun about orthogonal axis in PPL by desired SA_set
      mark_xyz = rotVecAroundArbAxis([sun.x(za_i), sun.y(za_i), sun.z(za_i)], [axi.x(za_i), axi.y(za_i), axi.z(za_i)], -SA_set(SA_i));
      [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));
      % Convert to degrees.
      mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
      % Convert theta and phi to El, Za, Az
      mark.EL = mark.PHI_deg; mark.ZA = 90-mark.EL;
      mark.AZ = 360-mark.TH_deg;
      % Compute SA to confirm.  This should agree with rotated angle SA_set
      mark.SA = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, mark.AZ);
      % Store the result
      target.CW.SA(za_i,SA_i) = mark.SA;
      target.CW.El(za_i,SA_i) = mark.EL;
      target.CW.dEl(za_i,SA_i) = SEL_(za_i)-mark.EL;
      target.CW.dAz(za_i,SA_i) = mark.AZ;
      if mark.EL >15
         SA_i = SA_i +1;
      end
   end
   %Now complete the rest of the desired scattering angles as an Almucantar

   last_Az= ceil(mod(mark.AZ-SAZ,180));
   test_Az = last_Az:0.5:179.5;
   % Compute SA for Az up to 180 at this fixed ZA
   % then interpolate to find Az for the target Aeronet SA_set.
   SA_t = zeros(size(test_Az));
   for tAz = 1:length(test_Az)
      SA_t(tAz) = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, SAZ + test_Az(tAz));
   end
   Az_set = interp1(SA_t, test_Az, SA_set(SA_i+1:end),'nearest');
   Az_set(isnan(Az_set)) = [];
   for aa = 1:length(Az_set)
      target.CW.SA(za_i,SA_i+aa) = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, Az_set(aa));
      target.CW.El(za_i,SA_i+aa) = mark.EL;
      target.CW.dEl(za_i,SA_i+aa) = mark.EL - SEL_(za_i);
      target.CW.dAz(za_i,SA_i+aa) = Az_set(aa);
   end
   target.CW.SA(SA_i+aa+1) = scat_ang_degs(SZA_(za_i), SAZ, mark.ZA, 180);
   target.CW.El(za_i,SA_i+aa+1) = mark.EL;
   target.CW.dEl(za_i,SA_i+aa+1) = mark.EL - SEL_(za_i);
   target.CW.dAz(za_i,SA_i+aa+1) = 180;

end
target.CCW.ddEl(:,1) = target.CCW.dEl(:,1); target.CCW.ddEl(:,2:end) = diff(target.CCW.dEl,1,2);
target.CCW.ddAz(:,1) = target.CCW.dAz(:,1); target.CCW.ddAz(:,2:end) = diff(target.CCW.dAz,1,2);

target.CW.ddEl(:,1) = target.CW.dEl(:,1); target.CW.ddEl(:,2:end) = diff(target.CW.dEl,1,2);
target.CW.ddAz(:,1) = target.CW.dAz(:,1); target.CW.ddAz(:,2:end) = diff(target.CW.dAz,1,2);

return