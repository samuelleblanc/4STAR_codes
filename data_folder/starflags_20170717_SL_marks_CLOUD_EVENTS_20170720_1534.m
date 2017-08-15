function marks = starflags_20170717_SL_marks_CLOUD_EVENTS_20170720_1534  
 % starflags file for 20170717 created by SL on 20170720_1534 to mark CLOUD_EVENTS conditions 
 version_set('20170720_1534'); 
 daystr = '20170717';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('15:04:02') datenum('15:04:33') 700 
datenum('16:19:47') datenum('17:35:44') 700 
datenum('17:42:29') datenum('17:48:54') 700 
datenum('17:55:59') datenum('17:57:34') 700 
datenum('17:57:47') datenum('18:17:37') 700 
datenum('18:20:08') datenum('18:26:33') 700 
datenum('18:27:06') datenum('18:27:19') 700 
datenum('18:27:26') datenum('18:29:24') 700 
datenum('18:29:32') datenum('18:29:57') 700 
datenum('18:30:05') datenum('18:33:54') 700 
datenum('18:38:41') datenum('19:09:37') 700 
datenum('19:28:49') datenum('19:29:10') 700 
datenum('19:32:11') datenum('19:32:14') 700 
datenum('19:32:30') datenum('19:32:36') 700 
datenum('19:33:04') datenum('19:33:09') 700 
datenum('19:33:26') datenum('19:33:59') 700 
datenum('19:41:59') datenum('19:42:16') 700 
datenum('20:24:09') datenum('20:24:09') 700 
datenum('20:36:28') datenum('20:37:45') 700 
datenum('20:37:50') datenum('20:37:50') 700 
datenum('20:37:58') datenum('20:37:58') 700 
datenum('20:38:11') datenum('20:50:19') 700 
datenum('15:04:02') datenum('15:04:33') 10 
datenum('16:19:43') datenum('17:35:44') 10 
datenum('17:42:29') datenum('17:48:54') 10 
datenum('17:55:59') datenum('18:17:37') 10 
datenum('18:17:48') datenum('18:17:49') 10 
datenum('18:20:08') datenum('18:26:33') 10 
datenum('18:27:06') datenum('18:29:26') 10 
datenum('18:29:32') datenum('18:29:57') 10 
datenum('18:30:05') datenum('18:33:54') 10 
datenum('18:34:00') datenum('18:34:01') 10 
datenum('18:34:04') datenum('18:34:04') 10 
datenum('18:38:41') datenum('19:09:37') 10 
datenum('19:27:27') datenum('19:27:27') 10 
datenum('19:27:35') datenum('19:27:39') 10 
datenum('19:27:59') datenum('19:27:59') 10 
datenum('19:28:45') datenum('19:29:10') 10 
datenum('19:30:28') datenum('19:30:28') 10 
datenum('19:30:32') datenum('19:30:34') 10 
datenum('19:32:05') datenum('19:32:14') 10 
datenum('19:32:28') datenum('19:32:36') 10 
datenum('19:33:00') datenum('19:33:09') 10 
datenum('19:33:23') datenum('19:33:59') 10 
datenum('19:34:45') datenum('19:34:45') 10 
datenum('19:41:59') datenum('19:42:16') 10 
datenum('20:24:09') datenum('20:24:09') 10 
datenum('20:26:56') datenum('20:26:56') 10 
datenum('20:36:28') datenum('20:37:45') 10 
datenum('20:37:50') datenum('20:37:50') 10 
datenum('20:37:58') datenum('20:37:58') 10 
datenum('20:38:08') datenum('20:50:19') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return