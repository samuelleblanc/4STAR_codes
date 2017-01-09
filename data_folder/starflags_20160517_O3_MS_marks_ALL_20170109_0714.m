function marks = starflags_20160517_O3_MS_marks_ALL_20170109_0714  
 % starflags file for 20160517 created by MS on 20170109_0714 to mark ALL conditions 
 version_set('20170109_0714'); 
 daystr = '20160517';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:21:59') datenum('07:54:41') 700 
datenum('26:53:50') datenum('26:54:34') 700 
datenum('27:13:31') datenum('27:16:38') 700 
datenum('28:02:47') datenum('28:03:16') 700 
datenum('28:10:51') datenum('28:12:52') 700 
datenum('30:47:43') datenum('31:30:52') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return