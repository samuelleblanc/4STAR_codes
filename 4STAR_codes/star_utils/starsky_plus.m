function s = starsky_plus(s)
%  star = starsky_plus(star)
% Augments a supplied sky scan struct "star" with additional info needed to
% for running the AERONET retrieval
% These include TOD (total optical depth), AOD, AGOD (absorbing gas OD), PWV, Ozone, flight-level
% albedo.

% Might change this create a skyscan struct containing only the relevant
% measurements including time, lat, lon, alt, Az_gnd, El_gnd, SA, scan_type, skyrad,
% anet_dl, CWV, O3_DU, TOD, AOD, AGOD, flt_lev_alb, land_fraction, rad_scale,
% flight_level...

if ~exist('s','var')
   sfile = getfullname('*STARSKY*.mat','starsky','Select star sky mat file.');
   s = load(sfile);
   if isfield(s,'s_out')
      s = s.s_out;
   end
   s.filename  = {sfile};
end
if ~isstruct(s)&&isafile(s)
   filename = s;
   s = load(filename);
   s.filename = {filename};
end

on_ground = ~(geodist(s.Lat(1),s.Lon(1),s.Lat(end),s.Lon(end)) > 100);
in_air = ~on_ground;
if ~isfield(s.toggle,'no_SSFR')
   s.toggle.no_SSFR = false;
end

%This is a bit subtle.  In addition to merely testing for whether we are
%deployed with SSFR (in the toggle), the logic below determines whether
%get_ssfr_flight_albedo came up empty
if in_air && ~s.toggle.no_SSFR
   [flight_alb, out_time] = get_ssfr_flight_albedo(s.t,s.w);
   imgdir = getnamedpath('starimg');
   skyimgdir = [imgdir,s.fstem,filesep];
   fig_out = [skyimgdir, s.fstem,s.created_str,'SSFR_albedo'];
   if ~isadir([imgdir,s.fstem]);
       mkdir(imgdir, s.fstem);
   end
   saveas(gcf,[fig_out,'.fig']);
   saveas(gcf,[fig_out,'.png']);
   ppt_add_slide(s.pptname, fig_out);
end
no_SSFR = ~isavar('flight_alb')||isempty(flight_alb);

if in_air && ~no_SSFR
   s.sfc_alb = flight_alb;
elseif on_ground || no_SSFR
   s.brdf = get_mcd_brdf(s.Lat,s.Lon,s.t, s.Alt);
end

if ~isfield(s,'brdf')&&~isavar('flight_alb')
   % Strange that the above section provides sfc_alb in one case and brdf
   % in another.  Not sure what to provide manually.
   disp('Could not get albedo. Need manual help.')
   %     pause; % Fill in albedo values below, or load from an aeronet ssa file, or get from MODIS, ...
   alb = [0.022960,0.076110,0.336650,0.329370];
   anet_wl = [.44,.675,.87,1.02];
   s.sfc_alb = interp1(anet_wl, alb, s.w);
   in = ~isnan(s.sfc_alb);
   s.sfc_alb(in) = interp1(anet_wl, alb, s.w(in),'pchip');
   s.sfc_alb(~in) = interp1(anet_wl, alb, s.w(~in),'nearest','extrap');
   
end

% if ~isfield(s,'wind_speed')
%     s.wind_speed= 7.5;
% end
% for SEAC4RS
s.ground_level = s.flight_level/1000; % picking very low "ground level" sufficient for sea level or AMF ground level.
s.land_fraction = 1;
% Should replace this with an actual determination based on a land-surface
% mapping.
% s.rad_scale = 1; % This is an adhoc means of adjusting radiance calibration for whatever reason.


return

% Collecting bits of code here that had been in star_anet_aip_process_menu
% and subsequent functions

if iscell(s.filename)
   s.filename = s.filename{1};
end
if isfield(s,'filename')
   [p,skytag,x] = fileparts(s.filename);
   skytag = strrep(skytag,'_VIS_','_');
   skytag = strrep(skytag,'_NIR_','_');
   skytag = strrep(skytag,'_starsky','');
end
pname_mat = getnamedpath('starmat');
if contains(skytag,'_STARSKY')
   skytag = strrep(skytag,'_STARSKY','_aSTARSKY');
end

if ~exist([pname_mat, skytag,'.mat'],'file')
   save([pname_mat, skytag,'.mat'], '-struct','s');
end

star.pname_tagged = pname_tagged;
star.fname_tagged = fname_tagged;

disp(['This selection has been saved to ',fname_tagged]);

% [pname_mat,~,~] = fileparts(sfile);
% if exist([pname_mat, filesep,skytag,'_starsky.mat'],'file')
%    delete([pname_mat, filesep,skytag,'_starsky.mat']);
% end
% save([pname_mat, filesep,skytag,'_starsky.mat'], '-struct','s');
