function marks = starflags_20160517_O3_MS_marks_NOT_GOOD_AEROSOL_20160520_2342  
 % starflags file for 20160517 created by MS on 20160520_2342 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160520_2342'); 
 daystr = '20160517';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:21:59') datenum('07:54:41') 700 
datenum('26:53:51') datenum('26:54:23') 700 
datenum('26:54:30') datenum('26:54:32') 700 
datenum('27:13:28') datenum('27:16:46') 700 
datenum('27:16:48') datenum('27:17:17') 700 
datenum('28:02:47') datenum('28:03:16') 700 
datenum('28:10:52') datenum('28:12:49') 700 
datenum('30:53:57') datenum('31:30:52') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return