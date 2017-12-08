function marks = starflags_20170809_CWV_MS_marks_ALL_20170906_1645  
 % starflags file for 20170809 created by MS on 20170906_1645 to mark ALL conditions 
 version_set('20170906_1645'); 
 daystr = '20170809';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:43:52') datenum('09:55:06') 700 
datenum('11:27:36') datenum('11:27:36') 700 
datenum('11:26:37') datenum('11:27:33') 10 
datenum('11:27:38') datenum('12:04:53') 10 
datenum('13:26:28') datenum('13:26:33') 10 
datenum('13:40:29') datenum('14:10:03') 10 
datenum('16:11:10') datenum('16:11:11') 10 
datenum('16:16:48') datenum('16:16:49') 10 
datenum('16:20:01') datenum('16:20:04') 10 
datenum('16:28:43') datenum('16:28:45') 10 
datenum('16:29:36') datenum('16:29:36') 10 
datenum('16:29:38') datenum('16:29:38') 10 
datenum('17:20:13') datenum('17:26:00') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return