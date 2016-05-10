function marks = starflags_20160503_MS_marks_ALL_20160509_2356  
 % starflags file for 20160503 created by MS on 20160509_2356 to mark ALL conditions 
 version_set('20160509_2356'); 
 daystr = '20160503';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:51:52') datenum('23:05:33') 700 
datenum('26:56:25') datenum('26:57:58') 700 
datenum('26:59:19') datenum('26:59:22') 700 
datenum('27:17:20') datenum('27:19:14') 700 
datenum('30:26:58') datenum('30:28:08') 700 
datenum('30:28:58') datenum('30:28:58') 700 
datenum('30:29:00') datenum('30:29:08') 700 
datenum('30:29:10') datenum('30:30:04') 700 
datenum('30:30:06') datenum('30:30:10') 700 
datenum('31:47:22') datenum('31:48:40') 700 
datenum('31:48:43') datenum('31:49:43') 700 
datenum('31:49:46') datenum('31:49:51') 700 
datenum('31:49:54') datenum('31:50:52') 700 
datenum('31:50:55') datenum('31:50:59') 700 
datenum('31:51:01') datenum('31:51:42') 700 
datenum('31:51:44') datenum('31:52:10') 700 
datenum('31:52:12') datenum('31:52:13') 700 
datenum('31:52:16') datenum('31:52:23') 700 
datenum('31:52:28') datenum('31:52:32') 700 
datenum('31:52:36') datenum('31:53:08') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return