function marks = starflags_20170817_NO2_MS_marks_CLOUD_EVENTS_20170907_1428  
 % starflags file for 20170817 created by MS on 20170907_1428 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1428'); 
 daystr = '20170817';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:37:16') datenum('12:37:21') 700 
datenum('16:10:11') datenum('16:12:32') 700 
datenum('16:15:40') datenum('16:16:57') 700 
datenum('16:18:18') datenum('16:20:25') 700 
datenum('08:38:28') datenum('08:41:52') 10 
datenum('12:37:16') datenum('12:37:21') 10 
datenum('12:42:25') datenum('12:43:12') 10 
datenum('13:11:40') datenum('13:11:42') 10 
datenum('15:55:55') datenum('16:12:32') 10 
datenum('16:12:39') datenum('16:15:35') 10 
datenum('16:15:40') datenum('16:16:57') 10 
datenum('16:16:59') datenum('16:18:13') 10 
datenum('16:18:18') datenum('16:24:38') 10 
datenum('16:47:24') datenum('16:54:44') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return