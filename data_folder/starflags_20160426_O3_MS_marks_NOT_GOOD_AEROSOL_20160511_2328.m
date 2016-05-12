function marks = starflags_20160426_O3_MS_marks_NOT_GOOD_AEROSOL_20160511_2328  
 % starflags file for 20160426 created by MS on 20160511_2328 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160511_2328'); 
 daystr = '20160426';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:38:32') datenum('13:08:21') 700 
datenum('13:12:27') datenum('13:16:03') 700 
datenum('13:29:48') datenum('13:30:57') 700 
datenum('13:59:10') datenum('14:04:28') 700 
datenum('17:14:27') datenum('17:28:28') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return