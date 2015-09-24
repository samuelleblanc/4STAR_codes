%% Details of the program:
% NAME:
%   FOV_scan
% 
% PURPOSE:
%   Creates carpet plots of a single FOV at a time, and multiple other
%   plots
%
% CALLING SEQUENCE:
%  ins = FOV_scan(ins)
%
% INPUT:
%  - ins: vis or nir _fova or fovp data structure (vis_fovp)
% 
% OUTPUT:
%  - ins: output structure, with a few added fields
%
% DEPENDENCIES:
%  - starwavelengths.m
%  - scat_ang_degs.m
%  - version_set.m
%  - convert_star_to_rd_spc
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Connor Flynn, Date unknown - before March 24th, 2014, PNNL
% Modified: by Samuel LeBlanc, August 15th, 2014, Happy Acadian Day!
%           - made the code compatible with current star structures,
%           removed dependencies on rd_spc routines.
%           - added comments
% Modified (v1.0): by Samuel LeBlanc, October, 13th, 2014, NASA Ames
%           - added version_set for m script version control
% Modified (v1.1): by Samuel LeBlanc, November 25th, 2014, NASA Ames
%           - modified the call to the scat_and_degs - it was erronous.
%           - the scattering angle calculation is now based on epheremis
%           calculated sun position with the offset from 4STAR.
% Modified (v1.2): by Samuel LeBlanc, December 5th, 2014, NASA Ames
%           - slight modifications to plotting of the line FOV.
% Modified (v1.3): by Samuel LeBlanc, August 27th, 2015, NASA Ames
%           - small bug fix in plotting
%
% -------------------------------------------------------------------------

%% Start of code

function ins = FOV_scan(ins)
version_set('1.3');

%% legacy code
% 
% if ~exist('infile','var')
% ins = rd_spc_F4_v2(getfullname('*FOV*.dat','Star_FOV'));
% close(gcf);
% else
%    if ~isstruct(infile)
%    ins = rd_spc_F3(infile);
%    else
%       ins = infile; 
%       infile = [ins.pname, ins.fname];
%    end
% end
% ins = read_flight_FOV;

%% Set correct variables
% ins = ins.raw;
ins.AZ_deg = -1.*ins.AZstep./50;
ins.Az_deg = ins.AZ_deg;
ins.El_deg = -1.*ins.Elstep*360/5e4;
ins.minEl = min(ins.El_deg(ins.Str>0));
ins.maxEl = max(ins.El_deg(ins.Str>0));
ins.rangeEl = ins.maxEl-ins.minEl;
ins.minAz = min(ins.AZ_deg(ins.Str>0));
ins.maxAz = max(ins.AZ_deg(ins.Str>0));
ins.rangeAz = ins.maxAz-ins.minAz;
ins.Vscan = ins.rangeEl>ins.rangeAz;

%% set variables from new 4STAR analysis software to match old code
ins=convert_star_to_rd_spc(ins);

%%
tracking = (abs(ins.QdVlr./ins.QdVtot)<0.02) & (abs(ins.QdVtb./ins.QdVtot)<0.02) & (ins.QdVtot>.5)&(ins.Str==1) & (ins.Str>0);
ic = find(tracking);
icenter = ic(ceil(end/2));
rec = [1:length(tracking)]';
if any(tracking)
    scan = ~tracking & (rec>min(rec(tracking)))&(rec<max(rec(tracking)))&ins.Str~=0;
   % scan(icenter) = true;
else
    scan = true(size(tracking));
    scan([1:3 end-2:end]) = false;
end
%%
figure('position',[80,80,1400,500]); 
sb(1) = subplot(2,2,1);
plot([1:length(ins.QdVlr)], [ins.QdVlr./ins.QdVtot, ins.QdVtb./ins.QdVtot], '+',...
    rec(scan), ins.QdVlr(scan)./ins.QdVtot(scan),'ro',...
    rec(~tracking&~scan), ins.QdVlr(~tracking&~scan)./ins.QdVtot(~tracking&~scan),'k-x',...
    rec(ins.Str==0), ins.QdVlr(ins.Str==0)./ins.QdVtot(ins.Str==0),'ko');
legend('LR/Tot','TB/Tot');
% title(ins.fname,'interp','none')
title(ins.filename{:},'interp','none')
sb(2) = subplot(2,2,3);
plot([1:length(ins.QdVlr)],[ins.AZ_deg-mean(ins.AZ_deg(tracking)), ins.El_deg-mean(ins.El_deg(tracking))], '-o');
legend('Az deg','El deg');
linkaxes(sb,'x');
ylim(sb(1),[-.1,.1]);
%%
% tracking = (abs(ins.QdVlr./ins.QdVtot)<0.02) & (abs(ins.QdVtb./ins.QdVtot)<0.02) & (ins.QdVtot>.5);
% rec = [1:length(tracking)]';
% if any(tracking)
% scan = ~tracking & (rec>min(rec(tracking)))&(rec<max(rec(tracking)))&ins.Str~=0;
% else
%     scan = true(size(tracking));
%     scan([1:3 end-2:end]) = false;
% end
%%
El_fit_range = scan&abs(ins.El_deg-mean(ins.El_deg(tracking)))<=1;
El_range = ins.El_deg(El_fit_range)-mean(ins.El_deg(El_fit_range));
P_LR = polyfit(El_range, ins.QdVlr(El_fit_range)./ins.QdVtot(El_fit_range),1);
P_TB = polyfit(El_range, ins.QdVtb(El_fit_range)./ins.QdVtot(El_fit_range),1);

Az_fit_range = scan&abs(ins.AZ_deg-mean(ins.AZ_deg(tracking)))<=1;
Az_range = ins.AZ_deg(Az_fit_range)-mean(ins.AZ_deg(Az_fit_range));
P_LR_a = polyfit(Az_range, ins.QdVlr(Az_fit_range)./ins.QdVtot(Az_fit_range),1);
P_TB_a = polyfit(Az_range, ins.QdVtb(Az_fit_range)./ins.QdVtot(Az_fit_range),1);

%%
%figure; 
sb(3) = subplot(2,2,2);
plot(rec(tracking), [ins.QdVlr(tracking)./ins.QdVtot(tracking), ins.QdVtb(tracking)./ins.QdVtot(tracking)], 'o',...
    rec(scan), ins.QdVlr(scan)./ins.QdVtot(scan)./P_LR(1),'.r-',...
    rec(scan), ins.QdVtb(scan)./ins.QdVtot(scan)./P_TB(1),'.m-',...
    rec(~tracking&~scan), ins.QdVlr(~tracking&~scan)./ins.QdVtot(~tracking&~scan),'k-x',...
    rec(ins.Str==0), ins.QdVlr(ins.Str==0)./ins.QdVtot(ins.Str==0),'k.');
lg = legend('LR/Tot','TB/Tot', 'LR / P_LR','TB / P_TB'); set(lg,'interp','none')
title(ins.fname,'interp','none')
sb(4) = subplot(2,2,4);
plot([1:length(ins.QdVlr)],[ins.AZ_deg-mean(ins.AZ_deg), ins.El_deg-mean(ins.El_deg)], '-o');
legend('Az deg','El deg');
linkaxes(sb,'x');
%%
% figure; plot(ins.nm, ins.spectra(ins.Str==1,:),'-',ins.nm, ins.spectra(ins.Str==0,:),'k-')

%%
ins.spectra=ins.raw; %!!!
ins.time=ins.t; %!!!
if ~isempty(findstr(ins.filename{:}, 'VIS'))
    ins.is_vis=1;
else
    ins.is_vis=0;
end;
%!!!
if sum(ins.Str==0)==0
    darks = min(ins.spectra);
else 
    if sum(ins.Str==0)==1
        darks = ins.spectra(ins.Str==0,:);
    else
        darks = mean(ins.spectra(ins.Str==0,:));
    end
end

%%
good_t = scan;
ins.minCCD = darks;
ins.maxCCD = max(ins.spectra(good_t,:));
ins.rangeCCD = ins.maxCCD-ins.minCCD;
ins.CCD_norm = (ins.spectra - ones(size(ins.time))*ins.minCCD)./(ones(size(ins.time))*ins.rangeCCD);

if ins.is_vis
   good_pix = (ins.rangeCCD>1000)&(rem([1:length(ins.nm)],100)==0);
else
   good_pix = (ins.rangeCCD>100)&(rem([1:length(ins.nm)],50)==0);
end

if ~any(good_pix);
    disp('*** No good pixels found, showing more')
    good_pix = (ins.rangeCCD>5)&(rem([1:length(ins.nm)],50)==0);
end;
%%   
%scat_ang_degs(sza, saz, za, az) 
%sza = 90-interp1(abs(ins.El_deg(icenter)).*ones(size(ins.AZ_deg));
%sza = interp1(ins.t(tracking),90-abs(ins.El_deg(tracking)),ins.t,'linear','extrap')
dza = (90-abs(ins.El_deg(icenter))) - (90-ins.sunel(icenter))
sza = (90-abs(ins.sunel)) + dza
%saz = abs(ins.AZ_deg(icenter)).*ones(size(ins.AZ_deg));
%saz = interp1(ins.t(tracking),abs(ins.AZ_deg(tracking)),ins.t,'linear','extrap')
daz = ins.Az_deg(icenter) - ins.sunaz(icenter)
saz = ins.sunaz + daz

ins.SA = scat_ang_degs(sza,saz,90.0-abs(ins.El_deg),ins.AZ_deg)
   
 % Old code  
 %  ins.SA = scat_ang_degs(90-mean(abs(ins.El_deg)).*ones(size(ins.AZ_deg)), ins.AZ_deg,...
 %  90-mean(abs(ins.El_deg)).*ones(size(ins.AZ_deg)), mean(ins.AZ_deg).*ones(size(ins.AZ_deg)));

if ins.Vscan
   ins.midAng = ins.El_deg(icenter) %mean(ins.El_deg);
   %ins.SA = scat_ang_degs(sza, saz,90-abs(ins.El_deg),ins.AZ_deg);
   ins.SA(ins.El_deg<ins.midAng) = -1.*ins.SA(ins.El_deg<ins.midAng);
   title_str = ['Vertical FOV'];
else
   ins.midAng = ins.AZ_deg(icenter) %mean(ins.AZ_deg);
   %ins.SA = scat_ang_degs(sza, saz,90-abs(ins.El_deg),ins.AZ_deg);
   ins.SA(ins.AZ_deg<ins.midAng) = -1.*ins.SA(ins.AZ_deg<ins.midAng);
   title_str = ['Horizontal FOV'];
end

%%



% SA = scat_ang_degs(sza, saz, za, az)
%%
light_ii = find(scan);
[~,ii] = unique(ins.SA(light_ii));

SA_range = [min(ins.SA(light_ii(ii))), max(ins.SA(light_ii(ii)))];

ins.good_pix = good_pix;
save([ins.pname, ins.fname(1:end-4),'.mat'])
%%


fig1 = figure;
imagesc(ins.SA(light_ii(ii)), ins.nm, ins.CCD_norm(light_ii(ii),:)'); axis('xy');
title([ins.fname ' normalized to range'], 'interp','none');
xlabel('scattering angle');
ylabel('wavelength');
caxis([0.92, 1.03]);colorbar
if any(ins.nm<500)
    ylim([400,1000]);
else
    ylim([900,1700]);
end
xlim([-1.5,1.5]);
ax(1) = gca;

%% normalize by each value at the center point
ins.CCD_norm_zero = ins.CCD_norm./repmat(ins.CCD_norm(icenter,:),size(ins.t))

%%

fig2 = figure; 
lines = plot(ins.SA(scan), ins.CCD_norm_zero(scan,good_pix), '-');grid('on');
% lines = plot(ins.SA(light_ii(ii)),ins.CCD_norm(light_ii(ii),good_pix), '-');grid('on');
recolor(lines, ins.nm(good_pix));
title({title_str;ins.fname},'interp','none');
xlabel('Angle [degrees]');
ylabel('Relative signal');
c = colorbar
ylabel(c,'Wavelength [nm]')
ylim([.94,1.08]);
xlim([-1.5,1.5]);
ax(2) = gca;
v = axis;
save_fig(fig2,[ins.pname, ins.fname(1:end-4),'.line_FOV']);
%saveas(fig2,[ins.pname, ins.fname(1:end-4),'.line_FOV.fig']);
%saveas(fig2,[ins.pname, ins.fname(1:end-4),'.line_FOV.png']);

%%
% ./(ones(size(ins.time))*ins.rangeCCD);
% fig7 = figure; 
% % lines = plot(ins.SA(scan), ins.CCD_norm(scan,good_pix).*((1./(ins.Tint(scan)))*ins.rangeCCD(good_pix)), '-');grid('on');
% lines = plot(ins.SA(scan), ins.CCD_norm(scan,good_pix), '-');grid('on');
% % lines = plot(ins.SA(light_ii(ii)),ins.CCD_norm(light_ii(ii),good_pix), '-');grid('on');
% recolor(lines, ins.nm(good_pix));
% title({title_str;ins.fname},'interp','none');
% xlabel('Angle [degrees]');
% ylabel('Relative signal');
% colorbar
% ylim([.85,1.02]);
% xlim([-1,1]);
% ax(2) = gca;
% v = axis;
%%
fig3 = figure; 
plot(ins.SA(scan), [ins.QdVlr(scan)./ins.QdVtot(scan), ins.QdVtb(scan)./ins.QdVtot(scan)],'o');

legend('Quad V_L_-_R / Quad V_t_o_t','Quad T_B_-_R / Quad V_t_o_t','location','North');
title({title_str;ins.fname},'interp','none');
xlabel('Scattering Angle [degrees]');
ylabel('Quad V_x/V_t_o_t');


%%
saveas(fig2,[ins.pname, ins.fname(1:end-4),'.selected_lines.fig']);
saveas(fig2,[ins.pname, ins.fname(1:end-4),'.selected_lines.png']);
% saveas(fig1,[ins.pname, ins.fname(1:end-4),'.spectral_FOV.fig']);
% saveas(fig1,[ins.pname, ins.fname(1:end-4),'.spectral_FOV.png']);
saveas(fig3,[ins.pname, ins.fname(1:end-4),'.quad_sigs.fig']);
saveas(fig3,[ins.pname, ins.fname(1:end-4),'.quad_sigs.png']);

%%
%ins.SA(3:end-2), ins.CCD_norm(3:end-2,good_pix)
midSA = icenter %ins.SA>-.35 & ins.SA<.35 &ins.Str==1 & scan;
%for ix = length(ins.nm):-1:1
%    P{ix} = polyfit(ins.SA(midSA),ins.CCD_norm(midSA,ix),1);
%    midv = polyval(P{ix},0);
%    ins.CCD_renorm(:,ix) = ins.CCD_norm(:,ix)./midv;
%    ins.CCD_fit(:,ix) = polyval(P{ix},ins.SA(midSA));
%end
ins.CCD_renorm = ins.CCD_norm_zero;
%%
fig4 = figure;
imagesc(ins.SA(light_ii(ii)), ins.nm, ins.CCD_renorm(light_ii(ii),:)'); axis('xy');
title([ins.fname ' normalized to 0 deg'], 'interp','none');
xlabel('scattering angle');
ylabel('wavelength');
caxis([0.92, 1.03]);colorbar
if any(ins.nm<500)
    ylim([400,1000]);
else
    ylim([900,1700]);
end
xlim([-1.5,1.5]);
ax(4) = gca;
linkaxes(ax,'x');
axis(ax(2),v);

saveas(fig4,[ins.pname, ins.fname(1:end-4),'.spectral_FOV.fig']);
saveas(fig4,[ins.pname, ins.fname(1:end-4),'.spectral_FOV.png']);
%%
return
%