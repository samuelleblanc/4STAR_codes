function marks = starflags_20170817_O3_MS_marks_CLOUD_EVENTS_20170907_1412  
 % starflags file for 20170817 created by MS on 20170907_1412 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1412'); 
 daystr = '20170817';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:43:02') datenum('08:43:09') 700 
datenum('08:46:58') datenum('08:47:01') 700 
datenum('08:39:06') datenum('08:43:09') 10 
datenum('08:46:58') datenum('08:48:27') 10 
datenum('15:47:29') datenum('15:51:47') 10 
datenum('15:51:53') datenum('15:51:54') 10 
datenum('15:53:04') datenum('16:03:29') 10 
datenum('16:39:45') datenum('16:51:14') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return