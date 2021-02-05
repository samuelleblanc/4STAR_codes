function [aod_fit, fit_rms, Ks,log_modes] = fit_aod_basis(wl, aod, wl_out);
% aod_fit = fit_aod_basis(wl, aod,wl_out);
% wl should be in nm and Mx1 or 1xM
% aod should be Mx1 or 1xM or MxN with M matchin wl
% wl_out should be Nx1 or 1xN
% Fits supplied AOD as a combination of log_aod basis vectors at selected
% wavelengths and returns over extended
% Testing with new basis from observed anet PDFs in vmr and std


% 2020-11-26: v1.0, Connor added version control
version_set('1.0');
% TBD: augment to output Ks, Cn, PDF etc.  Important if we want to use this
% to identify "dust" for example, or identify/remove "425 bip"

if ~any(wl)>100
    wl = wl*1000;
end

wl_size = size(wl);
if size(wl,1)==1&&size(wl,2)>1
    wl = wl';
end
if size(aod,1)==1&&size(aod,2)>1
    aod = aod';
end
if size(wl,2)==1 && all(size(wl)==size(aod))
    if ~isavar('wl_out')
        wl_out = wl;
        wl_out_size = wl_size;
    else
        wl_out_size = size(wl_out);
    end
    if size(wl_out,1)==1 && size(wl_out,2)>1
        wl_out = wl_out';
    end
    if ~any(wl_out)>100
        wl_out = wl_out * 1000;
    end
    aod_mode = load([strrep(which('fit_aod_basis.m'),'fit_aod_basis.m','aod_SD_mode.mat')]);
    
    % Seems to work OK for MFRSR + anetmode.
    sub_modes = aod_mode.log_modes;
    sub_modes = sub_modes./(ones(size(sub_modes,1),1)*max(sub_modes));
    % sub_i = [2:2:length(aod_mode.vmr)];
    % sub_modes = sub_modes(:,sub_i);
    log_modes = interp1(aod_mode.log_wl, sub_modes,log(wl),'linear','extrap');
    
    done = false; 
    good = true(1,size(log_modes,2));
    good_ii = find(good);
    
    %The idea here is to eliminate unnecessary components by iteratively 
    % throwing out the least significant one until all exceed 1e-6.
    % Initially I normalized by the max coef, but the exponential blew this
    % up in certain cases, pushing values toward inf or -inf.  The
    % alternate approach below avoids this by sorting in log-space and only
    % assessing the smallest value against the threshold
    while ~done && sum(good)>1
        Ks(good) = real(log(aod))'/real(log_modes(:,good))';
%         Ks = fit_it_2(log(aod), log_modes(:,good_ii));
         nKs(good) = Ks(good)-max(Ks(good));      
        [minKs,min_ii] = min(nKs(good_ii));
        if exp(minKs)<1e-6
            Ks(good_ii(min_ii)) = 0; nKs(good_ii(min_ii)) = 0;
            good(good_ii(min_ii)) = false; 
            good_ii = find(good);
        else
            done = true;
        end
    end
    
    slog_modes = interp1(aod_mode.log_wl, sub_modes(:,good_ii),log(wl_out),'linear','extrap');
    log_modes = interp1(aod_mode.log_wl, sub_modes(:,good_ii),log(wl),'linear','extrap');
    log_aod_fit = slog_modes*Ks(good)'; log_aod = log_modes*Ks(good)';
    aod_fit = exp(log_aod_fit); aod_fit_ = exp(log_aod); fit_rms = sqrt(nanmean((aod-aod_fit_).^2));
%         figure_(2020); plot(wl, aod, 'r*',wl_out, aod_fit,'-kx'); logx; logy
    if any(wl_out_size ~= size(wl_out))
        aod_fit = aod_fit';
    end
    
    %  figure_(2020); plot(wl, aod, 'r*',wl_out, aod_fit,'-kx'); logx; logy
    
    % bins = unique(aod_mode.bin_radius(:));
    % md_PSD = 0.*ones(length(Ks),length(bins));
    % for k = 1:length(Ks)
    %     md_PSD(k,:) = interp1(aod_mode.bin_radius(k,:),exp(Ks(k)).*aod_mode.PSD(k,:), bins);
    % end
    % md_PSD(isnan(md_PSD))= 0;
    % PSD = sum(md_PSD); PSD(PSD==0) = NaN;
    % figure; plot(1000.*bins, PSD,'-o');logx; logy
    % xlabel('bin radius [um]');
    
    % figure; loglog(wl, aod, 'o-',wl_out, aod_fit,'k-');
    % figure; plot(exp(aod_mode.log_wl), exp(aod_mode.log_modes), '-'); logy; logx
else
    warning('wl and aod must be row vectors of same length')
    aod_fit = NaN(size(aod)); Ks = []; log_modes = [];
end
return