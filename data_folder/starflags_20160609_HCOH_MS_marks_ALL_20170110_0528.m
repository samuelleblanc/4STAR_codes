function marks = starflags_20160609_HCOH_MS_marks_ALL_20170110_0528  
 % starflags file for 20160609 created by MS on 20170110_0528 to mark ALL conditions 
 version_set('20170110_0528'); 
 daystr = '20160609';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('21:59:11') datenum('07:30:07') 03 
datenum('21:59:11') datenum('-2:34:47') 700 
datenum('22:34:51') datenum('-2:34:51') 700 
datenum('22:34:55') datenum('-2:34:55') 700 
datenum('22:34:59') datenum('-2:34:59') 700 
datenum('22:35:04') datenum('-2:35:10') 700 
datenum('22:35:12') datenum('-2:57:25') 700 
datenum('22:57:27') datenum('-2:57:27') 700 
datenum('22:57:30') datenum('00:57:34') 700 
datenum('24:57:37') datenum('05:08:52') 700 
datenum('29:09:01') datenum('05:57:24') 700 
datenum('29:57:27') datenum('06:01:21') 700 
datenum('30:01:23') datenum('06:05:35') 700 
datenum('30:05:38') datenum('07:30:07') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return