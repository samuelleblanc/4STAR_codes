%% Details of the function:
% NAME:
%   save_fig
% 
% PURPOSE:
%   save the current figure to png and fig formats, but not before asking
%   to save
%
% CALLING SEQUENCE:
%  save_fig(pid,fi,asktopause)
%
% INPUT:
%  - pid: figure id number
%  - fi: file path for figure saving
%  - asktopause: boolean to either ask to save before saving (gives time to
%                adjust figure) (default set to true)
%
% OUTPUT:
%  - saved figure files in .png and .fig
%
% DEPENDENCIES:
%  - version_set.m: to track the version of this script
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  >> figure(12); 
%  >> plot(x,y);
%  >> save_fig(12,[dir 'simpleplot'],true);
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, 2014
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, October 14th, 2014
%                  - changed the stophere to eval('dbstop');
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, December 5th, 2014
%                  - changed options to be more descriptive.
% Modified (v1.3): by Samuel LeBlanc, Santa Cruz, June 26th, 2017
%                  - added keywords to be selected via the asktopause variable
% Modified (v1.4): by Connor, added call to figure_ and zoom('on') to put the figure to be
% saved front and center
% -------------------------------------------------------------------------

%% Function routine
function save_fig(pid,fi,asktopause)
version_set('1.4');
if nargin<3;
    asktopause=true; 
elseif asktopause>1;
    return
elseif asktopause>2;
    s=dbstack;
    eval(['dbstop in ' s(2).name ' at ' num2str(s(2).line+1)])
    return
end;
figure_(pid); zoom('on');
if asktopause 
  OK =menu('Plot saving?','Save figure and continue','Continue without saving','Exit and debug');
  if OK==3
      s=dbstack;
      eval(['dbstop in ' s(2).name ' at ' num2str(s(2).line+1)])
      %stophere %evalin('caller','dbstop if 1==1'); %stophere
      return
  else;
      s=dbstack;
      try
        eval(['dbclear in ' s(2).name ' at ' num2str(s(2).line+1)])
      catch
        nul=0;
      end
  end;
  if OK==2;
      return
  end;
end
saveas(pid,[fi '.fig']);
set(pid,'PaperUnits','inches');
po = get(pid,'Position');
xwidth = po(3);
ywidth = po(4);
dpi = 150.0;
set(pid,'PaperSize',[xwidth ywidth]./dpi);
set(pid,'PaperPosition',[0 0 xwidth ywidth]./dpi);
set(gcf,'paperpositionmode','auto');
saveas(pid,[fi '.png']);
disp(['saving figure at:' fi])
return
