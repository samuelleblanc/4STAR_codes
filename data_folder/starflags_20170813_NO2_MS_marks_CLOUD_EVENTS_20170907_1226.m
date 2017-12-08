function marks = starflags_20170813_NO2_MS_marks_CLOUD_EVENTS_20170907_1226  
 % starflags file for 20170813 created by MS on 20170907_1226 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1226'); 
 daystr = '20170813';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:15:54') datenum('10:15:59') 700 
datenum('10:17:23') datenum('10:17:23') 700 
datenum('10:17:41') datenum('10:17:41') 700 
datenum('10:02:56') datenum('10:10:17') 10 
datenum('10:15:52') datenum('10:31:25') 10 
datenum('12:36:23') datenum('13:26:51') 10 
datenum('14:27:08') datenum('14:29:05') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return