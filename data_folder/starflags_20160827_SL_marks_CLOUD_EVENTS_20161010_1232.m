function marks = starflags_20160827_SL_marks_CLOUD_EVENTS_20161010_1232  
 % starflags file for 20160827 created by SL on 20161010_1232 to mark CLOUD_EVENTS conditions 
 version_set('20161010_1232'); 
 daystr = '20160827';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:59:31') datenum('09:59:33') 700 
datenum('09:59:30') datenum('09:59:33') 10 
datenum('14:27:56') datenum('14:28:27') 10 
datenum('14:28:33') datenum('14:28:43') 10 
datenum('14:29:24') datenum('14:29:24') 10 
datenum('14:29:27') datenum('14:29:31') 10 
datenum('14:29:38') datenum('14:30:21') 10 
datenum('14:30:23') datenum('14:30:31') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return