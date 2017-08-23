function star = starsky_scan(star)
% star = starsky_scan(star); This routine is called from "starsky"
% Generate sky scans from starsky struct.  
%  In the case of ALM scans the CW and CCW branches of ALM are assessed.
% Offsets are determined for the pos and neg portions of the CW branch, and
% for the CW neg relative to the CCW pos (main portions), and adjusted to
% whichever is least. If offsets are too high, or too few valid points were
% available due to saturation then the sky is deemed "suspect".
%
[pname,fstem,ext] = fileparts(strrep(star.filename{1},'\',filesep));
pname = [pname, filesep];
fstem = strrep(fstem, '_VIS','');
star.time = star.t;
vis_pix = find(star.aeronetcols);
% star.vis_pix = vis_pix;
% sat_rad = star.skyrad;
% sat_rad(star.sat_ij) = NaN;
recs = (1:length(star.time))';
% Now, check agreement between any sun meausurements and Az_gnd and El_gnd
% Apply offsets, then compute initial SA.

suns_ii = find(star.Str==1 & star.Zn==0);
Quad_devs = sqrt((star.QdVlr(suns_ii)./star.QdVtot(suns_ii)).^2 + (star.QdVtb(suns_ii)./star.QdVtot(suns_ii)).^2);
[Quad_dev, min_i] = min(Quad_devs);
if Quad_dev>0.02
   warning(['Quad deviation during sun was ',sprintf('%2.3f',Quad_dev)])
end
star.tau_aero_skyscan = star.tau_aero(suns_ii(min_i),star.aeronetcols);

Az_offset = star.sunaz(suns_ii(min_i))-star.Az_gnd(suns_ii(min_i));
star.Az_gnd = star.Az_gnd+Az_offset;

El_offset = star.sunel(suns_ii(min_i))-star.El_gnd(suns_ii(min_i));
star.El_gnd = star.El_gnd+El_offset;



% Compute preliminary SA to determine if PPL or ALM
% Then within each scan type, assess symmetry and apply final offsets
% and compute final SA.
SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_gnd), star.Az_gnd);
rec = [1:length(star.t)];


figure(100); sx(1) = subplot(3,1,1);
plot(rec, star.Headng-star.Headng(1),'x',rec, star.pitch,'o',...
   rec, star.roll,'x', rec, star.Alt - star.Alt(1),'s');legend('Heading','pitch','roll','alt')
sx(2) = subplot(3,1,2);
plot(rec, SA, 'o', rec, mod(star.Az_gnd-star.Az_gnd(1)+90,180)-90, 'x',rec, star.El_gnd-star.El_gnd(1),'*');
legend('SA','Az','El')
sx(3) = subplot(3,1,3);
plot(rec, star.skyrad(:,star.aeronetcols),'x-');legend('sky rad');
linkaxes(sx, 'x');

heading = star.Headng; heading(heading<180) = heading(heading<180)+360;
d_head = max(heading)-min(heading); d_roll = max(star.roll)-min(star.roll);
d_pitch = max(star.pitch)-min(star.pitch); 
d_Alt = max(star.Alt) - min(star.Alt);
straight_level = d_head<5 & d_roll<2 & d_pitch < 1 & d_Alt <100;
if ~straight_level
   warning('Flight not straight and level for this sky scan!')
end

star.isPPL = std(star.El_deg)>std(mod(star.Az_deg+180,360));
%%

% star.sat_time = max(star.raw,[],2)==65535; % we already have star.sat_time
% star.sat_pixel = max(star.raw,[],1)==65535; % we have star.sat_ij instead.

if sum(star.sat_time)>0
   if any(star.sat_ij(1:1044))
      filename = star.filename{1};
      Tint = star.visTint(star.sat_time);
   elseif any(star.sat_ij(1045:end))
      filename = star.filename{2};
      Tint = star.nirTint(star.sat_time);
   end
   [~,fname,ext] = fileparts(filename);
   
   disp(fname)
   disp(sprintf('Altitude: %4.0f ',mean(star.Alt(star.sat_time))));
   disp(sprintf('Number of saturated zones: %d',length(unique(star.Zn(star.sat_time)))));
   disp(sprintf('Saturated angles: %d',sum(star.sat_time)));
   disp(sprintf('Record, Zone, tint, dAz, dEl'));
   disp(sprintf('%d,    %d,   %d,   %2.2f,  %2.2f \n', [recs(star.sat_time),star.Zn(star.sat_time),...
      Tint, ...
      star.Az_gnd(star.sat_time)+star.Headng(star.sat_time)-star.sunaz(star.sat_time),...
      star.El_gnd(star.sat_time)-star.sunel(star.sat_time)]'))
end
modes = unique(star.Md);
zones = unique(star.Zn);
%%
figure;
z= 0;
%%
z = z+1;
tints_vis = unique(star.visTint(star.Zn==zones(z)));
tints_nir = unique(star.nirTint(star.Zn==zones(z)));

plot([star.w], [star.skyrad(star.Zn==zones(z),:)],'.-');
title({fstem; [' Zone = ',num2str(zones(z)), sprintf(',  vis tints=%3.0d, ',tints_vis), ...
   sprintf('  nir tints=%3.0d ',tints_nir)]},'interp','none')
if z > length(zones)
   z = 0;
end

%%
% figure(9);
% s(1) = subplot(4,1,1); plot(serial2Hh(star.time(star.Str==1)), [star.El_ac(star.Str==1), ac_el(star.Str==1)'],'.'); legend('star','AC');
% title('Elevation on aircraft')
%  s(2) = subplot(4,1,2); plot(serial2Hh(star.time(star.Str==1)), mod(5*360+[star.Az_ac(star.Str==1), ac_az(star.Str==1)'],360),'.'); legend('star','AC')
%  title('Azimuth on aircraft')
%  s(3) = subplot(4,1,3); plot(serial2Hh(star.time(star.Str==1)), [star.QdVlr(star.Str==1), star.QdVtb(star.Str==1)], '.'); legend('V LR','V_TB');
%  title('Quads');
%  s(4) = subplot(4,1,4); plot(serial2Hh(star.time(star.Str==1)), ...
%      [star.Headng(star.Str==1)-mean(star.Headng(star.Str==1)), ...
%      star.pitch(star.Str==1)-mean(star.pitch(star.Str==1)),...
%      star.roll(star.Str==1)-mean(star.roll(star.Str==1))], '.'); legend('dhead','dpitch','droll');
%  title('deviation from straight and level');
%  linkaxes(s,'x');
%
%  star.aeronetcols = [332, 624,880,1040];

% vis_pix = find((1000*star.w(star.aeronetcols))<1000);
% % vis_pix = vis_pix([1 3 5 7]);
% vis_pix(star.aeronetcols(vis_pix)>1044) = [];
% vis_pix = vis_pix(1:2:end);

%%
% Use zone==0 and Str==1 to define the actual sun position and the
% angular offsets.
% star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_gnd), star.Az_gnd);


% recs = (1:length(star.time));

% s(1) = subplot(2,1,1);
% plot(recs(star.Str==0),star.Zn(star.Str==0),'b.',recs(star.Str==1),star.Zn(star.Str==1),'bo',...
%     recs(star.Str==2),star.Zn(star.Str==2),'gx',...
%     recs(star.Str==0&star.sat_time),star.Zn(star.Str==0&star.sat_time),'r.',...
%     recs(star.Str==1&star.sat_time),star.Zn(star.Str==1&star.sat_time),'ro',...
%     recs(star.Str==2&star.sat_time),star.Zn(star.Str==2&star.sat_time),'rx');
% title(fstem,'interp','none');
% ylabel('zone');
% legend('closed','sun','sky','location','northwest')
% s(2) = subplot(2,1,2);
% plot(recs(star.Str==0),star.visTint(star.Str==0),'r.',recs(star.Str==1),star.visTint(star.Str==1),'bo',...
%     recs(star.Str==2),star.visTint(star.Str==2),'gx')
% title('Tints');
% plot(recs(star.Str==0),star.QdVtb(star.Str==0),'r.',recs(star.Str==1),star.QdVtb(star.Str==1),'bo',...
%     recs(star.Str==2),star.QdVtb(star.Str==2),'gx')
% title('QdVtb');
%
% % plot(recs(star.Str==0),star.QdVlr(star.Str==0),'r.',recs(star.Str==1),star.QdV(star.Str==1),'bo',...
% %     recs(star.Str==2),star.QdVlr(star.Str==2),'gx')
% % title('QdVlr');
%
% s(3) = subplot(3,1,3);&star.sat_time

% plot(recs(star.Str==0&star.Headng~=0),star.SA(star.Str==0&star.Headng~=0),'b.',...
%     recs(star.Str==1&star.Headng~=0),star.SA(star.Str==1&star.Headng~=0),'bo',...
%     recs(star.Str==2&star.Headng~=0),star.SA(star.Str==2&star.Headng~=0),'gx',....
%     recs(star.Str==0&star.sat_time&star.Headng~=0),star.SA(star.Str==0&star.sat_time&star.Headng~=0),'r.',...
%     recs(star.Str==1&star.sat_time&star.Headng~=0),star.SA(star.Str==1&star.sat_time&star.Headng~=0),'ro',...
%     recs(star.Str==2&star.sat_time&star.Headng~=0),star.SA(star.Str==2&star.sat_time&star.Headng~=0),'rx')
% ylabel('scattering angle [deg]')
% linkaxes(s,'x')

% figout = savefig(gcf,[figdir, fstem,'.zones.png'],true);
%%


% Nominal, before correcting for symmetry
% star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_gnd), star.Az_gnd);
% recs = (1:length(star.time));
% figure;
% ss(1) = subplot(2,1,1);
% plot(recs,star.skyrad(:,star.aeronetcols(vis_pix(end))), '-b.');
% title(fstem,'interp','none');
% ylabel('rate');
% ss(2) = subplot(2,1,2);
% if ~star.isPPL
%     plot(recs(star.Str==0&star.Headng~=0),acosd(cosd(star.Az_gnd(star.Str==0&star.Headng~=0)-star.sunaz((star.Str==0&star.Headng~=0)))),'b.',...
%         recs(star.Str==1&star.Headng~=0),acosd(cosd(star.Az_gnd(star.Str==1&star.Headng~=0)-star.sunaz(star.Str==1&star.Headng~=0))),'bo',...
%         recs(star.Str==2&star.Headng~=0),acosd(cosd(star.Az_gnd(star.Str==2&star.Headng~=0)-star.sunaz(star.Str==2&star.Headng~=0))),'gx',....
%         recs(star.Str==0&star.sat_time&star.Headng~=0),acosd(cosd(star.Az_gnd(star.Str==0&star.sat_time&star.Headng~=0)-star.sunaz(star.Str==0&star.sat_time&star.Headng~=0))),'r.',...
%         recs(star.Str==1&star.sat_time&star.Headng~=0),acosd(cosd(star.Az_gnd(star.Str==1&star.sat_time&star.Headng~=0)-star.sunaz(star.Str==1&star.sat_time&star.Headng~=0))),'ro',...
%         recs(star.Str==2&star.sat_time&star.Headng~=0),acosd(cosd(star.Az_gnd(star.Str==2&star.sat_time&star.Headng~=0)-star.sunaz(star.Str==2&star.sat_time&star.Headng~=0))),'rx')
%     ylabel('Az - Sunaz [deg]')
% else
%     plot(recs(star.Str==0),star.El_gnd(star.Str==0)-star.sunaz((star.Str==0)),'b.',...
%         recs(star.Str==1),star.El_gnd(star.Str==1)-star.sunel(star.Str==1),'bo',...
%         recs(star.Str==2),star.El_gnd(star.Str==2)-star.sunel(star.Str==2),'gx',....
%         recs(star.Str==0&star.sat_time),star.El_gnd(star.Str==0&star.sat_time)-star.sunel(star.Str==0&star.sat_time),'r.',...
%         recs(star.Str==1&star.sat_time),star.El_gnd(star.Str==1&star.sat_time)-star.sunel(star.Str==1&star.sat_time),'ro',...
%         recs(star.Str==2&star.sat_time),star.El_gnd(star.Str==2&star.sat_time)-star.sunel(star.Str==2&star.sat_time),'rx')
%     ylabel('El - Sunel [deg]')
%
% end
% legend('closed','sun','sky','location','south')
% linkaxes([s,ss],'x')

% figout = savefig(gcf,[figdir, fstem,'.rate_trace.png'],true);

%%
% The section for the PPL below is overly complicated in that it more or
% less duplicates pre-existing behaviour but with syntax based on the ALM
% treatment. 
% 
zone = ((abs(star.Zn)==5)|(abs(star.Zn)==4)|(abs(star.Zn)==3))&(star.Str==2);
if star.isPPL
   star.QA_PPL = 0; star.QA_above = 0; star.QA_below = 0;
   title_str = {['Principal Plane Scan: ',fstem] ; ...
      [datestr(star.time(1),'mmm dd, yyyy HH:MM UTC'),'. Altitude=',sprintf('%3.0f m',mean(star.Alt)), ...
      ', SZA=',sprintf('%2.0f deg',mean(star.sza))]};
   sat = star.sat_ij(:,star.aeronetcols(end));
   below_orb = (star.El_gnd < star.sunel)& (abs(star.Az_gnd-star.sunaz)<5);
   above_orb = (star.El_gnd > star.sunel)& (abs(star.Az_gnd-star.sunaz)<5);
      rad_b4 = star.skyrad(zone&below_orb&~sat,star.aeronetcols(vis_pix(end)));
   SA_b4 = SA(zone&below_orb&~sat);
   el_b4  = star.El_gnd(zone&below_orb&~sat)-...
      star.sunel(zone&below_orb&~sat);
   rad_f2 = star.skyrad(zone&above_orb&~sat,star.aeronetcols(vis_pix(end)));
   SA_f2 = SA(zone&above_orb&~sat);
   el_f2  = star.El_gnd(zone&above_orb&~sat)...
      -star.sunel(zone&above_orb&~sat);
   
   lowest_top = min([max(rad_b4),max(rad_f2)]);
   highest_bot = max([min(rad_b4),min(rad_f2)]);
   overlap =(lowest_top+highest_bot)./2;

   [rad_b4, ij] = unique(rad_b4);
   el_b4 = el_b4(ij); SA_b4 = SA_b4(ij);
   
   [rad_f2, ij] = unique(rad_f2);
   el_f2 = el_f2(ij);    SA_f2 = SA_f2(ij);
   
   [rad_near, rad_ij] = unique([lowest_top; highest_bot; overlap]);
%    rad_near([1 end]) = [];
   
   if (length(rad_b4)>0)&&(length(rad_f2)>0)
      below = interp1(rad_b4,el_b4,overlap,'pchip','extrap');
      above = interp1(rad_f2, el_f2,overlap,'pchip','extrap');
      SA_below = interp1(rad_b4, SA_b4, rad_near, 'pchip');
      SA_above = interp1(rad_f2, SA_f2, rad_near,'pchip');
      dSA = (SA_above - SA_below)./2;
      miss = (above+below)./2;
      dSA = mean(dSA);

   
   % miss = .85;
   if abs(miss)>3 || abs(mean(dSA))>3
      star.QA_PPL = 1;
   end
   star.El_miss = miss;
   star.El_gnd(star.Str==2) = star.El_gnd(star.Str==2) - star.El_miss;
   star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_gnd), star.Az_gnd);
   star.above_orb = above_orb;
   star.below_orb = below_orb;
   SA_new = SA;
   SA_new(above_orb&star.Str==2) =  SA_new(above_orb&star.Str==2)- mean(dSA);
   SA_new(below_orb&star.Str==2) =  SA_new(below_orb&star.Str==2)+ mean(dSA);
   
   figure;
   plot(abs(star.El_gnd(zone&below_orb)...
      -star.sunel(zone&below_orb)), ...
      star.skyrad(zone&below_orb,star.aeronetcols(vis_pix(end))),'o',...
      abs(star.El_gnd(zone&above_orb)...
      -star.sunel(zone&above_orb)), ...
      star.skyrad(zone&above_orb,star.aeronetcols(vis_pix(end))),'x');
   title(['Near-sun sky zone shifted by ',sprintf('%2.2f deg',miss)]);
   ylabel('radiance');legend('Below sun','Above sun')
   xlabel('El shifted - sun El');
   
   figure;
   plot(SA_new(zone&below_orb),star.skyrad(zone&below_orb,star.aeronetcols(vis_pix(end))),'o',...
      SA_new(zone&above_orb), star.skyrad(zone&above_orb,star.aeronetcols(vis_pix(end))),'x');
   title(['Near-sun sky zone shifted by ',sprintf('%2.2f deg',mean(dSA))]);
   ylabel('radiance');legend('Below sun','Above sun')
   xlabel('SA shifted');
   else
      miss = NaN;
      dSA = NaN;
      star.QA_PPL = 1;
      if length(rad_b4)<2||any(isnan(rad_b4))
         star.QA_above = 1;
      end
      if length(rad_f2)<2||any(isnan(rad_f2))
         star.QA_below = 1;
      end
      star.SA = SA;
   end
   % %     figout = savefig(gcf,[figdir, fstem,'.ppl_shift.png'],true);
else
   star.QA_CCW = 0;
   star.QA_CW = 0;
   star.QA_CW_CCW = 0;
   title_str = {['Almucantar Scan: ',fstem] ; ...
      [datestr(star.time(1),'mmm dd, yyyy HH:MM UTC'),'. Altitude=',sprintf('%3.0f m',mean(star.Alt)), ...
      ', SZA=',sprintf('%2.0f deg',mean(star.sza))]};
   % Identify legs, then compute miss for each leg independently using
   % near sun sky scan measurements similar to PPL.
   % consider this carefully in light of PPL azimuth adjustments
   %%
   
   % By quirk of 4STAR naming convention, 4STAR "positive" zones are for zone with ZA < SZA, which is a CCW rotation.
   % The CCW branch is executed first, followed by the CW branch, so we might
   % expect the CCW branch to be more robust and less susceptible to
   % unexpected aircraft motion
   
   ccw_p_i= find(star.Zn<0&star.Str==2,1,'first');  % Start of CCW leg is with ZA>SZA,
   ccw_p_j = ccw_p_i + find(star.Zn(ccw_p_i+1:end)>0|star.Str(ccw_p_i+1:end)~=2,1,'first')-1;
   ccw_n_i = find(star.Zn>0&star.Str==2,1,'first');  % Positize zones are negative SA, ZA < SZA
   ccw_n_j = ccw_n_i+find(star.Zn(ccw_n_i+1:end)==0,1,'first')-1;
   midsun = ccw_n_j+find(star.Zn(ccw_n_j+1:end)==0,1,'first'); %middle position returning to sun between CCW and CW legs
   ccw_last = ccw_n_j;
   ccw = [ccw_p_i:ccw_p_j ccw_n_i:ccw_last];
   
   cw_n_i = midsun + find(star.Zn(midsun+1:end)~=1, 1,'first'); % Postive zones are negative SA
   cw_n_j = cw_n_i + find(star.Str(cw_n_i+1:end)~=2,1,'first')-1;
   cw_p_i = cw_n_j+find(star.Zn(cw_n_j+1:end)~=1&star.Str(cw_n_j+1:end)==2,1,'first');
   cw_p_j = cw_p_i + find(star.Zn(cw_p_i+1:end)~=0,1,'last');
   cw = [cw_n_i:cw_n_j cw_p_i:cw_p_j];
   
   CW = false(size(star.t)); CCW = CW; NEG = CW; POS = CW;
   CW(1:midsun-1) = true;
   CCW(midsun:end) = true;
   NEG([cw_n_i:cw_n_j ccw_n_i:ccw_n_j]) = true;
   POS([cw_p_i:cw_p_j, ccw_p_i:ccw_p_j]) = true;
   
   sa = SA; sa(NEG) = -sa(NEG);
   
   figure; plot(sa(CW&NEG), star.skyrad(CW&NEG,star.aeronetcols),'-x',...
      sa(CCW&POS), star.skyrad(CCW&POS,star.aeronetcols),'k-o')
   
   %First, assess CCW leg based on symmetry of POS and NEG portions
   SA_ = (SA<7)&((CCW&NEG)|(CCW&POS))&~star.sat_ij(:,star.aeronetcols(end));
   plot(sa(SA_&CCW&NEG), star.skyrad(SA_&CCW&NEG,star.aeronetcols),'-x',...
      sa(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');
   title('CCW leg, original')
   
   CCW_X = SA(SA_&CCW&POS); CCW_Y = star.skyrad(SA_&CCW&POS,star.aeronetcols(end));
   CCW_X(isnan(CCW_Y)) = []; CCW_Y(isnan(CCW_Y)) = [];
   CCW_neg_X = SA(SA_&CCW&NEG); CCW_neg_Y = star.skyrad(SA_&CCW&NEG,star.aeronetcols(end));
   CCW_neg_X(isnan(CCW_neg_Y)) = []; CCW_neg_Y(isnan(CCW_neg_Y)) = [];
   
   min_max = min([max(CCW_Y), max(CCW_neg_Y)]);
   max_min = max([min(CCW_Y), min(CCW_neg_Y)]);
   Ys = unique([CCW_Y; CCW_neg_Y]); 
   if ~isempty(Ys)
      Ys(Ys<max_min) = [];
   end
   if ~isempty(Ys)
      Ys(Ys>min_max)=[];
   end
   if isempty(Ys)
      Ys = [min_max, mean([min_max max_min]), max_min];
   end
   if length(CCW_Y)>1&&length(CCW_neg_Y)>1
      X_CCW = interp1(CCW_Y, CCW_X, Ys,'pchip');
      X_CCW_neg = interp1(CCW_neg_Y, CCW_neg_X, Ys,'pchip');
      dX_CCW = (X_CCW-X_CCW_neg);
      star.SA_CCW_offset = mean(dX_CCW);
      if mean(abs(dX_CCW))<2
         SA(CCW&POS) = SA(CCW&POS)-mean(dX_CCW)./2;
         SA(CCW&NEG) = SA(CCW&NEG) + mean(dX_CCW)./2;
         star.QA_CCW = 0; % 0 is good
         sa = SA; sa(NEG) = -SA(NEG);
         plot(SA(SA_&CCW&NEG), star.skyrad(SA_&CCW&NEG,star.aeronetcols),'-x',...
            SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');
         title(['CCW leg, shifted by ',sprintf('%2.1f',mean(dX_CCW)./2)])
      else
         warning('Offset for CCW branch > 2')
         star.QA_CCW = 1; % suspect
      end
   else
      warning('Insufficient valid points to assess CCW branch')
      star.QA_CCW = 1;
      star.SA_CCW_offset = NaN;
      dX_CCW = NaN;
   end
   
   %Next, assess CW leg based on symmetry of POS and NEG portions
   SA_ = (SA<7)&((CW&NEG)|(CW&POS))&~star.sat_ij(:,star.aeronetcols(end));
   plot(sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x',...
      sa(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols),'k-o');
   title('CW leg, original')
   CW_X = SA(SA_&CW&POS); CW_Y = star.skyrad(SA_&CW&POS,star.aeronetcols(end));
   CW_X(isnan(CW_Y)) = []; CW_Y(isnan(CW_Y)) = [];
   CW_neg_X = SA(SA_&CW&NEG); CW_neg_Y = star.skyrad(SA_&CW&NEG,star.aeronetcols(end));
   CW_neg_X(isnan(CW_neg_Y)) = []; CW_neg_Y(isnan(CW_neg_Y)) = [];
   min_max = min([max(CW_Y), max(CW_neg_Y)]);
   max_min = max([min(CW_Y), min(CW_neg_Y)]);
   Ys = unique([CW_Y; CW_neg_Y]); Ys(Ys<max_min) = [];Ys(Ys>min_max)=[];
   if isempty(Ys)
      Ys = [min_max, mean([min_max max_min]), max_min];
   end
   
   if length(CW_Y)>1 && length(CW_neg_Y)>1  % then we have enough points to assess CW symmetry
      X_CW = interp1(CW_Y, CW_X, Ys,'pchip');
      X_CW_neg = interp1(CW_neg_Y, CW_neg_X, Ys,'pchip');
      dX_CW = (X_CW-X_CW_neg);
      star.SA_CW_offset = mean(dX_CW);
      if mean(abs(dX_CW))<1
         SA(CW&POS) = SA(CW&POS)-mean(dX_CW)./2;
         SA(CW&NEG) = SA(CW&NEG) + mean(dX_CW)./2;
         star.QA_CW = 0; % 0 is good
         sa = SA; sa(NEG) = -SA(NEG);
         plot(SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x',...
            SA(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols),'k-o');
         title(['CW leg, shifted by ',sprintf('%2.1f',mean(dX_CW)./2)])
      else
         warning('Offset for CW branch > 1')
         star.QA_CW = 1; % suspect
      end
   else
      warning('Insufficient valid points to assess CW branch independently')
      star.QA_CW = 1;
      star.SA_CW_offset = NaN;
      dX_CW = NaN;
   end
   % At this point the CCW and CW legs have both been assessed for symmetry,
   % adjusted if possible, and flagged as good or suspect
   
   %Check if only one was leg was deemed to be good and if so register the
   %main branch of the other one to it
    if sum(star.QA_CW)==1 || (star.QA_CCW)==1
      % Assess primary CCW and CW legs against each other
      SA_ = (SA<7)&((CW&NEG)|(CCW&POS))&~star.sat_ij(:,star.aeronetcols(end));
      plot(sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x',...
         sa(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');
      title('CW and CCW main branches, before final adjustment')
      CCW_X = SA(SA_&CCW&POS); CCW_Y = star.skyrad(SA_&CCW&POS,star.aeronetcols(end));
      CCW_X(isnan(CCW_Y)) = []; CCW_Y(isnan(CCW_Y)) = [];
      CW_neg_X = SA(SA_&CW&NEG); CW_neg_Y = star.skyrad(SA_&CW&NEG,star.aeronetcols(end));
      CW_neg_X(isnan(CW_neg_Y)) = []; CW_neg_Y(isnan(CW_neg_Y)) = [];
      min_max = min([max(CCW_Y), max(CW_neg_Y)]);
      max_min = max([min(CCW_Y), min(CW_neg_Y)]);
      Ys = unique([CCW_Y; CW_neg_Y]); Ys(Ys<max_min) = [];Ys(Ys>min_max)=[];
      if isempty(Ys)
         Ys = [min_max, mean([min_max max_min]), max_min];
      end
      if length(CCW_Y)>1 && length(CW_neg_Y)>1 % then we have enough points to assess CW vs CCW symmetry
         X_CW_neg = interp1(CCW_Y, CCW_X, Ys,'pchip');
         X_CCW = interp1(CW_neg_Y, CW_neg_X, Ys,'pchip');
         dX_CCW_CW = (X_CW_neg-X_CCW);
         star.SA_CCW_CW_offset = mean(dX_CCW_CW);
         if mean(dX_CCW_CW)<5 && std(dX_CCW_CW)<1.5% Then we'll trust it and adjust one branch and mask out short side
            if (star.QA_CCW == 0) && (star.QA_CW == 1)
               SA(CW&NEG) = SA(CW&NEG) + mean(dX_CCW_CW);
               SA(CW&POS) = SA(CW&POS) - mean(dX_CCW_CW);
               star.skyrad(CW&POS,:) = NaN; %POS is short branch of CW leg, mask it out
            elseif (star.QA_CW == 0) && (star.QA_CCW == 1)
               SA(CCW&NEG) = SA(CCW&NEG) + mean(dX_CCW_CW);
               SA(CCW&POS) = SA(CCW&POS) - mean(dX_CCW_CW);
               star.skyrad(CCW&NEG,:) = NaN; % NEG is short branch of CCW leg, mask it out
            else
               SA(CW&NEG) = SA(CW&NEG) + mean(dX_CCW_CW)./2;
               SA(CCW&POS) = SA(CCW&POS) - mean(dX_CCW_CW)./2;
               
               star.skyrad(CCW&NEG,:) = NaN; % NEG is short branch of CCW leg, mask it out
               star.skyrad(CW&POS,:) = NaN; %POS is short branch of CW leg, mask it out
            end
            sa = SA; sa(NEG) = -SA(NEG);
            plot(SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x',...
               SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');      title(['CW and CCW main branches, with final shift of ',sprintf('%2.1f',mean(dX_CCW_CW))])
         else
            warning('Offset of CW relative to CCW  > 5 or too variable')
            star.QA_CCW_CW = 1;
         end
      else
         warning('Insufficient valid points to assess branch symmetry')
         star.QA_CCW_CW = 1;
         star.SA_CCW_CW_offset = NaN;
      end
    end
      
      sa = SA; sa(NEG) = -SA(NEG);
      figure
      subplot(2,1,1);
      these = plot(sa(CW), star.skyrad(CW,star.aeronetcols),'-'); recolor(these,[3:-1:1]);
      for th=1:length(these)
         text(sa(CW), star.skyrad(CW,star.aeronetcols(th)),...
            repmat({'L'},size(star.skyrad(CW,star.aeronetcols(th)))),...
            'color',get(these(th),'color'));
      end
      hold('on');
      those= plot( sa(CCW), star.skyrad(CCW,star.aeronetcols),'-');recolor(those,3:-1:1);
      for toe=1:length(those)
         text(sa(CCW), star.skyrad(CCW,star.aeronetcols(toe)),...
            repmat({'R'},size(star.skyrad(CCW,star.aeronetcols(toe)))),...
            'color',get(those(toe),'color'));
      end
      
      subplot(2,1,2);
      %% 
      thats = plot(SA(CW), star.skyrad(CW,star.aeronetcols),'-kx',...
         SA(CCW), star.skyrad(CCW,star.aeronetcols),'-ko');
         recolor(thats,[3:-1:1, 3:-1:1]);
      
      %% 
      
      star.SA = SA;
      star.CW = CW; star.CCW = CCW;star.NEG = NEG; star.POS = POS;
      %
   end
   
   
   % if star.isPPL
   % %     star.SA(star.El_gnd<star.sunel) = -1.*star.SA(star.El_gnd<star.sunel);
   %     legx =  find([0;abs(diff(star.El_deg)) > 100],1,'first');
   % else
   % %     star.SA(star.Az_gnd<star.sunaz) = -1.*star.SA(star.Az_gnd<star.sunaz);
   %     legx =  find([0;(abs(diff(star.Az_deg)) > 100)],1,'first');
   % end
   % leg_A = false(size(star.time));
   % leg_A(1:(legx-1)) = true;
   % leg_B = ~leg_A;
   %%
   % figure;
   % subplot(2,1,1); plot([1:length(star.time)], star.Az_gnd-star.sunaz,'.',[1:length(star.time)], star.SA./cos(star.sunel.*pi./180),'o');
   % title({[fstem];['Top plot agrees for ALM']},'interp','none');
   % legend('Az-SAZ','SA*cos(sunel)','location','northwest')
   % subplot(2,1,2); plot([1:length(star.time)], star.El_gnd-star.sunel,'.',[1:length(star.time)], star.SA,'o');
   % title('Bottom plot agrees for PPL but diverges after zenith.')
   % legend('El-sunel','SA','location','northwest')
   % xlabel('record number');
   %
   % figure; plot(star.SA(star.Str==2&star.SA>0), ...
   %     star.visTint(star.Str==2&star.SA>0),'-o');
   % title({[fstem];['Scattering angle vs Vis Tint(ms)']},'interp','none');
   % xlabel('Scattering angle');
   % ylabel('Vis Tint [ms]');
   
   % Would like to distinguish the portion of the PPL below the sun EL
   % from the rest, and would also like to distinguish the half-ALM acquired on one side
   % of the sun from the half-scan acquired on the opposite semicircle.
   % Also, our ALMs are measured starting a few degrees to one side of the
   % sun past the solar disk, and then out to 180 deg.  The symmetry of
   % the near-sun signal for a given azimuthal scan direction could be
   % used to infer a more accurate azimuthal offset for each leg.
   %
   
   if star.isPPL
      good_ppl =  star.Str==2&star.El_gnd>0   ;

      good_ppl(star.Str==2&star.El_gnd>0) = sky_angstrom_screen(star.w(star.aeronetcols(vis_pix)), ...
         star.SA(star.Str==2&star.El_gnd>0),...
         star.skyrad(star.Str==2&star.El_gnd>0,star.aeronetcols(vis_pix)));
      star.good_ppl = good_ppl;
      %%
      if ~exist('fog','var')
         fog = figure;
      else
         figure(fog);
      end
      semilogy(star.SA(star.Str==2&star.El_gnd>0&good_ppl), ...
         star.skyrad(star.Str==2&star.El_gnd>0&good_ppl,star.aeronetcols(vis_pix)),'-o');

%       hold('on');
%       plot(star.SA(star.Str==2&star.El_gnd>0&(star.sat_time|~good_ppl)), ...
%          star.skyrad(star.Str==2&star.El_gnd>0&(star.sat_time|~good_ppl),star.aeronetcols(vis_pix)), 'ro','markerface','k' );
%       hold('off')
      xlabel('scattering angle [degrees]');
      ylabel('mW/(m^2 sr nm)');
      title(title_str,'interp','none')
      grid('on');
      set(gca,'Yminorgrid','off');
      
      
      leg_str{1} = sprintf('%2.0f nm AOD (%2.2f)',star.w(star.aeronetcols(vis_pix(1)))*1000, star.tau_aero_skyscan(1));
      for ss = 2:length(star.aeronetcols(vis_pix))
         leg_str{ss} = sprintf('%2.0f nm AOD (%2.2f)',star.w(star.aeronetcols(vis_pix(ss)))*1000,star.tau_aero_skyscan(ss));
      end
      legend(leg_str, 'location','northeast');
      
      xlim([0,ceil(max(star.SA(good_ppl)).*.1).*10]);
      if star.QA_PPL || star.QA_above || star.QA_below
         
         QA_str = {};
         if star.QA_below==1
            QA_str = {'PPL portion below sun is suspect'};
         end
          if star.QA_above==1
             QA_str(end+1) = {'PPL portion above sun is suspect'};
          end
          warning(QA_str{:})
          txt = text(.1, .95,QA_str, 'units','norm', 'color','red','linestyle','-','fontsize',14)
      end
      
   else
      %%
      good_almA = CCW&(POS|NEG);star.good_almA = good_almA; 
%       good_almA(good_almA) = sky_angstrom_screen(star.w(star.aeronetcols(vis_pix)), ...
%          sa(good_almA),star.skyrad(good_almA,star.aeronetcols(vis_pix)));
      good_almB = CW&(POS|NEG);star.good_almB = good_almB;
      good_alm = good_almA|good_almB; star.good_alm = good_alm;
%       good_almB(good_almB) = sky_angstrom_screen(star.w(star.aeronetcols(vis_pix)), ...
%          star.SA(good_almB),star.skyrad(good_almB,star.aeronetcols(vis_pix)));
%       star.good_alm = good_almA|good_almB;
      
      
      %     good_alm = sky_symmetry_screen(star.w(star.aeronetcols(vis_pix)), ...
      %     star.SA(good_almB),star.skyrad(good_almB,star.aeronetcols(vis_pix)))
      
      if ~exist('fog','var')
         fog = figure;
      else
         figure(fog);
      end
      semilogy(star.SA(good_almA), ...
         star.skyrad(good_almA,star.aeronetcols(vis_pix)),'-o');
      xlabel('scattering angle [degrees]');
      ylabel('mW/(m^2 sr nm)');
      title(title_str,'interp','none')
      grid('on'); set(gca,'Yminorgrid','off');
      leg_str{1} = sprintf('%2.0f nm, AOD(%2.2f)',star.w(star.aeronetcols(1))*1000, star.tau_aero_skyscan(1));
      for ss = 2:length(star.aeronetcols(vis_pix))
         leg_str{ss} = sprintf('%2.0f nm, AOD(%2.2f)',star.w(star.aeronetcols(ss))*1000, star.tau_aero_skyscan(ss));
      end
      legend(leg_str,'location','northeast');
      hold('on')
      semilogy(abs(star.SA(good_almB)), ...
         star.skyrad(good_almB,star.aeronetcols(vis_pix)),'k-');
      %       semilogy(star.SA(good_almB&star.sat_time), star.skyrad(good_almB&star.sat_time,star.aeronetcols(vis_pix)), 'ro','markerface','k' );
      hold('off')
      xlim([0,ceil(max(star.SA(good_almB|good_almA)).*.1).*10]);
      %%
      if star.QA_CW||star.QA_CCW||star.QA_CW_CCW
      QA_str = {};
         if star.QA_CW==1
            QA_str(1) = {'CW portion is suspect'};
         end
          if star.QA_CCW==1
             QA_str(end+1) = {'CCW portion is suspect'};
          end
         if star.QA_CW_CCW==1
             QA_str(end+1) = {'CW and CCW notaligned'};
          end
         
          warning(QA_str{:})
          txt = text(.05, .05,QA_str, 'units','norm', 'color','red',...
             'linestyle','-','fontsize',14,'VerticalAlignment','bottom');
      end
   end
   %%
   if isfield(star,'good_ppl')&&~isfield(star,'good_alm')
      star.good_sky = star.good_ppl;
   end
   if ~isfield(star,'good_ppl')&&isfield(star,'good_alm')
      star.good_sky = star.good_alm;
   end
   
   if isfield(star,'good_ppl')&&isfield(star,'good_alm')
      if sum(star.good_ppl)>sum(star.good_alm)
         star.good_sky = star.good_ppl;
      else
         star.good_sky = star.good_alm;
      end
   end
   %%
   
   
   % figdir = ['C:\Users\d3k014\Desktop\TCAP\instruments\4STAR\img\sky_scans\'];
   % figout = savefig(gcf,[figdir, fstem,'.png'],true);
   % if ~isempty(figout)
   % figout = strrep(figout,'.png','.fig');
   % % savefig(gcf,figout,false);
   % end
   % %%
   % star_light_fname = [pname, '..',filesep,'mats',filesep,datestr(star.t(1),'yyyymmdd'),'starsun_LIGHT.mat'];
   % % star_light_fname = ['C:\Users\d3k014\Desktop\TCAP\instruments\4STAR\mats\20120722starsun_about22.mat'];
   % if exist(star_light_fname,'file')
   %   sun_aods = get_star_light(star_light_fname, star.t, star.aeronetcols(vis_pix));
   %   star.sun_aods = sun_aods;
   % end
   %
   % %% Read Mihal's CWV files here cwv_20120722.mat
   % star_cwv_fname = [pname, '..',filesep,'mats',filesep,'cwv_',datestr(star.t(1),'yyyymmdd'),'.mat'];
   % % star_light_fname = ['C:\Users\d3k014\Desktop\TCAP\instruments\4STAR\mats\20120722starsun_about22.mat'];
   % if exist(star_cwv_fname,'file')
   %   pwv = get_star_cwv(star.t(star.good_sky), star.Alt(star.good_sky),star_cwv_fname);
   %   star.PWV = pwv;
   % end
   % %% Windspeed
   % % Read G1 met file here 20120715a.met.txt
   %
   % while ~exist('star_met_fname','var')||~exist(star_met_fname,'file')
   %     star_met_fname = getfullname([pname, '..',filesep,'..',filesep,'G1',filesep,datestr(star.t(1),'yyyymmdd'),'*.met*.txt']);
   % end
   % %%
   % % star_light_fname = ['C:\Users\d3k014\Desktop\TCAP\instruments\4STAR\mats\20120722starsun_about22.mat'];
   % pwv = load(star_cwv_fname);
   %   WindSpeed = get_star_WindSpeed(star.t(star.good_sky), star.Alt(star.good_sky),pwv.time, pwv.Alt, star_met_fname);
   %   %%
   %   star.wind_speed = WindSpeed;
   % %%
   % % Read OMI file here gecomiX1.a1.20120701.000000.cdf
   % % star_omi_fname = [pname, '..',filesep,'..',filesep,'OMI',filesep,['gecomiX1.a1.',datestr(star.t(1),'yyyymm01.000000'),'.cdf']];
   % % if exist(star_omi_fname,'file')
   %   Ozone_DU = getdailyomi(mean(star.t(star.good_sky)), mean(star.Lat(star.good_sky)), mean(star.Lon(star.good_sky)));
   %   %(star_met_fname, mean(star.t(good_sky)),mean(star.Lat(good_sky)), mean(star.Lon(good_sky)));
   %   star.O3col = Ozone_DU;
   % %    s.O3col=0.330;
   % %  s.land_fraction = 0.02;
   %
   % % end
   %%
   %
   
   %
   
   return
