function [aod_fit, good_wl_,fit_rms, nonlog_fit, good_nwl,fit_rms_] = zfit_aod_basis(wl, aod, wl_out, mad_factor);
% [aod_fit, good_wl_] = zfit_aod_basis(wl, aod, wl_out,  mad_factor);
% Multi-stage aod_fit:
% zfit progress with be_aod. Does not include wl_block.  fit_wl will be
% drawn from supplied tau.
%  
%  1) interatively apply fit_aod_basis rejecting outliers to yield a robust subset of pixels
%  2) Extend robust subset by reintroducing originally supplied values (excluding worst outliers?) that fall within a 
%     wavelength acceptable envelope
%  3) Assess RMS and bias of robust and extended subsets.  Output best.

% 2021-02-04: v0.0 Connor, in development. 

version_set('1.0');
if nargin<2
    error(['wl, aod']);
end
    
if ~isavar('wl_out')
    wl_out = wl;
end
if ~isavar('mad_factor')
    mad_factor = 3;
end


wl_ii = [1:length(wl)];
% [aod_fit, Ks] = fit_aod_basis_(wl(wl_ii), aod(wl_ii));
[aod_fit, fit_rms, nolog_fit, nolog_rms, fit_abserr, nolog_abserr, fit_pcterr, nolog_pcterr,Ks,log_modes, Ks_, nonlog_modes] = fit_aod_basis_(wl(wl_ii), aod(wl_ii));
% [aod_fit, fit_rms, nolog_fit, nolog_rms, fit_abserr, nolog_abserr, fit_pcterr, nolog_pcterr,Ks,log_modes, Ks_, nonlog_modes] = fit_aod_basis_(wl, aod, wl_out);
res_ = aod(wl_ii)-aod_fit;
fit_rms_ = sqrt(nanmean((res_).^2)); %rms(res_);
fit_bias_ = nanmean(-res_);
% Note aod_fit is same size as wl_ii

changed = false;
wl_ = true(size(wl));wl_(isnan(aod))= false;
    done = false;
    while ~done
        b4 = sum(wl_);
        [wl_(wl_), mad, abs_dev] = madf(aod(wl_)-aod_fit(wl_));
        done = (sum(wl_)==b4);
        changed = changed | ~done;
    end  

% [aod_fit, Ks] = fit_aod_basis(wl(wl_ii), aod(wl_ii),wl);
% res = aod-aod_fit;
% fit_rms = sqrt(nanmean((res(wl_ii)).^2));%rms(res(wl_ii));
% fit_bias = mean(-res(wl_ii));

wl_x_ = (abs(res)<0.3.*RR); %this is an extended set of pixels including other close values


 [aod_fit_x, Ks_x] = fit_aod_basis(wl(wl_x), aod(wl_x),wl);
res_x = aod-aod_fit_x;
fit_rms_x = sqrt(nanmean((res_x(wl_x)).^2)); %rms(res_x(wl_x));
fit_bias_x = mean(-res_x(wl_x));

% figure; plot(wl, aod, '-', wl(wl_ii), aod_fit(wl_ii),'-o',wl(wl_x), aod_fit_x(wl_x),'-x',wl, aod-aod_fit, 'r-', wl, aod-aod_fit_x,'k-')

good_wl_ = false(size(wl));
if (fit_rms_x < fit_rms) && (abs(fit_bias_x)<abs(fit_bias))
    aod_fit = aod_fit_x; 
    good_wl_(wl_x) = true;
    fit_rms = fit_rms_x;
%     disp('Extended set is better')
else
    good_wl_(wl_ii) = true;
%     disp('Initial set is better')
end
    
% Now we can compare the RMS (and bias?) of the reduced and extended fits
% and report whichever has better statistics

return