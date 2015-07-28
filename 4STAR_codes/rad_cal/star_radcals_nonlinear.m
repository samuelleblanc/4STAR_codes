%% PURPOSE:
%   Generate the nonlinear analysis from multiple radiance calibrations
%   taken with different large intgrateiong sphere lamp number and settings
%
% CALLING SEQUENCE:
%   star_radcals_nonlinear
%
% INPUT:
%   none
% 
% OUTPUT:
%  - resp_corr.mat save file with data from nonlinear analysis
%  - plots of welldepth vs. radiance or counts
%
% DEPENDENCIES:
%  - startup_plotting.m
%  - save_fig.m
%  - version_set.m : for version control of this file
%  - load_calrad.m : for loading radiance calibration files
%  - meannonan.m : for calculating mean value without nans
%  - makepoly_nresp.m : to build a polynomial of the response function
%  - recolor.m : to recolor the lines
%
% NEEDED FILES:
%  - radiance calibration files
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, date unknown, 2014
%          - ported from sasze_radcals_nonlinear_SL.m
% Modified (v1.1): Samuel LeBlanc, NASA Ames, 2014-11-12
%          - changed startup to startup_plotting
% -------------------------------------------------------------------------

%% Start of function
function star_radcals_nonlinear
version_set('1.1');
startup_plotting;
clear
close all

asktopause=false;
[cals pname date corstr] = load_calrad();

%[pname, fname, ext] = fileparts(infile); pname = [pname, filesep];
fields = fieldnames(cals);
for f = length(fields):-1:1;
    if ~isempty(strfind(fields{f},'Lamps_'))
        Lamps(f) = sscanf(fields{f}(strfind(fields{f},'Lamps_')+length('Lamps_'):end),'%f');
    end
end
Lamps = unique(Lamps); 
% Loop through each lamp combination and traverse the structure to pull out
% well depth WD and responsivity to populate an array with integration time
% and wavelength as dimensions.
% Within the lamp combination loop, for each pixel (nm) compute the mean 
% well depth averaged over all integration times, and normalize the 
% responsivities versus this mean to yield nresp
% the normalized respositivities are normalized to their value at 0.5 well
% depth.
WD_set_point=0.4
for LL = Lamps
    lamp_str =['Lamps_',num2str(LL)];
    for spc = {'vis','nir'}
        clear WD resp pin_val
        spc = char(spc);
        cal = cals.(['Lamps_',sprintf('%g',LL)]).(char(spc));
        for t = length(cal.t_int_ms):-1:1
            ms_str = strrep(sprintf('%g',cal.t_int_ms(t)),'.','p');
            WD(t,:) = cal.(['welldepth_',ms_str,'_ms']);
            resp(t,:) = cal.(['resp_',ms_str,'_ms']);
        end
        nm = cal.lambda;
        for nm_ = length(nm):-1:1
            [wells, ij] = unique(WD(:,nm_));
            meanWD = meannonan(wells);
            nonlin.(lamp_str).(spc).mean_WD(nm_) = meanWD;
            WD_set_point=meanWD;
            if length(ij)>2
                [P,S] =polyfit(wells, resp(ij,nm_),2);
                pin_val = polyval(P,WD_set_point,S);
                %             hiss_rad.STAR_VIS.(['lamps_',LL]).pin_val(nm_) = interp1(wells, hiss_rad.STAR_VIS.(['lamps_',LL]).resp(ij,nm_),.45,'linear');
            else
                pin_val =NaN;
            end
            nonlin.(lamp_str).(spc).wells(:,nm_) = WD(:,nm_);
            nonlin.(lamp_str).(spc).pin_val(nm_) = pin_val;
            nonlin.(lamp_str).(spc).nresp(:,nm_) = resp(:,nm_)./pin_val;
            nonlin.(lamp_str).(spc).resp(:,nm_)  = resp(:,nm_);
            %         disp(nm_)
        end
    end
end
%
% make new analysis based on the nonlin structure
pols=makepoly_nresp(nonlin);
save_fig(6,[pname,filesep,date, 'welldepth_nresp_polyfit' corstr],asktopause);

%% plot the normalized responsitivity and non-normalized responsitivity for
% a single wavelength
disp('plotting at single wavelength vis');
nm_ = 555;
figure(1); 
plot(nonlin.Lamps_1.vis.wells(:,nm_), nonlin.Lamps_1.vis.nresp(:,nm_),'o-',...
    nonlin.Lamps_2.vis.wells(:,nm_), nonlin.Lamps_2.vis.nresp(:,nm_),'o-',...
    nonlin.Lamps_3.vis.wells(:,nm_), nonlin.Lamps_3.vis.nresp(:,nm_),'o-',...
    nonlin.Lamps_6.vis.wells(:,nm_), nonlin.Lamps_6.vis.nresp(:,nm_),'o-',...
    nonlin.Lamps_9.vis.wells(:,nm_), nonlin.Lamps_9.vis.nresp(:,nm_),'o-',...
    nonlin.Lamps_12.vis.wells(:,nm_), nonlin.Lamps_12.vis.nresp(:,nm_),'o-',...
    pols.WD_reconstruct, pols.vis.nresp_reconstruct(:,nm_),'--');
legend('1 lamp','2 lamps','3 lamps','6 lamps','9 lamps','12 lamps','Fit');
xlabel('well depth')
ylabel('normalized responsivity')
title(['normalized responsivity vs well depth for vis pixel ',num2str(nm_)])
grid on;
save_fig(1,[pname,filesep,date, 'welldepth_nresp_vis_',num2str(nm_),corstr],asktopause);

%
figure(5); plot(nonlin.Lamps_1.vis.wells(:,nm_), nonlin.Lamps_1.vis.resp(:,nm_),'o-',...
    nonlin.Lamps_2.vis.wells(:,nm_), nonlin.Lamps_2.vis.resp(:,nm_),'o-',...
    nonlin.Lamps_3.vis.wells(:,nm_), nonlin.Lamps_3.vis.resp(:,nm_),'o-',...
    nonlin.Lamps_6.vis.wells(:,nm_), nonlin.Lamps_6.vis.resp(:,nm_),'o-',...
    nonlin.Lamps_9.vis.wells(:,nm_), nonlin.Lamps_9.vis.resp(:,nm_),'o-',...
    nonlin.Lamps_12.vis.wells(:,nm_), nonlin.Lamps_12.vis.resp(:,nm_),'o-');
legend('1 lamp','2 lamps','3 lamps','6 lamps','9 lamps','12 lamps');
xlabel('Well Depth')
ylabel('Responsivity (counts/(Wm^-2sr^-1nm^-1)')
title(['Responsivity vs well depth for vis pixel ',num2str(nm_)])
grid on;
save_fig(5,[pname,filesep,date, 'welldepth_resp_vis_',num2str(nm_),corstr],asktopause);

%% now to do the same for nir spectrometer
% plot the normalized responsitivity and non-normalized responsitivity for
% a single wavelength
disp('plottng at single wavelength nir')
nm_ = 70;
figure(2); 
plot(nonlin.Lamps_1.nir.wells(:,nm_), nonlin.Lamps_1.nir.nresp(:,nm_),'o-',...
    nonlin.Lamps_2.nir.wells(:,nm_), nonlin.Lamps_2.nir.nresp(:,nm_),'o-',...
    nonlin.Lamps_3.nir.wells(:,nm_), nonlin.Lamps_3.nir.nresp(:,nm_),'o-',...
    nonlin.Lamps_6.nir.wells(:,nm_), nonlin.Lamps_6.nir.nresp(:,nm_),'o-',...
    nonlin.Lamps_9.nir.wells(:,nm_), nonlin.Lamps_9.nir.nresp(:,nm_),'o-',...
    nonlin.Lamps_12.nir.wells(:,nm_), nonlin.Lamps_12.nir.nresp(:,nm_),'o-',...
    pols.WD_reconstruct, pols.nir.nresp_reconstruct(:,nm_),'--');
legend('1 lamp','2 lamps','3 lamps','6 lamps','9 lamps','12 lamps','Fit');
xlabel('well depth')
ylabel('normalized responsivity')
title(['normalized responsivity vs well depth for nir pixel ',num2str(nm_)])
grid on;
save_fig(2,[pname,filesep,date, 'welldepth_nresp_nir_',num2str(nm_),corstr],asktopause);

%
figure(7); plot(nonlin.Lamps_1.nir.wells(:,nm_), nonlin.Lamps_1.nir.resp(:,nm_),'o-',...
    nonlin.Lamps_2.nir.wells(:,nm_), nonlin.Lamps_2.nir.resp(:,nm_),'o-',...
    nonlin.Lamps_3.nir.wells(:,nm_), nonlin.Lamps_3.nir.resp(:,nm_),'o-',...
    nonlin.Lamps_6.nir.wells(:,nm_), nonlin.Lamps_6.nir.resp(:,nm_),'o-',...
    nonlin.Lamps_9.nir.wells(:,nm_), nonlin.Lamps_9.nir.resp(:,nm_),'o-',...
    nonlin.Lamps_12.nir.wells(:,nm_), nonlin.Lamps_12.nir.resp(:,nm_),'o-');
legend('1 lamp','2 lamps','3 lamps','6 lamps','9 lamps','12 lamps');
xlabel('Well Depth')
ylabel('Responsivity (counts/(Wm^-2sr^-1nm^-1)')
title(['Responsivity vs well depth for nir pixel ',num2str(nm_)])
grid on;
save_fig(7,[pname,filesep,date, 'welldepth_resp_nir_',num2str(nm_),corstr],asktopause);


%% new figures
%stophere
disp('plotting combined figures')

figure; lines = plot(nonlin.Lamps_9.vis.wells, nonlin.Lamps_9.vis.nresp,'-'); recolor(lines,cals.Lamps_3.vis.lambda);


figure; lines = plot(fliplr(nonlin.Lamps_9.vis.wells), fliplr(nonlin.Lamps_9.vis.nresp),'-'); recolor(lines,fliplr(cals.Lamps_3.vis.lambda));
% Now, go back through the various nresp (that were normalized against
% their own value at their mean well depth) to match against nresp
% curves from different lamp combos and pixels. 
figure;
for LL = fliplr(Lamps)
    for spc = {'vis','nir'} ;
        spc = spc{:};
        lamp_str = ['Lamps_',num2str(LL)];
        if strcmp(spc,'vis')
            xl = [400:900];
        else
            xl = [980:1600];
        end
%         xl_i = find(cals.Lamps_1.(spc).lambda>=xl(1)&cals.Lamps_1.(spc).lambda<=xl(2));
        xl_i = unique(interp1(cals.Lamps_1.(spc).lambda, [1:length(cals.Lamps_1.(spc).lambda)],xl,'nearest'));
        WD = nonlin.(lamp_str).(spc).wells(:,xl_i);
        maxWD = max(WD);
        nresp = nonlin.(lamp_str).(spc).nresp(:,xl_i);
        
        [maxs, ij] = sort(maxWD);
        
        for nm_i = length(ij):-1:2
            top_nresp = nresp(:,ij(nm_i)); top_good = ~isNaN(top_nresp); top_nresp = top_nresp(top_good);
            bot_nresp = nresp(:,ij(nm_i-1));  bot_good = ~isNaN(bot_nresp); bot_nresp = bot_nresp(bot_good);
            top_WD = WD(:,ij(nm_i)); top_WD = top_WD(top_good);
            bot_WD = WD(:,ij(nm_i-1)); bot_WD = bot_WD(bot_good);
            if ~isempty(top_WD)&&~isempty(bot_WD)
                len = length(bot_WD);half = max([1,floor(len./2)]);
                top_nr = interp1(top_WD,top_nresp,bot_WD(half:end),'linear');
                len = length(bot_nresp);half = max([1,floor(len./2)]);
                bot_nr = bot_nresp(half:end);
                w = madf(top_nr./bot_nr -1, 3);
                repin = mean(top_nr(w)./bot_nr(w));
            end
            nresp(:,ij(nm_i-1)) = nresp(:,ij(nm_i-1)) .*repin;
        end
        nonlin.(lamp_str).(spc).nresp = NaN(size(nonlin.(lamp_str).(spc).nresp));
        nonlin.(lamp_str).(spc).nresp(:,xl_i) = nresp;
        good = ~isNaN(nonlin.(lamp_str).(spc).nresp);
        nonlin.(lamp_str).(spc).nresp_by_wd = nonlin.(lamp_str).(spc).nresp(good);
        nonlin.(lamp_str).(spc).wd = nonlin.(lamp_str).(spc).wells(good);
        [nonlin.(lamp_str).(spc).wd, ij] = sort(nonlin.(lamp_str).(spc).wd);
        nonlin.(lamp_str).(spc).nresp_by_wd = nonlin.(lamp_str).(spc).nresp_by_wd(ij);
        nonlin.(lamp_str).(spc).wd_smoothed = [min(nonlin.(lamp_str).(spc).wd):0.001:max(nonlin.(lamp_str).(spc).wd)];
            nonlin.(lamp_str).(spc).nresp_smoothed = NaN.*nonlin.(lamp_str).(spc).wd_smoothed;
            
                            
            for dWD = 2:length(nonlin.(lamp_str).(spc).wd_smoothed)
                W = 0.001 + 0.1.*nonlin.(lamp_str).(spc).wd_smoothed(dWD);
                wd_ = nonlin.(lamp_str).(spc).wd>=(nonlin.(lamp_str).(spc).wd_smoothed(dWD -1)-W) & ...
                    nonlin.(lamp_str).(spc).wd<= (nonlin.(lamp_str).(spc).wd_smoothed(dWD)+W);
                [P,S] = polyfit(nonlin.(lamp_str).(spc).wd(wd_), nonlin.(lamp_str).(spc).nresp_by_wd(wd_),2);
                nonlin.(lamp_str).(spc).nresp_smoothed(dWD) = polyval(P,nonlin.(lamp_str).(spc).wd_smoothed(dWD),S);
            end
            wd_ = nonlin.(lamp_str).(spc).wd>=(nonlin.(lamp_str).(spc).wd_smoothed(1)-.001) & ...
                    nonlin.(lamp_str).(spc).wd<= (nonlin.(lamp_str).(spc).wd_smoothed(1)+0.001);
                [P,S] = polyfit(nonlin.(lamp_str).(spc).wd(wd_), nonlin.(lamp_str).(spc).nresp_by_wd(wd_),2);
                nonlin.(lamp_str).(spc).nresp_smoothed(1) = polyval(P,nonlin.(lamp_str).(spc).wd_smoothed(1),S);

        if strcmp(spc,'vis')   
            figure(10); 
        else
            figure(11); 
        end

            lines = plot(nonlin.(lamp_str).(spc).wells(:,xl_i), nresp,'.'); 
            recolor(lines,cals.(lamp_str).(spc).lambda(xl_i));
            hold('on');
            plot(nonlin.(lamp_str).(spc).wd_smoothed, nonlin.(lamp_str).(spc).nresp_smoothed,'k-');

        hold('off')
        xlabel('well depth')
        ylabel('sensitivity')
        title(['Relative sensitivity to well-depth for ',spc, ' with ',lamp_str],'interp','none');   
        
        if strcmp(spc,'vis')   
            save_fig(10,[pname,filesep,date, 'welldepth_sensitivity.',lamp_str,'_',spc,corstr],asktopause);
        else
            save_fig(11,[pname,filesep,date, 'welldepth_sensitivity.',lamp_str,'_',spc,corstr],asktopause);
        end
     end

end

%% build figure with all well depth vs. responses
%first find the average pinned values over each lamp settings

disp('building figures with all responses and well depth')

for l=1:length(nonlin.Lamps_1.vis.pin_val); %for vis
    all.vis.pin_val(l)=nanmean([nonlin.Lamps_1.vis.pin_val(l),nonlin.Lamps_2.vis.pin_val(l),...
                            nonlin.Lamps_3.vis.pin_val(l),nonlin.Lamps_6.vis.pin_val(l),...
                            nonlin.Lamps_9.vis.pin_val(l),nonlin.Lamps_12.vis.pin_val(l)]);
end
for l=1:length(nonlin.Lamps_1.nir.pin_val); %for nir
    all.nir.pin_val(l)=nanmean([nonlin.Lamps_1.nir.pin_val(l),nonlin.Lamps_2.nir.pin_val(l),...
                            nonlin.Lamps_3.nir.pin_val(l),nonlin.Lamps_6.nir.pin_val(l),...
                            nonlin.Lamps_9.nir.pin_val(l),nonlin.Lamps_12.nir.pin_val(l)]);
end

%now for building the well depth array
all.vis.well=[nonlin.Lamps_1.vis.wells(:)',nonlin.Lamps_2.vis.wells(:)',nonlin.Lamps_3.vis.wells(:)',...
          nonlin.Lamps_6.vis.wells(:)',nonlin.Lamps_9.vis.wells(:)',nonlin.Lamps_12.vis.wells(:)'];

all.nir.well=[nonlin.Lamps_1.nir.wells(:)',nonlin.Lamps_2.nir.wells(:)',nonlin.Lamps_3.nir.wells(:)',...
          nonlin.Lamps_6.nir.wells(:)',nonlin.Lamps_9.nir.wells(:)',nonlin.Lamps_12.nir.wells(:)'];

if date == '20131121'
    all.vis.well=[nonlin.Lamps_1.vis.wells(:)',nonlin.Lamps_2.vis.wells(:)',nonlin.Lamps_3.vis.wells(:)',...
          nonlin.Lamps_6.vis.wells(:)'];

all.nir.well=[nonlin.Lamps_1.nir.wells(:)',nonlin.Lamps_2.nir.wells(:)',nonlin.Lamps_3.nir.wells(:)',...
          nonlin.Lamps_6.nir.wells(:)'];
    
end
      
      
      
%now build the new normalized reponse array, by using the mean pinned values
for LL = Lamps
    lamp_str =['Lamps_',num2str(LL)];
    for spc = {'vis','nir'}
        spc = char(spc);
        for nm_ = length(nonlin.(lamp_str).(spc).mean_WD):-1:1
            nonlin.(lamp_str).(spc).nnresp(:,nm_) = nonlin.(lamp_str).(spc).resp(:,nm_)./all.(spc).pin_val(nm_); %the new normalized response function
        end
    end
end


% all.vis.nresp=[nonlin.Lamps_1.vis.nnresp(:)',nonlin.Lamps_2.vis.nnresp(:)',nonlin.Lamps_3.vis.nnresp(:)',...
%           nonlin.Lamps_6.vis.nnresp(:)',nonlin.Lamps_9.vis.nnresp(:)',nonlin.Lamps_12.vis.nnresp(:)',...
%           ];
% 
% all.nir.nresp=[nonlin.Lamps_1.nir.nnresp(:)',nonlin.Lamps_2.nir.nnresp(:)',nonlin.Lamps_3.nir.nnresp(:)',...
%           nonlin.Lamps_6.nir.nnresp(:)',nonlin.Lamps_9.nir.nnresp(:)',nonlin.Lamps_12.nir.nnresp(:)',...
%           ];
      
all.vis.nresp=[nonlin.Lamps_1.vis.nresp(:)',nonlin.Lamps_2.vis.nresp(:)',nonlin.Lamps_3.vis.nresp(:)',...
          nonlin.Lamps_6.vis.nresp(:)',nonlin.Lamps_9.vis.nresp(:)',nonlin.Lamps_12.vis.nresp(:)'];

all.nir.nresp=[nonlin.Lamps_1.nir.nresp(:)',nonlin.Lamps_2.nir.nresp(:)',nonlin.Lamps_3.nir.nresp(:)',...
          nonlin.Lamps_6.nir.nresp(:)',nonlin.Lamps_9.nir.nresp(:)',nonlin.Lamps_12.nir.nresp(:)'];
 
      if date == '20131121'
          all.vis.nresp=[nonlin.Lamps_1.vis.nresp(:)',nonlin.Lamps_2.vis.nresp(:)',nonlin.Lamps_3.vis.nresp(:)',...
          nonlin.Lamps_6.vis.nresp(:)'];

all.nir.nresp=[nonlin.Lamps_1.nir.nresp(:)',nonlin.Lamps_2.nir.nresp(:)',nonlin.Lamps_3.nir.nresp(:)',...
          nonlin.Lamps_6.nir.nresp(:)'];
      end
      
      
all.vis.clr=[nonlin.Lamps_1.vis.nnresp(:)'.*0+1,nonlin.Lamps_2.vis.nnresp(:)'.*0+2,nonlin.Lamps_3.vis.nnresp(:)'.*0+3,...
          nonlin.Lamps_6.vis.nnresp(:)'.*0+4,nonlin.Lamps_9.vis.nnresp(:)'.*0+5,nonlin.Lamps_12.vis.nnresp(:)'.*0+6];

all.nir.clr=[nonlin.Lamps_1.nir.nnresp(:)'.*0+1,nonlin.Lamps_2.nir.nnresp(:)'.*0+2,nonlin.Lamps_3.nir.nnresp(:)'.*0+3,...
          nonlin.Lamps_6.nir.nnresp(:)'.*0+4,nonlin.Lamps_9.nir.nnresp(:)'.*0+5,nonlin.Lamps_12.nir.nnresp(:)'.*0+6];
      
all.nir.clr(isnan(all.nir.clr))=1;
all.vis.clr(isnan(all.vis.clr))=1;

%% build the look up table relationship between nresp and well depth
% use mean value at each point

% build the well depth look up array
well_bin=0.01;
all.vis.awell=(0:well_bin:1);
all.nir.awell=(0:well_bin:1);

all.vis.aresp=all.vis.awell.*NaN;
all.nir.aresp=all.nir.awell.*NaN;
%find the mean value of nresp at each well depth array
for w=1:length(all.vis.awell);
   L=max([0 all.vis.awell(w)-well_bin/2]); %low bound
   U=min([1 all.vis.awell(w)+well_bin/2]); %high bound
   all.vis.aresp(w)=nanmean(all.vis.nresp(all.vis.well >= L & all.vis.well < U));
   all.nir.aresp(w)=nanmean(all.nir.nresp(all.nir.well >= L & all.nir.well < U));
end
      
all.vis.aresp=smooth(all.vis.aresp,4);
all.nir.aresp=smooth(all.nir.aresp,4);

%% now plot the combined vectors
figure(12);
subplot(2,1,1);
pl=plot(all.vis.well,all.vis.nresp,'.');
hold on;
%plot(all.vis.well, all.vis.nresp,'r.');
%plot(all.vis.well, all.vis.nresp,'y.');
%plot(all.vis.well, all.vis.nresp,'b.');
%plot(all.vis.well, all.vis.nresp,'m.');
%plot(all.vis.well, all.vis.nresp,'g.');
%recolor(pl,all.vis.clr);

plot(all.vis.awell,all.vis.aresp,'k-');
hold off;
title('Vis spectrometer combined relationship with well depth');
xlabel('Well depth');
ylabel('Normalized response');

subplot(2,1,2);
plot(all.nir.well,all.nir.nresp,'.');
%recolor(pl,all.nir.clr);
hold on;
plot(all.nir.awell,all.nir.aresp,'k-');
hold off;
title('NIR spectrometer combined relationship with well depth');
xlabel('Well depth');
ylabel('Normalized response');

save_fig(12,[pname,filesep,date, 'welldepth_response_combine',corstr],asktopause);

if length(corstr) <= 1  
    disp(['Saving nonlinear analysis data to: ' pname '\' date '_resp_corr.mat'])
    save([pname filesep date '_resp_corr.mat'], 'all');
end
%return
