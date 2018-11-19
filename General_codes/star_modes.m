function out = star_modes(s,spc)

% OK, I'll split out the spc type and wls from the spc struct, call
% star_mode once for each one, and merge the results


% Works, but modifying to support both specs by making spc a struct with
% fields vis and nir having wls fields.  
% so spc.vis.wls and spc.nir.wls
% Merge into a single output using unique, perhaps with some rounding  
% And possibly a stage allowing interactive selection of output fields.
while ~exist('s','var')
   s = getfullname('*star.mat','starmat','Select an allstarmat file.')
end
if ischar(s)
   while ~exist(s,'file')
      s = getfullname('*star.mat','starmat','Select an allstarmat file.')
   end
   s_ = s; s = load(s); pname = [fileparts(s_),filesep];
end
if ~exist('spc','var')||~isstruct(spc)||...
      (~any(strcmp(fieldnames(spc),'vis'))&&~any(strcmp(fieldnames(spc),'nir')))
   error('spc is a required input')
end
sfields = fieldnames(s);
filename = [];
sf = 1;
while isempty(filename)&& sf<=length(sfields)
   if ~isempty(s.(sfields{sf}))
      filename = s.(sfields{sf}).filename(1);
      in_time = s.(sfields{sf}).t(1);
   else
      sf = sf +1;
   end
end
   

   [daystr, filen, datatype,instrumentname]=starfilenames2daystr(filename, 1);
   if ~exist('toggle','var') || ~toggle.lampcalib % choose Langley c0
      [visc0, nirc0, visnotec0, nirnotec0, ~, ~, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(in_time,false,instrumentname);     % C0
   else                 % choose lamp adjusted c0
      [visc0, nirc0, visnotec0, nirnotec0, ~, ~, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0lamp(in_time,false,instrumentname); % C0 adjusted with lamp values
   end
   [visresp, nirresp, visnoteresp, nirnoteresp, ~, ~, visaeronetcols, niraeronetcols, visresperr, nirresperr] = starskyresp(in_time,instrumentname);

if any(strcmp(fieldnames(spc),'vis'))&&~any(strcmp(fieldnames(spc),'nir'))
   [out,wls_ii] = star_mode(s,'vis',spc.vis.wls);
   out.Co = visc0(wls_ii);
   out.resp = visresp(wls_ii);
   if isfield(out, 'Vdettemp') 
      out.Vdettemp_vis = out.Vdettemp; out = rmfield(out,'Vdettemp');
      B=3450; T2=298; R2=10000;
      R1=out.Vdettemp_vis/1e-05;
      out.T_det_vis=1./(log(R1./R2)./B+1./T2)-273.17;
   end;
elseif ~any(strcmp(fieldnames(spc),'vis'))&&any(strcmp(fieldnames(spc),'nir'))
   [out,wls_ii] = star_mode(s,'nir',spc.nir.wls);
   out.Co = nirc0(wls_ii);
   out.resp = nirresp(wls_ii);   
   if isfield(out, 'Vdettemp') 
      out.Vdettemp_nir = out.Vdettemp; out = rmfield(out,'Vdettemp');
      Anir=1.2891e-03; Bnir=2.3561e-04; Cnir=9.4272e-08;
      Rnir=out.Vdettemp_nir/1e-05;  %divide by 10 microamps
      denom_nir=Anir + Bnir*log(Rnir) + Cnir*((log(Rnir)).^3);
      ig3=find(out.Vdettemp_nir>0);
      out.T_det_nir=NaN(size(out.t));
      out.T_det_nir(ig3)=1./denom_nir(ig3) - 273.16;
   end;

else % it we must have both
   [out,wls_ii] = star_mode(s,'vis',spc.vis.wls);
   out.Co = visc0(wls_ii);
   out.resp = visresp(wls_ii);   
   [out_,wls_ii] = star_mode(s,'nir',spc.nir.wls);
   out_.Co = nirc0(wls_ii);
   out_.resp = nirresp(wls_ii);
   if isfield(out, 'Vdettemp') &&isfield(out_, 'Vdettemp')
      out.Vdettemp_vis = out.Vdettemp; out = rmfield(out,'Vdettemp');
      out_.Vdettemp_nir = out_.Vdettemp; out_ = rmfield(out_,'Vdettemp');
      out.Vdettemp_nir = interp1(out_.t, out_.Vdettemp_nir,out.t, 'nearest');
      out_.Vdettemp_vis = interp1(out.t, out.Vdettemp_vis,out_.t,'nearest');
      B=3450; T2=298; R2=10000; Anir=1.2891e-03; Bnir=2.3561e-04; Cnir=9.4272e-08;
      R1=out.Vdettemp_vis/1e-05;
      out.T_det_vis=1./(log(R1./R2)./B+1./T2)-273.17;      
      Rnir=out.Vdettemp_nir/1e-05;  %divide by 10 microamps
      denom_nir=Anir + Bnir*log(Rnir) + Cnir*((log(Rnir)).^3);
      out.T_det_nir=NaN(size(out.t));      
      ig3=out.Vdettemp_nir>0;
      out.T_det_nir(ig3)=1./denom_nir(ig3) - 273.16;      
      
      R1=out_.Vdettemp_vis/1e-05;
      out_.T_det_vis=1./(log(R1./R2)./B+1./T2)-273.17;      
      Rnir=out_.Vdettemp_nir/1e-05;  %divide by 10 microamps
      denom_nir=Anir + Bnir*log(Rnir) + Cnir*((log(Rnir)).^3);
      out_.T_det_nir=NaN(size(out.t));      
      ig3=out_.Vdettemp_nir>0;
      out_.T_det_nir(ig3)=1./denom_nir(ig3) - 273.16;      
   end   
   tmp = [out.t; out_.t];
   dt = etime(datevec(tmp),datevec(ones(size(tmp)).*min(tmp)));
   [~,ij,ji] = unique(round(10.*dt)./10);
   out_times = tmp(ij);
   vis_ij = interp1(out_times, [1:length(ij)],out.t,'nearest','extrap');
   nir_ij = interp1(out_times, [1:length(ij)],out_.t,'nearest','extrap');
   fields = fieldnames(out);
   for fld = 1:length(fields)
      field = fields{fld};
   if size(out.(field),2)==1
      tmp = [out.(field);out_.(field)];
      out.(field) = tmp(ij);
   elseif size(out.(field),1)==1
      out.(field) = [out.(field), out_.(field)];
   elseif all(size(out.(field))>1)
      tmp = NaN([size(out_times,1),size(out.(field),2)+size(out_.(field),2)]);
      tmp(vis_ij,[1:size(out.(field),2)]) = out.(field);
      tmp(nir_ij,[1+size(out.(field),2):end]) = out_.(field);
      out.(field) = tmp;
   end
      
   end
   clear out_
end
% Not sure yet how to handle having both spc and wls.  
% spc = [spc,'_'];
% Do one component first to populate field lists

% Then I need to compute Az_deg and El_deg, remove AZstep and Elstep
% Maybe determine if airborne, fill in pressure altitude, and perhaps
% Az_gnd, El_gnd;
sun_sky_El_offset = 3.5; %This represents the known mechanical offset between the sun and sky FOV in elevation.
sun_sky_Az_offset = 0;
out.Az_AC = out.AZstep/(-50); 
out.El_AC = out.El_deg; out.El_AC(out.Str==2) = out.El_AC(out.Str==2) - sun_sky_El_offset;

out = rmfield(out,{'AZstep','El_deg'});

% if isfield(out, 'RHprecon'); % Yohei, 2012/10/19
%     out.RHprecon_percent=out.RHprecon*20;
% end;
% if isfield(out, 'Tprecon'); % Yohei, 2012/10/19
%     out.Tprecon_C=out.Tprecon*23-30;
% end;
% if isfield(out, 'Tbox'); % Yohei, 2012/10/19
%     out.Tbox_C=out.Tbox*100-273.15;
% end;
% if isfield(out, 'Tplate'); % Yohei, 2012/11/27
%     out.Tplate_C=out.Tplate*100-273.15;
% end;
% if isfield(out, 'Vdettemp')&&strcmp(lower(spc),'vis') % Yohei, 2013/07/23, from Livingston's plot_4STAR_various.m.
%     B=3450;
%     T2=298;
%     R2=10000;
%     R1=out.Vdettemp/1e-05;
%     out.T_det_vis=1./(log(R1./R2)./B+1./T2)-273.17;
% end;
% if isfield(out, 'Vdettemp')&&~strcmp(lower(spc),'vis'); % Yohei, 2013/07/23, from Livingston's plot_4STAR_various.m.
%     Anir=1.2891e-03;
%     Bnir=2.3561e-04;
%     Cnir=9.4272e-08;
%     Rnir=out.Vdettemp/1e-05;  %divide by 10 microamps
%     denom_nir=Anir + Bnir*log(Rnir) + Cnir*((log(Rnir)).^3);
%     ig3=find(out.Vdettemp>0);
%     out.T_det_nir=NaN(size(out.t));
%     out.T_det_nir(ig3)=1./denom_nir(ig3) - 273.16;
% end;


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

sun_ = zeros(size(out.t)); sun_(out.Str~=1) = NaN; sun_(~out.airborne) = NaN;
figure; plot(sun_+out.t, sqrt(out.QdVlr.^2 + out.QdVtb.^2)./out.QdVtot,'o',sun_+out.t, out.SA,'x');

out.off_zenith = out.SA-(90-out.sunel);
zen = zeros(size(out.t)); zen(~strcmp(out.file_tag,'zen')) = NaN;zen(out.Str~=2) = NaN;
figure; plot(zen+out.t, 90-out.El_gnd,'o',zen+out.t, out.off_zenith,'x');legend('90-El','Off zenith')

parked = strcmp(out.file_tag,'park'); park = zeros(size(out.t)); park(~parked) = NaN; park(~out.airborne) = NaN;
figure; plot(parked+out.t, out.El_AC, 'o',parked+out.t, out.Az_AC,'x'); legend('El','Az');

out.skyrad = out.rate./(ones(size(out.t))*out.resp);
out.skyrad(out.Str~=2,:) = NaN;
out.Tr_slant = out.rate./(ones(size(out.t))*out.Co);
out.Tr_slant(out.Str~=1,:) = NaN;


outfile = uiputfile([getnamedpath('starmode','Select path for starmode ASCII file',true), '*.dat']);
V = datevec(out.t);
outblock = [V(:,1), V(:,2), V(:,3), serial2hs(out.t)];
out_label = ['year, month, day_of_month, UT'];
format_str = ['%d, %d, %d, %f'];
fields = fieldnames(out);
ex_fields = {'t','file_tag'};
[~, ff] = setxor(fields, ex_fields); ff = sort(ff);
fields_ = fields; fs = 1;
while fs <= length(ff)
   fs = menu('Select fields to output: ',[fields_(ff);{'DONE'}]);
   if fs<=length(ff)
      if isempty(strfind(fields_{ff(fs)},' < NO > '))
         fields_(ff(fs)) = {[fields{ff(fs)}, ' < NO > ']};
      else
         fields_(ff(fs)) = fields(ff(fs));
      end
   end
end
ff = ff(strcmp(fields(ff), fields_(ff)));
for f = 1:length(ff)
   field = fields{ff(f)};
   if all(size(out.t)==size(out.(field)))
      outblock = [outblock, out.(field)];
      out_label = [out_label, ', ',field];
      if islogical(out.(field))
         format_str = [format_str, ', %d'];
      else
         format_str = [format_str, ', %f'];
      end
   end
end
outblock = [outblock, out.rate];
for ww = 1:length(out.w)
   out_label = [out_label, ', ',sprintf('rate_%4.1f_nm',1000.*out.w(ww))];
   format_str = [format_str, ', %f'];
end
outblock = [outblock, out.Tr_slant];
for ww = 1:length(out.w)
   out_label = [out_label, ', ',sprintf('Tr_slant_%4.1f_nm',1000.*out.w(ww))];
   format_str = [format_str, ', %f'];
end
outblock = [outblock, out.skyrad];
for ww = 1:length(out.w)
   out_label = [out_label, ', ',sprintf('skyrad_%4.1f_nm',1000.*out.w(ww))];
   format_str = [format_str, ', %f'];
end
format_str = [format_str, '\n']; 
fid = fopen([getnamedpath('starmode'), ['4STAR_mode.',datestr(out.t(1),'yyyy_mm_dd'), '.dat']],'wt');
% Print the header row to the file
fprintf(fid,'%s \n',out_label );
fprintf(fid,format_str,outblock');
fclose(fid)
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
% 2.3 When Str==0 or when good and truly parked.  So find Az El positions
% corresponding to Parked. Perhaps look at a flight when I know I parked to
% avoid clouds and see what Az and El were reported.  If spectra are
% collected, how different are they than Str==0 darks. 



% {'nir_sun','nir_zen','nir_park','nir_forj','nir_cldp','nir_skyp','nir_skya'});
% out.state = strcmp(out.part,'sun')&out.Str==1 + 2.*strcmp(out.part,'zen') -1.*strcmp(out.part,'park') + 4.*strcmp(out.part,'forj')+...
%    8.*strcmp(out.part,'cldp') + 16.*strcmp(out.part,'skyp')+32.*strcmp(out.part,'skya');
return