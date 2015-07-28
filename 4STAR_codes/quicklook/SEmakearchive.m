% Generates SEAC4RS archive files. 
% Prior to running this code, update the template file.
% Yohei, 2013/07/25, after TCmakearchive.m.

% set variables
prefix='SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV'; 
R='A'; % 0; % revision number; if 0 or a string, no uncertainty will be saved.
if ischar(R); % in field
    dslist={'20130806' '20130807' '20130808' '20130812' '20130814' '20130816' '20130819' '20130821'} ; % put one day string
    tadd=zeros(size(dslist));
    tadd(2)=86400; % add seconds
    tend=NaN(size(dslist));
    tend(1)=87370; % the last time stamp
else; % post field
    dslist={'20130802' '20130805' '20130806' '20130808'}; % for post-field batch processing
end;
dsexcludeAOD={};
platform='DC8';    

% generate files
for i=length(dslist);
    % get the flight time period
    daystr=dslist{i};
    evalstarinfo(dslist{i}, 'flight');
    
    % read data to be saved
    if isequal(prefix,'SEAC4RS-4STAR-AOD');
        if ismember(dslist{i}, dsexcludeAOD); % exclude the day when no sun measurements were made.
            tosave=[];
            warning(['For the ' dslist{i} ' file, add "No AOD measurements were made on this flight." to the header.']);
        else; % all other days
            starfile=fullfile(starpaths, [dslist{i} 'starsun.mat']);
            load(starfile,'t','w','Lat','Lon','Alt','tau_aero','tau_aero_err');
            if ~exist('tau_aero_err');
                load(starfile,'tau_aero_errlo','tau_aero_errhi');
            end;
            [visc,nirc,viscrange,nircrange]=starchannelsatSEAC4RSArchive(t);
            c=[visc(isfinite(visc)) nirc(isfinite(nirc))+1044];
            if ischar(R) || R==0; % don't include uncertainty at this point
                % Mask tau_aero above 5 km altitude. Yohei, 2013/08/21 switched from 3 km 2013/08/15,
                % after Jens's suggestion in this afternoon's meeting
                tau_aero(Alt>5000,:)=NaN;
                tosave=[round((t-floor(t(1)))*86400) Lat Lon Alt tau_aero(:,c)];
            elseif exist('tau_aero_err');
                tau_aero_err(isnan(tau_aero))=nan;
                tosave=[round((t-floor(t(1)))*86400) Lat Lon Alt tau_aero(:,c) tau_aero_err(:,c)];
            else
                tau_aero_errlo(isnan(tau_aero))=nan;
                tau_aero_errhi(isnan(tau_aero))=nan;
                tosave=[round((t-floor(t(1)))*86400) Lat Lon Alt tau_aero(:,c) tau_aero_errlo(:,c) tau_aero_errhi(:,c)];
            end;
            tosave(isfinite(tosave)==0 | imag(tosave)~=0)=-9999;
            % return the flight segment of data only; updated 2013/03/19 Yohei
            ok=incl(t, flight);
            tosave0=tosave(ok,:);
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
        end;
    elseif isequal(prefix,'SEAC4RS-4STAR-WV');
        
    elseif isequal(prefix,'SEAC4RS-4STAR-SKYSCAN');
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
    tosave(:,1)=tosave(:,1)+tadd(i);
    
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
    fg=fgetl(fid0); % do not copy the 7th line (dates); instead create the one below
    nowstr=datestr(now,30);
    texto=[dslist{i}(end-7:end-4) ', ' dslist{i}(end-3:end-2) ', ' dslist{i}(end-1:end) ', ' nowstr(1:4) ', ' nowstr(5:6) ', ' nowstr(7:8)];
    fprintf(fid, '%s\n', texto');
    fg=fgets(fid0);
    while fg~=-1;
        fprintf(fid, '%s', fg);
        fg=fgets(fid0);
    end;
    fclose(fid0);
    
    % save now   
    fmt=['%u, ' repmat('%6.3f, ',1,size(tosave,2)-1)];
    fmt=[fmt(1:end-2) '\n'];
    fprintf(fid, fmt, tosave');
    fclose(fid);
    
    disp(dslist{i});
end;

% plot
savefigure=true;
if isequal(prefix,'SEAC4RS-4STAR-AOD');
    fn='AOD355'; % one field name
elseif isequal(prefix,'SEAC4RS-4STAR-WV');
elseif isequal(prefix,'SEAC4RS-4STAR-SKYSCAN');
    fn='c5000'; % one field name
end;
if savefigure;
    figure;
        r=ictread(fullfile(starpaths,[prefix '_' platform '_' daystr '_R' num2str(R) '.ict']));
        ph=plot(r.t, r.(fn), '.');
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
%     lh=legend(ph([1 3]), 'R1', 'R0');
    set(lh,'fontsize',12,'location','best');
    starsas(['star' daystr 'archive' fn 'tseries_R' num2str(R) '.fig, ' mfilename '.m']);
end;

% for developers
% for i=1:1556; % create lines for header
%     disp(['sky diffusion photon count at ' num2str(w(i)*1000, '%0.1f') ' nm']);
% end;