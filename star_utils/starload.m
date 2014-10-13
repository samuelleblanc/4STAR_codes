function starload(source, varargin)

% starload(SOURCE, VARIABLES) loads 4STAR data from an existing star.mat
% file.   
% 
% SOURCE, a string, specifies the source mat-file.     
% 
% VARIABLES (optional) use one of the forms accepted by load.m.
% 
% Examples:
%     starload('d:\4star\data\20120717star.mat', 'vis_sun', 'nir_skyp'); 
%     starload('20120717', 'vis_sun', 'nir_skyp'); % same as above as long as the 4STAR matfolder is registered properly in starpaths.m
%     starload('20120717'); % loads all variables from 20120717star.mat.
%
% See also slsun.m, starfinder.m, load.m.
%
% Yohei, 2013/05/14, 2013/06/07, 2013/07/25, 2013/07/26.
% Samuel, v1.0, 2014/10/13, added version control of this m script via
%         version_set, and automatic loading of program_version 

if nargin==0
    file=starfinder('star');
else
    file=starfinder('star', source);
end;
expression=['load(''' file];
for i=1:numel(varargin);
    expression=[expression ''', ''' varargin{i}];
end;
expression=[expression ''', ''' 'program_version'];
expression=[expression ''');'];
evalin('caller', expression);
version_set('1.0');