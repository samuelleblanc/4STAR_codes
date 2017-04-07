function [mark, mrg_out] = oracles_clean_dirty_dtau
% User selects before, after, at_time, and a scale factor. 
% Scale factor is applied to the observed delta AOD between after and
% before.  This is used to compute the delta transmittance associated as a
% step function change at at_time
% 
% Had trouble with non-sequential at_times, and unique, so trying to get
% around that by defining blip as one instance of before, after, etc and
% then only depositing "blip" into mark after all elements are defined and
% acceptable.

% Modifed: SL, 2017/04/04, migrated from korus_clean_dirty_dtau.m to
% oracles

version_set('v1.0')

in_star_file = getfullname('*20160*starsun*.mat','starsun');
% star_ = matfile(in_star_file);
[~, fname, ext] = fileparts(in_star_file);
star = load(in_star_file, 't','El_deg','AZstep','rateaero','m_aero','c0', 'aeronetcols', 'w');
star.fname = [fname, ext];
% D:\case_studies\4STAR\Field_Campaigns_Intensives\KORUS\WWW-AIR_1481588467
mrg_name = getfullname(['mrg1*',datestr(star.t(1),'yyyymmdd'),'*.nc'],'mrg');
mrg = rd_nc(mrg_name);
mrg.time = floor(star.t(1))+mrg.Start_UTC./(24*60*60);
flight_str = ['ORACLES ',datestr(mrg.time(1),'yyyy-mm-dd')];
flight_date = datestr(mrg.time(1),'yyyymmdd');
tt = [serial2hs(mrg.time');serial2hs(mrg.time')];
wls = [380,452, 501,520,532,550,606,620,675, 781,865,1020,1040,1064,1236,1559,1627];
for wii = length(wls):-1:1
    star.(sprintf('i_%3.0f',wls(wii))) = interp1(star.w, [1:length(star.w)], wls(wii)./1000, 'nearest');
    %AODs(:,wii) = mrg.(sprintf('AOD_%3.0fnm_4STAR',wls(wii)));
    AODs(:,wii) = mrg.AOD(wii,:);
end
bad = AODs<0; AODs(bad) = NaN;
nAODs = length(wls);
wii = [2,3,10,11];
nwiis = length(wii);
% star.i_501 = interp1(star.w, [1:length(star.w)],.501,'nearest');
% star.i_781 = interp1(star.w, [1:length(star.w)],.781,'nearest');
% AODs = [...
%     mrg.AOD_dash_501nm_4STAR,...
%     mrg.AOD_dash_781nm_4STAR];
% nAODs = size(AODs,2); % make this match the number of merged AODs to use
[ainc, cina] = nearest(star.t, mrg.time);  mrg.m_aero = NaN(size(mrg.time)); mrg.m_aero(cina) = star.m_aero(ainc);
% ainc(mrg.AOD_dash_675nm_4STAR(cina)<=0 | mrg.AOD_dash_QualFlag_4STAR(cina)~=0) = [];
% cina(mrg.AOD_dash_675nm_4STAR(cina)<=0 | mrg.AOD_dash_QualFlag_4STAR(cina)~=0) =[];
mrg.AOD_QualFlag_4STAR = mrg.qual_flag;
ainc(isNaN(sum(AODs(cina,wii),2)) | mrg.AOD_QualFlag_4STAR(cina)~=0) = [];
cina(isNaN(sum(AODs(cina,wii),2)) | mrg.AOD_QualFlag_4STAR(cina)~=0) = [];
cina_ = NaN(size(mrg.time)); cina_(cina) = 0;
ainc_ = NaN(size(star.t)); ainc_(ainc) = 0;
%mrg.SCAT550nm_dry_total_LARGE(mrg.SCAT550nm_dry_total_LARGE<-100) = NaN;
mrg.Scattotal(2,mrg.Scattotal(2,:)<-100) = NaN;
if isfield(mrg,'CloudFlag_CPSPD_LARGE');
    cld = zeros(size(mrg.CloudFlag_CPSPD_LARGE)); cld(mrg.CloudFlag_CPSPD_LARGE~=1)=NaN;
elseif isfield (mrg, 'CloudFlag');
    cld = zeros(size(mrg.CloudFlag)); cld(mrg.CloudFlag~=1)=NaN;
else;
    disp('No cloud flag in the file using RH')
    cld = zeros(size(mrg.time)); cld(mrg.Relative_Humidity<99)=NaN;
end;


[face_angle, area_norm]  = bluff_face(90-star.El_deg, double(star.AZstep)./(-50.0));

done = false;
blip.time_b4 = mrg.time(cina(1));
blip.wl = wls;
%     mark.AOD_b4 = [mrg.AOD_dash_501nm_4STAR(cina(1)),mrg.AOD_dash_781nm_4STAR(cina(1))];
blip.AOD_b4 = AODs(cina(1),:);
blip.time_f2= mrg.time(cina(1));
blip.AOD_f2= blip.AOD_b4;
blip.at_time= mrg.time(cina(1));
blah = serial2hs(blip.at_time);
blip.at_str = {num2str(blah)};
blip.dAOD = blip.AOD_f2 - blip.AOD_b4;
blip.sf(1) = 1;
blip.m_aero(1) = mrg.m_aero(cina(1));
blip.dCo = exp(-blip.dAOD .*(ones(size(blip.dAOD))*blip.m_aero));
           
mark = blip;
% xl_b4 = []; xl_f2 = []; xl_time = []; sf = 1;
b4_str = '[]'; f2_str = '[]'; at_str = '[]'; delta_AOD = 0;
while ~done
    createButton;
    if length(mark.at_time)>1
        [cinm,minc] = nearest(mrg.time, mark.at_time);
    else
        cinm = cina(1); minc = 1;
    end
    mm = NaN(size(cld));
    mm(cinm) = 0;
    dCo = ones([length(mrg.time),nAODs]);
    dCo(cinm,:) = mark.dCo(minc,:); % These dCo values already account for sf
    dCo = cumprod(dCo,1); % And now these account for the accumulative effect on calibration
    dAODs = -log(dCo)./(mrg.m_aero*ones([1,nAODs])); % and the cumulative effect on AOD
    AODs_ = AODs-dAODs; % This is the time series after correction.        
    figure_(1);
    % ax(1) = subplot(4,1,1);
    plot(serial2hs(mrg.time), AODs(:,wii)+cina_*ones([1,nwiis])-dAODs(:,wii),'o');
    xlabel('time'); ylabel('AOD');
    yl = ylim;
    title({flight_str; 'AOD, initial (faint dots) and adjusted (circles)'});
    for lg = length(wii):-1:1
        leg_str{lg} = sprintf('%3.0f nm',wls(wii(lg)));
    end
    legend(leg_str,'location','NorthEastOutside');
    %     hold('on');plot(serial2hs(mrg.time), AODs+cina_*ones([1,nAODs])+log(dCo)./(mrg.m_aero*ones([1,nAODs])),'x');
    hold('on');
    these = plot(serial2hs(mrg.time), AODs(:,wii)+cina_*ones([1,nwiis]),'o');% dynamicDateTicks
    lighten(these,.125); scale_marker(these,.25);
    hold('off');
    %     hold('on');
    %     these = plot(serial2hs(mrg.time), AODs,'.');ylim(yl);
    %     lighten(these,.125);
    %     hold('off');
    yl= ylim; yls = [yl(1)+cld'; yl(2)+cld']; mms = [yl(1)+mm';yl(2)+mm'];
    hold('on'); plot(tt(:), yls(:), 'or-',tt(:), mms(:), 'ok-'); hold('off'); ylim(yl);
    ax(1) = gca;
    if exist('vs','var')
        axis(ax(1),vs(1,:));
    end
    figure_(2);
    plot(serial2hs(mrg.time), 1000.*mrg.Pressure_Altitude,'r.',serial2hs(mrg.time), 1000.*mrg.Pressure_Altitude+cina_,'-o');% dynamicDateTicks
    ylabel('Alt [m]');title('Altitude (pressure)');
    yl= ylim; yls = [yl(1)+cld'; yl(2)+cld']; mms = [yl(1)+mm';yl(2)+mm'];
    hold('on'); plot(tt(:), yls(:), 'or-',tt(:), mms(:), 'ok-'); hold('off'); ylim(yl);
    ax(2) = gca;
    if exist('vs','var')
        axis(ax(2),vs(2,:));
    end
    
    figure_(3);
    % ax(4) = subplot(4,1,2);
    plot(serial2hs(star.t), [ainc_+star.rateaero(:,star.i_501)./star.c0(star.i_501), ...
        ainc_+star.rateaero(:,star.i_781)./star.c0(star.i_781)] ,'o');legend('Tr(501nm)','Tr(761nm)');
    hold('on'); plot(serial2hs(star.t), real(([star.rateaero(:,star.i_501)./(star.c0(star.i_501)), ...
        star.rateaero(:,star.i_781)./(star.c0(star.i_781))])) ,'.') ; % dynamicDateTicks
    hold('off');
    hold('on'); plot(serial2hs(star.t), 1./star.m_aero ,'k-');
    hold('off');
    %     yl= ylim; yls = [yl(1)+cld'; yl(2)+cld'];
    %     hold('on'); plot((tt(:)), yls(:), 'or-'); hold('off'); ylim(yl);
    yl= ylim; yls = [yl(1)+cld'; yl(2)+cld']; mms = [yl(1)+mm';yl(2)+mm'];
    hold('on'); plot(tt(:), yls(:), 'or-',tt(:), mms(:), 'ok-'); hold('off'); ylim(yl);
    ax(3) = gca;
    if exist('vs','var')
        axis(ax(3),vs(3,:));
    end
    figure_(6); plot(serial2hs(star.t), cosd(double(star.AZstep)./(-50)), 'b-',serial2hs(star.t), area_norm, 'gx');
    yl= ylim; yls = [yl(1)+cld'; yl(2)+cld']; mms = [yl(1)+mm';yl(2)+mm'];
    hold('on'); plot(tt(:), yls(:), 'or-',tt(:), mms(:), 'ok-'); hold('off'); ylim(yl);
    % dynamicDateTicks;
    title('Window projected area relative for forward heading'); legend('cosd(Az)','projection')
    ax(4) = gca;
    if exist('vs','var')
        axis(ax(4),vs(4,:));
    end    
    linkaxes(ax,'x');
    if exist('xl','var')
        xlim(xl);
    end
    % Option 1) Compute dTau from difference in mean of before and after
    % tau_aero and ascribe to
    % ascribe to
    %     mn_A = menu('Identify regions to assess contamination?', 'Yes','No, done');
    
    %     if mn_A ==2
    %         done = true;
    %     else    
    out = false;
    if exist('xl_f2_','var') && exist('xl_b4_','var')
        % This is the difference between before and after, after having
        % accounted for all dCo defined so far.
        delta_AOD = nanmean(AODs_(xl_f2_,wii(1))) - nanmean(AODs_(xl_b4_,wii(1)));
    end
    
    while ~out                
        sf = blip.sf;
        mn = menu('Zoom in and select ...',['BEFORE: ',b4_str],['AFTER: ',f2_str],['AT: ',at_str],...
            ['SF: ',num2str(sf), sprintf(' [=(%1.3f/%1.3f)]',delta_AOD.*sf,delta_AOD)],'Apply','CANCEL','DONE');
        if mn==1
            xl_b4 = xlim; xl_b4_ = serial2hs(mrg.time)>=xl_b4(1) & serial2hs(mrg.time)<=xl_b4(2);
            tmp = serial2hs([mrg.time(1), min(mrg.time(xl_b4_)), max(mrg.time(xl_b4_))]); tmp(1) = [];
            b4_str = [num2str(tmp(1)), ':',num2str(tmp(2))];
            blip.time_b4 = mean(mrg.time(xl_b4_));
            blip.xl_b4 = xl_b4;
            blip.b4_str = b4_str;
            blip.AOD_b4 = nanmean(AODs_(xl_b4_,:));
            if isfield(blip, 'xl_f2') && blip.time_b4<blip.time_f2
                delta_AOD = blip.AOD_f2(wii(1)) - blip.AOD_b4(wii(1));
            end
        elseif mn==2
            xl_f2 = xlim; xl_f2_ = serial2hs(mrg.time)>=xl_f2(1) & serial2hs(mrg.time)<=xl_f2(2);
            tmp = serial2hs([mrg.time(1), min(mrg.time(xl_f2_)), max(mrg.time(xl_f2_))]); tmp(1) = [];
            f2_str = [num2str(tmp(1)), ':',num2str(tmp(2))];
            blip.time_f2 = mean(mrg.time(xl_f2_));
            blip.xl_f2 = xl_f2;
            blip.f2_str = f2_str;
            blip.AOD_f2 = nanmean(AODs_(xl_f2_,:));
            if isfield(blip, 'xl_b4') && blip.time_b4<blip.time_f2
                delta_AOD = blip.AOD_f2(wii(1)) - blip.AOD_b4(wii(1));
            end           
        elseif mn ==3
            xl_hs = xlim; xl_time_ = serial2hs(mrg.time)>=xl_hs(1) & serial2hs(mrg.time)<=xl_hs(2);
            xl_time = [mean(mrg.time(xl_time_))];
            blah_ = serial2hs([mrg.time(1),xl_time]); blah_(1)= [];
            at_str = num2str(blah_);
            blip.at_time = xl_time;
            blip.at_str = at_str;
            blip.xl_hs = xl_hs;
            blip.m_aero = nanmean(mrg.m_aero(xl_time_));            
        elseif mn==5
            if ~isempty(blip.b4_str)&&~isempty(blip.f2_str)&&~isempty(blip.at_str)&&...
                blip.xl_b4(2)<blip.xl_f2(1)&& blip.at_time>=blip.xl_b4(2) && mean(blip.xl_hs)<=blip.xl_f2(1)
                blip.AOD_b4 = nanmean(AODs_(xl_b4_,:));
                blip.AOD_f2 = nanmean(AODs_(xl_f2_,:));
                delta_AOD = (blip.AOD_f2(wii(1)) - blip.AOD_b4(wii(1)));
                blip.dAOD = (blip.AOD_f2 - blip.AOD_b4).*blip.sf;
                blip.dCo = exp(-blip.dAOD .*(blip.m_aero*ones([1,nAODs])));
            
                [mark.at_time, ij, ji] = unique([blip.at_time, mark.at_time]);% ji(1) is index of blip.at_time
                tmp = {blip.at_str, mark.at_str{:}};
                mark.at_str = {tmp{ij}};
                tmp = [blip.sf, mark.sf];
                mark.sf = tmp(ij);
                tmp = [blip.m_aero, mark.m_aero];
                mark.m_aero = tmp(ij);
                tmp = [blip.time_b4 mark.time_b4]; 
                mark.time_b4 = tmp(ij);
                tmp = [blip.time_f2, mark.time_f2]; 
                mark.time_f2 = tmp(ij);
                tmp = [blip.AOD_b4; mark.AOD_b4]; 
                mark.AOD_b4 = tmp(ij,:);
                tmp = [blip.AOD_f2; mark.AOD_f2]; 
                mark.AOD_f2 = tmp(ij,:);
                mark.dAOD = (mark.AOD_f2 - mark.AOD_b4).*(mark.sf'*ones([1,nAODs]));
                mark.dCo = exp(-mark.dAOD .*(mark.m_aero'*ones([1,nAODs])));
                out = true;
            else
                disp('You need to pick "before" and "after" periods and a period for "time"');
            end
        elseif mn ==4
            % input a scale factor to apply to last correction
            sf = input('Input a new scale factor to apply to the last adjustment: ');
            if length(sf)>1
                sf  = sf(end);
            end
            blip.sf = sf;           
        elseif mn ==6
            
                really = menu('Really cancel?','Yes, really','Not really');
                if really == 1
                    break
                end

        else
            out = true;
            done = true;
        end
        
    end % of while
    %     end
    xl = xlim;
    if ~done        
        for xx = length(ax):-1:1
            vs(xx,:) = axis(ax(xx));
        end
        close('all');
    end
end
mrg_out.time = mrg.time;
mrg_out.AODs = AODs;
mrg_out.dCo = dCo;
mrg_out.m_aero = mrg.m_aero; nan_mass = isNaN(mrg.m_aero); 
mrg_out.m_aero(nan_mass) = interp1(mrg_out.time(~nan_mass), mrg_out.m_aero(~nan_mass), mrg_out.time(nan_mass),'linear','extrap');
 mrg_out.dAODs = -log(dCo)./(mrg_out.m_aero*ones([1,nAODs]));

mrg_out.wl_nm = wls;
% Make figures of dCo and dAODs
 
[p_out, fname] = fileparts(in_star_file);p_out = [p_out, filesep];
ffname = extract_date_from_starname(fname);
save([p_out,ffname,'_AOD_marks.mat'],'-struct','mark');
save([p_out,ffname,'_AOD_merge_marks.mat'],'-struct','mrg_out');
fig_out = strrep(p_out,'mat','fig');
if ~exist(fig_out,'dir')
    mkdir(fig_out);
end

menu('Zoom figure 1 to desired scale. Click OK when ready to save.','OK')
saveas(1,[fig_out,flight_date,'_AOD_adjusted.fig']);

[xiny, yinx] = nearest(mark.at_time, mrg_out.time);
all_times = serial2hs(mrg_out.time(yinx(2:end)));

figure; these = plot(mark.wl, mrg_out.dAODs(yinx(2:end),:),'-o'); 
if length(these)>1; recolor(these, (mrg_out.time(yinx(2:end))-mrg_out.time(1)).*24); end;
xlabel('wavelength'); ylabel('dOD'); title({flight_str; 'Accumulated AOD error vs wavelength'});
if length(these)>1; cb = colorbar; set(get(cb,'title'),'string','hour in flight','rotation',-90); end;
menu('Zoom to scale. Click OK when ready to save.','OK')
saveas(gcf,[fig_out,flight_date,'_accum_AOD_error_vs_wavelength.fig']);

figure;these = plot(mrg_out.wl_nm, mrg_out.dCo(yinx(2:end),:),'-o'); 
if length(these)>1; recolor(these, (mrg_out.time(yinx(2:end))-mrg_out.time(1)).*24); end;
xlabel('wavelength'); ylabel('dCo'); title({flight_str; 'Accumulated calibration error vs wavelength'});
if length(these)>1; cb = colorbar; set(get(cb,'title'),'string','hour in flight','rotation',-90); end;
menu('Zoom to scale. Click OK when ready to save.','OK')
saveas(gcf,[fig_out,flight_date,'_accum_cal_error_vs_wavelength.fig']);

figure; plot(mrg_out.time, mrg_out.dCo(:,wii),'-'); legend(leg_str,'location','NorthEast');
dynamicDateTicks;xlabel('time'); ylabel('dCo'); title({flight_str; 'Accumulated effective calibration bias'});
menu('Zoom to scale. Click OK when ready to save.','OK')
saveas(gcf,[fig_out,flight_date,'_accum_cal_error_vs_time.fig']);

figure; plot(mrg_out.time, mrg_out.dAODs(:,wii),'-'); legend(leg_str,'location','NorthWest');
dynamicDateTicks;xlabel('time'); ylabel('dOD'); title({flight_str; 'Accumulated uncertainty in AOD'});
menu('Zoom to scale. Click OK when ready to save.','OK')
saveas(gcf,[fig_out,flight_date,'_accum_AOD_error_vs_time.fig']);

return