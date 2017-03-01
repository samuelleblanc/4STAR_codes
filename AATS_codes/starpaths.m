function [matfolder, figurefolder, askforsourcefolder, author]=starpaths

% returns paths for 4STAR folders. 
% Mandatory directory settings:
%   None, to run this code. But to run starsun.m, C0, starinfo and cross
%   section files must exist directly under "matfolder".  
% Recommended directory settings:
%   make 'raw' subfolder under your matfolder.
%   make 'fig' and 'small' subfolders under your figurefolder.
% Yohei, 2012/04/09, 2012/05/18, 2012/10/03

askforsourcefolder=0; % in allstarmat.m, just ask for files.
if ~isempty(strfind(lower(userpath),'michal')); % a problem: userpath does not work on Michal's machine 
    matfolder='C:\MatlabCodes\data\';
    figurefolder='C:\MatlabCodes\4STAR\Figures\';
    askforsourcefolder=1; % in allstarmat.m, ask for a folder first; if that request is canceled, ask for files.
    author='Michal';
elseif ~isempty(strfind(lower(userpath),'meloe')); 
    matfolder='/Users/meloe/Programs.dir/Data.dir/4star.dir/starsun_datafiles/'; 
    figurefolder='/Users/meloe/Programs.dir/Read4star/4starfig'; 
    author='Meloe';
elseif ~isempty(strfind(lower(userpath),'qin')); 
    matfolder='C:\zq_working_baeri\4star\data\';
    figurefolder='C:\zq_working_baeri\4star\figures\';
    author='Qin';
elseif ~isempty(strfind(lower(userpath),'d3k014')) | ~isempty(strfind(lower(userpath),'connor')); 
    matfolder='D:\data\4STAR\yohei\mat\';
    figurefolder='D:\data\4STAR\yohei\img\';
    author='Connor';
elseif ~isempty(strfind(lower(userpath),'jens')); 
    matfolder='c:\Jens\Data\4STAR\data\'; 
    figurefolder='c:\Jens\Data\4STAR\figures\'; 
    author='Jens';
elseif ~isempty(strfind(lower(userpath),'livings')); 
    matfolder=cd; 
    figurefolder=cd; 
    author='John';
elseif ~isempty(strfind(lower(userpath),'ys')) | ~isempty(strfind(lower(userpath),'yohei')) | isequal(lower(getenv('username')), 'yohei')
    if now > datenum(2016,10,10,0,0,0);
    matfolder=fullfile(paths, 'data');
    figurefolder=fullfile(paths, 'figures');
    author='Yohei';
    else;
    matfolder=fullfile(paths, '4star','data');
    figurefolder=fullfile(paths, '4star','figures');
    author='Yohei';
    end;
else
    warning('Update starpaths.m');
    matfolder=cd;
    figurefolder=cd;
    author='';
end;