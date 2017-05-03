% Kristina, 2016-07-04, I want to modify starLangley.m (doc below) to be able
%                       to handle >1 langley per day, i.e. either both AM/PM 
%                       times, or to do >1 langley in the same period to
%                       avoid that weird bend we get and see what happens.
%                       Version reset to 1.0.
%
% A collection of loose codes related to 4STAR Langley calibration. Core
% computation is done in Langley.m, and saving in starsavec0.m.
%
% Yohei, 2012/01/23, 2013/02/19
% Michal,   2015-01-07, added version_set (v 1.0) for version control of this
%                       script
% Michal,   2015-01-07, added an option to plot Langley with Azdeg
%                       added an option to plot Langley with Tst
%                       changed version to 1.1
% Michal,   2015-01-20, added an option for further data range screening for
%                       Langley (Line 45)
% Michal,   2015-10-20, added options for the new Oct 2015 re-run of ARISE c0
%                       added NIR wavelengths in cols for plots
% Michal,   2015-10-28, tweaked to adjust ARISE unc to 0.03
% Michal,   2016-01-09, tweaked to accomodate MLO, Jan-2016 Langleys
% Michal,   2016-01-21, updated to include MLO-Jan-2016 airmass constraints
% Kristina, 2016-07-03, changing version to 1.2, adding automatic figure
%                       saving, I hope
% Samuel, 2016-04-20, v1.3, Modifiying to run through a single langley with
% either filtering from one wavelength, or with everywavelength
%--------------------------------------------------------------------------

version_set('1.3');

alldays={'20161110','20161111','20161112','20161113'};%,'20161114','20161115','20161116','20161117'}; %
alldays = {'20161111'};
% alldays={'20160630','20160702','20160703','20160704','20160705'};
% alldays={'20160630','20160702','20160703','20160704','20160705','20161110','20161111'};
daycolor={'c',      'r',        'g',        'b',        'k',        'm', [0.87 0.49 0],[0.2 0.5 0.7] };
langmark={'.','+','x','o','s','^'};
%********************
% set parameters
%********************
% daystr='20160703';  %moved down
stdev_mult=2:0.5:3; % screening criteria, as multiples for standard deviation of the rateaero.
col=408; % for screening. this should actually be plural - code to be developed
% cols=[225   258   347   408   432   539   627   761   869   969]; % for plots
cols=[225   258   347   408   432   539   627   761   869   969  1084  1109  1213  1439  1503]; % added NIR wavelength for plots
savefigure=0;

    multilangleyfig=figure; %can we put all the langleys on one?
    hold on;
    langno=1; %just for legend housekeeping

for daynum=1:length(alldays)%=5
    daystr=alldays{daynum};

    fp = 'C:\Users\sleblan2\Research\MLO\2016_November';
    file = fullfile(fp,['4STAR_' daystr 'starsun.mat']);
    load(file, 't', 'w', 'rateaero', 'm_aero','AZstep','Lat','Lon','Tst','tau_aero','tau_aero_noscreening');
    AZ_deg_   = AZstep/(-50);
    AZ_deg    = mod(AZ_deg_,360); AZ_deg = round(AZ_deg);

    %starinfofile=fullfile(starpaths, ['starinfo' daystr(1:8) '.m']);
    starinfofile=fullfile(starpaths, ['starinfo_' daystr(1:8) '.m']);
    s=importdata(starinfofile);
    %s1=s(strmatch('langley',s));
    s1=s(strncmp('langley',s,1));
    for i=1:size(s1,1); %this loop handles the possibility of >1 langley.  
        eval(s1{i}); % eval(s1{:}); %this is the old one for just one
    end
    for langnum=1:size(s1,1); 
        %this loop here will take the modification above (instead of one
        %"langley" variable, now we can have "langley1","langley2" etc) and
        %make it work for multiple segments and save them appropriately.  It's
        %basically just taking the loop and consecutively making langleyx into
        %langley, and the rest of the code should run as in starLangley.
        eval(['langley=langley',num2str(langnum),';']); %disp(langley); %forchecking

        ok=incl(t,langley);
        figure(multilangleyfig)
        plot(m_aero(ok),log(rateaero(ok,407)),'marker',langmark{langnum},'color',daycolor{daynum},'linestyle','none')
        legendentries{langno}=[daystr,' ',num2str(langnum)]; langno=langno+1;
        % perform different QA filtering
        [data0, od0, residual]=Langley(m_aero(ok),rateaero(ok,col),stdev_mult,1);
        ok2=ok(isfinite(residual(:,1))==1);
        [c0, od, ress] = Langley(m_aero(ok2),rateaero(ok2,:),[]);
       
        figure(100);
        plot(w,c0,'.-k');
        hold on;
        cz = c0*0.0;
        for iw=1:length(w);
            if w(iw) <0.32;
                cz(iw) = 0.0;
            else;
            figure(101);
            [cd,odd,resd] = Langley(m_aero(ok),rateaero(ok,iw),[2]);
            disp(['doing wavlength: ' num2str(w(iw)*1000.0) ' nm'])
            cz(iw) = cd(1);
            figure(100)
            plot(w(iw),cd(1),'xb');
            end;
        end;
        plot(w,cz,'-g');
        
        save(fullfile(fp,[daystr 'multiwavelength_c0.mat']))
        stophere
           
        for k=1:numel(stdev_mult);
            ok2=ok(isfinite(residual(:,k))==1);
            [c0new(k,:), od(k,:), residual2, h]=Langley(m_aero(ok2),rateaero(ok2,:), [], cols(4));
            %lstr=setspectrumcolor(h(:,1), w(cols));
            %lstr=setspectrumcolor(h(:,2), w(cols));
            hold on;
            h0=plot(m_aero(ok), rateaero(ok,cols(4)), '.','color',[.5 .5 .5]);
            chi=get(gca,'children');
            set(gca,'children',flipud(chi));
            ylabel('Count Rate (/ms) for Aerosols');
            starttstr=datestr(langley(1), 31);
            stoptstr=datestr(langley(2), 13);
            title([starttstr ' - ' stoptstr ', Screened STDx' num2str(stdev_mult(k), '%0.1f')]);
            if savefigure;
                starsas(['star' daystr 'rateaerovairmass' num2str(stdev_mult(k), '%0.1f') 'xSTD_Langley',num2str(langnum),'.fig, starLangley.m']);
            end;
            if (k==1 && (langnum==1 || langnum==4));%the strictest stdev option 
                figure(multilangleyfig)
                plot(0:15,((0:15).*-od(k,407)+log(c0new(k,407))),'-','color',daycolor{daynum},'linewidth',2);

            end
        end;
        eval(['c0new_',alldays{daynum},'_',num2str(langnum),'=c0new;'])
        eval(['slope_',alldays{daynum},'_',num2str(langnum),'=od;'])
        eval(['m_aero_',alldays{daynum},'_',num2str(langnum),'=m_aero(ok),;'])
        eval(['rateaero_',alldays{daynum},'_',num2str(langnum),'=(rateaero(ok,:));'])


        %********************
        % estimate unc
        %********************
        unc=3.0/100; % 3.0% this if for the range of min-max values due to changing aerosol in the scene and temperature effect
        c0unc=c0new.*unc';

        %********************
        % save new c0
        %********************
        viscols=1:1044;
        nircols=1044+(1:512);
        k=1; % select one of the multiple screening criteria (stdev_mult), or NaN (see below).
        c0unc = real(c0unc(k,:));
        if isnumeric(k) && k>=1; % save results from the screening/regression above
            %c0unc=NaN(size(w)); % put NaN for uncertainty - to be updated later
            c0unc = real(c0unc(k,:));
            filesuffix=['refined_Langley_ORACLES2016']; %exactly what it sounds like?
            filesuffix=['refined_Langley_MLO_Nov2016'];
            % additionalnotes='Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging.';
            additionalnotes=['Data outside ' num2str(stdev_mult(k), '%0.1f') 'x the STD of 501 nm Langley residuals were screened out.'];
            % additionalnotes='Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging. The Langley results were lowered by 0.8% in order to represent the middle FORJ sensitivity.';
        elseif isequal(k, 'addunc'); % add unc to an existing c0 file
            daystr='20120722';
            originalfilesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity'
            filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity_updatedunc'
            for kk=1:2;
                if kk==1;
                    spec='VIS';
                elseif kk==2;
                    spec='NIR';
                end;
                a=importdata(fullfile(starpaths, [daystr '_' spec '_C0_' originalfilesuffix '.dat']));
                if kk==1;
                    w=a.data(:,2)';
                    c0new=a.data(:,3)';
                elseif kk==2;
                    w=[w a.data(:,2)'];
                    c0new=[c0new a.data(:,3)'];
                end;
            end;
            source='20120722Langleystarsun.mat';
            c0unc=c0new.*unc_TCAP1';
            additionalnotes='Uncertainty was given by combining 0.8% FORJ impact and difference/2 between Feb 12 and 14 2013 air Langley results. Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging. The Langley results were lowered by 0.8% in order to represent the middle FORJ sensitivity.';
            k=1;
            viscols=(1:1044)';
            nircols=1044+(1:512)';
        elseif ~isfinite(k); % save after averaging
            daystr='20130212';
            originalfilesuffix='refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone';
            daystr2='20130214';
            originalfilesuffix2='refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone';
            for kk=1:2;
                if kk==1;
                    spec='VIS';
                elseif kk==2;
                    spec='NIR';
                end;
                filesuffix=[originalfilesuffix '_averagedwith20130214'];
                a=importdata(fullfile(starpaths, [daystr2 '_' spec '_C0_' originalfilesuffix2 '.dat']));
                if kk==1;fullfile(starpaths, [daystr '_' spec '_C0_' originalfilesuffix '.dat']);
                    w=(a.data(:,2)'+b.data(:,2)')/2;            
                    c0new=(a.data(:,3)'+b.data(:,3)')/2;
                    c0unc=(a.data(:,4)'+b.data(:,4)')/2;
                elseif kk==2;
                    w=[w (a.data(:,2)'+b.data(:,2)')/2];            
                    c0new=[c0new (a.data(:,3)'+b.data(:,3)')/2];
                    c0unc=[c0unc (a.data(:,4)'+b.data(:,4)')/2];
                end;
            end;
            source='(SEE ORIGINAL FILES FOR SOURCES)';
            additionalnotes=['Average of the ' daystr ' and ' daystr2 ' Langley C0, ' originalfilesuffix ' and ' originalfilesuffix2 '.'];
            k=1;
            viscols=(1:1044)';
            nircols=1044+(1:512)';
        end;
        visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
        nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);
%         starsavec0(visfilename, source, additionalnotes, w(viscols), c0new(k,viscols), c0unc(:,viscols));
%         starsavec0(nirfilename, source, additionalnotes, w(nircols), c0new(k,nircols), c0unc(:,nircols));
        % be sure to modify starc0.m so that starsun.m will read the new c0 files.

    end
end