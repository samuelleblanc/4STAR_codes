function [rootpath, codepath] = paths(str)
% Utility function to return the root data path
%
% syntax:   [rootpath, codepath] = paths(str);
%
%   The default with no options is to return both.  Possible string
%   arguments are 'root' and 'code'.
%
% Edit this mfile to reflect your configuration

%     rootpath='c:\work'; % for laptop 2011/10/31
%     codepath='C:\work\code';

if ispc==1 & exist('e:\work\code\'); % external disk used during MIRAGE
    rootpath='e:\work\';
    codepath='e:\work\code';
% % elseif ispc==1 & exist('f:\work\code\'); % external disk used during MIRAGE
% %     rootpath='f:\work\';
% %     codepath='f:\work\code';
% elseif strcmp(computer,'GLNX86')            % Linux, assume Steve Howell's
%                                         % machine
%   rootpath = '/home/showell/projects/intex/';
%   codepath = fullfile(rootpath,'code');
% elseif ispc==1 & exist('D:\install\cdex 1.51\rips\Butterfield Blues Band - I Got A Mind To Give Up Living.mp3')==2; % Mitch's computer in 500 lab.
%     rootpath='D:\yohei 120G backup\work\';
%     codepath='D:\yohei 120G backup\work\code';
elseif ispc==1 & exist('f:\work\code\'); % assume Yohei's MSB404 desktop
    rootpath='f:\work\';
    codepath='f:\work\code';
elseif ispc==1 & exist('g:\work\code\'); % assume Yohei's MSB404 desktop
    rootpath='g:\work\';
    codepath='g:\work\code';
% elseif now<datenum([2005 1 31 0 0 0]); % use the network until the new computer is delivered.
%     rootpath='\\500lab\yahoo 120g\work\';
%     codepath='\\500lab\yahoo 120g\work\code';
elseif ispc==1 & exist('c:\work\code\'); % assume other PC                                % other machine, assume Yohei
    rootpath='c:\work\';
    codepath='c:\work\code';
elseif ispc==1 & exist('e:\code\'); 
    rootpath='e:\';
    codepath='e:\code';
elseif ispc==1 & exist('d:\code\'); % assume other PC                                % other machine, assume Yohei
    rootpath='d:\';
    codepath='d:\code';
elseif ispc==1 & exist('d:\codes\'); % assume other PC                                % other machine, assume Yohei
    rootpath='d:\';
    codepath='d:\codes';
end

if nargin>0 
  if nargin==1 & isstr(str)
    switch str
     case 'root'
      rootpath = rootpath;
     case 'code'
      rootpath = codepath;
     otherwise
      error(['Unrecognized argument ''' str ''' in paths.m']);
    end
  else
    error('paths.m can take zero or one argument only'); 
  end
end
      