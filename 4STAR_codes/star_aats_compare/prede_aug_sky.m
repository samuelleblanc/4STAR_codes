function skies = prede_aug_sky;
% Reads a Prede file containing sky radiances for augmented Langley



prede = read_prede;
[zen, az, soldst, ha, dec, el, am] = sunae(prede.lat, prede.lon, prede.time);
SA = scat_ang_degs(zen, az, prede.zen, prede.azi);
SA_u = unique(round(SA./2).*2);
fields = fieldnames(prede);
for f = 1:length(fields)
   field = fields{f};
   if strfound(field,'filter')
      prede.([field,'_SA']) = NaN(size(SA_u*prede.time));
      for s = 1:length(SA_u)
         SA_ = (round(SA./2).*2)==SA_u(s);
         prede.([field,'_SA'])(s,:) = interp1(prede.time(SA_), prede.(field)(SA_), prede.time,'linear','extrap');
      end
   end
end
figure; plot(prede.time, prede.filter_2_SA(end,:),'-',...
   prede.time, prede.filter_3_SA(end,:),'-',...
   prede.time, prede.filter_4_SA(end,:),'-',...
   prede.time, prede.filter_5_SA(end,:),'-',...  
   prede.time, prede.filter_7_SA(end,:),'-')
legend('400','500','675','870','1020')
dynamicDateTicks
% SA_45_ij = find(round(SA./2).*2 ==60);
% figure; plot(prede.time(SA_45_ij), prede.filter_3(SA_45_ij), 'g-x'); legend('filter 3 SA=60'); dynamicDateTicks

for wl_i = 2:7;
figure; SAs = plot(prede.time, prede.(sprintf('filter_%d_SA',wl_i)),'-'); dynamicDateTicks; title(sprintf('filter %d: %d nm',wl_i, prede.wl(wl_i)));
legend([sprintf('%d deg',SA_u(1))],[sprintf('%d deg',SA_u(2))],[sprintf('%d deg',SA_u(3))],...
   [sprintf('%d deg',SA_u(4))],[sprintf('%d deg',SA_u(5))],[sprintf('%d deg',SA_u(6))]);
end



return
[P,S,MU] = polyfit(log10(SA_u(4:5)), (prede.filter_2_SA(4:5,1)),1);
[P2,S2,MU2] = polyfit(log10(SA_u(3:5)), (prede.filter_2_SA(3:5,1)),2);
figure; plot((SA_u), prede.filter_2_SA(:,1),'-o',...
   SA_u(2:end),(polyval(P,log10(SA_u(2:end)),[],MU)+polyval(P2,log10(SA_u(2:end)),[],MU2))./2,'r+'); ylabel('rad')
% Because the curvature of the scattering flattens out with increasing SA
% the 2nd order polyfit overpredicts rad(SA==60) but a linear interpolation
% underpredicts.  Maybe average the two to estimate skyrad(SA==60). 

figure; plot(SA_u, log10(prede.filter_2_SA(:,1)),'-',...
   SA_u(2:5), log10(prede.filter_2_SA(2:5,1)),'o',...
   SA_u(2:end),polyval(P,log10(SA_u(2:end))),'x'); ylabel('rad')

figure; plot(SA_u, (prede.filter_2_SA(:,1)),'-',...
   SA_u(2:5), (prede.filter_2_SA(2:5,1)),'o',...
   SA_u(2:end),10.^(polyval(P,log10(SA_u(2:end)))),'x'); ylabel('rad')
