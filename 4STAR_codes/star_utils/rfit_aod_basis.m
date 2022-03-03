function [aod_fit, good_wl_,fit_rms, fit_bias] = rfit_aod_basis(wl, aod, wl_out, mad_factor);
% [aod_fit, good_wl_] = rfit_aod_basis(wl, aod, wl_out,  mad_factor);

% Starting from xfit, modify to provide "robust" aod-fitting.
% fit_aod_basis iteratively determines an optimal set of component
% coefficients. This function calls fit_aod_basis iteratively while
% rejecting data values that appear as statisticl outliers relative to the
% existing sample and fitted result. It is nonetheless possible that this
% approachg may lead to a non-optimal "blind-alley" solution.  Considering
% how to evaluate that risk and mitigate such as applying the iteratively
% convergent solution to the original full sample, applying a stringent
% outlier rejection criterion, retrieving the convergent solution from this
% reduced set, and then comparing RMS and bias of both retrieved solutions
% against the full and reduced sample sets.

% Multi-stage aod_fit: (in progress)
%  1) interatively apply fit_aod_basis rejecting outliers to yield a robust subset of pixels
%  2)  Assess RMS and bias of robust and extended subsets.  Output best.

% 2021-02-04: v1.0 Connor add version control
% 2022-02-20: v1.1 Connor adapting for sashe and lang_tau_series.  Saved
% copy of original as *_bak.m  Removed non-log fit (since one is as good as
% the other, essentially), and test of extended WL set (since that applied
% to examination of hyperspectral fits but this is now focused on using
% filter-based AOD as pin for hyperspectral
% warning off all
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

[aod_fit] = fit_aod_basis(wl, aod);
res_ = aod-aod_fit;
fit_rms_ = sqrt(nanmean((res_).^2)); %rms(res_);
fit_bias_ = mean(-res_);
% Note aod_fit is same size as wl_ii
% Identify and exclude statistical outliers from contiguous blocks
changed = false;
w_ = true(size(wl)); % Assign weights to 1
done = false;
while ~done
    b4 = sum(w_);
    [w_(w_), mad, abs_dev] = madf(aod(w_)-aod_fit(w_),mad_factor);
    done = (sum(w_)==b4);
    changed = changed | ~done;
end

[aod_fit] = fit_aod_basis(wl(w_), aod(w_),wl(w_));
res= aod(w_)-aod_fit;
fit_rms = sqrt(nanmean((res).^2)); %rms(res_x(wl_x));
fit_bias = mean(res);
good_wl_ = w_;
[aod_fit] = fit_aod_basis(wl(w_), aod(w_),wl_out);
% warning on all
return