function marks = starflags_20170815_NO2_MS_marks_ALL_20170907_1345  
 % starflags file for 20170815 created by MS on 20170907_1345 to mark ALL conditions 
 version_set('20170907_1345'); 
 daystr = '20170815';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:01:36') datenum('08:03:17') 700 
datenum('10:14:49') datenum('10:14:49') 700 
datenum('10:14:56') datenum('10:17:29') 700 
datenum('11:05:17') datenum('11:10:28') 700 
datenum('11:10:32') datenum('11:58:28') 700 
datenum('12:50:15') datenum('13:28:01') 700 
datenum('13:57:56') datenum('14:01:51') 700 
datenum('14:03:15') datenum('14:15:21') 700 
datenum('14:15:26') datenum('14:18:16') 700 
datenum('14:30:40') datenum('14:32:51') 700 
datenum('15:12:15') datenum('15:13:42') 700 
datenum('15:13:49') datenum('15:13:52') 700 
datenum('15:15:34') datenum('15:18:17') 700 
datenum('15:18:28') datenum('15:26:17') 700 
datenum('15:46:41') datenum('15:49:32') 700 
datenum('16:17:28') datenum('16:25:09') 700 
datenum('16:49:39') datenum('16:56:15') 700 
datenum('14:18:20') datenum('14:20:30') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return