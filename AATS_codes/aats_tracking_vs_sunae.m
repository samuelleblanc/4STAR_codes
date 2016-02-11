% insun = matfile(getfullname);
% 
% allstar = load(getfullname);
% 
% size(allstar.vis_sun.Lat)
% 
% [zen, az, soldst, ha, dec, el, am] = sunae(allstar.vis_sun.Lat, allstar.vis_sun.Lon, allstar.vis_sun.t);
% figure; plot(allstar.vis_sun.t, allstar.vis_sun.AZ_deg - allstar.vis_sun.AZ_deg(1000) + az(1000)- az,'.',...
%  allstar.vis_sun.t, allstar.vis_sun.El_deg - allstar.vis_sun.El_deg(1000) + el(1000)- el,'.'  ); 
% legend('4STAR - Solar Az', '4STAR - Solar El')
% dynamicDateTicks
% 
% aats.time = datenum(aats.year,aats.month,aats.day) + aats.UT./24;
% [aats.solzen, aats.solaz, ~, ~, ~, aats.solel, aats.solam] = sunae(aats.meanlat.*ones(size(aats.time)), aats.meanlon.*ones(size(aats.time)), aats.time);
% 
% figure; plot(aats.time, aats.Az_pos - aats.Az_pos(1000) + aats.solaz(1000)- aats.solaz,'.',...
%  aats.time, aats.Elev_pos - aats.Elev_pos(1000) + aats.solel(1000)- aats.solel,'.'  ); 
% legend('AATS - Solar Az', 'AATS- Solar El')
% dynamicDateTicks
% ax(1) =gca; ax(2) = gca;
% linkaxes(ax,'xy')
% 
% aats9 = load(getfullname);
% aats9.time = datenum(aats9.year,aats9.month,aats9.day) + aats9.UT./24;
% [aats9.solzen, aats9.solaz, ~, ~, ~, aats9.solel, aats9.solam] = sunae(aats9.meanlat.*ones(size(aats9.time)), aats9.meanlon.*ones(size(aats9.time)), aats9.time);
% 
% figure; plot(aats9.time, aats9.Az_pos - aats9.Az_pos(1000) + aats9.solaz(1000)- aats9.solaz,'.',...
%  aats9.time, aats9.Elev_pos - aats9.Elev_pos(1000) + aats9.solel(1000)- aats9.solel,'.'  ); 
% legend('AATS9 - Solar Az', 'AATS9- Solar El')
% dynamicDateTicks
% ax(1) =gca; ax(2) = gca;
% linkaxes(ax,'xy')


aats11 = load(getfullname);
aats11.time = datenum(aats11.year,aats11.month,aats11.day) + aats11.UT./24;
[aats11.solzen, aats11.solaz, ~, ~, ~, aats11.solel, aats11.solam] = sunae(aats11.meanlat.*ones(size(aats11.time)), aats11.meanlon.*ones(size(aats11.time)), aats11.time);

figure; plot(aats11.time, aats11.Az_pos - aats11.Az_pos(1000) + aats11.solaz(1000)- aats11.solaz,'.',...
 aats11.time, aats11.Elev_pos - aats11.Elev_pos(1000) + aats11.solel(1000)- aats11.solel,'.'  ); 
legend('aats11 - Solar Az', 'aats11- Solar El')
dynamicDateTicks


