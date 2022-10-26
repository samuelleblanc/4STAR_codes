% aeronet filter measurements for 4STAR

fp = '\\cloudgazer\data_sunsat\'; %getnamedpath('sunsat');
instrument_name = '4STARB';

daystr = '20221020';
s = load([fp 'rooftop' filesep 'Fall_2022' filesep 'data_processed' filesep 'starsuns' filesep instrument_name '_' daystr 'starsun.mat']);


if strcmp(daystr,'20221007')
filters = {'1020 nm #1, #046'; 
           '1020 nm #2, #045';
           '675 nm, #3970';
           '870 nm, #076';
           '1640 nm, #2605';
           '380 nm, #4855';
           '2200 nm, #NA';
           '1240 nm, #3008';
           '500 nm, #4481';close 
           '440 nm, #3363';
           '340 nm, #3682'           };
if strcmp(instrument_name,'4STARB')
    filter_times = [[datenum(2022,10,7,20,55,30), datenum(2022,10,7,20,57,0)],
                    [datenum(2022,10,7,20,59,30), datenum(2022,10,7,21,1,30)],
                    [datenum(2022,10,7,21,3,0), datenum(2022,10,7,21,3,20)],
                    [datenum(2022,10,7,21,5,30), datenum(2022,10,7,21,7,30)],
                    [datenum(2022,10,7,21,8,45), datenum(2022,10,7,21,10,15)],
                    [datenum(2022,10,7,21,12,30), datenum(2022,10,7,21,14,30)],
                    [datenum(2022,10,7,21,16,0), datenum(2022,10,7,21,18,0)],
                    [datenum(2022,10,7,21,20,45), datenum(2022,10,7,21,22,15)],
                    [datenum(2022,10,7,21,24,45), datenum(2022,10,7,21,26,15)],
                    [datenum(2022,10,7,21,28,0), datenum(2022,10,7,21,29,0)],
                    [datenum(2022,10,7,21,31,45), datenum(2022,10,7,21,33,15)]];
    ref_time = [datenum(2022,10,7,20,50,30), datenum(2022,10,7,20,52,30)];
else
    filters = {'1020 nm, #046'; 
           '675 nm, #3970';
           '870 nm, #076';
           '1640 nm, #2605';
           '380 nm, #4855';
           '2200 nm, #3102';
           '1240 nm, #3008';
           '500 nm, #4481';
           '440 nm, #3363';
           '340 nm, #3682'           };
        filter_times = [[datenum(2022,10,7,18,31,00), datenum(2022,10,7,18,34,0)],
                    [datenum(2022,10,7,18,37,00), datenum(2022,10,7,18,39,00)],
                    [datenum(2022,10,7,18,40,30), datenum(2022,10,7,18,42,20)],
                    [datenum(2022,10,7,18,44,30), datenum(2022,10,7,18,47,30)],
                    [datenum(2022,10,7,18,48,45), datenum(2022,10,7,18,51,15)],
                    [datenum(2022,10,7,18,53,0), datenum(2022,10,7,18,54,0)],
                    [datenum(2022,10,7,18,57,0), datenum(2022,10,7,18,58,0)],
                    [datenum(2022,10,7,19,0,45), datenum(2022,10,7,19,4,15)],
                    [datenum(2022,10,7,19,7,0), datenum(2022,10,7,19,9,0)],
                    [datenum(2022,10,7,19,11,45), datenum(2022,10,7,19,13,15)]];
    ref_time = [datenum(2022,10,7,19,17,30), datenum(2022,10,7,19,20,30)];
end
elseif strcmp(daystr,'20221020')
    if strcmp(instrument_name,'4STARB')
        filters = {'340 nm, #3682';
            '440 nm, #3363';
            '500 nm, #4481';
            '870 nm, #076';
            '1020 nm, #045'; 
            '1240 nm, #3008'};
        filter_times = [[datenum(2022,10,20,19,42,55), datenum(2022,10,20,19,49,0)],
                    [datenum(2022,10,20,19,50,20), datenum(2022,10,20,19,52,10)],
                    [datenum(2022,10,20,19,53,20), datenum(2022,10,20,19,54,45)],
                    [datenum(2022,10,20,19,56,10), datenum(2022,10,20,19,58,30)],
                    [datenum(2022,10,20,19,59,15), datenum(2022,10,20,20,2,5)],
                    [datenum(2022,10,20,20,3,15), datenum(2022,10,20,20,5,15)]];
        ref_time = [datenum(2022,10,20,19,49,50), datenum(2022,10,20,19,50,5)];
    else
        error('This day was only tested with 4STARB')
    end
        
end

i_ref = s.t>ref_time(1) & s.t<ref_time(2);
ref_spec = nanmean(s.rate(i_ref,:));
m_ref = nanmean(s.m_aero(i_ref));
means_rate = [];

for i=1:length(filters)
   figure;
   set(gcf,'Position',[100 200 1000 800])
   ax1 = subplot(4,1,1);
   ax2 = subplot(4,1,2);
   ax3 = subplot(4,1,3);
   ax4 = subplot(4,1,4);
   linkaxes([ax1,ax2,ax3,ax4],'x');
   i_filts = s.t>filter_times(i,1) & s.t<filter_times(i,2);
   m_filt = nanmean(s.m_aero(i_filts));
   
   %rate_sp = s.rate(i_filts,:);
   
   % ni = length(s.t(i_filts));
   % cm=hsv(ni);
   % set(ax1, 'ColorOrder', cm, 'NextPlot', 'replacechildren') 
   
   plot(ax1,s.w.*1000.0,s.rate(i_filts,:));
   ylabel(ax1,'Rate [#/ms]')
   
   title(ax1,[instrument_name ' - ' daystr ' with AERONET filter at:' filters{i}]);
  %  labels = strread(num2str(s.visTint(i_filts),'%3.0f'),'%s');
  %  colormap(cm);
  %  lcolorbar(labels','TitleString','Vis Integration Time [ms]','fontweight','bold'); 
    
   plot(ax2,s.w.*1000.0,s.tau_aero_noscreening(i_filts,:));
   ylabel(ax2,'Optical Depth');
   set(ax2,'YScale','log');
   ylim(ax2,[0.0001,10]);
   
   [nul,i550] = min(abs(s.w-0.55));
   [nul,i750] = min(abs(s.w-0.75));
   rate_mean = nanmean(s.rate(i_filts,:));
   [max_val,imax] = max(rate_mean);
   means_rate = [means_rate;abs(rate_mean/rate_mean(i550))];
   
   pp = plot(ax3,s.w.*1000.0,s.rate(i_filts,:)/rate_mean(i550),'.'); 
   hold(ax3,'on');
   pm = plot(ax3,s.w.*1000.0,rate_mean/rate_mean(i550),'-k');
   
   pv = plot(ax3,[s.w(i550) s.w(i550)].*1000.0,[-0.1,5],'--','color',[0.5,0.5,0.5]);
   pa = plot(ax3,[s.w(imax) s.w(imax)].*1000.0,[-0.1,5],':r');
   
   legend([pm,pv,pa],'average rate','normalized wvl',['Max wvl: ' num2str(s.w(imax).*1000.0,'%4.1f\n') ' nm, Peak to 550 nm ratio: ' num2str(abs(max_val/rate_mean(i550)),'%9.1f\n')])
   ylabel(ax3,{'Rate filter'; 'Nomalized at 550 nm'});
   ylim(ax3,[-0.2,4]);
   grid(ax3);
   %set(ax3,'YScale','log');
   
   plot(ax4,s.w.*1000.0,s.rate(i_filts,:)/rate_mean(i750),'.');
   hold(ax4,'on');
   plot(ax4,s.w.*1000.0,rate_mean/rate_mean(i750)   ,'-k');
   
   plot(ax4,[s.w(i750) s.w(i750)].*1000.0,[-0.1,5],'--','color',[0.5,0.5,0.5]);
   ylabel(ax4,{'Rate filter'; 'Nomalized at 750 nm'});
   ylim(ax4,[-0.5,4]);
   if strcmp(instrument_name,'4STARB')
      ylim(ax4,[-15,40]);
   end
   grid(ax4);
   
   xlabel(ax4,'Wavelength [nm]');
   xlim(ax4,[200,1700]);
   save_fig(gcf,[fp 'rooftop' filesep 'Fall_2022' filesep 'plots' filesep instrument_name '_' daystr filesep instrument_name '_filter_' filters{i}] ,0);
end

figure; 
plot(s.w.*1000.0,means_rate,'-');
legend(filters);
grid;
ylabel('Average Rate normalized to 550 nm');
xlabel('Wavelength [nm]');
xlim([200,1700]);
ylim([0.001,100000]);
set(gca,'YScale','log');
title([instrument_name ' - ' daystr ' with AERONET filters, Normalized rate']);
save_fig(gcf,[fp 'rooftop' filesep 'Fall_2022' filesep 'plots' filesep instrument_name '_' daystr filesep instrument_name '_allfilters'] ,0);




 