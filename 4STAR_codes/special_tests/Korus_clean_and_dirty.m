dirty = getfullname('*.dat','lamp','Select lamp measurement before cleaning');
dirty = strrep(dirty,'NIR','VIS');
vis_dirty = sphere_spec(dirty);
dirty = strrep(dirty,'VIS','NIR');
nir_dirty = sphere_spec(dirty);


clean = getfullname('*.dat','lamp','Select lamp measurement after cleaning');
clean = strrep(clean,'NIR','VIS');
vis_clean = sphere_spec(clean);
clean = strrep(clean,'VIS','NIR');
nir_clean = sphere_spec(clean);


figure; plot(vis_dirty.nm, 100.*vis_dirty.lamp_rate./vis_clean.lamp_rate, '+b',...
    nir_dirty.nm, 100.*nir_dirty.lamp_rate./nir_clean.lamp_rate, 'xr');
legend('vis dirty/clean','nir dirty/clean');
ylabel('dirty/clean %');
xlabel('wavelength [nm]')
ylim([0,100]);

[~, forj_clean] = TCAPII_forj_az_v2;
[~, forj_dirty] = TCAPII_forj_az_v2;
figure; plot(forj_clean.nm, forj_clean.spec_sans_dark, 'b-',forj_clean.nm, forj_dirty.spec_sans_dark, 'r-')

figure; plot(forj_clean.nm, 100.* forj_dirty.spec_sans_dark./ forj_clean.spec_sans_dark, 'kx')
legend('FORJ dirty/clean')




[~, forj_unstable] = TCAPII_forj_az_v2;
[~, forj_stable] = TCAPII_forj_az_v2;

[~, forj_test] = TCAPII_forj_az_v2;

