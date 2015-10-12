% SEmakearchive_John_Nov2014_V06.m
% Generates SEAC4RS archive files. 
% Prior to running this code, update the template file.
% Yohei, 2013/07/25, after TCmakearchive.m.
% Yohei, 2014/04/07, updated for R0 submission.
% John,  2014/04/08-04/14, updated to accommodate new screening flags...note that all JL changes no longer commented with "JML" 
% John,  2014/04/12: complete working CWV code in a separate version for the time being
% John,  2014/10/02; updated to more AOD wvls and AOD unc for final SEAC4RS archival
% John,  2014/10/24; updated to add CWV variables for inclusion in AOD archive file
% Sam, 2015-08-24: Updated to use R2 calculated on Pleiades 
clear
close all

tic

def_starpaths = true; % false; % Yohei, 2015/10/01, for running on my laptop
%JML: following gives user flexibility to store *starsun.mat & flag files in a subdirectory under starpaths;
%could do same for starinfo*.m file but have not implemented that
%datadirec_special=[];     %JML
datadirec_special='DC8_';  %JML
datadirec_special='../../SEAC4RS/starmat/';  %SL
datadirec_special=''; % Yohei
datadirec_short_special='DC8_starsunfinalfiles_Nov14'; %'DC8_starsunfinalfiles_Oct14';
datadirec_short_special='../../SEAC4RS/starsun/';  %SL
datadirec_short_special='';  % Yohei
fp_starmat = '/nobackup/sleblan2/SEAC4RS/dc8/SEAC4RS/';
fp_starsun = '/nobackup/sleblan2/SEAC4RS/starsun_R2/';
fp_figs = '/nobackup/sleblan2/SEAC4RS/figs/';
[~, fp_figs] = starpaths; fp_figs = fullfile(fp_figs, 'fig', filesep); % Yohei
fp_ict = '/nobackup/sleblan2/SEAC4RS/starict_R2/'
fp_flag = '/u/sleblan2/4STAR/4STAR_codes/data_folder/'
fp_flag = fullfile(paths, 'code', '\4STAR_codes\data_folder');

fig_vis = {'Visible','off'}
vis_fig = {'Visible','off'}
savefigs = true;

flag_T4temp_filter=0; %value=0 or 1; if==1 will set flags=1 if ratio AODcorr due to temp>=cutoffratio_AODcorr
wvl_T4filt=1.02; %0.8645; %1.587; %1.02
cutoffratio_AODcorr=0.5;  %arbitrary 50% cutoff
T4cutoff=-15;

flag_NIRfilter=1; %fits 2nd order polynomial to AOD at archive NIR wvls to calculate AOD(865 nm), and then us
%                  the difference between this and the observed AOD(865) to set all AOD(NIR wvl)=Nan==>-9999 for
%                  unexplained increase in AOD(NIR wvls)
aoddiffNIR_threshold=0.1; %difference threshold

% set variables
prefix='SEAC4RS-4STAR-AOD-CWV'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV'; 
R='2'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
if isempty(str2num(R)); % in field
    dslist={'20130806' '20130807' '20130808' '20130812' '20130814' '20130816' '20130819' '20130821' '20130823' '20130826' '20130827' '20130828' '20130830' '20130902' '20130904' '20130906'} ; % put one day string

    tadd=zeros(size(dslist));
    tadd([2 11])=86400; % add seconds
    tend=NaN(size(dslist));
    tend(1)=87370; % the last time stamp
    tend(10)=87996; % the last time stamp
elseif isequal(R,'0') | isequal(R,'1') | isequal(R,'2') % post field  
    %JML flights that span 2 days will have to be listed separately and need to be added
    dslist={'20130806' '20130807' '20130808' '20130812' '20130814' '20130816' '20130819' '20130821' '20130823' '20130826' '20130827' '20130828' '20130830' '20130831' '20130902' '20130904' '20130906' '20130907' '20130909' '20130910' '20130911' '20130913' '20130916' '20130917' '20130918' '20130921' '20130923'} ; % put one day string
    %Values of jproc: 1=archive 0=do not archive  JML 4/7/14
    jproc=[         0          0          0          0          0          0          0          0          0          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1]; %set=1 to process    %JML 4/7/14
    %Values of idflag: 1=old flagging,2=new flagging JML 4/7/14   
    idflag=[        2          2          2          2          2          2          2          2          1          1          1          1          1          1          2          2          1          1          2          2          2          2          2          2          2          2          2]; %JML 4/7/14
    %JML updated datamanager for the purpose of these runs, but of course 9/6-7 is really Yohei and he has already archived that file
    datamanager=[repmat({'John'},1,8) repmat({'Yohei'},1,6) repmat({'Meloe'},1,2) repmat({'Yohei'},1,2) repmat({'Meloe'},1,7) repmat({'John'},1,2)];  %JML updated for these runs but   
end;
dsexcludeAOD={};
platform='DC8';    
bl=60/86400;

idx_file_proc=find(jproc==1); %JML 4/7/14
% generate files
for i=idx_file_proc,   %JML 4/7/14
    % get the flight time period
    daystr=dslist{i};
    evalstarinfo(dslist{i}, 'flight');
    
    if isequal(daystr, '20130827')  %Yohei's code to handle two flights with same date
        flight=flight(2,:);
    end;
    UTflight=timeMatlab_to_UTdechr(flight);
    
    % load track data
    if def_starpaths
        if ~isempty(datadirec_special)  %JML
            filestar=fullfile(starpaths, [sprintf('%s%s',datadirec_special,dslist{i}) filesep dslist{i} 'star.mat']);  %JML
            if ~exist(filestar)
                filestar = fullfile(starpaths, [sprintf('%s%s',datadirec_special, dslist{i},'star.mat')]);
            end;
        else   %JML
            filestar=fullfile(starpaths, [dslist{i} 'star.mat']);
        end    %JML
    else
	filestar = fullfile(fp_starmat, [dslist{i} 'star.mat'])
    end
    load(filestar,'track');
       

    if strcmp(daystr,'20130827')
        iii=find(track.t>=flight(1));
        track1_t=track.t(iii);
        track1_T4=track.T4(iii);
    else
        track1_t=track.t;
        track1_T4=track.T4;
    end
    UTtrack1=timeMatlab_to_UTdechr(track1_t);
    
    switch daystr
        case {'20130814','20130821','20130911','20130923'}
            flag_flightendcheck=0;
        otherwise
            flag_flightendcheck=1;
    end
    
    if flight(end)>track1_t(end)& flag_flightendcheck
        if def_starpaths
            filestar2=fullfile(starpaths, [sprintf('%s%s',datadirec_special,num2str(str2num(dslist{i})+1)) filesep num2str(str2num(dslist{i})+1) 'star.mat']);  %JML
            if ~exist(filestar2)
                filestar2 = fullfile(starpaths, [sprintf('%s%s',datadirec_special, dslist{i}) 'star.mat']);
            end;
        else
            filestar2 = fullfile(fp_starmat,[num2str(str2num(dslist{i})+1) 'star.mat'])
        end;
        load(filestar2,'track');
        switch daystr
            case '20130827'
                itsav=find(track.t<(datenum('25:30:00')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)])));
                track2_t=track.t(itsav);
                track2_T4=track.T4(itsav);
            case '20130826'
                itsav=find(track.t<=(datenum('25:47:41')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)])));
                track2_t=track.t(itsav);
                track2_T4=track.T4(itsav);
            otherwise
                itsav=[];
                itsav=find(track.t>=flight(end));
                if ~isempty(itsav)
                    track2_t=track.t(itsav);
                    track2_T4=track.T4(itsav);
                else
                    track2_t=track.t;
                    track2_T4=track.T4;
                end
        end
        %not sure about the following
        %         if ~isempty(itsav) & ~strcmp(daystr,'20130827')
        %             track2_t=track2_t(itsav(1):itsav(2));
        %             track2_T4=track2_T4(itsav(1):itsav(2));
        %         end
        UTtrack2=timeMatlab_to_UTdechr(track2_t);
        track_t=[track1_t;track2_t];
        track_T4=[track1_T4;track2_T4];
    else
        itsav=[];
        track_t=track1_t;
        track_T4=track1_T4;
    end
    
    clear track

    UTtrack=timeMatlab_to_UTdechr(track_t);
    track.tsm=boxxfilt(track_t, track_T4, bl);
    [track.tsorted, iisav]=unique(track_t);

    figure(fig_vis{:})
    ax1=subplot(2,1,1);
    plot(track_t,ones(length(track_t),1)*1.25,'c.')
    hold on
    if ~isempty(itsav)
        plot([track1_t(1) track1_t(end)],[1.1 1.1],'bo','markersize',8,'markerfacecolor','b')
        plot([track2_t(1) track2_t(end)],[1.2 1.2],'go','markersize',8,'markerfacecolor','g')
    end
    plot(flight,[1.15 1.15],'r-','linewidth',3)
    grid on
    datetick('x',0,'keeplimits','keepticks')
    set(gca,'ylim',[0 2],'fontsize',12)
    title(daystr,'fontsize',16)
    xlabel('Time','fontsize',20)
    ax2=subplot(2,1,2);
    plot(track1_t,track1_T4,'b.')
    hold on
    if ~isempty(itsav)
        plot(track2_t,track2_T4,'r.')
    end
    plot(track.tsorted,track.tsm(iisav),'g.')
    set(gca,'fontsize',12)
    grid on
    datetick('x',0,'keeplimits','keepticks')
    ylabel('T4 Temp (C)','fontsize',20)
    xlabel('Time','fontsize',20)
    linkaxes([ax1 ax2],'x')
    if savefigs
      fp_f = [fp_figs dslist{i} '_track_t_vs_T4.fig']
      saveas(gcf,fp_f);
      makevisible(fp_f);
    end

    clear track_t track_T4 track1_t track2_t track1_T4 track2_T4
    
    % read data to be saved
    if isequal(prefix,'SEAC4RS-4STAR-AOD-CWV');
        if ismember(dslist{i}, dsexcludeAOD); % exclude the day when no sun measurements were made.
            tosave=[];
            warning(['For the ' dslist{i} ' file, add "No AOD measurements were made on this flight." to the header.']);
        elseif isempty(str2num(R)); % all other days, in field
            starfile=fullfile(starpaths, [dslist{i} 'starsun.mat'])
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
        elseif isequal(R, '0') | isequal(R,'1') | isequal(R,'2'); % all other days, post field
            % load data
            if def_starpaths
%                 if ~isempty(datadirec_special)  %JML
                    %starfile=fullfile(starpaths, [sprintf('%s%s',datadirec_special,dslist{i}) filesep dslist{i} 'starsunfinalshort.mat']);  %JML
                    starfile=fullfile(starpaths, [datadirec_short_special filesep dslist{i} 'starsunfinal.mat_short.mat']);  %JML
                    starfile=fullfile(starpaths, [datadirec_short_special filesep dslist{i} 'starsun.mat']);  %JML
                    starfile=fullfile(starpaths, [datadirec_short_special filesep dslist{i} 'starsun_R2.mat']);  %JML
                    %filestar=fullfile(starpaths, [sprintf('%s%s',datadirec_special,dslist{i}) filesep dslist{i} 'star.mat']);  %JML
%                 else   %JML
%                     starfile=fullfile(starpaths, [dslist{i} 'starsunfinal.mat']);
                    %filestar=fullfile(starpaths, [dslist{i} 'star.mat']);
%                 end    %JML
            else
                starfile = fullfile(fp_starsun,[dslist{i} 'starsun_R2.mat'])
            end
            %vars={'t','w','Lat','Lon','Alt','tau_aero_noscreening' 'flagallcols','m_aero'};  %used for R='0' Apr 2014
            %vars={'t','w','Lat','Lon','Alt','tau_aero_noscreening','tau_aero','flagallcols','m_aero','tau_aero_err'};  %added 'tau_aero_err' for R='1' Oct 2014
            vars={'t','w','Lat','Lon','Alt','tau_aero_noscreening','tau_aero','m_aero','tau_aero_err','cwv','flagallcols'}; %added 'cwv' for R='1',Oct 2014
            load(starfile,vars{:});
            UTstarsunfile=timeMatlab_to_UTdechr(t);
            T4degC_smintp=interp1(track.tsorted, track.tsm(iisav), t);
            idx_T4nan=find(isnan(T4degC_smintp));
%             if ~isempty(idx_T4nan)
%                 idx_T4g=find(~isnan(T4degC_smintp));
%                 T4degC_smintp(idx_T4nan)=interp1(t(idx_T4g),T4degC_smintp(idx_T4g),t(idx_T4nan),'spline','extrap');
%             end
            %clear track
            switch idflag(i)
                case 1  %old flagging, supposedly
                    flags0=any(sum(flagallcols(:,:,1:2),3),2); % Darks and non-tracking modes are replaced with -9999; AODs during other flag events (e.g., clouds) kept; this may be changed. 2014/04/07, Yohei.
                    flags=any(sum(flagallcols(:,:,3:end),3),2); % Darks and non-tracking modes are replaced with -9999; AODs during other flag events (e.g., clouds) kept; this may be changed. 2014/04/07, Yohei.
                    %flagstest=zeros(length(flags0),1);
                    flags0(t<flight(1)|t>flight(2))=1; %JML set these=1 for times before or after flight time
                    flags(flags0==1)=1; %JML
                case 2  %new flagging
                    flagfilename=select_flagfile(dslist{i},R);
                    if def_starpaths
                        if ~isempty(datadirec_special)  %JML
                            flagfile=fullfile(starpaths, [sprintf('%s%s',datadirec_special,dslist{i}) filesep flagfilename]);  %JML
                            if ~exist(flagfile);
                                flagfile=fullfile(starpaths, [sprintf('%s%s',datadirec_special, flagfilename)]);
                            end;
                        else
                            flagfile=fullfile(starpaths,flagfilename); %JML 4/7/14
                            flagfile=fullfile(fp_flag,flagfilename); %JML 4/7/14
                        end
                    else
                        flagfile = fullfile(fp_flag,flagfilename);
                    end
                    load(flagfile,'flags','flags_struct'); %JML 4/7/14
                    UTflagfile=timeMatlab_to_UTdechr(flags.time.t);
                    %% Sam 2015-09-08, modified to match the time of the flags to the time of the measurement
		    disp('UT starsun file')
		    if length(UTstarsunfile) ~= length(UTflagfile)
			disp('Problem with time mismatch')
			disp('Problem with time mismatch')
		    end                    

                    flagsnew=flags; %JML 4/7/14
                    flags0=flagsnew.before_or_after_flight | flagsnew.bad_aod;  %JML 4/7/14
                    idx_flags_cld=find(flagsnew.unspecified_clouds & ~flagsnew.smoke);
                    flags=zeros(length(t),1);    %JML 4/7/14
                    flags(flags0==1,1)=1;   %JML 4/7/14
                    flags(idx_flags_cld)=1; %JML 4/9/14 set flags=1 for unspecified_clouds obs.
                    idxfnd=findstr(flags_struct.flags_str_unspecified_clouds(end-5:end),'>');
                    rawrelstd1=str2num(flags_struct.flags_str_unspecified_clouds(end-idxfnd+1:end));
                    angcrit1=-99;
                    if isfield(flags_struct,'flags_str_smoke')
                        if ~isempty(flags_struct.flags_str_smoke)  %edited Oct2014
                            jdxfnd=findstr(flags_struct.flags_str_smoke(end-5:end),'>');
                            angcrit1=str2num(flags_struct.flags_str_smoke(end-jdxfnd+1:end));
                        end
                    end
                    flagfilesav1=flagfilename;
            end
            
            % determine wavelengths to archive...calculate here for use later
            [visc,nirc,viscrange,nircrange]=starchannelsatSEAC4RSArchive(t); % these lines do not need to be repeated for each flight, but I don't find a good place outside the loop for them.
            c=[visc(isfinite(visc)) nirc(isfinite(nirc))+1044];

            if flag_T4temp_filter
                load('c:\johnmatlab\4STAR\data\tau_4STARtempcorr_10degoffset.mat','tempC_4STARtempcorr','amass_4STARtempcorr','tau_4STARtempcorr')
                %   amass_4STARtempcorr        1x301               2408  double
                %   tau_4STARtempcorr        301x801            1928808  double
                %   tempC_4STARtempcorr        1x801               6408  double
                
                jjj=find(flags==0);
                kgood=find(~isnan(T4degC_smintp(jjj)));
                knan=find(isnan(T4degC_smintp(jjj)));
                AODcorr_duetotemp=zeros(length(m_aero),1);
                if ~isempty(kgood)
                    for k=1:length(kgood),
                        jint=jjj(kgood(k));
                        AODcorr_duetotemp(jint)=tableinterpolate(amass_4STARtempcorr,tempC_4STARtempcorr,tau_4STARtempcorr,m_aero(jint),T4degC_smintp(jint));
                    end
                end
                [valT4filt,idxT4filt]=min(abs(w(c)-wvl_T4filt));
                abs_ratio_AODcorr=abs(AODcorr_duetotemp(jjj)./tau_aero_noscreening(jjj,c(idxT4filt)));
                idxUTflight=find(t>=flight(1)&t<=flight(end));
                flagsav=flags;
                idxreset=jjj(abs_ratio_AODcorr>=cutoffratio_AODcorr | T4degC_smintp(jjj)<T4cutoff);
                flags(idxreset)=1; %set flags=1 if ratio>cutoff                
                figure(vis_fig{:}) %for QA
                UTplot=UTstarsunfile;
                idxnextday=find(UTplot>=0 & UTplot<=3);
                UTplot(idxnextday)=UTplot(idxnextday)+24;
                if length(UTplot) > length(ig);
                   UTplot = UTplot(1:length(ig));
                   disp('modifying the UTplot becasue it was too long')
                end;
                ax1=subplot(3,1,1)
                plot(UTplot(jjj),tau_aero_noscreening(jjj,c(idxT4filt)),'b.')
                hold on
                plot(UTplot(jjj),AODcorr_duetotemp(jjj),'ro')
                grid on
                set(gca,'fontsize',16)
                labstr='{\color{blue}AOD(';
                ylabel(sprintf('%s%5.1f nm)},',labstr,wvl_T4filt*1000,'{\color{red}AODcorr}'),'fontsize',14) %, {\color{red}AODtempcorr}
                ax2=subplot(3,1,2)
                plot(UTplot(idxUTflight),flagsav(idxUTflight),'b.')
                hold on
                plot(UTplot(idxUTflight),flags(idxUTflight),'r.')
                plot(UTplot(idxreset),flags(idxreset),'go')
                plot(UTplot(idxUTflight),Alt(idxUTflight)/10000,'c.')
                set(gca,'ylim',[-1 2])
                grid on
                set(gca,'fontsize',16)
                ylabel('{\color{blue}flagsav},{\color{red}flags},{\color{green}flagsreset},{\color{cyan}Altkm//10}','fontsize',14)
                ax3=subplot(3,1,3)
                plot(UTplot(jjj),abs_ratio_AODcorr,'k.')
                hold on
                plot([UTplot(jjj(1)) UTplot(jjj(end))],[cutoffratio_AODcorr cutoffratio_AODcorr],'g--','linewidth',2),
                grid on
                set(gca,'fontsize',16)
                ylabel('{\color{black}abs|ratioAODcorr|},{\color{green}cutoffratio}','fontsize',14)
                xlabel('UT (hr)','fontsize',20)
                linkaxes([ax1 ax2 ax3],'x')
                if savefigs 
                  fp_f = [fp_figs dslist{i} '_aero_noscreening_time_flags.fig']
                  saveas(gcf,fp_f);
                  makevisible(fp_f);
                end

                %stophere168
            end
 
            if flag_NIRfilter %handles records where NIR AOD are elevated relative to VIS AOD and obviously incorrect
                [val865,idx865]=min(abs(w(c)-0.865));
                idxvis=c(c<1044);
                idxnir=c(c>1044);
                xfvis=log(w(idxvis));
                xfnir=log(w(idxnir));
                w865=w(c(idx865));
                log865=log(w865);
                ig=find(flags==0);
		disp('lenght of ig')
                length(ig)
                for jloop=1:length(ig),
                    ival=ig(jloop);
                    %[pvis,Svis] = polyfit(xfvis,log(tau_aero(i,idxvis)),2);
                    %aod865_visfit(j)=exp(polyval(pvis,log865));
                    [pnir,Snir] = polyfit(xfnir,log(tau_aero_noscreening(ival,idxnir)),2);
                    aod865_nirfit(jloop)=real(exp(polyval(pnir,log865)));

                end
                if length(aod865_nirfit) > length(ig)
                   aod865_nirfit = aod865_nirfit(1:length(ig));
                   disp('Modyfying the length of aod865_nirfit to match') %SL
                end;
                aoddiff_nirminusobs=aod865_nirfit'-tau_aero_noscreening(ig,c(idx865));%use this quantity for filtering
                aodratio_nirtoobs=aod865_nirfit'./tau_aero_noscreening(ig,c(idx865)); %of interest but not used for filtering
                idxig_NIRbad=find(aoddiff_nirminusobs>=aoddiffNIR_threshold); %used below for filtering
                if length(idxig_NIRbad)>0
                    figure(vis_fig{:}) %for QA
                    subplot(3,1,1)
                    set(gca,'position',[0.131 0.655 0.775 0.307]);
                    %irecfnd=find(UTstarsunfile>18.3894);
                    %irec=irecfnd(1);
                    irec=ig(idxig_NIRbad(1));
                    UTstarsunfile(irec)
                    loglog(w(c),tau_aero_noscreening(irec,c),'bo','markersize',8,'markerfacecolor','b'); %idxig_NIRbad(1)
                    hold on
                    loglog(w(c),tau_aero(irec,c),'rs','markersize',10) ;%idxig_NIRbad(1)
                    [pnir,Snir] = polyfit(xfnir,log(tau_aero_noscreening(irec,idxnir)),2);
                    aodnirfit_plot=real(exp(polyval(pnir,[log865 xfnir])));
                    loglog(w([c(idx865) idxnir]),aodnirfit_plot,'g--','linewidth',3)
                    loglog(w865,aodnirfit_plot(1),'go','markersize',10,'markerfacecolor','g','markeredgecolor','k')
                    set(gca,'fontsize',16)
                    ylabel('AOD','fontsize',20)
                    set(gca,'xlim',[0.4 1.7],'ylim',[0.01 10])
                    grid on
                    set(gca,'xtick',[0.4:0.1:1.7]);
                    xlabel('Wavelength [\mum]','FontSize',20);
                    title(sprintf('rec:%6i   UT:%8.4f',irec,UTstarsunfile(irec)),'fontsize',14)
                    ax2=subplot(3,1,2);
                    set(gca,'position',[0.131 0.362 0.775 0.216]);
                    if ~exist('UTplot')
                        UTplot=UTstarsunfile;
                        idxnextday=find(UTplot>=0 & UTplot<=3);
                        UTplot(idxnextday)=UTplot(idxnextday)+24;
                    end
                    plot(UTplot(ig),aoddiff_nirminusobs,'g.','markersize',10)
                    hold on
                    plot(UTplot(ig),aod865_nirfit,'r.','markersize',10)
                    plot(UTplot(ig),tau_aero_noscreening(ig,c(idx865)),'bo')
                    set(gca,'fontsize',16)
                    set(gca,'ylim',[-1 10])
                    grid on
                    ylabel('AOD diff: NIR minus obs','fontsize',16)
                    ax3=subplot(3,1,3);
                    plot(UTplot(ig),aodratio_nirtoobs,'k.','markersize',8)
                    hold on
                    plot([UTplot(ig(1)) UTplot(ig(end))],[1.5 1.5],'r--','linewidth',2)
                    grid on
                    set(gca,'fontsize',16)
                    ylabel('AOD ratio: NIR/obs','fontsize',16)
                    xlabel('UT (hr)','fontsize',20)
                    linkaxes([ax2 ax3],'x')
                    tau_aero_noscreening(ig(idxig_NIRbad),idxnir)=NaN;
                    tau_aero_err(ig(idxig_NIRbad),idxnir)=NaN;
                    if savefigs
                        fp_f = [fp_figs dslist{i} '_loglog_aod_diff.fig']
                        saveas(gcf,fp_f);
                        makevisible(fp_f);
                    end

                else
                    figure(vis_fig{:})
                    ax1=subplot(2,1,1);
                    plot(UTplot(ig),aoddiff_nirminusobs,'b.','markersize',10)
                    hold on
                    plot(UTplot(ig),aod865_nirfit,'r.','markersize',10)
                    plot(UTplot(ig),tau_aero_noscreening(ig,c(idx865)),'c.','markersize',10)
                    set(gca,'fontsize',16)
                    set(gca,'ylim',[-1 10])
                    grid on
                    ylabel('AOD diff: NIR minus obs','fontsize',16)
                    hleg=legend('diff','fit ','obs ');
                    set(hleg,'fontsize',14)
                    title(dslist(i),'fontsize',14)
                    ax2=subplot(2,1,2);
                    plot(UTplot(ig),aodratio_nirtoobs,'k.','markersize',8)
                    hold on
                    plot(UTplot(ig),10*aoddiff_nirminusobs,'b.','markersize',6)
                    plot([UTplot(ig(1)) UTplot(ig(end))],[0.1 0.1],'m--','linewidth',2)
                    plot([UTplot(ig(1)) UTplot(ig(end))],[1.5 1.5],'r--','linewidth',2)
                    grid on
                    set(gca,'fontsize',16)
                    ylabel('{\color{black}AOD ratio:NIR/obs}, {\color{blue}AOD diff*10}','fontsize',16)
                    xlabel('UT (hr)','fontsize',20)
                    linkaxes([ax1 ax2],'x')
                    if savefigs
                        fp_f = [fp_figs dslist{i} '_aod_diff.fig']
                        saveas(gcf,fp_f);
                        makevisible(fp_f);
                    end                   
                end
            end
            
            %JL_04Dec14: special filter for 20130808 to handle times when AOD(idxnir) are elevated compared to AOD(idxvis)
            if strcmp(daystr,'20130808')               
                itspecfilt=find(UTstarsunfile>=18 & UTstarsunfile<=21.72);
                    tau_aero_noscreening(itspecfilt,idxnir)=NaN; %will be set to -9999 below
                    tau_aero_err(itspecfilt,idxnir)=NaN;         %will be set to -9999 below         
            end
            
            tau_aero_noscreening(flags0,:)=NaN;
            tau_aero_err(flags0,:)=NaN; %JML Oct2014

%             if isequal(dslist{i}, '20130827')  %Yohei's code to handle two flights with same date
%                 flight=flight(2,:);
%             end;
            
            if isequal(dslist{i},'20130814')
                flight(1,2)=735460.93;  %temporary fix because t(end)=735460.93138 < max(flight(:))=735460.95874
            end
            
            %             9/21/flight
            %                  flight: 735498.71260 735499.09096
            %             t(1),t(end): 735498.66118 735498.99821
            if isequal(dslist{i},'20130921')
                flight(1,2)=735498.99;  %temporary fix because t(end) < max(flight(:)) and I don't have the data past 00UT on 9/22
            end
            
            %JML edited following segment
            if t(end)<max(flight(:)) & ~strcmp(daystr,'20130827'); % the flight possibly continued to the 4STAR files with date stamps of the next day
                if ~isempty(datadirec_special) %JML
                    %starfile2=fullfile(starpaths, [sprintf('%s%s',datadirec_special,num2str(str2num(dslist{i})+1)) filesep num2str(str2num(dslist{i})+1) 'starsunfinalshort.mat']);   %JML
                    starfile2=fullfile(starpaths, [datadirec_short_special filesep num2str(str2num(dslist{i})+1) 'starsunfinal.mat_short.mat']);   %JML
                    %filestar2=fullfile(starpaths, [sprintf('%s%s',datadirec_special,num2str(str2num(dslist{i})+1)) filesep num2str(str2num(dslist{i})+1) 'star.mat']);  %JML
                else  %JML
                    starfile2=fullfile(starpaths, [num2str(str2num(dslist{i})+1) 'starsunfinal.mat']);
                    %filestar2=fullfile(starpaths, [num2str(str2num(dslist{i})+1) 'star.mat']);
                end   %JML
                if exist(starfile2);
                    l2=load(starfile2,vars{:});
                    UTstarsunfile2=timeMatlab_to_UTdechr(l2.t);
                    %load(filestar2,'track')
                    %track.tsm=boxxfilt(track_t, track_T4, bl);
                    %[track.tsorted, ii]=unique(track.t);
                    l2.T4degC_smintp=interp1(track.tsorted, track.tsm(iisav), l2.t);
                    idx2_T4nan=find(isnan(l2.T4degC_smintp));
                    if ~isempty(idx2_T4nan)
                        idx2_T4g=find(~isnan(l2.T4degC_smintp));
                        l2.T4degC_smintp(idx2_T4nan)=interp1(l2.t(idx2_T4g),l2.T4degC_smintp(idx2_T4g),l2.t(idx2_T4nan),'spline','extrap');
                    end
                    switch idflag(i+1)
                        case 1
                            l2.flags0=any(sum(l2.flagallcols(:,:,1:2),3),2);
                            l2.flags=any(sum(l2.flagallcols(:,:,3:end),3),2);
                        case 2
                            flagfilename=select_flagfile(char(dslist(i+1)),R);
                            if ~isempty(datadirec_special)  %JML
                                l2flagfile=fullfile(starpaths, [sprintf('%s%s',datadirec_special,num2str(str2num(dslist{i})+1)) filesep flagfilename]);  %JML
                            else
                                l2flagfile=fullfile(starpaths,flagfilename); %JML
                            end
                            l2flags=load(l2flagfile,'flags','flags_struct'); %JML 4/7/14
                            UTflagfile2=timeMatlab_to_UTdechr(l2flags.flags.time.t);
                            l2.flags0=l2flags.flags.before_or_after_flight | l2flags.flags.bad_aod;  %JML 4/8/14
                            idx_flags_cld_l2=find(l2flags.flags.unspecified_clouds & ~l2flags.flags.smoke);
                            l2.flags=zeros(length(l2.t),1);    %JML 4/7/14
                            l2.flags(l2.flags0==1,1)=1;   %JML 4/7/14
                            l2.flags(idx_flags_cld_l2)=1;   %JML 4/9/14
                            rawrelstd2=str2num(flags_struct.flags_str_unspecified_clouds(end-3:end));
                            if isfield(l2flags.flags_struct,'flags_str_smoke')
                                %angcrit2=str2num(l2flags.flags_struct.flags_str_smoke(17:19)); %Apr2014
                                jdx2fnd=findstr(l2flags.flags_struct.flags_str_smoke(end-5:end),'>');  %Oct2014
                                angcrit2=str2num(l2flags.flags_struct.flags_str_smoke(end-jdx2fnd+1:end)); %Oct2014
                            else
                                angcrit2=-99;
                            end
                            flagfilesav2=flagfilename;
                    end
                    
                    if flag_T4temp_filter
                        jj2=find(l2.flags==0 & l2.t<=flight(end));
                        if ~isempty(jj2)
                            kgood=find(~isnan(l2.T4degC_smintp(jj2)));
                            knan=find(isnan(l2.T4degC_smintp(jj2)));
                            l2.AODcorr_duetotemp=zeros(length(l2.m_aero),1);
                            if ~isempty(kgood)
                                for k=1:length(kgood),
                                    jint=jj2(kgood(k));
                                    l2.AODcorr_duetotemp(jint)=tableinterpolate(amass_4STARtempcorr,tempC_4STARtempcorr,tau_4STARtempcorr,l2.m_aero(jint),l2.T4degC_smintp(jint));
                                end
                            end
                            l2.abs_ratio_AODcorr=abs(l2.AODcorr_duetotemp(jj2)./l2.tau_aero_noscreening(jj2,idxT4filt));
                            flags(jj2(l2.abs_ratio_AODcorr>=cutoffratio_AODcorr))=1; %set flags=1 if ratio>=cutoff
                        end
                    end
                    
                    if flag_NIRfilter %handles records where NIR AOD are elevated relative to VIS AOD and obviously incorrect
                        ig2=find(l2.flags==0 & l2.t<=flight(end));
                        if ~isempty(ig2)
                            for jloop=1:length(ig2),
                                ival=ig2(jloop);
                                [pnir,Snir] = polyfit(xfnir,log(l2.tau_aero_noscreening(ival,idxnir)),2);
                                l2.aod865_nirfit(jloop)=real(exp(polyval(pnir,log865)));
                            end
                            l2.aoddiff_nirminusobs=l2.aod865_nirfit'-l2.tau_aero_noscreening(ig2,c(idx865));%use this quantity for filtering
                            l2.aodratio_nirtoobs=l2.aod865_nirfit'./l2.tau_aero_noscreening(ig2,c(idx865)); %of interest but not used for filtering
                            l2.idxig_NIRbad=find(l2.aoddiff_nirminusobs>=aoddiffNIR_threshold); %used below for filtering
                            if length(l2.idxig_NIRbad)>0
                                l2.tau_aero_noscreening(ig2(l2.idxig_NIRbad),idxnir)=NaN;
                                l2.tau_aero_err(ig2(l2.idxig_NIRbad),idxnir)=NaN;
                            end
                        end
                    end
                    
                    l2.tau_aero_noscreening(l2.flags0,:)=NaN;
                    l2.tau_aero_err(l2.flags0,:)=NaN;  %JML Oct2014
                    
               end;
            else
                flagfilesav2=[];
            end;
            
            % format data
            %tosave0=[round((t-floor(t(1)))*86400) Lat Lon Alt tau_aero_noscreening(:,c) flags];  %used for R0 archive April 2014
            %tosave0=[round((t-floor(t(1)))*86400) Lat Lon Alt flags T4degC_smintp cwv.cwv940m1 cwv.cwv940m1std cwv.cwv940m2 cwv.cwv940m2resi tau_aero_noscreening(:,c) tau_aero_err(:,c)];  %added tau_aero_err and moved flags location JML Oct2014
            tosave0=[round((t-floor(t(1)))*86400) Lat Lon Alt flags m_aero T4degC_smintp cwv.cwv940m1 cwv.cwv940m1std tau_aero_noscreening(:,c) tau_aero_err(:,c)];  %Nov2014 JL
            if ~strcmp(daystr,'20130827') && t(end)<max(flight(:)) && exist(starfile2); % the flight possibly continued to the 4STAR files with date stamps of the next day
                %tosave0=[tosave0; round((l2.t-floor(t(1)))*86400) l2.Lat l2.Lon l2.Alt l2.tau_aero_noscreening(:,c) l2.flags]; %used for R0 archive April 2014
                %tosave0=[tosave0; round((l2.t-floor(t(1)))*86400) l2.Lat l2.Lon l2.Alt l2.flags l2.T4degC_smintp l2.cwv.cwv940m1 l2.cwv.cwv940m1std l2.cwv.cwv940m2 l2.cwv.cwv940m2resi l2.tau_aero_noscreening(:,c) l2.tau_aero_err(:,c)]; %added tau_aero_err and moved flags location JML Oct2014
                tosave0=[tosave0; round((l2.t-floor(t(1)))*86400) l2.Lat l2.Lon l2.Alt l2.flags l2.m_aero l2.T4degC_smintp l2.cwv.cwv940m1 l2.cwv.cwv940m1std l2.tau_aero_noscreening(:,c) l2.tau_aero_err(:,c)]; %Nov2014 JL
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
            % load data
            starfile=fullfile(starpaths, ['data' dslist{i} '_4starCWV.v0.mat']);
            vars={'t','Lat','Lon','Alt','cwv','std','unc','cwv1100','resi1100'};
            load(starfile,vars{:});
       
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
    else
        error('What data?');
    end;
    % adjust time stamp
    if exist('tadd'); % 'tadd' was an in-field emergency treatment for flights that each saw two dates in raw file names. Use the "flight"-based data selection for future experiments.
        tosave(:,1)=tosave(:,1)+tadd(i);
    end;
    
    % copy headers from the template file
    %templatefile=fullfile(starpaths, [prefix '_' platform '_' 'yyyymmdd_R' num2str(R) '.ict']);
    %savefilename=fullfile(starpaths, [prefix '_' platform '_' dslist{i} '_R' num2str(R) '.ict']);
    %templatefile=fullfile(starpaths, [prefix '_' platform '_' 'yyyymmdd_R' num2str(R) '_V03_John.ict']);
    if def_starpaths
     templatefile=fullfile(starpaths, [prefix '_' platform '_' 'yyyymmdd_R' num2str(R) '_V06_John.ict']);
     templatefile=fullfile(starpaths, [prefix '_' platform '_' 'yyyymmdd_R' num2str(R) '_Yohei.ict']);
    if ~isempty(datadirec_special)  %JML updated 11/25/14
        %savefilename=fullfile(starpaths, [sprintf('%s%s',datadirec_special,dslist{i}) filesep], [prefix '_' platform '_' dslist{i} '_R' num2str(R) '_John.ict']);
        savefilename=fullfile('c:\johnmatlab\4STAR\SEAC4RS_archive_files\R1archive_AOD_files_JML_rev03\', [prefix '_' platform '_' dslist{i} '_R' num2str(R) '_John.ict']);
    else
        savefilename=fullfile(starpaths, [prefix '_' platform '_' dslist{i} '_R' num2str(R) '_John.ict']);
        savefilename=fullfile(starpaths, [prefix '_' platform '_' dslist{i} '_R' num2str(R) '_Yohei.ict']);
    end  
    if exist(savefilename);
        error([savefilename ' exists.']);
    end;
    else
       savefilename = fullfile(fp_ict,[prefix '_' platform '_' dslist{i} '_R' num2str(R) '.ict'])
       templatefile=fullfile(fp_ict, [prefix '_' platform '_' 'yyyymmdd_R' num2str(R) '.ict']);
    end
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
        %for 'SEAC4RS-4STAR-AOD-CWV', use Yohei and Michal, as listed in the template file...so no special lines needed here
        if ~isempty(str2num(R)) && isequal(prefix,'SEAC4RS-4STAR-AOD') && strncmp(fg, 'DM_CONTACT_INFO', 15);
            if isequal(lower(datamanager{i}), 'john')
                fg='DM_CONTACT_INFO: Yohei Shinozuka, Yohei.Shinozuka@nasa.gov; John Livingston, John.M.Livingston@nasa.gov';
            elseif isequal(lower(datamanager{i}), 'yohei')
                fg='DM_CONTACT_INFO: Yohei Shinozuka, Yohei.Shinozuka@nasa.gov';
            elseif isequal(lower(datamanager{i}), 'meloe')
                fg='DM_CONTACT_INFO: Yohei Shinozuka, Yohei.Shinozuka@nasa.gov; Meloe Kacenelenbogen, meloe.s.kacenelenbogen@nasa.gov';
            elseif isequal(lower(datamanager{i}), 'connor')
                fg='DM_CONTACT_INFO: Yohei Shinozuka, Yohei.Shinozuka@nasa.gov; Connor Flynn, connor.flynn@pnnl.gov';
            end;
            %fg=[fg '\n'];
            fg=sprintf('%s\n',fg);
        end;
        if ~isempty(str2num(R)) && isequal(prefix,'SEAC4RS-4STAR-AOD') && strncmp(fg, 'flag_T4temp_filter', 18);
            if idflag(i)==1
                fg=sprintf('flag_T4temp_filter:%i  wvl_T4filt:%5.3f  cutoffratio_AODcorr:%3.1f  T4cutoff:%5.1f  flag_NIRfilter:%i  aoddiffNIR_thresh:%4.2f\n',...
                    flag_T4temp_filter,wvl_T4filt,cutoffratio_AODcorr,T4cutoff,flag_NIRfilter,aoddiffNIR_threshold);
            elseif idflag(i)==2
                if ~isempty(flagfilesav2)
                    fg=sprintf('flag_T4temp_filter:%i  wvl_T4filt:%5.3f  cutoffratio_AODcorr:%3.1f  T4cutoff:%5.1f  flag_NIRfilter:%i  aoddiffNIR_thresh:%4.2f  flagfile1:%s  flagfile2:%s\n',...
                        flag_T4temp_filter,wvl_T4filt,cutoffratio_AODcorr,T4cutoff,flag_NIRfilter,aoddiffNIR_threshold,flagfilesav1,flagfilesav2);
                else
                    fg=sprintf('flag_T4temp_filter:%i  wvl_T4filt:%5.3f  cutoffratio_AODcorr:%3.1f  T4cutoff:%5.1f  flag_NIRfilter:%i  aoddiffNIR_thresh:%4.2f  flagfile1:%s\n',...
                        flag_T4temp_filter,wvl_T4filt,cutoffratio_AODcorr,T4cutoff,flag_NIRfilter,aoddiffNIR_threshold,flagfilesav1);
                end
            end
        end
        fprintf(fid, '%s', fg);
        fg=fgets(fid0);
    end;
    fclose(fid0);
    
    % save now   
    %fmt=['%u, ' repmat('%6.3f, ',1,size(tosave,2)-1)];
    fmt=['%u, %7.4f, %9.4f, ' repmat('%6.3f, ',1,size(tosave,2)-3)]; %from Yohei 4/8/2014
    fmt=[fmt(1:end-2) '\n'];
    fprintf(fid, fmt, tosave');
    fclose(fid);
    
    disp(dslist{i});
end;

% plot
savefigure=false;
if isequal(prefix,'SEAC4RS-4STAR-AOD');
%     fn='AOD355'; % one field name
    fn='AOD550'; % one field name
elseif isequal(prefix,'SEAC4RS-4STAR-WV');
elseif isequal(prefix,'SEAC4RS-4STAR-SKYSCAN');
    fn='c5000'; % one field name
end;
if savefigure;
    figure;
        %r=ictread(fullfile(starpaths,[prefix '_' platform '_' daystr '_R' num2str(R) '.ict']));
        if ~isempty(datadirec_special)  %JML
            r=ictread(fullfile(starpaths,[sprintf('%s%s',datadirec_special,dslist{i}) filesep],[prefix '_' platform '_' daystr '_R' num2str(R) '_John.ict']));
        else
            r=ictread(fullfile(starpaths,[prefix '_' platform '_' daystr '_R' num2str(R) '_John.ict']));
        end
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

toc
