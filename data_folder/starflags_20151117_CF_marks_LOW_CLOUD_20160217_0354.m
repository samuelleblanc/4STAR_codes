function marks = starflags_20151117_CF_marks_LOW_CLOUD_20160217_0354  
 % starflags file for 20151117 created by CF on 20160217_0354 to mark LOW_CLOUD conditions 
 daystr = '20151117';  
 % tag = 10: unspecified_clouds 
 % tag = 400: low_cloud 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('14:53:09') datenum('15:12:54') 10 
datenum('15:43:54') datenum('15:44:18') 10 
datenum('16:10:37') datenum('16:10:43') 10 
datenum('16:13:13') datenum('16:13:21') 10 
datenum('16:19:51') datenum('16:20:06') 10 
datenum('14:53:21') datenum('15:12:54') 700 
datenum('15:43:54') datenum('15:44:18') 700 
datenum('16:10:41') datenum('16:10:43') 700 
datenum('16:13:21') datenum('16:13:21') 700 
datenum('16:20:01') datenum('16:20:06') 700 
datenum('14:53:09') datenum('15:12:54') 400 
datenum('15:43:54') datenum('15:44:18') 400 
datenum('16:10:37') datenum('16:10:43') 400 
datenum('16:13:13') datenum('16:13:21') 400 
datenum('16:19:51') datenum('16:20:06') 400 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return