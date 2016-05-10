function marks = starflags_20160501_O3_MS_marks_NOT_GOOD_AEROSOL_20160510_0438  
 % starflags file for 20160501 created by MS on 20160510_0438 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160510_0438'); 
 daystr = '20160501';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:49:44') datenum('22:49:44') 700 
datenum('23:41:52') datenum('23:41:52') 700 
datenum('23:42:02') datenum('23:42:02') 700 
datenum('23:45:33') datenum('23:45:36') 700 
datenum('24:24:03') datenum('24:24:09') 700 
datenum('24:24:12') datenum('24:24:22') 700 
datenum('24:24:34') datenum('24:24:37') 700 
datenum('24:28:57') datenum('24:28:57') 700 
datenum('24:36:42') datenum('24:36:45') 700 
datenum('24:36:49') datenum('24:36:51') 700 
datenum('24:36:54') datenum('24:37:00') 700 
datenum('24:44:26') datenum('24:45:08') 700 
datenum('26:30:17') datenum('26:30:17') 700 
datenum('28:11:22') datenum('28:11:22') 700 
datenum('28:21:52') datenum('28:21:52') 700 
datenum('28:44:33') datenum('28:45:16') 700 
datenum('28:45:28') datenum('28:46:26') 700 
datenum('28:47:09') datenum('28:47:12') 700 
datenum('28:48:28') datenum('28:48:30') 700 
datenum('28:51:33') datenum('28:51:33') 700 
datenum('29:07:36') datenum('29:07:36') 700 
datenum('29:09:00') datenum('29:09:13') 700 
datenum('29:13:01') datenum('29:13:01') 700 
datenum('29:17:14') datenum('29:17:14') 700 
datenum('29:20:27') datenum('29:20:42') 700 
datenum('30:15:28') datenum('30:15:28') 700 
datenum('30:17:05') datenum('30:17:05') 700 
datenum('30:17:18') datenum('30:17:18') 700 
datenum('30:20:04') datenum('30:20:04') 700 
datenum('30:34:31') datenum('30:34:31') 700 
datenum('30:44:23') datenum('30:44:26') 700 
datenum('30:46:23') datenum('30:46:35') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return