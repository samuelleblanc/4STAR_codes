function hscan = hyscan(SEL, SA_set)
% hscan = hyscan(SEL, SA_set)

% Called by hybrid_scan_LUT iteratively to provide hybrid sky scan patterns

% Connor, v1.0, 2018/09/25
version_set('1.0');

if ~isavar('SEL')
   SEL = 60;
end
if ~isavar('SA_set')
   SA_set = [-10, -7, -5, -3.5, 3, 3.5, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 25, 30, 35, ...
   40, 45, 50, 60, 70, 80, 90, 100, 120, 140, 160, 180];
end
SZA = 90-SEL;

hscan.SA = SA_set;
hscan.SZA = SZA;
hscan.SEL = SEL;
hscan.x = NaN(size(SA_set));
hscan.y = NaN(size(SA_set));
hscan.z = NaN(size(SA_set));
hscan.SA = NaN(size(SA_set));
hscan.El = NaN(size(SA_set));
hscan.dEl = NaN(size(SA_set));
hscan.dAz = NaN(size(SA_set));
hscan.ddEl = NaN(size(SA_set));
hscan.ddAz = NaN(size(SA_set));

%sun.xyz is vector locating sun in cartesian coords
% the negative sign for SAZ corrects Az(0=north) frame to a RH axis system
[sun_xyz.x, sun_xyz.y, sun_xyz.z] = sph2cart(0, SEL.*pi/180,1);
%axi is vector locating point in principle plane 90 degrees from sun
[axi.x, axi.y, axi.z] = sph2cart(180.*pi/180, (90-SEL).*pi/180,1);
SA_i = 0; 
mark_xyz = [sun_xyz.x,-sun_xyz.y,sun_xyz.z];
mark.EL = SEL; mark.ZA = 90-mark.EL;
rot = sign(SA_set(1)-SA_set(2));% rotational sense
mark.AZ = -rot*20;
mark.SA = 0;
   % While EL>15, do hybrid portion.
   while mark.EL > 15
      SA_i = SA_i +1;
      % Determine hybrid angles, CCW leg
      % Rotate vector at sun about orthogonal axis in PPL by desired SA_set
      mark_xyz = rotVecAroundArbAxis([sun_xyz.x, sun_xyz.y, sun_xyz.z], [axi.x, axi.y, axi.z], SA_set(SA_i));
      [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));
      % Convert to degrees.
      mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
      % Convert theta and phi to El, Za, Az
      mark.EL = mark.PHI_deg; 
      mark.ZA = 90-mark.EL;
      mark.AZ = -mark.TH_deg;
      % Compute SA to confirm.  This should agree with rotated angle SA_set
      mark.SA = scat_ang_degs(SZA, 0, mark.ZA, mark.AZ);
      % Store the result
      hscan.x(SA_i) = mark_xyz(1);
      hscan.y(SA_i) = mark_xyz(2);
      hscan.z(SA_i) = mark_xyz(3);
      hscan.SA(SA_i) = mark.SA;
      hscan.El(SA_i) = mark.EL;
%       hscan.dEl(SA_i) = SEL-mark.EL;
      hscan.dAz(SA_i) = mark.AZ;
   end
   %Now complete the rest of the desired scattering angles as an Almucantar
   endAz = rot*180;
   test_Az = mark.AZ:.25*rot:endAz;

   % Compute SA for Az up to 180 at this fixed ZA
   % then interpolate to find Az for the target Aeronet SA_set.
   SA_t = zeros(size(test_Az));
   for tAz = 1:length(test_Az)
      SA_t(tAz) = scat_ang_degs(SZA, 0, mark.ZA, test_Az(tAz));
   end
   SA_signed = real(SA_t); SA_signed(test_Az>0) = -1*SA_signed(test_Az>0);
   Az_set = interp1(SA_signed, test_Az, SA_set(SA_i+1:end),'nearest');
   Az_set(isnan(Az_set)) = []; Az_set = [Az_set, endAz]; Az_set = unique(Az_set,'stable');
%    mark.AZ-Az_set
   mark.AZ(mark.AZ==-rot*20) = 0;
   for aa = 1:length(Az_set)
      mark_xyz = rotVecAroundArbAxis([mark_xyz(1), mark_xyz(2), mark_xyz(3)], [0, 0, 1], (mark.AZ-Az_set(aa)));
      [mark.TH, mark.PHI, mark.z] = cart2sph(mark_xyz(1),mark_xyz(2),mark_xyz(3));
      % Convert to degrees.
      mark.TH_deg = (180./pi).*mark.TH; mark.PHI_deg = mark.PHI.*180./pi;
      % Convert theta and phi to El, Za, Az
      mark.EL = mark.PHI_deg; mark.ZA = 90-mark.EL;
      mark.AZ = 360-mark.TH_deg;
      % Compute SA to confirm.  This should agree with rotated angle SA_set
      mark.SA = scat_ang_degs(SZA, 0, mark.ZA, mark.AZ);
      hscan.x(SA_i+aa) = mark_xyz(1);
      hscan.y(SA_i+aa) = mark_xyz(2);
      hscan.z(SA_i+aa) = mark_xyz(3);
      hscan.SA(SA_i+aa) = scat_ang_degs(SZA, 0, mark.ZA, Az_set(aa));
      hscan.El(SA_i+aa) = mark.EL;
%       hscan.dEl(SA_i+aa) = mark.EL - SEL;
      hscan.dAz(SA_i+aa) = Az_set(aa);
   end
   hscan.dEl = hscan.El-SEL;
   hscan.ddEl(1) = hscan.dEl(1); hscan.ddEl(2:end) = diff(hscan.dEl,1,2);
   hscan.ddAz(1) = hscan.dAz(1); hscan.ddAz(2:end) = diff(hscan.dAz,1,2);


return

% function plots
%    figure_(86);
%    plot3(hscan.x, hscan.y, hscan.z,'ok-');
%    title(['Hybrid scan for SZA=',num2str(SZA)]);
%    xlabel('x'); ylabel('y'); zlabel('z')
%    xl = xlim; yl = ylim; zl = zlim;
% ll(1) = min([xl,yl,zl]); ll(2) = max([xl,yl,zl]);
% axis('square');
% xlim(ll); ylim(ll); zlim(ll);
% return