%% Details of the function:
% NAME:
%   save_fig
% 
% PURPOSE:
%   save the current figure to png and fig formats, but not before asking
%   to save
%
% CALLING SEQUENCE:
%  save_fig(pid,fi,asktopause
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
%
% -------------------------------------------------------------------------

%% Function routine
function save_fig(pid,fi,asktopause)
version_set('1.1');
if nargin<3, asktopause=true; end; % set default asktopause behavior
if asktopause 
  OK =menu('continue or exit?','Continue','Exit');
  if OK==2
      s=dbstack;
      eval(['dbstop in ' s(2).name ' at ' num2str(s(2).line+1)])
      %stophere %evalin('caller','dbstop if 1==1'); %stophere
      return
  else;
      s=dbstack;
      eval(['dbclear in ' s(2).name ' at ' num2str(s(2).line+1)])
  end;
end
saveas(pid,[fi '.fig']);
saveas(pid,[fi '.png']);
disp(['saving figure at:' fi])