function gxs = get_GlobalCrossSections
loadCrossSections_global
save([fileparts(which('get_GlobalCrossSections')),filesep,'gxs.mat']);
gxs = load(which('gxs.mat'));
return
