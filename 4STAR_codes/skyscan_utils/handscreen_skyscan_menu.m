function star = handscreen_skyscan_menu(star)
% s = handscreen_skyscan_menu(s)
% Adjust selected WL, SA

% Parameters to adjust:
% wavelengths
% scattering angles
if ~isfield(star,'wl_')
    star.wl_ = false(size(star.w));
    star.wl_(star.aeronetcols) = true;
    star.wl_ii = find(star.wl_);
end
fini = false;
while ~fini
    if length(star.wl_ii)<7
        WL_str = ['Wavelengths [nm]: ',sprintf('%3.1f,',1000.*star.w(star.wl_ii))];       
    else
        WL_str = ['Wavelengths [nm]: ',sprintf('%3.0f,',1000.*star.w(star.wl_ii(1:2))),...
            '...',sprintf('%3.0f,',1000.*star.w(star.wl_ii(end-1:end)))];
        WL_str(end) = [];        
    end
   plot_skyscan(star);
   mn = menu('MODIFY: ', WL_str,'Screen Angles','DONE');
if mn==1 %select wavelengths
   star = select_skyscan_wl(star);
   star = select_skyscan_SA(star);
%    star.wl_ii = find(star.wl_);
%    WL_str = ['Wavelengths [nm]: ',sprintf('%4.f ',1000.*star.w(star.wl_ii))];
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
last_wl.w_fit_ii = star.w_isubset_for_polyfit;
last_wl_path = getnamedpath('last_wl');
save([last_wl_path, 'last_wl.mat'],'-struct','last_wl');
if isfield(star.toggle,'sky_tag')&&~isempty(star.toggle.sky_tag)
    tag_str = star.toggle.sky_tag; tag_str = tag_str{:}; 
   if ~isempty(tag_str) tag_str = [tag_str, '.']; tag_str = strrep(tag_str,'..','.');end
else tag_str = '';
end
save([last_wl_path,['last_wl.',tag_str,datestr(now,'yyyymmdd.HHMMSS.'),'mat']],'-struct','last_wl');
star.toggle = flip_toggle(star.toggle);
if star.isPPL
   sky = 'ppl_mod';
elseif star.isALM
   sky = 'alm_mod';
end
imgdir = getnamedpath('starimg');
skyimgdir = [imgdir,star.fstem,filesep];
    if ~isadir(skyimgdir)
           mkdir(skyimgdir);
    end
   fig_out = [skyimgdir, star.fstem,star.created_str,sky];
   saveas(gcf,[fig_out,'.fig']);
   saveas(gcf,[fig_out,'.png']);
   ppt_add_slide(star.pptname, fig_out);

%%
return % fini

