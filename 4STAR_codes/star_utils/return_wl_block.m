function [block, w_ii] = return_wl_block(w_ii, wl)
% block = return_wl_block(w_ii, wl)
% wl is wavelength
% w_ii are indices (of pixels) into wl or a logical of same length as wl. 
% block is a sequence of rows identifying contiguous blocks of pixels in
% w_ii after excluding isolated "good" pixels.
% col 1: start index in w_ii
% col 2: end index in w_ii
% col 3: start pixel index in wl
% col 4: star pixel index in wl
% col 5: start pixel in nm (or whatever units wl is provided in)
% col 6: ending pixel in nm (or whatever units wl is provided in)
% col 7: mean wl for block

% This block will be used in xfit_aod_basis to define the pixels to compute
% the fit over, and the RMSE of each block to define a wavelength dependent
% envelope for assessing additional pixels for inclusion in the fit.
if islogical(w_ii) && (length(w_ii)==length(wl))
    w_ii = find(w_ii);
end

% Remove isolated good pixels.  Commented section removes isolated bad 
good = false(size(wl)); good(w_ii) = true;
for ww = 2:(length(good)-1)
    if (good(ww)&&~good(ww-1)&&~good(ww+1))
        good(ww) = false;
    end
%     if (~good(ww)&&good(ww-1)&&good(ww+1))
%         good(ww) = true;
%     end
end
w_ii = find(good);

clear block
L = 1; B = 1; 
while L < length(w_ii)
    block(B,1) = L;
    while  (L < length(w_ii)) & ((w_ii(L+1)-w_ii(L)) ==1)
        L = L +1;
    end
    block(B,2) = L; 
    L = L+1; B = B+1;    
end

block(:,3) = w_ii(block(:,1));
block(:,4) = w_ii(block(:,2));
block(:,5) = wl(block(:,3));
block(:,6) = wl(block(:,4));
block(:,7) = (block(:,5)+block(:,6))./2;
% block.header = {'w_ii(start)  w_ii(end)  wl_ii(start) wl_ii(end) nm(start) nm(end) nm_mean'};
% block.datestr = datestr(now,'yyyy-mm-dd HH:MM:SS');
% col 1: start index in w_ii
% col 2: end index in w_ii
% col 3: start pixel index in wl
% col 4: star pixel index in wl
% col 5: start pixel in nm (or whatever units wl is provided in)
% col 6: ending pixel in nm (or whatever units wl is provided in)
% col 7: mean wl for block

return