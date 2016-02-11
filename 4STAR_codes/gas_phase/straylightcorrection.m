function corr=straylightcorrection(t,rate,w)

%--------------------------------------------------------%
% this function averages wavelengths<270 nm
% to account for stray light effects - oth order
% this is constant with wavelength and changes with time
%--------------------------------------------------------%

% find wavelength range: 220-270 nm
 nm_0220 = interp1(w,[1:length(w)],0.220,  'nearest');
 nm_0270 = interp1(w,[1:length(w)],0.270,  'nearest');
 
 % average over wavelength
 
 corr = nanmean(rate(:,nm_0220:nm_0270),2);
 
 % plot corr with time
 figure;
 plot(t,corr,'og');
 xlabel('time');
 ylabel('rate (count)');
 title(datestr(t(1),'yyyy-mm-dd'));
 
 % plot corr with airmass
%  figure;
%  plot(airmass,corr,'or');
%  xlabel('airmass');
%  ylabel('rate (count)');
 
 figure;
 plot(t,100*(corr./rate(:,407)),'og');hold on;% 500 nm
 plot(t,100*(corr./rate(:,283)),'ob');hold on;% 400 nm
 legend('500 nm','400 nm');
 xlabel('time');
 ylabel('relative amount of stray light (%)');
 title(datestr(t(1),'yyyy-mm-dd'))
 