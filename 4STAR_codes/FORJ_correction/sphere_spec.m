function star = sphere_spec(vis)
% v2 attempt to clean up darks and lights, added "lights" boolean
if ~exist('vis','var')||~exist(vis,'file');
    vis = getfullname('*.dat','sphere','Select a data file containing sphere measurements.');
end

star =  rd_spc_TCAP_v2(vis);
%%
% Compute Az_deg from AZstep with CW positive
star.t.Az_deg = star.raw.AZstep./50;
% forj_nir.t.Az_deg = -forj_nir.raw.AZstep./50;
recs = [1:length(star.time)]';
pix_630 = interp1(star.nm, [1:length(star.nm)],630,'nearest');
%%
dark = star.t.shutter==0;

darks_spec = mean(star.spectra(dark,:));
% darks_nir = mean(forj_nir.spectra(dark,:))
% figure; plot(star.nm, star.spectra(~dark,:)-ones([sum(~dark),1])*darks,'-'); zoom('on')

%%
 spec = star.spectra-ones([length(star.time),1])*darks_spec;
 lights = star.t.shutter~=0;
 last_dark = find(star.t.shutter==0,1,'last');
 ii = last_dark;
 while star.t.shutter(ii)== 0;
     ii = ii -1;
 end
 stable_end = ii;
  while star.t.shutter(ii)~= 0;
     ii = ii -1;
  end
 stable_start = ii+1;
 lamp_stable = recs>=stable_start & recs<=stable_end;
 lamp_off = recs>last_dark;
 
 lamp_light =  mean(spec(lamp_stable,:))-mean(spec(lamp_off,:));
 figure; 
 ss(1) = subplot(3,1,1); 
 plot(star.nm, spec(lamp_stable,:), '-');
ss(2) = subplot(3,1,2); 
 plot(star.nm, spec(lamp_off,:), '-');
ss(3) = subplot(3,1,3); 
 plot(star.nm, mean(spec(lamp_stable,:))-lamp_light, '-');
linkaxes(ss,'x');
 
star.lamp_rate = lamp_light ./ mean(star.t.t_ms(lamp_stable));
star.lamp_rate;
if mean(star.nm)<1000
    figure; plot(star.nm, star.lamp_rate, 'b-'); 
    legend('lamp rate, vis spectrometer')
else
    figure; plot(star.nm, star.lamp_rate, 'r-'); 
    legend('lamp rate, nir spectrometer')
end

xlabel('wavelength [nm]'); ylabel('count rate [cts/ms]');
tl =title(star.fname); set(tl,'interp','none')

return