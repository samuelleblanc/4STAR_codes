daystr = '20151118';  
 s.intervals=[ 
 datenum('19:39:23') datenum('19:40:28') 02 
datenum('19:41:38') datenum('19:42:11') 02 
datenum('19:39:23') datenum('19:40:28') 700 
datenum('19:41:38') datenum('19:42:11') 700 
datenum('11:12:15') datenum('11:30:28') 10 
datenum('11:30:35') datenum('11:46:02') 10 
];  
s.intervals(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);