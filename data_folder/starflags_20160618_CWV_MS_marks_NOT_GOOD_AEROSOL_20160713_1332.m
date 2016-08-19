function marks = starflags_20160618_CWV_MS_marks_NOT_GOOD_AEROSOL_20160713_1332  
 % starflags file for 20160618 created by MS on 20160713_1332 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160713_1332'); 
 daystr = '20160618';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('15:54:05') datenum('16:03:39') 700 
datenum('16:03:46') datenum('16:10:07') 700 
datenum('18:37:09') datenum('18:37:14') 700 
datenum('18:37:30') datenum('18:37:30') 700 
datenum('18:37:32') datenum('18:37:35') 700 
datenum('19:20:55') datenum('19:20:55') 700 
datenum('19:21:50') datenum('19:21:50') 700 
datenum('19:23:31') datenum('19:23:31') 700 
datenum('19:30:25') datenum('19:30:28') 700 
datenum('19:31:30') datenum('19:32:41') 700 
datenum('19:35:24') datenum('19:35:32') 700 
datenum('19:58:15') datenum('19:58:15') 700 
datenum('20:02:56') datenum('20:03:25') 700 
datenum('20:03:35') datenum('20:03:48') 700 
datenum('20:03:51') datenum('20:03:59') 700 
datenum('20:04:02') datenum('20:04:06') 700 
datenum('20:13:22') datenum('20:13:22') 700 
datenum('20:14:22') datenum('20:14:22') 700 
datenum('20:26:10') datenum('20:26:13') 700 
datenum('20:37:49') datenum('20:37:50') 700 
datenum('20:37:56') datenum('20:38:00') 700 
datenum('20:38:26') datenum('20:38:29') 700 
datenum('20:39:36') datenum('20:39:38') 700 
datenum('20:39:40') datenum('20:39:41') 700 
datenum('20:40:44') datenum('20:40:45') 700 
datenum('20:59:14') datenum('20:59:18') 700 
datenum('20:59:34') datenum('20:59:40') 700 
datenum('21:00:02') datenum('21:00:18') 700 
datenum('21:00:30') datenum('21:00:30') 700 
datenum('21:01:57') datenum('21:01:59') 700 
datenum('21:02:10') datenum('21:02:11') 700 
datenum('21:02:38') datenum('21:02:38') 700 
datenum('21:15:07') datenum('21:15:14') 700 
datenum('21:15:33') datenum('21:15:52') 700 
datenum('21:22:26') datenum('21:22:32') 700 
datenum('21:45:23') datenum('21:45:27') 700 
datenum('21:46:46') datenum('21:46:48') 700 
datenum('21:50:38') datenum('21:51:46') 700 
datenum('22:09:42') datenum('22:09:52') 700 
datenum('22:30:43') datenum('22:31:35') 700 
datenum('22:31:39') datenum('22:31:39') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return