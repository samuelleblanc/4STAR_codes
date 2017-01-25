function toggle_out = update_toggle(toggle_in)
% toggle_out = update_toggle(toggle_in)
% Merge the optional "toggle_in" with user-supplied values in toggle_out
% Frequently this instance will be shadowed by the internal function
% of the same name defined beneath starinfo files.
% un-test commit michal 2016-05-08

toggle_out.subsetting_Tint = true;
toggle_out.pca_filter = false;
toggle_out.verbose=true;
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
toggle_out.dostarflag = true; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = false;
toggle_out.applyforjcorr = true;
toggle_out.applystraycorr = false;
toggle_out.editstarinfo = false;
toggle_out.reduce_variable_size = true; % for changing the starsun saved variables to single precision, reducing by more than half saved file size

if exist('toggle_in', 'var')
   toggle_out = catstruct(toggle_out, toggle_in);
end

return
