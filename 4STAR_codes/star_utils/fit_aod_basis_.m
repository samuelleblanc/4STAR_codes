function [aod_fit, fit_rms, nolog_fit, nolog_rms, fit_abserr, nolog_abserr, fit_pcterr, nolog_pcterr,Ks,log_modes, Ks_, nolog_modes] = fit_aod_basis_(wl, aod, wl_out);
% aod_fit = fit_aod_basis_(wl, aod,wl_out);
% wl should be in nm and Mx1 or 1xM
% aod should be Mx1 or 1xM or MxN with M matchin wl
% wl_out should be Nx1 or 1xN
% Fits supplied AOD as a combination of log_aod basis vectors at selected
% wavelengths and returns over extended
% Testing with new basis from observed anet PDFs in vmr and std

% 2020-11-26: v1.0, Connor added version control
% 2021-02-19: v1.1, Connor, using normalized basis in  added version control
% 2021-02-19: v1.2, Connor, testing with both log_mode and "non-log" modes
%                   Nearly equivalent RMS for log and non-log fitting but
%                   at least for aeronet&mfrsr tests log-fit appears to
%                   extrapolate better (lower curvature at both ends)
%   Although initially counter-intuitive to me, it begins to make sense
%   that the log and non-log fits perform similarly since the AOD is
%   typically between 0.02 and 1 (or less) so the dynamic range is not
%   radically different for logged and nonlogged tau. 
%   The conceptual benefit of logged values is that the fit coefficients
%   can't imply non-physical negative AODs. Rather negative of logged
%   coefficients simply indicates factors less than 1.  The down-side is
%   that addition of logged AODs is not analogous to addition of tau.  
%   In contrast, the fit using non-log quantities can be restricted to
%   physical solutions by discarding negative coefs. But one is not
%   guaranteed to obtain an optimal solution via sequential exclusion. 
%   Thus, while either of these will frequently yield a decent fit with low
%   RMS, neither is necessarily the "best fit" inasmuch as it is possible
%   an multivariant approach may yield an even better fit.

% Thinking about derivatives, resolution, and relevance/applicability 
% Considering computing extinction at 0.1 nm resolution and then computing
% 2nd order polynomial fit over a sliding window (of width 1-3 nm?) with resulting ext(z) and
% corresponding first and second derivatives at 1 nm resolution.  The
% derivatives will add in proportion to the tau components so should provide best-estimate tau, tau', and tau''
% results (but will the logged values? Not without careful treatment, I expect). 
version_set('1.1');

% TBD: augment to output Ks, Cn, PDF etc.  Important if we want to use this
% to identify "dust" for example



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
    bad = isnan(wl)|isnan(aod);
    wl = wl(~bad);
    aod = aod(~bad);
    aod_mode = load([strrep(which('fit_aod_basis.m'),'fit_aod_basis.m','aod_SD_nmode.mat')]);   
    sub_modes = aod_mode.log_nmodes;
%     sub_modes = sub_modes -(ones(size(sub_modes,1),1)*max(sub_modes));
    log_modes = interp1(aod_mode.log_wl, sub_modes,log(wl),'linear','extrap');
    nolog_modes = interp1(aod_mode.log_wl, exp(sub_modes),log(wl),'linear','extrap');   
% Test both log_modes and nonlog_modes    
    done = false; 
    good = true(1,size(log_modes,2));
    good_ii = find(good);
    done_ = false; 
    good_ = true(1,size(nolog_modes,2));
    good_ii_ = find(good_);
    %The idea here is to eliminate unnecessary components by iteratively 
    % throwing out the least significant one until all exceed 1e-6 for log modes or >0
    % for non-log modes.
    % Initially I normalized by the max coef, but the exponential blew this
    % up in certain cases, pushing values toward inf or -inf.  The
    % alternate approach below avoids this by sorting in log-space and only
    % assessing the smallest value against the threshold
    while (~done && sum(good)>1) || (~done_ && sum(good_)>1)
        if ~done && sum(good)>1
            Ks(good) = real(log(aod))'/real(log_modes(:,good))';
            good(good) = ~(Ks(good)==0); good_ii = find(good);
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
        if ~done_ && sum(good_)>1
            Ks_(good_) = real(aod)'/real(nolog_modes(:,good_))';
            good_(good_) = ~(Ks_(good_)==0); good_ii_ = find(good_);
            nKs_(good_) = Ks_(good_)./max(Ks_(good_));
            [minKs_,min_ii_] = min(nKs_(good_ii_));
            
            if minKs_<0
                Ks_(good_ii_(min_ii_)) = 0; nKs_(good_ii_(min_ii_)) = 0;
                good_(good_ii_(min_ii_)) = false;
                good_ii_ = find(good_);
            else
                done_ = true;
            end
        end
    end
    
    Ks(~good) = NaN; nKs(~good) = NaN;
    log_modes = interp1(aod_mode.log_wl, sub_modes(:,good_ii),log(wl),'linear','extrap');    
    log_fit = log_modes*Ks(good)';
    aod_fit = exp(log_fit); 
    fit_rms = sqrt(nanmean((aod-aod_fit).^2));
    fit_abserr = aod_fit-aod;
    fit_pcterr = 100.*fit_abserr./aod;
    
    log_modes = interp1(aod_mode.log_wl, sub_modes(:,good_ii),log(wl_out),'linear','extrap');
    log_fit = log_modes*Ks(good)'; 
    aod_fit = exp(log_fit); 

    Ks_(~good_) = NaN; nKs_(~good_) = NaN;
    nolog_modes = interp1(aod_mode.log_wl, exp(sub_modes(:,good_ii_)),log(wl),'linear','extrap');    
    nolog_fit = nolog_modes*Ks_(good_)';
    nolog_rms = sqrt(nanmean((aod-nolog_fit).^2));
    nolog_abserr = nolog_fit - aod;
    nolog_pcterr = 100.*nolog_abserr./aod;
    
    nolog_modes = interp1(aod_mode.log_wl, exp(sub_modes(:,good_ii_)),log(wl_out),'linear','extrap');
    nolog_fit = nolog_modes*Ks_(good_)'; 
    
%     figure; 
%     zz(1) = subplot(2,1,1); plot(wl, fit_abserr,'-o',wl,nolog_abserr,'x-'); legend('log fit','no log'); ylabel('abs err');
%     zz(2) = subplot(2,1,2); plot(wl, fit_pcterr,'o-',wl,nolog_pcterr,'x-'); legend('log fit','no log'); ylabel('pcterr');
%     linkaxes(zz,'x');
% 
%     figure; plot(wl, aod, 'r*',wl_out, aod_fit,'-ko', wl_out, nolog_fit,'-bx',wl_out, (aod_fit+nolog_fit)./2, 'r-'); logx; logy;
%     legend('meas',sprintf('log-fit RMS=%1.2e',fit_rms), sprintf('non-log RMS=%1.2e',nolog_rms), 'mean of fits');
    if any(wl_out_size ~= size(wl_out))
        aod_fit = aod_fit';
    end    
else
    warning('wl and aod must be row vectors of same length')
    aod_fit = NaN(size(aod)); Ks = []; log_modes = [];
end
return