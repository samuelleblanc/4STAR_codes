function plot_skyscan(star)
% plot_skyscan
% Displays a sky scan for interrogation as part of handscreen_skyscan
% Display only, nothing saved or returned.
% CJF, v1.0, 2020-05-03, had previouly been nested within handscreen_skyscan_menu

version_set('1.0');
star.wl_ii = find(star.wl_);% This doesn't propagate out since there is no argout
skyrad = star.skyrad(:,star.wl_);
skymask = star.skymask(:,star.wl_);
if ~isfield(star,'sky_wl')
    star.sky_wl = star.w(star.wl_); % This doesn't propagate out since there is no argout
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
        star.sky_wl = star.w(star.wl_); % This doesn't propagate out since there is no argout
    end
end
figure_(1000);

ang = double(star.SA);
x_type = 1; % All angles positive, so both branches of ALM appear on top of each other
x_type = 2; % Branches of ALM appear symmetrically
%         x_type = menu('Choose x-axis style:','Scattering angle (positive only)','Difference angle (pos and neg)');

if x_type ==2
    if ~star.isPPL
        ang(star.POS) = -ang(star.POS);
    end
end
wl_ii = star.aeronetcols; rain = length(wl_ii)>6;
if star.isPPL
    linesA = semilogy(ang(star.good_ppl), ...
        skyrad(star.good_ppl,:).*skymask(star.good_ppl,:),'.-');
    if ~rain
    for la = 1:length(linesA)
       leg_str(la) =  {['w(',num2str(star.wl_ii(la)),') ',sprintf('[%4.1f nm]',1000.*star.w(star.wl_ii(la)))]};
        tx = text(ang(star.good_ppl), ...
            skyrad(star.good_ppl,la).*skymask(star.good_ppl, la),'U','color',...
            get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
    end
    legend(leg_str)
    else 
        recolor(linesA,1000.*star.w(wl_ii)); cb = colorbar; cbt=get(cb,'title'); set(cbt,'string','nm')
    end
    xlabel('scattering angle [degrees]');
    ylabel('mW/(m^2 sr nm)');
    title(['Current input for ',star.fstem],'interp','none')
    grid('on'); set(gca,'Yminorgrid','off');
else
    linesA = semilogy(ang(star.good_almA), ...
        skyrad(star.good_almA,:).*skymask(star.good_almA,:),'.-');
    if ~rain
        for la = 1:length(linesA)
            leg_str(la) =  {['w(',num2str(star.wl_ii(la)),') ',sprintf('[%4.1f nm]',1000.*star.w(star.wl_ii(la)))]};
            text(ang(star.good_almA), ...
                skyrad(star.good_almA,la).*skymask(star.good_almA, la),'L','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
        end
        legend(leg_str,'location','northeast');
    else
        recolor(linesA,1000.*star.w(wl_ii)); cb = colorbar; cbt=get(cb,'title'); set(cbt,'string','nm')
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

    hold('on');
    ax = gca;
    ax.ColorOrderIndex = 1;
    linesB = semilogy(ang(star.good_almB), ...
        skyrad(star.good_almB,:).*skymask(star.good_almB,:),'-');
    semilogy(ang(star.good_alm&star.sat_time), skyrad(star.good_alm&star.sat_time,:)...
        .*skymask(star.good_alm&star.sat_time,:), 'ro','markerface','k' );
    if rain
        recolor(linesB,1000.*star.w(wl_ii)); cb = colorbar;cbt=get(cb,'title'); set(cbt,'string','nm')
    else
%     for la = 1:length(linesB)
%         text(ang(star.good_almB), ...
%             skyrad(star.good_almB,la).*skymask(star.good_almB,la),'R','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
%     end
    end
    hold('off')
    %         xlim([0,85+star.sza(1)-max(abs(star.pitch))-max(abs(star.roll))]);
end
zoom('on');
return