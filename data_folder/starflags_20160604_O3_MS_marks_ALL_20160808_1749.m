function marks = starflags_20160604_O3_MS_marks_ALL_20160808_1749  
 % starflags file for 20160604 created by MS on 20160808_1749 to mark ALL conditions 
 version_set('20160808_1749'); 
 daystr = '20160604';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:03:40') datenum('00:04:26') 700 
datenum('03:11:15') datenum('03:13:00') 700 
datenum('04:06:49') datenum('04:14:38') 700 
datenum('04:18:02') datenum('04:19:02') 700 
datenum('04:19:52') datenum('04:20:56') 700 
datenum('04:26:17') datenum('04:28:42') 700 
datenum('04:31:52') datenum('04:31:55') 700 
datenum('04:34:45') datenum('04:36:53') 700 
datenum('04:57:04') datenum('05:00:37') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return