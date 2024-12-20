function SEstarbasicplots(daystr, platform, savefigure);

% SEstarbasicplots(DAYSTR, PLATFORM, SAVEFIGURE) generates basic plots of
% SEAC4RS 4STAR data for the single day specified by DAYSTR and for the
% PLATFORM. DAYSTR is a string of 8 numbers, such as '20130821'. PLATFORM
% is either 'flight' or 'ground'. The third and optional input, SAVEFIGURE,
% determines whether the figures are saved. This code requires a starinfo
% file (e.g., starinfo20130821.m) with the following field: 
% 'flight': a 1x2 vector that indicates [take-off landing] times.
%
% Example:
%     % create a starsun.mat file unless it already exists.
%     daystr='20130821'; 
%     allstarmat; % create a star.mat; after this, put the 'flight' [take-off landing] times in starinfo....m, run figure;spvis(daystr,'t','Alt','.');
%     starsun(fullfile(starpaths, [daystr 'star.mat']),fullfile(starpaths, [daystr 'starsun.mat'])); % create a starsun.mat
%     % generate routine figures.
%     SEstarbasicplots(daystr, 'flight', 1); % after this, add manually flight notes, pictures, additional figures (spectra!!), etc.
%     SEstarbasicplots(daystr, 'ground', 1); % after this, add manually pictures, additional figures (spectra!!), etc.
%
% See SEquickplots.m for plots for multiple days, ad hoc analyses, etc.
% 
% Yohei, 2013/06/17, being modified from TCquickplots.m.
% Yohei, 2013/07/28, reorganized

%********************
% set parameters
%********************
if nargin<3;
    savefigure=false;
end;
if ismember(lower(platform), {'f' 'flight' 'flt' 'dc8'});
    platform='flight';
elseif ismember(lower(platform), {'g' 'ground' 'grd'});
    platform='ground';
else
    error('platform must be either flight or ground.');
end;

%********************
% prepare for plotting
%********************
% load frequently used variables
starload(daystr, 'track');
%starload(strcat('C:\MatlabCodes\data\',daystr,'\'), 'track');
track.T=[track.T1 track.T2 track.T3 track.T4];
track.P=[track.P1 track.P2 track.P3 track.P4];
bl=60/86400;
for i=1:4;
    track.Tsm(:,i)=boxxfilt(track.t, track.T(:,i), bl);
    track.Psm(:,i)=boxxfilt(track.t, track.P(:,i), bl);
end;
clear i;
slsun(daystr, 't', 'w', 'Alt', 'aerosolcols', 'viscols', 'nircols', ...
    'tau_aero', 'tau_aero_noscreening', 'raw', 'm_aero', 'QdVlr', 'QdVtb', 'QdVtot');
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t);
c=[visc(1:10) nirc(11:13)+1044];
colslist={'' c 1:13
    'VISonly' visc(3:9) 3:9 
    'NIRonly' nirc(11:13)+1044 11:13};

% read auxiliary data from starinfo and select rows
evalstarinfo(daystr, 'flight');
if isequal(platform, 'flight');
    if ~exist('flight');
        error(['Specify flight time period in starinfo' daystr '.m.']);
    end;
    tlim=flight;
elseif isequal(platform, 'ground');
    if exist('flight');
        tlim=NaN(size(flight,1)+1,2);
        tlim(1,1)=t(1);
        tlim(end,2)=t(end);
        tlim(1:end-1,2)=flight(:,1);
        tlim(2:end,1)=flight(:,2);
    else
        tlim=t([1 end])';
    end;
    evalstarinfo(daystr, 'groundcomparison');
    if ~exist('groundcomparison');
        groundcomparison=tlim;
    end;
end;

% prepare common lines
mods={'tlim', tlim, ...
    'title', [daystr ' ' platform], ...
    'savefigure', savefigure};
if isequal(platform, 'flight');
    vars.xtlim={'xlim', [min(flight(:)) max(flight(:))]+60/86400*[-1 1]};
    vars.Alt={'t', Alt, '-k'};
    vars.Alt1e4={'t', Alt/1e4, '-k'};
    vars.Alt1e5={'t', Alt/1e5, '-k'};
elseif isequal(platform, 'ground');
    vars.xtlim={'xlim', t([1 end])'+60/86400*[-1 1]};
    vars.Alt={};
    vars.Alt1e4={};
    vars.Alt1e5={};
end;

% prepare to save a PowerPoint file
pptcontents={}; % pairs of a figure file name and the number of figures per slide
pptcontents0={};
[~, figurefolder]=starpaths;

%********************
% generate map, altitude and airmasses
%********************
if isequal(platform, 'flight');
    % flight track map
    figure;
    [h,filename]=ssvis(daystr, 'Lon', 'Lat', 24, 't', mods{:});
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
    % altitude 
    figure;
    [h,filename]=spvis(daystr, 't', 'Alt', '.', vars.xtlim{:}, ...
        'tlim', tlim, ...
    'title', [daystr ' ' platform]);
    for i=1:numel(h);
        set(h(i), 'ydata', get(h(i),'ydata')/1e3);
    end;
    yl=ylim;
    ylim([0 max(yl)]/1000);
    lh=legend;
    lstr=get(lh,'string');
    hold on;
    h2=spsun(daystr, 't', 'm_ray', '.b', 't', 'm_aero', '.c', vars.xtlim{:}, 'tlim', tlim);
    lstr=[lstr {'m_ray'} {'m_aero'}];
    ylabel('Altitude (km) or Airmass');
    lh=legend([h; h2], lstr);
    set(lh,'interpreter','none','fontsize',12,'location','best');
    if savefigure;
        starsas([filename '.fig, ' mfilename '.m']);
    end;
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
    % longitude and altitude
    figure;
    [h,filename]=ssvis(daystr, 'Lon', 'Alt', 24, 't', mods{:});
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
    % latitude and altitude
    figure;
    [h,filename]=ssvis(daystr, 'Lat', 'Alt', 24, 't', mods{:});
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
elseif isequal(platform, 'ground');
     % latitude and altitude
    figure;
    [h,filename]=spsun(daystr, 't', 'm_ray', 'b.','t', 'm_aero', 'c.', vars.xtlim{:}, mods{:});
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
end;

%********************
% inspect environmental and instrument conditions
%********************
% T&P from track
for ii={'T' 'P'};
    ysm=track.([ii{:} 'sm']);
    figure;
    plot(track.t, ysm, '.');
    set(gca,'xlim', vars.xtlim{2});
    lh=legend(starfieldname2label([ii{:} '1']),starfieldname2label([ii{:} '2']),starfieldname2label([ii{:} '3']),starfieldname2label([ii{:} '4']));
    set(lh,'fontsize',12,'location','best');
    ggla;
    grid on;
    dateticky('x','keeplimits');
    ylabel([ii{:} ', smoothed over ' num2str(bl*86400) ' s']);
    title([daystr ' ' platform]);
    filename=['star' daystr platform 'track' ii{:} 'smtseries'];
    if savefigure;
        starsas([filename '.fig, ' mfilename '.m'])
    end;
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
end;
clear ii;

% T&RH
figure;
[h,filename]=spsun(daystr, 't', 'RHprecon_percent', '.', ...
    't', 'Tprecon_C', '.', ...
    't', 'Tbox_C', '.', ...
    'ylim', [0 40], ...
    vars.xtlim{:}, mods{:});
pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
    
% Pst
figure;
[h,filename]=spvis(daystr, 't', 'Pst', '.', vars.xtlim{:}, mods{:});
pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];

% Tst
figure;
[h,filename]=spvis(daystr, 't', 'Tst', '.', vars.xtlim{:}, mods{:});
pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];

% Tint
figure;
[h,filename]=spvisnir(daystr, 't', 'Tint', '.', vars.xtlim{:}, mods{:});
% pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];

% motors
figure;
[h,filename]=spsun(daystr, 't', 'AZ_deg', '.', ...
    't', 'El_deg', '.', ...
    vars.xtlim{:}, mods{:});
pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
pptcontents0=[pptcontents0; {' ' 4}];
pptcontents0=[pptcontents0; {' ' 4}];

% quad
figure;
ax(1)=subplot(5,1,1:4);
[h,filename]=spsun(daystr, 't', QdVlr./QdVtot, '>', ...
    't', QdVtb./QdVtot, 'v', ...
    'tlim', tlim, 'title', [daystr ' ' platform], ...
    vars.xtlim{:});    
set(h, 'linewidth',1);
grid on;
dateticky('x','keeplimits');
ylabel('Quad Signal Ratio');
ylim([-0.6 0.6]);
lh=legend('(Left-Right) / Total', '(Top-Bottom) / Total');
set(lh, 'location', 'best', 'fontsize',12);
ax(2)=subplot(5,1,5);
h2=spvis(daystr, 't', 'Str', 'rs', 't', 'Md', '.k', 't', 'Zn', 'o', ...
    'linewidth',1);
% set(h2(1), 'markersize',6);
% set(h2(2), 'markersize',12);
% set(h2(3), 'markersize',3, 'color',[.5 .5 .5]);
lh2=legend;
set(lh2,'fontsize',8);
dateticky('x','keeplimits');
axis tight;
linkaxes(ax,'x');
filename=['star' daystr platform 'QuadSignalRatiotseries'];
if savefigure;
    starsas([filename '.fig, ' mfilename '.m'])
end;
pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];

%********************
% plot spectra, of 4STAR only
%********************
% raw count
figure;
[h,filename]=spsun(daystr, 't', 'raw', '.', vars.Alt{:}, mods{:}, ...
    'cols', c, ...
    'filename', ['star' daystr platform 'rawcounttseries']);
pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];

% tau aero noscreening
if exist('tau_aero_noscreening');
    for k=1:size(colslist,1); % for multiple sets of wavelengths
        figure;
        [h,filename]=spsun(daystr, 't', tau_aero_noscreening, '.', vars.Alt1e4{:}, mods{:}, ...
            'cols', colslist{k,2}, 'ylabel', 'tau_aero_noscreening', ...
            'filename', ['star' daystr platform 'tau_aero_noscreeningtseries' colslist{k,1}]);
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
    end;
end;

% tau aero
for k=1:size(colslist,1); % for multiple sets of wavelengths
    if k==1 | k==2;
        yl=[0 max(max(tau_aero(incl(t,tlim),colslist{k,2})))];
    end;
    figure;
    [h,filename]=spsun(daystr, 't', tau_aero, '.', vars.Alt1e4{:}, mods{:}, ...
        'cols', colslist{k,2}, 'ylabel', 'tau_aero', ...
        'ylim', yl, ...
        'filename', ['star' daystr platform 'tau_aerotseries' colslist{k,1}]);
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
end;

% tau aero after correction based on AATS
if ~exist('tau_aero_scaled') && exist(fullfile(starpaths, ['star' daystr 'c0corrfactor.dat']))==2;
    c0corrfactor=load(fullfile(starpaths, ['star' daystr 'c0corrfactor.dat']));
    tau_aero_scaled=tau_aero+(1./m_aero)*log(c0corrfactor);
end;
if exist('tau_aero_scaled');
    for k=1:size(colslist,1); % for multiple sets of wavelengths
        figure;
        [h,filename]=spsun(daystr, 't', tau_aero_scaled, '.', vars.Alt1e5{:}, mods{:}, ...
            'cols', colslist{k,2}, 'ylabel', 'tau_aero_scaled', ...
            'filename', ['star' daystr platform 'tau_aero_scaledtseries' colslist{k,1}]);
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
    end;
end;

%********************
% plot spectra in comparison with AATS-14
%********************
if isequal(platform, 'ground') && exist(fullfile(starpaths, [daystr 'aats.mat']))==2;
    [both, ~, aats]=staraatscompare(daystr);
    both.rows=incl(both.t, tlim);
    % 4STAR AATS time-series comparison, wavelength by wavelength
    for ii=[1:9 11:13];
        figure;
        if isfield(both, 'tau_aero') & isfield(both, 'dtau_aero');
            ph=plot(both.t(both.rows),both.tau_aero(both.rows,c(ii)), '.', ...
                aats.t,aats.tau_aero(ii,:), '.', ...
                both.t(both.rows), both.dtau_aero(both.rows,ii), '.', ...
                both.t(both.rows), both.trratio(both.rows,ii)-1, '.');
            vali=find(isfinite(both.dtau_aero(both.rows,ii))==true);
            xlim(both.t(both.rows(vali([1 end])))'+[-1 1]*60/86400);
            hold on
            plot(xlim, [0 0], '-k');
            ystr='tau aero, \Deltatau aero, Tr Ratio';
            yl=ylim;
            ylim([min([max([yl(1) -.1]) -0.1]) max([min([yl(2) .1]) 0.1])]);
            set(gca,'ytick',[-0.5:0.1:-0.2 -0.1:0.01:0.1 0.2:0.1:0.5]);
            lh=legend(ph, ['4STAR ' num2str(both.w(c(ii))*1000, '%0.2f') ' nm'],...
                ['AATS ' num2str(aats.w(ii)*1000, '%0.2f') ' nm'], ...
                '4STAR-AATS', ...
                'Transmittance Ratio, 4STAR/AATS, -1');
        elseif isfield(both, 'tau_aero_noscreening');
            ph=plot(both.t(both.rows),both.tau_aero_noscreening(both.rows,c(ii)), '.', ...
                aats.t,aats.tau_aero(ii,:), '.', ...
                both.t(both.rows), both.dtau_aero(both.rows,ii), '.');
            xl=xlim;
            xlim([max([xl(1) floor(t(1))]) min([xl(2) floor(t(end))])])
            ystr='tau aero noscreening';
            yl=ylim;
            ylim([max([yl(1) 0]) min([yl(2) 0.5])]);
            lh=legend(ph, ['4STAR ' num2str(both.w(c(ii))*1000, '%0.2f') ' nm'],['AATS ' num2str(aats.w(ii)*1000, '%0.2f') ' nm']);
        else; % no longer used; for record keeping
            ph=plot(both.t(both.rows),both.tau_aero_noscreening(both.rows,c(ii)), '.b', ...
                both.t(both.rows),both.tau_aero_noscreening(both.rows,c(ii))-repmat(tau_aero_ref(c(ii)),size(both.rows)), '.b', ...
                aats.t,aats.tau_aero(ii,:), '.');
            set(ph(1),'color',[0.5 0.5 0.5]);
            set(ph(end),'color',[0 0.5 0],'markersize',12);
            xl=xlim;
            xlim([max([xl(1) floor(t(1))]) min([xl(2) floor(t(end))])])
            ystr='tau aero noscreening';
            yl=ylim;
            ylim([max([yl(1) 0]) min([yl(2) 0.5])]);
            lh=legend(ph, ['4STAR ' num2str(both.w(c(ii))*1000, '%0.2f') ' nm'],['AATS ' num2str(aats.w(ii)*1000, '%0.2f') ' nm']);
        end;
        ggla;
        grid on;
        dateticky('x','keeplimits');
        xlabel('Time');
        ylabel(ystr);
        title(daystr);
        set(lh,'fontsize',12,'location','best');
        filename=['star' daystr 'AATS' ystr(regexp(ystr,'\w')) '_' num2str(aats.w(ii)*1000, '%0.0f') 'nm'];
        if savefigure;
            starsas([filename '.fig, ' mfilename '.m'])
        end;
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
    end
    
    % time series of the delta tau_aero at all overlapping wavelengths
    if isfield(both, 'tau_aero') & isfield(both, 'dtau_aero');
        for k=1:size(colslist,1); % for multiple sets of wavelengths
            cols=colslist{k,3};
            figure;
            ph=plot(both.t(both.rows), both.dtau_aero(both.rows,cols), '.');
            vali=find(any(isfinite(both.dtau_aero(both.rows,cols)),2)==true);
            xlim(both.t(both.rows(vali([1 end])))'+[-1 1]*60/86400);
            hold on
            plot(xlim, [0 0], '-k');
            ystr='\Deltatau aero, 4STAR-AATS';
            ylabel(ystr);
            ylim([-0.1 0.1]);
            yl=ylim;
            ylim([min([max([yl(1) -1]) -0.1]) max([min([yl(2) 1]) 0.1])]);
            set(gca,'ytick',[-0.5:0.1:-0.2 -0.1:0.01:0.1 0.2:0.1:0.5]);
            ggla;
            grid on;
            dateticky('x','keeplimits');
            xlabel('Time');
            title(daystr);
            lstr=setspectrumcolor(ph, aats.w(cols));
            lh=legend(ph,lstr);
            set(lh,'fontsize',12,'location','best');
            filename=['star' daystr 'AATS' ystr(regexp(ystr,'\w')) colslist{k,1}];
            if savefigure;
                starsas([filename '.fig, ' mfilename '.m'])
            end;
            pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
        end;
    end;
    
    % transmittance ratio, 4STAR/AATS, against wavelengths
    if ~exist('groundcomparison');        
        rows=incl(both.t, groundcomparison);
        % extrapolate to non-AATS wavelengths
        aatsgoodviscols=[2:7 9];
        aatsgoodnircols=[11 13]; % "You should ignore AATS 1.2 um." says Phil, Aug. 13, 2013.
        %         visc0corrfactor=interp1(aats.w(aatsgoodviscols), nanmean(both.trratio(rows,aatsgoodviscols),1), w, 'cubic');
%         [p,S] = polyfit(log(aats.w(aatsgoodviscols)),nanmean(both.trratio(rows,aatsgoodviscols),1),2);
        [p,S] = polyfit(log(aats.w(aatsgoodviscols)),nanmedian(both.trratio(rows,aatsgoodviscols),1),2);
        visc0corrfactor=polyval(p,log(w));
        %         nirc0corrfactor=interp1(aats.w(aatsgoodnircols), nanmean(both.trratio(rows,aatsgoodnircols),1), w, 'cubic');
%         [p,S] = polyfit(log(aats.w(aatsgoodnircols)),nanmean(both.trratio(rows,aatsgoodnircols),1),2);
        [p,S] = polyfit(log(aats.w(aatsgoodnircols)),nanmedian(both.trratio(rows,aatsgoodnircols),1),2);
        nirc0corrfactor=polyval(p,log(w));
        c0corrfactor=[visc0corrfactor(1:1044) nirc0corrfactor(1044+(1:512))];
        save(fullfile(starpaths, ['star' daystr 'c0corrfactor.dat']), 'c0corrfactor', '-ascii'); !!! format and locate this line better
        tau_aero_scaled=tau_aero+(1./m_aero)*log(c0corrfactor);
        % plot tr ratio
        figure;
        %         sh=semilogx(aats.w(1:13), both.trratio(rows,:), 'c.', ...
        %             w, c0corrfactor, '.m', ...
        %             w([1 end]), [1 1], '-k');
%         set(sh(1:end-2),'markersize',24);
        xxs=repmat(aats.w(1:13),size(rows));
        yys=both.trratio(rows,:);
        ccs=24*ones(size(both.trratio(rows,:)));
        sss=repmat(both.t(rows),1,size(both.trratio,2));
        sh=scatter(xxs(:), yys(:), ccs(:), sss(:));
        ch=colorbarlabeled('UTC');
        datetick(ch,'y','keeplimits');
            hold on;
        plot(w, c0corrfactor, '.m', ...
            w([1 end]), [1 1], '-k');
        gglwa;
        grid on;
        ylim([0.8 1.2]);
        xlabel('Wavelength (nm)');
        ylabel('Tr. Ratio, 4STAR/AATS');
        title([daystr ' ' datestr(groundcomparison(1), 13) ' - ' datestr(groundcomparison(end), 13)]);
        filename=['star' daystr datestr(groundcomparison(1), 'HHMMSS') datestr(groundcomparison(end), 'HHMMSS') 'AATStrratio'];
        if savefigure;
            starsas([filename '.fig, ' mfilename '.m'])
        end;
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
        % plot spectra
        figure;
        h=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
        set(h, 'color',[.5 .5 .5]);
        hold on;
        hcorr=starplotspectrum(w, nanmean(tau_aero_scaled(rows,:),1), aerosolcols, viscols, nircols);
        %         set(gca,'yscale','linear');
        gglwa;
        ylim([0.01 1]);
        grid on;
        xlabel('Wavelength (nm)');
        ylabel('Optical Depth');
        title([daystr ' ' datestr(groundcomparison(1), 13) ' - ' datestr(groundcomparison(end), 13)]);
        filename=['star' daystr datestr(groundcomparison(1), 'HHMMSS') datestr(groundcomparison(end), 'HHMMSS') 'tau_aero_scaledspectra'];
        if savefigure;
            starsas([filename '.fig, ' mfilename '.m'])
        end;
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
    end;
    
% % %     % spectra, average
% % %     figure;
% % %     ok=both.rowscomparison;
% % %     aats.ok=interp1(aats.t,1:numel(aats.t),both.t(ok),'nearest');
% % %     aats.ok=unique(aats.ok(isfinite(aats.ok)));
% % %     h=starplotspectrum(w, nanmean(both.tau_aero(ok,:)), aerosolcols, viscols, nircols);
% % %     hold on;
% % %     ah=plot(aats.w, nanmean(aats.tau_aero(:,aats.ok)'), '.', 'markersize',12,'color', [0 0.5 0]);
% % %     % starttstr=datestr(tlim(1),13);
% % %     % stoptstr=datestr(tlim(2),13);
% % %     ylabel('Optical Depth');
% % %     % title([refdaystr ' on the ground ' starttstr ' - ' stoptstr]);
% % %     title([daystr ' MLO']);
% % %     % lh=legend([h(2) h2(2) ah], 'TCAP winter cal', 'high alt subtracted', 'AATS-14');
% % %     % set(lh,'fontsize',12,'location','best');
% % %     if savefigure;
% % %         %     starsas(['star' daystr datestr(tlim(1),'HHMMSS') datestr(tlim(2),'HHMMSS') 'ground_tau_aero.fig, SEquickplots.m'])
% % %         starsas(['star' daystr 'ground_tau_aero.fig, SEquickplots.m'])
% % %     end;
% % %     
% % %     % spectra, individual
% % %     figure;
% % %     ok=both.rowscomparison;
% % %     aats.ok=interp1(aats.t,1:numel(aats.t),both.t(ok),'nearest');
% % %     aats.ok=unique(aats.ok(isfinite(aats.ok)));
% % %     h=starplotspectrum(w, both.tau_aero(ok,:), aerosolcols, viscols, nircols);
% % %     hold on;
% % %     ah=plot(aats.w, aats.tau_aero(:,aats.ok)', '.', 'markersize',12,'color', [0 0.5 0]);
% % %     % starttstr=datestr(tlim(1),13);
% % %     % stoptstr=datestr(tlim(2),13);
% % %     ylabel('Optical Depth');
% % %     % title([refdaystr ' on the ground ' starttstr ' - ' stoptstr]);
% % %     title([daystr ' MLO']);
% % %     lh=legend([h(2) h2(2) ah], 'TCAP winter cal', 'high alt subtracted', 'AATS-14');
% % %     set(lh,'fontsize',12,'location','best');
% % %     if savefigure;
% % %         starsas(['star' daystr datestr(tlim(1),'HHMMSS') datestr(tlim(2),'HHMMSS') 'ground_tau_aero.fig, SEquickplots.m'])
% % %     end;
    
%     % 4STAR/AATS ratio (not normalized) v. airmass
%     figure;
%     cols=find(isfinite(both.c(2,:))==1);
%     ph=plot(both.m_aero, both.rateratiotoaats(:,cols), '.');
%     xlabel('Aerosol Airmass Factor');
%     ylabel('4STAR/AATS');
%     ggla;
%     grid on;
%     lstr=setspectrumcolor(ph, both.w(both.c(2,cols)));
%     title(daystr);
%     lh=legend(ph,lstr);
%     set(lh,'fontsize',12,'location','best');
%     if savefigure;
%         starsas(['star' daystr 'rateratiotoAATSvm_aero'  '.fig, SEquickplots.m'])
%         pause(3);
%     end;
%     set(ph([1 2 10:end]), 'visible','off','markersize',1);
%     set(lh,'fontsize',12,'location','best');
%     if savefigure;
%         starsas(['star' daystr 'rateratiotoAATSvm_aero' 'VISonly.fig, SEquickplots.m'])
%         pause(3);
%     end;
%     ylim([0 2]);
%     set(ph([1 2 10:end]), 'visible','on','markersize',6);
%     set(ph([1:10]), 'visible','off','markersize',1);
%     set(lh,'fontsize',12,'location','best');
%     if savefigure;
%         starsas(['star' daystr 'rateratiotoAATSvm_aero' 'NIRonly.fig, SEquickplots.m'])
%         pause(3);
%     end;
%     
%     % 4STAR/AATS ratio normalized v. airmass
%     figure;
%     cols=find(isfinite(both.c(2,:))==1);
%     ph=plot(both.m_aero, both.raterelativeratiotoaats(:,cols), '.');
%     hold on;
%     plot(xlim, [1 1], '-k');
%     xlabel('Aerosol Airmass Factor');
%     ylabel(['4STAR/AATS, ' datestr(both.t(both.noonrow),13) '=1']);
%     ylim([0.96 1.04]);
%     ggla;
%     grid on;
%     lstr=setspectrumcolor(ph, both.w(both.c(2,cols)));
%     title(daystr);
%     lh=legend(ph,lstr);
%     set(lh,'fontsize',12,'location','best');
%     if savefigure;
%         starsas(['star' daystr 'raterelativeratiotoAATSvm_aero'  '.fig, SEquickplots.m'])
%         pause(3);
%     end;
%     ylim([0.94 1.02])
%     set(ph([1 2 10:end]), 'visible','off','markersize',1);
%     set(lh,'fontsize',12,'location','best');
%     if savefigure;
%         starsas(['star' daystr 'raterelativeratiotoAATSvm_aero' 'VISonly.fig, SEquickplots.m'])
%         pause(3);
%     end;
%     set(ph([1 2 10:end]), 'visible','on','markersize',6);
%     set(ph([1:10]), 'visible','off','markersize',1);
%     set(lh,'fontsize',12,'location','best');
%     if savefigure;
%         starsas(['star' daystr 'raterelativeratiotoAATSvm_aero' 'NIRonly.fig, SEquickplots.m'])
%         pause(3);
%     end;
end;

%********************
% Generate a new PowerPoint file
%********************
if savefigure;
    % sort out the PowerPoint contents
    idx4=[];
    for ii=1:size(pptcontents0,1);
        if pptcontents0{ii,2}==1;
            pptcontents=[pptcontents; {pptcontents0(ii,1)}];
        elseif pptcontents0{ii,2}==4;
            idx4=[idx4 ii];
            if numel(idx4)==4 || ii==size(pptcontents0,1) || pptcontents0{ii+1,2}~=4;
                if numel(idx4)>=3;
                    pptcontents=[pptcontents; {pptcontents0(idx4,1)}];
                else
                    pptcontents=[pptcontents; {[pptcontents0(idx4,1);' ';' ']}];
                end;
                idx4=[];
            end;
        else
            error('Paste either 1 or 4 figures per slide.');
        end;
    end;
    pptfilename=fullfile(figurefolder, [daystr platform '.ppt']);
%     makeppt(pptfilename, [daystr ' ' platform], pptcontents{:});
end;
