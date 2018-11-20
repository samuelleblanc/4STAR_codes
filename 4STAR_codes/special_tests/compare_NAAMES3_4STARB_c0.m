%compare_NAAMES3_4STARB_c0.m: want to make a code which will compare the runs
%from the two different sets of c0s, the one which is just derived from
%rooftop measurements, and the one which includes Yohei's field-derived c0
%plus 3%, to see the magnitude of this effect.  Also, if we're going there,
%it would be great if it can give us an idea of the high-alt c0s too...

%October 2018.  This is going to be very specific to Kristina's machine,
%sorry.

%pull save_wvls from SEmakearchive_NAAMES_2017_AOD.m
save_wvls  = [354.9,380.0,451.7,470.2,500.7,520,530.3,532.0,550.3,605.5,619.7,660.1,675.2,699.7,780.6,864.6,1019.9,1039.6,1064.2,1235.8,1249.9,1558.7,1626.6,1650.1];
[v,n] = starwavelengths(now,'4STARB'); wvl = [v,n].*1000.0;
%indices of the above, as in line 305 from the above makearchive
save_iwvls=[227,258,347,370,408,432,444,447,469,538,556,607,626,657,760,868,1085,1096,1110,1215,1224,1442,1495,1514];

fltdays={'20170831','20170904','20170906','20170908','20170909','20170912','20170916','20170917','20170919','20170920','20180318','20180324'};%
aodmins=NaN*ones(length(fltdays),length(save_wvls)); %make an array to store the minimum AOD, by flight day and by wavelength, to see who's <0
% for fltday=1%:3%length(fltdays)
%     aod1=load(['C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibonlyrooftop\4STARB_',fltdays{fltday},'starsun.mat'],'w','t','tau_aero_polynomial','tau_aero','Alt')
%     flagname=dir(['C:\Users\kpistone\Documents\4STAR_codes\data_folder\',fltdays{fltday},'_starflag_man_*KP.mat'])
%     %here plot first tau aero as it is
%     highz=aod1.tau_aero((aod1.Alt>5e3),:);
%     figure; plot(1000*aod1.w,highz(1:500:end,:),'-'); ylim([-0.1 0.5])
%     for lala=1:length(aod1.t)
%         aod1.tau_aero_calc(lala,:)=exp(polyval([aod1.tau_aero_polynomial(lala,:)],log(1e-3*save_wvls)));
%     end
%     if ~isempty(flagname) %add another check because i didn't flag 2018...
%         flags1=load(['C:\Users\kpistone\Documents\4STAR_codes\data_folder\',flagname.name,''])
% 
%         %simplify some variable names
%         aod1.tau_aero_calc(flags1.bad_aod==1,:)=NaN;
%         aod1.tau_aero_calc(flags1.cirrus==1,:)=NaN;
%         aod1.tau_aero_calc(flags1.unspecified_clouds==1,:)=NaN;
%         aod1.tau_aero(flags1.bad_aod==1,:)=NaN;
%         aod1.tau_aero(flags1.cirrus==1,:)=NaN;
%         aod1.tau_aero(flags1.unspecified_clouds==1,:)=NaN;
%     end
% %     figure; 
%     figidx=0;
%     for i=1:length(save_iwvls)
%         figidx=figidx+1;
% %         if figidx>12; figidx=1; figure; end
% %         subplot(3,4,figidx); 
% %         hist(aod1.tau_aero((aod1.Alt>5e3),(i)),-5e-2:2e-3:0.1); hold on; grid on; 
% %         title([datestr(aod1.t(1),'yyyy-mmm-dd'),' ',num2str(save_wvls(i)),'nm'])
% %         xlabel('AOD (>5km)')
%         aodmins(fltday,i)=min(aod1.tau_aero((aod1.Alt>5e3),(i)));
%     end
%     hold on; plot(save_wvls,aod1.tau_aero_calc(1:500:end,:),'-','linewidth',2)
%     set(gca,'yscale','log')
%     xlabel('w'); ylabel('AOD'); title([datestr(aod1.t(1),'yyyy-mmm-dd'),', subset of >5km data'])
% end

%%%%%OLD VERSION, THIS ONE USES TAU_AERO DIRECTLY INSTEAD OF TAU_AERO_POLY
fltdays={'20170831','20170904','20170906','20170908','20170909','20170912','20170916','20170917','20170919','20170920','20180318','20180324'};%
aodmins=NaN*ones(length(fltdays),length(save_wvls)); %make an array to store the minimum AOD, by flight day and by wavelength, to see who's <0
for fltday=1:length(fltdays)
    aod1=load(['C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibonlyrooftop\4STARB_',fltdays{fltday},'starsun_small.mat'])
    flagname=dir(['C:\Users\kpistone\Documents\4STAR_codes\data_folder\',fltdays{fltday},'_starflag_man_*KP.mat'])
    if ~isempty(flagname) %add another check because i didn't flag 2018...
        flags1=load(['C:\Users\kpistone\Documents\4STAR_codes\data_folder\',flagname.name,''])

        %simplify some variable names
        aod1.tau_aero(flags1.bad_aod==1,:)=NaN;
        aod1.tau_aero(flags1.cirrus==1,:)=NaN;
        aod1.tau_aero(flags1.unspecified_clouds==1,:)=NaN;
    end
    figure; 
    figidx=0;
    for i=1:length(save_iwvls)
        figidx=figidx+1;
        if figidx>12; figidx=1; starsas(['NAAMES3_4STARB_archival_g5kmAODs_',fltdays{fltday},'_1.fig'],'compare_NAAMES3_4STARB_c0.m'); figure; end
        subplot(3,4,figidx); 
        hist(aod1.tau_aero((aod1.Alt>5e3),save_iwvls(i)),-5e-2:2e-3:0.1); hold on; grid on; 
        title([datestr(aod1.t(1),'yyyy-mmm-dd'),' ',num2str(save_wvls(i)),'nm'])
        xlabel('AOD (>5km)')
        aodmins(fltday,i)=min(aod1.tau_aero((aod1.Alt>5e3),save_iwvls(i)));
    end
    
    starsas(['NAAMES3_4STARB_archival_g5kmAODs_',fltdays{fltday},'_2.fig'],'compare_NAAMES3_4STARB_c0.m'); 
    highz=aod1.tau_aero((aod1.Alt>5e3),:);
    figure; plot(aod1.w,highz(1:500:end,:),'-'); ylim([-0.1 0.5])
    xlabel('w'); ylabel('AOD'); title([datestr(aod1.t(1),'yyyy-mmm-dd'),', subset of >5km data'])
end
%%%%%






% 
% aods_20170831_calibwithinfield=load('C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibwithinfield\4STARB_20170831starsun_small.mat')
% aods_20170831_calibrooftoponly=load('C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibonlyrooftop\4STARB_20170831starsun_small.mat')
% flags0831=load('20170831_starflag_man_created20180512_1333by_KP.mat')
% 
% %simplify some variable names
% aod1=aods_20170831_calibrooftoponly;
% aod2=aods_20170831_calibwithinfield;
% aod1.tau_aero(flags0831.bad_aod==1,:)=NaN;
% aod2.tau_aero(flags0831.bad_aod==1,:)=NaN;
% aod1.tau_aero(flags0831.cirrus==1,:)=NaN;
% aod2.tau_aero(flags0831.cirrus==1,:)=NaN;
% aod1.tau_aero(flags0831.unspecified_clouds==1,:)=NaN;
% aod2.tau_aero(flags0831.unspecified_clouds==1,:)=NaN;
% 
% % 
% % figure; 
% % figidx=0;
% % for i=1:length(save_iwvls)
% %     figidx=figidx+1;
% %     if figidx>6; figidx=1; figure; end
% %     subplot(3,2,figidx); 
% %     plot(aod1.t,aod1.tau_aero(:,save_iwvls(i))-aod2.tau_aero(:,save_iwvls(i)),'.k'); hold on; grid on; 
% %     plot(aod1.t((aod1.Alt>5e3)),aod1.tau_aero((aod1.Alt>5e3),save_iwvls(i))-aod2.tau_aero((aod1.Alt>5e3),save_iwvls(i)),'or'); hold on; grid on; 
% % %     plot(-0.1:0.1:1,-0.1:0.1:1,'--r')
% %     dynamicDateTicks
% %     title(num2str(save_wvls(i)))
% %     
% % end
% 
% % %this one is a no-fly day, sigh.
% % aods_20170903_calibwithinfield=load('C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibwithinfield\4STARB_20170903starsun_small.mat')
% % aods_20170903_calibrooftoponly=load('C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibonlyrooftop\4STARB_20170903starsun_small.mat')
% % flags0903=load('20170903_starflag_man_created20180512_1503by_KP.mat')
% % 
% % %simplify some variable names
% % aod1=aods_20170903_calibrooftoponly;
% % aod2=aods_20170903_calibwithinfield;
% % 
% % 
% % aods_20170904_calibwithinfield=load('C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibwithinfield\4STARB_20170904starsun_small.mat')
% % aods_20170904_calibrooftoponly=load('C:\Users\kpistone\Documents\NAAMES\4STARB_NAAMES3_calibonlyrooftop\4STARB_20170904starsun_small.mat')
% % flags0904=load('20170904_starflag_man_created20180527_1628by_KP.mat')
% % 
% % 
% % %simplify some variable names
% % aod1=aods_20170904_calibrooftoponly;
% % aod2=aods_20170904_calibwithinfield;
% % aod1.tau_aero(flags0904.bad_aod==1,:)=NaN;
% % aod2.tau_aero(flags0904.bad_aod==1,:)=NaN;
% % aod1.tau_aero(flags0904.cirrus==1,:)=NaN;
% % aod2.tau_aero(flags0904.cirrus==1,:)=NaN;
% % aod1.tau_aero(flags0904.unspecified_clouds==1,:)=NaN;
% % aod2.tau_aero(flags0904.unspecified_clouds==1,:)=NaN;
% 
% %plot the difference between the two tau_aeros calculated with different
% %c0s as a function of time, for the archiving wavelengths. special flag for
% %high-altitude times.
% figure; 
% figidx=0;
% for i=1:length(save_iwvls)
%     figidx=figidx+1;
%     if figidx>6; figidx=1; figure; end
%     subplot(3,2,figidx); 
%     plot(aod1.t,aod1.tau_aero(:,save_iwvls(i))-aod2.tau_aero(:,save_iwvls(i)),'.k'); hold on; grid on; 
%     plot(aod1.t((aod1.Alt>5e3)),aod1.tau_aero((aod1.Alt>5e3),save_iwvls(i))-aod2.tau_aero((aod1.Alt>5e3),save_iwvls(i)),'or'); hold on; grid on; 
% %     plot(-0.1:0.1:1,-0.1:0.1:1,'--r')
%     dynamicDateTicks
%     title([num2str(save_wvls(i)),'nm'])    
% end
% 
% %plot histograms of the differences between the two, for high-altitude, for
% %each of the archiving wavelengths
% figure; 
% figidx=0;
% for i=1:length(save_iwvls)
%     figidx=figidx+1;
%     if figidx>12; figidx=1; figure; end
%     subplot(3,4,figidx); 
%     hist(aod1.tau_aero((aod1.Alt>5e3),save_iwvls(i))-aod2.tau_aero((aod1.Alt>5e3),save_iwvls(i)),-5e-3:1e-3:0.01); hold on; grid on; 
%     title([num2str(save_wvls(i)),'nm'])
%     
% end
% 
% figure; 
% figidx=0;
% for i=1:length(save_iwvls)
%     figidx=figidx+1;
%     if figidx>24; figidx=1; figure; end
%     subplot(3,8,figidx); 
% %     plot(aod1.tau_aero(:,save_iwvls(i)),aod2.tau_aero(:,save_iwvls(i)),'.k'); hold on; grid on; 
%     plot(aod1.tau_aero((aod1.Alt>5e3),save_iwvls(i)),aod2.tau_aero((aod1.Alt>5e3),save_iwvls(i)),'.k'); hold on; grid on; axis square;
%     plot(-0.1:0.1:1,-0.1:0.1:1,'--r')
%     title([num2str(save_wvls(i)),'nm, >5km'])
%     xlim([-0.05 0.2]); ylim([-0.05 0.2])
%     xlabel('roof only c0'); ylabel('roof + in field avg c0')
% end