function pos = loadfigpos(H)
% Loads a figure position file for H
usrpath = [strrep(userpath,pathsep,''),filesep];
% usrpath= strrep(strrep(userpath,';',filesep),':',filesep);
pathdir = [usrpath, 'fig_position'];
if ~exist(pathdir,'dir')
    mkdir(usrpath, 'fig_position');
end
pathdir = [pathdir,filesep];

if ~isempty(strfind(class(H),'Figure'))
    num = H.Number;
elseif isnumeric(H)
    num = H;
end
figfile = [pathdir,'figpos.',num2str(num),'.mat'];

if isavar('pos') && isempty(pos)
    delete(figfile);
end
if isafile(figfile)
    pos = load(figfile);
else
    pos = [];
end

return