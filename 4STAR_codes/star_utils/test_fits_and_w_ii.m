function test_fits_and_w_ii(s,in)
% test_fits_and_w_ii(s,in)

% Written to identify good pixels for tau_fit and to also explore other
% spectral issues
% Several interesting take-aways:
% 1. Possibly significant value down to 270 nm or even lower.
% 2. Possible to improve oxygen A-band c0, but of uncertain benefit
% 3. windows at 1240 nm and 1283 nm vary quasi-independently.  Possibly
% depending on temperature and water vapor profile.  Usually 1283 is
% better, but not always.
%4. Likely able to identify a minimum subset of robust pixels, identify
%contiguous blocks with associated RME or MADS, and contextually extend
%this minimal set with pixels meeting a bias threshold.  Then assess RME of
%minimal and extended.
% Explore what is going on with c0 below 270 nm where we see bat-ears.
% After accounting for O3 below 400 nm, review HCOH retrieval

%2DU - 
% Modify rfit_aod_basis to include a block listing of good_wl that will
% permit piece-wise / block-wise expression of RMS vs wavelength and
% hopefully permit robust flexible screening of pixels near absorption
% features that depend on details of the non-aerosol species.
% Augment to use a scaled version of HCOH since the retrieval is not
% robust.
  

if isavar('in')
    if isfield(in,'w_ii')
        w_ii = in.w_ii;
    end
    if isfield(in.suns)
        suns = in.suns;
    end
    if isafield(in, 'cross_sections')
        cross_sections = in.cross_sections;
    end
end



if ~isavar('block')
    block = load(getfullname('*block*.mat','block','Select block file indicating contiguous pixels.')); 
    if isfield(block,'block') block = block.block; end;
end
if ~isavar('s')
    s = load(getfullname('*starsun*.mat','starsun','Select starsun file.'));
end
wl_ = false(size(s.w));
for b = 1:size(block,1)
    wl_(block(b,3):block(b,4)) = true;
end
w_ii = find(wl_);
if ~isavar('cross_sections')
    [daystr, filen, datatype,instrumentname]=starfilenames2daystr(s.filename, 1);
    cross_sections=taugases(s.t, datatype, s.Alt, s.Pst, s.Lat, s.Lon, s.O3col, s.NO2col,instrumentname);
%     
%     if ~isavar('w_ii')
%         w_ii = get_wvl_subset(s.t(1),instrumentname);
%         [last_wl.wl_, last_wl.wl_ii, last_wl.sky_wl,last_wl.w_fit_ii] = get_last_wl(s);
%         w_ii = last_wl.w_fit_ii;
%     end
end

in.cross_sections = cross_sections;
in.w_ii = w_ii;
% in.w_ii =  s.w_isubset_for_polyfit;
figure; 
ax(1) = subplot(2,1,1); 
plot(s.t, s.Alt, 'o');dynamicDateTicks
ax(2) = subplot(2,1,2);
plot(s.t, s.tau_aero(:,500),'o'); dynamicDateTicks
linkaxes(ax,'x');

menu('Zoom into a period containing good tau aero.','Done')
xl = xlim;
sun_ = (s.Zn==0&s.Str==1&s.t>xl(1)&s.t<xl(2));
suns_i = find(s.Zn==0&s.Str==1&s.t>xl(1)&s.t<xl(2)&isfinite(s.tau_aero(:,500)));

ax(1) = subplot(2,1,1); 
plot(s.t, s.Alt, 'o', s.t(suns_i), s.Alt(suns_i),'r.');dynamicDateTicks
ax(2) = subplot(2,1,2);
plot(s.t, s.tau_aero(:,500),'o',s.t(suns_i), s.tau_aero(suns_i,500),'r.'); dynamicDateTicks
linkaxes(ax,'x');
NN = 25;
for s_i = length(suns_i):-NN:1
    in.suns_i = suns_i(s_i);
    good_wl(s_i,:) = pick_wl_subset(s,in);
    in.w_ii = find(good_wl(s_i,:));
    sprintf('index = %d',s_i)
end
% Now we want to find the intersection of good_wl 
least_good = good_wl(length(suns_i),:);
for s_i = length(suns_i):-NN:1
    sum(least_good)
    least_good = least_good & good_wl(s_i,:);
end

least_w_ii = find(least_good);

block = return_wl_block(least_w_ii, cross_sections.wln);
% block represents contiguous regions of good fit. 
% save('xfit_wl_block.mat','block')
return