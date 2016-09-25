% clear all
% close all
% daystr='20160918';

vertprofs=[datenum('07:05:00') datenum('07:20:00'); ...
datenum('09:15:00') datenum('09:43:00'); ...
datenum('11:19:00') datenum('11:42:30'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

horilegs=[
datenum('07:20:30') datenum('08:33:00'); ...
datenum('09:11:00') datenum('09:21:00'); ... %
datenum('09:49:00') datenum('09:58:40'); ... %
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
