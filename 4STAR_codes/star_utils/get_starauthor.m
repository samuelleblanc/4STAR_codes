function [author, askforsourcefolder] = get_starauthor;
%[author, askforsourcefolder] = get_starauthor;
% returns string containing 4STAR author derived from usrpath 
% Also returns "askforsourcefolder" user preference as 2nd output
% 
% Connor, 2017/12/05 
% MODIFICATION HISTORY:
% v1.1, 2020-05-04, Connor: Added Logan as author
%---------------------------------------------------------------------
version_set('1.1');

% get the version of matlab
vv = version('-release');
askforsourcefolder = 0;
usr = lower(userpath);
if ~isempty(strfind(usr,'msegalro')); %
    askforsourcefolder=1; % in allstarmat.m, ask for a folder first; if that request is canceled, ask for files.
    author='Michal';
elseif ~isempty(strfind(usr,'meloe'));
    author='Meloe';
elseif ~isempty(strfind(usr,'qin'));
    author='Qin';
elseif ~isempty(strfind(usr,'d3k014')) || ~isempty(strfind(usr,'connor')) 
    author='Connor';
elseif ~isempty(strfind(usr,'jredeman'));
    author='Jens';
elseif ~isempty(strfind(usr,'livings'));
    author='John';
elseif ~isempty(strfind(usr,'ys')) || ~isempty(strfind(lower(userpath),'yohei'))
    author='Yohei';
elseif ~isempty(strfind(usr,'yohei')); % Yohei's laptop
    author='Yohei';
elseif ~isempty(strfind(usr,'samuel')) || ~isempty(strfind(usr,'sam'))
    author='Samuel';
elseif ~isempty(strfind(usr,'sleblan2'))
    author='Samuel';
elseif ~isempty(strfind(lower(getenv('USER')),'sleblan2')) % for running on pleiades
    author='Samuel';
elseif ~isempty(strfind(usr,'lebla')) % for running on pleiades
    author='Samuel';
elseif ~isempty(strfind(usr,'kpistone'))
    author='Kristina';
elseif ~isempty(strfind(lower(userpath), 'logan'))
    author='Logan';
elseif ~isempty(strfind(lower(userpath), 'sbroccar'))
    author='SteveB';
else
    warning('Update get_starauthor.m');
    author='anon_star_user';
end

return
