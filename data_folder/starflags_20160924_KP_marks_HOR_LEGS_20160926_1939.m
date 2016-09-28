function marks = starflags_20160924_KP_marks_HOR_LEGS_20160926_1939  
 % starflags file for 20160924 created by KP on 20160926_1939 to mark HOR_LEGS conditions 
 version_set('20160926_1939'); 
 daystr = '20160924';  
 % tag = 3: t 
 % tag = 500: hor_legs 
 % tag = 600: vert_legs 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:17:02') datenum('07:17:06') 03 
datenum('07:35:22') datenum('07:35:26') 03 
datenum('07:53:42') datenum('07:53:47') 03 
datenum('08:30:23') datenum('08:30:27') 03 
datenum('08:48:43') datenum('08:48:47') 03 
datenum('14:05:18') datenum('14:05:23') 03 
datenum('14:23:38') datenum('14:23:43') 03 
datenum('14:41:59') datenum('14:42:03') 03 
datenum('15:00:19') datenum('15:00:23') 03 
datenum('06:45:11') datenum('06:45:11') 700 
datenum('07:17:02') datenum('07:17:06') 700 
datenum('07:35:22') datenum('07:35:26') 700 
datenum('07:53:42') datenum('07:53:47') 700 
datenum('08:30:23') datenum('08:30:27') 700 
datenum('08:43:59') datenum('08:44:12') 700 
datenum('08:48:43') datenum('08:48:47') 700 
datenum('09:15:29') datenum('09:16:29') 700 
datenum('09:59:06') datenum('09:59:16') 700 
datenum('09:59:58') datenum('10:00:11') 700 
datenum('10:00:15') datenum('10:00:15') 700 
datenum('14:05:18') datenum('14:05:23') 700 
datenum('14:23:38') datenum('14:23:43') 700 
datenum('14:41:59') datenum('14:42:03') 700 
datenum('15:00:19') datenum('15:00:23') 700 
datenum('06:45:11') datenum('06:58:41') 500 
datenum('06:58:48') datenum('08:10:52') 500 
datenum('08:13:46') datenum('08:50:30') 500 
datenum('09:15:29') datenum('09:18:10') 500 
datenum('09:56:01') datenum('10:00:15') 500 
datenum('13:51:50') datenum('15:12:18') 500 
datenum('06:45:11') datenum('06:58:41') 600 
datenum('06:58:48') datenum('07:17:01') 600 
datenum('07:17:08') datenum('07:35:21') 600 
datenum('07:35:28') datenum('07:53:41') 600 
datenum('07:53:48') datenum('07:59:59') 600 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return