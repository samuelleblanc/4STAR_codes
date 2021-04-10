function toggle_out = update_toggle(toggle_in)
% toggle_out = update_toggle(toggle_in)
% Merge the optional "toggle_in" with user-supplied values in toggle_out
% Frequently this instance will be shadowed by the internal function
% of the same name defined beneath starinfo files.
% un-test commit michal 2016-05-08
% CJF: v1.1, 2020-05-03, Replaced catstruct with explicit loop to prevent sorting
version_set('1.1');

toggle_out.subsetting_Tint = true;
toggle_out.pca_filter = false;
toggle_out.verbose=true;
toggle_out.saveadditionalvariables=true;
toggle_out.savefigure=false;
toggle_out.computeerror=true;
toggle_out.inspectresults=false;
toggle_out.applynonlinearcorr=true;
toggle_out.applytempcorr=false;% true is for SEAC4RS data
toggle_out.gassubtract = true;
toggle_out.booleanflagging = false; % for running any Yohei style flagging
toggle_out.starflag_mode = 1; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.flagging = toggle_out.starflag_mode; % Defunct but kept for old codes
toggle_out.doflagging = false; % for running any Yohei style flagging
toggle_out.dostarflag = true; % for newer style flagging
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = true;
toggle_out.applyforjcorr = true;
toggle_out.applystraycorr = false;
toggle_out.editstarinfo = false;
toggle_out.reduce_variable_size = true; % for changing the starsun saved variables to single precision, reducing by more than half saved file size
toggle_out.save_marks_flags = false;
toggle_out.no_SSFR = false;
toggle_out.use_last_wl = true;
toggle_out.custom_polyfit = true;
toggle_out.flip_toggle = true;
toggle_out.skip_ppl = false;
toggle_out.skip_alm = false;
toggle_out.skip_lt_N = 1;
toggle_out.skip_gt_N = inf;
toggle_out.sky_tag = {'_5wl_360_xfit_more_complete'}; %'_minusdAOD'; % descriptive tag applied to input filename, leading underscore pls
toggle_out.skyscan_manual = true; % true for skyscan manual selection, i.e. manual interaction and to set defaults
toggle_out.sky_SA_min = 3.5;
toggle_out.sky_El_min = 6;
toggle_out.sky_dOD =0; % -[0.055 0.036 0.029 0.024 0.037];%<-0924 after11a %[0.06 0.042 0.035 0.029 0.037];%<-0924 before11a%[0.024 0.018 0.016 0.013 0.025];%<-0925 %[0.011 0.009 0.007 0.006 0.011];%<-0927 (5pm) %[0.024 0.02 0.018 0.018 0.025]; %<-0831a[not scans 9&10] %[0.022 0.018 0.017 0.016 0.02];%<-0902 %[0.026 0.015 0.009 0.008 0.018]; %<-0904 %[0.028 0.017 0.01 0.01 0.019];%<-0906 %[0.025 0.021 0.022 0.025 0.033];%<- 0918 %[0.018 0.015 0.01 0.01 0.018]; %<-0914 %[0.028 0.019 0.013 0.013 0.022]; %<-0910 %[0.024 0.016 0.01 0.01 0.02]; %<-0908  %0;%-[0.018 0.013 0.01 0.01 0.02]; %<- 0912 %[0]; %-[0.036 0.03 0.03 0.03 0.036]; <-0920 % tod = tod + dOD %
toggle_out.sky_rad_scale = 1;
toggle_out.grasp_out = false; %Set to true to generate output for GRASP
toggle_out.anet_out = true; 
toggle_out.debug = false; % Steps into debug execution after untrapped errors
load('RadUncAt4STARwl.mat','RadUncAt4STARwl');
toggle_out.sky_rad_scale = 1-0*RadUncAt4STARwl;
if isavar('toggle_in')
    toggle_out = merge_toggle(toggle_out, toggle_in);
end

return
