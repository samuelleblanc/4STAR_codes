function marks = starflags_20170830_CWV_MS_marks_CLOUD_EVENTS_20170907_1143  
 % starflags file for 20170830 created by MS on 20170907_1143 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1143'); 
 daystr = '20170830';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('15:23:02') datenum('15:37:21') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return