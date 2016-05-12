function marks = starflags_20160426_O3_MS_marks_NOT_GOOD_AEROSOL_20160512_0442  
 % starflags file for 20160426 created by MS on 20160512_0442 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160512_0442'); 
 daystr = '20160426';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:51:04') datenum('10:51:17') 700 
datenum('12:38:32') datenum('13:08:07') 700 
datenum('13:12:23') datenum('13:16:03') 700 
datenum('13:29:43') datenum('13:30:55') 700 
datenum('13:59:09') datenum('14:04:26') 700 
datenum('17:02:23') datenum('17:28:28') 700 
datenum('26:01:12') datenum('26:02:46') 700 
datenum('26:03:00') datenum('26:22:40') 700 
datenum('28:26:54') datenum('28:30:36') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return