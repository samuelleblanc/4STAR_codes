function star = select_skyscan_SA(star)
% star = select_skyscan_SA(star)
% We need to be a bit careful now that we're trying to use this iteratively
% with select_skyscan_wl because that changes the dimensionality of good_sky
% Check for existence of sky_wl and that it matches the wl in star.wl_.
skyrad = star.skyrad(:,star.wl_); skymask = star.skymask(:,star.wl_); 
if isfield(star,'good_sky')
   good_sky = false(size(star.good_sky*star.wl_ii));
   good_sky(star.good_sky,:) = true;
end
wl_ii = star.wl_ii; rain = length(wl_ii)>7;
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
%    else
%       skymask = star.skymask;
%       good_sky = star.good_sky;
   end
end
figure_(1000);
done = false;
while ~done % with SA selection
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
         tx = text(ang(star.good_ppl), ...
            skyrad(star.good_ppl,la).*skymask(star.good_ppl, la),'U','color',...
            get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
      end
      xlabel('scattering angle [degrees]');
      ylabel('mW/(m^2 sr nm)');
      title('Select or reject points for retrieval','interp','none')
      grid('on'); set(gca,'Yminorgrid','off');
   else
      linesA = semilogy(ang(star.good_almA), ...
         skyrad(star.good_almA,:).*skymask(star.good_almA,:),'.-');
      for la = 1:length(linesA)
         tx = text(ang(star.good_almA), ...
            skyrad(star.good_almA,la).*skymask(star.good_almA, la),'L','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
      end
      xlabel('scattering angle [degrees]');
      ylabel('mW/(m^2 sr nm)');
      title('Select or reject points for retrieval','interp','none')
      grid('on'); set(gca,'Yminorgrid','off');
      if ~rain;
          leg_str{1} = sprintf('%2.0f nm',star.w(wl_ii(1))*1000);
          for ss = 2:length(wl_ii)
              leg_str{ss} = sprintf('%2.0f nm',star.w(wl_ii(ss))*1000);
          end
          legend(leg_str,'location','northeast');
      end
      hold('on');
      ax = gca;
      ax.ColorOrderIndex = 1;
      linesB = semilogy(ang(star.good_almB), ...
         skyrad(star.good_almB,:).*skymask(star.good_almB,:),'-');
      semilogy(ang(star.good_alm&star.sat_time), skyrad(star.good_alm&star.sat_time,:)...
         .*skymask(star.good_alm&star.sat_time,:), 'ro','markerface','k' );
      for la = 1:length(linesB)
         tx = text(ang(star.good_almB), ...
            skyrad(star.good_almB,la).*skymask(star.good_almB,la),'R','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
      end
      hold('off')
      %         xlim([0,85+star.sza(1)-max(abs(star.pitch))-max(abs(star.roll))]);
   end
   if rain
       recolor(linesA,1000.*star.w(wl_ii)); cb = colorbar;cbt=get(cb,'title'); set(cbt,'string','nm')
       if isavar('linesB') recolor(linesB,1000.*star.w(wl_ii));
       end
   end
   zoom('on');
   
   act = menu('Now zoom in to specific regions and select the desired action, or exit','Include','Exclude','Toggle','ONLY these','Done/Exit');
   if act==5
      done = true;
   else
      % Now zoom in and include, toggle, or exclude

      v = axis;
      for wi = 1:length(wl_ii)
         in_bounds =  ang>=v(1)&ang<=v(2)&skyrad(:,wi)>=v(3)&skyrad(:,wi)<=v(4)&star.Str==2;
         if size(good_sky,2)==1
            if act==1
               good_sky(in_bounds) = true;
            elseif act==2
               good_sky(in_bounds) = false;
            elseif act==3
               good_sky(in_bounds) = ~good_sky(in_bounds,wi);
            elseif act==4
               good_sky = false;
               good_sky(in_bounds) = true;
            end
            skymask(good_sky,wi) = 1;
            skymask(~good_sky,wi) = NaN;
         else
            if act==1
               good_sky(in_bounds,wi) = true;
            elseif act==2
               good_sky(in_bounds,wi) = false;
            elseif act==3
               good_sky(in_bounds,wi) = ~good_sky(in_bounds,wi);
            elseif act==4
               good_sky(:,wi) = false;
               good_sky(in_bounds,wi) = true;
            end
            skymask(good_sky) = 1;
            skymask(~good_sky) = NaN;
         end
      end
   end
end

star.skymask(:,star.wl_) = skymask ;

return