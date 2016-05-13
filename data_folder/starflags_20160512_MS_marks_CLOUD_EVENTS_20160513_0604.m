function marks = starflags_20160512_MS_marks_CLOUD_EVENTS_20160513_0604  
 % starflags file for 20160512 created by MS on 20160513_0604 to mark CLOUD_EVENTS conditions 
 version_set('20160513_0604'); 
 daystr = '20160512';  
 % tag = 90: cirrus 
 marks=[ 
 datenum('23:21:40') datenum('23:28:32') 90 
datenum('23:43:11') datenum('23:49:11') 90 
datenum('23:49:18') datenum('24:25:25') 90 
datenum('24:25:32') datenum('24:54:03') 90 
datenum('25:18:04') datenum('25:18:37') 90 
datenum('25:19:40') datenum('25:19:40') 90 
datenum('25:19:42') datenum('25:19:43') 90 
datenum('25:19:45') datenum('25:19:46') 90 
datenum('25:19:58') datenum('25:19:58') 90 
datenum('25:20:01') datenum('25:20:01') 90 
datenum('25:20:03') datenum('25:20:38') 90 
datenum('25:23:45') datenum('25:23:45') 90 
datenum('25:23:48') datenum('25:23:48') 90 
datenum('25:23:52') datenum('25:23:52') 90 
datenum('25:24:59') datenum('25:24:59') 90 
datenum('25:28:29') datenum('25:38:07') 90 
datenum('25:38:14') datenum('25:50:50') 90 
datenum('27:30:49') datenum('27:30:49') 90 
datenum('27:30:57') datenum('27:30:59') 90 
datenum('27:31:29') datenum('27:31:31') 90 
datenum('27:34:25') datenum('27:34:25') 90 
datenum('27:34:28') datenum('27:34:29') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return