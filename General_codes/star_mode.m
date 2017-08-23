function out = star_mode(s,spc,wls)
while ~exist('s','var')
   s = getfullname('*star.mat','allstarmat','Select an allstarmat file.')
end
if ischar(s)
   while ~exist(s,'file')
      s = getfullname('*star.mat','allstarmat','Select an allstarmat file.')
   end
   s = load(s);
end
if strcmp(lower(spc),'vis')
   file_tags = intersect(fieldnames(s),{'vis_sun','vis_zen','vis_park','vis_forj','vis_cldp','vis_skyp','vis_skya'});
else
   file_tags = intersect(fieldnames(s),{'nir_sun','nir_zen','nir_park','nir_forj','nir_cldp','nir_skyp','nir_skya'});
end
spc = [spc,'_'];
% Do one component first to populate field lists
all_fields = fieldnames(s.(file_tags{end})(1));
fields = {'Str','Md','Zn','Lat','Lon','Alt','Headng','pitch','roll','Tst','Pst','RH','AZstep','El_deg','QdVtot','QdVlr','QdVtb','Tint','raw'};
xfields = setxor(all_fields, fields); xfields(strcmp(xfields,'t'))= [];
out = s.(file_tags{end})(1); 
w = unique(xstar_wl(out)); 
  if all(wls<2)
     wls = interp1(w, [1:length(w)],wls,'nearest','extrap');
  end
  w = w(wls); 
out.raw = out.raw(:,wls); 
out = rmfield(out,xfields);
out.file_tag = repmat(strrep(file_tags(end),spc,''),[size(out.t)]);
s.(file_tags{end})(1) = []; 
if isempty(s.(file_tags{end}))
   s = rmfield(s, file_tags{end});
   file_tags(end) = [];
end

while ~isempty(file_tags)
   file_tag =file_tags{end};file_tags(end) = [];
   for p = 1:length(s.(file_tag))
      outs = s.(file_tag)(p).t; 
      if size(outs,1)==1 outs = outs'; end
      tmp = [out.t; outs];
      [out.t, ij] = unique(tmp);

      for f = 1:length(fields)
         outs = s.(file_tag)(p).(fields{f}); 
         if size(outs,1)==1 outs = outs'; end
         if strcmp(fields{f},'raw')
            outs = outs(:,wls);
            tmp = [out.(fields{f}); outs];
            out.(fields{f}) = tmp(ij,:);            
         else
            tmp = [out.(fields{f}); outs];
            out.(fields{f}) = tmp(ij);
         end
      end     
      tmp = [out.file_tag;repmat({strrep(file_tag,'nir_','')},size(s.(file_tag)(p).t))];
      out.file_tag = tmp(ij);
   end
end
out.rate = xstar_rate(out.raw, out.t, out.Str, out.Tint);
% Then I need to compute Az_deg and El_deg, remove AZstep and Elstep
% Maybe determine if airborne, fill in pressure altitude, and perhaps
% Az_gnd, El_gnd;
sun_sky_El_offset = 3.5; %This represents the known mechanical offset between the sun and sky FOV in elevation.
sun_sky_Az_offset = 0;
out.Az_AC = out.AZstep/(-50); 
out.El_AC = out.El_deg; out.El_AC(out.Str==2) = out.El_AC(out.Str==2) - sun_sky_El_offset;

out = rmfield(out,{'AZstep','El_deg'});

% Maybe easiest to identify when airborne manually ooking at some plots. 
figure; sub(1) = subplot(3,1,1); plot(serial2hs(out.t), out.Alt,'o'); legend('Alt');
sub(2) = subplot(3,1,2); plot(serial2hs(out.t), out.Pst, 'cx'); legend('Pressure');
sub(3) = subplot(3,1,3); plot(serial2hs(out.t), out.Headng, 'r*'); legend('Heading'); 
xlabel('time [UT]'); linkaxes(sub,'x');
out.airborne = true(size(out.t));
menu('Zoom until first airborne point is at left-hand limit. Click "Done" when ready.','Done');
xl = xlim;
out.airborne(serial2hs(out.t)<xl(1)) = false;
menu('Zoom until last airborne point is at right-hand limit. Click "Done" when ready.','Done');
xl = xlim;
out.airborne(serial2hs(out.t)>xl(2)) = false;
   out.Az_gnd = out.Az_AC;  out.El_gnd = out.El_AC;
   warning('Change ac_to_gnd_oracles to general ac_to_gnd function')
   [out.Az_gnd(out.airborne), out.El_gnd(out.airborne)] = ...
      ac_to_gnd_oracles(out.Az_AC(out.airborne), out.El_AC(out.airborne), ...
      out.Headng(out.airborne), out.pitch(out.airborne), out.roll(out.airborne));

% dist_moved = sqrt(real(geodist(out.Lat(1), out.Lon(1),out.Lat, out.Lon)).^2 + (out.Alt(1)-out.Alt).^2);
% course_changed = false(size(out.t));
% course_changed(2:end) = dist_moved(2:end)>0 | diff(out.Headng)~=0 | diff(out.pitch)~=0 | diff(out.roll)~=0;
% 
% if sum(course_changed)>5 && sum(course_changed)./length(course_changed)>0.2
%    out.airborne = true;
%    warning('Change ac_to_gnd_oracles to general ac_to_gnd function')
%    [out.Az_gnd, out.El_gnd] = ac_to_gnd_oracles(out.Az_AC, out.El_AC, out.Headng, out.pitch, out.roll);
% else
%    out.airborne = false;
%    out.Az_gnd = out.Az_AC;  out.El_gnd = out.El_AC;
%    % Less important but we could determine El and Az offsets from
%    % ground data when actually tracking the sun.
% end
out.Az_gnd = mod(out.Az_gnd,360);

% Then, in starsky_scan whether airborne or not, good nav or bad nav, we'll use good 
% sun tracking (Str==1, balanced quads, high enough Qd_tot) to determine an
% offset between where we thought we were pointing and the ephemeris.  And
% correct our Az_true and El_true to agree with the ephemeris 
%********************
%% If Alt is 0 from telemetry, attempt to replace by pressure altitude
[~, out.Alt_pressure] = Alt_from_P(out.Pst);
bad_Alt = (out.Alt==0)&(out.Pst>0);
out.Alt(bad_Alt) = out.Alt_pressure(bad_Alt); 
v=datevec(out.t);
[out.sunaz, out.sunel]=sun(out.Lon, out.Lat,v(:,3), v(:,2), v(:,1), rem(out.t,1)*24,out.Tst+273.15,out.Pst); % Beat's code
out.sza=90-out.sunel;

out.SA = scat_ang_degs(out.sza, out.sunaz, 90-abs(out.El_gnd), out.Az_gnd);


% We want to know:
% 1. Whether we're airborne or on the ground
% And
% 2. When we are tracking the sun and well-locked.
%     So, Str==1, Quad voltages balanced, and SA is small (difference
%     between where we expect the sun to be in aircraft coords and where
%     tracking says it really is)
% 2. When we're not tracking the sun three or four definite outcomes
% 2.1 Sky scanning, report where we are pointing relative to AC and to Gnd
% 2.2 Zenith, report SA and difference between SA and SZA as well as
% difference between El_AC and 90.
% 2.3 When Str==0 or when good and truy parked.  So find Az El positions
% corresponding to Parked. Perhaps look at a flight when I know I parked to
% avoid clouds and see what Az and El were reported.  If spectra are
% collected, how different are they than Str==0 darks. 



% {'nir_sun','nir_zen','nir_park','nir_forj','nir_cldp','nir_skyp','nir_skya'});
% out.state = strcmp(out.part,'sun')&out.Str==1 + 2.*strcmp(out.part,'zen') -1.*strcmp(out.part,'park') + 4.*strcmp(out.part,'forj')+...
%    8.*strcmp(out.part,'cldp') + 16.*strcmp(out.part,'skyp')+32.*strcmp(out.part,'skya');
return