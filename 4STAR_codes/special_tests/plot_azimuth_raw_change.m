%% Details of the program:
% NAME:
%   plot_azimuth_raw_change
% 
% PURPOSE:
%   plot the change in signal with a change in azimuth on the rotation
%   stage
%
% INPUT:
%  - none
% 
% OUTPUT:
%  - various plots
%
% DEPENDENCIES:
%  - save_fig.m 
%  - startup_plotting.m (for making good looking plots)
%  - version_set.m (for m script version tracking)
%  - t2utch.m 
%
% NEEDED FILES:
%  - 20160208starsun.mat
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, Febuary 9th, 2016
% -------------------------------------------------------------------------

%% Start of function
function plot_azimuth_raw_change
startup_plotting;
version_set('1.0');

s = load('C:\Users\sleblan2\Research\4STAR\roof\20160208\20160208starsun.mat')
f = 'C:\Users\sleblan2\Research\4STAR\roof\20160208\';
s.utc = t2utch(s.t);

%% run through plotting a few things first
figure(1);
ax1 = subplot(3,1,1);
plot(s.utc,s.rateaero(:,400))
ylabel('rateaero')
ax2 = subplot(3,1,2);
plot(s.utc,s.AZ_deg-360.0)
ylabel('Azimuth [deg]')
ax3 = subplot(3,1,3);
plot(s.utc,s.El_deg)
xlabel('UTC [h]')
ylabel('Elevation [deg]')
linkaxes([ax1,ax2,ax3],'x')
save_fig(1,[f 'entire_day.png'],true);

%% set up the cases to analyze
istartp = [4631 5347 6577 7472 8218 8838]; 
iendp = [4851 5568 6798 7693 8333 9061] ;
istartd = [4921 5759 6979 7792 8507 9193];
iendd = [5142 5982 7203 8017 8624 9416];

leg_text = '';
ca = cool(length(istartp));
cw = hot(length(istartp));
for i=1:length(istartp);
    mean_el = mean(s.El_deg(istartp(i):iendp(i)));
    [nul,ip] = min(abs(s.AZ_deg(istartp(i):iendp(i))-300.0))
    [nul,id] = min(abs(s.AZ_deg(istartd(i):iendd(i))-300.0))
    inorm_azp = ip+istartp(i);
    inorm_azd = id+istartd(i);
    figure(i+1);
    plot(s.AZ_deg(istartp(i):iendp(i)),s.rateaero(istartp(i):iendp(i),400)./s.rateaero(inorm_azp,400).*100.0,'b')
    hold on;
    plot(s.AZ_deg(istartd(i):iendd(i)),s.rateaero(istartd(i):iendd(i),400)./s.rateaero(inorm_azd,400).*100.0,'r')
    hold off;
    legend('clockwise','counter-clockwise','location','northwest')
    ylabel('Rate aero change [%]')
    xlabel('Azimuth [deg]')
    title(['Azimuth test for mean Elevation: ' num2str(mean_el) ' wvl:' num2str(s.w(400)*1000) ' nm'])
    ylim([95 105]);
    grid;
    save_fig(i+1,[f 'rate_vs_az_el' num2str(mean_el) '.png'],true);
    
    figure(20);
    plot(s.AZ_deg(istartp(i):iendp(i)),s.rateaero(istartp(i):iendp(i),400)./s.rateaero(inorm_azp,400).*100.0,'color',ca(i,:))
    leg_text = [leg_text; {['clock :' num2str(mean_el)]}];
    hold all;
    plot(s.AZ_deg(istartd(i):iendd(i)),s.rateaero(istartd(i):iendd(i),400)./s.rateaero(inorm_azd,400).*100.0,'color',cw(i,:))
    leg_text = [leg_text; {['c-clock:' num2str(mean_el)]}];
end

legend('location','west')
ylabel('Rate aero change [%]')
xlabel('Azimuth [deg]')
ylim ([95 105]);
grid;
legend(leg_text,'Location','eastoutside');
hold off;
save_fig(20,[f 'rate_vs_az_all'],true);

end