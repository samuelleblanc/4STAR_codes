function marks = starflags_20160617_O3_MS_marks_ALL_20160701_1258  
 % starflags file for 20160617 created by MS on 20160701_1258 to mark ALL conditions 
 version_set('20160701_1258'); 
 daystr = '20160617';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('16:08:15') datenum('16:09:13') 700 
datenum('17:48:51') datenum('17:49:53') 700 
datenum('18:20:41') datenum('18:21:33') 700 
datenum('18:38:02') datenum('18:39:19') 700 
datenum('18:54:19') datenum('18:55:22') 700 
datenum('19:01:05') datenum('19:02:59') 700 
datenum('19:12:49') datenum('19:14:12') 700 
datenum('19:52:56') datenum('19:54:02') 700 
datenum('20:01:29') datenum('20:01:32') 700 
datenum('20:02:29') datenum('20:02:33') 700 
datenum('20:05:13') datenum('20:06:27') 700 
datenum('20:15:03') datenum('20:17:02') 700 
datenum('20:29:48') datenum('20:31:26') 700 
datenum('21:23:53') datenum('21:24:52') 700 
datenum('21:31:24') datenum('21:32:33') 700 
datenum('22:28:44') datenum('22:29:20') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return