function marks = starflags_20160602_O3_MS_marks_CLOUD_EVENTS_20170109_1234  
 % starflags file for 20160602 created by MS on 20170109_1234 to mark CLOUD_EVENTS conditions 
 version_set('20170109_1234'); 
 daystr = '20160602';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:00:17') datenum('23:56:48') 700 
datenum('23:58:06') datenum('31:12:03') 700 
datenum('31:12:07') datenum('31:23:19') 700 
datenum('23:00:17') datenum('31:12:03') 10 
datenum('31:12:07') datenum('31:23:19') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return