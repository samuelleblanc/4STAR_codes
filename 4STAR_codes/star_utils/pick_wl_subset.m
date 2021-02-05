function [good_wl,w_ii] = pick_wl_subset(s, in)
% [good_wl,w_ii] = pick_wl_subset(s,in)
% in:
% in.cross_sections
% in.w_ii
% in.suns
% This script identifies potential contributions to 4STAR measurements by
% plotting ESR, resp, c0, rate, and gas contributions.
% Gas contributions are displayed normalized against measured tau and at
% retrieved levels if available. 

% The idea is to use these quantities to interactively identify reliable
% pixels for fitting AOD. 

% Use this in tandem with robust outlier rejection after initial pixel
% selection, and for a range of cases (low/hi alt, low/hi loading, and diverse
% campaigns)

% eventually evaluate aod_fit vs polyfit RMS etc. 
% Also need to understand relative noisiness of SWIR tau and potential
% issues with ~1000 nm measurements.

% As of 2021-01-17, the aod_fit looks superior to polyfit 1 or 2.
% Figure(1111) of co, resp, rate, ESR has not shown much value but there
% is potential improvement of co from 337nm down to 300 nm and perhaps as
% short as 274 nm.  This may be improved using the ESR, O3, Rayleigh and airmass to
% define an instantaneous in flight reference at high altitude.  May permit
% more robust retrieval of HOHC (formaldahyde)
% There is also an issue with the wavelength registration of 4STARA versus
% the wln field in cross_sections
if isavar('in')
    if isfield(in,'w_ii')
        w_ii = in.w_ii;
    end
    if isfield(in,'suns_i')
        suns_i = in.suns_i;
    end
    if isfield(in, 'cross_sections')
        cross_sections = in.cross_sections;
    end
end
persistent yl_13;
if ~isavar('suns_i')
    suns_i = find(s.Str==1&s.Zn==0);
end

if ~isavar('cross_sections')
    [daystr, filen, datatype,instrumentname]=starfilenames2daystr(s.filename, 1);
    cross_sections=taugases(s.t, datatype, s.Alt, s.Pst, s.Lat, s.Lon, s.O3col, s.NO2col,instrumentname);
end

if ~isavar('w_ii')
    w_ii = get_wvl_subset(s.t(1),instrumentname);
end

if ~isfield(s,'tau_tot_vert')
    Tr = real(s.rate./repmat(s.f,1,length(s.w))./repmat(s.c0,length(s.t),1));
    Tr_noray = Tr ./tr(s.m_ray, s.tau_ray);
    tau_noray_slant = -real(log(Tr_noray));
    tau_noray_vert = tau_noray_slant ./repmat(s.m_aero,1,length(s.w));
    s.tau_tot_vert = tau_noray_vert + s.tau_ray; % This is really a "total" vertical optical depth
end
wl = 1000.*s.w;
c0 = s.c0; c0(s.w<.3)=0; c0(c0<=0) = NaN; c0(~isfinite(c0)) = NaN;
resp = s.skyresp; resp(resp<=0) = NaN; resp(~isfinite(resp)) = NaN;
rate = s.rate(suns_i,:); rate(~isfinite(rate)) = NaN;
rate_lte = zeros(size(rate)); rate_lte(rate<=0) = NaN;
tau_aero = s.tau_aero(suns_i,:); tau_aero(tau_aero<=0) = NaN;
tau_aero_sub = s.tau_aero_subtract_all(suns_i,:); tau_aero_sub(tau_aero_sub<=0) = NaN;
tau_noray = s.tau_tot_vert(suns_i,:) - s.tau_ray(suns_i,:); 
tau_noray(~isfinite(tau_noray)|(tau_noray<=0))=NaN;

guey_ESR = gueymard_ESR;
g_ESR = interp1(guey_ESR(:,1), guey_ESR(:,2), 1000.*s.w,'pchip','extrap');
figure_(1111);close(1111); figure_(1111);
if isavar('ax'); hold('off'); end
semilogy(1000.*s.w(1:1044), resp(1:1044)./max(resp(1:1044)),'.',...
    1000.*s.w(1:1044), (c0(1:1044)./g_ESR(1:1044)).*(max(g_ESR(1:1044))./max(c0(1:1044))),'.',...
1000.*s.w(1:1044), c0(1:1044)./max(c0(1:1044)),'.',...
1000.*s.w(1:1044), rate_lte(1:1044) + rate(1:1044)./max(rate(1:1044)),'.',...
1000.*s.w, g_ESR./max(g_ESR), 'g-');
xlabel('wavelength');
lg = legend('resp','co/esr','co','rate', 'ESR TOA'); set(lg,'location','south');
hold('on');
ax(1) = gca; 
ax(1).ColorOrderIndex = 1;
plot(1000.*s.w(1045:end), resp(1045:end)./max(resp(1045:end)),'.',...
1000.*s.w(1045:end), (c0(1045:end)./g_ESR(1045:end)).*(max(g_ESR(1045:end))./max(c0(1045:end))),'.',...    
1000.*s.w(1045:end), c0(1045:end)./max(c0(1045:end)),'.',...
1000.*s.w(1045:end), rate_lte(1,1045:end)+rate(1,1045:end)./max(rate(1,1045:end)),'.'...
);

zoom('on')

good_wl = false(size(s.w));
good_wl(w_ii) = true;
done = false; 
 wi_subset = get_wvl_subset(s.t(1),'4STAR');
[a2,a1,a0,ang,curvature]=polyfitaod(s.w(wi_subset ),tau_noray(wi_subset ));
tau_poly = exp(polyval([a2,a1,a0],log(s.w)));
[a2,a1,a0,ang,curvature]=polyfitaod(s.w(wi_subset ),tau_aero(wi_subset ));
tau_aero_poly = exp(polyval([a2,a1,a0],log(s.w)));
while ~done
w_ii(isnan(tau_noray(w_ii))|tau_noray(w_ii)<=0) = [];

[a2x,a1x,a0x,angx,curvaturex]=polyfitaod(s.w(w_ii),tau_noray(w_ii));
tau_polyx = exp(polyval([a2x,a1x,a0x],log(s.w)));
[a2x,a1x,a0x,angx,curvaturex]=polyfitaod(s.w(w_ii),tau_aero(w_ii));
tau_aero_polyx = exp(polyval([a2x,a1x,a0x],log(s.w)));
% [P2,S2,M2] = polyfit(real(log(1000.*s.w(w_ii))),real(log(tau_noray(w_ii))),2);
% tau_polyx = exp(polyval(P2, log(1000.*s.w),S2,M2));
% [P3,S3,M3] = polyfit(real(log(1000.*s.w(w_ii))),real(log(tau_noray(w_ii))),3);
% tau_fit_3 = exp(polyval(P3, log(1000.*s.w),S3,M3));

[aod_fit, Ks,log_modes] = fit_aod_basis(1000.*s.w(w_ii), tau_noray(w_ii), 1000.*s.w);
[aod_xfit, good_wl_x] = xfit_aod_basis(wl, tau_noray, return_wl_block(w_ii, cross_sections.wln));
[tau_aero_fit, Ks_aero,log_modes] = fit_aod_basis(1000.*s.w(w_ii), tau_aero(w_ii), 1000.*s.w);
[tau_aero_xfit, good_wl_aex] = xfit_aod_basis(wl, tau_aero, return_wl_block(w_ii, cross_sections.wln));

res_1 = tau_noray - tau_poly; res_2 = tau_noray -tau_polyx; res_afit = tau_noray -aod_fit; res_x = tau_noray - aod_xfit;
res_ae_1 = tau_aero - tau_aero_poly; res_ae_2 = tau_aero -tau_aero_polyx; res_aefit = tau_aero -tau_aero_fit; res_aex = tau_aero -tau_aero_xfit; 

rms_1 = sqrt(nanmean(res_1(wi_subset).^2));
rms_2 = sqrt(nanmean(res_2(w_ii).^2));
rms_afit = sqrt(nanmean(res_afit(w_ii).^2));
rms_x = sqrt(nanmean(res_x(good_wl_x).^2));

rms_ae1 = sqrt(nanmean(res_ae_1(wi_subset).^2));
rms_ae2 = sqrt(nanmean(res_ae_2(w_ii).^2));
rms_aefit = sqrt(nanmean(res_aefit(w_ii).^2));
rms_aex = sqrt(nanmean(res_aex(good_wl_aex).^2));

tau_mins = min([tau_poly;tau_polyx;aod_fit;tau_aero_poly; tau_aero_polyx; tau_aero_fit]);
% Normalize gas cross sections to unity maximum within WL range of interest.
% Have cross sections for O2, O3, O4 (O4all), NO2, CO2, CH4, H2O
bot = 1e-3; 
nxs.wln = cross_sections.wln;
[tmp,nxs.o2_i] = max(cross_sections.o2);
nxs.o2 = cross_sections.o2./tmp; nxs.o2(nxs.o2<bot) = NaN;
% o3, wl>330
tmp = max(cross_sections.o3(cross_sections.wln>330)); 
nxs.o3_i = find(cross_sections.o3==tmp);
nxs.o3 = cross_sections.o3./tmp;  nxs.o3(nxs.o3<bot|nxs.wln<233) = NaN;

tmp = max(cross_sections.o4(cross_sections.wln>340));
nxs.o4_i = find(cross_sections.o4==tmp);
nxs.o4all = cross_sections.o4all./cross_sections.o4all(nxs.o4_i); 
nxs.o4all(nxs.o4all<bot|nxs.wln>1340) = NaN;
% figure; plot(nxs.wln, [nxs.o2;nxs.o3;nxs.o4all],'-'); logy
% legend('o2','o3','o4 all');

% figure; plot(cross_sections.wln, [cross_sections.co2;cross_sections.no2;cross_sections.ch4],'-'); logy
[tmp,nxs.co2_i] = max(cross_sections.co2);
nxs.co2 = cross_sections.co2./tmp; nxs.co2(nxs.co2<bot) = NaN;
[tmp,nxs.no2_i] = max(cross_sections.no2);
nxs.no2 = cross_sections.no2./tmp;  nxs.no2(nxs.no2<bot|nxs.wln<330|nxs.wln>665) = NaN;
[tmp,nxs.ch4_i] = max(cross_sections.ch4);
nxs.ch4 = cross_sections.ch4./tmp;  nxs.ch4(nxs.ch4<bot) = NaN;
% figure; plot(nxs.wln, [nxs.co2; nxs.no2; nxs.ch4],'-'); logy; zoom('on');

% figure; plot(cross_sections.wln, [cross_sections.h2o],'-');logy;zoom('on')
nxs.h2o_sw = NaN(size(cross_sections.wln)); nxs.h2o_lw = nxs.h2o_sw;
nxs.h2o_sw(cross_sections.wln>393 & cross_sections.wln<675) = cross_sections.h2o(cross_sections.wln>393 & cross_sections.wln<675);
nxs.h2o_lw(cross_sections.wln>675) = cross_sections.h2o(cross_sections.wln>675);
[tmp, nxs.h2o_i] = max(nxs.h2o_sw); nxs.h2o_sw = nxs.h2o_sw./tmp; nxs.h2o_sw(nxs.h2o_sw<bot) = NaN;
[tmp, nxs.h2o_j] = max(nxs.h2o_lw); nxs.h2o_lw = nxs.h2o_lw./tmp; nxs.h2o_lw(nxs.h2o_lw<bot) = NaN;

% figure; plot(nxs.wln, [nxs.h2o_sw; nxs.h2o_lw],'-'); logy; zoom('on');


% Now,  bring in assumed or retrieved ODs as well:
% tau_O3, tau_NO2, tau_O4, tau_CO2_CH4_N2(==0))
tau_gas.wln = nxs.wln; 
tau_gas.NO2 = s.tau_NO2(suns_i,:); tau_gas.NO2(isnan(nxs.no2))= NaN;
tau_gas.O3 = s.tau_O3(suns_i,:); tau_gas.O3(isnan(nxs.o3))= NaN;
tau_gas.O4 = s.tau_O4(suns_i,:); tau_gas.O4(isnan(nxs.o4all))= NaN;

% figure; plot(nxs.wln, [tau_gas.NO2;tau_gas.O3;tau_gas.O4],'-'); logy;zoom('on')

% And now retrieved gas OD
ret_gas.no2.vis_od = s.gas.no2.no2OD(suns_i,:); 
ret_gas.no2.vis_od(isnan(nxs.no2)) = NaN;

ret_gas.o3.vis_od = s.gas.o3.o3OD(suns_i,:); ret_gas.o3.vis_od(isnan(nxs.o3)) = NaN;
% h2o and o4 in o3 retrieval are 0 or useless

ret_gas.co2.od = s.gas.co2.co2OD(suns_i,:); ret_gas.co2.od(isnan(nxs.co2)) = NaN;
% ch4 in co2 retrieval is 0

ret_gas.hcoh.od = s.gas.hcoh.hcohOD(suns_i,:);
tmp = max(ret_gas.hcoh.od(nxs.wln>330)); 
ret_gas.hcoh.max_i = find(ret_gas.hcoh.od  == tmp,1,'first');
nxs.hcoh = ret_gas.hcoh.od./tmp; 
nxs.hcoh_i = ret_gas.hcoh.max_i;
% This OD is HUGE!  Maybe if hcohOD(wl>330)>tau_noray_vert then scale to match?


figure_(1112);close(1112); figure_(1112);
if length(ax)==2 hold('off');end
semilogy(...
    nxs.wln(~isnan(tau_noray)), tau_noray(~isnan(tau_noray)), 'k-',...
    nxs.wln(w_ii), tau_noray(w_ii), 'ko',...
    nxs.wln(~isnan(tau_aero)), tau_aero(~isnan(tau_aero)), 'g-',...
    nxs.wln(wi_subset), tau_aero(wi_subset), 'go');
ax(2) = gca;
hold('on');
plot(nxs.wln,tau_poly,'k--',nxs.wln,tau_polyx, 'k-.', nxs.wln,aod_fit,'k:',...
    nxs.wln,tau_aero_poly,'g--',nxs.wln,tau_aero_polyx, 'g-.', nxs.wln,tau_aero_fit,'g:');
ax(2).ColorOrderIndex = 1;
semilogy(nxs.wln,...
    [nxs.hcoh .* interp1(nxs.wln, tau_mins,nxs.wln(nxs.hcoh_i),'linear');...
    nxs.no2 .* interp1(nxs.wln, tau_mins,nxs.wln(nxs.no2_i),'linear');...
    nxs.o2 .* interp1(nxs.wln, tau_mins,nxs.wln(nxs.o2_i),'linear');...
    nxs.o3 .* interp1(nxs.wln, tau_mins,nxs.wln(nxs.o3_i),'linear');...
    nxs.o4all .* interp1(nxs.wln, tau_mins,nxs.wln(nxs.o4_i),'linear');...
    nxs.co2 .* interp1(nxs.wln, tau_mins,nxs.wln(nxs.co2_i),'linear');...
    nxs.ch4 .* abs(interp1(nxs.wln, tau_mins,nxs.wln(nxs.ch4_i),'linear'))],'-.');

semilogy(nxs.wln,...
    [nxs.h2o_sw .* interp1(nxs.wln, tau_aero,nxs.wln(nxs.h2o_i),'linear');...
    nxs.h2o_lw .* interp1(nxs.wln, tau_aero,nxs.wln(nxs.h2o_j),'linear')],':','color',[.5,0,0]);
zoom('on');
legend('tau noray','fit values','tau aero','fit values', 'tau poly', 'tau polyx','aod fit','tau aero poly', 'tau aero polyx','tau aero fit','HCOH','NO_2', 'O_2','O_3','O_4','CO_2','CH_4','H_2O')
% Where feasible, also plot retrieved gas ODs.
ax(2) = gca;
linkaxes(ax,'x');


figure_(1113); close(1113); figure_(1113); mid = (nxs.wln>270)&(nxs.wln<1650);
zz(1) = subplot(2,1,1);
plot(nxs.wln(mid),[tau_poly(mid); tau_polyx(mid); aod_fit(mid)],'-');
yl_ = ylim;yl(2) = yl_(2);
plot(nxs.wln(mid),[res_1(mid); res_2(mid); res_afit(mid)],':');
yl_= ylim; yl(1) = yl_(1);
plot(nxs.wln(nxs.wln>310), tau_noray(nxs.wln>310),'k-'); 
ax3 = gca; 
ax3.ColorOrderIndex = 4;
hold('on');
plot(nxs.wln(nxs.wln>310),[tau_poly(nxs.wln>310); tau_polyx(nxs.wln>310); aod_fit(nxs.wln>310);aod_xfit(nxs.wln>310)],'-');
plot(1000.*s.w(wi_subset ), tau_noray(wi_subset ),'m*', 1000.*s.w(w_ii ), tau_noray(w_ii ),'go',...
    nxs.wln(good_wl_x),tau_noray(good_wl_x),'rx');
ax3.ColorOrderIndex = 4;
plot(nxs.wln(nxs.wln>310),[res_1(nxs.wln>310); res_2(nxs.wln>310); res_afit(nxs.wln>310);res_x(nxs.wln>310)],'--',...
    1000.*s.w(wi_subset), res_1(wi_subset),'m*',nxs.wln(w_ii), res_2(w_ii),'x',nxs.wln(w_ii), res_afit(w_ii),'go',nxs.wln(good_wl_x),res_x(good_wl_x),'r.');ylim(yl);

lg = legend('tau noray',sprintf('poly RMS=%1.2e',rms_1),sprintf('polyx RMS=%1.2e',rms_2),sprintf('aodfit RMS=%1.2e',rms_afit),...
    sprintf('xfit RMS=%1.2e',rms_x),...
    'w_isubset','afit pixels','xfit pixels');
set(lg,'interp','none')
hold('off');
title({[s.instrumentname,sprintf(' %s',datestr(s.t(suns_i),'yyyy-mm-dd HH:MM:SS'))];...
    sprintf('Alt: %d m, Pixels in fit: %d',s.Alt(in.suns_i),length(w_ii))});
if isempty(yl_13)
    ylim(yl);
else
    ylim(yl_13);
end
zz(2) = subplot(2,1,2);
plot(nxs.wln(mid),[tau_aero_poly(mid); tau_aero_polyx(mid); tau_aero_fit(mid);],'-');
yl_ = ylim;yl(2) = yl_(2);
plot(nxs.wln(mid),[res_ae_1(mid); res_ae_2(mid); res_aefit(mid)],':');
yl_= ylim; yl(1) = yl_(1);
plot(nxs.wln(nxs.wln>310), tau_aero(nxs.wln>310),'k-'); 
ax3 = gca; 
ax3.ColorOrderIndex = 4;
hold('on');
plot(nxs.wln(nxs.wln>310),[tau_aero_poly(nxs.wln>310); tau_aero_polyx(nxs.wln>310); tau_aero_fit(nxs.wln>310);tau_aero_xfit(nxs.wln>310)],'-');
plot(1000.*s.w(wi_subset ), tau_aero(wi_subset ),'m*', 1000.*s.w(w_ii ), tau_aero(w_ii ),'go',...
    nxs.wln(good_wl_aex),tau_aero(good_wl_aex),'rx');
ax3.ColorOrderIndex = 4;
plot(nxs.wln(nxs.wln>310),[res_ae_1(nxs.wln>310); res_ae_2(nxs.wln>310); res_aefit(nxs.wln>310);res_aex(nxs.wln>310)],'--',...
    1000.*s.w(wi_subset), res_ae_1(wi_subset),'m*',nxs.wln(w_ii), res_ae_2(w_ii),'x',nxs.wln(w_ii), res_aefit(w_ii),'go',nxs.wln(good_wl_x),res_aex(good_wl_x),'r.');ylim(yl);

lg = legend('tau aero',sprintf('tau aero poly RMS=%1.2e',rms_ae1),sprintf('tau aero polyx RMS=%1.2e',rms_ae2),...
    sprintf('tau aero fit RMS=%1.2e',rms_aefit),sprintf('aexfit RMS=%1.2e',rms_aex),...
    'w_isubset','afit pixels','xfit pixels');
set(lg,'interp','none')
hold('off');
if isempty(yl_13)
    ylim(yl);
else
    ylim(yl_13);
end
linkaxes(zz,'xy');
mn = menu('Zoom into tau_noray then select/exclude points:','Use in fit','Exclude from fit','done');
top_fig = double(gcf);
figure(1113); 
yl_13 = ylim;
if top_fig==1111    
    figure_(1113)
else
    figure_(top_fig);
end
v = axis;
these = nxs.wln>v(1)&nxs.wln<v(2)&tau_noray>v(3)&tau_noray<v(4);
if mn==1
    good_wl(these) = true;
elseif mn==2
    good_wl(these) = false;
else
    done = true;
end
w_ii = find(good_wl);

end
% 

return
