function H = figure_(H,pos)
%Calls built-in figure but then uses returned argument to set position to
% position of same figure when last closed.
%FIGURE Create figure window.
%   FIGURE, by itself, creates a new figure window, and returns
%   its handle.
%
%   FIGURE(H) makes H the current figure, forces it to become visible,
%   and raises it above all other figures on the screen.  If Figure H
%   does not exist, and H is an integer, a new figure is created with
%   handle H.
%
%   GCF returns the handle to the current figure.
%
%   Execute GET(H) to see a list of figure properties and
%   their current values. Execute SET(H) to see a list of figure
%   properties and their possible values.
%
%   See also SUBPLOT, AXES, GCF, CLF.

%   Copyright 1984-2002 The MathWorks, Inc.
%   Built-in function.
if nargin==0
    H = builtin('figure');
else
    if isgraphics(H)
        pos.position = get(H,'position');
        pos.units = get(H,'units');
        pos.windowstyle = get(H,'windowstyle');
    end
    H = builtin('figure',H);
end

if ~isempty(strfind(class(H),'Figure'))
    num = H.Number;
elseif isnumeric(H)
    num = H;
end

% pname = strrep(strrep(userpath,';',filesep),':',filesep);
% pathdir = [pname, 'filepaths'];
% if ~exist(pathdir,'dir')
%     mkdir(pname, 'filepaths');
% end
% pathdir = [pathdir,filesep];
% 
% 
% figfile = [pathdir,'figpos.',num2str(num),'.mat'];

% Load the current figpos file unless pos was supplied as an argument.
if isempty(who('pos')) || isempty(pos)
    pos = loadfigpos(H);
else
    if ~isstruct(pos)&&length(pos)==4
        tmp = pos; clear pos
        pos.position = tmp;
        if all(pos.position>=0)&&all(pos.position<=1)
            pos.units = 'normalized';
        else
            pos.units = 'pixel';
        end
        pos.windowstyle = 'normal';
    end
end
%     delete(figfile);
% elseif exist('pos','var') && isstruct(pos) && isfield(pos,'units') && isfield(pos,'position')
%     save(figfile,'-struct','pos')
% end
% if exist(figfile,'file')  
if ~isempty(who('pos')) && ~isempty(pos) 
    set(H,'units',pos.units);
    if ~strcmp(get(H,'windowstyle'),'docked')
        set(H,'position',pos.position);
    end
    if isfield(pos,'windowstyle')
        set(H,'Windowstyle',pos.windowstyle);
    end    
end

% next line is never executed but is added so that bundlefnt will include
% closereq which along with loadfigpos and savefigpos is required for
% figure_ to work
if false
   closereq;
end

return