function marks = starflags_20160925_SL_marks_OTHER_FLAGGED_EVENTS_20161024_1938  
 % starflags file for 20160925 created by SL on 20161024_1938 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20161024_1938'); 
 daystr = '20160925';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:59:27') datenum('07:59:37') 02 
datenum('08:19:27') datenum('08:19:31') 02 
datenum('08:37:58') datenum('08:38:02') 02 
datenum('08:56:33') datenum('08:56:37') 02 
datenum('09:18:54') datenum('09:18:58') 02 
datenum('09:37:27') datenum('09:37:31') 02 
datenum('09:58:11') datenum('09:58:15') 02 
datenum('10:16:49') datenum('10:16:53') 02 
datenum('10:38:31') datenum('10:38:43') 02 
datenum('10:57:23') datenum('10:57:27') 02 
datenum('11:29:34') datenum('11:29:47') 02 
datenum('11:37:09') datenum('11:41:38') 02 
datenum('12:03:52') datenum('12:03:57') 02 
datenum('12:26:59') datenum('12:27:12') 02 
datenum('12:51:12') datenum('12:51:21') 02 
datenum('13:16:40') datenum('13:16:53') 02 
datenum('13:52:38') datenum('13:52:51') 02 
datenum('14:14:34') datenum('14:14:46') 02 
datenum('14:33:12') datenum('14:33:17') 02 
datenum('14:41:35') datenum('14:41:48') 02 
datenum('15:01:39') datenum('15:01:44') 02 
datenum('15:23:30') datenum('15:23:35') 02 
datenum('15:33:41') datenum('15:33:56') 02 
datenum('15:57:31') datenum('15:57:35') 02 
datenum('16:15:58') datenum('16:16:02') 02 
datenum('16:25:06') datenum('16:25:16') 02 
datenum('16:26:11') datenum('16:26:15') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return