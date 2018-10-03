function fig_names = plot_toggles(toggles);
%% Details of the program:
% NAME:
%   plot_toggles
%
% PURPOSE:
%  creates a figure with the toggles and their states indicated
%
% INPUT:
%  toggles:  struct of toggles
%
% OUTPUT:
%  single figure (png) with toggle states
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - sNone
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA P3, Lat: 14.15°N ,Lon: 52.9°W, 2018-09-22
%                 
% -------------------------------------------------------------------------

fig = figure();
plot([0,0],[0,0]); hold on;
fl = fields(toggles);
set(groot, 'defaultLegendInterpreter','none');
r = {};
for i=1:length(fl);
    plot([0,0],[0,0])
    r{i} = [[fl{i}(:)]' ': ' num2str(toggles.(fl{i})) ];
end;
legend(r,'boxoff','ncols',2)

return