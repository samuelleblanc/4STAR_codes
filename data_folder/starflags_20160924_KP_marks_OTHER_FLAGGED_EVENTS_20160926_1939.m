function marks = starflags_20160924_KP_marks_OTHER_FLAGGED_EVENTS_20160926_1939  
 % starflags file for 20160924 created by KP on 20160926_1939 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160926_1939'); 
 daystr = '20160924';  
 % tag = 2: before_or_after_flight 
 % tag = 500: hor_legs 
 % tag = 600: vert_legs 
 marks=[ 
 datenum('06:38:01') datenum('06:43:08') 02 
datenum('06:45:11') datenum('06:58:41') 500 
datenum('06:58:48') datenum('08:10:52') 500 
datenum('08:13:46') datenum('08:50:30') 500 
datenum('09:15:29') datenum('09:18:10') 500 
datenum('09:56:01') datenum('10:00:15') 500 
datenum('13:51:50') datenum('15:12:18') 500 
datenum('06:43:03') datenum('07:17:01') 600 
datenum('07:17:08') datenum('07:35:21') 600 
datenum('07:35:28') datenum('07:53:41') 600 
datenum('07:53:48') datenum('07:59:59') 600 
datenum('08:50:46') datenum('09:14:12') 600 
datenum('10:00:49') datenum('10:13:42') 600 
datenum('12:43:20') datenum('13:03:44') 600 
datenum('13:39:41') datenum('13:51:46') 600 
datenum('15:12:44') datenum('15:44:34') 600 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return