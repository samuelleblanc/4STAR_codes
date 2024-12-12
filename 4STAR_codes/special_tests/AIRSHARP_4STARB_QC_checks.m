%AIRSHARP_4STARB_QC_checks.m: exactly what it sounds like... not the most
%curated but these are codes i ran

fltdates={'1007','1008','1012','1018','1019','1020'};
for fltnum=1:length(fltdates)
%     % ncdisp('4STARB-AOD_TwinOtter_20241008_RA.nc')
%     % ncload2('4STARB-AOD_TwinOtter_20241008_RA.nc')
%     eval(['ncdisp(''4STARB-AOD_TwinOtter_2024',fltdates{fltnum},'_RA.nc'')'])
    %eval(['ncload2(''4STARB-AOD_TwinOtter_2024',fltdates{fltnum},'_RA.nc'')'])
    eval(['ncload2(''AirSHARP-4STARB-AOD_AirSHARP-TO_2024',fltdates{fltnum},'_R0.nc'')'])
    matlab_day=datenum(2024,0,day_of_year,0,0,0);
    figure; plot(UTC_time,GPS_Alt,'.-k')
    title(['flight ',datestr(matlab_day(1)),'-',datestr(matlab_day(end))])
%     figure; 
    subplot(2,3,1);
    plot(matlab_day,GPS_Alt,'.-k'); dynamicDateTicks
    title(['flight ',datestr(matlab_day(1)),'-',datestr(matlab_day(end))])

    matlab_day=datenum(2024,0,day_of_year,0,0,0);
    disp(fltdates{fltnum})
    

%     figure; plot(matlab_day,GPS_Alt,'.-k'); dynamicDateTicks
%     figure; plot(matlab_day,AOD(236,:),'.-k'); dynamicDateTicks
    AOD_QC=NaN*ones(size(AOD)); for i=1:size(AOD,2); for j=1:size(AOD,1); if qual_flag(i)==0; AOD_QC(j,i)=AOD(j,i); end; end; end;
%     figure; 
    subplot(2,3,2);
    plot(matlab_day,AOD(236,:),'.-k'); dynamicDateTicks
    hold on; plot(matlab_day,AOD_QC(236,:),'og'); dynamicDateTicks
    ylabel([num2str(wavelength(236)),' nm']); grid on
    title(['flight ',datestr(matlab_day(1)),' to ',datestr(matlab_day(end))])
    ylim([0 0.5])
% %     ncdisp('4STARB-AOD_TwinOtter_20241008_RA.nc')
% %     figure; hist(AOD_uncertainty(236,:)',0:0.001:8)
%     figure; hist(AOD_uncertainty(236,:),0:0.01:8)
%     ylabel([num2str(wavelength(236)),' nm']); grid on
%     title(['flight ',datestr(matlab_day(1)),' to ',datestr(matlab_day(end))])
    AOD_uncQC=NaN*ones(size(AOD)); for i=1:size(AOD,2); for j=1:size(AOD,1); if qual_flag(i)==0; AOD_uncQC(j,i)=AOD_uncertainty(j,i); end; end; end;
%     figure; plot(matlab_day,AOD_uncQC(236,:),'o-g'); dynamicDateTicks
%     figure; 
    subplot(2,3,3);
    plot(matlab_day,AOD_uncertainty(236,:),'.-k'); dynamicDateTicks
    hold on; plot(matlab_day,AOD_uncQC(236,:),'o-g'); dynamicDateTicks
    ylabel([num2str(wavelength(236)),' nm']); grid on
    title(['uncertainties, flight ',datestr(matlab_day(1)),' to ',datestr(matlab_day(end))])
    ylim([0 0.5])
    wavelength(236);
%     figure;     
    subplot(2,3,4);
    plot(AOD_QC,AOD_uncQC,'.k')
    xlabel('AOD'); ylabel('AOD uncertainty');     title(['flight ',datestr(matlab_day(1),'yyyymmdd')])


    wl_subset=([56,176,198,236,429,510]);%,600]); %some subset of the wavelengths which are ones we usually archive. jk, these used to be the ones we usually archive, in this new version we have fewer wavelengths so everything got shifted. sorry!
    wavelength(wl_subset);
%     figure; plot(AOD_QC(wl_subset,:),AOD_uncQC(wl_subset,:),'o')
%     figure; 
    subplot(2,3,5);
    plot(AOD_QC(wl_subset,:)',AOD_uncQC(wl_subset,:)','o')
    legend(num2str(wavelength(wl_subset)))
    xlabel('QC''d AOD'); ylabel('QC''d AOD uncertainty')
    axis square; grid on;
    title(['AODs, AirSHARP ',datestr(matlab_day(1),'yyyymmdd')])
    grid on
    ylim([0 0.2])

    %all wavelengths, one timestep, picked pretty much at random
%     figure; 
    subplot(2,3,6);
    exwl=9000; %example wavelength, picked somewhat at random to just show a spectrum. change this number if it is missing values i.e. bad data for this random timestep
    plot(wavelength,AOD_QC(:,exwl),'.-k')
    title(datestr(matlab_day(exwl)))
    grid on
    hold on; for i=1:6; plot(wavelength(wl_subset(i))*ones(size(-0.7:0.1:0.2)),-0.7:0.1:0.2,'--b'); end
    ylim([-0.05 0.2])

    figure; for i=1:6; subplot(2,3,i); plot(matlab_day,AOD(wl_subset((i)),:),'.-k'); dynamicDateTicks
    hold on; plot(matlab_day,AOD_QC(wl_subset((i)),:),'og'); title(['QC''d AOD, ',num2str(wavelength(wl_subset(i))),'nm, ',datestr(matlab_day(1),'yyyymmdd')]); grid on; end
end