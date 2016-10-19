function stardirty_KORUS()
%% PURPOSE:
%   Conglomerate of dirty window analysis for KORUS-AQ
%
% CALLING SEQUENCE:
%   stardirty_KORUS()
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
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2016-10-17
% -------------------------------------------------------------------------

%% Start of function
version_set('1.0');

campaign = 'KORUS-AQ'

%% set up the different data for the flights.
fp = ['C:\Users\sleblan2\Research\' campaign '\data\FORJ\'];

d.t02.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.t02.daystr = '20160427';

d.f01.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f01.daystr = '20160501';

d.f02.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f02.daystr = '20160503';

d.f03.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f03.daystr = '20160504';

d.f04.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f04.daystr = '20160506';

d.f05.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f05.daystr = '20160510';

d.f06.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f06.daystr = '20160511';

d.f07.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f07.daystr = '20160512';

d.f08.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f08.daystr = '20160516';

d.f09.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f09.daystr = '20160517';

d.f10.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f10.daystr = '20160519';

d.f11.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f11.daystr = '20160521';

d.f12.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f12.daystr = '20160524';

d.f13.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f13.daystr = '20160526';

d.f14.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f14.daystr = '20160529';

d.f15.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f15.daystr = '20160530';

d.f16.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f16.daystr = '20160601';

d.f17.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f17.daystr = '20160602';

d.f18.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f18.daystr = '20160604';

d.f19.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f19.daystr = '20160608';

d.f20.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.f20.daystr = '20160609';

d.t03.f = [fp '4STAR_KORUSstar_FORJ.mat'];
d.t03.daystr = '20160614';

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
    
    save([fp campaign '_dirty_summary.mat'],'spc_diff','d','days','spc_tx')
else;
    load([fp campaign '_dirty_summary.mat']);
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
title(['Clean dirty comparison for ' campaign])
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

save_fig(2,[fp campaign '_dirty_clean_summary'])

%% Now make the figure f transmittance
figure(3);

bar([abs(spc_tx(:,i630)),abs(spc_tx(:,i550)),abs(spc_tx(:,i450))],'EdgeColor','None','BarWidth',1.4)

set(gca,'XTick',1:length(days),'XTickLabel',days)
ylabel('Transmission')
title(['Clean dirty comparison for ' campaign])
%xlabel('Flight days')
%hold off;
legend('630 nm','550 nm','450 nm')
ylim([0.9,1]);
% rotate the xlabels
h = gca;
a=get(h,'XTickLabel');
set(gca,'XTickLabel',[]);
b=get(gca,'XTick');
c=get(gca,'YTick');
th=text(b,repmat(c(1)-.1*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','right','rotation',90);
set(h,'Position',get(h,'Position')+[0 0.05 0 -0.05])

save_fig(3,[fp campaign '_dirty_clean_summary_transmittance'])

end