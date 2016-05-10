function marks = starflags_20160504_SL_marks_OTHER_FLAGGED_EVENTS_20160510_2053  
 % starflags file for 20160504 created by SL on 20160510_2053 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160510_2053'); 
 daystr = '20160504';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('21:53:34') datenum('22:14:34') 02 
datenum('22:14:40') datenum('22:34:39') 02 
datenum('22:34:45') datenum('22:50:49') 02 
datenum('27:58:43') datenum('28:04:32') 02 
datenum('28:04:38') datenum('28:07:51') 02 
datenum('28:23:33') datenum('28:28:10') 02 
datenum('28:41:36') datenum('28:59:57') 02 
datenum('29:00:04') datenum('29:21:07') 02 
datenum('29:21:13') datenum('29:42:17') 02 
datenum('29:42:24') datenum('29:43:49') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return