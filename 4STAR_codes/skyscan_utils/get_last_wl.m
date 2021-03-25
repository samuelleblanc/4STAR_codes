function [wl_, wl_ii, sky_wl,w_fit_ii] = get_last_wl(star)
% Load the last_wl_mat file, then parse for Wavelength and wl_ii fields
wl_path = getnamedpath('wl_path');
if isafile([wl_path,'last_wl.mat'])
   in_mat = load([wl_path, 'last_wl.mat']);
   if isfield(in_mat,'Wavelength')
      wl_ii = interp1(star.w, [1:length(star.w)],in_mat.Wavelength,'nearest');
      wl_ = false(size(star.w)); wl_(wl_ii) = true;
   elseif isfield(in_mat,'wl_ii')&&isfield(in_mat,'wl_')&&(length(in_mat.wl_)==length(star.w))
      wl_ii = in_mat.wl_ii;
      wl_ = false(size(star.w)); wl_(wl_ii) = true;
   end
   if isfield(in_mat,'w_fit_ii')
       w_fit_ii =  in_mat.w_fit_ii;
   else
       w_fit_ii = star.w_isubset_for_polyfit;
   end
end
sky_wl = star.w(wl_);

return