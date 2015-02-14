%% Details of the program:
% NAME:
%   pca_rads
%
% PURPOSE:
%  smooth out the radiance data by doing deomposing and recomposing the
%  spectra using pca
%
% CALLING SEQUENCE:
%   s = pca_rads(s)
%
% INPUT:
%  - s: structure of starzen data with subsetted rads(radiances), t_rad(time)
%
% OUTPUT:
%  - s: original structure of starzen with added variables
%       rads: reconstructed radiance spectra from pca analysis 
%
% DEPENDENCIES:
%  - version_set.m
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, February 13th, 2015
% Modified:
%
% -------------------------------------------------------------------------
function s = pca_rads(s)
if ~s.toggle.subsetting_Tint;
    warning('Must run the pca_rads on subsetted radiances first. Returning without doing anything.')
    return
end;

% split the radiances into rads for vis and nir and remove the end points
w_vis = s.w(3:1042);
rads_vis = s.rads(:,3:1042);
w_nir = s.w(1048:end-3);
rads_nir = s.rads(:,1048:end-3);

subw_vis = any(isfinite(rads_vis),1); %filter out any wavelength with no finite values
subr_vis = find(all(isfinite(rads_vis(:,subw_vis)),2)); % filter out points with no finite values
rad_vis = rads_vis(subr_vis,subw_vis);

subw_nir = any(isfinite(rads_nir),1); %filter out any wavelength with no finite values
subr_nir = find(all(isfinite(rads_nir(:,subw_nir)),2)); % filter out points with no finite values
rad_nir = rads_nir(subr_nir,subw_nir);
error('*** Not finished yet ***');

[res_vis,rad_vis_re] = pca(rad_vis,10);
[res_nir,rad_nir_re] = pca(rad_nir,10);

% now rebuild the radiances with a subset of the coefficients
return