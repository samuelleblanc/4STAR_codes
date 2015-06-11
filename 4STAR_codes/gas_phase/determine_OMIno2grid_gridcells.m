% function that searches the OMI values that fall within the flight path
% grid
% MS, Feb-18, 2015, modified from determine_OMINO2_gridcells
%-----------------------------------------------------------------------
function [OMI_latgridsav,OMI_longridsav,lat_OMI,lon_OMI,ixtrk_OMI,iytrk_OMI,lat_OMI_center,lon_OMI_center,lat_OMI_corner,lon_OMI_corner,...
    NO2_OMI_map,NO2std_OMI_map,NO2strat_OMI_map,NO2stratstd_OMI_map,NO2trop_OMI_map,NO2tropstd_OMI_map,NO2CloudFraction_OMI_map,NO2CloudPressure_OMI_map,...
    NO2_OMI,NO2std_OMI,NO2strat_OMI,NO2stratstd_OMI,NO2trop_OMI,NO2tropstd_OMI,NO2CloudFraction_OMI,NO2CloudPressure_OMI,idx4STAR_ingrid]=...
    determine_OMIno2grid_gridcells(no2infile,file4STAR,maplonlim,maplatlim,lat_4STAR,lon_4STAR,idx4STAR_crit)

% yyyy_process=str2num(fileOMI_NO2(19:22));
% mm_process=str2num(fileOMI_NO2(24:25));
% dd_process=str2num(fileOMI_NO2(26:27));
% days_since01Jan1993_00UT=julian(dd_process,mm_process,yyyy_process,0)-julian(1,1,1993,0);

% read file
no2 = readOMIno2grid(no2infile);
% assign variables

NO2_OMI_in         = no2.no2col;
NO2std_OMI_in      = no2.no2colStd;
NO2strat_OMI_in    = no2.no2colStrat;
NO2stratstd_OMI_in = no2.no2colStratStd;
NO2trop_OMI_in     = no2.no2colTrop;
NO2tropstd_OMI_in  = no2.no2colTropStd;
lat_OMI_in         = no2.lat;
lon_OMI_in         = no2.lon;
NO2CloudFraction_in= no2.cldF;
NO2CloudPressure_in= no2.cldP%[hPa]
%TAI_Scan_Start_Time_in=double(hdf5read(dirfile,'/HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/Time')); % TAI Time at Start of Scan replicated across line swath; Seconds since 1993-1-1 00:00:00.0 0   

%-------find data in research area
[ri,rj]=find(lon_OMI_in>=maplonlim(1) & lon_OMI_in<=maplonlim(2) & lat_OMI_in>=maplatlim(1) & lat_OMI_in<=maplatlim(2));
long=lon_OMI_in(unique(ri),unique(rj));
lat=lat_OMI_in(unique(ri),unique(rj));
% TAI_Scan_Start_Time_filter=TAI_Scan_Start_Time_in(unique(rj));
% UTdechr_OMI_in = 24*(TAI_Scan_Start_Time_filter - days_since01Jan1993_00UT*86400 - 33)/86400; %conversion to UT
NO2_OMI_filter=NO2_OMI_in(unique(ri),unique(rj));
NO2std_OMI_filter=NO2std_OMI_in(unique(ri),unique(rj));
NO2strat_OMI_filter=NO2strat_OMI_in(unique(ri),unique(rj));
NO2stratstd_OMI_filter=NO2stratstd_OMI_in(unique(ri),unique(rj));
NO2trop_OMI_filter=NO2trop_OMI_in(unique(ri),unique(rj));
NO2tropstd_OMI_filter=NO2tropstd_OMI_in(unique(ri),unique(rj));
NO2CloudFraction_OMI_filter=NO2CloudFraction_in(unique(ri),unique(rj));
NO2CloudPressure_OMI_filter=NO2CloudPressure_in(unique(ri),unique(rj));

figure(453)
plot(lon_OMI_in,lat_OMI_in,'.')
set(gca,'fontsize',16)
grid on
xlabel('Longitude (deg)','fontsize',24)
ylabel('Latitude (deg)','fontsize',24)
strtitle=no2infile;
for i=1:length(strtitle),
    if strcmp(strtitle(i),'_') strtitle(i)='-'; end
end       
title(strtitle,'fontsize',14)

%---- move lat and long to make original lat and long in the center of pcolor square
%---- only used if plotting image
new_x=1:length(lat(:,1))-1;
new_y=1:length(lat(1,:))-1;
for i = 1:length(lat(:,2))-1
    for j = 1:length(lat(1,:))-1
       long_moved(i,j) = long(i,j)-(long(i+1,j+1)-long(i,j))/2;
       lat_moved(i,j) = lat(i,j)-(lat(i+1,j+1)-lat(i,j))/2;
   end
end

%find grid polygon vertices
for iytrk=2:size(lat,2)-1, 
    for ixtrk=2:size(lat,1)-1, 
        lat1=lat(ixtrk,iytrk);
        lon1=long(ixtrk,iytrk);
        %upper right
        rng=distance(lat1,lon1,lat(ixtrk-1,iytrk+1),long(ixtrk-1,iytrk+1));
        az=azimuth(lat1,lon1,lat(ixtrk-1,iytrk+1),long(ixtrk-1,iytrk+1));
        [latout(ixtrk,iytrk,1),lonout(ixtrk,iytrk,1)]=reckon(lat1,lon1,0.5*rng,az);
        %upper left
        rng=distance(lat1,lon1,lat(ixtrk+1,iytrk+1),long(ixtrk+1,iytrk+1));
        az=azimuth(lat1,lon1,lat(ixtrk+1,iytrk+1),long(ixtrk+1,iytrk+1));
        [latout(ixtrk,iytrk,2),lonout(ixtrk,iytrk,2)]=reckon(lat1,lon1,0.5*rng,az);
        %lower left
        rng=distance(lat1,lon1,lat(ixtrk+1,iytrk-1),long(ixtrk+1,iytrk-1));
        az=azimuth(lat1,lon1,lat(ixtrk+1,iytrk-1),long(ixtrk+1,iytrk-1));
        [latout(ixtrk,iytrk,3),lonout(ixtrk,iytrk,3)]=reckon(lat1,lon1,0.5*rng,az);
        %lower right
        rng=distance(lat1,lon1,lat(ixtrk-1,iytrk-1),long(ixtrk-1,iytrk-1));
        az=azimuth(lat1,lon1,lat(ixtrk-1,iytrk-1),long(ixtrk-1,iytrk-1));
        [latout(ixtrk,iytrk,4),lonout(ixtrk,iytrk,4)]=reckon(lat1,lon1,0.5*rng,az);
        %repeat upper right point for drawing polygon
        latout(ixtrk,iytrk,5)=latout(ixtrk,iytrk,1);
        lonout(ixtrk,iytrk,5)=lonout(ixtrk,iytrk,1);
    end
end

%save pixels within map limits
iOMImap=0;
for iytrk=2:size(lat,2)-1, %11:11,  %
    for ixtrk=2:size(lat,1)-1, %12:12, %
        iOMImap=iOMImap+1;
        lattemp=permute(latout(ixtrk,iytrk,:),[3 1 2]);
        lontemp=permute(lonout(ixtrk,iytrk,:),[3 1 2]);
        lat_OMI_center(iOMImap)=lat(ixtrk,iytrk);
        lon_OMI_center(iOMImap)=long(ixtrk,iytrk);
        lat_OMI_corner(:,iOMImap)=lattemp;
        lon_OMI_corner(:,iOMImap)=lontemp;
        NO2_OMI_map(iOMImap)=NO2_OMI_filter(ixtrk,iytrk);
        NO2std_OMI_map(iOMImap)=NO2std_OMI_filter(ixtrk,iytrk);
        NO2strat_OMI_map(iOMImap)=NO2strat_OMI_filter(ixtrk,iytrk);
        NO2stratstd_OMI_map(iOMImap)=NO2stratstd_OMI_filter(ixtrk,iytrk);
        NO2trop_OMI_map(iOMImap)=NO2trop_OMI_filter(ixtrk,iytrk);
        NO2tropstd_OMI_map(iOMImap)=NO2tropstd_OMI_filter(ixtrk,iytrk);
        NO2CloudFraction_OMI_map(iOMImap)=NO2CloudFraction_OMI_filter(ixtrk,iytrk);
        NO2CloudPressure_OMI_map(iOMImap)=NO2CloudPressure_OMI_filter(ixtrk,iytrk);
    end
end

flag_plot_annotateOMIgrids='yes';%'yesannotate';
flag_outlinegridcell='no';
if strcmp(flag_plot_annotateOMIgrids(1:3),'yes')
    figure(454)
    plot(lon_OMI_center,lat_OMI_center,'b.','markersize',12)
    if strcmp(flag_plot_annotateOMIgrids,'yesannotate')
        for ii=1:length(lon_OMI_center),
         htt=text(lon_OMI_center(ii),lat_OMI_center(ii),sprintf('%10.3e',NO2_OMI_map(ii)));
         set(htt,'fontsize',10)
        end
    end
    set(gca,'xlim',maplonlim,'ylim',maplatlim)
    hold on
    if strcmp(flag_outlinegridcell,'yes')
        for iy=2:size(lat,2)-1,
            for ix=2:size(lat,1)-1,
                hold on
                latplotit=permute(latout(ix,iy,:),[3,1,2]);
                lonplotit=permute(lonout(ix,iy,:),[3,1,2]);
                plot(lonplotit,latplotit,'b--')
            end
        end
    end
end

%for aircraft below certain altitude find indices of track that fall within grid box
xx=lon_4STAR(idx4STAR_crit);
yy=lat_4STAR(idx4STAR_crit);
for iytrk=2:size(lat,2)-1,
    for ixtrk=2:size(lat,1)-1,
        idxin=inpolygon(xx,yy,squeeze(lonout(ixtrk,iytrk,:)),squeeze(latout(ixtrk,iytrk,:)));
        idxin_sav(:,ixtrk,iytrk)=idxin;  %this will save for each box        
        value1=find(idxin==1);
        if ~isempty(value1) 
            plot(xx(idxin==1),yy(idxin==1),'yo');
            text(long(ixtrk,iytrk),lat(ixtrk,iytrk)+0.02,sprintf('%d,%6.3f,%6.3f,%6.3f',length(value1),NO2_OMI_filter(ixtrk,iytrk)*1e-15,NO2strat_OMI_filter(ixtrk,iytrk)*1e-15,NO2trop_OMI_filter(ixtrk,iytrk)*1e-15))
        end
    end
end

flag_label_box='no';
iOMI=0;
for iytrk=2:size(lat,2)-1, %11:11,  %
    for ixtrk=2:size(lat,1)-1, %12:12, %
        lonplt=permute(lonout(ixtrk,iytrk,:),[3 1 2]);
        latplt=permute(latout(ixtrk,iytrk,:),[3 1 2]);
        if all(lonplt) & all(latplt) & any(idxin_sav(:,ixtrk,iytrk))
           if NO2_OMI_filter(ixtrk,iytrk,1)>0
            iOMI=iOMI+1;
            lat_OMI(iOMI)=lat(ixtrk,iytrk);
            lon_OMI(iOMI)=long(ixtrk,iytrk);
            NO2_OMI(iOMI)=NO2_OMI_filter(ixtrk,iytrk);
            NO2std_OMI(iOMI)=NO2std_OMI_filter(ixtrk,iytrk);
            NO2strat_OMI(iOMI)=NO2strat_OMI_filter(ixtrk,iytrk);
            NO2stratstd_OMI(iOMI)=NO2stratstd_OMI_filter(ixtrk,iytrk);
            NO2trop_OMI(iOMI)=NO2trop_OMI_filter(ixtrk,iytrk);
            NO2tropstd_OMI(iOMI)=NO2tropstd_OMI_filter(ixtrk,iytrk);
            NO2CloudFraction_OMI(iOMI)=NO2CloudFraction_OMI_filter(ixtrk,iytrk);
            NO2CloudPressure_OMI(iOMI)=NO2CloudPressure_OMI_filter(ixtrk,iytrk);
            %UTdechr_OMI(iOMI)=UTdechr_OMI_in(iytrk);
            OMI_latgridsav(:,iOMI)=latplt;
            OMI_longridsav(:,iOMI)=lonplt;
            idx4STAR_ingrid(:,iOMI)=idxin_sav(:,ixtrk,iytrk);
            n4STAR_ingrid(iOMI)=length(find(idx4STAR_ingrid(:,iOMI)==1));
            ixtrk_OMI(iOMI)=ixtrk;
            iytrk_OMI(iOMI)=iytrk;
            
            line(lonplt,latplt,'linest','-','color','r') %,'linewidth',2);
            plot(long(ixtrk,iytrk),lat(ixtrk,iytrk),'g.','markersize',10);  %plot grid box centerpoints
            if strcmp(flag_label_box,'yes')
                value1=find(idxin_sav(:,ixtrk,iytrk)==1);
                ht=text(long(ixtrk,iytrk),lat(ixtrk,iytrk),sprintf('%d,%d,%d',ixtrk,iytrk,length(value1)));
            end
           end
        end
    end
end
set(gca,'fontsize',20)
xlabel('Longitude (deg)','fontsize',24)
ylabel('Latitude (deg)','fontsize',24)
title(sprintf('%s   %s',file4STAR,strtitle),'fontsize',14)

if iOMI==0
    lat_OMI=[];
    lon_OMI=[];
    NO2_OMI=[];
    NO2std_OMI=[];
    NO2strat_OMI=[];
    NO2stratstd_OMI=[];
    NO2trop_OMI(iOMI)=[];
    NO2tropstd_OMI(iOMI)=[];
    OMI_latgridsav=[];
    OMI_longridsav=[];
    idx4STAR_ingrid=[];
    ixtrk_OMI=[];
    iytrk_OMI=[];
    %UTdechr_OMI=[];
end

return