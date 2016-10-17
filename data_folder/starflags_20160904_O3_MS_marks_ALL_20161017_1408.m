function marks = starflags_20160904_O3_MS_marks_ALL_20161017_1408  
 % starflags file for 20160904 created by MS on 20161017_1408 to mark ALL conditions 
 version_set('20161017_1408'); 
 daystr = '20160904';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:37:29') datenum('15:25:17') 03 
datenum('07:37:29') datenum('07:37:59') 700 
datenum('07:56:05') datenum('07:56:09') 700 
datenum('08:14:25') datenum('08:14:29') 700 
datenum('08:32:45') datenum('08:32:49') 700 
datenum('08:51:05') datenum('08:51:09') 700 
datenum('09:36:59') datenum('09:37:01') 700 
datenum('09:44:13') datenum('09:44:17') 700 
datenum('10:02:36') datenum('10:02:41') 700 
datenum('10:22:31') datenum('10:22:36') 700 
datenum('10:43:23') datenum('10:43:27') 700 
datenum('10:44:52') datenum('10:45:25') 700 
datenum('10:45:43') datenum('10:58:21') 700 
datenum('13:53:01') datenum('13:53:05') 700 
datenum('14:11:21') datenum('14:11:26') 700 
datenum('14:31:51') datenum('14:31:55') 700 
datenum('14:50:12') datenum('14:50:17') 700 
datenum('15:08:32') datenum('15:08:37') 700 
datenum('15:20:04') datenum('15:25:17') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return