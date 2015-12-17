function match_4STAR_aeronet
% For each selected sky_scan mat file, we find the mean time, lat, and lon
% and then find the corresponding AERONET files if any. 
aip = load(['D:\data\seac4rs\INV_Level2_Daily_V2\aeronet_collocated_lv2_daily.mat']);
aip = load(['D:\data\seac4rs\INV_Level2_All_Points_V2\aeronet_collocated_lv2.mat']);
aip =  load(['D:\data\seac4rs\INV_Level15_Daily_V2\DAILY\..\aeronet_collocated_lv1p5_daily.mat']);
pname = ['D:\data\4STAR\yohei\mat\seac4rs_starsky_mats\'];
skys = dir(['D:\data\4STAR\yohei\mat\seac4rs_starsky_mats\*_starsky*.mat']);
done_dir = [];

matched = 0;
for sky = 1:length(skys)
   clear SSA star AOT
   skymat = load([pname, skys(sky).name]); 
%    skymat = load(getfullname(['D:\data\4STAR\yohei\mat\seac4rs_starsky_mats\*_starsky*.mat'],'starsky_mats','Select a starsky.mat file'));
   mean_time = mean(skymat.time);
   mean_lat = mean(skymat.Lat);
   mean_lon = mean(skymat.Lon);
   dist = geodist(aip.lat, aip.lon, mean_lat, mean_lon);
   nearby = (dist<500000);
   recent = (abs(aip.time - mean_time)<(.5));
   notNaN = ~isNaN(aip.SSA440_T);
   skys(sky).name
   sum(nearby & recent & notNaN)
   SSA(1,:) = aip.SSA440_T(recent&nearby&notNaN);
   SSA(2,:) = aip.SSA673_T(recent&nearby&notNaN);
   SSA(3,:) = aip.SSA873_T(recent&nearby&notNaN);
   SSA(4,:) = aip.SSA1020_T(recent&nearby&notNaN);
   AOT(1,:) = aip.AOTExt440_T(recent&nearby&notNaN);
   AOT(2,:) = aip.AOTExt673_T(recent&nearby&notNaN);
   AOT(3,:) = aip.AOTExt873_T(recent&nearby&notNaN);
   AOT(4,:) = aip.AOTExt1020_T(recent&nearby&notNaN);
   
   wl = [440,673,873,1020];
   [~,fname,~] = fileparts(skys(sky).name); 
   stub = ['4STAR_.',fname(1:end-7),'*.mat'];
   star_mats = dir(['C:\z_4STAR\work_2aaa__\4STAR_\done\',stub]);
   for s = 1:length(star_mats)
   starmat = load(['C:\z_4STAR\work_2aaa__\4STAR_\done\',star_mats(1).name])
   star.wl = starmat.Wavelength;
   star.ssa_T(s,:) = starmat.ssa_total;
   star.aod(s,:) = starmat.aod;
   end
   figure(88)
   plot(wl,mean(SSA,2),'k-', 1000.*star.wl, mean(star.ssa_T), '-ro', wl,SSA,'k:',1000.*star.wl, star.ssa_T', 'r:');legend('Aeronet','4STAR');
title([fname(1:end-8)],'interp','none')
ylabel('SSA')
xlabel('wavelength[nm])')
figure(99)
   plot(wl,mean(AOT,2),'k-', 1000.*star.wl, mean(star.aod), '-ro', wl,AOT,'k:',1000.*star.wl, star.aod', 'r:');legend('Aeronet','4STAR');
title([fname(1:end-8)],'interp','none')
ylabel('AOD')
xlabel('wavelength[nm])')
   %scans.anet(sky) = sum(nearby & recent);
end


return