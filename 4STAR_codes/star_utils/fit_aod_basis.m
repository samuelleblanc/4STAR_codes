function [aod_fit, fit_rms, Ks,log_modes] = fit_aod_basis(wl, aod, wl_out);
% aod_fit = fit_aod_basis(wl, aod,wl_out);
% wl should be in nm and Mx1 or 1xM
% aod should be Mx1 or 1xM or MxN with M matchin wl
% wl_out should be Nx1 or 1xN
% Fits supplied AOD as a combination of log_aod basis vectors at selected
% wavelengths and returns over extended
% Testing with new basis from observed anet PDFs in vmr and std

% 2020-11-26: v1.0, Connor added version control
% 2021-02-19: v1.1, Connor, using normalized basis in  added version control
version_set('1.1');
% TBD: augment to output Ks, Cn, PDF etc.  Important if we want to use this
% to identify "dust" for example, or identify/remove "425 bip"

warning off 'MATLAB:nearlySingularMatrix'
warning off 'MATLAB:rankDeficientMatrix'

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
    aod_mode = load([strrep(which('fit_aod_basis.m'),'fit_aod_basis.m','aod_SD_nmode.mat')]);   
    sub_modes = aod_mode.log_nmodes;
%     sub_modes = sub_modes -(ones(size(sub_modes,1),1)*max(sub_modes));
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
    Ks(~good) = NaN; nKs(~good) = NaN;
    log_modes = interp1(aod_mode.log_wl, sub_modes(:,good_ii),log(wl),'linear','extrap');    
    log_fit = log_modes*Ks(good)';
    aod_fit = exp(log_fit); 
    fit_rms = sqrt(nanmean((aod-aod_fit).^2));
    
    log_modes = interp1(aod_mode.log_wl, sub_modes(:,good_ii),log(wl_out),'linear','extrap');
    log_fit = log_modes*Ks(good)'; 
    aod_fit = exp(log_fit); 
        
%  figure_(2021); plot(wl, aod, 'r*',wl_out, aod_fit,'-ko'); logx; logy
    if any(wl_out_size ~= size(wl_out))
        aod_fit = aod_fit';
    end
    
else
    warning('wl and aod must be row vectors of same length')
    aod_fit = NaN(size(aod)); Ks = []; log_modes = [];
end

warning on 'MATLAB:nearlySingularMatrix'
warning on 'MATLAB:rankDeficientMatrix'
return