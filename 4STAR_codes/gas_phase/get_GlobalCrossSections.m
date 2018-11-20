function gxs = get_GlobalCrossSections
loadCrossSections_global
if ~isafile([fileparts(which('get_GlobalCrossSections')),filesep,'gxs.mat'])
   save([fileparts(which('get_GlobalCrossSections')),filesep,'gxs.mat']);
end
gxs = load(which('gxs.mat'));
return
