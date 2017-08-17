[STARA.CW, STARA.CCW] = get_hybrid_skies;
[STARB.CW, STARB.CCW] = get_hybrid_skies;

pname = ['C:\case_studies\4STAR\data\20170604_MLO_day10pm\4STAR\'];
% s2_fname = ['4STAR_20170603star.mat']; 
% props = properties(matfile([pname,s2_fname]));
% s2 = load([pname,s2_fname],'vis_sun');

s4_fname = ['4STAR_20170604star.mat']; 
s4 = load([pname,s4_fname],'vis_sun', 'nir_sun');

figure; ax(1) = subplot(2,1,1); plot(serial2hs(s4.vis_sun.t), s4.vis_sun.El_deg,'o-')
ax(2) = subplot(2,1,2); plot(serial2hs(s4.vis_sun.t), s4.vis_sun.AZ_deg,'x-'); linkaxes(ax,'x');


[s4.sza, s4.saz, s4.soldst, ~, ~, s4.sel, s4.am] = sunae(s4.vis_sun.Lat, s4.vis_sun.Lon, s4.vis_sun.t);

Str0 = zeros(size(s4.vis_sun.t)); Str0(s4.vis_sun.Str~=0) = NaN;
Str1 = zeros(size(s4.vis_sun.t)); Str1(s4.vis_sun.Str~=1) = NaN;
Str2 = zeros(size(s4.vis_sun.t)); Str2(s4.vis_sun.Str~=2) = NaN;

figure; plot(s4.vis_sun.t, s4.vis_sun.Tint+Str0,'o-',s4.vis_sun.t, s4.vis_sun.Tint+Str1,'x-',...
   s4.vis_sun.t, s4.vis_sun.Tint+Str2,'*-'); legend('Str 0','Str 1', 'Str 2')

figure;darks = plot([1:1044], flipud(s4.vis_sun.raw(s4.vis_sun.Str==0&s4.vis_sun.Tint>40,:)),'-'); 
recolor(darks, serial2hs(s4.vis_sun.t(s4.vis_sun.Str==0&s4.vis_sun.Tint>40)));
unique(s4.vis_sun.Tint(s4.vis_sun.Str==2))
% figure;plot([1:1044], flipud(s4.vis_sun.raw(s4.vis_sun.Str==0&s4.vis_sun.Tint>40,:)),'k-',...
%    [1:1044], flipud(s4.vis_sun.raw(s4.vis_sun.Str==0&s4.vis_sun.Tint==5,:)),'b-',...
% [1:1044], flipud(s4.vis_sun.raw(s4.vis_sun.Str==0&s4.vis_sun.Tint==10,:)),'g-',...
% [1:1044], flipud(s4.vis_sun.raw(s4.vis_sun.Str==0&s4.vis_sun.Tint==20,:)),'r-'); 

Tint = [4,50];
dark = zeros(2,1044);
s4.rate = zeros(size(s4.vis_sun.raw));
s4.sig = s4.rate;
for tt = length(Tint):-1:1
dark(tt,:) = mean(s4.vis_sun.raw(s4.vis_sun.Str==0&s4.vis_sun.Tint==Tint(tt),:));
s4.sig(s4.vis_sun.Tint==Tint(tt),:) = s4.vis_sun.raw(s4.vis_sun.Tint==Tint(tt),:)-ones([sum(s4.vis_sun.Tint==Tint(tt)),1])*dark(tt,:);
s4.rate(s4.vis_sun.Tint==Tint(tt),:) = s4.sig(s4.vis_sun.Tint==Tint(tt),:)./Tint(tt);
end

figure; scatter(find(s4.vis_sun.Str==0), s4.vis_sun.raw(s4.vis_sun.Str==0,[400]),32,s4.vis_sun.Tint(s4.vis_sun.Str==0),'filled');

figure; plot(serial2hs(s4.vis_sun.t), s4.vis_sun.QdVlr+Str1,'kx',serial2hs(s4.vis_sun.t), s4.vis_sun.QdVtb+Str1,'bo');
xl = xlim;xl_ = serial2hs(s4.vis_sun.t)>=xl(1) & serial2hs(s4.vis_sun.t)<= xl(2);
figure; plot(serial2hs(s4.vis_sun.t(xl_)), s4.sel(xl_), 'o',serial2hs(s4.vis_sun.t(xl_)), s4.vis_sun.El_deg(xl_),'x');
figure; plot(serial2hs(s4.vis_sun.t(xl_)), s4.saz(xl_), 'o',serial2hs(s4.vis_sun.t(xl_)), s4.vis_sun.AZ_deg(xl_),'x');
figure; plot(serial2hs(s4.vis_sun.t(xl_)), s4.saz(xl_)-s4.vis_sun.AZ_deg(xl_),'o',serial2hs(s4.vis_sun.t(xl_)), s4.sel(xl_)-s4.vis_sun.El_deg(xl_),'x');
Az_offset = mean(s4.saz(xl_)-s4.vis_sun.AZ_deg(xl_)); El_offset = mean(s4.sel(xl_)-s4.vis_sun.El_deg(xl_));
s4.SA = scat_ang_degs(s4.sza, s4.saz, 90-(s4.vis_sun.El_deg+El_offset), s4.vis_sun.AZ_deg+Az_offset);
figure; plot(serial2hs(s4.vis_sun.t), s4.SA + Str2, 'o')

figure; plot(serial2hs(s4.vis_sun.t), s4.vis_sun.AZ_deg+ Str2-Az_offset,'o');
figure; plot(serial2hs(s4.vis_sun.t), s4.vis_sun.raw(:,400)+ Str1,'o',serial2hs(s4.vis_sun.t), s4.vis_sun.raw(:,400)+ Str2,'*');
figure; plot(serial2hs(s4.vis_sun.t), s4.rate(:,400)+ Str1,'o',serial2hs(s4.vis_sun.t), s4.rate(:,400)+ Str2,'*');legend('sun','sky')
figure; plot(serial2hs(s4.vis_sun.t), s4.sel,'o'); legend('solar elevation angle')
figure; plot(serial2hs(s4.vis_sun.t), s4.am,'rx') ;legend('airmass')
linkexes;
edges = false(size(s4.vis_sun.t));
edges(1:end-1) = s4.vis_sun.Str(1:end-1)==2 & s4.vis_sun.Str(2:end)==1; 
edge.ii = find(edges);
edge.t = s4.vis_sun.t(edge.ii);
edge.sel = s4.sel(edge.ii +1);
edge.saz = s4.saz(edge.ii +1);
edge.az_offset = s4.saz(edge.ii+1) - s4.vis_sun.AZ_deg(edge.ii+1);
edge.sa = scat_ang_degs(s4.sza(edge.ii), s4.saz(edge.ii), s4.sza(edge.ii), s4.vis_sun.AZ_deg(edge.ii) + edge.az_offset);
% edge.rate_CW = s4.rate(edge.ii-1,:); edge.rate_CCW = s4.rate(edge.ii-5,:);
for ii = 1:length(edge.ii);
   edge.sky_CW(ii,:) = mean(s4.rate(edge.ii(ii)+[-1:0],:));
   edge.sky_CCW(ii,:) = mean(s4.rate(edge.ii(ii)+[-4:-3],:));
end
s4.vis_sun.sky_CW = interp1(edge.t, edge.sky_CW, s4.vis_sun.t,'linear');
s4.vis_sun.sky_CCW = interp1(edge.t, edge.sky_CCW, s4.vis_sun.t,'linear');
figure; plot(s4.am(xl_), Str1(xl_)+ log10(s4.rate(xl_,400)),'x-')
am_ = s4.am<30&s4.am>1.5;
figure; plot(s4.vis_sun.sky_CW(xl_&am_,400)./s4.rate(xl_&am_,400), ...
   Str1(xl_&am_)+ log10(s4.rate(xl_&am_,400)),'bx-',...
   s4.vis_sun.sky_CCW(xl_&am_,400)./s4.rate(xl_&am_,400), Str1(xl_&am_)+ log10(s4.rate(xl_&am_,400)),'ro-')
figure; scatter(s4.vis_sun.sky_CCW(xl_&s4.am<20,400)./s4.rate(xl_&s4.am<20,400), Str1(xl_&s4.am<20)+ log10(s4.rate(xl_&s4.am<20,400)),64, s4.am(xl_&s4.am<20));
X = s4.vis_sun.sky_CW(xl_&s4.am<15,400)./s4.rate(xl_&s4.am<15,400);
Y = Str1(xl_&s4.am<15)+ log10(s4.rate(xl_&s4.am<15,400));
bad = isNaN(X) | isNaN(Y); X(bad) = []; Y(bad) = [];
P_CW = polyfit(X,Y,1); Io_CW = 10.^P_CW(2);
X = s4.vis_sun.sky_CCW(xl_&s4.am<15,400)./s4.rate(xl_&s4.am<15,400);
Y = Str1(xl_&s4.am<15)+ log10(s4.rate(xl_&s4.am<15,400));
bad = isNaN(X) | isNaN(Y); X(bad) = []; Y(bad) = [];
P_CCW = polyfit(X,Y,1); Io_CCW = 10.^P_CCW(2);


figure; scatter(s4.vis_sun.sky_CCW(xl_,400)./s4.rate(xl_,400), Str1(xl_)+ log10(s4.rate(xl_,400)),8, s4.am(xl_),'filled');
xlabel('direct normal / diffuse sky')
 ylabel('log_1_0(direct normal)')
title({'4STAR "diffuse assisted" Langley'; ['Pixel 400 during PM Langley ',datestr(s4.vis_sun.t(1),'yyyy-mm-dd')]})
figure; scatter(s4.vis_sun.sky_CW(xl_,400)./s4.rate(xl_,400), Str1(xl_)+ log10(s4.rate(xl_,400)),8, s4.am(xl_), 'filled');

rrate = xstar_rate(s4.vis_sun.raw, s4.vis_sun.Str, s4.vis_sun.Tint);