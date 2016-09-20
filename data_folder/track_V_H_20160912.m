% clear all
% close all
% daystr='20160912';

vertprofs=[datenum('07:33:00') datenum('07:58:00'); ...
datenum('11:00:00') datenum('11:18:00'); ...
datenum('12:21:00') datenum('12:42:00'); ...
datenum('12:58:00') datenum('13:08:00'); ...
datenum('14:05:00') datenum('14:31:00'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

horilegs=[datenum('08:00:00') datenum('11:00:00'); ... %transit at 18kft
datenum('11:18:00') datenum('11:32:00'); ... %below-cloud
datenum('11:33:00') datenum('11:44:00'); ... %in-cloud
datenum('11:45:00') datenum('11:56:00'); ... %above-cloud
datenum('12:47:00') datenum('12:57:00'); ... %level leg through aerosol plume
datenum('13:08:00') datenum('13:18:00'); ... %level leg through aerosol plume
datenum('13:22:00') datenum('13:32:00'); ... %in-cloud
datenum('13:32:00') datenum('13:43:00'); ... %in-cloud
datenum('13:43:00') datenum('13:55:00'); ... %above-cloud
datenum('14:31:00') datenum('15:24:00'); ... %transit at 18kft/13kft
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
