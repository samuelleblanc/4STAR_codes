function stamp(filename, author)

% Yohei, now preserves the original order of figure children, on 2009-11-07
% Yohei, enabled previous stamp deletion on 2004-02-04
% Yohei, modified on 2002-08-15
% Yohei, August 1, 2001
% This code makes a stamp on the left-bottom corner of the current figure.
% Input
%   filename
%   author (optional): 'Yohei' as default.
% For example, stamp('TPnephvsOPC.fig, TPclosure.m','Yohei')

% parameter
% normalized position of stamp
xx=0.13;
yy=0.01;
% author
if nargin<2;
    author='Yohei';
end;

% delete previous stamps
chi=get(gcf,'children');
ps=findobj(gcf, 'type','axes','tag','stamp');
if ~isempty(ps)
    delete(ps);
    chi=chi(find(ps~=chi));
end;

% stamp position
gca0=gca;
ns=axes('units', 'normalized', 'position', [xx yy 0.01 0.01], ...
    'visible', 'off', 'tag', 'stamp');
chi=[chi; ns];

% stamp now
stamp=([filename ', ' author ', ' datestr(date,29)]);
text(0, 0, stamp,'fontsize',8, 'interpreter', 'none');
set(gcf,'children',chi);
axes(gca0);

% set up filename for easy saving
fs=findstr(filename, '.fig');
if ~isempty(fs);
    figurename=filename(1:(fs+3));
    set(gcf, 'filename', figurename);
end;