function marks = starflags_20160824_CWV_MS_marks_NOT_GOOD_AEROSOL_20161017_2221  
 % starflags file for 20160824 created by MS on 20161017_2221 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_2221'); 
 daystr = '20160824';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:37:51') datenum('17:44:23') 03 
datenum('10:37:51') datenum('11:51:55') 02 
datenum('10:37:51') datenum('10:47:32') 700 
datenum('10:56:17') datenum('10:56:21') 700 
datenum('11:14:37') datenum('11:14:41') 700 
datenum('11:31:47') datenum('11:34:30') 700 
datenum('11:50:56') datenum('11:50:59') 700 
datenum('11:51:57') datenum('11:52:21') 700 
datenum('11:52:59') datenum('11:53:03') 700 
datenum('12:11:19') datenum('12:11:23') 700 
datenum('12:29:39') datenum('12:29:43') 700 
datenum('12:47:59') datenum('12:48:04') 700 
datenum('13:06:19') datenum('13:06:24') 700 
datenum('13:24:40') datenum('13:24:44') 700 
datenum('13:56:08') datenum('13:56:12') 700 
datenum('14:14:28') datenum('14:14:32') 700 
datenum('14:32:48') datenum('14:32:52') 700 
datenum('14:51:08') datenum('14:51:12') 700 
datenum('15:09:28') datenum('15:09:33') 700 
datenum('15:25:28') datenum('15:25:37') 700 
datenum('15:29:32') datenum('15:29:36') 700 
datenum('16:17:20') datenum('16:17:24') 700 
datenum('17:29:27') datenum('17:29:27') 700 
datenum('17:30:10') datenum('17:30:15') 700 
datenum('17:32:50') datenum('17:36:14') 700 
datenum('17:40:53') datenum('17:40:53') 700 
datenum('17:44:23') datenum('17:44:23') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return