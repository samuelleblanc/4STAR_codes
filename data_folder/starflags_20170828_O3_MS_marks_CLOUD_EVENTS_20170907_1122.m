function marks = starflags_20170828_O3_MS_marks_CLOUD_EVENTS_20170907_1122  
 % starflags file for 20170828 created by MS on 20170907_1122 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1122'); 
 daystr = '20170828';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('10:28:01') datenum('10:35:51') 10 
datenum('10:36:54') datenum('10:46:10') 10 
datenum('10:46:41') datenum('10:47:53') 10 
datenum('11:44:14') datenum('11:45:25') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return