% clear all
% close all
% daystr='20160918';

vertprofs=[datenum('08:01:30') datenum('08:11:40'); ...
datenum('08:41:00') datenum('09:15:00'); ...
datenum('09:47:00') datenum('10:06:30'); ...
datenum('10:06:30') datenum('10:24:20'); ...
datenum('11:21:30') datenum('11:29:00'); ...
datenum('11:34:30') datenum('11:40:45'); ...
datenum('11:45:00') datenum('11:51:00'); ...
datenum('12:07:20') datenum('12:14:30'); ...
datenum('13:07:00') datenum('13:22:00'); ...
datenum('14:16:30') datenum('14:27:30'); ...
datenum('15:32:00') datenum('15:55:00'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

horilegs=[
datenum('08:11:40') datenum('08:40:45'); ...
datenum('10:24:30') datenum('10:45:00'); ...
datenum('11:29:30') datenum('11:33:00'); ... %
datenum('13:22:00') datenum('13:33:40'); ... %
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
