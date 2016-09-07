function plotLangleyCompare(filelist,band)
%---------------------------------------------
% routine to plot c0 values from different dates/mod (i.e. refined vs.
% modified)
% for both VIS/NIR
% filelist is a cell array of filenames
% mod is 'refined' or 'modified' langley
% band is 'vis' or 'nir' or 'wv'
%--------------------------------------------------------------------------

% Michal Segal-Rozenhaimer, 2016-01-09, MLO

% upload files and read
%----------------------

% filelist = {'20160109_VIS_C0_refined_Langley_MLO','20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened'};
% filelist = {'20160109_NIR_C0_refined_Langley_MLO','20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened'};
% filelist = {'20160109_VIS_C0_refined_Langley_MLO','20160109_VIS_C0_modified_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO'};
% filelist = {'20160110_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_modified_Langley_MLO'};
% filelist = {'20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened_3correctO3','20151104_VIS_C0_modified_Langley_at_WFF_Ground_screened_3correctO3'};

% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_modified_Langley_on_C130_screened','20160109_VIS_C0_modified_Langley_MLO','20160110_VIS_C0_modified_Langley_MLO','20160111_VIS_C0_modified_Langley_MLO','20160112_VIS_C0_modified_Langley_MLO','20160113_VIS_C0_modified_Langley_MLO','20160114_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO'};
% filelist = {'20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO','20160117_VIS_C0_refined_Langley_MLOalldata','20160117_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO','20160117_NIR_C0_refined_Langley_MLOalldata','20160117_NIR_C0_refined_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO','20160117_VIS_C0_refined_Langley_MLOalldata','20160117_VIS_C0_refined_Langley_MLO','20160118_VIS_C0_refined_Langley_MLO_alldata','20160...(line truncated)...
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO','20160117_NIR_C0_refined_Langley_MLOalldata','20160117_NIR_C0_refined_Langley_MLO','20160117_NIR_C0_refined_Langley_MLO_alldata','20160...(line truncated)...
% these are "optimized" for best FORJ locations
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO','20160117_VIS_C0_refined_Langley_MLOalldata','20160117_VIS_C0_refined_Langley_MLO','20160118_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO','20160117_NIR_C0_refined_Langley_MLOalldata','20160117_NIR_C0_refined_Langley_MLO','20160118_NIR_C0_refined_Langley_MLO'};

% these are NOT "optimized" for best FORJ locations
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO_original','20160110_VIS_C0_refined_Langley_MLO_original','20160111_VIS_C0_refined_Langley_MLO_original','20160112_VIS_C0_refined_Langley_MLO_original','20160113_VIS_C0_refined_Langley_MLO_original','20160114_VIS_C0_refined_Langley_MLO_original','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO','20160117_VIS_C0_refined_Langley_MLOalldata','20160117_VIS_C0_refined_Langley_MLO...(line truncated)...
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO_original','20160110_NIR_C0_refined_Langley_MLO_original','20160111_NIR_C0_refined_Langley_MLO_original','20160112_NIR_C0_refined_Langley_MLO_original','20160113_NIR_C0_refined_Langley_MLO_original','20160114_NIR_C0_refined_Langley_MLO_original','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO','20160117_NIR_C0_refined_Langley_MLOalldata','20160117_NIR_C0_refined_Langley_MLO...(line truncated)...


% filelist = {'20160109_VIS_C0_refined_Langley_MLO','20160109_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160110_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160111_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160112_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160113_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160114_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160115_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160116_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160117_VIS_C0_refined_Langley_MLO','20160117_VIS_C0_modified_Langley_MLO'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened','20150916_VIS_C0_compared_with_AATS_at_Ames'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20151104_NIR_C0_refined_Langley_at_WFF_Ground_screened','20150916_NIR_C0_compared_with_AATS_at_Ames'};
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened','20150916_VIS_C0_compared_with_AATS_at_Ames','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20151104_NIR_C0_refined_Langley_at_WFF_Ground_screened','20150916_NIR_C0_compared_with_AATS_at_Ames','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO'};

% order in ordinal date
% filelist = {'20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20130708_VIS_C0_modified_Langley_at_MLO_screened_2std_averagethru20130711','20130708_VIS_C0_refined_Langley_at_MLO_screened_averagethru20130712_scaled3p20141013','20150916_VIS_C0_compared_with_AATS_at_Ames','20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO'};
% filelist = {'20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20130708_NIR_C0_modified_Langley_at_MLO_screened_2std_averagethru20130711','20130708_NIR_C0_refined_Langley_at_MLO_screened_averagethru20130712_scaled3p20141013','20150916_NIR_C0_compared_with_AATS_at_Ames','20151104_NIR_C0_refined_Langley_at_WFF_Ground_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO'};

% 20130708_NIR_C0_refined_Langley_at_MLO_screened_3.0x_averagethru20130712_scaled3p20141013

% compare MLO 2016 and WFF c0
% filelist = {'20160109_VIS_C0_refined_Langley_at_MLO_screened_2std_averagethru20160113','20160109_VIS_C0_refined_Langley_at_MLO_screened_2std_averagethru20160113_wFORJcorr','20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened_3correctO3'};
% filelist = {'20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened_3correctO3','20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_at_MLO_screened_2std_averagethru20160113','20160426_VIS_C0_refined_Langley_korusaq_transit1_v1'};
% filelist = {'20151104_NIR_C0_refined_Langley_at_WFF_Ground_screened_3correctO3','20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_at_MLO_screened_2std_averagethru20160113','20160426_NIR_C0_refined_Langley_korusaq_transit1_v1'};
% filelist = {'20160426_VIS_C0_refined_Langley_korusaq_transit1_v1','20160426_VIS_C0_modified_Langley_korusaq_transit1_v1'};
% filelist = {'20160426_VIS_C0_refined_Langley_korusaq_transit1_v1','20160426_VIS_C0_refined_Langley_korusaq_transit1_v2'};
% filelist = {'20160426_VIS_C0_refined_Langley_korusaq_transit1_v2','20160109_VIS_C0_refined_Langley_at_MLO_screened_2std_averagethru20160113'};

% compare the MLO June 2016 and ORACLES c0 from WFF ground
filelist = {'20160707_NIR_C0_Langley_MLO_June2016_mean','20160823_NIR_C0_refined_Langley_ORACLES_WFF_gnd','20160825_NIR_C0_refined_Langley_ORACLES_transit2'}
band = 'nir'

% prepare for plotting
colorlist_ = varycolor(140);
colorlist  = colorlist_(140:-10:1,:);

for i=1:length(filelist)
    
    tmp = importdata(strcat(starpaths,filelist{:,i},'.dat'));
    wln = tmp.data(:,2);
    lang.(strcat('c0_',filelist{:,i})) = tmp.data(:,3);
    
end

% plot c0 comparison
%--------------------
    
        % overlay
        figure(1);
        for i=1:length(filelist)
                plot(wln,lang.(strcat('c0_',filelist{:,i})),'-','color',colorlist(i,:),'linewidth',2);hold on;
                xlabel('wavelength');
                ylabel('c0 count rate');
                title('Langley comparison');
                
                if strcmp(band,'vis')
                    xlim([300 1000]);
                elseif strcmp(band,'nir')
                    xlim([1000 1700]);
                else
                    xlim([700 1000]); % this is for modified Langley, water vapor region
                end
        end
        
        legend(filelist);
        fi=[strcat(starpaths, 'figs\', filelist{:,1}, 'compare_with_', filelist{:,end})];
        save_fig(1,fi,false);
        
        % compare to 1st

        figure(2);
        
        for i=1:length(filelist)
                sub = 100*((lang.(strcat('c0_',filelist{:,i})) - lang.(strcat('c0_',filelist{:,1})))./lang.(strcat('c0_',filelist{:,1})));
                plot(wln,sub,'-','color',colorlist(i,:),'linewidth',2);hold on;
                xlabel('wavelength');
                ylabel(['c0 difference relative to ',filelist{:,1},' [%]']);
                title('Langley comparison');
                
                if strcmp(band,'vis')
                    xlim([350 1000]);
                elseif strcmp(band,'nir')
                    xlim([1000 1700]);
                else
                    xlim([700 1000]); % this is for modified Langley, water vapor region
                end
        end
        
        legend(filelist);
        fi=[strcat(starpaths, 'figs\', filelist{:,end}, 'compare_with_', filelist{:,1})];
        save_fig(2,fi,false);
        
         % plot average and std of all Langley's chosen
        
            %initialize all c0 array
            c0cat = [];
            
            for i=2:length(filelist)
                    c0cat = [c0cat; (lang.(strcat('c0_',filelist{:,1})))']; 
            end
            
            figure(3);

            plot(wln,nanmean(c0cat),'-','color',[0.8 0.8 0.8],'linewidth',2);hold on;
            plot(wln,nanmean(c0cat)+nanstd(c0cat),'--','color',[0.8 0.8 0.8],'linewidth',2);hold on;
            plot(wln,nanmean(c0cat)-nanstd(c0cat),'--','color',[0.8 0.8 0.8],'linewidth',2);hold on;
            legend('mean c0','std c0');
                    xlabel('wavelength');
                    ylabel(['c0 (rates)']);
                    title([strcat(starpaths, 'figs\', 'avg_and_std_',filelist{:,2}, 'through_', filelist{:,end})]);

                    if strcmp(band,'vis')
                        xlim([300 1000]);
                        ylim([0 620]);
                    elseif strcmp(band,'nir')
                        xlim([1000 1700]);
                         ylim([0 12]);
                    else
                        xlim([850 1000]); % this is for modified Langley, water vapor region
                        ylim([0 200]);
                    end

            fi=[strcat(starpaths, 'figs\', 'avg_and_std_',filelist{:,2}, 'through_', filelist{:,end})];
            save_fig(3,fi,false);
            
            % signal strength with time
            
            %wln = [411 425 500 880 1020 1050 1650];
            if strcmp(band,'vis')
                ind = [297 314 407 888];
                str = 'vis_';
                wlnstr = {'411 nm','425 nm','500 nm','880 nm'};
            elseif strcmp(band,'nir')
                ind = [40 57 467];% nir
                str = 'nir_';
                wlnstr = {'1020 nm','1050 nm','1650 nm'};
            end
            
            marksize = [4 6 8 10];
            legendall={};
            % order in ordinal date
            % filelist = {'20150916_VIS_C0_compared_with_AATS_at_Ames','20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened','20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened','20160109_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_refined_Langley_MLO','20160115_VIS_C0_refined_Langley_MLO','20160116_VIS_C0_refined_Langley_MLO'};
            % filelist = {'20150916_NIR_C0_compared_with_AATS_at_Ames','20151104_NIR_C0_refined_Langley_at_WFF_Ground_screened','20151118_NIR_C0_sunrise_refined_Langley_on_C130_screened','20160109_NIR_C0_refined_Langley_MLO','20160110_NIR_C0_refined_Langley_MLO','20160111_NIR_C0_refined_Langley_MLO','20160112_NIR_C0_refined_Langley_MLO','20160113_NIR_C0_refined_Langley_MLO','20160114_NIR_C0_refined_Langley_MLO','20160115_NIR_C0_refined_Langley_MLO','20160116_NIR_C0_refined_Langley_MLO'};

            figure(4);
            for ii=1:length(ind)
                for i=1:length(filelist)
                        plot(i,lang.(strcat('c0_',filelist{:,i}))(ind(ii)),'o','color',colorlist(i,:),'markersize',marksize(ii));hold on;
                end
                legendall = {legendall{:} wlnstr{ii}};
            end
            xlabel('measurement #');
            ylabel('c0 value');

            legend(legendall{:});
            fi=[strcat(starpaths, 'figs\', filelist{:,1}, str,'_variability_', filelist{:,end})];
            save_fig(4,fi,false);
        

