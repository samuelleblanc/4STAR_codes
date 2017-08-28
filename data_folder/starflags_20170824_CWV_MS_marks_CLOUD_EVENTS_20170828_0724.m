function marks = starflags_20170824_CWV_MS_marks_CLOUD_EVENTS_20170828_0724  
 % starflags file for 20170824 created by MS on 20170828_0724 to mark CLOUD_EVENTS conditions 
 version_set('20170828_0724'); 
 daystr = '20170824';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('08:21:50') datenum('08:22:51') 10 
datenum('08:25:16') datenum('08:33:08') 10 
datenum('08:33:20') datenum('08:33:22') 10 
datenum('08:33:38') datenum('08:33:38') 10 
datenum('11:17:49') datenum('11:17:49') 10 
datenum('11:18:51') datenum('11:19:03') 10 
datenum('11:24:28') datenum('11:24:28') 10 
datenum('11:24:30') datenum('11:24:30') 10 
datenum('11:25:57') datenum('11:25:57') 10 
datenum('11:27:13') datenum('11:28:28') 10 
datenum('14:44:26') datenum('14:44:33') 10 
datenum('14:44:49') datenum('14:48:13') 10 
datenum('14:51:55') datenum('14:53:01') 10 
datenum('14:53:36') datenum('14:53:46') 10 
datenum('14:53:51') datenum('14:54:04') 10 
datenum('14:54:09') datenum('14:54:14') 10 
datenum('14:57:46') datenum('14:57:48') 10 
datenum('14:57:53') datenum('14:58:13') 10 
datenum('15:25:35') datenum('15:26:00') 10 
datenum('16:13:08') datenum('16:13:14') 10 
datenum('16:13:18') datenum('16:13:18') 10 
datenum('16:48:55') datenum('16:48:57') 10 
datenum('16:49:03') datenum('16:49:03') 10 
datenum('16:49:08') datenum('16:49:10') 10 
datenum('16:49:23') datenum('16:49:23') 10 
datenum('16:49:28') datenum('16:49:28') 10 
datenum('16:49:33') datenum('17:21:43') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return