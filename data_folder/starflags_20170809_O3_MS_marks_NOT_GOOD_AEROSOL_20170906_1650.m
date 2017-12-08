function marks = starflags_20170809_O3_MS_marks_NOT_GOOD_AEROSOL_20170906_1650  
 % starflags file for 20170809 created by MS on 20170906_1650 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170906_1650'); 
 daystr = '20170809';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:43:38') datenum('09:53:35') 700 
datenum('11:26:40') datenum('12:04:53') 700 
datenum('12:37:26') datenum('12:37:26') 700 
datenum('13:25:58') datenum('13:27:02') 700 
datenum('13:40:00') datenum('13:41:22') 700 
datenum('13:59:25') datenum('14:02:31') 700 
datenum('14:07:35') datenum('14:10:18') 700 
datenum('17:19:39') datenum('17:26:02') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return