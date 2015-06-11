function [s,qq] = restrict_4STAR_wvl_(s)
%restrict_4STAR_wvl.m
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(s.t(1));

%UTdechr=timeMatlab_to_UTdechr(s.t);

idxw=[visc(1:10) nirc(11:13)+1044];
idxwvlvisp=[0 0 1 1 1 1 1 1 1 0 1 1 1];

% resize variables at AATS wvls
s.raw=s.raw(:,idxw);
s.w=s.w(:,idxw);
s.c0=s.c0(idxw);
s.c0err=s.c0err(idxw);
s.fwhm=s.fwhm(idxw);
% s.rate_noFORJcorr=s.rate_noFORJcorr(:,idxw);
s.dark=s.dark(:,idxw);
s.darkstd=s.darkstd(:,idxw);
s.rate=s.rate(:,idxw);
s.rateaero=s.rateaero(:,idxw);
s.tau_aero_noscreening = s.tau_aero_noscreening(:,idxw);
s.flag=s.flag(:,idxw);
s.tau_ray=s.tau_ray(:,idxw);
s.tau_O3=s.tau_O3(:,idxw);
s.tau_NO2=s.tau_NO2(:,idxw);
s.tau_O4=s.tau_O4(:,idxw);
s.tau_CO2_CH4_N2O=s.tau_CO2_CH4_N2O(:,idxw);
s.tau_CO2_CH4_N2O_abserr=s.tau_CO2_CH4_N2O_abserr(:,idxw);
s.forjunc=s.forjunc(:,idxw);
qq=length(s.w);

return