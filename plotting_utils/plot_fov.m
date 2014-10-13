function [dir]=plot_fov();
make_fig=true;


dir='C:\Users\Samuel\Research\4STAR\codes\';
load([dir '20140410star.mat'],'vis_fova','nir_fova','vis_fovp','nir_fovp');


[visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths();
lbls={'No Nd - 1 fiber','Nd - 1 fiber','Nd - 3 fiber',...
        'Nd - 3 fiber','Nd - 3 fiber','Nd_2 - 16 fiber',...
        'Nd_2 - 16 fiber','Nd_2 - 1 fiber','Nd_2 - 1 fiber'};


 % Normalize the raw values to the center points
 [numa numv]=size(vis_fova);
 for i=1:numv;
     for j=1:54-14; 
         vis_fova(i).norm_raw(j,:)=vis_fova(i).raw(j+14,:)./nanmean(vis_fova(i).raw([1:14 55:64],:))./1.2;
         nir_fova(i).norm_raw(j,:)=nir_fova(i).raw(j+14,:)./nanmean(nir_fova(i).raw([1:14 55:64],:))./1.2;
     end;
     vis_fova(i).deg=abs(vis_fova(i).AZ_deg(15:54))-mean(abs(vis_fova(i).AZ_deg(15:54)));
     nir_fova(i).deg=abs(nir_fova(i).AZ_deg(15:54))-mean(abs(nir_fova(i).AZ_deg(15:54)));

    if make_fig;  
     v=0.7:0.05:1.3;
     fig=figure;
     set(fig, 'units', 'centimeter', 'position', [2 2 30 15]);
     subplot(1,2,1);
     contourf(vis_fova(i).deg,visw,vis_fova(i).norm_raw',v);
     xlabel('Angle from center');
     ylabel('Wavelength (um)');
     title([lbls(i);'AZ FOV for VIS']);
     colorbar;
     
     subplot(1,2,2);
     contourf(nir_fova(i).deg,nirw,nir_fova(i).norm_raw',v);
     xlabel('Angle from center');
     ylabel('Wavelength (um)');
     title('AZ FOV for NIR');
     colorbar;
     
     text(.75,1.25,lbls(i))
     fname=['FOVA_contour_' num2str(i,'%0d') '' '.fig'];
     starsas(fname,'Samuel');
    end;
 end;

 
 % now make plots of comparisons of the fov for the same pixel, but different setups
 fig=figure;
 set(0,'defaultlinelinewidth',1.5)
 set(fig, 'units', 'centimeter', 'position', [6 2 18 28]);
 subplot(2,1,1);
 plot(vis_fova(1).deg,vis_fova(1).norm_raw(:,407),'linewidth',2.5);
 xlabel('Angle from Center');
 ylabel('Normalized counts');
 ylim([0.85 1.15]);
 %set(gca,'Position',[],'Units','normalized');
 title('AZ FOV for different configurations at 500 nm');
 hold on;
 cl=hsv(numv);
 for i=2:numv;
     plot(vis_fova(i).deg,vis_fova(i).norm_raw(:,407),'color',cl(i,:));
     if i==6; set(gca,'linewidth',2.5); end;
 end;
 grid on;
 hold off;
 hl=legend('No Nd - 1 fiber','Nd - 1 fiber','Nd - 3 fiber',...
        'Nd - 3 fiber','Nd - 3 fiber','Nd_2 - 16 fiber',...
        'Nd_2 - 16 fiber','Nd_2 - 1 fiber','Nd_2 - 1 fiber');
set(hl,'Position',[0.8 0.75 0.2 0.2],'Units','normalized');
 
 subplot(2,1,2);
 plot(nir_fova(1).deg,nir_fova(1).norm_raw(:,146),'linewidth',2.5);
 ylim([0.85 1.15]);
 xlabel('Angle from Center');
 ylabel('Normalized counts');
 title('AZ FOV for different configurations at 1200 nm');
 hold on;
 
 for i=2:numv;
     plot(nir_fova(i).deg,nir_fova(i).norm_raw(:,146),'color',cl(i,:));
     if i==6; set(gca,'linewidth',2.5); end;
 end;
 grid on;
 hold off;
 % legend('No diff - 1 fiber','diff - 1 fiber','diff - 3 fiber',...
 %       'diff_2 - 3 fiber','diff_2 - 3 fiber','diff_2 - 16 fiber',...
 %       'diff_2 - 16 fiber','diff_2 - 1 fiber','diff_2 - 1 fiber');
 
 fname=['FOVA_comparison' '.fig'];
 starsas(fname,'Samuel');

 %%%%%%
 %%%%%%
 %% Now do the same for fovp
 %%%%%%
 %%%%%%
 
 
 lbls={'No Nd - 1 fiber','Nd - 1 fiber','Nd - 3 fiber',...
        'Nd - 3 fiber','Nd_2 - 16 fiber',...
        'Nd_2 - 16 fiber','Nd_2 - 1 fiber','Nd_2 - 1 fiber'};
  % Normalize the raw values to the center points
 [numa numv]=size(vis_fovp);
 for i=1:numv;
     for j=1:54-14; 
         vis_fovp(i).norm_raw(j,:)=vis_fovp(i).raw(j+14,:)./nanmean(vis_fovp(i).raw([1:14 55:64],:))./1.2;
         nir_fovp(i).norm_raw(j,:)=nir_fovp(i).raw(j+14,:)./nanmean(nir_fovp(i).raw([1:14 55:64],:))./1.2;
     end;
     vis_fovp(i).deg=abs(vis_fovp(i).El_deg(15:54))-mean(abs(vis_fovp(i).El_deg(15:54)));
     nir_fovp(i).deg=abs(nir_fovp(i).El_deg(15:54))-mean(abs(nir_fovp(i).El_deg(15:54)));

    if make_fig;  
     v=0.7:0.05:1.3;
     fig=figure;
     set(fig, 'units', 'centimeter', 'position', [2 2 30 15]);
     subplot(1,2,1);
     contourf(vis_fovp(i).deg,visw,vis_fovp(i).norm_raw',v);
     xlabel('Angle from center');
     ylabel('Wavelength (um)');
     title([lbls(i);'Principal FOV for VIS']);
     colorbar;
     
     subplot(1,2,2);
     contourf(nir_fovp(i).deg,nirw,nir_fovp(i).norm_raw',v);
     xlabel('Angle from center');
     ylabel('Wavelength (um)');
     title('Pricinpal FOV for NIR');
     colorbar;
     
     text(.75,1.25,lbls(i))
     fname=['FOVP_contour_' num2str(i,'%0d') '' '.fig'];
     starsas(fname,'Samuel');
    end;
 end;

 
 % now make plots of comparisons of the fov for the same pixel, but different setups
 fig=figure;
 set(0,'defaultlinelinewidth',1.5)
 set(fig, 'units', 'centimeter', 'position', [6 2 18 28]);
 subplot(2,1,1);
 plot(vis_fovp(1).deg,vis_fovp(1).norm_raw(:,407),'linewidth',2.5);
 xlabel('Angle from Center');
 ylabel('Normalized counts');
 ylim([0.85 1.15]);
 %set(gca,'Position',[],'Units','normalized');
 title('Principal FOV for different configurations at 500 nm');
 hold on;
 cl=hsv(numv);
 for i=2:numv;
     plot(vis_fovp(i).deg,vis_fovp(i).norm_raw(:,407),'color',cl(i,:));
     if i==6; set(gca,'linewidth',2.5); end;
 end;
 grid on;
 hold off;
 hl=legend('No Nd - 1 fiber','Nd - 1 fiber','Nd - 3 fiber',...
        'Nd - 3 fiber','Nd_2 - 16 fiber',...
        'Nd_2 - 16 fiber','Nd_2 - 1 fiber','Nd_2 - 1 fiber');
set(hl,'Position',[0.8 0.75 0.2 0.2],'Units','normalized');
 
 subplot(2,1,2);
 plot(nir_fovp(1).deg,nir_fovp(1).norm_raw(:,146),'linewidth',2.5);
 ylim([0.85 1.15]);
 xlabel('Angle from Center');
 ylabel('Normalized counts');
 title('Principal FOV for different configurations at 1200 nm');
 hold on;
 
 for i=2:numv;
     plot(nir_fovp(i).deg,nir_fovp(i).norm_raw(:,146),'color',cl(i,:));
     if i==6; set(gca,'linewidth',2.5); end;
 end;
 grid on;
 hold off;
 % legend('No diff - 1 fiber','diff - 1 fiber','diff - 3 fiber',...
 %       'diff_2 - 3 fiber','diff_2 - 3 fiber','diff_2 - 16 fiber',...
 %       'diff_2 - 16 fiber','diff_2 - 1 fiber','diff_2 - 1 fiber');
 
 fname=['FOVP_comparison' '.fig'];
 starsas(fname,'Samuel');
 
 return;
 %end;