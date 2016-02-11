% totaly in draft mode, even using legacy file reading utils.  
% changing over to new 4STAR code now...

spc = rd_spc_F4_v2;
nir = rd_spc_F4_v2;

% figure; plot(serial2hs(spc.time), spc.spectra(:,532),'-')
% figure; plot(serial2hs(spc.time(xl_pi)), spc.raw.spectra(xl_pi,532),'ro')
time_hs = serial2hs(spc.time);
pix_cts = spc.raw.spectra(:,532);
figure; plot(time_hs, pix_cts,'o');
done = false;
sun = 1;
while ~done
   k = menu('Select good or done','good','done');
   if k == 1
      xl = xlim;
      xl_ = time_hs>xl(1)&time_hs<xl(2);
      xl_ii = find(xl_);
      ts = time_hs(xl_);
      pix = pix_cts(xl_);
      goods = IQ(pix);
      suny.time(sun) = mean(ts(goods));
      suny.spc(sun,:) = mean(spc.raw.spectra(xl_ii(goods),:));
      sun = sun +1;
   else
      done = true;
   end
end

%%
nsun = 1
done = false;
shade = 1;
while ~done
   k = menu('Select good or done','good','done');
   if k == 1
      xl = xlim;
      xl_ = time_hs>xl(1)&time_hs<xl(2);
      xl_ii = find(xl_);
      ts = time_hs(xl_);
      pix = pix_cts(xl_);
      goods = IQ(pix);
      shady.time(nsun) = mean(ts(goods));
      shady.spc(nsun,:) = mean(spc.raw.spectra(xl_ii(goods),:));
      nsun = nsun +1;
   else
      done = true;
   end
end

shaded = interp1(shady.time, shady.spc, suny.time, 'linear','extrap');
direct = suny.spc - shaded;
mean_direct = mean(direct);
std_direct = std(direct);
figure; these = plot(spc.nm, suny.spc(4:6,:)-ones(3,1)*mean(suny.spc(4:6,:)),'-'); recolor(these, suny.time); title('suny')
figure; these = plot(spc.nm, shaded(4:6,:)-ones(3,1)*mean(shaded(4:6,:)),'-'); recolor(these, suny.time); title('shaded')
figure; these = plot(spc.nm, direct(4:6,:)-ones(3,1)*mean(direct(4:6,:)),'-'); recolor(these, suny.time); title('direct norm')
figure; these = plot(spc.nm, 100.*std(direct(4:6,:))./mean(direct(4:6,:)),'-'); ; title('% direct norm')

%Do = D_panel * (2pi / ref) * 1/(exp(-tau*airmass));  

%So, "direct" is the raw counts for the direct solar beam contribution to
%the signal from the spectralon panel.  Next, divide by integration time.
% Correct for earth-sun distance squared, and so on to get Do. Then divide
% this by ESR to get Responsivity

save('D:\data\4STAR\yohei\MLO_2016_Jan\20160112_MLO_Day4\2016_01_12_dirn_shady.mat')


%%