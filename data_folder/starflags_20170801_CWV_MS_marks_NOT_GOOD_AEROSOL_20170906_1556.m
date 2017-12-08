function marks = starflags_20170801_CWV_MS_marks_NOT_GOOD_AEROSOL_20170906_1556  
 % starflags file for 20170801 created by MS on 20170906_1556 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170906_1556'); 
 daystr = '20170801';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:26:38') datenum('12:31:10') 700 
datenum('12:31:24') datenum('13:14:53') 700 
datenum('13:14:59') datenum('13:15:06') 700 
datenum('13:15:12') datenum('13:15:12') 700 
datenum('13:15:15') datenum('13:15:15') 700 
datenum('13:15:20') datenum('13:15:30') 700 
datenum('13:15:48') datenum('13:15:48') 700 
datenum('13:18:03') datenum('13:18:03') 700 
datenum('13:18:17') datenum('13:25:21') 700 
datenum('16:48:38') datenum('16:48:38') 700 
datenum('17:38:40') datenum('17:38:41') 700 
datenum('17:38:57') datenum('17:39:01') 700 
datenum('17:39:05') datenum('17:40:29') 700 
datenum('17:41:36') datenum('17:41:38') 700 
datenum('17:41:52') datenum('17:41:53') 700 
datenum('17:44:31') datenum('17:44:31') 700 
datenum('17:45:16') datenum('17:45:21') 700 
datenum('17:45:29') datenum('17:45:32') 700 
datenum('17:45:36') datenum('17:45:40') 700 
datenum('17:45:45') datenum('17:45:45') 700 
datenum('17:46:15') datenum('17:46:22') 700 
datenum('17:46:26') datenum('17:46:31') 700 
datenum('17:47:52') datenum('17:49:53') 700 
datenum('16:48:39') datenum('16:48:43') 10 
datenum('17:23:49') datenum('17:23:51') 10 
datenum('17:25:33') datenum('17:25:35') 10 
datenum('17:38:55') datenum('17:38:55') 10 
datenum('17:39:03') datenum('17:39:03') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return