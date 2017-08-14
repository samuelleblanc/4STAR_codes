infile = getfullname_('?STAR*.mat','MLO');
pname = ['C:\case_studies\4STAR\data\20170604_MLO_day10pm\4STAR\'];
s4_fname = ['4STAR_20170604star.mat']; 
[pname, s4_fname, ext] = fileparts(infile); 
pname = [pname, filesep]; s4_fname = [s4_fname ext];
xs4 = load([pname,s4_fname],'vis_sun', 'nir_sun');
xs4.vis_sun.wl = xstar_wl(xs4.vis_sun);
xs4.nir_sun.wl = xstar_wl(xs4.nir_sun);

xs4.vis_sun.rate =xstar_rate(xs4.vis_sun.raw, xs4.vis_sun.t, xs4.vis_sun.Str, xs4.vis_sun.Tint);
xs4.nir_sun.rate =xstar_rate(xs4.nir_sun.raw, xs4.nir_sun.t, xs4.nir_sun.Str, xs4.nir_sun.Tint);

[xs4.sza, xs4.saz, xs4.soldst, ~, ~, xs4.sel, xs4.am] = sunae(xs4.vis_sun.Lat, xs4.vis_sun.Lon, xs4.vis_sun.t);
[xs4.m_ray, xs4.m_aero, xs4.m_H2O]=airmasses(xs4.sza, xs4.vis_sun.Alt);
% MLO local pressure on 2017/06/07: mlo_met_metric.jpg = 683.2 mb
xs4.vis_sun.Pst = xs4.vis_sun.Pst + 683.2;
[xs4.vis_sun.tau_ray]=rayleighez(xs4.vis_sun.wl,xs4.vis_sun.Pst,xs4.vis_sun.t,xs4.vis_sun.Lat); % Rayleigh
xs4.vis_sun.tr = tr(xs4.m_ray, xs4.vis_sun.tau_ray);
% tr(s.m_ray, s.tau_ray)    
    

Str0 = zeros(size(xs4.vis_sun.t)); Str0(xs4.vis_sun.Str~=0) = NaN;
Str1 = zeros(size(xs4.vis_sun.t)); Str1(xs4.vis_sun.Str~=1) = NaN;
Str2 = zeros(size(xs4.vis_sun.t)); Str2(xs4.vis_sun.Str~=2) = NaN;

figure; plot(serial2hs(xs4.vis_sun.t), xs4.vis_sun.QdVlr+Str1,'kx',serial2hs(xs4.vis_sun.t), xs4.vis_sun.QdVtb+Str1,'bo');
xl = xlim;xl_ = serial2hs(xs4.vis_sun.t)>=xl(1) & serial2hs(xs4.vis_sun.t)<= xl(2);
% Az_offset = mean(xs4.saz(xl_)-xs4.vis_sun.AZ_deg(xl_)); El_offset = mean(xs4.sel(xl_)-xs4.vis_sun.El_deg(xl_));
% xs4.SA = scat_ang_degs(xs4.sza, xs4.saz, 90-(xs4.vis_sun.El_deg+El_offset), xs4.vis_sun.AZ_deg+Az_offset);
% figure; plot(serial2hs(xs4.vis_sun.t), xs4.SA + Str2, 'o');
% now
edges = false(size(xs4.vis_sun.t));
edges(1:end-1) = xs4.vis_sun.Str(1:end-1)==2 & xs4.vis_sun.Str(2:end)==1; 
edge.ii = find(edges);
edge.t = xs4.vis_sun.t(edge.ii);
edge.sel = xs4.sel(edge.ii +1);
edge.saz = xs4.saz(edge.ii +1);
edge.az_offset = xs4.saz(edge.ii+1) - xs4.vis_sun.AZ_deg(edge.ii+1);
edge.sa = scat_ang_degs(xs4.sza(edge.ii), xs4.saz(edge.ii), xs4.sza(edge.ii), xs4.vis_sun.AZ_deg(edge.ii) + edge.az_offset);
% edge.vis_sun.rate_CW = xs4.vis_sun.rate(edge.ii-1,:); edge.vis_sun.rate_CCW = xs4.vis_sun.rate(edge.ii-5,:);
for ii = length(edge.ii):-1:1;
   edge.sky_CW(ii,:) = mean(xs4.vis_sun.rate(edge.ii(ii)+[-1:0],:));
   edge.sky_CCW(ii,:) = mean(xs4.vis_sun.rate(edge.ii(ii)+[-4:-3],:));
end
xs4.vis_sun.sky_CW = interp1(edge.t, edge.sky_CW, xs4.vis_sun.t,'linear');
xs4.vis_sun.sky_CCW = interp1(edge.t, edge.sky_CCW, xs4.vis_sun.t,'linear');
figure; plot(xs4.am(xl_), Str1(xl_)+ log10(xs4.vis_sun.rate(xl_,400)),'x-');
am_ = xs4.am<15&xs4.am>1.5;
figure; plot(xs4.vis_sun.sky_CW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400), ...
   Str1(xl_&am_)+ log10(xs4.vis_sun.rate(xl_&am_,400)),'bx-',...
   xs4.vis_sun.sky_CCW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400), ...
   Str1(xl_&am_)+ log10(xs4.vis_sun.rate(xl_&am_,400)),'ro-');
legend('Az CW','Az CCW');
xlabel('direct normal / diffuse sky');
 ylabel('log_1_0(direct normal)');
title({'4STAR "diffuse assisted" Langley'; ['Pixel 400 during PM Langley ',datestr(xs4.vis_sun.t(1),'yyyy-mm-dd')]});


figure; plot(xs4.vis_sun.sky_CW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400), ...
   Str1(xl_&am_)+ log10(xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400)),'bx-',...
   xs4.vis_sun.sky_CCW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400), ...
   Str1(xl_&am_)+ log10(xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400)),'ro-')
legend('Az CW','Az CCW');
xlabel('direct normal / diffuse sky');
 ylabel('log_1_0(direct normal / Tr_R_a_y)');
title({'4STAR "CW diffuse assisted" Langley'; ['Pixel 400 during PM Langley ',datestr(xs4.vis_sun.t(1),'yyyy-mm-dd')]});

% figure; plot(xs4.vis_sun.sky_CW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400), ...
%    Str1(xl_&am_)+ log10(xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400)),'bx-',...
%    xs4.vis_sun.sky_CCW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400), ...
%    Str1(xl_&am_)+ log10(xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400)),'ro-')
% legend('Az CW','Az CCW');
% xlabel('direct normal / diffuse sky / Tr_R_a_y');
%  ylabel('log_1_0(direct normal / Tr_R_a_y)');
% title({'4STAR "diffuse assisted" Langley'; ['Pixel 400 during PM Langley ',datestr(xs4.vis_sun.t(1),'yyyy-mm-dd')]});
% % !! Doesn't work !!
% % This doesn't work because it removes the Rayleigh component of the direct
% % beam but doesn't adjust the Rayleigh contribution to sky radiance.  


X = xs4.vis_sun.sky_CW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400);
Y = Str1(xl_&am_)+ log(xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400));
figure_(990); scatter(X, Y,64, xs4.am(xl_&am_));
xl = xlim; xl(1) = 0; xlim(xl); hold('on'); 
bad = isNaN(X) | isNaN(Y); X(bad) = []; Y(bad) = [];
P_CW_ln = polyfit(X,Y,1); 
Io_CW_asst_ref_ = exp(P_CW_ln(2));
[Io_CW_asst_ref, tau,P_CW,good] = rlang(X, exp(Y),2.75,10);
figure_(990);hold('on');
plot(X(~good), Y(~good),'.','color',[.5,.5,.5]); plot(xl, polyval(P_CW,xl), 'r-');
legend('Az CW','excluded', 'fit line');
xlabel('direct normal / diffuse sky');
 ylabel('ln(direct normal / Tr_R_a_y)');
title({'4STAR "CW diffuse assisted" Langley'; ['Pixel 400 during PM Langley ',...
   datestr(xs4.vis_sun.t(1),'yyyy-mm-dd')]});
hold('off');

X = xs4.vis_sun.sky_CCW(xl_&am_,400)./xs4.vis_sun.rate(xl_&am_,400);
Y = Str1(xl_&am_)+ log(xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400));
figure_(991); scatter(X, Y,64, xs4.am(xl_&am_));
xl = xlim; xl(1) = 0; xlim(xl); hold('on'); 
bad = isNaN(X) | isNaN(Y); X(bad) = []; Y(bad) = [];
P_CCW_ln = polyfit(X,Y,1); 
Io_CCW_asst_ref_ = exp(P_CCW_ln(2));
[Io_CCW_asst_ref, tau,P_CCW,good] = rlang(X, exp(Y),2.75,10);
figure_(991);hold('on');
plot(X(~good), Y(~good),'.','color',[.5,.5,.5]); plot(xl, polyval(P_CCW,xl), 'r-');
legend('Az CCW','excluded', 'fit line');
xlabel('direct normal / diffuse sky');
 ylabel('ln(direct normal / Tr_R_a_y)');
title({'4STAR "CCW diffuse assisted" Langley'; ['Pixel 400 during PM Langley ',...
   datestr(xs4.vis_sun.t(1),'yyyy-mm-dd')]});
hold('off');


% figure; scatter(xs4.m_aero(xl_&am_), Str1(xl_&am_)+ log10(xs4.vis_sun.rate(xl_&am_,400)...
%    ./xs4.vis_sun.tr(xl_&am_,400)),64, xs4.am(xl_&am_));
X = xs4.m_aero(xl_&am_);
Y = Str1(xl_&am_)+ log(xs4.vis_sun.rate(xl_&am_,400)./xs4.vis_sun.tr(xl_&am_,400));
figure_(992); scatter(X, Y,64, xs4.am(xl_&am_));
xl = xlim; xl(1) = 0; xlim(xl); hold('on'); 
bad = isNaN(X) | isNaN(Y); X(bad) = []; Y(bad) = [];
P_lang_ref = polyfit(X,Y,1); 
Io_refined_ = exp(P_CCW_ln(2));
[Io_refined, tau,P_lang_ref,good] = rlang(X, exp(Y),2.75,10);
figure_(992);hold('on');
plot(X(~good), Y(~good),'.','color',[.5,.5,.5]); plot(xl, polyval(P_lang_ref,xl), 'r-');
legend('"refined" Langley','excluded', 'fit line');
xlabel('aerosol air mass');
 ylabel('ln(direct normal / Tr_R_a_y)');
title({'4STAR "refined" Langley'; ['Pixel 400 during PM Langley ',...
   datestr(xs4.vis_sun.t(1),'yyyy-mm-dd')]});
hold('off');



bad = isNaN(X) | isNaN(Y); X(bad) = []; Y(bad) = [];
P_lang_ref = polyfit(X,Y,1); 
Io_lang_ref = 10.^P_lang_ref(2);
xl = xlim; xl(1) = 0; xlim(xl); hold('on'); 
plot(xl, polyval(P_lang_ref,xl), 'r-');
legend('"refined" Langley', 'fit line');
xlabel('air mass [aerosol]');
ylabel('log_1_0(direct normal / Tr_R_a_y)');
title({'4STAR refined Langley'; ['Pixel 400 during PM Langley ',datestr(xs4.vis_sun.t(1),'yyyy-mm-dd')]});

% NIR
