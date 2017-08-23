function s = select_skyscan_tau(s)

sunfile = (getfullname(['4STAR_',datestr(s.t(1),'yyyymmdd'),'starsun.mat'],'starsun','Select a starsun file'));
if ~isempty(sunfile)
    if ~exist('fig3','var')
        fig3 = figure_;
    end

    if ~exist('fig2','var')
        fig2 = figure_;
    end
    
    sun = matfile(sunfile);
    props = properties(sun);
    pp=numel(sun.t);
    qq=size(s.rate,2);
    dist = geodist(mean(s.Lat), mean(s.Lon), sun.Lat, sun.Lon)./1000;
    startime = sun.t;
    if any(strcmp('aeronetcols',props))
       anet = sun.aeronetcols;
    else
       anet = [332 624  880];
    end
    tau_aero = sun.tau_aero;
%     tau_aero = tau_aero(:,anet);%tau_aero = tau_aero(:,anet);
    tau=real(-log(sun.rate./repmat(sun.f,1,qq)./repmat(sun.c0,pp,1))./repmat(sun.m_aero,1,qq));
%     tau = tau(:,anet);
    tau_O3 = sun.tau_O3; %tau_O3 = tau_O3(:,anet);
    if any(strcmp('tau_aero_noscreening',props))
        tau_aero_ns = sun.tau_aero_noscreening; 
        %tau_aero_ns = tau_aero_ns(:,anet);
    else
        tau_aero_ns = tau_aero;
        disp('No unscreened tau')
    end
    if any(strcmp('CWV',props))
        CWV = sun.CWV;
    else
        disp('No CWV in this file')
        CWV = [];
    end
    
    figure_(fig2);
    %                 ax2(1) = subplot(2,1,1);
    plot(startime, sun.Alt, 'o-', mean(s.t), mean(s.Alt),'rx'); legend('Alt', 'location','EastOutside');
    ylabel('Altitude')
    ax2(1) = gca;
    %             dynamicDateTicks;
    %                 ax2(2) = subplot(2,1,2);
    %                 plot(startime, dist, '-x', scan_table.time(r), 0, 'ro'); legend('geo dist', 'location','North');
    zoom('on')
    %             dynamicDateTicks
    
    figure_(fig3);
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
        plot((sun.t), real(tau_aero(:,anet)), 'o',[mean(s.t), mean(s.t)], yl,'r--'); yl= ylim;
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
            & tau_aero(:,anet(1))<2& tau_aero(:,anet(2))<2& tau_aero(:,anet(3))<2&~isNaN(tau_aero(:,anet(1)))&...
            ~isNaN(tau_aero(:,anet(2)))&~isNaN(tau_aero(:,anet(3)));
        s.tau_aero = mean(tau_aero(good_aod,:));
        s.tau_aero_std = std(tau_aero(good_aod,:));
        if sum(good_aod)==0            
            good_aod = startime>=xl(1) & startime<=xl(2) & tau_aero_ns(:,anet(1))>0 &  tau_aero_ns(:,anet(2))>0 &  tau_aero_ns(:,anet(3))>0 ...
                & tau_aero_ns(:,anet(1))<2& tau_aero_ns(:,anet(2))<2& tau_aero_ns(:,anet(3))<2&~isNaN(tau_aero_ns(:,anet(1)))&...
                ~isNaN(tau_aero_ns(:,anet(2)))&~isNaN(tau_aero_ns(:,anet(3)));
            s.tau_aero = mean(tau_aero_ns(good_aod,:));
        end
        s.tau = mean(tau(good_aod,:)); 
        s.tau_std = std(tau(good_aod,:));
        s.tau_O3 = mean(tau_O3(good_aod,:)); 
        if ~isempty(CWV)
            good_cwv = startime>=xl(1) & startime<=xl(2) & CWV>0 &~isNaN(CWV);
            s.PWV = mean(CWV(good_cwv));
        end
    end
end


return