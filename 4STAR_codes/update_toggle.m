function toggle = update_toggle
% toggle = update_toggle
% This function contains default toggle states.  
% Frequently this instance will be shadowed by the internal function
% of the same name defined beneath starinfo files.

toggle.verbose=true;
toggle.saveadditionalvariables=true;
toggle.savefigure=false;
toggle.computeerror=true;
toggle.inspectresults=false;
toggle.applynonlinearcorr=true;
toggle.applytempcorr=false;% true is for SEAC4RS data
toggle.gassubtract = false;
toggle.booleanflagging = true;
toggle.flagging = 2; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle.doflagging = true; % for running any Yohei style flagging
toggle.dostarflag = true; 
toggle.lampcalib  = false; 
toggle.runwatervapor = false;
toggle.subsetting_Tint = true;
toggle.pca_filter = false;


return