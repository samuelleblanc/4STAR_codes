function [aod_fit, good_wl_,fit_rms] = xfit_aod_basis(wl, aod, block, mad_factor, wl_out);
% [aod_fit, good_wl_] = xfit_aod_basis(wl, aod, block, wl_out,  mad_factor);
% Multi-stage aod_fit:
%  0) Compose w_ii from "block"
%  1) interatively apply fit_aod_basis rejecting outliers to yield a robust subset of pixels
%  2) Extend robust subset to include all values between blocks that are within a 
%     wavelength acceptable envelope
%  3) Assess RMS and bias of robust and extended subsets.  Output best.

% 2021-02-04: v1.0 Connor add version control

version_set('1.0');
if nargin<2
    error(['wl, aod']);
end
if ~isavar('block')
    block = load(getfullname('xfit_wl_block.mat','block','Select block file indicating contiguous pixels.')); 
    if isfield(block,'block') block = block.block; end;
end
    
if ~isavar('wl_out')
    wl_out = wl;
end
if ~isavar('mad_factor')
    mad_factor = 3;
end

wl_ = false(size(wl));
for b = 1:size(block,1)
    wl_(block(b,3):block(b,4)) = true;
end
wl_ii = find(wl_);
[aod_fit, Ks] = fit_aod_basis(wl(wl_ii), aod(wl_ii));
res_ = aod(wl_ii)-aod_fit;
fit_rms_ = sqrt(nanmean((res_).^2)); %rms(res_);
fit_bias_ = mean(-res_);
% Note aod_fit is same size as wl_ii
% Identify and exclude statistical outliers from contiguous blocks
changed = false;
for B = 1:size(block,1)
    aa = [block(B,1):block(B,2)];% indices in wl_ii and aod_fit
    bb =[block(B,3):block(B,4)]; % indices in wl and aod    
    w = true(size(bb)); % Assign weights to 1
    done = false;
    while ~done
        b4 = sum(w);
        [w(w), mad, abs_dev] = madf(aod(bb(w))-aod_fit(aa(w)),3);
        done = (sum(w)==b4);
        changed = changed | ~done;
    end
    wl_(bb) = w;    
end
if changed & sum(wl_)>2
    [block, wl_ii] = return_wl_block(wl_, wl); % this is for reduced set of pixels    
    % Note, aod_fit is now same size as wl!
% else
%     disp('No pixels removed')
end
[aod_fit, Ks] = fit_aod_basis(wl(wl_ii), aod(wl_ii),wl);
res = aod-aod_fit;
fit_rms = sqrt(nanmean((res(wl_ii)).^2));%rms(res(wl_ii));
fit_bias = mean(-res(wl_ii));
% Now, compute the RMSE at each block, interpolate over wavelength, and
% identify new block 
for B = size(block,1):-1:1
    aa = [block(B,1):block(B,2)];% indices in wl_ii and aod_fit
    bb =[block(B,3):block(B,4)]; % indices in wl and aod
    RR = sqrt(nanmean((res(bb)).^2)); %rms(res(bb));
    block(B,8) = RR;
end
RR = interp1(block(:,7), block(:,8), wl,'linear');
if sum(~isnan(RR))>1
RR(isnan(RR)) = interp1(wl(~isnan(RR)),RR(~isnan(RR)),wl(isnan(RR)),'nearest','extrap');
end
% figure; plot(block(:,7), block(:,8), 'o',wl, RR, '-',wl(wl_ii), res(wl_ii),'rs'); 

wl_x_ = (res < 0.5.*RR)&(abs(res)<RR); %this is an extended set of pixels including other close values
[block_x, wl_x] = return_wl_block(unique([find(wl_x_),wl_ii]),wl);

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