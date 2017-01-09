function marks = starflags_20160506_HCOH_MS_marks_ALL_20170109_0442  
 % starflags file for 20160506 created by MS on 20170109_0442 to mark ALL conditions 
 version_set('20170109_0442'); 
 daystr = '20160506';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:06:53') datenum('07:09:49') 03 
datenum('22:06:53') datenum('-2:50:30') 700 
datenum('22:53:45') datenum('07:09:49') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return