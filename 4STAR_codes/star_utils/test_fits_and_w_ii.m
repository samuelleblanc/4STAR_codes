function test_fits_and_w_ii(s,in)
% test_fits_and_w_ii(s,in)

% Written to identify good pixels for tau_fit and to also explore other
% spectral issues
% Several interesting take-aways:
% 2. Possible to improve oxygen A-band c0, but of uncertain benefit
% 3. windows at 1240 nm and 1283 nm vary quasi-independently.  Possibly
% depending on temperature and water vapor profile.  Usually 1283 is
% better, but not always.
%4. Likely able to identify a minimum subset of robust pixels, identify
%contiguous blocks with associated RME or MADS, and contextually extend
%this minimal set with pixels meeting a bias threshold.  Then assess RME of
%minimal and extended
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

% Understand "wl_block"
% Saved semi-permanently at end of test_fits_and_w_ii, menu driven
% Seven columns described thusly:
% col 1: start index in w_ii and aod_fit
% col 2: end index in w_ii and aod_fit
% col 3: start pixel index in wl and aod
% col 4: star pixel index in wl and aod
% col 5: start pixel in nm (or whatever units wl is provided in)
% col 6: ending pixel in nm (or whatever units wl is provided in)
% col 7: mean wl for block

if ~isavar('block')
    blocks = load(getfullname('*block*.mat','block','Select block file indicating contiguous pixels.')); 
    if isfield(blocks,'blocks') block = blocks.blocks; 
    else
        block = blocks;
    end
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
inst_name = s.instrumentname;
least_w_ii = find(least_good);
% Uncomment to save block
saveme = menu('Save the selected pixel set?', 'Yes','No');
if saveme ==1
    block_.header = {'w_ii(start)  w_ii(end)  wl_ii(start) wl_ii(end) nm(start) nm(end) nm_mean'};
    block_.datestr = datestr(now,'yyyy-mm-dd HH:MM:SS');
    block_.instrumentname = inst_name;
    block_.description = string(input('Enter a description of this pixel set, if desired: ','s'));
    block_.wl = 1000.*s.w;
    block_.w_ii = w_ii;
    block_.tau = s.tau_aero(suns_i(1),:);
    block_.blocks = return_wl_block(least_w_ii, 1000.*s.w);
%     block represents contiguous regions of good fit.
    block_file = [getnamedpath('block'),inst_name,'_wl_block.',datestr(now,'yyyymmdd'),'*.mat'];
    N = 1+ length(dir_(block_file)); N_str = sprintf('_%d',N);
    if N == 1
        block_file = [getnamedpath('block'),inst_name,'_wl_block.',datestr(now,'yyyymmdd'),'.mat'];
    else
        block_file = [getnamedpath('block'),inst_name,'_wl_block.',datestr(now,'yyyymmdd'),N_str,'.mat'];
    end
    [block_file_, pname] = uiputfile(block_file);
    save([getnamedpath('block'),block_file_],'-struct','block_');
end
savedef = menu('Use as new default? ','Yes','No');
if savedef==1
    def_block = [getnamedpath('block'),inst_name,'_wl_block.mat'];
    copyfile([getnamedpath('block'),block_file_], def_block,'f')
end
return