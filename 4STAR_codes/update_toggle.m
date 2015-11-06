function toggle_out = update_toggle(toggle_in)
% toggle_out = update_toggle(toggle_in)
% Merge the optional "toggle_in" with user-supplied values in toggle_out
% Frequently this instance will be shadowed by the internal function
% of the same name defined beneath starinfo files.

toggle_out.verbose=true;
toggle_out.saveadditionalvariables=true;
toggle_out.savefigure=false;
toggle_out.computeerror=true;
toggle_out.inspectresults=false;
toggle_out.applynonlinearcorr=false;
toggle_out.applytempcorr=false;% true is for SEAC4RS data
toggle_out.gassubtract = false;
toggle_out.booleanflagging = true;
toggle_out.flagging = 2; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.doflagging = true; % for running any Yohei style flagging
toggle_out.dostarflag = true; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = false;

if exist('toggle_in', 'field')
   toggle_out = catstruct(toggle_in, toggle_out);
end


return