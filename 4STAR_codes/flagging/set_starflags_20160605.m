function flags = set_starflags_20160605(inp, flags)
% Should be modified to reflect the desired criterion for specific flights
% or missions

if ~exist('flags','var')
    flags = [];
end
if ~isfield(flags, 'bad_aod')
    flags.bad_aod = false(size(inp.t));
end
if ~isfield(flags, 'unspecified_clouds')
    flags.unspecified_clouds = false(size(inp.t));
end
flags.before_or_after_flight = inp.t<inp.flight(1) | inp.t>inp.flight(2);
flags.unspecified_clouds = inp.aod_500nm>inp.aod_500nm_max | (inp.ang_noscreening<.2 & inp.aod_500nm>0.08) | inp.rawrelstd(:,1)>inp.sd_aero_crit;
flags.bad_aod = inp.aod_500nm<0 | inp.aod_865nm<0 | ~isfinite(inp.aod_500nm) | ~isfinite(inp.aod_865nm) | ~(inp.Md==1) | ~(inp.Str==1) | (inp.m_aero>inp.m_aero_max) | (inp.c0_500nm<=0);
if isfield(inp,'darkstd_500nm')
    flags.bad_aod = flags.bad_aod | (inp.raw_500nm-inp.dark_500nm)<=inp.darkstd_500nm;
end

return