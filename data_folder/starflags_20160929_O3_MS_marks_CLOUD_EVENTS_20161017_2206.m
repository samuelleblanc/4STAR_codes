function marks = starflags_20160929_O3_MS_marks_CLOUD_EVENTS_20161017_2206  
 % starflags file for 20160929 created by MS on 20161017_2206 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2206'); 
 daystr = '20160929';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('14:03:28') datenum('14:04:29') 03 
datenum('18:14:29') datenum('18:23:28') 03 
datenum('14:03:58') datenum('14:04:00') 700 
datenum('18:14:59') datenum('18:15:05') 700 
datenum('18:15:26') datenum('18:15:26') 700 
datenum('18:15:36') datenum('18:15:45') 700 
datenum('18:23:06') datenum('18:23:28') 700 
datenum('14:03:28') datenum('14:04:29') 10 
datenum('18:14:29') datenum('18:23:28') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return