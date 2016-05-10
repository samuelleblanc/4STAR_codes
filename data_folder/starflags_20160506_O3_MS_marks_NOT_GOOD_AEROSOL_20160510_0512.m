function marks = starflags_20160506_O3_MS_marks_NOT_GOOD_AEROSOL_20160510_0512  
 % starflags file for 20160506 created by MS on 20160510_0512 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160510_0512'); 
 daystr = '20160506';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:50:03') datenum('22:53:45') 700 
datenum('26:35:33') datenum('26:35:34') 700 
datenum('26:35:42') datenum('26:35:55') 700 
datenum('26:36:33') datenum('26:36:34') 700 
datenum('26:36:42') datenum('26:36:56') 700 
datenum('27:20:00') datenum('27:20:59') 700 
datenum('27:21:03') datenum('27:21:04') 700 
datenum('27:21:09') datenum('27:21:10') 700 
datenum('31:06:37') datenum('31:09:49') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return