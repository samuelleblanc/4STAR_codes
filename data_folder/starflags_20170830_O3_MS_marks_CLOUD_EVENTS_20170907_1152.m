function marks = starflags_20170830_O3_MS_marks_CLOUD_EVENTS_20170907_1152  
 % starflags file for 20170830 created by MS on 20170907_1152 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1152'); 
 daystr = '20170830';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:51:57') datenum('12:52:16') 700 
datenum('10:39:17') datenum('11:04:41') 10 
datenum('11:31:54') datenum('11:41:44') 10 
datenum('12:36:42') datenum('12:52:16') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return