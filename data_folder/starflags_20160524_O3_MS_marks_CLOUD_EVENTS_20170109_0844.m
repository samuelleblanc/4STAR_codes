function marks = starflags_20160524_O3_MS_marks_CLOUD_EVENTS_20170109_0844  
 % starflags file for 20160524 created by MS on 20170109_0844 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0844'); 
 daystr = '20160524';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('07:05:25') datenum('07:21:03') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return