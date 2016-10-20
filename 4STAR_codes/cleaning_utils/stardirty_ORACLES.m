function stardirty_ORACLES(dir)
%% PURPOSE:
%   Conglomerate of dirty window analysis for ORACLES
%
% CALLING SEQUENCE:
%   stardirty_ORACLES(dir)
%
% INPUT:
%   - dir: directory of where to find the star.mat data (defaults for Sam)
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
% -------------------------------------------------------------------------

%% Start of function
version_set('1.0');


%% set up the different data for the flights.
fp = 'C:\Users\sleblan2\Research\ORACLES\data\FORJ\';

d.t01.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.t01.daystr = '20160824';

d.t02.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.t02.daystr = '20160825';

d.t03.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.t03.daystr = '20160827';

d.f01.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f01.daystr = '20160830';

d.f02.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f02.daystr = '20160831';

d.f03.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f03.daystr = '20160902';

d.f04.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f04.daystr = '20160904';

d.f05.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f05.daystr = '20160906';

d.f06.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f06.daystr = '20160908';

d.f07.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f07.daystr = '20160910';

d.f08.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f08.daystr = '20160912';

d.f09.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f09.daystr = '20160914';

d.f10.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f10.daystr = '20160918';

d.f11.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f11.daystr = '20160920';

d.f12.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f12.daystr = '20160924';

d.f13.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f13.daystr = '20160925';

d.f14.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f14.daystr = '20160927';

d.f15.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f15.daystr = '20160929';

d.f16.f = [fp '4STAR_ORACLESstar_FORJ.mat'];
d.f16.daystr = '20160930';

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

