function marks = starflags_20161026_HCOH_MS_marks_NOT_GOOD_AEROSOL_20161026_2319  
 % starflags file for 20161026 created by MS on 20161026_2319 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161026_2319'); 
 daystr = '20161026';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('16:12:12') datenum('23:10:21') 03 
datenum('16:12:12') datenum('17:20:57') 700 
datenum('17:31:14') datenum('17:40:11') 700 
datenum('17:41:08') datenum('18:15:14') 700 
datenum('18:15:16') datenum('18:17:53') 700 
datenum('18:17:55') datenum('18:17:56') 700 
datenum('18:17:59') datenum('18:22:52') 700 
datenum('18:22:55') datenum('18:30:33') 700 
datenum('18:30:36') datenum('18:31:23') 700 
datenum('18:31:25') datenum('18:33:25') 700 
datenum('18:33:28') datenum('18:33:29') 700 
datenum('18:33:32') datenum('18:33:51') 700 
datenum('18:33:54') datenum('18:33:54') 700 
datenum('18:33:56') datenum('18:33:57') 700 
datenum('18:33:59') datenum('18:34:09') 700 
datenum('18:34:11') datenum('18:34:16') 700 
datenum('18:34:18') datenum('18:34:30') 700 
datenum('18:34:32') datenum('18:34:45') 700 
datenum('18:34:47') datenum('18:35:53') 700 
datenum('18:35:56') datenum('18:36:00') 700 
datenum('18:36:02') datenum('18:36:35') 700 
datenum('18:36:37') datenum('19:25:09') 700 
datenum('19:25:12') datenum('19:25:15') 700 
datenum('19:25:17') datenum('19:25:27') 700 
datenum('19:25:29') datenum('19:25:33') 700 
datenum('19:25:35') datenum('19:26:33') 700 
datenum('19:26:35') datenum('19:27:30') 700 
datenum('19:27:32') datenum('19:27:45') 700 
datenum('19:27:48') datenum('19:27:52') 700 
datenum('19:27:54') datenum('19:27:58') 700 
datenum('19:28:00') datenum('19:28:04') 700 
datenum('19:28:07') datenum('19:28:09') 700 
datenum('19:28:11') datenum('19:28:15') 700 
datenum('19:28:18') datenum('19:28:21') 700 
datenum('19:28:23') datenum('19:28:33') 700 
datenum('19:28:35') datenum('19:28:36') 700 
datenum('19:28:38') datenum('19:28:57') 700 
datenum('19:28:59') datenum('19:29:06') 700 
datenum('19:29:08') datenum('19:29:09') 700 
datenum('19:29:11') datenum('19:29:17') 700 
datenum('19:29:20') datenum('19:29:22') 700 
datenum('19:29:25') datenum('19:29:38') 700 
datenum('19:29:40') datenum('19:29:53') 700 
datenum('19:29:55') datenum('19:30:00') 700 
datenum('19:30:02') datenum('19:30:02') 700 
datenum('19:30:04') datenum('19:30:08') 700 
datenum('19:30:10') datenum('23:10:21') 700 
datenum('17:24:02') datenum('17:31:14') 10 
datenum('17:40:12') datenum('17:41:08') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return