function toggle_out = update_toggle(toggle_in)
% toggle_out = update_toggle(toggle_in)
% Merge the optional "toggle_in" with user-supplied values in toggle_out
% Frequently this instance will be shadowed by the internal function
% of the same name defined beneath starinfo files.
% un-test commit michal 2016-05-08

toggle_out.subsetting_Tint = true;
toggle_out.pca_filter = false;
toggle_out.verbose=false;
toggle_out.saveadditionalvariables=true;
toggle_out.savefigure=false;
toggle_out.computeerror=true;
toggle_out.inspectresults=false;
toggle_out.applynonlinearcorr=true;
toggle_out.applytempcorr=false;% true is for SEAC4RS data
toggle_out.gassubtract = false;
toggle_out.booleanflagging = true;
toggle_out.starflag_mode = 1; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.flagging = toggle_out.starflag_mode; % Defunct but kept for old codes
toggle_out.doflagging = true; % for running any Yohei style flagging
toggle_out.dostarflag = false; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = false;
toggle_out.applyforjcorr = false;
toggle_out.applystraycorr = false;
toggle_out.editstarinfo = true;
toggle_out.reduce_variable_size = true; % for changing the starsun saved variables to single precision, reducing by more than half saved file size
toggle_out.no_SSFR = false;
toggle_out.use_last_wl = false;
toggle_out.flip_toggle = false;
toggle_out.skip_ppl = false;
toggle_out.skip_alm = false;
toggle_out.skip_lt_N = 0;
toggle_out.skip_gt_N = inf;
toggle_out.sky_tag = ''; % descriptive tag applied to input filename
toggle_out.skyscan_manual = false; % true for skyscan manual selection, i.e. manual interaction and to set defaults
toggle_out.sky_SA_min = 3.5;
toggle_out.sky_El_min = 6;
toggle_out.sky_dOD = [0]; % tod = tod + dOD
toggle_out.sky_rad_scale = 1;
if exist('toggle_in', 'var')
   toggle_out = catstruct(toggle_out,toggle_in);
end

return
