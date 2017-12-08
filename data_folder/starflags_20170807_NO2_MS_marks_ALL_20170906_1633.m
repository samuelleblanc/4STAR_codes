function marks = starflags_20170807_NO2_MS_marks_ALL_20170906_1633  
 % starflags file for 20170807 created by MS on 20170906_1633 to mark ALL conditions 
 version_set('20170906_1633'); 
 daystr = '20170807';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:30:15') datenum('10:15:48') 700 
datenum('19:33:34') datenum('19:33:54') 700 
datenum('12:51:21') datenum('12:53:35') 10 
datenum('12:56:31') datenum('12:58:07') 10 
datenum('13:27:42') datenum('13:34:51') 10 
datenum('13:38:19') datenum('13:41:52') 10 
datenum('19:07:51') datenum('19:17:51') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return