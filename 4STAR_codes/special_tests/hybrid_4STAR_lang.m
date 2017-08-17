function hybrid_4STAR_lang
% Good hybrid Langleys 6/04 PM 6/05 AM

sky_file = getfullname_('*hybridsky*.mat','hybridsky','Select a hybrid sky file.');
[sky] = load(sky_file); [~, filen, ext] = fileparts(sky_file); sky.fname = [filen,ext];
starn.sky = strtok(filen,'_');




figure_(2000);leg_str = {};
for S = length(sky.CW.SA_hybrid):-1:1
   plot(sky.CW.SA{S}.t, sky.CW.SA{S}.rate(:,400),'-',...
      sky.CCW.SA{S}.t, sky.CCW.SA{S}.rate(:,400),'-');hold('on')
   leg_str = {leg_str{:}, sprintf('%2.1d deg CW',sky.CW.SA_hybrid(S)),...
      sprintf('%2.1d deg CCW',sky.CCW.SA_hybrid(S))}; 
end; dynamicDateTicks
legend(leg_str); 

for S = length(sky.CW.SA_hybrid):-1:1
   plot(sky.CW.SA{S}.t, sky.CW.SA{S}.rate(:,400),'r.');hold('on')
end; 
for S = length(sky.CCW.SA_hybrid):-1:1
   plot(sky.CCW.SA{S}.t, sky.CCW.SA{S}.rate(:,400),'g.');hold('on')
end;   
hold('off')

[infile]  = getfullname_('4STAR*star.mat','4STAR_mats', 'Select file for direct beam.');
[pname, fname, ext] = fileparts(infile);
starn.sun = strtok(fname,'_');
s4 = load(infile,'vis_sun', 'nir_sun');
s4.vis_sun.wl = xstar_wl(s4.vis_sun);
s4.nir_sun.wl = xstar_wl(s4.nir_sun);
s4.vis_sun.rate =xstar_rate(s4.vis_sun.raw, s4.vis_sun.t, s4.vis_sun.Str, s4.vis_sun.Tint);
s4.nir_sun.rate =xstar_rate(s4.nir_sun.raw, s4.nir_sun.t, s4.nir_sun.Str, s4.nir_sun.Tint);
[s4.sza, s4.saz, s4.soldst, ~, ~, s4.sel, s4.am] = sunae(s4.vis_sun.Lat, s4.vis_sun.Lon, s4.vis_sun.t);
[s4.m_ray, s4.m_aero, s4.m_H2O]=airmasses(s4.sza, s4.vis_sun.Alt);
% MLO local pressure on 2017/06/07: mlo_met_metric.jpg = 683.2 mb
s4.vis_sun.Pst = s4.vis_sun.Pst + 683.2;
[s4.vis_sun.tau_ray]=rayleighez(s4.vis_sun.wl,s4.vis_sun.Pst,s4.vis_sun.t,s4.vis_sun.Lat); % Rayleigh
s4.vis_sun.tr = tr(s4.m_ray, s4.vis_sun.tau_ray);

s4.nir_sun.Pst = s4.nir_sun.Pst + 683.2;
[s4.nir_sun.tau_ray]=rayleighez(s4.nir_sun.wl,s4.nir_sun.Pst,s4.nir_sun.t,s4.nir_sun.Lat); % Rayleigh
s4.nir_sun.tr = tr(s4.m_ray, s4.nir_sun.tau_ray);

% Interpolate temporally and spectrally.
tmp = interp1(sky.CW.wl(~isNaN(sky.CW.wl)), sky.CW.SA{S}.rate(:,~isNaN(sky.CW.wl))' ,s4.vis_sun.wl','linear')';
s4.vis_sun.sky_CW  = interp1(sky.CW.SA{S}.t, tmp ,s4.vis_sun.t,'linear');

tmp = interp1(sky.CCW.wl(~isNaN(sky.CCW.wl)), sky.CCW.SA{S}.rate(:,~isNaN(sky.CCW.wl))' ,s4.vis_sun.wl','linear')';
s4.vis_sun.sky_CCW  = interp1(sky.CCW.SA{S}.t, tmp ,s4.vis_sun.t,'linear');

% Here we handle the different orientation of nSTAR NIR spectrometers.  
% 4STAR "A" needs to be flipped, but 4STAR "B" does not.

tmp = interp1(sky.CW.wl(~isNaN(sky.CW.wl)), sky.CW.SA{S}.rate(:,~isNaN(sky.CW.wl))' ,s4.nir_sun.wl','linear')';
s4.nir_sun.sky_CW  = interp1(sky.CW.SA{S}.t, tmp ,s4.nir_sun.t,'linear');

tmp = interp1(sky.CCW.wl(~isNaN(sky.CCW.wl)), sky.CCW.SA{S}.rate(:,~isNaN(sky.CCW.wl))' ,s4.nir_sun.wl','linear')';
s4.nir_sun.sky_CCW  = interp1(sky.CCW.SA{S}.t, tmp ,s4.nir_sun.t,'linear');

if ~strcmp(starn.sun,'4STARB') && strcmp(starn.sun,'4STAR')
   s4.nir_sun.rate = fliplr(s4.nir_sun.rate);
end

figure_(201); plot(sky.CW.SA{S}.t, sky.CW.SA{S}.rate(:,400),'o',...
   s4.vis_sun.t,s4.vis_sun.sky_CCW(:,400),'x',s4.vis_sun.t,s4.vis_sun.sky_CW(:,400),'r.'); 
title(['Sky radiance from ',starn.sky, ' matched spectrally and temporally to ', starn.sun])
dynamicDateTicks

Str0 = zeros(size(s4.vis_sun.t)); Str0(s4.vis_sun.Str~=0) = NaN;
Str1 = zeros(size(s4.vis_sun.t)); Str1(s4.vis_sun.Str~=1) = NaN;
Str2 = zeros(size(s4.vis_sun.t)); Str2(s4.vis_sun.Str~=2) = NaN;

figure_(202); plot(s4.vis_sun.t, s4.vis_sun.rate(:,400)+ Str1,'o',...
   s4.vis_sun.t, s4.vis_sun.rate(:,400)+ Str2,'x'); legend([starn.sun,' sun'],[starn.sky ' sky']); dynamicDateTicks
figure_(203); plot(s4.vis_sun.t, s4.sel,'o'); legend('solar elevation angle'); dynamicDateTicks
figure_(204); plot(s4.vis_sun.t, s4.am,'rx'); legend('airmass'); dynamicDateTicks
linkexes;

xl = xlim; xl_ = (s4.vis_sun.t)>=xl(1) & (s4.vis_sun.t)<=xl(2) & ~isNaN(s4.saz);
PM_ = mean(s4.saz(xl_))>180; 
if PM_
   PM_str = ['PM'];
else
   PM_str = ['AM'];
end

figure_(205); plot(s4.am(xl_), Str1(xl_)+ log10(s4.vis_sun.rate(xl_,400)),'x-')

am_ = s4.am<15&s4.am>1.5;
figure; plot(s4.vis_sun.sky_CW(xl_&am_,400)./s4.vis_sun.rate(xl_&am_,400), ...
   Str1(xl_&am_)+ log10(s4.vis_sun.rate(xl_&am_,400)),'bx-',...
   s4.vis_sun.sky_CCW(xl_&am_,400)./s4.vis_sun.rate(xl_&am_,400), ...
   Str1(xl_&am_)+ log10(s4.vis_sun.rate(xl_&am_,400)),'ro-'); xl = xlim;
legend('CW','CCW');
xlim([max([0,xl(1)]), min([10,xl(2)])]);

% Could identify a subset of wavelengths instead of pixel 400 here
[aats.w, aats.fwhm, aats.V0]=aatslambda;
%AATS wavelength to nSTAR pixel
a2s_wii = interp1(s4.vis_sun.wl(~isNaN(s4.vis_sun.wl)), find(~isNaN(s4.vis_sun.wl)),aats.w,'nearest'); 
good = true(size(s4.vis_sun.t(xl_&am_)));
X = s4.vis_sun.sky_CW(xl_&am_,a2s_wii(4))./s4.vis_sun.rate(xl_&am_,a2s_wii(4));
Y = Str1(xl_&am_)+ log(s4.vis_sun.rate(xl_&am_,a2s_wii(4))./s4.vis_sun.tr(xl_&am_,a2s_wii(4)));

bad = isNaN(X) | isNaN(Y) | X < 0.01 | X > 50; 
good = ~bad;
P_CW_ln = polyfit(X(good),Y(good),1); 
Io_CW_asst_ref_ = exp(P_CW_ln(2));
[Io_CW_asst_ref, tau,P_CW,good(good)] = rlang(X(good), exp(Y(good)),2.25,10);

X = s4.vis_sun.sky_CCW(xl_&am_,a2s_wii(4))./s4.vis_sun.rate(xl_&am_,a2s_wii(4));
Y = Str1(xl_&am_)+ log(s4.vis_sun.rate(xl_&am_,a2s_wii(4))./s4.vis_sun.tr(xl_&am_,a2s_wii(4)));
bad = isNaN(X) | isNaN(Y) | X < 0.01 | X > 50; 
good = good&~bad;
[Io_CCW_asst_ref, tau,P_CCW,good(good)] = rlang(X(good), exp(Y(good)),2.75,10);


X = s4.vis_sun.sky_CW(xl_&am_,a2s_wii(8))./s4.vis_sun.rate(xl_&am_,a2s_wii(8));
Y = Str1(xl_&am_)+ log(s4.vis_sun.rate(xl_&am_,a2s_wii(8))./s4.vis_sun.tr(xl_&am_,a2s_wii(8)));
bad = isNaN(X) | isNaN(Y) | X < 0.01 | X > 50; 
good = good&~bad;
[Io_CW_asst_ref, tau,P_CW,good(good)] = rlang(X(good), exp(Y(good)),2.25,10);

X = s4.vis_sun.sky_CCW(xl_&am_,a2s_wii(8))./s4.vis_sun.rate(xl_&am_,a2s_wii(8));
Y = Str1(xl_&am_)+ log(s4.vis_sun.rate(xl_&am_,a2s_wii(8))./s4.vis_sun.tr(xl_&am_,a2s_wii(8)));
bad = isNaN(X) | isNaN(Y) | X < 0.01 | X > 50; 
good = good&~bad;
[Io_CW_asst_ref, tau,P_CCW,good(good)] = rlang(X(good), exp(Y(good)),2.25,10);


% Now we've determined our "good" times, so compute Io values for all
% wavelengths, with both CW and CCW radiance.
Io_CW = NaN(size(s4.vis_sun.wl));
Io_CCW = Io_CW;
Io_ref = Io_CW;
for ii = length(s4.vis_sun.wl):-1:1
   X = s4.vis_sun.sky_CW(xl_&am_,ii)./s4.vis_sun.rate(xl_&am_,ii);
   Y = Str1(xl_&am_)+ log(s4.vis_sun.rate(xl_&am_,ii)./s4.vis_sun.tr(xl_&am_,ii));
   P_CW = polyfit(X(good),Y(good),1); 
   Io_CW(ii) = real(exp(P_CW(2)));
   X = s4.vis_sun.sky_CCW(xl_&am_,ii)./s4.vis_sun.rate(xl_&am_,ii);
   P_CCW = polyfit(X(good),Y(good),1); 
   Io_CCW(ii) = real(exp(P_CCW(2)));  
   X = s4.m_aero(xl_&am_);
   P_ref = polyfit(X(good),Y(good),1); 
   Io_ref(ii) = real(exp(P_ref(2)));  
   end
s4.vis_sun.Io_CW = Io_CW;
s4.vis_sun.Io_CCW = Io_CCW;
s4.vis_sun.Io_ref = Io_ref;

Io_CCW = NaN(size(s4.nir_sun.wl));
Io_CW = Io_CCW;
Io_ref= Io_CCW;
for ii = length(s4.nir_sun.wl):-1:1
   X = s4.nir_sun.sky_CW(xl_&am_,ii)./s4.nir_sun.rate(xl_&am_,ii);
   Y = Str1(xl_&am_)+ log(s4.nir_sun.rate(xl_&am_,ii)./s4.nir_sun.tr(xl_&am_,ii));
   P_CW = polyfit(X(good),Y(good),1); 
   Io_CW(ii) = real(exp(P_CW(2)));
   X = s4.nir_sun.sky_CCW(xl_&am_,ii)./s4.nir_sun.rate(xl_&am_,ii);
   P_CCW = polyfit(X(good),Y(good),1); 
   Io_CCW(ii) = real(exp(P_CCW(2))); 
   X = s4.m_aero(xl_&am_);
   P_ref = polyfit(X(good),real(Y(good)),1); 
   Io_ref(ii) = real(exp(P_ref(2)));     
end
s4.nir_sun.Io_CW = Io_CW;
s4.nir_sun.Io_CCW = Io_CCW;
s4.nir_sun.Io_ref = Io_ref;

disp('Modify these plots to include AATS filter wavelengths')

figure; plot(1000.*s4.vis_sun.wl, s4.vis_sun.Io_ref, '-',...
   1000.*s4.vis_sun.wl, s4.vis_sun.Io_CW, '-',...
   1000.*s4.vis_sun.wl, s4.vis_sun.Io_CCW, '-');
xlabel('wavelength [nm]');
ylabel('cts / ms')
title({['Langleys for ',datestr(s4.vis_sun.t(1),'yyyy-mm-dd'),' , ',PM_str, ' leg'];...
   ['Sky (',starn.sky,sprintf(' %1.0d deg)',sky.CCW.SA_hybrid(S)) ' / Sun(',starn.sun,')']});
legend('Refined','sky CW','sky CCW'); xlim([325,995]); 
saveas(gcf,strrep(infile,'star.mat','_skylang_vis.fig'));

figure; plot(1000.*s4.nir_sun.wl, s4.nir_sun.Io_ref, '-',...
   1000.*s4.nir_sun.wl, s4.nir_sun.Io_CW, '-'...
   ,1000.*s4.nir_sun.wl, s4.nir_sun.Io_CCW, '-')
legend('Refined',[starn.sky,' sky CW'],[starn.sky 'sky CCW']); 
xlabel('wavelength [nm]');
ylabel('cts / ms')
title({['Langleys for ',datestr(s4.vis_sun.t(1),'yyyy-mm-dd'),' , ',PM_str, ' leg'];...
   ['Sky (',starn.sky,sprintf(' %1.0d deg)',sky.CCW.SA_hybrid(S)) ' / Sun(',starn.sun,')']});
xlim([960,1700]); 
saveas(gcf,strrep(infile,'star.mat','_skylang_nir.fig'));

tic
disp('Saving skylang.mat file.  (This may take a minute...)')
save(strrep(infile,'star.mat','_skylang.mat'),'-v7.3','s4')
toc
disp('Consider revising to reduce size of skylang.mat file.')
disp('Either modify code to not carry some fields forward, or delete before saving')
% 
% figure_(990);hold('on');
% plot(X(~good), Y(~good),'.','color',[.5,.5,.5]); plot(xl, polyval(P_CW,xl), 'r-');
% legend('Az CW','excluded', 'fit line');
% xlabel('diffuse sky / direct normal');
%  ylabel('ln(direct normal / Tr_R_a_y)');
% title({'4STAR "CW diffuse assisted" Langley'; ['Pixel 400 during ',PM_str,' Langley ',...
%    datestr(s4.vis_sun.t(1),'yyyy-mm-dd')]});
% hold('off');
% gstr = sprintf('Co = %2.2f',Io_CW_asst_ref);
% gtext(gstr);
% 
% X = s4.vis_sun.sky_CCW(xl_&am_,400)./s4.vis_sun.rate(xl_&am_,400);
% Y = Str1(xl_&am_)+ log(s4.vis_sun.rate(xl_&am_,400)./s4.vis_sun.tr(xl_&am_,400));
% figure_(991); scatter(X, Y,64, s4.am(xl_&am_));
% xl = xlim; xl(1) = 0; xlim(xl); hold('on'); 
% bad = isNaN(X) | isNaN(Y); X(bad) = []; Y(bad) = [];
% P_CCW_ln = polyfit(X,Y,1); 
% Io_CCW_asst_ref_ = exp(P_CCW_ln(2));
% [Io_CCW_asst_ref, tau,P_CCW,good] = rlang(X, exp(Y),2.75,10);
% figure_(991);hold('on');
% plot(X(~good), Y(~good),'.','color',[.5,.5,.5]); plot(xl, polyval(P_CCW,xl), 'r-');
% legend('Az CCW','excluded', 'fit line');
% xlabel('diffuse sky / direct normal');
%  ylabel('ln(direct normal / Tr_R_a_y)');
% title({'4STAR "CCW diffuse assisted" Langley'; ['Pixel 400 during ',PM_str,' Langley ',...
%    datestr(s4.vis_sun.t(1),'yyyy-mm-dd')]});
% hold('off');
% gstr = sprintf('Co = %2.2f',Io_CCW_asst_ref);
% gtext(gstr);
% 

return
