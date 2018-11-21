function star = handscreen_skyscan_menu(star)
% s = handscreen_skyscan_menu(s)
% Adjust selected WL, SA
% Maybe eventually dAOD, rad_scale, etc.
% Originated as handselect_skyscan_menu to modify absorbing components
% before we understood that the aeronet input file combines all absorbing
% gases.

% Parameteters to adjust:
% wavelengths
% scattering angles
% tau
% radscale

star.wl_ = false(size(star.w));
star.wl_(star.aeronetcols) = true;
star.wl_ii = find(star.wl_);

fini = false;

% When we have SSFR, use land_fraction = 1 along with SSFR-derived flight level albedo
star.land_fraction = 1;
% for SEAC4RS should replace this with an actual determination based on a land-surface
% mapping.

% Wind speed will only have relevance when not flying with SSFR since it is
% used to infer a sea-surface SA as a function of wind-speed.
if ~isfield(star,'wind_speed')
   star.wind_speed= 7.5;
end

star.rad_scale = 1; % This is an adhoc means of adjusting radiance calibration for whatever reason.
star.ground_level = star.flight_level/1000; % picking very low "ground level" sufficient for sea level or AMF ground level.
% Should replace this with an actual determination based on a land-surface mapping.
% Both gen_sky_inp_4STAR and gen_aip_cimel_need to be modified.
% This is trickier than it looks because of the ability in selecting SA
% to exclude wavelength-specific points, not just specific SA.



% star = select_skyscan_wl(star);
% star = select_skyscan_SA(star);
%       good_sky = star.good_sky;
%       skymask = star.skymask;
%    good_sky = false(size(star.good_sky*star.wl_ii));
%    good_sky(star.good_sky,:) = true;
%    skymask = ones(size(star.skyrad(:,star.wl_)));
%    skymask(~good_sky) = NaN;
% AOD_440 = star.tau_aero(star.aeronetcols(1));
% AOD_str = ['AOD [',sprintf('%1.2f',AOD_440),']'];
WL_str = ['Wavelengths [nm]: ',sprintf('%4.1f ',1000.*star.w(star.wl_ii))];
while ~fini
   plot_skyscan(star);
   mn = menu('MODIFY: ', WL_str,'Angles','DONE');

if mn==1 %select wavelengths
   star = select_skyscan_wl(star);
   star.wl_ii = find(star.wl_);
   WL_str = ['Wavelengths [nm]: ',sprintf('%4.f ',1000.*star.w(star.wl_ii))];
   %       good_sky = false(size(star.good_sky*star.wl_ii));
   %       good_sky(star.good_sky,:) = true;
   %       skymask = ones(size(star.skyrad(:,star.wl_)));
   %       skymask(~good_sky) = NaN;
elseif mn==2  %select scattering angles
   star = select_skyscan_SA(star);
   %       good_sky = star.good_sky;
   %       skymask = star.skymask;
elseif mn==3 % must be done!
   fini = true;
end
end
star.wl_ii = find(star.wl_);
last_wl.w = star.w; last_wl.wl_ = star.wl_; last_wl.wl_ii = star.wl_ii;
last_wl_path = getnamedpath('last_wl');
save([last_wl_path, 'last_wl.mat'],'-struct','last_wl');
star.toggle = flip_toggle(star.toggle);
if star.isPPL
   sky = 'ppl_mod';
elseif star.isALM
   sky = 'alm_mod';
end
imgdir = getnamedpath('starimg');
skyimgdir = [imgdir,star.fstem,filesep];
   fig_out = [skyimgdir, star.fstem,star.created_str,sky];
   saveas(gcf,[fig_out,'.fig']);
   saveas(gcf,[fig_out,'.png']);
   ppt_add_slide(star.pptname, fig_out);

%%
return % fini
function plot_skyscan(star)

%        last_wl_path = getnamedpath('last_wl');
%        if isafile([last_wl_path,'last_wl.mat'])
%            in_mat = load([last_wl_path, 'last_wl.mat']);
%            if isfield(in_mat,'Wavelength')
%                star.wl_ii = interp1(star.w, [1:length(star.w)],in_mat.Wavelength,'nearest');
%                star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
%            elseif isfield(in_mat,'wl_ii')&&isfield(in_mat,'wl_')&&(length(in_mat.wl_)==length(star.w))
%                star.wl_ii = in_mat.wl_ii;
%                star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
%            end
%        end     
star.wl_ii = find(star.wl_);
skyrad = star.skyrad(:,star.wl_);
skymask = ones(size(skyrad));
wl_ii = star.wl_ii;
if ~isfield(star,'sky_wl')
    star.sky_wl = star.w(star.wl_);
    good_sky = false(size(star.good_sky*star.wl_ii));
    good_sky(star.good_sky,:) = true;
    skymask(~good_sky) = NaN;
else
    if length(star.sky_wl)~=sum(star.wl_) || ~all(star.sky_wl==star.w(star.wl_))
        sky_wl_ii = interp1(star.w, [1:length(star.w)],star.sky_wl,'nearest');
        [sky_both, sky_ii,sky_ij] = intersect(sky_wl_ii,star.wl_ii);
        [~,ii_new] = setxor(star.wl_ii,sky_wl_ii);
        skymask(:,sky_ij) = star.skymask(:,sky_ii);
        skymask(:,ii_new) = any(star.skymask,2)*ones([1,length(ii_new)]);
        good_sky(:,sky_ij) = star.good_sky(:,sky_ii);
        good_sky(:,ii_new) = any(star.good_sky,2)*ones([1,length(ii_new)]);
        
        star.sky_wl = star.w(star.wl_);
    else
        skymask = star.skymask;
        good_sky = star.good_sky;
    end
end
figure_(1000);

ang = star.SA;
x_type = 2;
%         x_type = menu('Choose x-axis style:','Scattering angle (positive only)','Difference angle (pos and neg)');

if x_type ==2
    if ~star.isPPL
        ang(star.POS) = -ang(star.POS);
    end
end

if star.isPPL
    linesA = semilogy(ang(star.good_ppl), ...
        skyrad(star.good_ppl,:).*skymask(star.good_ppl,:),'.-');
    for la = 1:length(linesA)
       leg_str(la) =  {['w(',num2str(star.wl_ii(la)),') ',sprintf('[%4.1f nm]',1000.*star.w(star.wl_ii(la)))]};
        tx = text(ang(star.good_ppl), ...
            skyrad(star.good_ppl,la).*skymask(star.good_ppl, la),'U','color',...
            get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
    end
    legend(leg_str)
    xlabel('scattering angle [degrees]');
    ylabel('mW/(m^2 sr nm)');
    title(['Current input for ',star.fstem],'interp','none')
    grid('on'); set(gca,'Yminorgrid','off');
else
    linesA = semilogy(ang(star.good_almA), ...
        skyrad(star.good_almA,:).*skymask(star.good_almA,:),'.-');
    for la = 1:length(linesA)
       leg_str(la) =  {['w(',num2str(star.wl_ii(la)),') ',sprintf('[%4.1f nm]',1000.*star.w(star.wl_ii(la)))]};
        text(ang(star.good_almA), ...
            skyrad(star.good_almA,la).*skymask(star.good_almA, la),'L','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
    end
    xlabel('scattering angle [degrees]');
    ylabel('mW/(m^2 sr nm)');
    title(['Current input for ',star.fstem],'interp','none')
    grid('on'); set(gca,'Yminorgrid','off');
%     leg_str{1} = sprintf('%2.0f nm',star.w(wl_ii(1))*1000);
%     for ss = 2:length(wl_ii)
%         leg_str{ss} = sprintf('%2.0f nm',star.w(wl_ii(ss))*1000);
%                leg_str(la) =  {['w(',num2str(star.wl_ii(la)),') ',sprintf('[%4.1f nm]',1000.*star.w(star.wl_ii(la)))]};
%     end
    legend(leg_str,'location','northeast');
    hold('on');
    ax = gca;
    ax.ColorOrderIndex = 1;
    linesB = semilogy(ang(star.good_almB), ...
        skyrad(star.good_almB,:).*skymask(star.good_almB,:),'-');
    semilogy(ang(star.good_alm&star.sat_time), skyrad(star.good_alm&star.sat_time,:)...
        .*skymask(star.good_alm&star.sat_time,:), 'ro','markerface','k' );
    for la = 1:length(linesB)
        text(ang(star.good_almB), ...
            skyrad(star.good_almB,la).*skymask(star.good_almB,la),'R','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
    end
    hold('off')
    %         xlim([0,85+star.sza(1)-max(abs(star.pitch))-max(abs(star.roll))]);
end
zoom('on');
return
