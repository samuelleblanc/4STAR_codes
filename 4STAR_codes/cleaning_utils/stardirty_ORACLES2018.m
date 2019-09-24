function stardirty_ORACLES2018()
%% PURPOSE:
%   Conglomerate of dirty window analysis for ORACLES, 2018
% CALLING SEQUENCE:
%   stardirty_ORACLES2018
%
% INPUT:
%   - None
%
% OUTPUT:
%  Plots of dirty and clean window differences
%
% DEPENDENCIES:
%  - startup_plotting.m (setup for nice figure plotting, can be safely omitted)
%  - starwrapper.m and required dependencies (updated to handle a single
%  structure, with command toggles)
%  - nanmean and nanstd
%  - save_fig.m (save figures in png and fig)
%  - t2utch.m  (to create decimal utc time from time array)
%  - version_set.m
%  - stardirty.m
%
% NEEDED FILES:
%  - dirty and clean window .dat file or star.mat files
%  - starinfo function files
%
% EXAMPLE:
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2016-10-18
% Modified (v1.1): Samuel LeBlanc, Santa Cruz, CA, 2019-05-05, Happy Cinco do Mayo!
%                  - ported from ORACLES 2016
% -------------------------------------------------------------------------

%% Start of function
version_set('1.1');


%% set up the different data for the flights.
fp = [getnamedpath('ORACLES_2018') 'FORJ\'];

d.f02.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f02.daystr = '20180930';

d.f03.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f03.daystr = '20181002';

d.f04.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f04.daystr = '20181003';

d.f05.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f05.daystr = '20181005';

d.f06.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f06.daystr = '20181007';

%d.f07.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
%d.f07.daystr = '20181010';

%d.f08.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
%d.f08.daystr = '20181012';

d.f09.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f09.daystr = '20181015';

%d.f10.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
%d.f10.daystr = '20181017';

d.f11.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f11.daystr = '20181019';

d.f12.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f12.daystr = '20181021';

d.f13.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f13.daystr = '20181023';

d.f14.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f14.daystr = '20181025';

d.f15.f = [fp '4STAR_ORACLES2018_FORJ_star.mat'];
d.f15.daystr = '20181026';

%d.f16.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
%d.f16.daystr = '20181027';

%% Now run through each day
fld = fields(d)
spc_diff = [];
spc_tx = [];
days = [];
if true;
    for i=1:length(fld);
        try
            [d.(fld{i}).dirty,d.(fld{i}).clean,d.(fld{i}).diff] = stardirty(d.(fld{i}).daystr,d.(fld{i}).f,true);
            spc_diff = [spc_diff;d.(fld{i}).diff.normdiff];
            spc_tx = [spc_tx;d.(fld{i}).diff.transmit];
        catch
            spc_diff = [spc_diff;spc_diff(end,:).*NaN];
            spc_tx = [spc_tx;spc_tx(end,:).*NaN];
        end;
        days = [days;d.(fld{i}).daystr];
    end;
    
    save([fp 'ORACLES_dirty_summary.mat'],'spc_diff','d','days','spc_tx')
else;
    load([fp 'ORACLES_dirty_summary.mat']);
end;
%% Now make the figure
figure(2);
try
    [nul,i630] = min(abs(d.f01.dirty.w-0.630));
    [nul,i550] = min(abs(d.f01.dirty.w-0.550));
    [nul,i450] = min(abs(d.f01.dirty.w-0.450));
catch
    [nul,i630] = min(abs(d.f03.dirty.w-0.630));
    [nul,i550] = min(abs(d.f03.dirty.w-0.550));
    [nul,i450] = min(abs(d.f03.dirty.w-0.450));
end;
%plot(spc_diff(:,i630),'rx');
%hold on;
%plot(spc_diff(:,i550),'gx');
bar([abs(spc_diff(:,i630)),abs(spc_diff(:,i550))],'EdgeColor','None','BarWidth',1.4)

set(gca,'XTick',1:length(days),'XTickLabel',days)
ylabel('Rate difference [%]')
title('Clean dirty comparison for ORACLES')
%xlabel('Flight days')
%hold off;
legend('630 nm','550 nm')
% rotate the xlabels
h = gca;
a=get(h,'XTickLabel');
set(gca,'XTickLabel',[]);
b=get(gca,'XTick');
c=get(gca,'YTick');
th=text(b,repmat(c(1)-.1*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','right','rotation',90);
set(h,'Position',get(h,'Position')+[0 0.05 0 -0.05])

save_fig(2,[fp 'ORACLES_dirty_clean_summary'])

%% Now make the figure f transmittance
figure(3);

bar([abs(spc_tx(:,i630)),abs(spc_tx(:,i550)),abs(spc_tx(:,i450))],'EdgeColor','None','BarWidth',1.4)

set(gca,'XTick',1:length(days),'XTickLabel',days)
ylabel('Transmission')
title('Clean dirty comparison for ORACLES')
%xlabel('Flight days')
%hold off;
legend('630 nm','550 nm','450 nm')
ylim([0.9,1]);
xlim([0,length(days)+1]);
% rotate the xlabels
h = gca;
a=get(h,'XTickLabel');
set(gca,'XTickLabel',[]);
b=get(gca,'XTick');
c=get(gca,'YTick');
th=text(b,repmat(c(1)-.1*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','right','rotation',90);
set(h,'Position',get(h,'Position')+[0 0.05 0 -0.05])

save_fig(3,[fp 'ORACLES_dirty_clean_summary_transmittance'])

end

