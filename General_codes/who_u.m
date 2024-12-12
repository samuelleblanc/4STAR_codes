function author = who_u

if ~isempty(strfind(lower(userpath),'msegalro')); %
    askforsourcefolder=1; % in allstarmat.m, ask for a folder first; if that request is canceled, ask for files.
    author='Michal';
elseif ~isempty(strfind(lower(userpath),'meloe'));
    author='Meloe';
elseif ~isempty(strfind(lower(userpath),'qin'));
    author='Qin';
elseif ~isempty(strfind(lower(userpath),'d3k014')) || ~isempty(strfind(lower(userpath),'connor')) 
    author='Connor';
elseif ~isempty(strfind(lower(userpath),'jredeman'));
    author='Jens';
elseif ~isempty(strfind(lower(userpath),'livings'));
    author='John';
elseif ~isempty(strfind(lower(userpath),'ys')) || ~isempty(strfind(lower(userpath),'yohei'))
    author='Yohei';
elseif ~isempty(strfind(lower(userpath),'yohei')); % Yohei's laptop
    author='Yohei';
elseif ~isempty(strfind(lower(userpath),'samuel')) || ~isempty(strfind(lower(userpath),'sleblanc')) || ~isempty(strfind(lower(userpath),'lebla')); % Sam's laptop
    author='Samuel';
elseif ~isempty(strfind(lower(userpath),'sleblan2'))
    author='Samuel';
elseif ~isempty(strfind(lower(getenv('USER')),'sleblan2')) % for running on pleiades
    author='Samuel';
elseif ~isempty(strfind(lower(userpath),'kpistone'))
    author='Kristina';
else
    warning('Update who_u.m');
    author='anon_star_user';
end;

return