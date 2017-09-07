function marks = starflags_20170904_CWV_MS_marks_CLOUD_EVENTS_20170907_1101  
 % starflags file for 20170904 created by MS on 20170907_1101 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1101'); 
 daystr = '20170904';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('11:04:05') datenum('11:04:05') 10 
datenum('11:07:16') datenum('11:07:25') 10 
datenum('11:07:32') datenum('11:09:38') 10 
datenum('11:09:48') datenum('11:10:00') 10 
datenum('11:10:11') datenum('11:10:16') 10 
datenum('11:32:14') datenum('11:33:02') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return