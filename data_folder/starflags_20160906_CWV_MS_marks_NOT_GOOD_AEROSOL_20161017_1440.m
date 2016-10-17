function marks = starflags_20160906_CWV_MS_marks_NOT_GOOD_AEROSOL_20161017_1440  
 % starflags file for 20160906 created by MS on 20161017_1440 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1440'); 
 daystr = '20160906';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('05:59:22') datenum('14:47:53') 03 
datenum('14:47:36') datenum('14:47:53') 02 
datenum('05:59:22') datenum('06:59:12') 700 
datenum('07:04:21') datenum('07:04:26') 700 
datenum('07:22:42') datenum('07:22:46') 700 
datenum('07:49:49') datenum('07:49:53') 700 
datenum('08:22:55') datenum('08:22:59') 700 
datenum('08:23:51') datenum('08:24:41') 700 
datenum('08:46:52') datenum('08:48:20') 700 
datenum('08:56:27') datenum('08:56:41') 700 
datenum('09:13:23') datenum('09:13:28') 700 
datenum('09:36:42') datenum('09:36:47') 700 
datenum('09:37:06') datenum('09:37:06') 700 
datenum('10:11:40') datenum('10:11:46') 700 
datenum('10:16:17') datenum('10:19:38') 700 
datenum('11:00:43') datenum('11:02:53') 700 
datenum('11:42:24') datenum('11:42:29') 700 
datenum('12:03:06') datenum('12:03:11') 700 
datenum('12:21:26') datenum('12:21:31') 700 
datenum('13:07:22') datenum('13:07:26') 700 
datenum('13:15:42') datenum('13:15:42') 700 
datenum('13:15:46') datenum('13:15:46') 700 
datenum('13:52:00') datenum('13:52:04') 700 
datenum('14:10:20') datenum('14:10:24') 700 
datenum('14:33:26') datenum('14:33:30') 700 
datenum('14:47:36') datenum('14:47:53') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return