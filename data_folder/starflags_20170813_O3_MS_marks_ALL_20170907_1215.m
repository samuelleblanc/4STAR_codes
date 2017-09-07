function marks = starflags_20170813_O3_MS_marks_ALL_20170907_1215  
 % starflags file for 20170813 created by MS on 20170907_1215 to mark ALL conditions 
 version_set('20170907_1215'); 
 daystr = '20170813';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:45:33') datenum('07:46:58') 700 
datenum('07:57:07') datenum('07:59:51') 700 
datenum('10:15:47') datenum('10:31:56') 700 
datenum('11:02:30') datenum('11:03:57') 700 
datenum('11:24:05') datenum('11:26:04') 700 
datenum('11:54:41') datenum('12:03:48') 700 
datenum('12:24:36') datenum('12:24:37') 700 
datenum('12:52:30') datenum('12:52:47') 700 
datenum('13:00:40') datenum('13:00:58') 700 
datenum('13:22:57') datenum('13:24:08') 700 
datenum('14:27:52') datenum('14:29:05') 700 
datenum('16:39:47') datenum('16:56:53') 700 
datenum('14:43:10') datenum('14:47:07') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return