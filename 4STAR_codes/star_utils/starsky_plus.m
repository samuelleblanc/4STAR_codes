function s = starsky_plus(s)
%  star = starsky_plus(star)
% Augments a supplied sky scan struct "star" with additional info needed to
% for running the AERONET retrieval
% These include AOD, TOD (total optical depth), CWV, Ozone, flight-level
% albedo and could include incorporation of flight telemetry to improve
% scattering angle accuracy.
if ~exist('s','var')
    sfile = getfullname('*SKY*.mat','starsky','Select star sky mat file.');
    s = load(sfile);
    if isfield(s,'s_out')
        s = s.s_out;
    end
end
if isfield(s,'filename')
    if iscell(s.filename)
        filename = s.filename{1};
    else
        filename = s.filename;
    end
    [p,skytag,x] = fileparts(strrep(filename,'\',filesep));
    skytag = strrep(skytag,'_VIS_','_');skytag = strrep(skytag,'_NIR_','_');
end
if isfield(s,'good_sky')&&~all(size(s.t)==size(s.good_sky))
    s.good_sky = s.good_sky';
end

! This is the wrong location to save mat files.
[pname_mat,~,~] = fileparts(filename);
if ~exist([pname_mat, filesep,skytag,'_starsky.mat'],'file')
    save([pname_mat, filesep,skytag,'_starsky.mat'], '-struct','s');
end
% Determine if on ground or airborne
if geodist(s.Lat(1),s.Lon(1),s.Lat(end),s.Lon(end)) > 1000
   % We are in the air so use ssfr or MODIS if no SSFR and below ???km
[s.sfc_alb, time_out] = get_ssfr_flight_albedo(mean(s.t), 1000.*s.w);
else 
   % Eventually pass in time or doy, but for now hardcode for SEACRS
   % s.brdf = get_modis_brdf(s.Lat(1),s.Lon(1),doy);
   s.brdf = get_modis_brdf(s.Lat(1),s.Lon(1));
   [wl, wl_ii] = sort(s.brdf(:,1));
   s.brdf = s.brdf(wl_ii,:);
   % We are on ground so use supplied or MODIS
end

sunfile = (getfullname(['4STAR_',datestr(s.t(1),'yyyymmdd'),'starsun.mat'],'starsun','Select a starsun file'));
if ~isempty(sunfile)
    if ~exist('fig3','var')
        fig3 = figure;
    end
    %             if ~isempty(get(gcf,'children'))
    %                 fig3 = figure;
    %             end
    if ~exist('fig2','var')
        fig2 = figure;
    end
    
    sun = matfile(sunfile);
    pp=numel(sun.t);
    qq=size(s.rate,2);
    dist = geodist(mean(s.Lat), mean(s.Lon), sun.Lat, sun.Lon)./1000;
    startime = sun.t;
    try
        anet = sun.aeronetcols;
    catch
        anet = [332 624  880];
    end
    tau_aero = sun.tau_aero;
%     tau_aero = tau_aero(:,anet);%tau_aero = tau_aero(:,anet);
    tau=real(-log(sun.rate./repmat(sun.f,1,qq)./repmat(sun.c0,pp,1))./repmat(sun.m_aero,1,qq));
%     tau = tau(:,anet);
    tau_O3 = sun.tau_O3; %tau_O3 = tau_O3(:,anet);
    try
        tau_aero_ns = sun.tau_aero_noscreening; 
        %tau_aero_ns = tau_aero_ns(:,anet);
    catch
        tau_aero_ns = tau_aero;
        disp('No unscreened tau')
    end
    try
        CWV = sun.CWV;
    catch
        disp('No CWV in this file')
        CWV = [];
    end
    
    figure(fig2)
    %                 ax2(1) = subplot(2,1,1);
    plot(startime, sun.Alt, 'o-', mean(s.t), mean(s.Alt),'rx'); legend('Alt', 'location','EastOutside');
    ylabel('Altitude')
    ax2(1) = gca;
    %             dynamicDateTicks;
    %                 ax2(2) = subplot(2,1,2);
    %                 plot(startime, dist, '-x', scan_table.time(r), 0, 'ro'); legend('geo dist', 'location','North');
    zoom('on')
    %             dynamicDateTicks
    
    figure(fig3);
    if ~isempty(CWV)
        ax3(1) = subplot(2,1,1);
        plot((sun.t), tau_aero(:,anet), 'o'); legend('440 nm','673 nm','873 nm', 'Location','EastOutside');
        yl = ylim;
        hold('on');
        plot(sun.t, real(tau_aero_ns(:,anet)), 'k.');
        plot(sun.t, real(tau_aero(:,anet)), 'o', [mean(s.t), mean(s.t)], yl,'r--'); ylim(yl)
        title('4STAR AODs')
        hold('off');
        ax3(2) = subplot(2,1,2);
        plot(startime, CWV, 'o'); yl2 = ylim;
        plot(startime, CWV, 'o',[mean(s.t), mean(s.t)], yl2,'r--');
        ylim(yl2);  legend('CWV','Location','EastOutside');
        %                 dynamicDateTicks;
    else
        
        plot((sun.t), real(tau_aero(:,anet)), 'o'); legend('440 nm','673 nm','873 nm', 'Location','EastOutside'); yl= ylim;
        plot((sun.t), real(tau_aero(:,anet)), 'o',[mean(s.t), mean(s.t)], yl,'r--', ...
            s.t([1 end]), ones([2,1])*s.tau_aero_skyscan, '-')
        yl= ylim;
        title('4STAR AODs')
        %                 dynamicDateTicks;
        ax3(1) = gca;
        
    end
    zoom('on')
    linkaxes([ax2 ax3],'x');
    dynamicDateTicks(ax2,'linked');
    dynamicDateTicks(ax3,'linked');
    K = menu('Zoom and select action','Good','Questionable','BAD','SKIP');
    if K <4
        xl = xlim;
        good_aod = startime>=xl(1) & startime<=xl(2) & tau_aero(:,anet(1))>0 &  tau_aero(:,anet(2))>0 &  tau_aero(:,anet(3))>0 ...
            & tau_aero(:,anet(1))<2& tau_aero(:,anet(2))<2& tau_aero(:,anet(3))<2&~isnan(tau_aero(:,anet(1)))&...
            ~isnan(tau_aero(:,anet(2)))&~isnan(tau_aero(:,anet(3)));
        s.tau_aero = mean(tau_aero(good_aod,:));
        if sum(good_aod)==0
            
            good_aod = startime>=xl(1) & startime<=xl(2) & tau_aero_ns(:,anet(1))>0 &  tau_aero_ns(:,anet(2))>0 &  tau_aero_ns(:,anet(3))>0 ...
                & tau_aero_ns(:,anet(1))<2& tau_aero_ns(:,anet(2))<2& tau_aero_ns(:,anet(3))<2&~isnan(tau_aero_ns(:,anet(1)))&...
                ~isnan(tau_aero_ns(:,anet(2)))&~isnan(tau_aero_ns(:,anet(3)));
            s.tau_aero = mean(tau_aero_ns(good_aod,:));
        end

        s.tau = mean(tau(good_aod,:));
        s.tau_O3 = mean(tau_O3(good_aod,:));
        if ~isempty(CWV)
            good_cwv = startime>=xl(1) & startime<=xl(2) & CWV>0 &~isnan(CWV);
            s.PWV = mean(CWV(good_cwv));
        end
    end
end


!!
if ~isfield(s,'PWV')
    s.PWV = 1.7;
end
if ~isfield(s,'O3col')
    s.O3col=0.330;
end
if s.O3col>1
    s.O3col = s.O3col./1000;
end
% if ~isfield(s,'wind_speed')
%     s.wind_speed= 7.5;
% end
% for SEAC4RS
s.land_fraction = 1;
% Should replace this with an actual determination based on a land-surface
% mapping.
s.rad_scale = 1; % This is an adhoc means of adjusting radiance calibration for whatever reason.
s.flight_level = mean(s.Alt); % picking very low "ground level" sufficient for sea level or AMF ground level.
% Should replace this with an actual determination based on a land-surface mapping.
% Both gen_sky_inp_4STAR and gen_aip_cimel_need to be modified.

[pname_mat,~,~] = fileparts(filename);
if exist([pname_mat, filesep,skytag,'_starsky.mat'],'file')
    delete([pname_mat, filesep,skytag,'_starsky.mat']);
end
save([pname_mat, filesep,skytag,'_starsky.mat'], '-struct','s');


return
