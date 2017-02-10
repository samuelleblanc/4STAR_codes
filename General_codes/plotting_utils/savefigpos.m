function savefigpos(H)
% savefigpos(H)
% Saves the position of the supplied figure to a file named after the
% figure number.  Normally this function will be called within the
% "closereq" function so is not needed to be called manually.

if nargin==0
    H = gcbf;
end
if isempty(H)&&~isempty(allchild(0))
    H = gcf;
end
if ~isempty(H)
    pname = [strrep(userpath,';',filesep),filesep];
    pname = strrep(pname, [filesep filesep],filesep);
    pathdir = [pname, 'filepaths'];
    if ~exist(pathdir,'dir')
        mkdir(pname, 'filepaths');
    end
    pathdir = [pathdir,filesep];
    
    if ~isempty(strfind(class(H),'Figure'))
        num = H.Number;
    elseif isnumeric(H)
        num = H;
    end
    
    figfile = [pathdir,'figpos.',num2str(num),'.mat'];
    pos.units = get(H,'Units');
    pos.windowstyle = get(H,'Windowstyle');
    pos_saved = loadfigpos(H);
    if strcmp(get(H,'windowstyle'),'docked') && ~isempty(pos_saved) && isfield(pos_saved, 'position')
        pos.position = pos_saved.position;
    else
        pos.position = get(H,'Position');
    end
    save(figfile,'-struct','pos');
end
return