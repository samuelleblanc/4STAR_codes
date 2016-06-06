function flags = define_flags_20160605(s, flags);
% flags = define_flags_20160605(s, flags);
% define flags for use in visiscreen.  This includes initial population
% of "auto" screens as well as manual flags.

if ~exist(flags,'var')
    flags = [];
end

t = s.t;
w = s.w;

if isfield(s,'flight')
    flight = s.flight;
elseif any(Alt>0)
    flight(1) = t(find(Alt>0,1,'first'));
    flight(2) = t(find(Alt>0,1,'last'));
else
    flight(1) = t(1);
    flight(2) = t(end);
end
inp.flight = flight;
inp.Md = s.Md; 
inp.Str = s.Str;
inp.sd_aero_crit = s.sd_aero_crit;



nm_380 = interp1(w,[1:length(w)],.38, 'nearest');
nm_500 = interp1(w,[1:length(w)],.5, 'nearest');
nm_870 = interp1(w,[1:length(w)],.87, 'nearest');
nm_452 = interp1(w,[1:length(w)],.452, 'nearest');
nm_865 = interp1(w,[1:length(w)],.865, 'nearest');
inp.colsang=[nm_452 nm_865];
inp.ang_noscreening=sca2angstrom(tau_aero_noscreening(:,colsang), w(colsang));
inp.aod_380nm = tau_aero_noscreening(:,nm_380);
inp.aod_452nm = tau_aero_noscreening(:,nm_452);
inp.aod_500nm = tau_aero_noscreening(:,nm_500);
inp.aod_865nm = tau_aero_noscreening(:,nm_865);
inp.aod_500nm_max=3;
inp.m_aero_max=15;
c0 = s.c0;

inp.c0_500nm = c0(nm_500);



% % initializing a logical field
% good_ang = true(size(ang_noscreening));

% % Here is an example of how to use logical flags in succession without
% % overwriting initial results.  If this section is run repeatedly a smaller
% % and smaller subset of "good_ang" values would be true and screened by
% % madf_span.
% [good_ang(good_ang)] = madf_span(ang_noscreening(good_ang),50,3);sum(good_ang)







return

function flags = set_flags(inp, flags)
if ~exist('flags','var')
    flags = [];
end

if ~isfield(flags, 'bad_aod')
    flags.bad_aod = false(size(t));
end
if ~isfield(flags, 'unspecified_clouds')
    flags.unspecified_clouds = false(size(t));
end


flags.before_or_after_flight = inp.t<inp.flight(1) | inp.t>inp.flight(2);
flags.unspecified_clouds = inp.aod_500nm>inp.aod_500nm_max | (inp.ang_noscreening<.2 & inp.aod_500nm>0.08) | inp.rawrelstd(:,1)>inp.sd_aero_crit;
flags.bad_aod = inp.aod_500nm<0 | inp.aod_865nm<0 | ~isfinite(inp.aod_500nm) | ~isfinite(inp.aod_865nm) | ~(inp.Md==1) | ~(inp.Str==1) | (inp.m_aero>inp.m_aero_max) | inp.c0_500nm)<=0;
flags_str.bad_aod = 'aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | c0(:,nm_500)<=0';
if exist('darkstd','var')
    flags.bad_aod = flags.bad_aod | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500);
    flags_str.bad_aod = [flags_str.bad_aod, ' | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500)'];
end



return