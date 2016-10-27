function marks = starflags_20161026_CWV_MS_marks_NOT_GOOD_AEROSOL_20161026_2314  
 % starflags file for 20161026 created by MS on 20161026_2314 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161026_2314'); 
 daystr = '20161026';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('16:12:12') datenum('23:10:21') 03 
datenum('16:12:12') datenum('16:12:24') 700 
datenum('16:30:39') datenum('16:30:44') 700 
datenum('16:49:00') datenum('16:49:04') 700 
datenum('16:52:27') datenum('16:52:27') 700 
datenum('17:07:20') datenum('17:07:24') 700 
datenum('17:24:02') datenum('17:33:17') 700 
datenum('17:40:12') datenum('17:49:24') 700 
datenum('18:07:40') datenum('18:07:45') 700 
datenum('18:26:00') datenum('18:26:05') 700 
datenum('18:44:21') datenum('18:44:25') 700 
datenum('19:02:41') datenum('19:02:45') 700 
datenum('19:21:01') datenum('19:21:05') 700 
datenum('19:39:21') datenum('19:39:25') 700 
datenum('19:57:41') datenum('19:57:45') 700 
datenum('20:16:01') datenum('20:16:06') 700 
datenum('20:34:21') datenum('20:34:26') 700 
datenum('20:52:42') datenum('20:52:46') 700 
datenum('21:02:48') datenum('21:12:03') 700 
datenum('21:30:06') datenum('21:33:20') 700 
datenum('21:51:35') datenum('21:51:40') 700 
datenum('22:09:56') datenum('22:10:00') 700 
datenum('22:28:16') datenum('22:28:20') 700 
datenum('22:46:36') datenum('22:46:40') 700 
datenum('22:58:33') datenum('23:07:04') 700 
datenum('23:10:21') datenum('23:10:21') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return