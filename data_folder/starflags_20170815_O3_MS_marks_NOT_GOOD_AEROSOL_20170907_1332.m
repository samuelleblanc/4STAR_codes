function marks = starflags_20170815_O3_MS_marks_NOT_GOOD_AEROSOL_20170907_1332  
 % starflags file for 20170815 created by MS on 20170907_1332 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1332'); 
 daystr = '20170815';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:01:36') datenum('08:03:23') 700 
datenum('10:10:58') datenum('10:14:49') 700 
datenum('10:14:56') datenum('10:17:52') 700 
datenum('11:09:27') datenum('11:22:39') 700 
datenum('11:26:15') datenum('11:28:42') 700 
datenum('11:28:47') datenum('11:57:50') 700 
datenum('12:50:15') datenum('12:57:36') 700 
datenum('13:24:13') datenum('13:26:22') 700 
datenum('13:57:53') datenum('14:01:50') 700 
datenum('14:15:24') datenum('14:21:20') 700 
datenum('14:30:42') datenum('14:32:51') 700 
datenum('15:12:00') datenum('15:18:14') 700 
datenum('15:20:10') datenum('15:26:17') 700 
datenum('16:17:46') datenum('16:19:42') 700 
datenum('16:23:42') datenum('16:24:41') 700 
datenum('16:45:38') datenum('16:45:38') 700 
datenum('16:51:27') datenum('16:56:15') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return