function slsun(source, varargin)

% slsun(SOURCE, VARIABLES) loads 4STAR Sun data from an existing
% starsun.mat file. 
% 
% SOURCE, a string, specifies the source starsun.mat file.   
% 
% VARIABLES (optional) use one of the forms accepted by load.m.
% 
% Examples:
%     slsun('d:\4star\data\20120717starsun.mat','t','w','tau_aero');
%     slsun('20120717','t','w','tau_aero'); % same as above as long as the 4STAR matfolder is registered properly in starpaths.m
%     slsun('20120717'); % loads all variables from 20120717starsun.mat.
%
% See also starload.m, starfinder.m, load.m.
%
% Yohei, 2013/07/26

if nargin==0
    source=starfinder('starsun');
elseif exist('source','var') && ~exist(source,'file')
    source=starfinder('starsun', source);
end;
expression=['load(''' source];
for i=1:numel(varargin);
    expression=[expression ''', ''' varargin{i}];
end;
expression=[expression ''');'];
evalin('caller', expression);

return