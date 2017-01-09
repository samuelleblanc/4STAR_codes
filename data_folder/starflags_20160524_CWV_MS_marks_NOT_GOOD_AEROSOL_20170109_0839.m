function marks = starflags_20160524_CWV_MS_marks_NOT_GOOD_AEROSOL_20170109_0839  
 % starflags file for 20160524 created by MS on 20170109_0839 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0839'); 
 daystr = '20160524';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:56:48') datenum('22:56:59') 700 
datenum('23:08:40') datenum('23:08:40') 700 
datenum('23:08:47') datenum('23:09:01') 700 
datenum('23:09:05') datenum('23:09:11') 700 
datenum('23:09:16') datenum('23:09:16') 700 
datenum('23:09:19') datenum('23:09:45') 700 
datenum('23:09:50') datenum('23:09:50') 700 
datenum('23:09:52') datenum('23:09:58') 700 
datenum('23:15:59') datenum('23:16:12') 700 
datenum('25:13:21') datenum('25:13:45') 700 
datenum('25:16:04') datenum('25:19:54') 700 
datenum('25:34:04') datenum('25:34:04') 700 
datenum('25:34:19') datenum('25:34:20') 700 
datenum('27:56:57') datenum('27:58:17') 700 
datenum('28:27:39') datenum('28:27:43') 700 
datenum('28:27:48') datenum('28:27:55') 700 
datenum('29:34:25') datenum('29:34:28') 700 
datenum('31:01:31') datenum('31:01:39') 700 
datenum('31:01:45') datenum('31:01:49') 700 
datenum('31:01:52') datenum('31:01:52') 700 
datenum('31:01:54') datenum('31:02:34') 700 
datenum('31:03:45') datenum('31:03:55') 700 
datenum('31:04:57') datenum('31:04:57') 700 
datenum('31:05:27') datenum('31:05:36') 700 
datenum('31:06:21') datenum('31:06:33') 700 
datenum('31:06:51') datenum('31:08:05') 700 
datenum('31:08:23') datenum('31:08:26') 700 
datenum('31:09:17') datenum('31:09:19') 700 
datenum('31:09:34') datenum('31:16:33') 700 
datenum('31:16:40') datenum('31:21:03') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return