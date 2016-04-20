function s = staraero(s, toggle)
% s = staraero(s, toggle)

% The block of code below will yield congruent "toggle" and "s.toggle" with
% the values from "toggle" propagated onto s.toggle. 
% If no "toggle" supplied, then values from update_toggle are pushed onto
% s.toggle.
if ~isfield(s,'toggle')
    if ~exist('toggle','var')
        toggle = update_toggle;
    else
        toggle = update_toggle(toggle);
    end
    s.toggle = toggle;
else
    if exist('toggle','var')
        s.toggle = catstruct(s.toggle, toggle); % merge, overwrite s.toggle with toggle
    end  
end
toggle = s.toggle;

%********************
%% screen data
%********************
if toggle.doflagging;
    m_aero_max=15;
    if toggle.booleanflagging; % new flagging system
        boolean=toggle.booleanflagging;
        %warning('Boolean flagging is under development. Please report any bug to Yohei.');
        if toggle.verbose; disp('in the boolean flagging system'), end;
        % prepare for flagging
        if strmatch('sun', lower(datatype(end-2:end))); % screening only for SUN data
            if toggle.verbose; disp('In the boolean flagging area'), end;
            % compute STD for auto cloud screening
            ti=9/86400;
            if strmatch('vis', lower(datatype(1:3)));
                cc=408;
            elseif strmatch('nir', lower(datatype(1:3)));
                cc=169;
            else;
                cc=[408 169+1044];
            end;
            s.rawstd=NaN(pp, numel(cc));
            s.rawmean=NaN(pp, numel(cc));
            for i=1:pp;
                rows=find(s.t>=s.t(i)-ti/2&s.t<=s.t(i)+ti/2 & s.Str==1); % Yohei, 2012/10/22 changed from s.Str>0
                if numel(rows)>0;
                    s.rawstd(i,:)=nanstd(s.raw(rows,cc),0,1); % stdvec.m seems to have a precision problem.
                    s.rawmean(i,:)=nanmean(s.raw(rows,cc),1);
                end;
            end;
            s.rawrelstd=s.rawstd./s.rawmean;
        end;
        
        % flag all columns (see below for flagging specific columns)
        nflagallcolsitems=7;
        s.flagallcolsitems=repmat({''},nflagallcolsitems,1);
        s.flagallcols=false(pp,1,nflagallcolsitems); % flags applied to all columns
        s.flagallcols(s.Str~=1,:,1)=true; s.flagallcolsitems(1)={'darks or sky scans'};
        if strmatch('sun', lower(datatype(end-2:end)));
            s.flagallcols(s.Md~=1,:,2)=true; s.flagallcolsitems(2)={'non-tracking modes'}; % is this flag redundant with the Str-based screening?
            s.flagallcols(any(s.rawrelstd>s.sd_aero_crit,2),:,3)=true; s.flagallcolsitems(3)={'high standard deviation'};
        end;
        s.flagallcols(s.m_aero>m_aero_max,:,4)=true; s.flagallcolsitems(4)={['aerosol airmass higher than ' num2str(m_aero_max)]};
        for i=1:size(s.ng,1);
            ng=incl(s.t,s.ng(i,1:2));
            if isempty(ng);
            elseif s.ng(i,3)<10;
                s.flagallcols(ng,:,5)=true; s.flagallcolsitems(5)={'unknown or others (manual flag)'};
            elseif s.ng(i,3)<100;
                s.flagallcols(ng,:,6)=true; s.flagallcolsitems(6)={'clouds (manual flag)'};
            elseif s.ng(i,3)<1000;
                s.flagallcols(ng,:,7)=true; s.flagallcolsitems(7)={'instrument tests or issues (manual flag)'};
            end;
        end;
        if size(s.flagallcols,3)~=nflagallcolsitems;
            error('Update starwrapper.m.');
        end;
        
        % flag specific columns
        nflagitems=1;
        s.flagitems=repmat({},nflagitems,1);
        s.flag=false(pp,qq,nflagitems); % flags applied to each column separately
        s.flag(s.raw-s.dark<=s.darkstd | repmat(s.c0,size(s.t))<=0)=true; s.flagitems(1)={'<=1 signal-to-noise ratio or non-positive c0'};
        if size(s.flag,3)~=nflagitems;
            error('Update starwrapper.m.');
        end;
        
    else; % the old flagging system
        % execute manual flags to screen out data for clouds and other unfavorable conditions
        if toggle.verbose; disp('in the old flagging system'), end;
        s.flag=zeros(size(s.rate));
        for i=1:size(s.ng,1);
            ng=incl(s.t,s.ng(i,1:2));
            s.flag(ng,:)=s.flag(ng,:)+s.ng(i,3);
        end;
        
        % auto screening
        % cjf: We may need to consider a different screen for the AOD at the beginning
        % and ending of the sky scans.
        % YS: agreed. And different screens mean they should be applied in starsun
        % and starsky, not in starwrapper.
        autoscrnote='Auto-screening was applied for ';
        s.flag(s.Str~=1,:)=s.flag(s.Str~=1,:)+0.1; % Yohei 2012/10/08 darks and sky scans % s.flag(s.Str==0,:)=s.flag(s.Str==0,:)+0.1; % darks
        autoscrnote=[autoscrnote 'darks or sky scans, '];
        s.flag(s.raw-s.dark<=s.darkstd | repmat(s.c0,size(s.t))<=0)=s.flag(s.raw-s.dark<=s.darkstd | repmat(s.c0,size(s.t))<=0)+0.4;  % YS 2012/10/09
        autoscrnote=[autoscrnote '<=1 signal-to-noise ratio or non-positive c0, ']; % YS 2012/10/09
        s.flag(s.m_aero>m_aero_max,:)=s.flag(s.m_aero>m_aero_max,:)+0.02; % Yohei 2012/10/19 large airmass. John says "I certainly don't trust values of m_aero > 15 (for that matter, I probably don't trust the values for m_aero ~>14? 13?)."
        autoscrnote=[autoscrnote 'aerosol airmass higher than ' num2str(m_aero_max) ', ']; % YS 2012/10/09
        if strmatch('sun', lower(datatype(end-2:end))); % screening only for SUN data
            % non-tracking mode - is this redundant with the Str-based screening?
            s.flag(s.Md~=1,:)=s.flag(s.Md~=1,:)+0.2;
            autoscrnote=[autoscrnote 'non-tracking modes, '];
            % STD-based cloud screening
            ti=9/86400;
            if strmatch('vis', lower(datatype(1:3)));
                cc=408;
            elseif strmatch('nir', lower(datatype(1:3)));
                cc=169;
            else;
                cc=[408 169+1044];
            end;
            s.rawstd=NaN(pp, numel(cc));
            s.rawmean=NaN(pp, numel(cc));
            for i=1:pp;
                rows=find(s.t>=s.t(i)-ti/2&s.t<=s.t(i)+ti/2 & s.Str==1); % Yohei, 2012/10/22 s.Str>0
                if numel(rows)>0;
                    s.rawstd(i,:)=nanstd(s.raw(rows,cc),0,1); % stdvec.m seems to have a precision problem.
                    s.rawmean(i,:)=nanmean(s.raw(rows,cc),1);
                end;
            end;
            s.rawrelstd=s.rawstd./s.rawmean;
            s.flag(any(s.rawrelstd>s.sd_aero_crit,2),:)=s.flag(any(s.rawrelstd>s.sd_aero_crit,2),:)+0.01;
            autoscrnote=[autoscrnote 'STD higher than ' num2str(s.sd_aero_crit) ' at columns #' num2str(cc) ', '];
        end;
        s.note=[autoscrnote(1:end-2) '. ' s.note];
    end;
end; % toggle.doflagging
%compute s.rawrelstd for auto cloud screening
% if strmatch('sun', lower(datatype(end-2:end))); % screening only for SUN data
%     ti=9/86400;
%     if strmatch('vis', lower(datatype(1:3)));
%         cc=408;
%     elseif strmatch('nir', lower(datatype(1:3)));
%         cc=169;
%     else;
%         cc=[408 169+1044];
%     end;
% %gasmode=1;
%
%     s.rawstd=NaN(pp, numel(cc));
%     s.rawmean=NaN(pp, numel(cc));
%     for i=1:pp;
%         rows=find(s.t>=s.t(i)-ti/2&s.t<=s.t(i)+ti/2 & s.Str==1); % Yohei, 2012/10/22 changed from s.Str>0
%         if numel(rows)>0;
%             s.rawstd(i,:)=nanstd(s.raw(rows,cc),0,1); % stdvec.m seems to have a precision problem.
%             s.rawmean(i,:)=nanmean(s.raw(rows,cc),1);
%         end;
%     end;
%     s.rawrelstd=s.rawstd./s.rawmean;
%  %end;

% (remaining items from the AATS code)
% filter #2 discard measurement cycles with bad tracking
% bad altitude data, tr<=0

%********************
% derive AODs, uncertainties and polynomial fits
%********************
% mode of gas retrieval proc
% gasmode=menu('Select gas retrieval mode:','1: CWV only','2: PCA, hyperspectral');

if ~isempty(strfind(lower(datatype),'sun'))|| ~isempty(strfind(lower(datatype),'forj'));
    % || ~isempty(strfind(lower(datatype),'sky')); % not for FOV, ZEN, PARK data
    
    %if ~isempty(strmatch('sun', lower(datatype(end-2:end)))) || ~isempty(strmatch('forj', lower(datatype(end-3:end)))) || ~isempty(strmatch('sky', lower(datatype(end-2:end)))); % not for FOV, ZEN, PARK data
    % derive optical depths by the traditional method
    [s.m_ray, s.m_aero, s.m_H2O, s.m_O3, s.m_NO2]=airmasses(s.sza, s.Alt, s.O3h); % airmass for O3
    [s.tau_ray, s.tau_r_err]=rayleighez(s.w,s.Pst,s.t,s.Lat); % Rayleigh
    [cross_sections, s.tau_O3, s.tau_NO2, s.tau_O4, s.tau_CO2_CH4_N2O, s.tau_O3_err, s.tau_NO2_err, s.tau_O4_err, s.tau_CO2_CH4_N2O_abserr]=taugases(s.t, 'SUN', s.Alt, s.Lat, s.Lon, s.O3col, s.NO2col); % gases
 
    % cjf: Alternative with tr
    %     if ~isempty(strfind(lower(datatype),'sky')); % if clause added by Yohei, 2012/10/22
    %         s.skyrad = s.rate./repmat(s.skyresp,pp,1);
    %         s.skyrad(s.Str==0|s.Md==1,:) = NaN; % sky radiance not defined when shutter is closed or when actively tracking the sun
    %     end;
    
    
    % MS added gas retrieval Nov 19 2013
    %     if gasmode==1
    %         % Yohei's original...
    %         s.rateaero=s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2_CH4_N2O); % rate adjusted for the aerosol component
    %         s.tau_aero_noscreening=-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq); % aerosol optical depth before flags are applied
    %
    %     elseif gasmode==2
    %         % use retrieved O3/NO2 to subtract
    %         % reconstruct filtered data using PCA
    %         % Yohei's original...!!!should be optimized to not include twice...
    %         s.rateaero=s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2_CH4_N2O); % rate adjusted for the aerosol component
    %         s.tau_aero_noscreening=-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq); % aerosol optical depth before flags are applied
    %         s.tau_aero=s.tau_aero_noscreening;                                %!!! this is non-screened but not used in gas code
    %
    %         [s.tau_O3 s.o3VCD s.tau_NO2 s.no2VCD s.mse_O3 s.mse_NO2 s.tau_H2Oa s.tau_H2Ob s.CWV] = gasretrieveo3no2cwv(s,cross_sections);    % s.tau_O3/NO2 are columnar OD
    %         [s.pcadata s.pcavisdata s.pcanirdata s.pcvis s.pcnir s.eigvis s.eignir s.pcanote] =starPCAshort(s);
    %         % original:s.rateaero=s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2_CH4_N2O); % rate adjusted for the aerosol component
    %         s.rateaero=s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2)./tr(s.m_ray, s.tau_CH4);
    %         s.tau_aero_noscreening=-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq); % aerosol optical depth before flags are applied
    %         s.rateaero_woh2o=s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2)./tr(s.m_ray, s.tau_CH4)./...
    %             tr(s.m_H2O, s.tau_H2Oa); % rate adjusted for the aerosol component with water vapor subtraction
    %         s.tau_aero_noscreening_woh2o=-log(s.rateaero_woh2o./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq); % aerosol optical depth before flags are applied
    %     end
    % MS added water-vapor only gas retrieval Jan 17, 2014
    %if gasmode==1 && ~isempty(strfind(lower(datatype),'sun'))
    % Yohei's original...
    s.rateaero=real(s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2_CH4_N2O)); % rate adjusted for the aerosol component
    s.tau_aero_noscreening=real(-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq)); % aerosol optical depth before flags are applied
    s.tau_aero=s.tau_aero_noscreening;
    
    % total optical depth (Rayleigh subtracted) needed for gas processing
    if toggle.gassubtract
        tau_O4nir          = s.tau_O4; tau_O4nir(:,1:1044)=0;
        s.rateslant        = real(s.rate./repmat(s.f,1,qq));
        s.ratetot          = real(s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_ray, tau_O4nir));
        s.tau_tot_slant    = real(-log(s.ratetot./repmat(s.c0,pp,1)));
        s.tau_tot_vertical = real(-log(s.ratetot./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq));
    end;
    
    % compare rate structures:
    
    %     figure;
    %     plot(s.w,s.tau_O4([9850 9860 9890],:),'-');
    %
    %     wi = [1084,1109,1213,1439,1503];
    %     le = {'1020 nm';'1064 nm';'1236 nm';'1559 nm';'1640 nm'};
    %     figure;
    %     for ll=1:length(wi)
    %         subplot(length(wi),1,ll);
    %         plot(serial2Hh(s.t),s.rateaero(:,wi(ll)) - ...
    %              s.ratetot(:,wi(ll)), 'ok','markersize',8);hold on;
    %
    %          if ll==3
    %          xlabel('time [UTC]');
    %          ylabel('\Delta (rate-aero - rate-aero minus O4)');
    %          end
    %         legend(le{ll,:});
    %         axis([min(serial2Hh(s.t)) max(serial2Hh(s.t)) -0.005 0.005]);
    %         plot(serial2Hh(s.t),zeros(length(serial2Hh(s.t)),1),'-m');hold off;
    %     end
    %
    %     figure;
    %     plot(s.w,s.rateaero(9850,:) - s.ratetot(9850,:),'-.b');
    %     axis([0.3 1.7 0 10]);
    %     legend('rateaero-ratetot(O4nir sub)')
    %
    %     figure;
    %     plot(s.w,s.tau_aero_noscreening(9850,:) - ...
    %          s.tau_tot_vertical(9850,:),'-.b');hold on;
    %
    %     legend('tau-aero-noscreening - tau-aero-minus-nirO4');
    %     axis([0.3 1.7 0 1]);
    %
    %     figure;
    %     plot(s.w,s.tau_aero_noscreening([9850 9900,9950 9980],:),'-.');hold on;
    %     plot(s.w,s.tau_tot_vertical([9850 9900,9950 9980],:),    ':'); hold on;
    %     plot(s.w,s.dark([9850 9900,9950 9980],:)/10000,'-k');hold on;
    %     legend('tau-aero-noscreening','tau-aero-minus-nirO4');
    %
    %     figure;
    %     plot(s.UTHh,s.dark(:,1083),'ob');hold on;
    %     plot(s.UTHh,s.dark(:,1085),'og');hold on;
    %     legend('dark at peak (1.018)','dark at valley (1.022)');
    %
    %     figure;
    %     plot(s.UTHh,s.rate(:,1083),'ob');hold on;
    %     plot(s.UTHh,s.rate(:,1085),'og');hold on;
    %     legend('rate at peak (1.018)','rate at valley (1.022)');
    %
    %     figure;
    %     plot(s.UTHh,s.ratetot(:,1083),'ob');hold on;
    %     plot(s.UTHh,s.ratetot(:,1085),'og');hold on;
    %     legend('ratetot at peak (1.018)','ratetot at valley (1.022)');
    %
    %     figure;
    %     plot(s.w,s.c0-s.rateaero(9850,:),'-b');hold on;
    %     plot(s.w,s.c0-s.ratetot(9850,:) ,'-g');hold on;
    %     axis([0.3 1.7 -1 1]);
    %     xlabel('wavelength');ylabel('c0-rate');
    %     legend('rateaero','ratetot');
    %
    %     figure;
    %     plot(s.w,s.c0,'-b');hold on;
    %     plot(s.w,s.rateaero(9850,:),':g');hold on;
    %     %plot(s.w,s.ratetot(9850,:),':m');hold on;
    %     plot(s.w,smooth(s.c0),'--b','linewidth',2);hold on;
    %     plot(s.w,smooth(s.rateaero(9850,:)),'.-g','linewidth',2);hold on;
    %     %plot(s.w,smooth(s.ratetot(9850,:)), '.-m','linewidth',2);hold on;
    %     legend('c0','rateaero','smooth c0','smooth rateaero');
    %     xlabel('wavelength');ylabel('dark subtracted, corrected counts');
    %     axis([0.3 1.7 0 10]);
    %
    %     figure;
    %     plot(s.w,s.tau_aero_noscreening([9850:9855],:),'-');
    %     xlabel('wavelength');ylabel('tau-aero-noscreening');title('2014-09-02');
    
    % apply screening here
    %flags bad_aod, unspecified_clouds and before_and_after_flight
    %produces YYYYMMDD_auto_starflag_created20131108_HHMM.mat and
    %s.flagallcols
    %************************************************************
    %[s.flags]=starflag(daystr,1,s);
    % Does not seem to work for MLO ground-based data, perhaps because
    % starflag.m assumes attempts to read "flight" from starinfo. Yohei,
    % 2014/07/18.
    %************************************************************
    
    % calculate CWV from 940 nm band and subtract other regions
    % tavg=3;
    % [s] = spec_aveg_cwv(s,tavg);
    
    %[s.tau_H2Oa s.tau_H2Ob s.CWV] = gasretrievecwv(s,cross_sections);%original version
    %         if verbose; disp('calculating water vapor amount and subtracting'), end;
    %         [s.tau_aero_wvsubtract s.CWV s.CWVunc] = cwvsubtract(s,cross_sections,visc0mod, nirc0mod, vislampc0, nirlampc0);
    %[s.tau_aero_fitsubtract s.tau_aero_specsubtract s.gas] = gasescorecalc(s,visc0mod',nirc0mod',model_atmosphere);
    %[s.tau_aero_fitsubtract s.gas] = gasessubtract(s,visc0mod',nirc0mod',model_atmosphere);
    % water vapor retrieval (940fit+c0 method)
    %-----------------------------------------
    if toggle.runwatervapor;
        if toggle.verbose; disp('water vapor retrieval start'), end;
        [s.cwv] = cwvcorecalc(s,s.c0mod,model_atmosphere);
        % subtract water vapor from tau_aero
        if toggle.verbose; disp('water vapor retrieval end'), end;
        % gases subtractions and o3/no2 conc [in DU] from fit
        %-----------------------------------------------------
        if toggle.gassubtract
            if toggle.verbose; disp('gases subtractions start'), end;
            %[s.tau_aero_fitsubtract s.gas] = gasesretrieve(s);
            [s.tau_aero_fitsubtract s.gas] = gasessubtract(s);
            if toggle.verbose; disp('gases subtractions end'), end;
            %s.tau_aero=s.tau_aero_wvsubtract;
        end;
    end;
    %elseif gasmode==2 && ~isempty(strfind(lower(datatype),'sun'))
    % use retrieved O3/NO2 to subtract
    % reconstruct filtered data using PCA
    % Yohei's original...!!!should be optimized to not include twice...
    %         s.rateaero=real(s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2_CH4_N2O)); % rate adjusted for the aerosol component
    %         s.tau_aero_noscreening=real(-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq)); % aerosol optical depth before flags are applied
    %         s.tau_aero=s.tau_aero_noscreening;                                %!!! this is non-screened but not used in gas code
    
    % original O3/NO2 retrieval - leave in to compare
    %         [s.flags]=starflag(daystr,1,s);
    %         %-----------------------------------------------------
    %         if verbose; disp('o3/no2 standard retrieval start'), end;
    %         [s.pcadata s.pcavisdata s.pcanirdata s.pcvis s.pcnir s.eigvis s.eignir s.pcanote] =starPCAshort(s);
    %         [s.tau_O3 s.o3VCD s.tau_NO2 s.no2VCD s.mse_O3 s.mse_NO2 s.tau_H2Oa s.tau_H2Ob s.CWV] = gasretrieveo3no2cwv(s,cross_sections);    % s.tau_O3/NO2 are columnar OD
    %         if verbose; disp('o3/no2 standard retrieval end'), end;
    % original:s.rateaero=s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2_CH4_N2O); % rate adjusted for the aerosol component
    %         s.rateaero=real(s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2)./tr(s.m_ray, s.tau_CH4));
    %         s.tau_aero_noscreening=real(-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq)); % aerosol optical depth before flags are applied
    %         s.rateaero_woh2o=real(s.rate./repmat(s.f,1,qq)./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2)./tr(s.m_ray, s.tau_CH4)./...
    %             tr(s.m_H2O, s.tau_H2Oa)); % rate adjusted for the aerosol component with water vapor subtraction
    %         s.tau_aero_noscreening_woh2o=real(-log(s.rateaero_woh2o./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq)); % aerosol optical depth before flags are applied
    %end
    
    
    
    % cjf: Reformulation in terms of atmos transmittance tr. I prefer this to
    % using "rateaero", since it eliminates arbitrary units (cts/ms, etc) and
    % plots of atmospheric tr are more intelligible than rateaero.
    % And it is also keeps the sun and sky processing more symmetric.
    % s.tr = s.rate./repmat(s.c0,pp,1)./repmat(s.f,1,qq);
    % s.tr(s.Str~=1|s.Md~=1,:) = NaN;% not defined if the shutter is not open to sun or if not actively tracking
    % s.traero=s.tr./tr(s.m_ray, s.tau_ray)./tr(s.m_O3, s.tau_O3)./tr(s.m_NO2, s.tau_NO2)./tr(s.m_ray, s.tau_O4)./tr(s.m_ray, s.tau_CO2_CH4_N2O); % rate adjusted for the aerosol component
    % s.tau_aero_noscreening=-log(s.traero)./repmat(s.m_aero,1,qq); % aerosol optical depth before flags are applied
    % Yohei 2012/10/22
    % Though the analogy with the sky algorithm is attractive, I prefer
    % rateaero over tr. I use rateaero for Langley plots, but have not used
    % tr for any purpose so far. But I can be persuaded to include tr if
    % there is a practical use in it to justify a modest increase in file size.
    tau=real(-log(s.rate./repmat(s.f,1,qq)./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq)); % tau, just for the error analysis below
    warning('Diffuse light correction and its uncertainty (tau_aero_err10) to be amended.');
    % % % s=rmfield(s, 'rate'); YS 2012/10/09
    
    % estimate uncertainties in tau aero - largely inherited from AATS14_MakeAOD_MLO_2011.m
    if toggle.computeerror;
        s.m_err=0.0003.*(s.m_ray/2).^2.2; % expression for dm/m is from Reagan report
        s.m_err(s.m_ray<=2)=0.0003; % negligible for TCAP July, but this needs to be revisited. The AATS code offers two options: this (0.03%) and 1%.
        s.tau_aero_err1=abs(tau.*repmat(s.m_err,1,qq)); % YS 2012/10/09 abs avoids imaginary part and hence reduces the size of tau_aero_err (for which tau_aero is NaN as long as rate<=darkstd is screened out.).
        if size(s.c0err,1)==1;
            s.tau_aero_err2=1./s.m_aero*(s.c0err./s.c0);
        elseif size(s.c0err,1)==2;
            s.tau_aero_err2lo=1./s.m_aero*(s.c0err(1,:)./s.c0);
            s.tau_aero_err2hi=1./s.m_aero*(s.c0err(2,:)./s.c0);
        end;
        s.tau_aero_err3=s.darkstd./(s.raw-s.dark)./repmat(s.m_aero,1,qq); % be sure to subtract dark, as it can be negative.
        s.tau_aero_err4=repmat(s.m_ray./s.m_aero,1,qq)*s.tau_r_err.*s.tau_ray;
        s.tau_aero_err5=repmat(s.m_O3./s.m_aero,1,qq)*s.tau_O3_err.*s.tau_O3;
        s.tau_aero_err6=repmat(s.m_NO2./s.m_aero,1,qq)*s.tau_NO2_err.*s.tau_NO2;
        %s.tau_aero_err6=s.m_NO2./s.m_aero*s.tau_NO2_err*s.tau_NO2;
        s.tau_aero_err7=repmat(s.m_ray./s.m_aero,1,qq).*s.tau_O4_err.*s.tau_O4;
        s.tau_aero_err8=0; % legacy from the AATS code; reserve this variable for future H2O error estimate; % tau_aero_err8=tau_H2O_err*s.tau_H2O.* (ones(n(2),1)*(m_H2O./m_aero));
        s.responsivityFOV=starresponsivityFOV(s.t,'SUN',s.QdVlr,s.QdVtb,s.QdVtot);
        s.track_err=abs(1-s.responsivityFOV);
        s.tau_aero_err9=s.track_err./repmat(s.m_aero,1,qq);
        s.tau_aero_err10=0; % reserved for error associated with diffuse light correction; tau_aero_err10=tau_aero.*runc_F'; %error of diffuse light correction
        s.tau_aero_err11=s.m_ray./s.m_aero*s.tau_CO2_CH4_N2O_abserr;
        if size(s.c0err,1)==1;
            s.tau_aero_err=(s.tau_aero_err1.^2+s.tau_aero_err2.^2+s.tau_aero_err3.^2+s.tau_aero_err4.^2+s.tau_aero_err5.^2+s.tau_aero_err6.^2+s.tau_aero_err7.^2+s.tau_aero_err8.^2+s.tau_aero_err9.^2+s.tau_aero_err10.^2+s.tau_aero_err11.^2).^0.5; % combined uncertianty
        elseif size(s.c0err,1)==2;
            s.tau_aero_errlo=-(s.tau_aero_err1.^2+s.tau_aero_err2lo.^2+s.tau_aero_err3.^2+s.tau_aero_err4.^2+s.tau_aero_err5.^2+s.tau_aero_err6.^2+s.tau_aero_err7.^2+s.tau_aero_err8.^2+s.tau_aero_err9.^2+s.tau_aero_err10.^2+s.tau_aero_err11.^2).^0.5; % combined uncertianty
            s.tau_aero_errhi=(s.tau_aero_err1.^2+s.tau_aero_err2hi.^2+s.tau_aero_err3.^2+s.tau_aero_err4.^2+s.tau_aero_err5.^2+s.tau_aero_err6.^2+s.tau_aero_err7.^2+s.tau_aero_err8.^2+s.tau_aero_err9.^2+s.tau_aero_err10.^2+s.tau_aero_err11.^2).^0.5; % combined uncertianty
        end;
    end;
    
    %flags bad_aod, unspecified_clouds and before_and_after_flight
    %produces YYYYMMDD_auto_starflag_created20131108_HHMM.mat and
    %s.flagallcols
    %************************************************************
    if toggle.dostarflag;
        if toggle.verbose; disp('Starting the starflag'), end;
        %if ~isfield(s, 'rawrelstd'), s.rawrelstd=s.rawstd./s.rawmean; end;
        [s.flags, good]=starflag(s,toggle.flagging); % flagging=1 automatic, flagging=2 manual, flagging=3, load existing
    end;
    %************************************************************
    
    %% apply flags to the calculated tau_aero_noscreening
    s.tau_aero=s.tau_aero_noscreening;
    if toggle.dostarflag && toggle.flagging==1;
        s.tau_aero(s.flags.bad_aod,:)=NaN;
    end;
    % tau_aero on the ground is used for purposes such as comparisons with AATS; don't mask it except for clouds, etc. Yohei,
    % 2014/07/18.
    % The lines below used to be around here. But recent versions of starwrapper.m. do not have them. Now revived. Yohei, 2014/10/31.
    % apply flags to the calculated tau_aero_noscreening
    if toggle.doflagging;
        if toggle.booleanflagging;
            s.tau_aero(any(s.flagallcols,3),:)=NaN;
            s.tau_aero(any(s.flag,3))=NaN;
        else
            s.tau_aero(s.flag~=0)=NaN; % the flags come starinfo########.m and starwrapper.m.
        end;
    end;
    % The end of "The lines below used to be around here. But recent
    % versions of starwrapper.m. do not have them. Now revived. Yohei, 2014/10/31."
    
    % fit a polynomial curve to the non-strongly-absorbing wavelengths
    [a2,a1,a0,ang,curvature]=polyfitaod(s.w(s.aerosolcols),s.tau_aero(:,s.aerosolcols)); % polynomial separated into components for historic reasons
    s.tau_aero_polynomial=[a2 a1 a0];
    
    % derive optical depths and gas mixing ratios
    % Michal's code TO BE PLUGGED IN HERE.
    
end; % End of sun-specific processing

if ~isempty(strfind(lower(datatype),'sky')); % if clause added by Yohei, 2012/10/22
    s.skyrad = s.rate./repmat(s.skyresp,pp,1);
    s.skyrad(s.Str==0|s.Md==1,:) = NaN; % sky radiance not defined when shutter is closed or when actively tracking the sun
end;



%********************
%% remove some of the results for a lighter file
%********************
if ~toggle.saveadditionalvariables;
    s=rmfield(s, {'darkstd'});
    if ~isempty(strfind(lower(datatype),'sun'));
        s=rmfield(s, {'tau_O3' 'tau_O4' 'tau_aero_noscreening' 'tau_ray' ...
        'rawmean' 'rawstd' 'sat_ij'});
    end;
    if toggle.computeerror;
        s=rmfield(s, {'tau_aero_err1' 'tau_aero_err2' 'tau_aero_err3' 'tau_aero_err4' 'tau_aero_err5' 'tau_aero_err6' 'tau_aero_err7' 'tau_aero_err8' 'tau_aero_err9' 'tau_aero_err10' 'tau_aero_err11'});
    end;
end;

%********************
%% inspect results
%********************
% plots very tightly related to the processes above only. For other figures, use other codes.
% data screening
if toggle.inspectresults && ~isempty(strmatch('sun', lower(datatype(end-2:end)))) ; %|| ~isempty(strmatch('sky', lower(datatype(end-2:end))))); % don't inspect FOV, ZEN, PARK data
    panel_preference=1;
    if panel_preference==2;
        yylist={'s.tau_aero_noscreening' 'ang' 's.rawrelstd' 'track_err' 's.Alt/1000'};
        yypanel=[1 2 2 2 2];
        yys={'.' 'o', '.k','x','-k'};
        yylstr={'\tau_{aero}', char(197), 'STD_{rel}', 'Track Err', 'Alt (km)'}; % for each label
        yystr={'\tau_{aero}' ''}; % for each panel
        yylim=[0 1; -0.5 3];
    elseif panel_preference==1;
        yylist={'s.tau_aero_noscreening' 's.rawrelstd' 's.sd_aero_crit' 'track_err' 'ang' 's.Alt/1000'};
        yypanel=[1 2 2 3 3 3];
        yys={'.' '.-k','--m','x', 'o','-k'};
        yylstr={'\tau_{aero}', 'STD_{rel}', 'sd aero crit', 'Track Err', char(197), 'Alt (km)'}; % for each label
        yystr={'\tau_{aero}', 'STD_{rel}', ['Track Err, ' char(197) ', Alt (km)']}; % for each panel
        yylim=[0 1; 0 0.2; -0.5 3];
    end;
    aerosolcols=s.aerosolcols;
    [visc,nirc]=starchannelsatAATS(s.t);
    cols=[visc nirc+numel(s.viscols)];
    cols=cols(isfinite(cols)==1);
    colsang=cols([3 7]);
    ang=sca2angstrom(s.tau_aero_noscreening(:,colsang), s.w(colsang));
    daystr=starfilenames2daystr(s.filename);
    figure;
    for ii=unique(yypanel);
        subplot(max(yypanel), 1, ii);
        kk=find(yypanel==ii);
        clear lstr;
        for k=kk;
            eval(['yy=' yylist{k} ';']);
            if numel(yy)==1;
                yy=repmat(yy,pp,1);
            end;
            if size(yy,2)==qq && size(yy,1)==pp;
                ph00=plot(s.t,yy(:,cols),yys{k},'color',[.5 .5 .5]);
                hold on;
                yyok=yy;
                if boolean
                    yyok(any(s.flagallcols,3),:)=NaN;
                    yyok(any(s.flag,3))=NaN;
                else
                    yyok(s.flag~=0)=NaN;
                end;
                ph0=plot(s.t,yyok(:,cols),yys{k});
            else
                ph00=plot(s.t,yy,yys{k},'color',[.5 .5 .5]);
                hold on;
                yyok=yy;
                if boolean
                    yyok(any(s.flagallcols,3),:)=NaN;
                else
                    yyok(all(s.flag(:,cols),2),:)=NaN;
                end;
                ph0=plot(s.t,yyok,yys{k});
            end;
            ph(k)=ph0(1);
            if numel(ph0)==numel(cols);
                lstr=setspectrumcolor(ph0, s.w(cols));
            end;
        end;
        ax(ii)=gca;
        ylim(ax(ii),yylim(ii,:));
        ylabel(yystr{ii});
        set(gca,'xtick',[],'xticklabel','');
        if numel(kk)==1 && exist('lstr');
            lh=legend(ph0, lstr);
            set(lh,'fontsize',6,'location','best');
        else
            lh=legend(ph(kk), yylstr(kk));
            set(lh,'fontsize',10,'location','best');
        end;
        if ii==1;
            title(daystr);
        end;
    end;
    linkaxes(ax,'x');
    datetick('x'); % it'd be nice if the figure automatically update the datetick
    % then use dynamicDateTicks instead
    xlabel('Time');
    if savefigure;
        starsas(['star' daystr 'starwrapper_screening.fig']);
    end;
    
    % prepare to plot average tau and tau_aero_err
    ok=ones(size(s.tau_aero));
    if boolean
        ok(any(s.flagallcols,3),:)=NaN;
        ok(any(s.flag,3))=NaN;
    else
        ok(find(s.flag~=0))=NaN;
    end;
    
    % average tau
    figure;
    mean_taus=[nanmean(s.tau_ray.*ok,1)
        nanmean(s.tau_O3.*ok,1)
        nanmean(repmat(s.tau_NO2,pp,1).*ok,1)
        nanmean(s.tau_O4.*ok,1)
        nanmean(repmat(s.tau_CO2_CH4_N2O,pp,1).*ok,1)
        nanmean(s.tau_aero.*ok,1)];
    nerrs=size(mean_taus,1);
    h=loglog(s.w,mean_taus,s.w(aerosolcols),mean_taus(:,aerosolcols),'markersize',12,'linestyle','none');
    set(h(1+[0 nerrs]),'marker','.','color','c');
    set(h(2+[0 nerrs]),'marker','.','color',[0.5 0 0.5]);
    set(h(3+[0 nerrs]),'marker','.','color','r');
    set(h(4+[0 nerrs]),'marker','.','color',[1 .5 0]);
    set(h(5+[0 nerrs]),'marker','.','color',[0.5 0.5 0.5], 'markersize',6);
    set(h(6+[0 nerrs]),'marker','+','color','m','markersize',6,'linewidth',2);
    for i=1:nerrs;
        clr=get(h(i),'color');
        set(h(i),'color',clr/2+0.5);
    end;
    gglwa;
    ylim([0.0001 0.2]);
    grid on;
    ylabel('mean tau','interpreter','none');
    title(daystr);
    lh=legend(h(nerrs+1:end),'Rayleigh','O3','NO2','O2-O2','(CO2,CH4,N2O)','Aerosol');
    set(lh,'fontsize',10,'location','best');
    if savefigure;
        starsas(['star' daystr 'taus.fig']);
    end;
    
    % uncertainty components
    figure;
    if size(s.c0err,1)==1;
        mean_errs=[nanmean(tau_aero_err1.*ok,1)
            nanmean(s.tau_aero_err2.*ok,1)
            nanmean(s.tau_aero_err3.*ok,1)
            nanmean(s.tau_aero_err4.*ok,1)
            nanmean(s.tau_aero_err5.*ok,1)
            nanmean(s.tau_aero_err6.*ok,1)
            nanmean(s.tau_aero_err7.*ok,1)
            repmat(s.tau_aero_err8,size(s.w))
            nanmean(s.tau_aero_err9.*ok,1)
            repmat(s.tau_aero_err10,size(s.w))
            nanmean(s.tau_aero_err11.*ok,1)
            nanmean(s.tau_aero_err.*ok,1)];
    elseif size(s.c0err,1)==2;
        mean_errs=[nanmean(s.tau_aero_err1.*ok,1)
            abs(nanmean(s.tau_aero_err2lo.*ok,1))
            abs(nanmean(s.tau_aero_err2hi.*ok,1))
            nanmean(s.tau_aero_err3.*ok,1)
            nanmean(s.tau_aero_err4.*ok,1)
            nanmean(s.tau_aero_err5.*ok,1)
            nanmean(s.tau_aero_err6.*ok,1)
            nanmean(s.tau_aero_err7.*ok,1)
            repmat(s.tau_aero_err8,size(s.w))
            nanmean(s.tau_aero_err9.*ok,1)
            repmat(s.tau_aero_err10,size(s.w))
            nanmean(s.tau_aero_err11.*ok,1)
            nanmean(s.tau_aero_errlo.*ok,1)
            nanmean(s.tau_aero_errhi.*ok,1)];
    end;
    nerrs=size(mean_errs,1);
    h=loglog(s.w,mean_errs,s.w(aerosolcols),mean_errs(:,aerosolcols),'markersize',12,'linestyle','none');
    if size(s.c0err,1)==1;
        set(h(1+[0 nerrs]),'marker','s','color','b','markersize',3,'linewidth',1);
        set(h(2+[0 nerrs]),'marker','o','color','k','markersize',6,'linewidth',2);
        set(h(3+[0 nerrs]),'marker','d','color','k','markersize',6,'linewidth',1);
        set(h(4+[0 nerrs]),'marker','.','color','c');
        set(h(5+[0 nerrs]),'marker','.','color',[0.5 0 0.5]);
        set(h(6+[0 nerrs]),'marker','.','color','r');
        set(h(7+[0 nerrs]),'marker','.','color',[1 .5 0]);
        set(h(repmat([8 10 11]',1,2)+repmat([0 nerrs],3,1)),'marker','.','color',[.5 .5 .5],'markersize',6);
        set(h(9+[0 nerrs]),'marker','x', 'color', [0.75 0.25 0],'markersize',6,'linewidth',1);
        set(h(12+[0 nerrs]),'marker','+','color','m','markersize',6,'linewidth',2);
        lh=legend(h(nerrs+1:end),'Airmass','C0','dC (dark STD)','Rayleigh','O3','NO2','O2-O2','(H2O)','Tracking','(Diffuse Light)','(CO2,CH4,N2O)','Total');
    elseif size(s.c0err,1)==2;
        set(h(1+[0 nerrs]),'marker','s','color','b','markersize',3,'linewidth',1);
        set(h(2+[0 nerrs]),'marker','o','color','k','markersize',6,'linewidth',2);
        set(h(3+[0 nerrs]),'marker','o','color','k','markersize',6,'linewidth',2);
        set(h(4+[0 nerrs]),'marker','d','color','k','markersize',6,'linewidth',1);
        set(h(5+[0 nerrs]),'marker','.','color','c');
        set(h(6+[0 nerrs]),'marker','.','color',[0.5 0 0.5]);
        set(h(7+[0 nerrs]),'marker','.','color','r');
        set(h(8+[0 nerrs]),'marker','.','color',[1 .5 0]);
        set(h(repmat([9 11 12]',1,2)+repmat([0 nerrs],3,1)),'marker','.','color',[.5 .5 .5],'markersize',6);
        set(h(10+[0 nerrs]),'marker','x', 'color', [0.75 0.25 0],'markersize',6,'linewidth',1);
        set(h(13+[0 nerrs]),'marker','+','color','m','markersize',6,'linewidth',2);
        set(h(14+[0 nerrs]),'marker','+','color','m','markersize',6,'linewidth',2);
        lh=legend(h(nerrs+1:end),'Airmass','C0(lower)','C0(upper)','dC (dark STD)','Rayleigh','O3','NO2','O2-O2','(H2O)','Tracking','(Diffuse Light)','(CO2,CH4,N2O)','Total(lower)','Total(upper)');
    end;
    for i=1:nerrs;
        clr=get(h(i),'color');
        set(h(i),'color',clr/2+0.5);
    end;
    try
        gglwa; % fails when the plot is empty
    end;
    ylim([0.0001 0.03]);
    grid on;
    ylabel('mean tau_aero_err','interpreter','none');
    title(daystr);
    set(lh,'fontsize',10,'location','best');
    if savefigure;
        starsas(['star' daystr 'tauaeroerrs.fig']);
    end;
end % done with plotting sun results

return