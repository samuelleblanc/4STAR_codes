
%push variable to caller
% Bad coding practice to blind-push variables to the caller.  
% Creates potential for clobbering and makes collaborative coding more
% difficult because fields appear in caller memory space undeclared.

varNames=who();
for i=1:length(varNames)
   if ~strcmp(varNames{i},'s')
      assignin('caller',varNames{i},eval(varNames{i}));
   end
end;

return

function toggle = update_toggle

toggle.verbose=true;
toggle.saveadditionalvariables=true;
toggle.savefigure=false;
toggle.computeerror=true;
toggle.inspectresults=false;
toggle.applynonlinearcorr=false;
toggle.applytempcorr=false;% true is for SEAC4RS data
toggle.gassubtract = false;
toggle.booleanflagging = true;
toggle.flagging = 2; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle.doflagging = true; % for running any Yohei style flagging
toggle.dostarflag = true; 
toggle.lampcalib  = false; 
toggle.runwatervapor = false;

return