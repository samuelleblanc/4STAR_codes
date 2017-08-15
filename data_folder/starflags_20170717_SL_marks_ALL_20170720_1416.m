function marks = starflags_20170717_SL_marks_ALL_20170720_1416  
 % starflags file for 20170717 created by SL on 20170720_1416 to mark ALL conditions 
 version_set('20170720_1416'); 
 daystr = '20170717';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('15:03:44') datenum('16:17:32') 700 
datenum('16:19:47') datenum('17:35:44') 700 
datenum('17:42:29') datenum('17:48:54') 700 
datenum('17:49:38') datenum('17:57:34') 700 
datenum('17:57:47') datenum('18:17:37') 700 
datenum('18:20:08') datenum('18:26:33') 700 
datenum('18:27:06') datenum('18:27:19') 700 
datenum('18:27:26') datenum('18:29:24') 700 
datenum('18:29:32') datenum('18:29:57') 700 
datenum('18:30:05') datenum('18:33:54') 700 
datenum('18:38:41') datenum('19:27:09') 700 
datenum('19:27:41') datenum('19:27:41') 700 
datenum('19:28:25') datenum('19:28:29') 700 
datenum('19:28:49') datenum('19:30:24') 700 
datenum('19:32:11') datenum('19:32:14') 700 
datenum('19:32:30') datenum('19:32:36') 700 
datenum('19:33:04') datenum('19:33:09') 700 
datenum('19:33:26') datenum('19:33:59') 700 
datenum('19:41:59') datenum('20:01:39') 700 
datenum('20:03:44') datenum('20:24:09') 700 
datenum('20:28:52') datenum('20:28:56') 700 
datenum('20:36:28') datenum('20:37:50') 700 
datenum('20:37:58') datenum('20:37:58') 700 
datenum('20:38:11') datenum('20:50:20') 700 
datenum('15:03:44') datenum('20:24:22') 10 
datenum('20:24:39') datenum('20:28:51') 10 
datenum('20:28:53') datenum('20:50:20') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return