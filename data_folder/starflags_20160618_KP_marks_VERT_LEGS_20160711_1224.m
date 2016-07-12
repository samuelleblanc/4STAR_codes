function marks = starflags_20160618_KP_marks_VERT_LEGS_20160711_1224  
 % starflags file for 20160618 created by KP on 20160711_1224 to mark VERT_LEGS conditions 
 version_set('20160711_1224'); 
 daystr = '20160618';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 300: frost 
 % tag = 600: vert_legs 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('21:56:42') datenum('21:56:46') 03 
datenum('22:09:42') datenum('22:09:52') 03 
datenum('22:15:04') datenum('22:15:09') 03 
datenum('21:55:19') datenum('21:55:19') 700 
datenum('21:55:45') datenum('21:55:46') 700 
datenum('21:55:55') datenum('21:55:57') 700 
datenum('21:56:07') datenum('21:56:08') 700 
datenum('21:56:11') datenum('21:56:14') 700 
datenum('21:56:42') datenum('21:56:46') 700 
datenum('21:56:51') datenum('21:56:51') 700 
datenum('21:56:53') datenum('21:57:03') 700 
datenum('21:57:25') datenum('21:57:28') 700 
datenum('21:58:06') datenum('21:58:06') 700 
datenum('21:58:26') datenum('21:58:29') 700 
datenum('21:58:31') datenum('21:58:31') 700 
datenum('21:58:48') datenum('21:58:53') 700 
datenum('22:02:07') datenum('22:02:07') 700 
datenum('22:02:12') datenum('22:02:17') 700 
datenum('22:02:43') datenum('22:02:44') 700 
datenum('22:03:00') datenum('22:03:12') 700 
datenum('22:03:22') datenum('22:03:27') 700 
datenum('22:04:01') datenum('22:04:07') 700 
datenum('22:09:17') datenum('22:09:26') 700 
datenum('22:09:30') datenum('22:09:30') 700 
datenum('22:09:55') datenum('22:09:55') 700 
datenum('22:10:06') datenum('22:10:06') 700 
datenum('22:10:10') datenum('22:10:18') 700 
datenum('22:11:49') datenum('22:11:54') 700 
datenum('22:15:04') datenum('22:15:09') 700 
datenum('22:15:12') datenum('22:15:12') 700 
datenum('22:15:38') datenum('22:15:38') 700 
datenum('22:16:05') datenum('22:16:06') 700 
datenum('22:16:08') datenum('22:16:08') 700 
datenum('22:16:11') datenum('22:16:11') 700 
datenum('22:17:24') datenum('22:17:24') 700 
datenum('22:17:42') datenum('22:17:43') 700 
datenum('22:17:45') datenum('22:17:45') 700 
datenum('22:17:48') datenum('22:17:48') 700 
datenum('22:18:20') datenum('22:18:23') 700 
datenum('22:18:26') datenum('22:18:26') 700 
datenum('22:09:42') datenum('22:09:52') 10 
datenum('21:53:32') datenum('22:18:55') 600 
datenum('21:53:58') datenum('21:56:41') 300 
datenum('21:56:47') datenum('21:57:07') 300 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return