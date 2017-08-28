function marks = starflags_20170826_O3_MS_marks_NOT_GOOD_AEROSOL_20170828_0925  
 % starflags file for 20170826 created by MS on 20170828_0925 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170828_0925'); 
 daystr = '20170826';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:18:18') datenum('08:02:24') 700 
datenum('08:32:52') datenum('08:39:54') 700 
datenum('10:05:56') datenum('10:07:12') 700 
datenum('10:34:39') datenum('10:36:40') 700 
datenum('10:43:51') datenum('11:26:09') 700 
datenum('11:33:23') datenum('11:34:41') 700 
datenum('11:40:16') datenum('11:42:53') 700 
datenum('11:43:38') datenum('11:43:42') 700 
datenum('11:55:11') datenum('11:55:11') 700 
datenum('11:58:01') datenum('12:03:27') 700 
datenum('12:24:28') datenum('12:25:38') 700 
datenum('12:42:55') datenum('12:44:08') 700 
datenum('13:19:39') datenum('13:25:45') 700 
datenum('13:25:49') datenum('13:35:49') 700 
datenum('14:23:33') datenum('14:42:08') 700 
datenum('17:22:00') datenum('17:25:04') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return