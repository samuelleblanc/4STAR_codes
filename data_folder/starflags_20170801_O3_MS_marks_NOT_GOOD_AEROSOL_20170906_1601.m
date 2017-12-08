function marks = starflags_20170801_O3_MS_marks_NOT_GOOD_AEROSOL_20170906_1601  
 % starflags file for 20170801 created by MS on 20170906_1601 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170906_1601'); 
 daystr = '20170801';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('12:26:25') datenum('12:33:21') 10 
datenum('16:12:49') datenum('16:53:10') 10 
datenum('17:38:25') datenum('17:49:55') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return