clear all
close all

latN=38.5;
latS=32;
lonW=124;
lonE=133;

flight_days = {'02', '04', '05', '07', '11', '12', '13', '17', '18', '20', '22'};
for j=1:numel(flight_days);
% for j=1:1;
    
    h1 = figure('units','inches','position',[.1 .2 11 9],'paperposition',[.1 .1 5 3.2]);
    
    m_proj('Equidistant','long',[lonW lonE],'lat',[latS latN]);
    hold on
    
    %---plot rgb image as background---
    [P,map]=imread(['D:\zq_baeri\KORUS_rgb\aqua_201605',flight_days{j},'.tif']);
    [MAPX,MAPY]=m_ll2xy([lonW lonE],[latN latS],'clip','point');
    image(MAPX,MAPY,P);set(gca,'ydir','normal');
    hold on
    
    output_data=strcat('D:\zq_baeri\KORUS_rgb\201605',flight_days{j},'_track.mat');
    eval(['load ' output_data]);
    
    m_scatter(star_Lon,star_Lat,2,star_Alt);
    hold on
    caxis([0 floor(max(star_Alt)+1)]);  %for alt
    colormap('jet');
    H=colorbar;
    set(get(H,'ylabel'),'string','GPS Altitude [km]','fontsize',8,'fontname','arial');
    
    axis square
    m_grid_my('linest','-','linewidth',0.5,'tickdir','in','xtick',5,'ytick',5,'fontsize',6);
    hold on
    %------------------------
    
    xlabel('Longitude','fontsize',8),ylabel('Latitude','fontsize',8);
    titlestr = strcat('Aqua RGB, KORUS flight #',num2str(j), ', 201605',flight_days{j});
    font_size = [10];
    title(titlestr, 'fontsize', font_size);
 
    image1a = strcat('D:\zq_baeri\KORUS_rgb\plots\korus_track_201605',flight_days{j},'_aqua.ps');
    print(h1,'-r300','-dpsc2',image1a);
end