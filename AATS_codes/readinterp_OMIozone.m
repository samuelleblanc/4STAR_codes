function [OMIozone_interp,filename_OMIO3] = readinterp_OMIozone(imoda,latitude,longitude)

%if isempty(imoda) imoda=0408; end

%1-deg lat,lon spacing for OMI
latitude_OMIO3=[-89.5:1:89.5];
longitude_OMIO3=[-179.5:1:179.5];
path_OMIO3='c:\johnmatlab\ARCTAS\OMI_ozone\';
filename_OMIO3=strcat('L3_ozone_omi_2008',sprintf('%04d',imoda),'.txt');  
fidO3=fopen([path_OMIO3 filename_OMIO3]);

OMIozone_DU=zeros(360,180);
%skip 3 lines
for i=1:3,
   line = fgetl(fidO3);		%skip end-of-line character
end

for j=1:180,
kend=25;
for lines=1:15,  
   linedata = fgets(fidO3);
   if lines==15
      kend=10;
   end
   datain=linedata(2:kend*3+1);
   for kk=1:kend,
      ibeg=3*(kk-1)+1;
      idx=25*(lines-1)+kk;
      datause(idx)=str2num(datain(ibeg:ibeg+2));
   end
end

OMIozone_DU(:,j)=datause(1,:)';
end
fclose(fidO3)

%[X,Y]=meshgrid(longitude_OMIO3,latitude_OMIO3);
X=longitude_OMIO3'*ones(1,180);
Y=ones(360,1)*latitude_OMIO3;
OMIozone_interp = 0.001*interp2(X',Y',OMIozone_DU',longitude,latitude); %convert from DU to atm-cm

clear datause X Y OMIozone_DU longitude_OMIO3 latitude_OMIO3
