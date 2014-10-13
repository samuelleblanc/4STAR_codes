%% Details of the function:
% NAME:
%   correct_nonlinear
% 
% PURPOSE:
%   Correct the nonlinear behaviour inherent to the spectrometers (vis and
%   nir) by relating the well depth. Uses radiance calibration from
%   laboratory. 
%
% CALLING SEQUENCE:
%  spout_raw=correct_nonlinear(spin_raw)
%
% INPUT:
%  - spin_raw: array of raw count spectra before nonlinearity, can be
%              either from vis or nir. The program selects the correct vis
%              or nir spectrometer depending on the size of the raw array.
% 
% OUTPUT:
%  - spout_raw: array of raw cunt spectra with nonlinearity reduced
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%  - version_set.m: to track the version of this script
%
% NEEDED FILES:
%  - yyyymmdd_resp_corr.mat file created by sasze_radcals_nonlinear_SL.m
%
% EXAMPLE:
%  - rawout=correct_nonlinear(vis_sun.raw);
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, June 19th, 2014
% Modified: by Yohei Shinozuka, October 9th, 2014
%           - changed lines 71-78 for increased efficiency.
% Modified (v1.0): by Samuel LeBlanc, October 10th, 2014
%           - changed wd to be no smaller than 0
%           - added version_set call
%
% -------------------------------------------------------------------------

%% Function routine
function spout_raw=correct_nonlinear(spin_raw, verbose)
version_set('1.0');

%% Determine either vis or nir spectrometer
if length(spin_raw(1,:)) == 512 
    isvis=false;
elseif length (spin_raw(1,:)) == 1044
    isvis=true;
else
    disp('Problem determining the spectrometer in use - check size of raw array')
end

%% Load the file containing the look-up-table correction
date='20130507';
pname=starpaths; %'C:\Users\sleblan2\Research\4STAR\cal\20130506';
if verbose, disp(['loading correction file:' pname date '_resp_corr.mat']), end;
% load([pname date '_resp_corr.mat']);
load(fullfile(pname, [date '_resp_corr.mat']));

%% Calculate well depth
if isvis 
    corr=all.vis;
    max_val=2^16;
    if verbose, disp('for Vis spectrometer'), end;
else
    corr=all.nir;
    max_val=2^15;
    if verbose, disp('for NIR spectrometer'), end;
end
wd=spin_raw./max_val; %get well depth

%% Now go through each pixel and normalize then correct for nonlinearity
% for inm=1:length(spin_raw(1,:))
%    for it=1:length(spin_raw(:,1))
%      % find the closest well depth look-up-table value
%      [c ind]=min(abs(corr.awell-wd(it,inm))); 
%      % divide the well depth by the correction value
%      spout_wd(it,inm)=wd(it,inm)./corr.aresp(ind);
%    end
% end
wd(find(wd <0))=0;
spout_wd=wd./corr.aresp(round(wd*100)+1); % Yohei, 2014/10/08

%% Write to the out spectra array by converting well depth back to raw counts
spout_raw=spout_wd.*max_val; 
return