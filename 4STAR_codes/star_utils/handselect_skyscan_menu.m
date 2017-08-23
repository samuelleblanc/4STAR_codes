function star = handselect_skyscan_menu(star)
% Manually select data points in a sky scan.  This might look a lot like
% starsky_scan
% s = handscreen_skyscan(s)
% apply manual/graphical screen to sky scan to eliminate bad angles.
% this uses the current star struct, not my old one

% Modified "handselect_skyscan" to add menu selection that will permit
% selection of desired parameters and re-use of others
% This may facilitate sensitivity tests and or bracketing conditions
% Adding option to modify AOD which requires access to starsun file
%

% Parameteters to adjust:
% PWV
% Ozone
% tau
% wavelengths
% scattering angles

done = false;
star.wl_ = false(size(star.w));
star.wl_(star.aeronetcols) = true;
star.wl_ii = find(star.wl_);

fini = false;
%
if isfield(star,'O3col')
   O3_str = sprintf('Ozone <%0.0f DU>',1000.*star.O3col);
else O3_str = 'Ozone <Needed>';end

if isfield(star,'PWV')
   PWV_str = sprintf('PWV <%0.1f cm>',star.PWV);
else PWV_str = 'PWV <Needed>';
end

   % When we have SSFR, use land_fraction = 1 along with SSFR-derived flight level albedo
   star.land_fraction = 1;
   % for SEAC4RS should replace this with an actual determination based on a land-surface
   % mapping.
   
   % Wind speed will only have relevance when not flying with SSFR since it is
   % used to infer a sea-surface SA as a function of wind-speed.
   if ~isfield(star,'wind_speed')
      star.wind_speed= 7.5;
   end
   
   star.rad_scale = 1; % This is an adhoc means of adjusting radiance calibration for whatever reason.
   star.ground_level = star.flight_level/1000; % picking very low "ground level" sufficient for sea level or AMF ground level.
   % Should replace this with an actual determination based on a land-surface mapping.
   % Both gen_sky_inp_4STAR and gen_aip_cimel_need to be modified.
   % This is trickier than it looks because of the ability in selecting SA
   % to exclude wavelength-specific points, not just specific SA.  
   star = select_skyscan_wl(star);
   star = select_skyscan_SA(star);
%       good_sky = star.good_sky;
%       skymask = star.skymask;
%    good_sky = false(size(star.good_sky*star.wl_ii));
%    good_sky(star.good_sky,:) = true;
%    skymask = ones(size(star.skyrad(:,star.wl_)));
%    skymask(~good_sky) = NaN;

while ~fini
   if isfield(star,'O3col')&&isfield(star,'PWV')&&isfield(star,'tau')&&isfield(star,'SA')&&isfield(star,'w')
      mn = menu('MODIFY: ', 'Wavelengths','Angles','Tau',PWV_str,O3_str,'Save input file with these settings.')
   else
      mn = menu('MODIFY: ', 'Wavelengths','Angles','Tau',PWV_str,O3_str);
   end
   if mn==1 %select wavelengths
      star = select_skyscan_wl(star);
%       good_sky = false(size(star.good_sky*star.wl_ii));
%       good_sky(star.good_sky,:) = true;
%       skymask = ones(size(star.skyrad(:,star.wl_)));
%       skymask(~good_sky) = NaN;
   elseif mn==2  %select scattering angles
      star = select_skyscan_SA(star);
%       good_sky = star.good_sky;
%       skymask = star.skymask;
   elseif mn==3 % select TAU
      star = select_skyscan_tau(star);
   elseif mn==4 % select PWV
      star = select_skyscan_CWV(star);
      PWV_str = sprintf('PWV <%3.2f>',star.PWV);
   elseif mn==5 % select O3
      star = select_skyscan_ozone(star);
      if star.O3col>1
         star.O3col = star.O3col./1000;
      end
      O3_str = sprintf('Ozone <%3.1f>',1000.*star.O3col);
   elseif mn==6 % must be done!
         pname_tagged = 'C:\z_4STAR\work_2aaa__\4STAR_\';
   if isfield(star,'filename')
      if iscell(star.filename)
         [p,skytag,x] = fileparts(star.filename{1});
      else
         [p,skytag,x] = fileparts(star.filename);
      end
      skytag = strrep(skytag,'_VIS_','_');skytag = strrep(skytag,'_NIR_','_');
   end
   tag = strrep([skytag,'.created_',datestr(now, 'yyyymmdd_HHMMSS'),'..'],'4STAR_','');
   desc = input('Add a text tag for this input file (such as "alm_L", alm_R", "superset", "subset",...): ','s');
%    if isempty(desc)
%       tag = strrep(tag,'..','.');
%       else
      tag = strrep(tag, '..', ['.',desc,'.']);
%    end
   fname_tagged = ['4STAR_.',tag, 'input'];
   star.pname_tagged = pname_tagged;
   star.fname_tagged = fname_tagged;
   [inp, line_num] = gen_sky_inp_4STAR(star);
   disp(['This selection has been saved to ',fname_tagged]);
   %%
   again = menu('Define another?',['No, I''m done'],'Yes, another');
   if again == 1
      fini = true;
   end

      
      %       fini = true;
   else % Anything to do?
   end
   
   
   
   % good_time_base = star.Str==2&star.El_gnd>0 ;
   % semilogy(DA(star.Str==2&good_time_base&star.good_almA), ...
   %     star.skyrad(star.Str==2&good_time_base&star.good_almA,wl_),'-o',...
   %     DA(star.Str==2&good_time_base&star.good_almB), ...
   %     star.skyrad(star.Str==2&good_time_base&star.good_almB,wl_),'-x');
   
   %     below = ((star.sunel - star.SA)-star.El_gnd)<1;
   
   %%
end % fini
return