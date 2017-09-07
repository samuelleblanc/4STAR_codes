function marks = starflags_20170828_NO2_MS_marks_CLOUD_EVENTS_20170907_1134  
 % starflags file for 20170828 created by MS on 20170907_1134 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1134'); 
 daystr = '20170828';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('10:35:43') datenum('10:38:43') 10 
datenum('16:34:11') datenum('16:34:19') 10 
datenum('16:34:29') datenum('16:34:29') 10 
datenum('16:34:31') datenum('16:35:50') 10 
datenum('16:36:40') datenum('16:36:42') 10 
datenum('16:39:13') datenum('16:40:01') 10 
datenum('16:40:15') datenum('16:41:16') 10 
datenum('16:41:23') datenum('16:41:23') 10 
datenum('16:44:32') datenum('16:45:34') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return