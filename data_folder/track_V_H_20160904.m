% clear all
% close all
% daystr='20160904';

horilegs=[datenum('08:11:23') datenum('08:40:27'); ...
datenum('08:45:10') datenum('08:49:31'); ...
datenum('09:28:27') datenum('09:33:21'); ...
datenum('09:55:09') datenum('10:05:27'); ...
datenum('10:59:28') datenum('11:09:10'); ...
datenum('11:21:57') datenum('11:24:32'); ...
datenum('11:27:09') datenum('11:55:15'); ...
datenum('12:08:35') datenum('13:13:09'); ...
datenum('13:33:27') datenum('13:38:24'); ...
datenum('13:40:13') datenum('14:55:31'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

vertprofs=[datenum('07:36:22') datenum('07:52:03'); ...
datenum('07:52:03') datenum('08:11:23'); ...
datenum('08:40:27') datenum('08:45:10'); ...
datenum('08:49:31') datenum('09:28:27'); ...
datenum('09:33:21') datenum('09:55:09'); ...
datenum('10:05:27') datenum('10:59:28'); ...
datenum('11:09:10') datenum('11:21:57'); ...
datenum('11:24:32') datenum('11:27:09'); ...
datenum('11:55:15') datenum('12:08:35'); ...
datenum('13:13:09') datenum('13:33:27'); ...
datenum('13:38:24') datenum('13:40:13'); ...
datenum('14:55:31') datenum('15:23:25'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

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

