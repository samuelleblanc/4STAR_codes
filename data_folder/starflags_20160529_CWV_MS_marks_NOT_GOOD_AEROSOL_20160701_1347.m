function marks = starflags_20160529_CWV_MS_marks_NOT_GOOD_AEROSOL_20160701_1347  
 % starflags file for 20160529 created by MS on 20160701_1347 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160701_1347'); 
 daystr = '20160529';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:51:44') datenum('23:00:05') 700 
datenum('23:09:33') datenum('23:09:36') 700 
datenum('26:40:20') datenum('26:41:34') 700 
datenum('26:41:41') datenum('26:43:06') 700 
datenum('26:52:27') datenum('26:52:32') 700 
datenum('26:52:41') datenum('26:52:45') 700 
datenum('26:53:54') datenum('26:54:03') 700 
datenum('26:54:06') datenum('26:54:17') 700 
datenum('26:54:38') datenum('26:54:43') 700 
datenum('27:01:46') datenum('27:01:48') 700 
datenum('27:01:58') datenum('27:01:59') 700 
datenum('27:09:24') datenum('27:09:31') 700 
datenum('27:10:50') datenum('27:10:57') 700 
datenum('27:16:21') datenum('27:16:31') 700 
datenum('27:17:54') datenum('27:18:00') 700 
datenum('27:22:39') datenum('27:22:47') 700 
datenum('27:23:24') datenum('27:23:28') 700 
datenum('27:23:34') datenum('27:23:36') 700 
datenum('27:26:02') datenum('27:26:06') 700 
datenum('27:31:24') datenum('27:31:30') 700 
datenum('27:38:56') datenum('27:38:58') 700 
datenum('27:53:20') datenum('27:53:21') 700 
datenum('28:01:46') datenum('28:01:48') 700 
datenum('28:03:59') datenum('28:04:08') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return