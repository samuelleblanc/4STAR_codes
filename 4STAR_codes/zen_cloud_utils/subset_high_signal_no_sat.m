%% Details of the program:
% NAME:
%   subset_high_signal_no_sat
%
% PURPOSE:
%  runs through zenith radiance data which are measured in sets of integration times
%  This programs finds the highest signal without saturation in each subset of integration times.
%
% CALLING SEQUENCE:
%   s = subset_high_signal_no_sat(s)
%
% INPUT:
%  - s: structure of starzen data with rad(radiances), t(time),
%       visTint(visible integration times), nirTint(Near IR integration times),
%       sat_ij (saturation location of each pixel)
%
% OUTPUT:
%  - s: original structure of starzen with added variables
%       t_rad: subset of time points used for subset of radiance measurements
%       sat_nir: saturation flag for nir spectrometer (derived from sat_ij)
%       sat_vis: saturation flag for vis spectrometer
%       rads: subset of radiance spectra optimized for signal, with saturated spectra removed
%       visTint_rad: subset of integration times for vis used for the subsetted radiance
%       nirTint_rad: subset of integration times for nir used for the subsetted radiance
%       sat_set_vis: if in the original subset there was a saturated point.
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
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, March 19th, 2015
%                  - fixed bug below
%
% -------------------------------------------------------------------------

function s = subset_high_signal_no_sat(s)
version_set('v1.1')

if s.toggle.verbose; disp('Subsetting the zenith radiances samples for the highest non-saturated signal'), end;

nvis = 1044;
s.sat_vis = any(s.sat_ij(:,1:nvis),2);
s.sat_nir = any(s.sat_ij(:,nvis+1:end),2);

iset = find(diff(s.visTint) < 0 & diff(s.nirTint) < 0);

ilow = 1;
s.rads = s.rad(1,:);
for i=1:length(iset);
    ihigh = iset(i);
    u = [ilow:ihigh];
    s.sat_set_vis(i) = any(s.sat_vis(u));
    s.sat_set_nir(i) = any(s.sat_nir(u));
    if all(s.sat_vis(u)) || all(s.sat_vis(u));
        s.rads(i,:) = s.rad(u(1),:)*NaN;
        s.t_rad(i) = s.t(u(1));
        continue;
    end;
    try;
        [s.visTint_rad(i), iv] = max(s.visTint(u(~s.sat_vis(u))));
        [s.nirTint_rad(i), in] = max(s.nirTint(u(~s.sat_nir(u))));
        s.t_rad(i) = s.t(max([u(iv),u(in)]));
        s.rads(i,1:nvis) = s.rad(u(iv),1:nvis);
        s.rads(i,nvis+1:end) = s.rad(u(in),nvis+1:end);
    catch;
        s.rads(i,:) = s.rad(i,:).*NaN;
    end;
    ilow = ihigh+1;
end;
s.iset = iset;
return

