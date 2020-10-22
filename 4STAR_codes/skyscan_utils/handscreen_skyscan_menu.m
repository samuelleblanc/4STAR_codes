function [star,changed] = handscreen_skyscan_menu(star)
% [s,changed] = handscreen_skyscan_menu(s)
% Adjust selected WL, SA
% changed.wl and changed.SA are booleans indicating whether either were
% changed

% Parameters to adjust:
% wavelengths
% scattering angles
changed.wl = false; changed.SA = false;

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
   star_ = select_skyscan_wl(star);
   if length(star_.wl_ii)~=length(star.wl_ii)||any(star_.wl_ii~=star.wl_ii)
       changed.wl = true;
       star = select_skyscan_SA(star_); 
       if any(star.good_sky~=star_.good_sky)
           changed.SA = true;
       end
   else
       star = star_;
   end
  clear star_;
%    star.wl_ii = find(star.wl_);
%    WL_str = ['Wavelengths [nm]: ',sprintf('%4.f ',1000.*star.w(star.wl_ii))];
   %       good_sky = false(size(star.good_sky*star.wl_ii));
   %       good_sky(star.good_sky,:) = true;
   %       skymask = ones(size(star.skyrad(:,star.wl_)));
   %       skymask(~good_sky) = NaN;
elseif mn==2  %select scattering angles
   star_ = star;
   star = select_skyscan_SA(star_);
   if any(star.good_sky~=star_.good_sky)
       changed.SA = true;
   end
   clear star_
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

if isfield(star.toggle,'sky_tag')&&~isempty(star.toggle.sky_tag)
    tag_str = star.toggle.sky_tag; tag_str = tag_str{:}; 
   if ~isempty(tag_str) tag_str = [tag_str, '.']; tag_str = strrep(tag_str,'..','.');end
else tag_str = '';
end
new_file = [last_wl_path,['last_wl.',tag_str,datestr(now,'yyyymmdd_HHMMSS.'),'mat']];
last_file = [last_wl_path,'last_wl.mat'];
while ~isafile(last_file)
    last_file = getfullname('last_wl*.mat','last_wl','Select last_wl.mat file');
end

save(new_file,'-struct','last_wl');
% If the new last_wl is identical to last_wl.mat, then delete new one
last_wls = load(last_file); new_wls = load(new_file);
if isequal(last_wls,new_wls )
        delete(new_file);       
else
    save([last_wl_path, 'last_wl.mat'],'-struct','last_wl');
end
clear last_wls new_wls
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

