function [out,wls_ii] = star_mode(s,spc,wls)
while ~exist('s','var')
   s = getfullname('*star.mat','allstarmat','Select an allstarmat file.')
end
if ischar(s)
   while ~exist(s,'file')
      s = getfullname('*star.mat','allstarmat','Select an allstarmat file.')
   end
   s_ = s; s = load(s); pname = [fileparts(s_),filesep];
end
if strcmp(lower(spc),'vis')
   file_tags = intersect(fieldnames(s),{'vis_sun','vis_zen','vis_park','vis_forj','vis_cldp','vis_skyp','vis_skya'});
else
   file_tags = intersect(fieldnames(s),{'nir_sun','nir_zen','nir_park','nir_forj','nir_cldp','nir_skyp','nir_skya'});
end
spc = [spc,'_'];
% Do one component first to populate field lists
all_fields = fieldnames(s.(file_tags{end})(1));
fields = {'Str','Md','Zn','Lat','Lon','Alt','Headng','pitch','roll','Tst',...
   'Pst','RH','AZstep','El_deg','QdVtot','QdVlr','QdVtb','Tint','raw','Tbox',...
   'Tprecon','RHprecon','Vdettemp'};
xfields = setxor(all_fields, fields); xfields(strcmp(xfields,'t'))= [];
out = s.(file_tags{end})(1); 
w = unique(xstar_wl(out)); w(isnan(w))=[];
  if all(wls<3)||~all(wls==round(wls))
     wls_ii = interp1(w, [1:length(w)],wls,'nearest','extrap');
  else
     wls_ii = wls;
  end
%   w = w(wls); 
out.w = w(wls_ii);
out.raw = out.raw(:,wls_ii); 
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
            outs = outs(:,wls_ii);
            tmp = [out.(fields{f}); outs];
            out.(fields{f}) = tmp(ij,:);            
         else
            tmp = [out.(fields{f}); outs];
            out.(fields{f}) = tmp(ij);
         end
      end     
      tmp = [out.file_tag;repmat({strrep(file_tag,spc,'')},size(s.(file_tag)(p).t))];
      out.file_tag = tmp(ij);
   end
end

out.rate = xstar_rate(out.raw, out.t, out.Str, out.Tint);
% [daystr, filen, datatype,instrumentname]=starfilenames2daystr(s.filename, 1);
% if ~toggle.lampcalib % choose Langley c0
%     [visc0, nirc0, visnotec0, nirnotec0, ~, ~, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(nanmean(s.t),toggle.verbose,instrumentname);     % C0
% else                 % choose lamp adjusted c0
%     [visc0, nirc0, visnotec0, nirnotec0, ~, ~, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0lamp(nanmean(s.t),toggle.verbose,instrumentname); % C0 adjusted with lamp values
% end
% [visresp, nirresp, visnoteresp, nirnoteresp, ~, ~, visaeronetcols, niraeronetcols, visresperr, nirresperr] = starskyresp(nanmean(s.t(1)),instrumentname);
% 
% %Now read in appropriate Co and Resp 
% if strcmp(lower(spc),'vis')
%    out.Co = visc0(wls);
%    out.resp = visresp(wls);
% else
%    out.Co = nirc0(wls);
%    out.resp = nirresp(wls);
%  end


% Then I need to compute Az_deg and El_deg, remove AZstep and Elstep
% Maybe determine if airborne, fill in pressure altitude, and perhaps
% Az_gnd, El_gnd;
% sun_sky_El_offset = 3.5; %This represents the known mechanical offset between the sun and sky FOV in elevation.
% sun_sky_Az_offset = 0;
% out.Az_AC = out.AZstep/(-50); 
% out.El_AC = out.El_deg; out.El_AC(out.Str==2) = out.El_AC(out.Str==2) - sun_sky_El_offset;
% 
% out = rmfield(out,{'AZstep','El_deg'});

if isfield(out, 'RHprecon'); % Yohei, 2012/10/19
    out.RHprecon_percent=out.RHprecon*20;
end;
if isfield(out, 'Tprecon'); % Yohei, 2012/10/19
    out.Tprecon_C=out.Tprecon*23-30;
end;
if isfield(out, 'Tbox'); % Yohei, 2012/10/19
    out.Tbox_C=out.Tbox*100-273.15;
end;
if isfield(out, 'Tplate'); % Yohei, 2012/11/27
    out.Tplate_C=out.Tplate*100-273.15;
end;
% if isfield(out, 'Vdettemp')&&strcmp(lower(spc),'vis') % Yohei, 2013/07/23, from Livingston's plot_4STAR_various.m.
%     B=3450;
%     T2=298;
%     R2=10000;
%     R1=out.Vdettemp/1e-05;
%     out.Vdettemp_C=1./(log(R1./R2)./B+1./T2)-273.17;
% end;
% if isfield(out, 'Vdettemp')&&~strcmp(lower(spc),'vis'); % Yohei, 2013/07/23, from Livingston's plot_4STAR_various.m.
%     Anir=1.2891e-03;
%     Bnir=2.3561e-04;
%     Cnir=9.4272e-08;
%     Rnir=out.Vdettemp/1e-05;  %divide by 10 microamps
%     denom_nir=Anir + Bnir*log(Rnir) + Cnir*((log(Rnir)).^3);
%     ig3=find(out.Vdettemp>0);
%     out.Vdettemp_C=NaN(size(out.t));
%     out.Vdettemp_C(ig3)=1./denom_nir(ig3) - 273.16;
% end;


% Maybe easiest to identify when airborne manually ooking at some plots. 
% figure; sub(1) = subplot(3,1,1); plot(serial2hs(out.t), out.Alt,'o'); legend('Alt');
% sub(2) = subplot(3,1,2); plot(serial2hs(out.t), out.Pst, 'cx'); legend('Pressure');
% sub(3) = subplot(3,1,3); plot(serial2hs(out.t), out.Headng, 'r*'); legend('Heading'); 
% xlabel('time [UT]'); linkaxes(sub,'x');
% out.airborne = true(size(out.t));
% menu('Zoom until first airborne point is at left-hand limit. Click "Done" when ready.','Done');
% xl = xlim;
% out.airborne(serial2hs(out.t)<xl(1)) = false;
% menu('Zoom until last airborne point is at right-hand limit. Click "Done" when ready.','Done');
% xl = xlim;
% out.airborne(serial2hs(out.t)>xl(2)) = false;
%    out.Az_gnd = out.Az_AC;  out.El_gnd = out.El_AC;
%    warning('Change ac_to_gnd_oracles to general ac_to_gnd function')
%    [out.Az_gnd(out.airborne), out.El_gnd(out.airborne)] = ...
%       ac_to_gnd_oracles(out.Az_AC(out.airborne), out.El_AC(out.airborne), ...
%       out.Headng(out.airborne), out.pitch(out.airborne), out.roll(out.airborne));

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
% out.Az_gnd = mod(out.Az_gnd,360);

% Then, in starsky_scan whether airborne or not, good nav or bad nav, we'll use good 
% sun tracking (Str==1, balanced quads, high enough Qd_tot) to determine an
% offset between where we thought we were pointing and the ephemeris.  And
% correct our Az_true and El_true to agree with the ephemeris 
%********************
%% If Alt is 0 from telemetry, attempt to replace by pressure altitude
% [~, out.Alt_pressure] = Alt_from_P(out.Pst);
% bad_Alt = (out.Alt==0)&(out.Pst>0);
% out.Alt(bad_Alt) = out.Alt_pressure(bad_Alt); 
% v=datevec(out.t);
% [out.sunaz, out.sunel]=sun(out.Lon, out.Lat,v(:,3), v(:,2), v(:,1), rem(out.t,1)*24,out.Tst+273.15,out.Pst); % Beat's code
% out.sza=90-out.sunel;
% 
% out.SA = scat_ang_degs(out.sza, out.sunaz, 90-abs(out.El_gnd), out.Az_gnd);
% 
% sun_ = zeros(size(out.t)); sun_(out.Str~=1) = NaN; sun_(~out.airborne) = NaN;
% figure; plot(sun_+out.t, sqrt(out.QdVlr.^2 + out.QdVtb.^2)./out.QdVtot,'o',sun_+out.t, out.SA,'x');
% 
% out.off_zenith = out.SA-(90-out.sunel);


return