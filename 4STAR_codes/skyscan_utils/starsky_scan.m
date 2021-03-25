function star = starsky_scan(star)
% star = starsky_scan(star); This routine is called from "starsky"
% Generate sky scans from starsky struct.
%  In the case of ALM scans the CW and CCW branches of ALM are assessed.
% Offsets are determined for the pos and neg portions of the CW branch, and
% for the CW neg relative to the CCW pos (main portions), and adjusted to
% whichever is least. If offsets are too high, or too few valid points were
% available due to saturation then the sky is deemed "suspect".
%
% This routine applies shifts/corrections to star.SA inferred from symmetry
% between above/below portions of PPL or CW and CCW of ALM scans
% The resulting corrected values are in star.SA
% For PPL, star.El_gnd is also corrected but star.Az_gnd is not similarly
% shifted for ALM scans

% 2018-06-02: v0.1 Connor Added test to require SA > SA_min = 3.5 and El_gnd > El_min = 6, airmass < ~10
% 2020-11-23: v1.1 Connor added rfit_aod_basis to be evaluated are replacement for polyfit to tau_aero_subtract_all lines 110-
% This is looking pretty acceptable but still requires testing with data
% from each field campaign
% 2021-02-04: v1.2 Connor introducing tau_xfit that combines polyfit, afit,
% and xfit to provide the best-fit that minimizes RMS. Fully supplants
% rfit_aod_basis which is deprecated.
% 2021-03-19: v1.3, Connor, testing polyfit as well as  a-fit (aod basis), 
% and xfit (aod basis with outlier rejection and capture). Also provides RMS
% for each fit type and independent results to facilitate residuals
version_set('1.3');
% minimum acceptable scattering angle. Aeronet 3.5, airborne maybe 4?
if isfield(star.toggle,'sky_SA_min')
    SA_min = star.toggle.sky_SA_min;
else
    SA_min = 3.5;
end
% minimum acceptable elevation angle, equiv to airmass about 10
if isfield(star.toggle,'sky_El_min')
    El_min = star.toggle.sky_El_min;
else
    El_min = 6; %  ~= airmass<10
end
[pname,fstem,~] = fileparts(strrep(star.filename{1},'\',filesep));
pname = [pname, filesep];
fstem = strrep(fstem, '_VIS',''); star.fstem = fstem;
paths = set_starpaths; imgdir = paths.starimg; pptdir = paths.starppt;
if ~isadir([imgdir,star.fstem]);
    mkdir(imgdir, star.fstem);
end
skyimgdir = [imgdir, star.fstem, filesep];
star.pptname = [pptdir, star.fstem, '.ppt'];
created_str = ['.created', datestr(now, '_yyyymmdd_HHMMSS.')];
star.created_str = created_str;
star.pptname = ppt_add_title(star.pptname, [star.fstem, ': ', star.created_str]);

% fstem = strrep(star.out,'_STARSKY','_SKY')
if ~isempty(findstr(upper(fstem),'SKYP'))
    star.isPPL = true;
    star.isALM = false;
elseif ~isempty(findstr(upper(fstem),'SKYA'))
    star.isPPL = false;
    star.isALM = true;
else
    star.isPPL = false;
    star.isALM = false;
end
if ~isfield(star,'instrumentname')
    star.instrumentname = [];
end
star.time = star.t;
% picking very low "ground level" sufficient for sea level or AMF ground level.

star.flight_level = mean(star.Alt);
% warning('decide between Alt and Alt_pressure')
%  Attempted resolution of Alt and Alt_pressure by Connor in starwrapper on
%  Feb 6, 2021 using an interpolated scaled value from Alt_pressure to fill
%  telemetry glitches in Alt
vis_pix = find(star.aeronetcols);
recs = (1:length(star.time))';
[pp,qq] = size(star.rate);
sun_ = star.Zn==0&star.Str==1; suns_ii = find(sun_);
sun_ii = suns_ii(1);
zone = ((abs(star.Zn)==5)|(abs(star.Zn)==4)|(abs(star.Zn)==3))&(star.Str==2);
wl_ii = star.aeronetcols; rain = length(wl_ii)>6; %'rain' for 'rainbow' map used when wl_ii gets large

if ~isfield(star,'PWV')
    if isfield(star,'cwv')&&isfield(star.cwv, 'cwv940m2')
        star.PWV = star.cwv.cwv940m2(sun_ii);
    end
end
% if ~isfield(star,'gas')
if isfield(star,'gas')&&isfield(star.gas,'o3')&&isfield(star.gas.o3, 'o3DU');
    star.O3col = star.gas.o3.o3DU(sun_ii);
end
if star.O3col>8
    star.O3col = star.O3col./1000;
end
% end
%% This section to test impact of different selection of wavelengths to compute
% Check this logic carefully in light of afit and xfit implementations and
% implications regarding tau_aero and tau_aero_subtract_all.
% Not sure whether w_ii and last_wl have any utility anymore
% w_ii = wl_isubset_for_polyfit; % w_ii = [225,wl_isubset_for_polyfit];
% w_ii(wl(w_ii)>1.1) = [];w_ii(wl(w_ii)>.9) = [];
% if isfield(star.toggle,'use_last_wl')&&star.toggle.use_last_wl
%     [last_wl.wl_, last_wl.wl_ii, last_wl.sky_wl,last_wl.w_fit_ii] = get_last_wl(star);
%     wll_ = last_wl.wl_; wll_ii = last_wl.wl_ii; wl_isubset_for_polyfit= last_wl.w_fit_ii;
%     star.aeronetcols = wll_ii;
%     w_ii = wl_isubset_for_polyfit;
% end
block = load(getfullname([star.instrumentname,'_wl_block.mat'],'block','Select block file indicating contiguous pixels.'));
if isfield(block,'block') block = block.block; end;
if isfield(block,'blocks') block = block.blocks; end;
wl_ = false(size(star.w));
for b = 1:size(block,1)
    wl_(block(b,3):block(b,4)) = true;
end
w_ii = find(wl_);
wl = 1000.*star.w;
lte0 = star.tau_aero_subtract_all(sun_ii,w_ii)<=0;  w_ii(lte0) = [];
% This reproduces some of starwrapper ~717 in order to reduce file size by
% not retaining an alternate version tau_noray_vert
tau_noray_vert = star.tau_tot_vert -star.tau_ray;
% star.tau_tot_vert(sun_ii,lte0) = tau_noray_vert(sun_ii,lte0) + star.tau_ray(sun_ii,lte0);
% [aod, min_rms, fit_rms, m_ij, aod_pfit, aod_afit, aod_xfit]
wl_block = load(getfullname([star.instrumentname,'_wl_block.mat'],'block'));
    if isfield(block,'block') block = block.block; end;
    if isfield(block,'blocks') block = block.blocks; end;    
[aod_fit, min_rms, fit_rms, m_ij, aod_xfit, aod_afit, aod_pfit, w_ii_out] = ...
    tau_xfit(wl,star.tau_aero_subtract_all(sun_ii,:),wl_block);

% Now evaluate projecting get_wvl_subset for polyfit into block
% w_pii: "w" for wavelength, "p" for polyfit, "ii" for index
w_pii = get_wvl_subset(star.t(1),star.instrumentname);
% w_pii(wl(w_pii)<400) = [];
% w_pii(wl(w_pii)>900) = [];
w_pii(wl(w_pii)>1100) = []; 

w_pii_ = false(size(wl)); w_pii_(w_pii) = true; 
w_pii_(1:end-1) = w_pii_(1:end-1)| w_pii_(2:end);
w_pii_(end) = w_pii_(end)|w_pii_(end-1); 
w_pii = find(w_pii_); w_pii_block = return_wl_block(w_pii, wl);
[star.aod_fit_pii, star.min_rms_pii, star.fit_rms_pii, m_ij_pii, star.aod_xfit_pii, aod_afit_pii, star.aod_pfit_pii, w_ii_out_pii] = ...
    tau_xfit(wl,star.tau_aero_subtract_all(sun_ii,:),w_pii_block);

%% Interestingly, the fits using a truncated range from get_wvl_subset yields 
% lower residuals than the fits using the wavelengths in wv_block.mat
% Thus, we'll carry the _pii fields and residuals forward.
tau_abs_gas = tau_noray_vert(sun_ii,:) - star.tau_aero_subtract_all(sun_ii,:);
tau_abs_gas_fit = tau_noray_vert(sun_ii,:) - star.aod_fit_pii;
tau_abs_gas_xfit = tau_noray_vert(sun_ii,:) - star.aod_xfit_pii;
tau_abs_gas_pfit = tau_noray_vert(sun_ii,:) - star.aod_pfit_pii;
% tau_abs_gas_pfit = tau_noray_vert(sun_ii,:) - aod_pfit_pii;
star.tau_xfit_res = star.tau_aero_subtract_all(sun_ii,:) - star.aod_fit_pii;
star.tau_pfit_res = star.tau_aero_subtract_all(sun_ii,:) - star.aod_pfit_pii;

star.AOD = star.aod_fit_pii; % aod_fit_pii looks better than aod_fit
star.AGOD = tau_abs_gas_fit;
% If inferred absorbing gas is negative, instead define it as zero, and
% compute new tau_vert_tot as the tau_ray + fitted tau_aero_subtract
w_fin_i = find(wl>415 & wl<435);
[~, fin_max_ii] = max(abs(tau_abs_gas_fit(w_fin_i))); 
fin_max = tau_abs_gas_fit(w_fin_i(fin_max_ii));
lte0 = star.AGOD<=0;
star.AGOD(lte0) = 0;
star.TOD = star.AGOD + aod_fit + star.tau_ray(sun_ii,:);
% 2021-02-04 I think figured out to here...

ii = [200:1044 1070:1550];

figure_(3001);
sx(1) = subplot(2,1,1);
% I think this is just for visualization purposes
tau_line = aod_fit(star.aeronetcols);
nix = single(tau_noray_vert(sun_ii,ii)<=0); nix(nix==1)= NaN;
nox = single(star.tau_aero_subtract_all(sun_ii,ii)<=0); nox(nox==1)= NaN;
plot(wl(ii), nix+tau_noray_vert(sun_ii,ii),'-', ...
    wl(ii), nox+star.tau_aero_subtract_all(sun_ii,ii),'-', ...
    wl(ii), star.aod_pfit_pii(ii), 'k-',wl(ii), star.aod_xfit_pii(ii), 'r-', ...
    wl(w_pii), star.aod_fit_pii(w_pii), 'o',......
    wl(star.aeronetcols),star.aod_fit_pii(star.aeronetcols), 'o'); 
logx; 
logy;clear nix nox
ylabel('optical depth');
yl = ylim;
ylim([min(tau_line).*.25, 2]);
lg = legend('tau noray vert', ...
    'tau aero subtract all',sprintf('pfit RMS=%1.1e',star.fit_rms_pii(3)),...
    sprintf('xfit RMS=%1.1e',star.fit_rms_pii(1)),'fit pixels', 'retrieval pixels');
set(lg,'interp','none');
created = star.created_str(10:end-1);
tl = title({[star.fstem, ' ',created];...
[datestr(star.t(sun_ii),'yyyy-mm-dd HH:MM:SS UTC'), ' ',sprintf(', SunEl=%1.1f',star.sunel(sun_ii)), sprintf(', airmass=%1.2f',star.m_aero(sun_ii))]}, 'interp','none');
sx(2) = subplot(2,1,2);
plot(wl(ii), star.AGOD(ii),'-',wl(ii), tau_abs_gas(ii),'-',wl(ii), tau_abs_gas_pfit(ii),'-k',...
    wl(star.aeronetcols), tau_abs_gas_fit(star.aeronetcols),'*',...
    wl(star.aeronetcols), tau_abs_gas(star.aeronetcols),'ro'...
    ); logx;
xlabel('wavelength [um]');
ylabel('Gas OD'); ylim([-.02,.28])
lg = legend('AGOD (tot-aod_xfit)','tot - tau_aero_subtract_all','(tot-aod_pfit)','AGOD fit pixels','tau noray - aero'); set(lg,'interp','none', 'location','northwest')
title({sprintf('Lat=%2.4f, Lon=%2.4f, Alt=%1.0f m, Az=%1.0f deg',star.Lat(sun_ii), ...
    star.Lon(sun_ii), star.Alt(sun_ii), acosd(cosd(star.Az_deg(sun_ii))));sprintf('Fin = %0.3f',fin_max)});

linkaxes(sx,'x');
xlim([wl(225), wl(1550)]);
%%
if all(isNaN(star.AGOD(200:1044)))||...
        all(isNaN(star.AGOD(star.aeronetcols)))
    disp('Problem with gas absorption?')
    warning('Problem with gas absorption?');
    pause(2)
end

fig_out = [skyimgdir, star.fstem,star.created_str,'AOD_AGOD_biplot'];
saveas(gcf,[fig_out,'.fig']);
saveas(gcf,[fig_out,'.png']);
ppt_add_slide(star.pptname, fig_out);



% Now, check agreement between any sun meausurements and Az_gnd and El_gnd
% Apply offsets, then compute initial SA.


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

SA = double(scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_gnd), star.Az_gnd));
rec = [1:length(star.t)];


figure_(3002); sx(1) = subplot(3,1,1);
plot(rec, star.Headng-star.Headng(1),'x',rec, star.pitch,'o',...
    rec, star.roll,'x', rec, star.Alt - star.Alt(1),'s');legend('Heading','pitch','roll','alt')
tl = title(fstem); set(tl,'interp','none');
sx(2) = subplot(3,1,2);
plot(rec, SA, 'o', rec, mod(star.Az_gnd-star.Az_gnd(1)+90,180)-90, 'x',rec, star.El_gnd-star.El_gnd(1),'*');
legend('SA','Az','El')
sx(3) = subplot(3,1,3);
if ~rain
    plot(rec, star.skyrad(:,star.aeronetcols),'x-');ylabel('sky rad');
else
    pl = plot(rec, star.skyrad(:,star.aeronetcols),'-');ylabel('sky rad')
    recolor(pl,1000.*wl(wl_ii)); colorbar('east');
end
xlabel('record number')
linkaxes(sx, 'x');

fig_out = [skyimgdir, star.fstem,star.created_str,'telemetry_triplot'];
saveas(gcf,[fig_out,'.fig']);
saveas(gcf,[fig_out,'.png']);
ppt_add_slide(star.pptname, fig_out);

heading = star.Headng; heading(heading<180) = heading(heading<180)+360;
d_head = max(heading)-min(heading); d_roll = max(star.roll)-min(star.roll);
d_pitch = max(star.pitch)-min(star.pitch);
d_Alt = max(star.Alt) - min(star.Alt);
straight_level = d_head<5 & d_roll<2 & d_pitch < 1 & d_Alt <100;
if ~straight_level
    warning('Flight not straight and level for this sky scan!')
end

% star.isPPL = std(star.El_deg)>std(mod(star.Az_deg+180,360));
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
% figure;
% z= 0;
% %%
% z = z+1;
% tints_vis = unique(star.visTint(star.Zn==zones(z)));
% tints_nir = unique(star.nirTint(star.Zn==zones(z)));
%
% plot([wl], [star.skyrad(star.Zn==zones(z),:)],'.-');
% title({fstem; [' Zone = ',num2str(zones(z)), sprintf(',  vis tints=%3.0d, ',tints_vis), ...
%     sprintf('  nir tints=%3.0d ',tints_nir)]},'interp','none')
% if z > length(zones)
%     z = 0;
% end
%
% %

%% PPL Section
if star.isPPL
    star.QA_PPL = 0; star.QA_above = 0; star.QA_below = 0;
    title_str = {['PPL: ',fstem] ; ...
        [ 'Lat=',sprintf('%3.4f, ',mean(star.Lat)),'Lon=',sprintf('%3.4f, ',...
        mean(star.Lon)),'Alt=',sprintf('%3.0f m, ',mean(star.Alt)),'SEL=',sprintf('%2.1f deg',90-mean(star.sza))];...
        ['Time: ', datestr(star.time(1),'yyyy-mm-dd HH:MM'),'-',datestr(star.time(end),'HH:MM UTC')] };
    sat = star.sat_ij(:,star.aeronetcols(end-1));
    below_orb = (star.El_gnd < star.sunel)& (abs(star.Az_gnd-star.sunaz)<5);
    above_orb = (star.El_gnd > star.sunel)|...
        ((star.El_gnd < star.sunel)&(abs(star.Az_gnd-star.sunaz-180)<5));
    
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
    
    if (length(rad_b4)>1)&&(length(rad_f2)>1)
        below = interp1(rad_b4,el_b4,overlap,'pchip','extrap');
        above = interp1(rad_f2, el_f2,overlap,'pchip','extrap');
        SA_below = interp1(rad_b4, SA_b4, rad_near, 'pchip');
        SA_above = interp1(rad_f2, SA_f2, rad_near,'pchip');
        dSA = (SA_above - SA_below)./2;
        miss = (above+below)./2;
        dSA = mean(dSA);
        
        if abs(miss)>3 || abs(mean(dSA))>3
            star.QA_PPL = 1;
        end
        star.El_miss = miss;
        star.El_gnd(star.Str==2) = star.El_gnd(star.Str==2) - star.El_miss;
        %The fixes star.SA for ppl scans
        star.SA = double(scat_ang_degs(star.sza, star.sunaz, 90-abs(star.El_gnd), star.Az_gnd));
        star.above_orb = above_orb;
        star.below_orb = below_orb;
        
        figure_(3003);
        plot(abs(star.El_gnd(zone&below_orb)...
            -star.sunel(zone&below_orb)), ...
            star.skyrad(zone&below_orb,star.aeronetcols(vis_pix(end))),'o',...
            abs(star.El_gnd(zone&above_orb)...
            -star.sunel(zone&above_orb)), ...
            star.skyrad(zone&above_orb,star.aeronetcols(vis_pix(end))),'x');
        title(['Near-sun sky zone shifted by ',sprintf('%2.2f deg',miss)]);
        ylabel('radiance');legend('Below sun','Above sun')
        xlabel('El shifted - sun El');
        
        fig_out = [skyimgdir, star.fstem, star.created_str, 'el_shift'];
        saveas(gcf, [fig_out, '.fig']);
        saveas(gcf, [fig_out, '.png']);
        ppt_add_slide(star.pptname, fig_out);
        pause(.1)
        
        figure_(3004);
        plot(star.SA(zone&below_orb),star.skyrad(zone&below_orb,star.aeronetcols(vis_pix(end))),'o',...
            star.SA(zone&above_orb), star.skyrad(zone&above_orb,star.aeronetcols(vis_pix(end))),'x');
        title(['Near-sun sky zone shifted by ',sprintf('%2.2f deg',mean(dSA))]);
        ylabel('radiance');legend('Below sun','Above sun')
        xlabel('SA shifted');
        
        fig_out = [skyimgdir, star.fstem,star.created_str,'sa_shift'];
        saveas(gcf,[fig_out,'.fig']);
        saveas(gcf,[fig_out,'.png']);
        ppt_add_slide(star.pptname, fig_out);
        
        good_ppl =  star.Str==2&star.El_gnd>El_min &star.SA>SA_min;
        %         sky_angstrom_screen(wl(star.aeronetcols(vis_pix)), ...
        %             star.SA(good_ppl),...
        %             star.skyrad(good_ppl,star.aeronetcols(vis_pix)));        star.good_ppl = good_ppl;
    else
        miss = NaN;
        dSA = NaN;
        star.QA_PPL = 1;
        if length(rad_b4)<2||any(isnan(rad_b4))
            star.QA_below = 1;
            good_ppl = star.Str==2&star.El_gnd>El_min &SA>SA_min & above_orb & ~sat ;
        end
        if length(rad_f2)<2||any(isnan(rad_f2))
            star.QA_above = 1;
            good_ppl = star.Str==2&star.El_gnd>El_min &SA>SA_min & rad_b4 & below_orb & ~sat ;
        end
        star.SA = SA;
    end
    star.good_ppl = good_ppl;
else
    %% ALM section
    star.QA_CCW = 0;
    star.QA_CW = 0;
    star.QA_CW_CCW = 0;
    title_str = {['Almucantar scan: ',fstem]; ...
        [ 'Lat=',sprintf('%3.4f, ',mean(star.Lat)),'Lon=',sprintf('%3.4f, ',...
        mean(star.Lon)),'Alt=',sprintf('%3.0f m, ',mean(star.Alt)),'SEL=',sprintf('%2.1f deg',90-mean(star.sza))];...
        ['Time: ', datestr(star.time(1),'yyyy-mm-dd HH:MM'),'-',datestr(star.time(end),'HH:MM UTC')] };
    % Identify legs, then compute miss for each leg independently using
    % near sun sky scan measurements similar to PPL.
    % By quirk of 4STAR naming convention, 4STAR "positive" zones are for zone with ZA < SZA, which is a CCW rotation.
    % The CCW branch is executed first, followed by the CW branch, so we might
    % expect the CCW branch to be more robust and less susceptible to
    % unexpected aircraft motion
    
    ccw_p_i= find(star.Zn<0&star.Str==2,1,'first');  % Start of CCW leg is with ZA>SZA,
    ccw_p_j = ccw_p_i + find(star.Zn(ccw_p_i+1:end)>0|star.Str(ccw_p_i+1:end)~=2,1,'first')-1;
    ccw_n_i = find(star.Zn>0&star.Str==2,1,'first');  % Positize zones are negative SA, ZA < SZA
    ccw_n_j = ccw_n_i+find(star.Zn(ccw_n_i+1:end)==0,1,'first')-1;
    % If ccw_n_j is empty then the scan aborted without returning to sun
    % after CCW portion.
    if isempty(ccw_n_j); ccw_n_j = ccw_n_i+find(star.Zn(ccw_n_i+1:end)>1,1,'last');end
    midsun = ccw_n_j+find(star.Zn(ccw_n_j+1:end)==0,1,'first'); %middle position returning to sun between CCW and CW legs
    ccw_last = ccw_n_j; if isempty(ccw_last); ccw_last = ccw_n_i+find(star.Zn(ccw_n_i+1:end)>1,1,'last');end
    ccw = [ccw_p_i:ccw_p_j ccw_n_i:ccw_last];
    
    cw_n_i = midsun + find(star.Zn(midsun+1:end)~=1, 1,'first'); % Postive zones are negative SA
    cw_n_j = cw_n_i + find(star.Str(cw_n_i+1:end)~=2,1,'first')-1;
    cw_p_i = cw_n_j+find(star.Zn(cw_n_j+1:end)~=1&star.Str(cw_n_j+1:end)==2,1,'first');
    cw_p_j = cw_p_i + find(star.Zn(cw_p_i+1:end)~=0,1,'last');
    cw = [cw_n_i:cw_n_j cw_p_i:cw_p_j];
    
    CW = false(size(star.t)); CCW = CW; NEG = CW; POS = CW;
    CW(cw) = true;
    CCW(ccw) = true;
    NEG([cw_n_i:cw_n_j ccw_n_i:ccw_n_j]) = true;
    POS([cw_p_i:cw_p_j, ccw_p_i:ccw_p_j]) = true;
    
    sa = SA; sa(NEG) = -sa(NEG);
    
    figure_(3004);
    if rain
        pl =  plot(sa(CW&NEG), star.skyrad(CW&NEG,wl_ii),'-x');
        recolor(pl,1000.*wl(wl_ii));colorbar
        hold('on'); plot(sa(CCW&POS), star.skyrad(CCW&POS,star.aeronetcols),'k-o');
        hold('off');
    else
        plot(sa(CW&NEG), star.skyrad(CW&NEG,star.aeronetcols),'-x',...
            sa(CCW&POS), star.skyrad(CCW&POS,star.aeronetcols),'k-o');
    end
    
    %First, assess CCW leg based on symmetry of POS and NEG portions
    SA_ = (SA<7)&((CCW&NEG)|(CCW&POS))&~star.sat_ij(:,star.aeronetcols(end-1));
    if ~rain
        plot(sa(SA_&CCW&NEG), star.skyrad(SA_&CCW&NEG,star.aeronetcols),'-x',...
            sa(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');
    else
        pl = plot(sa(SA_&CCW&NEG), star.skyrad(SA_&CCW&NEG,star.aeronetcols),'-x');
        recolor(pl,wl(wl_ii)); colorbar; hold('on');
        plot(sa(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');
        hold('off');
    end
    title('CCW leg, original')
    
    CCW_X = SA(SA_&CCW&POS); CCW_Y = star.skyrad(SA_&CCW&POS,star.aeronetcols(1));
    CCW_X(isnan(CCW_Y)) = []; CCW_Y(isnan(CCW_Y)) = [];
    CCW_neg_X = SA(SA_&CCW&NEG); CCW_neg_Y = star.skyrad(SA_&CCW&NEG,star.aeronetcols(1));
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
        star.SA_CCW_offset = mean(dX_CCW)./2;
        dAz = star.SA_CCW_offset./cosd(star.sunel(sun_ii));  %(SA_&CCW&NEG)
        if mean(abs(dX_CCW))<2
            SA(CCW&POS) = SA(CCW&POS)- star.SA_CCW_offset;
            SA(CCW&NEG) = SA(CCW&NEG) + star.SA_CCW_offset;
            star.Az_gnd(SA_&CCW)=star.Az_gnd(SA_&CCW);
            star.QA_CCW = 0; % 0 is good
            sa = SA; sa(NEG) = -SA(NEG);
            
            plot(SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols(1)),'k-o');hold('on');
            pl = plot(SA(SA_&CCW&NEG), star.skyrad(SA_&CCW&NEG,star.aeronetcols(1)),'-x');hold('off')
            %             if rain
            %                 plot(SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols(1)),'k-o');hold('on');
            %                 pl = plot(SA(SA_&CCW&NEG), star.skyrad(SA_&CCW&NEG,star.aeronetcols(1)),'-x');
            %                 recolor(pl,1000.*wl(wl_ii)); colorbar;hold('off')
            %             else
            %                 plot(SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols(1)),'k-o',...
            %                     SA(SA_&CCW&NEG), star.skyrad(SA_&CCW&NEG,star.aeronetcols(1)),'-x');
            %             end
            title(['CCW leg, shifted by ',sprintf('%2.1f deg',mean(dX_CCW)./2)])
        else
            warning('Offset for CCW branch > 2')
            star.QA_CCW = 1; % suspect
        end
        fig_out = [skyimgdir, star.fstem,star.created_str,'CCW_shift'];
        saveas(gcf,[fig_out,'.fig']);
        saveas(gcf,[fig_out,'.png']);
        ppt_add_slide(star.pptname, fig_out);
    else
        warning('Insufficient valid points to assess CCW branch')
        star.QA_CCW = 1;
        star.SA_CCW_offset = NaN;
        dX_CCW = NaN;
    end
    
    %Next, assess CW leg based on symmetry of POS and NEG portions
    SA_ = (SA<7)&((CW&NEG)|(CW&POS))&~star.sat_ij(:,star.aeronetcols(1));
    plot(sa(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols(1)),'k-o',...
        sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols(1)),'-x');
    
    %     if ~rain
    %         plot(sa(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols(1)),'k-o',...
    %             sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols(1)),'-x');
    %     else
    %         plot(sa(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols),'k-o');hold('on');
    %         pl = plot(sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x');
    %         recolor(pl,1000.*wl(wl_ii));colorbar;
    %         hold('off')
    %     end
    title('CW leg, original')
    CW_X = SA(SA_&CW&POS); CW_Y = star.skyrad(SA_&CW&POS,star.aeronetcols(1));
    CW_X(isnan(CW_Y)) = []; CW_Y(isnan(CW_Y)) = [];
    CW_neg_X = SA(SA_&CW&NEG); CW_neg_Y = star.skyrad(SA_&CW&NEG,star.aeronetcols(1));
    CW_neg_X(isnan(CW_neg_Y)) = []; CW_neg_Y(isnan(CW_neg_Y)) = [];
    min_max = min([max(CW_Y), max(CW_neg_Y)]);if isempty(min_max); min_max = NaN; end
    max_min = max([min(CW_Y), min(CW_neg_Y)]);if isempty(max_min); max_min = NaN; end
    Ys = unique([CW_Y; CW_neg_Y]); Ys(Ys<max_min) = [];Ys(Ys>min_max)=[];
    if isempty(Ys)
        Ys = [min_max, mean([min_max max_min]), max_min];Ys(isNaN(Ys)) = [];
    end
    
    if length(CW_Y)>1 && length(CW_neg_Y)>1  % then we have enough points to assess CW symmetry
        X_CW = interp1(CW_Y, CW_X, Ys,'pchip');
        [CW_neg_Y,IA]= unique(CW_neg_Y); CW_neg_X = CW_neg_X(IA);
        X_CW_neg = interp1(CW_neg_Y, CW_neg_X, Ys,'pchip');
        dX_CW = (X_CW-X_CW_neg);
        star.SA_CW_offset = mean(dX_CW)./2;
        dAz = star.SA_CW_offset./cosd(star.sunel(sun_ii));  %(SA_&CCW&NEG)
        if mean(abs(dX_CW))<2
            SA(CW&POS) = SA(CW&POS)-star.SA_CW_offset;
            SA(CW&NEG) = SA(CW&NEG) + star.SA_CW_offset;
            
            star.Az_gnd(SA_&CW)=star.Az_gnd(SA_&CW)-dAz;
            star.QA_CW = 0; % 0 is good
            sa = SA; sa(NEG) = -SA(NEG);
            plot(SA(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols(1)),'k-o',...
                SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols(1)),'-x');
            %
            %             if ~rain
            %                 plot(SA(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols),'k-o',...
            %                     SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x');
            %             else
            %                 plot(SA(SA_&CW&POS), star.skyrad(SA_&CW&POS,star.aeronetcols),'k-o');hold('on');
            %                 pl = plot(SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x');
            %                 recolor(pl,1000.*wl(wl_ii));colorbar; hold('off')
            %             end
            
            title(['CW leg, shifted by ',sprintf('%2.1f deg',mean(dX_CW)./2)])
        else
            warning('Offset for CW branch > 2')
            star.QA_CW = 1; % suspect
        end
        fig_out = [skyimgdir, star.fstem,star.created_str,'CW_shift'];
        saveas(gcf,[fig_out,'.fig']);
        saveas(gcf,[fig_out,'.png']);
        ppt_add_slide(star.pptname, fig_out);
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
        SA_ = (SA<7)&((CW&NEG)|(CCW&POS))&~star.sat_ij(:,star.aeronetcols(1));
        plot(sa(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols(1)),'k-o',...
            sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols(1)),'-x');
        %         if ~rain
        %             plot(sa(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o',...
        %                 sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x');
        %         else
        %             plot(sa(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');hold('on');
        %             pl = plot(sa(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x')
        %             recolor(pl,1000.*wl(wl_ii));colorbar; hold('off')
        %         end
        title('CW and CCW main branches, before final adjustment')
        CCW_X = SA(SA_&CCW&POS); CCW_Y = star.skyrad(SA_&CCW&POS,star.aeronetcols(1));
        CCW_X(isnan(CCW_Y)) = []; CCW_Y(isnan(CCW_Y)) = [];
        CW_neg_X = SA(SA_&CW&NEG); CW_neg_Y = star.skyrad(SA_&CW&NEG,star.aeronetcols(1));
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
            star.SA_CCW_CW_offset = mean(dX_CCW_CW)./2;
            dAz = star.SA_CCW_CW_offset./cosd(star.sunel(sun_ii));
            % The dAz shifts are tricky to get right in terms of sign and
            % even the factor of two.  I have tried to validate each of
            % these graphically but not 100% sure of 2nd and 3rd  below
            if mean(dX_CCW_CW)<5 && std(dX_CCW_CW)<1.5% Then we'll trust it and adjust one branch and mask out short side
                if (star.QA_CCW == 0) && (star.QA_CW == 1)
                    SA(CW&NEG) = SA(CW&NEG) + mean(dX_CCW_CW);
                    SA(CW&POS) = SA(CW&POS) - mean(dX_CCW_CW);
                    star.Az_gnd(CW)=star.Az_gnd(CW)-dAz;
                    star.skyrad(CW&POS,:) = NaN; %POS is short branch of CW leg, mask it out
                elseif (star.QA_CW == 0) && (star.QA_CCW == 1)
                    SA(CCW&NEG) = SA(CCW&NEG) + mean(dX_CCW_CW);
                    SA(CCW&POS) = SA(CCW&POS) - mean(dX_CCW_CW);
                    star.Az_gnd(CCW)=star.Az_gnd(CCW)-dAz.*2;
                    star.skyrad(CCW&NEG,:) = NaN; % NEG is short branch of CCW leg, mask it out
                else
                    SA(CW&NEG) = SA(CW&NEG) + mean(dX_CCW_CW)./2;
                    SA(CCW&POS) = SA(CCW&POS) - mean(dX_CCW_CW)./2;
                    star.Az_gnd(CW&NEG)=star.Az_gnd(CW&NEG)-dAz;
                    star.Az_gnd(CCW&POS)=star.Az_gnd(CCW&POS)-dAz;
                    star.skyrad(CCW&NEG,:) = NaN; % NEG is short branch of CCW leg, mask it out
                    star.skyrad(CW&POS,:) = NaN; %POS is short branch of CW leg, mask it out
                end
                plot(SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols(1)),'k-o',...
                    SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols(1)),'-x');
                %                 if ~rain
                %                     plot(SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o',...
                %                         SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x');
                %                 else
                %                     plot(SA(SA_&CCW&POS), star.skyrad(SA_&CCW&POS,star.aeronetcols),'k-o');hold('on');
                %                     pl = plot(SA(SA_&CW&NEG), star.skyrad(SA_&CW&NEG,star.aeronetcols),'-x');
                %                     recolor(pl,1000.*wl(wl_ii)); colorbar; hold('off');
                %
                %                     hold('off')
                %                 end
                title(['CW and CCW main branches, with final shift of ',sprintf('%2.1f',mean(dX_CCW_CW))])
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
    if ~rain
        
        subplot(2,1,1);
        these = plot(sa(CW), star.skyrad(CW,star.aeronetcols),'-'); recolor(these,[length(star.aeronetcols):-1:1]);
        for th=1:length(these)
            text(sa(CW), star.skyrad(CW,star.aeronetcols(th)),...
                repmat({'L'},size(star.skyrad(CW,star.aeronetcols(th)))),...
                'color',get(these(th),'color'));
        end
        hold('on');
        those= plot( sa(CCW), star.skyrad(CCW,star.aeronetcols),'-');recolor(those,length(star.aeronetcols):-1:1);
        for toe=1:length(those)
            text(sa(CCW), star.skyrad(CCW,star.aeronetcols(toe)),...
                repmat({'R'},size(star.skyrad(CCW,star.aeronetcols(toe)))),...
                'color',get(those(toe),'color'));
        end
        
        subplot(2,1,2);
        thats = plot(SA(CW), star.skyrad(CW,star.aeronetcols),'-kx',...
            SA(CCW), star.skyrad(CCW,star.aeronetcols),'-ko');
        recolor(thats,[length(star.aeronetcols):-1:1, length(star.aeronetcols):-1:1]);
    else
        subplot(2,1,1);
        these = plot(sa(CW), star.skyrad(CW,star.aeronetcols),'-'); recolor(these,1000.*wl(wl_ii));
        for th=1:length(these)
            text(sa(CW), star.skyrad(CW,star.aeronetcols(th)),...
                repmat({'L'},size(star.skyrad(CW,star.aeronetcols(th)))),...
                'color',get(these(th),'color'));
        end
        hold('on');
        those= plot( sa(CCW), star.skyrad(CCW,star.aeronetcols),'-');recolor(those,1000.*wl(wl_ii));
        for toe=1:length(those)
            text(sa(CCW), star.skyrad(CCW,star.aeronetcols(toe)),...
                repmat({'R'},size(star.skyrad(CCW,star.aeronetcols(toe)))),...
                'color',get(those(toe),'color'));
        end
        
        subplot(2,1,2);
        thats = plot(SA(CW), star.skyrad(CW,star.aeronetcols),'-kx',...
            SA(CCW), star.skyrad(CCW,star.aeronetcols),'-ko');
        recolor(thats,[wl(wl_ii),wl(wl_ii)]);
    end
    % At this point adjustments to SA based an symmetry of CW, CCW legs is
    % incorporeated into star.SA
    star.SA = SA;
    star.CW = CW; star.CCW = CCW;star.NEG = NEG; star.POS = POS;
    star.good_almA = CCW&(POS|NEG)&SA>=SA_min&star.El_gnd>El_min;
    star.good_almB = CW&(POS|NEG)&SA>=SA_min&star.El_gnd>El_min;
    % Now apply ALM symmetry test and flag failing values.
    [good_almA, good_almB] = alm_sym_test(star);
    %      sky_angstrom_screen(wl(star.aeronetcols(vis_pix)), ...
    %        star.SA(good_almA),star.skyrad(good_almA,star.aeronetcols(vis_pix)));
    star.good_almA = good_almA;
    %     sky_angstrom_screen(wl(star.aeronetcols(vis_pix)), ...
    %        star.SA(good_almB),star.skyrad(good_almB,star.aeronetcols(vis_pix)));
    star.good_almB = good_almB;
    good_alm = good_almA|good_almB;
    star.good_alm = good_alm;
end

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

star.good_sky(star.Str~=2) = false;
star.good_sky(star.SA<3) = false;
if isfield(star,'good_alm')
    star.good_alm = star.good_sky & star.good_alm;
end
if isfield(star,'good_almA')&&isfield(star,'good_alm')
    star.good_almA = star.good_almA & star.good_alm;
end
if isfield(star,'good_almB')&&isfield(star,'good_alm')
    star.good_almB = star.good_almB & star.good_alm;
end
star.skymask = NaN(size(star.skyrad));
star.skymask(star.good_sky,:) = 1;
%       good_sky =  star.good_alm;
%
% %       good_sky = sky_angstrom_screen(wl(wll_ii), ...
% %          star.SA(good_sky),...
% %          star.skyrad(good_sky,wll_ii));
% %       star.good_sky = good_sky;

% [star.anet_level, star.anet_tests] = anet_preproc_dl(star);
% title_str(1) = {[title_str{1}, sprintf(', lev=%1.1f',star.anet_level)]};
if star.isPPL
    
    %%
    if ~isavar('fog')
        fog = figure_(3007);
    else
        figure_(fog);
    end
    if ~rain
        semilogy(star.SA(star.Str==2&star.El_gnd>0&good_ppl), ...
            star.skyrad(star.Str==2&star.El_gnd>0&good_ppl,star.aeronetcols(vis_pix)),'-o');
    else
        pl = semilogy(star.SA(star.Str==2&star.El_gnd>0&good_ppl), ...
            star.skyrad(star.Str==2&star.El_gnd>0&good_ppl,star.aeronetcols(vis_pix)),'-o');
        recolor(pl,1000.*wl(wl_ii));
    end
    xlabel('scattering angle [degrees]');
    ylabel('mW/(m^2 sr nm)');
    title(title_str,'interp','none')
    grid('on');
    set(gca,'Yminorgrid','off');
    if ~rain
        leg_str{1} = sprintf('%2.0f nm (AOD=%2.2f)',wl(star.aeronetcols(vis_pix(1))), star.tau_aero_skyscan(1));
        for ss = 2:length(star.aeronetcols(vis_pix))
            leg_str{ss} = sprintf('%2.0f nm (AOD=%2.2f)',wl(star.aeronetcols(vis_pix(ss))),star.tau_aero_skyscan(ss));
        end
        legend(leg_str, 'location','northeast');
    else
        cb=colorbar; cbt=get(cb,'title'); set(cbt,'string','nm');
    end
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
        txt = text(.1, .95,QA_str, 'units','norm', 'color','red','linestyle','-','fontsize',14);
    end
    %    fig_out = [skyimgdir, star.fstem,star.created_str,'ppl'];
    % saveas(gcf,[fig_out,'.fig']);
    % saveas(gcf,[fig_out,'.png']);
    % ppt_add_slide(star.pptname, fig_out);
elseif star.isALM
    if ~isavar('fog')
        fog = figure_(3007);
    else
        figure_(fog);
    end
    semilogy(abs(star.SA(good_almB)), ...
        star.skyrad(good_almB,star.aeronetcols(vis_pix)),'k-'); hold('on')
    if ~rain
        semilogy(star.SA(good_almA), ...
            star.skyrad(good_almA,star.aeronetcols(vis_pix)),'-o');
    else
        pl=  semilogy(star.SA(good_almA), ...
            star.skyrad(good_almA,star.aeronetcols(vis_pix)),'-o');
        recolor(pl,1000.*wl(wl_ii)); cb =colorbar; cbt = get(cb,'title'); set(cbt,'string','nm');
    end
    xlabel('scattering angle [degrees]');
    ylabel('mW/(m^2 sr nm)');
    title(title_str,'interp','none')
    grid('on'); set(gca,'Yminorgrid','off');
    
    if ~rain
        leg_str{1} = sprintf('%2.0f nm (AOD=%2.2f)',wl(star.aeronetcols(1)), star.tau_aero_skyscan(1));
        for ss = 2:length(star.aeronetcols(vis_pix))
            leg_str{ss} = sprintf('%2.0f nm (AOD=%2.2f)',wl(star.aeronetcols(ss)), star.tau_aero_skyscan(ss));
        end
        legend(leg_str,'location','northeast');
    end
    
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
else
    warning('Not a sky scan file?')
end
if star.isALM
    fig_out = [skyimgdir, star.fstem,star.created_str,'alm'];
else
    fig_out = [skyimgdir, star.fstem,star.created_str,'ppl'];
end
saveas(gcf,[fig_out,'.fig']);
saveas(gcf,[fig_out,'.png']);
ppt_add_slide(star.pptname, fig_out);

%
% if isavar('fog')&&(star.isPPL||star.isALM)
%    % Save figure
%    img_dir = getnamedpath('starimg');
%    fig_out = [img_dir,star.out,'.fig'];
%    if exist(fig_out,'file')
%       delete(fig_out);
%    end
%    saveas(fog,fig_out);
%    pause(0.1);
%    png_out = [img_dir,star.out,'.png'];
%    if exist(png_out,'file')
%       delete(png_out);
%    end
%    saveas(fog,png_out);
% end

%%
return

