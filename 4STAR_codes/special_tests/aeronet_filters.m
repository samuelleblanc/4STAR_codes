% aeronet filter measurements for 4STAR

fp = '\\cloudgazer\data_sunsat\'; %getnamedpath('sunsat');
instrument_name = '4STAR';
s = load([fp 'rooftop\Fall_2022\data_processed\starsuns\' instrument_name '_20221007starsun.mat']);


filters = {'1020 nm #1, #046'; 
           '1020 nm #2, #045';
           '675 nm, #3970';
           '870 nm, #076';
           '1640 nm, #2605';
           '380 nm, #4855';
           '2200 nm, #NA';
           '1240 nm, #3008';
           '500 nm, #4481';
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



i_ref = s.t>ref_time(1) & s.t<ref_time(2);
ref_spec = nanmean(s.rate(i_ref,:));
m_ref = nanmean(s.m_aero(i_ref));

for i=1:length(filters)
   figure;
   ax1 = subplot(3,1,1);
   ax2 = subplot(3,1,2);
   ax3 = subplot(3,1,3);
   linkaxes([ax1,ax2,ax3],'x');
   i_filts = s.t>filter_times(i,1) & s.t<filter_times(i,2);
   m_filt = nanmean(s.m_aero(i_filts));
   
   plot(ax1,s.w.*1000.0,s.rate(i_filts,:));
   ylabel(ax1,'Rate [#/ms]')
   
   title(ax1,[instrument_name ' with AERONET filter at:' filters{i}]);
   
   plot(ax2,s.w.*1000.0,s.tau_aero_noscreening(i_filts,:));
   ylabel(ax2,'Optical Depth');
   set(ax2,'YScale','log');
   ylim(ax2,[0.0001,10]);
   
   plot(ax3,s.w.*1000.0,s.rate(i_filts,:) - ref_spec.*s.m_aero(i_filts)./m_ref,'.');
   ylabel(ax3,'rate_filter /  rate_ref');
   ylim(ax3,[0.00001,10000]);
   set(ax3,'YScale','log');
   xlabel(ax3,'Wavelength [nm]');
   save_fig(gcf,[fp 'rooftop\Fall_2022\plots\' instrument_name '_20221007\' instrument_name '_filter_' filters{i}] ,0);
end
 