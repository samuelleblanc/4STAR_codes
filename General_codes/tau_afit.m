function [aod, min_rms, fit_rms, aod_pfit, aod_afit] = tau_afit(ws,tau, block);
%[aod, min_rms, fit_rms, aod_pfit, aod_afit] = tau_afit(ws,tau, block);
% "ws" can be either a vector or wavelengths or an "s" struct.
% If ws is an "s" struct, then tau is ignored.
% If block is not provided it will be loaded from xfit_wl_block.mat
% Computes polyfit and aod_fit_basis on tau_aero.
% Returns aod representing the best fit having the lowest RMS for each time
% min_rms as the lowest RMS value
% aod_rms(:,1) as the RMS from polyfit
% aod_rms(:,2) as the RMS from aod_fit_basis
% aod_pfit is the evaluated polyfit
% aod_afit is the evaluated aod_fit_basis

% 2021-02-04: v1.0 Connor introducing tau_afit that combines polyfit, afit,

version_set('1.0');
if ~isavar('ws')||isempty(ws)
    s = load(getfullname('*starsun*.mat','starsun'));
    wl = 1000.*s.w; tau = s.tau_aero;
    sun_ = s.Zn==0&s.Str==1; 
    suns_ii = find(sun_);
    tau = tau(sun_,:); 
    clear s
end
if isavar('ws')&&isstruct(ws)&&isfield(ws,'w')&&isfield(ws,'tau_aero')
    wl = 1000.*ws.w;
    tau = ws.tau_aero;
    sun_ = ws.Zn==0&ws.Str==1; 
    suns_ii = find(sun_);
    tau = tau(sun_,:);
    clear ws
end
if isavar('ws')&&~isstruct(ws)&&~isempty(ws)
    wl = ws; 
    if all(wl<5)
        wl = 1000.*wl;
    end
    clear ws
end
if ~isavar('block')
    block = load(getfullname('xfit_wl_block.mat','block','Select block file indicating contiguous pixels.'));
    if isfield(block,'block') block = block.block; end;
end
wl_ = false(size(wl));
for b = 1:size(block,1)
    wl_(block(b,3):block(b,4)) = true;
end
wl_ii = find(wl_);

aod_afit = NaN(size(tau));
aod_afit_rms = NaN(size(tau,1));
[a2x,a1x,a0x,angx,curvaturex]=polyfitaod(wl(wl_ii)./1000,tau(:,wl_ii));
PPx = [a2x,a1x,a0x];
aod_pfit = NaN(size(tau));
tic
for s_i = 1:size(tau,1)
    [aod_afit(s_i,:), aod_afit_rms(s_i)] = fit_aod_basis(wl(wl_), tau(s_i,wl_),wl);  
    aod_pfit(s_i,:) = exp(polyval(PPx(s_i,:),log(wl./1000)));
end
res_2 = tau -aod_pfit; 
rms_2 = sqrt(nanmean(res_2(:,wl_).^2,2));
toc
fit_rms = [rms_2,aod_afit_rms]; 
[min_rms,m_ij] = min(fit_rms,[],2);
r_1 = m_ij==1; r_2 = m_ij==2; 
aod_ = aod_afit;
aod_(r_1,:) = aod_pfit(r_1,:);
aod = aod_;

% figure; ss(1) = subplot(2,1,1);
% plot([1:length(suns_ii)], tau(:,407),'x'); legend('aod 500nm');
% % title(['4STAR AOD and fitting results'];[datestr(s.t(1),'yyyy-mm-dd HH:MM:SS'),' to ',datestr(s.t(end),'HH:MM:SS')]});
% ss(2) = subplot(2,1,2);
% plot([1:length(suns_ii)], fit_rms,'.',[1:length(suns_ii)], min_rms,'o'); legend('pfit','afit','minfit');logy;
% % dynamicDateTicks;
% linkaxes(ss,'x');


return