function marks = starflags_20160827_O3_MS_marks_CLOUD_EVENTS_20161017_2229  
 % starflags file for 20160827 created by MS on 20161017_2229 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2229'); 
 daystr = '20160827';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:59:48') datenum('08:10:26') 03 
datenum('09:51:06') datenum('09:59:33') 03 
datenum('07:59:48') datenum('08:02:16') 700 
datenum('07:59:48') datenum('08:10:26') 10 
datenum('09:51:06') datenum('09:59:33') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return