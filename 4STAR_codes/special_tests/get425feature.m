function [dtau425,dtau400] = get425feature(tau,w);
%% Details of the program:
% NAME:
%   get425feature
%
% PURPOSE:
%  Get the AOD differential feature centered at 425 nm. Will do a
%  polynomial extrapolation from the edges of that feature to the quantify
%  the difference in AOD between polynomial fit and actual measurements.
%
% CALLING SEQUENCE:
%   [dtau425,dtau400] = get425feature(tau_aero,w)
%
% INPUT:
%  tau: Full AOD array at full wavelength
%  w: wavelength array
%
% OUTPUT:
%  dtau425: Difference AOD between actual and polynomial fit near 425.
%  dtau400: Difference AOD between actual and polynomial fit near 400.
%
% DEPENDENCIES:
%  - version_set.m
%
% NEEDED FILES:
%  - NA
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, May 1st, 2019
%                 Based on Connor's plot_tau_425nm_artifact.m 
% -------------------------------------------------------------------------

%% codes
version_set('v1.0')

%% set up the variables

% Select a range of pixels in the UV that appear not to be affected
uv_pix = (w>.348 & w<.357) | (w > .455 & w < .475);

% compute mean of tau_tot_vert for pixels around 350 and 465 nm.  
% tau_tot_vert is computed in starwrapper on line 690.  It is a true total
% observed optical depth projected onto the vertical column
tau_350 = mean(tau(:,(w>.348 & w<.357))')';
tau_465 = mean(tau(:,(w > .455 & w < .475))')';

%% Calculate
%Compute the linear least-squares single variable best fit of the equation
%described the cell array of strings.  In this case it is merely a
%single-order polynomial of log(w) vs log(tau) but "fit_it" and "eval_eq" are much faster 
% than iterating interp1 and polyval over time.  
P_uv = fit_it(log(w(uv_pix)), log(tau(:,uv_pix)),{'1';'X'});
tau_425 = real(exp(eval_eq(log(.425),P_uv,{'1';'X'})));
nm_425_i = interp1(w, [1:length(w)],.425,'nearest');

tau_400 = real(exp(eval_eq(log(.4),P_uv,{'1';'X'})));
nm_400_i = interp1(w, [1:length(w)],.4,'nearest');

dtau425 = tau(:,nm_425_i) - tau_425;
dtau400 = tau(:,nm_400_i) - tau_400;

%figure; plot(star_10.t, [tau_vert_350, tau_vert_425, tau_vert_465],'.',...
%   star_10.t, star_10.tau_tot_vert(:,nm_425_i),'k.' ); dynamicDateTicks
%legend('tau 350','tau bar 425', 'tau 465','tau 425')
%xlabel('time'); ylabel('tau'); 
return
