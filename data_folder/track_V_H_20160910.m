% clear all
% close all
% daystr='20160910';

vertprofs=[datenum('08:29:00') datenum('08:48:00'); ...
datenum('09:27:15') datenum('09:44:00'); ...
datenum('12:56:00') datenum('13:24:00'); ...
datenum('14:47:00') datenum('15:21:00'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

horilegs=[datenum('09:11:00') datenum('09:21:00'); ... %
datenum('09:49:00') datenum('09:58:40'); ... %
datenum('10:08:00') datenum('10:18:00'); ... %below cloud
datenum('10:22:00') datenum('10:32:00'); ... %in-cloud
datenum('10:58:00') datenum('11:05:00'); ... %above-cloud
datenum('11:53:00') datenum('12:03:00'); ... %below-cloud
datenum('12:05:00') datenum('12:15:00'); ... %in-cloud
datenum('12:17:00') datenum('12:27:00'); ... %above-cloud
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% 
% starmatfile=fullfile(starpaths, [daystr 'star.mat']);
% load(starmatfile);
% 
% hh = figure('units','inches','position',[.1 .2 4 3],'paperposition',[.1 .1 9 7]);
% ok=incl(vis_sun.t,horilegs);
% 
% ok_v = incl(vis_sun.t,vertprofs);
% h1 = plot(vis_sun.t,vis_sun.Alt, '.k', ...
%     vis_sun.t(ok), vis_sun.Alt(ok), '.r',vis_sun.t(ok_v), vis_sun.Alt(ok_v), '.g');
% hold on
% 
% 
% if exist('vis_zen');
%     ok=incl(vis_zen.t,horilegs);
%     ok_v=incl(vis_zen.t,vertprofs);
%     h2=plot(vis_zen.t,vis_zen.Alt, '*b', ...
%         vis_zen.t(ok),vis_zen.Alt(ok), '.r',vis_zen.t(ok_v),vis_zen.Alt(ok_v), '.g');
%     hold on
% end;
% datetick('x','keeplimits');
% title(daystr);
% 
% image1 = strcat('D:\zq_baeri\ORACLES_track\plots\',daystr,'.png');
% print(hh,'-dpng',image1);
% 
% 
% 
