function marks = starflags_20151117_CF_marks_HOR_LEGS_20160217_0406  
 % starflags file for 20151117 created by CF on 20160217_0406 to mark HOR_LEGS conditions 
 daystr = '20151117';  
 % tag = 10: unspecified_clouds 
 % tag = 90: cirrus 
 % tag = 500: hor_legs 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:35:15') datenum('10:36:21') 10 
datenum('10:36:24') datenum('10:37:44') 10 
datenum('10:37:46') datenum('10:40:20') 10 
datenum('10:40:22') datenum('10:42:57') 10 
datenum('10:43:00') datenum('10:46:47') 10 
datenum('10:46:50') datenum('10:49:52') 10 
datenum('10:49:54') datenum('10:51:54') 10 
datenum('10:51:56') datenum('11:00:38') 10 
datenum('11:00:45') datenum('11:00:51') 10 
datenum('11:07:04') datenum('11:07:12') 10 
datenum('12:18:31') datenum('12:19:40') 10 
datenum('12:31:28') datenum('12:31:38') 10 
datenum('13:39:02') datenum('13:39:13') 10 
datenum('13:44:34') datenum('13:44:42') 10 
datenum('14:19:38') datenum('14:20:59') 10 
datenum('14:21:43') datenum('14:21:45') 10 
datenum('12:17:49') datenum('12:17:50') 90 
datenum('12:21:01') datenum('12:21:01') 90 
datenum('12:31:32') datenum('12:31:32') 90 
datenum('12:31:34') datenum('12:31:34') 90 
datenum('10:35:15') datenum('11:00:45') 700 
datenum('11:07:09') datenum('11:11:16') 700 
datenum('11:29:32') datenum('11:29:36') 700 
datenum('11:47:52') datenum('11:47:57') 700 
datenum('12:06:13') datenum('12:06:17') 700 
datenum('12:18:37') datenum('12:19:34') 700 
datenum('12:24:59') datenum('12:25:04') 700 
datenum('12:43:20') datenum('12:43:24') 700 
datenum('13:01:40') datenum('13:01:44') 700 
datenum('13:20:00') datenum('13:20:04') 700 
datenum('13:30:51') datenum('13:34:00') 700 
datenum('13:52:16') datenum('13:52:20') 700 
datenum('14:00:07') datenum('14:03:09') 700 
datenum('14:21:25') datenum('14:21:30') 700 
datenum('10:35:15') datenum('14:26:07') 500 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return