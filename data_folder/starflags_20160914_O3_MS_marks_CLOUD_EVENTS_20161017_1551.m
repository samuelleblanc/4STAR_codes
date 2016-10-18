function marks = starflags_20160914_O3_MS_marks_CLOUD_EVENTS_20161017_1551  
 % starflags file for 20160914 created by MS on 20161017_1551 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1551'); 
 daystr = '20160914';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('11:21:40') datenum('11:21:47') 03 
datenum('11:22:23') datenum('11:22:23') 03 
datenum('11:22:28') datenum('11:22:28') 03 
datenum('11:23:34') datenum('11:23:37') 03 
datenum('11:23:42') datenum('11:23:44') 03 
datenum('11:24:20') datenum('11:24:27') 03 
datenum('12:17:16') datenum('12:18:18') 03 
datenum('11:22:23') datenum('11:22:23') 700 
datenum('11:22:28') datenum('11:22:28') 700 
datenum('11:23:34') datenum('11:23:37') 700 
datenum('11:23:42') datenum('11:23:44') 700 
datenum('12:17:47') datenum('12:17:48') 700 
datenum('11:21:40') datenum('11:21:47') 10 
datenum('11:22:23') datenum('11:22:23') 10 
datenum('11:22:28') datenum('11:22:28') 10 
datenum('11:23:34') datenum('11:23:37') 10 
datenum('11:23:42') datenum('11:23:44') 10 
datenum('11:24:20') datenum('11:24:27') 10 
datenum('12:17:16') datenum('12:18:18') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return