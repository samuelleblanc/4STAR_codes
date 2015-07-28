% function that searches the OMI values that fall within the flight path
% grid
% MS, Feb-18, 2015, modified from determine_OMIozone_gridcells
%-----------------------------------------------------------------------
function [OMI_latgridsav,OMI_longridsav,lat_OMI,lon_OMI,ixtrk_OMI,iytrk_OMI,ozoneDU_OMI,CloudFraction_OMI,CloudPressure_OMI,UVAerosolIndex_OMI,...
    ozoneDU_OMI_vect,CloudFraction_OMI_vect,CloudPressure_OMI_vect,UVAerosolIndex_OMI_vect,...
    idx4STAR_ingrid,lat_OMI_center,lon_OMI_center,lat_OMI_corner,lon_OMI_corner]=...
    determine_OMIo3grid_gridcells(o3infile,file4STAR,maplonlim,maplatlim,lat_4STAR,lon_4STAR,idx4STAR_crit)

% read file
o3 = readOMIo3grid(o3infile);
% assign variables
ozoneDU_OMI_in        =o3.o3col;
lat_OMI_in            =o3.lat;
lon_OMI_in            =o3.lon;
CloudFraction_OMI_in  =o3.cldF;
CloudPressure_OMI_in  =o3.cldP;
UVAerosolIndex_OMI_in =o3.uvAI;
%UTdechr_OMI_in        =o3.time/3600;

%-------find data in research area
[ri,rj]=find(lon_OMI_in>=maplonlim(1) & lon_OMI_in<=maplonlim(2) & lat_OMI_in>=maplatlim(1) & lat_OMI_in<=maplatlim(2));
long=lon_OMI_in(unique(ri),unique(rj));
lat=lat_OMI_in(unique(ri),unique(rj));
ozoneDU_OMI_filter=ozoneDU_OMI_in(unique(ri),unique(rj));
CloudFraction_OMI_filter=CloudFraction_OMI_in(unique(ri),unique(rj));
CloudPressure_OMI_filter=CloudPressure_OMI_in(unique(ri),unique(rj));
UVAerosolIndex_filter   =UVAerosolIndex_OMI_in(unique(ri),unique(rj));

figure(443)
plot(lon_OMI_in,lat_OMI_in,'.')
set(gca,'fontsize',16)
grid on
xlabel('Longitude (deg)','fontsize',24)
ylabel('Latitude (deg)','fontsize',24)
strtitle=o3infile;
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
        ozoneDU_OMI(iOMImap)=ozoneDU_OMI_filter(ixtrk,iytrk);
        CloudFraction_OMI(iOMImap)=CloudFraction_OMI_filter(ixtrk,iytrk);
        CloudPressure_OMI(iOMImap)=CloudPressure_OMI_filter(ixtrk,iytrk);
        UVAerosolIndex_OMI(iOMImap)=UVAerosolIndex_filter(ixtrk,iytrk);
        %AlgorithmFlags_OMI(iOMImap)=AlgorithmFlags_filter(ixtrk,iytrk);
   end
end

flag_plot_annotateOMIgrids='yes';%'yesannotate';
flag_outlinegridcell='no';
if strcmp(flag_plot_annotateOMIgrids(1:3),'yes')
    figure(444)
    plot(lon_OMI_center,lat_OMI_center,'b.','markersize',12)
    if strcmp(flag_plot_annotateOMIgrids,'yesannotate')
        for ii=1:length(lon_OMI_center),
         htt=text(lon_OMI_center(ii),lat_OMI_center(ii),sprintf('%5.3f',ozoneDU_OMI(ii)));
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
            text(long(ixtrk,iytrk),lat(ixtrk,iytrk)+0.02,sprintf('%d,%6.1f',length(value1),ozoneDU_OMI_filter(ixtrk,iytrk)))
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
           if ozoneDU_OMI_filter(ixtrk,iytrk,1)>0
            iOMI=iOMI+1;
            lat_OMI(iOMI)=lat(ixtrk,iytrk);
            lon_OMI(iOMI)=long(ixtrk,iytrk);
            ozoneDU_OMI_vect(iOMI)=ozoneDU_OMI_filter(ixtrk,iytrk,:);
            CloudFraction_OMI_vect(iOMI)=CloudFraction_OMI_filter(ixtrk,iytrk,:);
            CloudPressure_OMI_vect(iOMI)=CloudPressure_OMI_filter(ixtrk,iytrk,:);
            UVAerosolIndex_OMI_vect(iOMI)=UVAerosolIndex_filter(ixtrk,iytrk,:);
            %AlgorithmFlags_OMI_vect(iOMI)=AlgorithmFlags_filter(ixtrk,iytrk,:);
            %TAI_Scan_Start_Time(iOMI)=TAI_Scan_Start_Time_filter(ixtrk,iytrk);
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
    ozoneDU_OMI_vect=[];
    OMI_latgridsav=[];
    OMI_longridsav=[];
    idx4STAR_ingrid=[];
    ixtrk_OMI=[];
    iytrk_OMI=[];
else
end

return