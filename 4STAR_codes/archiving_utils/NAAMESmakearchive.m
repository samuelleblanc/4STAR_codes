% Generates SEAC4RS archive files. 
% Prior to running this code, update the template file.
% Yohei, 2013/07/25, after TCmakearchive.m.
% Yohei, 2014/04/07, updated for R0 submission.

% set variables
prefix='NAAMES-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV'; 
platform='C130';    
R='A'; % '0'; % A; % revision number; if 0 or a string, no uncertainty will be saved.
if isempty(str2num(R)); % in field
    dnlist=datenum(2015,11,1)+(1:30)-1; % look for 'flight' in starinfo files
    dslist={} ;
    for i=1:numel(dnlist);
        clear flight;
        daystr=datestr(dnlist(i), 'yyyymmdd');
        starinfofile=fullfile(starpaths, ['starinfo' daystr '.m']);
        if exist(starinfofile);
            evalstarinfo(daystr, 'flight');
            if exist('flight');
                dslist=[dslist daystr];
            end;
        end;
    end;
    clear i;
    datamanager=[repmat({'Yohei'},size(dslist)) repmat({'Samuel'},1,0)];
    % account for the time differences between starsun.mat and ict.dat; a
    % kind of ad hoc adjustment often needed for a quick turnout in the field
    tadd=zeros(size(dslist));
    tadd([])=86400; % add seconds
    tend=NaN(size(dslist));
    tend([])=87370; % the last time stamp
    tend([])=87996; % the last time stamp
else; % post field
    !!! SEAC4RS version, to be updated
    dslist={'20130806' '20130808' '20130812' '20130814' '20130816' '20130819' '20130821' '20130823' '20130826' '20130827' '20130830' '20130902' '20130904' '20130906' '20130909' '20130911' '20130913' '20130916' '20130918' '20130921' '20130923'} ; % put one day string
    datamanager=[repmat({'John'},1,7) repmat({'Yohei'},1,4) repmat({'Meloe'},1,2) {'Yohei'} repmat({'Meloe'},1,5) {'Connor'} {'Michal'}];    
end;
dsexcludeAOD={}; % don't include any data for the days listed in this variable

% generate files
for i=1:length(dslist);
    % get the flight time period
    daystr=dslist{i};
    evalstarinfo(dslist{i}, 'flight');
    
    % read data to be saved
    if isequal(prefix,'NAAMES-4STAR-AOD');
        if ismember(dslist{i}, dsexcludeAOD); % exclude the day when no sun measurements were made.
            tosave=[];
            warning(['For the ' dslist{i} ' file, add "No AOD measurements were made on this flight." to the header.']);
        elseif isempty(str2num(R)); % all other days, in field
            clear tau_aero_noscreening tau_aero_err;
            starfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
            load(starfile,'t','w','Lat','Lon','Alt','tau_aero', 'tau_aero_noscreening', 'tau_aero_err', 'note');
            if ~exist('tau_aero_noscreening');
                load(starfile, 'm_aero', 'rateaero', 'c0');
                tau_aero_noscreening=-log(rateaero./repmat(c0,size(t)))./repmat(m_aero,size(w)); % aerosol optical depth before flags are applied
                clear rateaero c0 m_aero
            end;
            [visc,nirc,viscrange,nircrange]=starchannelsatNAAMESArchive(t);
            c=[visc(isfinite(visc)) nirc(isfinite(nirc))+1044];
            qual_flag=isnan(sum(tau_aero(:,c),2));
            % Code developers: for a treatment of asymmetric error
            % estimates, see TCmakearchival.m. 
            if ischar(R) || R==0; % don't include uncertainty at this point
                tosave=[round((t-floor(t(1)))*86400) Lat Lon Alt qual_flag tau_aero_noscreening(:,c)];
            elseif exist('tau_aero_err');
                tau_aero_err(isnan(tau_aero))=nan;
                tosave=[round((t-floor(t(1)))*86400) Lat Lon Alt qual_flag tau_aero(:,c) tau_aero_err(:,c)];
            end;
            tosave(isfinite(tosave)==0 | imag(tosave)~=0)=-9999;
            % return the flight segment of data only
            tosave0=tosave(incl(t, flight),:);
            % insert lines to make the time interval ALWAYS 1 second
            clear tosave;
            if ~isfinite(tend(i));
                tosave=(tosave0(1,1):1:tosave0(end,1))';
            else
                tosave=(tosave0(1,1):1:tend(i))';
            end;
            [~,ia,ib]=intersect(tosave, tosave0(:,1));
            tosave=[tosave -9999*ones(size(tosave,1), size(tosave0,2)-1)];
            tosave(ia, 2:end)=tosave0(ib,2:end);
        elseif isequal(R, '0'); % all other days, post field
    !!! SEAC4RS version, to be updated
            % load data
            starfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
            vars={'t','w','Lat','Lon','Alt','tau_aero_noscreening' 'flagallcols'};
            load(starfile,vars{:});
            flags0=any(sum(flagallcols(:,:,1:2),3),2); % Darks and non-tracking modes are replaced with -9999; AODs during other flag events (e.g., clouds) kept; this may be changed. 2014/04/07, Yohei.
            flags=any(sum(flagallcols(:,:,3:end),3),2); % Darks and non-tracking modes are replaced with -9999; AODs during other flag events (e.g., clouds) kept; this may be changed. 2014/04/07, Yohei.
            tau_aero_noscreening(flags0,:)=NaN;
            if isequal(dslist{i}, '20130827'); % a day with two flights; the first is included in '20130826'
                flight=flight(2,:);
            end;
            if t(end)<max(flight(:)); % the flight possibly continued to the 4STAR files with date stamps of the next day
                starfile2=fullfile(starpaths, [num2str(str2num(dslist{i})+1) 'starsun.mat']);
                if exist(starfile2);
                    l2=load(starfile2,vars{:});
                    l2.flags0=any(sum(l2.flagallcols(:,:,1:2),3),2);
                    l2.flags=any(sum(l2.flagallcols(:,:,3:end),3),2);
                    l2.tau_aero_noscreening(l2.flags0,:)=NaN;
                end;
            end;
            if isequal(dslist{i}, '20130906'); 
                disp('20130906 Add notes about agricultural smoke 18:57:45-18:58:25.')
            end;
            % determine wavelengths to archive
            [visc,nirc,viscrange,nircrange]=starchannelsatSEAC4RSArchive(t); % these lines do not need to be repeated for each flight, but I don't find a good place outside the loop for them.
            c=[visc(isfinite(visc)) nirc(isfinite(nirc))+1044];
            % format data
            tosave0=[round((t-floor(t(1)))*86400) Lat Lon Alt tau_aero_noscreening(:,c) flags];
            if t(end)<max(flight(:)) && exist(starfile2); % the flight possibly continued to the 4STAR files with date stamps of the next day
                tosave0=[tosave0; round((l2.t-floor(t(1)))*86400) l2.Lat l2.Lon l2.Alt l2.tau_aero_noscreening(:,c) l2.flags];
                t=[t;l2.t];
                clear l2;
            end;
            tosave0(~isfinite(tosave0) | imag(tosave0)~=0)=-9999;
            tosave0=tosave0(incl(t,flight),:);
            tosave=(round((flight(1)-floor(flight(1)))*86400):1:round((flight(end)-floor(flight(1)))*86400))';
            [~,ia,ib]=intersect(tosave, tosave0(:,1));
            tosave=[tosave -9999*ones(size(tosave,1), size(tosave0,2)-1)];
            tosave(ia, 2:end)=tosave0(ib,2:end);
        end;
    elseif isequal(prefix,'SEAC4RS-4STAR-WV');
    !!! SEAC4RS version, to be updated        
    elseif isequal(prefix,'SEAC4RS-4STAR-SKYSCAN');
    !!! SEAC4RS version, to be updated
        starfile=fullfile(starpaths, [dslist{i} 'star.mat']);
        load(starfile, 'vis_skya', 'vis_skyp', 'nir_skya', 'nir_skyp');
        tosave=[];
        for j=1:2;
            if j==1;
                s=vis_skya;
                s2=nir_skya;
            elseif j==2;
                s=vis_skyp;
                s2=nir_skyp;
            end;
            for ii=1:numel(s);
                if ~isempty(s(ii).t);
                    tosave=[tosave; round((s(ii).t-floor(s(ii).t(1)))*86400) s(ii).Lat s(ii).Lon s(ii).Alt s(ii).AZ_deg s(ii).El_deg s(ii).raw fliplr(s2(ii).raw)];
                end;
            end;
        end;
        clear j ii;
        tosave=sortrows(tosave,1); % sort by the time (i.e., mix alum and ppl)
    else;
        error('What data?');
    end;
    % adjust time stamp
    if exist('tadd');
        tosave(:,1)=tosave(:,1)+tadd(i);
    end;
    
    % copy headers from the template file
    templatefile=fullfile(starpaths, [prefix '_' platform '_' 'yyyymmdd_R' num2str(R) '.ict']);
    savefilename=fullfile(starpaths, [prefix '_' platform '_' dslist{i} '_R' num2str(R) '.ict']);
    if exist(savefilename);
        error([savefilename ' exists.']);
    end;
    fid0=fopen(templatefile, 'r');
    fid=fopen(savefilename, 'w');
    for ii=1:6;
        fprintf(fid, '%s\n', fgetl(fid0));
    end;
    clear ii;
    fg=fgetl(fid0); % do not copy the 7th line (dates); instead create the one below
    nowstr=datestr(now,30);
    texto=[dslist{i}(end-7:end-4) ', ' dslist{i}(end-3:end-2) ', ' dslist{i}(end-1:end) ', ' nowstr(1:4) ', ' nowstr(5:6) ', ' nowstr(7:8)];
    fprintf(fid, '%s\n', texto');
    fg=fgets(fid0);
    while fg~=-1;
        if isequal(prefix,'NAAMES-4STAR-AOD') && strncmp(fg, 'DM_CONTACT_INFO', 15);
            if isequal(lower(datamanager{i}), 'yohei')
                fg='DM_CONTACT_INFO: Yohei Shinozuka, Yohei.Shinozuka@nasa.gov';
            elseif isequal(lower(datamanager{i}), 'samuel')
                fg='DM_CONTACT_INFO: Samuel LeBlanc, Samuel.LeBlanc@nasa.gov';
            end;
            fprintf(fid, '%s\n', fg);
        elseif isequal(prefix,'NAAMES-4STAR-AOD') && strncmp(fg, 'C0_source', 9);
            c0_source='';
            for ii=1:numel(note)
                if note{ii}(1:2) == 'C0';
                    c0_source = [c0_source note{ii}(9:end-1) ', '];
                end
            end
            clear ii;
            fg=['C0_source: ' c0_source(1:end-2)];
        elseif isequal(prefix,'NAAMES-4STAR-AOD') && strncmp(fg, 'PLATFORM', 8);
            fg=['PLATFORM: ' platform];
        else;
        fprintf(fid, '%s', fg);
        end;
        fg=fgets(fid0);
    end;
    fclose(fid0);
    
    % save now   
    fmt=['%u, %7.4f, %9.4f, ' repmat('%6.3f, ',1,size(tosave,2)-3)]; %from Yohei 4/8/2014
    fmt=[fmt(1:end-2) '\n'];
    fprintf(fid, fmt, tosave');
    fclose(fid);
    
    disp(dslist{i});
end;

% plot
savefigure=false; ! this section to be updated
if isequal(prefix,'NAAMES-4STAR-AOD');
%     fn='AOD355'; % one field name
    fn='AOD501'; % one field name
%     fn='AOD1064'; % one field name
elseif isequal(prefix,'SEAC4RS-4STAR-WV');
elseif isequal(prefix,'SEAC4RS-4STAR-SKYSCAN');
    fn='c5000'; % one field name
end;
if savefigure;
    figure;
        r=ictread(fullfile(starpaths,[prefix '_' platform '_' daystr '_R' num2str(R) '.ict']));
%         ra=ictread(fullfile(starpaths,[prefix '_' platform '_' daystr '_R' 'A' '.ict']));
        ph=plot(r.t, r.(fn), '.','markersize',12,'color', [.5 .5 .5]);
        hold on;
        ph(2)=plot(r.t(r.flag==0),r.(fn)(r.flag==0), '.r','markersize',12);
        ph(3)=plot(ra.t,ra.(fn), '.g','markersize',12);
        ph(4)=plot(rj.t(rj.flag==0),rj.(fn)(rj.flag==0), '.b','markersize',12);
%         r0=ictread(fullfile(starpaths,['4STAR_G1_' daystr '_R0.ict']));
%         r1=ictread(fullfile(starpaths,['4STAR_G1_' daystr '_R1.ict']));
%         [xx,yy,xx1,yy1]=errorbars(r1.t,r1.(fn)+r1.(['unc' fn]),r1.(fn)-r1.(['unc' fn]));
%         ph=plot(r1.t, r1.(fn), 'ob', xx,yy, '-b', r0.t,r0.(fn), '.k');
%         set(ph(end),'color',[.5 .5 .5]);
    ggla;
    grid on;
    datetick('x','keeplimits');
    xlabel('UTC');
    ylabel(fn);    
    title(daystr);
    lh=legend(ph, ['R' num2str(R)]);
%     lh=legend(ph, ['R' num2str(R)], ['R' num2str(R) ', flag=0']);
%     lh=legend(ph, ['R' num2str(R)], ['R' num2str(R) ', flag=0'], 'RA');
    lh=legend(ph, ['R' num2str(R)], ['R' num2str(R) ', flag=0'], 'RA', 'R0 John, flag=0');
%     lh=legend(ph([1 3]), 'R1', 'R0');
    set(lh,'fontsize',12,'location','best');
    set(gca,'children',ph([3 2 4 1 ]));
    starsas(['star' daystr 'archive' fn 'tseries_R' num2str(R) 'John.fig, ' mfilename '.m']);
end;

% s=ictread('d:\4star\data\NAAMES-4STAR-AOD_DC8_20130826_R0.ict');
% w=[380 452 501 520 532 550 606 675 781 865 1020 1064 1236 1559]/1000;
% aod=NaN(size(s.t,1),numel(w));
% for i=1:numel(w);
%     eval(['aod(:,i)=s.AOD' num2str(w(i)*1000) ';']);
% end;
% aod(s.flag==1,:)=NaN;

% for developers
% for i=1:1556; % create lines for header
%     disp(['sky diffusion photon count at ' num2str(w(i)*1000, '%0.1f') ' nm']);
% end;