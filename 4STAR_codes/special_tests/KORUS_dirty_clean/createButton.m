function h = createButton(h)
% typical syntax: 
%     h = createButton; finishup = onCleanup(@() deleteButton(h));
% Creates a button allowing user to pause execution
% type 'return' to resume
% follow this function with finishup = onCleanup(@() deleteButton(h));
% to remove button after parent function terminates.
if ~exist('h','var')
    h = 1234321;
end
h = figure_(h);
set(h,'MenuBar','none','Units','Normalized');
uicontrol(... % Button for updating selected plot
   'Parent', h, ...
   'Units','normalized',...
   'HandleVisibility','callback', ...
   'Position',[0.1 0.1 0.8 0.8],...
   'String','Pause. Type "return" to resume.',...
   'BackgroundColor',[1 0.6 0.6],...
   'Callback', 'eval(''keyboard'')');

return



