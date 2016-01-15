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
% filelist = {'20160109_VIS_C0_refined_Langley_MLO','20160109_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160110_VIS_C0_refined_Langley_MLO','20160110_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160111_VIS_C0_refined_Langley_MLO','20160111_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160112_VIS_C0_refined_Langley_MLO','20160112_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160113_VIS_C0_refined_Langley_MLO','20160113_VIS_C0_modified_Langley_MLO'};
% filelist = {'20160114_VIS_C0_refined_Langley_MLO','20160114_VIS_C0_modified_Langley_MLO'};

% prepare for plotting
colorlist_ = varycolor(90);
colorlist  = colorlist_(90:-10:1,:);

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
                    xlim([300 1000]);
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
        


