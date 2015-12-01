function star = starsky_scan(star)
% Generate sky scans from starsky struct
% This routine is called from "starsky"
[pname,fstem,ext] = fileparts(star.filename{1});
pname = [pname, filesep];
fstem = strrep(fstem, '_VIS','');
star.time = star.t;
% sat_rad = star.skyrad;
% sat_rad(star.sat_ij) = NaN;
recs = (1:length(star.time))';
% First, apply known mechanical/optical offsets between sun and sky barrels to yield 4STAR optical orientation
% in the aircraft frame.
star.sun_sky_El_offset = 3.5; %This represents the known mechanical offset between the sun and sky FOV in elevation.
star.sun_sky_Az_offset = 0;
star.Az_deg = -1.*star.AZstep./50;

% catch erroneous Headng==0 condition &star.Headng~=0
star.Az_offset_sun = mean(star.Headng(star.Str==1&star.Zn==0&star.Headng~=0)+  ...
    star.Az_deg(star.Str==1 & star.Zn==0 & star.Headng~=0) - star.sunaz(star.Str==1 & star.Zn==0 & star.Headng~=0));
star.El_offset_sun = mean(star.El_deg(star.Str==1 & star.Zn==0 & star.Headng~=0) - star.sunel(star.Str==1 & star.Zn==0 & star.Headng~=0));
star.Az_true = mod(star.Headng+ star.Az_deg - star.Az_offset_sun,360);
star.Az_true = star.Az_deg;
star.El_true = star.El_deg- star.El_offset_sun;
star.El_true = star.El_deg;
star.El_true(star.Str==2) = star.El_deg(star.Str==2) - star.sun_sky_El_offset;
star.isPPL = std(star.El_true)>std(star.Az_true);
%%
figdir = ['D:\data\4STAR\yohei\img\'];

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
        star.Az_true(star.sat_time)+star.Headng(star.sat_time)-star.sunaz(star.sat_time),...
        star.El_true(star.sat_time)-star.sunel(star.sat_time)]'))
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

% For accurate sky scans, we need to know what direction we are viewing
% relative to the earth-sun frame.
% Best will probably be to use aircraft telemetry and Euler rotations to
% convert the 4STAR az and el positions together with aircraft attitude but
% for the time being we'll assume straight and level flight during sky
% scans and use the sun-tracking measurements to infer offsets for az and
% el.

% Then, we'll follow either of these with case-by-case adjustments based on
% symmetry of scans across the solar disk.

% We may need to screen individual points either manually or based
% on deviation from interleaved curve fits.

% Finally, we need to populate the aip strings and run the retrieval.


% star.Az_ac = star.Az_deg;
% star.Az_ac(star.Str==2) = star.Az_ac(star.Str==2) - star.sun_sky_Az_offset;
% star.El_ac = star.El_deg;
% star.El_ac(star.Str==2) = star.El_ac(star.Str==2) - star.sun_sky_El_offset;

% Potentially apply other offsets based on Quad or ALM symmetry, etc...
% No corrections for this yet.

% Then apply rotations corresponding to aircraft heading, pitch, and roll
% to yield 4STAR optical orientation in ground frame.

% Test Kluzek rotations both ways. Check that rotated values of sunaz and sunel yield good
% agreement with 4STAR axis, and that the quad values are balanced for sun
% tracking.
% [star.sza, star.saz, star.soldst, ~, ~, star.sunel, star.am] = sunae(star.Lat, star.Lon, star.time);
% [ac_az, ac_el] = ang_ac_kluzek(star.saz, star.sunel,star.Headng, star.pitch, star.roll);
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
%%
% [az_gnd, el_gnd] = ang_ac_to_gnd_kluzek(ac_az, ac_el,azim, pitch, roll)

% Finally, compute SA relative to sunaz and sunel.
% Compute the offset between 4STAR azimuth and elevation and the aircraft fusilage.
% Best is to use aircraft telemetry and Euler rotations, but for now assume
% straight and level flight.
% % The commented code below only works when on the ground.
% % It _nearly_ works for straight level legs.
% % It fails for spirals.  We need Euler angle rotations to get this right.
% Az_offset =mean(s.Headng(tl)+s.Az_deg(tl) - s.sunaz(tl));
% s.Az_true = mod(s.Headng +s.Az_deg,360) - Az_offset;
% Based on ground-based data from July 18, after correcting for the sign of
% AZ_deg (mult by -1), s.Headng + s.Az_deg = s.sunaz to within one degree
%
% Could include a check on the quad voltages to make sure we're really tracking.



%Now convert 4STAR Az/El geometry (that permits El from horizon to horizon)
%to AERONET geometry with El from 0 to 90 and Az adjusted by 180 when El is
%on oppposite side of zenith from sun.
over_top = star.El_true>90;
star.El_true(over_top) = 180-star.El_true(over_top);
star.Az_true(over_top) = mod(star.Az_true(over_top)+180,360);
%(az_deg, el_deg, heading_deg, pitch_deg, roll_deg)
[star.Az_gnd, star.El_gnd] = ac_to_gnd_SEACRS(star.Az_true, star.El_true, star.Headng,  star.pitch, star.roll );

%  star.aeronetcols = [332, 624,880,1040];
vis_pix = find(star.aeronetcols);
% vis_pix = find((1000*star.w(star.aeronetcols))<1000);
% % vis_pix = vis_pix([1 3 5 7]);
% vis_pix(star.aeronetcols(vis_pix)>1044) = [];
% vis_pix = vis_pix(1:2:end);
star.vis_pix = vis_pix;
%%
% Use zone==0 and Str==1 to define the actual sun position and the
% angular offsets.
% star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_true), star.Az_true);
star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_gnd), star.Az_gnd);

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
% star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_true), star.Az_true);
% recs = (1:length(star.time));
% figure;
% ss(1) = subplot(2,1,1);
% plot(recs,star.skyrad(:,star.aeronetcols(vis_pix(end))), '-b.');
% title(fstem,'interp','none');
% ylabel('rate');
% ss(2) = subplot(2,1,2);
% if ~star.isPPL
%     plot(recs(star.Str==0&star.Headng~=0),acosd(cosd(star.Az_true(star.Str==0&star.Headng~=0)-star.sunaz((star.Str==0&star.Headng~=0)))),'b.',...
%         recs(star.Str==1&star.Headng~=0),acosd(cosd(star.Az_true(star.Str==1&star.Headng~=0)-star.sunaz(star.Str==1&star.Headng~=0))),'bo',...
%         recs(star.Str==2&star.Headng~=0),acosd(cosd(star.Az_true(star.Str==2&star.Headng~=0)-star.sunaz(star.Str==2&star.Headng~=0))),'gx',....
%         recs(star.Str==0&star.sat_time&star.Headng~=0),acosd(cosd(star.Az_true(star.Str==0&star.sat_time&star.Headng~=0)-star.sunaz(star.Str==0&star.sat_time&star.Headng~=0))),'r.',...
%         recs(star.Str==1&star.sat_time&star.Headng~=0),acosd(cosd(star.Az_true(star.Str==1&star.sat_time&star.Headng~=0)-star.sunaz(star.Str==1&star.sat_time&star.Headng~=0))),'ro',...
%         recs(star.Str==2&star.sat_time&star.Headng~=0),acosd(cosd(star.Az_true(star.Str==2&star.sat_time&star.Headng~=0)-star.sunaz(star.Str==2&star.sat_time&star.Headng~=0))),'rx')
%     ylabel('Az - Sunaz [deg]')
% else
%     plot(recs(star.Str==0),star.El_true(star.Str==0)-star.sunaz((star.Str==0)),'b.',...
%         recs(star.Str==1),star.El_true(star.Str==1)-star.sunel(star.Str==1),'bo',...
%         recs(star.Str==2),star.El_true(star.Str==2)-star.sunel(star.Str==2),'gx',....
%         recs(star.Str==0&star.sat_time),star.El_true(star.Str==0&star.sat_time)-star.sunel(star.Str==0&star.sat_time),'r.',...
%         recs(star.Str==1&star.sat_time),star.El_true(star.Str==1&star.sat_time)-star.sunel(star.Str==1&star.sat_time),'ro',...
%         recs(star.Str==2&star.sat_time),star.El_true(star.Str==2&star.sat_time)-star.sunel(star.Str==2&star.sat_time),'rx')
%     ylabel('El - Sunel [deg]')
%     
% end
% legend('closed','sun','sky','location','south')
% linkaxes([s,ss],'x')

% figout = savefig(gcf,[figdir, fstem,'.rate_trace.png'],true);

%%
% 
if star.isPPL
    title_str = {['Principal Plane Scan: ',fstem] ; ...
        [datestr(star.time(1),'mmm dd, yyyy HH:MM UTC'),'. Altitude=',sprintf('%3.0f m',mean(star.Alt)), ...
        ', SZA=',sprintf('%2.0f deg',mean(star.sza))]};
    below_orb = (star.El_true < star.sunel)& (abs(star.Az_true-star.sunaz)<5);
    lowest_top = min([max(star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb,star.aeronetcols(vis_pix(end)))),...
        max(star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb,star.aeronetcols(vis_pix(end))))]);
    highest_bot = max([min(star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb,star.aeronetcols(vis_pix(end)))),...
        min(star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb,star.aeronetcols(vis_pix(end))))]);
%     overlap =(lowest_top+highest_bot)./2;
%     rad_b4 = star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb,star.aeronetcols(vis_pix(end)));
%     el_b4  = star.El_true(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb)-...
%         star.sunel(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb);
%     el_b4 = el_b4(~isNaN(rad_b4));
%     rad_b4 = rad_b4(~isNaN(rad_b4));
%     [rad_b4, ij] = unique(rad_b4);
%     el_b4 = el_b4(ij);
%     
%     rad_f2 = star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb,star.aeronetcols(vis_pix(end)));
%     el_f2  = star.El_true(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb)...
%         -star.sunel(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb);
%     el_f2 = el_f2(~isNaN(rad_b4));
%     rad_f2 = rad_f2(~isNaN(rad_b4));
%     [rad_f2, ij] = unique(rad_f2);
%     el_f2 = el_f2(ij);
%     if (length(rad_b4)>1)&&(length(rad_f2)>1)
%         below = interp1(rad_b4,el_b4,overlap,'pchip','extrap');
%         above = interp1(rad_f2, el_f2,overlap,'pchip','extrap');
%         miss = (above+below)./2;
%     else
%         miss = 0;
%     end
%     
%     %     subplot(2,1,1);
%     %     plot(star.El_true((abs(star.Zn)==3))-star.sunel((abs(star.Zn)==3)), ...
%     %         star.skyrad((abs(star.Zn)==3),star.aeronetcols(vis_pix(end))),'-',...
%     %         star.El_true((abs(star.Zn)==3)&below_orb)-star.sunel((abs(star.Zn)==3)&below_orb), ...
%     %         star.skyrad((abs(star.Zn)==3)&below_orb,star.aeronetcols(vis_pix(end))),'o',...
%     %         star.El_true((abs(star.Zn)==3)&~below_orb)-star.sunel((abs(star.Zn)==3)&~below_orb), ...
%     %         star.skyrad((abs(star.Zn)==3)&~below_orb,star.aeronetcols(vis_pix(end))),'x');
%     %     % See if the two branches have any overlapping intensity.
%     %     %
%     %     subplot(2,1,2);
miss = 0;
    figure;
    plot(abs(star.El_true(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb)...
        -star.sunel(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb)-miss), ...
        star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&below_orb,star.aeronetcols(vis_pix(end))),'o',...
        abs(star.El_true(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb)...
        -star.sunel(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb)-miss), ...
        star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&~below_orb,star.aeronetcols(vis_pix(end))),'x');
    title(['Near-sun sky zone shifted by ',sprintf('%2.2f deg',miss)]);
    ylabel('radiance');legend('Below sun','Above sun')
    xlabel('El shifted - sun El');
    star.El_miss = miss;
    star.El_true(star.Str==2) = star.El_true(star.Str==2) - miss;
% %     figout = savefig(gcf,[figdir, fstem,'.ppl_shift.png'],true);
else
    title_str = {['Almucantar Scan: ',fstem] ; ...
        [datestr(star.time(1),'mmm dd, yyyy HH:MM UTC'),'. Altitude=',sprintf('%3.0f m',mean(star.Alt)), ...
        ', SZA=',sprintf('%2.0f deg',mean(star.sza))]};
    % Identify legs, then compute miss for each leg independently using
    % near sun sky scan measurements similar to PPL.
    % consider this carefully in light of PPL azimuth adjustments
    %%
    legx =  find([0;(abs(diff(star.Az_deg)) > 100)],1,'first');
    if isempty(legx)
        legx = length(star.Az_deg);
    end
    leg_A = false(size(star.time));
    leg_B = leg_A;
    leg_A(1:(legx-1)) = true; leg_A = leg_A & star.Headng~=0;
    leg_B(legx:end) = true; leg_B = leg_B &star.Headng~=0;
    
    before = ((abs(star.Zn)==4)|(abs(star.Zn)==3))&leg_A&(star.Az_true<star.sunaz);
    after = ((abs(star.Zn)==4)|(abs(star.Zn)==3))&leg_A&(star.Az_true>star.sunaz);
    
    lowest_top = min([max(star.skyrad(before,star.aeronetcols(vis_pix(end)))),...
        max(star.skyrad(after,star.aeronetcols(vis_pix(end))))]);
    highest_bot = max([min(star.skyrad(before,star.aeronetcols(vis_pix(end)))),...
        min(star.skyrad(after,star.aeronetcols(vis_pix(end))))]);
%     overlap =(lowest_top+highest_bot)./2;
%     rad_b4 = star.skyrad(before,star.aeronetcols(vis_pix(end)));
%     az_b4  = star.Az_true(before)-star.sunaz(before);
%     az_b4 = az_b4(~isNaN(rad_b4));
%     rad_b4 = rad_b4(~isNaN(rad_b4));
%     [rad_b4, ij] = unique(rad_b4);
%     az_b4 = az_b4(ij);
%     
%     
%     rad_f2 = star.skyrad(after,star.aeronetcols(vis_pix(end)));
%     az_f2  = star.Az_true(after)-star.sunaz(after);
%     az_f2 = az_f2(~isNaN(rad_f2));
%     rad_f2 = rad_f2(~isNaN(rad_f2));
%     [rad_f2, ij] = unique(rad_f2);
%     az_f2 = az_f2(ij);
%     %%
%     if (length(rad_b4)>1)&&(length(rad_f2)>1)
%         below = interp1(rad_b4,az_b4,overlap,'pchip','extrap');
%         above = interp1(rad_f2,az_f2 ,overlap,'pchip','extrap');
%         miss = (above+below)./2;
%     else
%         miss = 0;
%     end
%     star.Az_miss_legA = miss;
%     star.Az_true(leg_A&star.Str==2) = star.Az_true(leg_A&star.Str==2) - star.Az_miss_legA;
    figure;    
    subplot(2,1,1);
    plot(star.Az_true(((abs(star.Zn)==4)|(abs(star.Zn)==3))&leg_A)...
        -star.sunaz(((abs(star.Zn)==4)|(abs(star.Zn)==3))&leg_A), ...
        star.skyrad(((abs(star.Zn)==4)|(abs(star.Zn)==3))&leg_A,star.aeronetcols(vis_pix(end))),'.',...
        star.Az_true(before)-star.sunaz(before), ...
        star.skyrad(before,star.aeronetcols(vis_pix(end))),'o',...
        star.Az_true(after)-star.sunaz(after), ...
        star.skyrad(after,star.aeronetcols(vis_pix(end))),'x');
title(fstem,'interp','none');
    subplot(2,1,2);
    plot(    abs(star.Az_true(before)-star.sunaz(before)), ...
        star.skyrad(before,star.aeronetcols(vis_pix(end))),'-o',...
        abs(star.Az_true(after)-star.sunaz(after)), ...
        star.skyrad(after,star.aeronetcols(vis_pix(end))),'-x');
    title(['Near-sun ALM Leg A sky zone']);
    ylabel('radiance');
    xlabel('Az - sun Az');
%     saveas(gcf,[figdir, fstem,'.alm_legA_shift.png']);
%     %%
% 
    before = ((abs(star.Zn)==4)|(abs(star.Zn)==3))&leg_B&(star.Az_true<star.sunaz);
    after = ((abs(star.Zn)==4)|(abs(star.Zn)==3))&leg_B&(star.Az_true>star.sunaz);
    
    lowest_top = min([max(star.skyrad(before,star.aeronetcols(vis_pix(end)))),...
        max(star.skyrad(after,star.aeronetcols(vis_pix(end))))]);
    highest_bot = max([min(star.skyrad(before,star.aeronetcols(vis_pix(end)))),...
        min(star.skyrad(after,star.aeronetcols(vis_pix(end))))]);
%     overlap =(lowest_top+highest_bot)./2;
%     rad_b4 = star.skyrad(before,star.aeronetcols(vis_pix(end)));
%     az_b4  = star.Az_true(before)-star.sunaz(before);
%     az_b4 = az_b4(~isNaN(rad_b4));
%     rad_b4 = rad_b4(~isNaN(rad_b4));
%         [rad_b4, ij] = unique(rad_b4);
%     az_b4 = az_b4(ij);
%     
%     rad_f2 = star.skyrad(after,star.aeronetcols(vis_pix(end)));
%     az_f2  = star.Az_true(after)-star.sunaz(after);
%     az_f2 = az_f2(~isNaN(rad_f2));
%     rad_f2 = rad_f2(~isNaN(rad_f2));
%     [rad_f2, ij] = unique(rad_f2);
%     az_f2 = az_f2(ij);
%     
%     if (length(rad_b4)>1)&&(length(rad_f2)>1)
%         below = interp1(rad_b4,az_b4,overlap,'pchip','extrap');
%     above = interp1(rad_f2,az_f2 ,overlap,'pchip','extrap');
%     miss = (above+below)./2;
%     else
%         miss = 0;
%     end
%     star.Az_miss_legB = miss;
%     star.Az_true(leg_B&star.Str==2) = star.Az_true(leg_B&star.Str==2) - star.Az_miss_legB;
        figure;
    subplot(2,1,1);
    plot(star.Az_true(before|after)...
        -star.sunaz(before|after), ...
        star.skyrad(before|after,star.aeronetcols(vis_pix(end))),'.',...
        star.Az_true(before)-star.sunaz(before), ...
        star.skyrad(before,star.aeronetcols(vis_pix(end))),'o',...
        star.Az_true(after)-star.sunaz(after), ...
        star.skyrad(after,star.aeronetcols(vis_pix(end))),'x');
    title(fstem,'interp','none');
    subplot(2,1,2);
    plot(    abs(star.Az_true(before)-star.sunaz(before)), ...
        star.skyrad(before,star.aeronetcols(vis_pix(end))),'-o',...
        abs(star.Az_true(after)-star.sunaz(after)), ...
        star.skyrad(after,star.aeronetcols(vis_pix(end))),'-x');
    title(['Near-sun ALM leg B ']);
    ylabel('radiance');
    xlabel('Az - sun Az','interp','none');
%     saveas(gcf,[figdir, fstem,'.alm_legB_shift.png']);    
%     % If both miss legA and miss legB ==0, don't shift either leg.
%     % If only one is zero, shift that leg to match the other. 
%     % If both are non-zero, then shift compute the shift for both
%     % overlapping portions and take the average.
%     % But for now, we'll just move on...
%     
%     %%
%        
end


% star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_true), star.Az_true);

% star.SA = scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_true), star.Az_true);
% if star.isPPL
% %     star.SA(star.El_true<star.sunel) = -1.*star.SA(star.El_true<star.sunel);
%     legx =  find([0;abs(diff(star.El_deg)) > 100],1,'first');
% else
% %     star.SA(star.Az_true<star.sunaz) = -1.*star.SA(star.Az_true<star.sunaz);
%     legx =  find([0;(abs(diff(star.Az_deg)) > 100)],1,'first');
% end
% leg_A = false(size(star.time));
% leg_A(1:(legx-1)) = true;
% leg_B = ~leg_A;
%%
figure;
subplot(2,1,1); plot([1:length(star.time)], star.Az_true-star.sunaz,'.',[1:length(star.time)], star.SA./cos(star.sunel.*pi./180),'o');
title({[fstem];['Top plot agrees for ALM']},'interp','none');
legend('Az-SAZ','SA*cos(sunel)','location','northwest')
subplot(2,1,2); plot([1:length(star.time)], star.El_true-star.sunel,'.',[1:length(star.time)], star.SA,'o');
title('Bottom plot agrees for PPL but diverges after zenith.')
legend('El-sunel','SA','location','northwest')
xlabel('record number');

figure; plot(star.SA(star.Str==2&star.SA>0), ...
    star.visTint(star.Str==2&star.SA>0),'-o');
title({[fstem];['Scattering angle vs Vis Tint(ms)']},'interp','none');
xlabel('Scattering angle');
ylabel('Vis Tint [ms]');

% Would like to distinguish the portion of the PPL below the sun EL
% from the rest, and would also like to distinguish the half-ALM acquired on one side
% of the sun from the half-scan acquired on the opposite semicircle.
% Also, our ALMs are measured starting a few degrees to one side of the
% sun past the solar disk, and then out to 180 deg.  The symmetry of
% the near-sun signal for a given azimuthal scan direction could be
% used to infer a more accurate azimuthal offset for each leg.
%

if star.isPPL
good_ppl =  star.Str==2&star.El_true>0   ;
good_ppl(star.Str==2&star.El_true>0) = sky_angstrom_screen(star.w(star.aeronetcols(vis_pix)), ...
    star.SA(star.Str==2&star.El_true>0),...   
    star.skyrad(star.Str==2&star.El_true>0,star.aeronetcols(vis_pix)));
star.good_ppl = good_ppl;
    %%
    if ~exist('fog','var')
        fog = figure;
    else
        figure(fog);
    end
    semilogy(star.SA(star.Str==2&star.El_true>0&good_ppl), ...
        star.skyrad(star.Str==2&star.El_true>0&good_ppl,star.aeronetcols(vis_pix)),'-o');
    title({[fstem];['PPL plot']},'interp','none');
hold('on');
plot(star.SA(star.Str==2&star.El_true>0&(star.sat_time|~good_ppl)), ...
    star.skyrad(star.Str==2&star.El_true>0&(star.sat_time|~good_ppl),star.aeronetcols(vis_pix)), 'ro','markerface','k' );
   hold('off')
    xlabel('scattering angle [degrees]');
    ylabel('mW/(m^2 sr nm)');
    title(title_str,'interp','none')
    grid('on');
    set(gca,'Yminorgrid','off');
    
    
    leg_str{1} = sprintf('%2.0f nm',star.w(star.aeronetcols(vis_pix(1)))*1000);
    for ss = 2:length(star.aeronetcols(vis_pix))
        leg_str{ss} = sprintf('%2.0f nm',star.w(star.aeronetcols(vis_pix(ss)))*1000);
    end
    legend(leg_str,'location','eastoutside');
    
    xlim([0,85+star.sza(1)-max(abs(star.pitch))-max(abs(star.roll))])
else
    %%
    good_almA = (star.Str==2&leg_A);
    good_almA(good_almA) = sky_angstrom_screen(star.w(star.aeronetcols(vis_pix)), ...
    star.SA(good_almA),star.skyrad(good_almA,star.aeronetcols(vis_pix)));
    good_almB = (star.Str==2&leg_B);
    good_almB(good_almB) = sky_angstrom_screen(star.w(star.aeronetcols(vis_pix)), ...
    star.SA(good_almB),star.skyrad(good_almB,star.aeronetcols(vis_pix)));
    star.good_alm = good_almA|good_almB;
    star.good_almA = good_almA;
    star.good_almB = good_almB;

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
    leg_str{1} = sprintf('%2.0f nm',star.w(star.aeronetcols(1))*1000);
    for ss = 2:length(star.aeronetcols(vis_pix))
        leg_str{ss} = sprintf('%2.0f nm',star.w(star.aeronetcols(ss))*1000);
    end
    legend(leg_str,'location','northeast');
    hold('on')
    semilogy(abs(star.SA(good_almB)), ...
        star.skyrad(good_almB,star.aeronetcols(vis_pix)),'k-');
semilogy(star.SA(good_almB&star.sat_time), star.skyrad(good_almB&star.sat_time,star.aeronetcols(vis_pix)), 'ro','markerface','k' );
   hold('off')
    xlim([0,85+star.sza(1)-max(abs(star.pitch))-max(abs(star.roll))]);
%%    
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
