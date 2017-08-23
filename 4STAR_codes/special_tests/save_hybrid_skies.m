function hybrid_sky = save_hybrid_skies(infile)
% [CW, CCW] = get_hybrid_skies(infile);
% Accepts (or prompts for) a nSTAR file operating in Hybrid mode
% with interspersed direct sun and diffuse sky measurements
% and returns the sky light (grouped by scattering angle) as a function of time and airmass
% Under CW and CCW, returns static wavelength and SA_hybrid arrays and an 
% array of struct SA containing t and rate. 

% Testing on file...
% pname = ['C:\case_studies\4STAR\data\20170604_MLO_day10pm\4STAR\'];
% s4_fname = ['4STAR_20170604star.mat'];



while ~exist('infile','var')||~exist(infile,'file')
   infile = getfullname_('?STAR*.mat','MLO');
end
[pname, s4_fname, ext] = fileparts(infile);
starn = strtok(s4_fname,'_');
pname = [pname, filesep]; s4_fname = [s4_fname ext];
xs4 = load([pname,s4_fname],'vis_sun', 'nir_sun');
xs4.vis_sun.wl = xstar_wl(xs4.vis_sun);
xs4.nir_sun.wl = xstar_wl(xs4.nir_sun);

xs4.vis_sun.rate =xstar_rate(xs4.vis_sun.raw, xs4.vis_sun.t, xs4.vis_sun.Str, xs4.vis_sun.Tint);
xs4.nir_sun.rate =xstar_rate(xs4.nir_sun.raw, xs4.nir_sun.t, xs4.nir_sun.Str, xs4.nir_sun.Tint);

[xs4.sza, xs4.saz, xs4.soldst, ~, ~, xs4.sel, xs4.am] = sunae(xs4.vis_sun.Lat, xs4.vis_sun.Lon, xs4.vis_sun.t);
% [xs4.m_ray, xs4.m_aero, xs4.m_H2O]=airmasses(xs4.sza, xs4.vis_sun.Alt);
% % MLO local pressure on 2017/06/07: mlo_met_metric.jpg = 683.2 mb
% xs4.vis_sun.Pst = xs4.vis_sun.Pst + 683.2;
% [xs4.vis_sun.tau_ray]=rayleighez(xs4.vis_sun.wl,xs4.vis_sun.Pst,xs4.vis_sun.t,xs4.vis_sun.Lat); % Rayleigh
% xs4.vis_sun.tr = tr(xs4.m_ray, xs4.vis_sun.tau_ray);
% xs4.nir_sun.Pst = xs4.nir_sun.Pst + 683.2;
% [xs4.nir_sun.tau_ray]=rayleighez(xs4.nir_sun.wl,xs4.nir_sun.Pst,xs4.nir_sun.t,xs4.nir_sun.Lat); % Rayleigh
% xs4.nir_sun.tr = tr(xs4.m_ray, xs4.nir_sun.tau_ray);
% tr(s.m_ray, s.tau_ray)

Str0 = zeros(size(xs4.vis_sun.t)); Str0(xs4.vis_sun.Str~=0) = NaN;
Str1 = zeros(size(xs4.vis_sun.t)); Str1(xs4.vis_sun.Str~=1) = NaN;
Str2 = zeros(size(xs4.vis_sun.t)); Str2(xs4.vis_sun.Str~=2) = NaN;

xs4.dEl = xs4.sel -xs4.vis_sun.El_deg;
xs4.dAz = xs4.saz -xs4.vis_sun.AZ_deg;
quad_locked = xs4.vis_sun.Str==1 & abs(xs4.vis_sun.QdVlr./xs4.vis_sun.QdVtot) < 0.015 ...
   & abs(xs4.vis_sun.QdVtb./xs4.vis_sun.QdVtot) < 0.015;
xs4.dEl(~quad_locked) = interp1(xs4.vis_sun.t(quad_locked), xs4.dEl(quad_locked), xs4.vis_sun.t(~quad_locked), 'pchip','extrap');
xs4.dAz(~quad_locked) = interp1(xs4.vis_sun.t(quad_locked), xs4.dAz(quad_locked), xs4.vis_sun.t(~quad_locked), 'pchip','extrap');

% Add titles or something to distinuish the value of some of these panels,
% esp the center panel and panels 2,3 in second figure

figure_; sb(1) = subplot(3,1,1);
plot(serial2hs(xs4.vis_sun.t), Str1+xs4.vis_sun.QdVlr./xs4.vis_sun.QdVtot,'x',...
   serial2hs(xs4.vis_sun.t), Str1+xs4.vis_sun.QdVtb./xs4.vis_sun.QdVtot,'r*');
legend('Qd LR','Qd TB');  ylabel('mV');
sb(2) = subplot(3,1,2);
plot(serial2hs(xs4.vis_sun.t), xs4.dEl +Str1,'o',serial2hs(xs4.vis_sun.t), xs4.dEl +Str2,'r*');
legend('El - SolEl, Quad-locked, interpolated to Sky');
sb(3) = subplot(3,1,3);
plot(serial2hs(xs4.vis_sun.t), xs4.dAz +Str1,'x',serial2hs(xs4.vis_sun.t), xs4.dAz +Str2,'r*');
legend('Az - SolAz, Quad-locked, interpolated to Sky')

% [xs4.sza, xs4.saz, xs4.soldst, ~, ~, xs4.sel, xs4.am]
% The scattering angles below are corrected for instantaneous quad-locked
% offsets and for az_sun_sky offset of 3 deg.
SA = scat_ang_degs(xs4.sza, xs4.saz, 90 - (xs4.vis_sun.El_deg +xs4.dEl) , xs4.vis_sun.AZ_deg+xs4.dAz);
SA(xs4.vis_sun.Str==2) = scat_ang_degs(xs4.sza(xs4.vis_sun.Str==2), xs4.saz(xs4.vis_sun.Str==2),...
   90 - (xs4.vis_sun.El_deg(xs4.vis_sun.Str==2) +xs4.dEl(xs4.vis_sun.Str==2) - 3) , ...
   xs4.vis_sun.AZ_deg(xs4.vis_sun.Str==2)+xs4.dAz(xs4.vis_sun.Str==2));
figure_
sb(4) = subplot(3,1,1);
plot(serial2hs(xs4.vis_sun.t), xs4.vis_sun.Str,'-o');legend('Shutter')

sb(5) = subplot(3,1,2);
plot(serial2hs(xs4.vis_sun.t),xs4.dEl- xs4.sel +xs4.vis_sun.El_deg + Str2 -3,'c*',...
   serial2hs(xs4.vis_sun.t), xs4.dAz - xs4.saz +xs4.vis_sun.AZ_deg + Str2,'*');legend('Delta Sky Angle');
title('The observation Az and El of the sky views')
legend('El','Az')
ylabel('deg');

sb(6) = subplot(3,1,3);
plot(serial2hs(xs4.vis_sun.t), SA + Str1,'*',serial2hs(xs4.vis_sun.t), SA + Str2,'c*');legend('sun','sky');

ylabel('scat ang [deg]');
xlabel('time [UT]');
figure_
sb(7) = subplot(2,1,1);
plot(serial2hs(xs4.vis_sun.t), xs4.vis_sun.rate(:,400)+Str1, 'o'); legend('sun');
sb(8) = subplot(2,1,2);
plot(serial2hs(xs4.vis_sun.t), xs4.vis_sun.rate(:,400)+Str2, 'cx'); legend('sky');

linkaxes(sb,'x');
ok = menu('Zoom in to select a region when hybrid mode was operational','OK, done');
xl = xlim;xl_ = serial2hs(xs4.vis_sun.t)>=xl(1) & serial2hs(xs4.vis_sun.t)<= xl(2);

% Might need to be careful here about CW and CCW

SA_round = 4.*round(.25.*SA(xs4.vis_sun.Str==2&serial2hs(xs4.vis_sun.t)>xl(1)&serial2hs(xs4.vis_sun.t)<xl(2)));
SA_hybrid = unique(SA_round);

for s = length(SA_hybrid):-1:1
   if sum(SA_round==SA_hybrid(s))<4 % made this <4 to mitigate CW/CCW issues
      SA_hybrid(s) = [];
   end
end
% Now we have a concise list of all the intended scattering angles
% (assuming only integer targets were specified and drift during sequence
% was < 0.5 deg)
SA_ = false(size(SA)); SA_(xs4.vis_sun.Str==2 & xl_) = true;
% xs4.dAz - xs4.saz +xs4.vis_sun.AZ_deg
CW_ = (xs4.dAz - xs4.saz +xs4.vis_sun.AZ_deg)>1 & SA_; 
CCW_ = (xs4.dAz - xs4.saz +xs4.vis_sun.AZ_deg)<-1 & SA_;
SA_CW_ = SA_&CW_; SA_CCW_ = SA_&CCW_;
% Identify leading and trailing edges of different SA orientations
for s = length(SA_hybrid):-1:1   
   CW_edge_i = false(size(xs4.vis_sun.t)); % leading edge
   CW_edge_j = CW_edge_i; % trailing edge
   CCW_edge_i = CW_edge_i; CCW_edge_j = CCW_edge_i;
   CW_edge_i(2:end) = SA_CW_(1:end-1)==0 & SA_CW_(2:end)==1 & floor(round(SA(2:end)))==SA_hybrid(s); CW_edge_i = find(CW_edge_i);
   CCW_edge_i(2:end) = SA_CCW_(1:end-1)==0 & SA_CCW_(2:end)==1 & floor(round(SA(2:end)))==SA_hybrid(s); CCW_edge_i = find(CCW_edge_i);
   CW_edge_j(1:end-1) = SA_CW_(1:end-1)==1 & SA_CW_(2:end)==0 & floor(round(SA(1:end-1)))==SA_hybrid(s); CW_edge_j = find(CW_edge_j);
   CCW_edge_j(1:end-1) = SA_CCW_(1:end-1)==1 & SA_CCW_(2:end)==0 & floor(round(SA(1:end-1)))==SA_hybrid(s); CCW_edge_j = find(CCW_edge_j);
   CW_edge_j(CW_edge_j<CW_edge_i(1)) = []; CW_edge_i(CW_edge_i>CW_edge_j(end)) = [];
   CCW_edge_j(CCW_edge_j<CCW_edge_i(1)) = []; CCW_edge_i(CCW_edge_i>CCW_edge_j(end)) = [];
   CW_len = min([length(CW_edge_i),length(CW_edge_j)]);
   if isfield(xs4,'vis_sun')&&isfield(xs4,'nir_sun')
      wl = [xs4.vis_sun.wl,xs4.nir_sun.wl];
      %Flip 4STAR NIR left-to-right
      if ~strcmp(starn,'4STARB')&&strcmp(starn,'4STAR')
         rate = [xs4.vis_sun.rate, fliplr(xs4.nir_sun.rate)];
      else
         rate = [xs4.vis_sun.rate, xs4.nir_sun.rate];
      end
      xs4.t = xs4.vis_sun.t;
   elseif isfield(xs4,'vis_sun');
      wl = xs4.vis_sun.wl;
      rate = xs4.vis_sun.rate;
      xs4.t = xs4.vis_sun.t;
   elseif isfield(xs4,'nir_sun');
      wl = xs4.nir_sun.wl;
      rate = xs4.nir_sun.rate;
      xs4.t = xs4.nir_sun.t;
   end 
   % For each bounded portion, take robust IQ mean, mean, or single
   % measurement depending on how many measurements were taken
   for c = CW_len:-1:1
      CW.SA_hybrid(s) = SA_hybrid(s);
      CW.wl = wl;
      bounds = CW_edge_i(c):CW_edge_j(c);
      if length(bounds)<3
         CW.SA{s}.t(c,1) = xs4.t(bounds(end));
         CW.SA{s}.rate(c,:) = rate(bounds(end),:);
      else
         good_bounds = IQ(rate(bounds,400),.2);
         bounds = bounds(good_bounds);
      end
      if length(bounds)==1
         CW.SA{s}.t(c,1) = xs4.t(bounds(end));
         CW.SA{s}.rate(c,:) = rate(bounds(end),:);         
      else
         CW.SA{s}.t(c,1) = mean(xs4.t(bounds))';
         CW.SA{s}.rate(c,:) = mean(rate(bounds,:));         
      end
   end
   CCW_len = min([length(CCW_edge_i),length(CCW_edge_j)]);
   for cc = CCW_len:-1:1
      CCW.SA_hybrid(s) = SA_hybrid(s);
      CCW.wl = wl;
      bounds = CCW_edge_i(cc):CCW_edge_j(cc);
      if length(bounds)<3
         CCW.SA{s}.t(cc,1) = xs4.t(bounds(end));
         CCW.SA{s}.rate(cc,:) = rate(bounds(end),:);
      else
         good_bounds = IQ(rate(bounds,400),.2);
         bounds = bounds(good_bounds);
      end
      if length(bounds)==1
         CCW.SA{s}.t(cc,1) = xs4.t(bounds(end));
         CCW.SA{s}.rate(cc,:) = rate(bounds(end),:);         
      else
         CCW.SA{s}.t(cc,1) = mean(xs4.t(bounds));
         CCW.SA{s}.rate(cc,:) = mean(rate(bounds,:));         
      end
   end   
end

for cc = length(CCW.SA):-1:1
   if length(CCW.SA{cc}.t)<2
      CCW.SA_hybrid(cc) = [];
      CCW.SA(cc) = [];
   end
end
for cc = length(CW.SA):-1:1
   if length(CW.SA{cc}.t)<2
      CW.SA_hybrid(cc) = [];
      CW.SA(cc) = [];
   end
end

hybrid_sky.CW = CW; hybrid_sky.CCW = CCW;
save([pname, strrep(s4_fname,'star.mat','_hybridsky.mat')],'-struct','hybrid_sky');

return
