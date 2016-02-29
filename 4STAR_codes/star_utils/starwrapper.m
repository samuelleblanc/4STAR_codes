function	s=starwrapper(s, s2, varargin)

%% STARWRAPPER, called in the middle of a 4STAR processing code (e.g.,
% starsun.m, starsky.m), adds variables and makes adjustments common among
% all data types. When a second input s2 is given, s2 is combined to s.
%
% Files required
% starinfo file of the day, c0 files (VIS and NIR; see starc0.m),
% cross_sections file (see taugases.m), FWHM file (see starwavelengths.m).
% Place all of them under "matfolder" (see starpaths.m).
%
% Yohei, 2012/04/11
% CJF: 2012/10/05 Inserted commented placeholder function for radiance cals
% Yohei: 2012/10/05 Inserted comments.
% Yohei: 2012/10/09, 2012/10/19 New flags: signal lower than dark STD, non-positive C0.
% Some house keeping. Flag for large airmass.
% Yohei: 2012/10/09-2012/10/18 Major updates on figures.
% Yohei: 2012/11/27 Tplate implemented.
% Yohei: 2012/12/15 starinfo is now read near the beginning of this code,
% instead of right before cloud screening. This was meant to be a quick fix
% for the time stamp, but may not have been necessary. Later I decided to
% tweak the raw files instead.
% Yohei: 2013/01/25 NO2col now read from starinfo.
% Yohei: 2013/01/30 asymmetric c0unc and tau_aero_err introduced.
% MS: 2013/11/15 Added get_forj_corr
% MS: 2013/11/15 replaced: [s.rate_noFORJcorr, s.dark, s.darkstd,
% note]=starrate(s); with [s.rate, s.dark, s.darkstd, note]=starrate(s);
% MS: 2013/11/15: commented out: %adjust for FORJ sensitivity
% Yohei: 2013/11/19: added saveadditionalvariables and computeerror
% switches for users with limited computer memory. Also s.rawFORJcorr, and
% s2.rawFORJcorr are now computed once, not through double loops.
% rawFORJcorr renamed rawcorr, in anticipation of corrections on raw for
% items other than FORJ (e.g., temperature dependence). starrate.m modified
% accordingly.
% MS: 2013/11/19: added gas retrieval into this version
% MS: 2013/11/19: added H2O/CO2 corrections
% SL: 2014/07/18: added nonlinear correction scheme to raw counts, added
% switches for verbose output of the code running
% MS: 2014/07/25: added call to starc0mod
% MS: 2014/07/25: unified water vapor and o3 subtraction into
% gasessubtract routine
% MS: 2014/08/12: eliminated mode 1 /2 for gases
% MS: 2014/08/14: currently all subtractions are from one sub-routine
% cwv is retrieved by cwvcorecalc
% MS: 2014-08-22: added check for s2 struct in initial s2.note calls and
% nonlinear correction
% MS: 2014-08-23: added s2.note={}
% MS: 2014-08-27: added tau_err to s struct
% MS: 2014-08-28: applytempcorr switch (line 375)
% SL: 2014-10-06: added logic to use switches even when there is only one
%                 input structure
% SL: v1.0, 2014-10-10: set verison control of this script, with version_set
% SL: v1.1, 2014-11-12: changed switches to toggles in a toggle structure
%                       - added gassubstract toggle
%                       - added booleanflagging toggle
%                       - added flagging toggle
% MS: 2014/11/14: corrected bug in cwvcorecalc
% MS: 2014/11/17: commented spec_aveg_cwv out
% SL: v1.3, 2014-11-24: added check to ensure that no sun-specific
%                       processing occurs when in FOV.
%                       - changed the default values of the toggles.
% MS: v1.4, 2015-01-09: added toggle field lampcalib to chose between c0/lampc0 calib
% SL: v1.4, 2015-01-09: fixed bug in toggle checking
% SL: v1.5, 2015-02-05: added starinfo2 file which is a function file, for
%                       use with pleaides cluster
% SL: v1.6, 2015-02-13: can now put in a toggle structure as an argument,
%                       combines this toggle structure to the defaults, with preference over the
%                       input
% MS: v1.7, 2015-02-19: added total optical depth fields for gas utils
% MS: v1.8, 2015-04-07: added tau_O4nir field in preparation to use fitted
%                       gases subtraction for archiving
% SL: v1.9, 2015-08-27: added useability of starwrapper with toggles and a
%                       single s struct, no s2
% MS: v1.9, 2015-10-20: added verification plots comparing rateaero and
%                       gases subtracted structures, commented out
% YS: v2.0, 2015-11-02: slimmed down the output when
%                       saveadditionalvariables is set to false
% SL: v2.1, 2015-11-05: using outside function (update_toggle) to set default toggles
% YS: v2.2, 2015-11-06: added the applyforjcorr toggle
% SL: v2.3, 2015-11-22: fixed bugs in the functional calls of the starinfo files
% MS: v2.4, 2015-11-30: added variables to taugases, for reading OMI o3/no2 data
% MS: v2.5, 2016-01-09: changed starwrapper manually according to Yohei
%                       starwrapper version from Jan-05-2016
%                       changed s.tau_aero_err6 calculation to avoid
%                       dimension mistmatch bug
%                       changed flags.aerosol_init_auto to flags.bad_aod to
%                       make it compatible with starflag
% MS: v2.6, 2015-02-29: added recent changes after MLO of constant stray light correction

version_set('2.6');  
%********************
%% prepare for processing
%********************

%% set default toggle switches
toggle = update_toggle;

if isfield(s, 'toggle')
    s.toggle = catstruct(s.toggle, toggle); % merge, overwrite s.toggle with toggle
    toggle = s.toggle;
else
    s.toggle = toggle;
end

%% check if the toggles are set in the call to starwrapper
if (~isempty(varargin))
    if nargin==3;
        nnarg=1;
        if isa(varargin{1},'struct'); % check if its a toggle structure
            toggle = catstruct(toggle,varargin{1}); %concatenate the toggles, but with preference over the input toggle
        end;
    else;
        nnarg=2;
        if mod(nargin,2); % varargin not paired
            varargin={s2,varargin{:}};
        end;
        for c=1:2:length(varargin)-1
            switch varargin{c}
                case {'verbose'}
                    c=c+1;
                    toggle.verbose=varargin{c};
                    disp(['verbose set to ' num2str(toggle.verbose)])
                case {'saveadditionalvariables'}
                    c=c+1;
                    toggle.saveadditionalvariables=varargin{c};
                    disp(['saveadditionalvariables set to ' num2str(toggle.saveadditionalvariables)])
                case {'savefigure'}
                    c=c+1;
                    toggle.savefigure=varargin{c};
                    disp(['savefigure set to ' num2str(toggle.savefigure)])
                case {'computeerror'}
                    c=c+1;
                    toggle.computeerror=varargin{c};
                    disp(['computeerror set to ' num2str(toggle.computeerror)])
                case {'inspectresults'}
                    c=c+1;
                    toggle.inspectresults=varargin{c};
                    disp(['inspectresults set to ' num2str(toggle.inspectresults)])
                case {'applynonlinearcorr'}
                    c=c+1;
                    toggle.applynonlinearcorr=varargin{c};
                    disp(['applynonlinearcorr set to ' num2str(toggle.applynonlinearcorr)])
                case {'applytempcorr'}
                    c=c+1;
                    toggle.applytempcorr=varargin{c};
                    disp(['applytempcorr set to ' num2str(toggle.applytempcorr)])
                case {'applyforjcorr'}
                    c=c+1;
                    toggle.applytempcorr=varargin{c};
                    disp(['applyforjcorr set to ' num2str(toggle.applyforjcorr)])
                otherwise
                    error(['Invalid optional argument, ', ...
                        varargin{c}]);
                    nnarg=0;
            end % switch
        end % for
    end; % nargin==1
else
    nnarg = 0;
    if nargin==2;
        if ~isfield(s2,'t');
            nnarg=1;
            toggle = catstruct(toggle,s2)
        end;
    end;
end; % if

%% remerge the toggles and if not created make the s.toggle struct
if isfield(s, 'toggle')
    s.toggle = catstruct(s.toggle, toggle); % merge, overwrite s.toggle with toggle
    toggle = s.toggle;
else
    s.toggle = toggle;
end

if toggle.verbose;  disp('In Starwrapper'), end;

%% start taking notes
if ~isfield(s, 'note');
    s.note={};
end;
if ischar(s.note)
    s.note = {s.note};
end
if nargin>=2+nnarg && ~isfield(s2, 'note');
    s2.note={};
    
    if ischar(s2.note)
        s2.note = {s2.note};
    end
end;
s2.note={};

%% get data type
if toggle.verbose; disp('get data types'), end;
[daystr, filen, datatype]=starfilenames2daystr(s.filename, 1);
if nargin>=(2+nnarg)
    [daystr2, filen2, datatype2]=starfilenames2daystr(s2.filename, 1);
end;

%********************
%% get additional info specific to this data set
%********************
if toggle.verbose; disp('get additional info specific to file'), end;
s.ng=[]; % variables needed for this code (starwrapper.m).
s.O3h=[];s.O3col=[];s.NO2col=[]; % variables needed for starsun.m.
s.sd_aero_crit=Inf; % variable for screening direct sun datanote
infofile_ = ['starinfo_' daystr '.m'];
infofile = fullfile(starpaths, ['starinfo' daystr '.m']);
infofile2 = ['starinfo' daystr] % 2015/02/05 for starinfo files that are functions, found when compiled with mcc for use on cluster
dayspast=0;
maxdayspast=365;
if exist(infofile_)==2;
        if toggle.dostarflag
    try
        edit(infofile_) ; % open infofile in case user wants to edit it.
    catch me
        disp(['Problem editing starinfo file. Please open manually: ' infofile_])
    end
    infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
    try
        s = infofnt(s);
    catch
        eval([infofile_(1:end-2),'(s)']);
        %     s = eval([infofile2,'(s)']);
    end
        else
            run(infofile);
        end;
elseif exist(infofile2)==2;
    try
        edit(infofile2) ; % open infofile in case user wants to edit it.
    catch me
        disp(['Problem editing starinfo file. Please open manually: ' infofile_])
    end
    try
        infofnt = str2func(infofile2(1:end-2)); % Use function handle instead of eval for compiler compatibility
        s = infofnt(s);
    catch
        disp('*Problem with executing as script, converting to starinfo function*')
        modify_starinfo(which(infofile2));
        infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
        s = infofnt(s);
    end
    %     s = eval([infofile2,'(s)']);
elseif exist(infofile)==2;
    open(infofile);
    run(infofile); %Trying "run" instead of "eval" for better compiler compatibility
    %         eval(['run ' infofile ';']); % 2012/10/22 oddly, this line ignores the starinfo20120710.m after it was edited on a notepad (not on the Matlab editor).
else; % copy an existing old starinfo file and run it
    while dayspast<maxdayspast;
        dayspast=dayspast+1;
        infofile_previous=fullfile(starpaths, ['starinfo' datestr(datenum(daystr, 'yyyymmdd')-dayspast, 'yyyymmdd') '.m']);
        if exist(infofile_previous);
            copyfile(infofile_previous, infofile);
            open(infofile);
            run(infofile);
            %             eval(['edit ' infofile ';']);
            %             eval(['run ' infofile ';']);
            warning([infofile ' has been created from ' ['starinfo' datestr(datenum(daystr, 'yyyymmdd')-dayspast, 'yyyymmdd') '.m'] '. Inspect it and add notes specific to the measurements of the day, for future data users.']);
            break;
        end;
    end;
end;
if dayspast>=maxdayspast;
    error(['Make ' infofile ' available.']);
end;
if isempty(s.O3h) || isempty(s.O3col);
    warning(['Enter ozone height and column density in starinfo' daystr '.m.']);
end;
if isempty(s.NO2col);
    warning(['Enter nitric dioxide column density in starinfo' daystr '.m.']);
end;
if isfield(s,'toggle')
    toggle = s.toggle;
end
%********************
%% add related variables, derive count rate and combine structures
%********************
%% include wavelengths in um and flip NIR raw data
if toggle.verbose; disp('add related variables, count rate and combine structures'), end;
[visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(nanmean(s.t)); % wavelengths
if ~toggle.lampcalib % choose Langley c0
    [visc0, nirc0, visnotec0, nirnotec0, ~, ~, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(nanmean(s.t),toggle.verbose);     % C0
else                 % choose lamp adjusted c0
    [visc0, nirc0, visnotec0, nirnotec0, ~, ~, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0lamp(nanmean(s.t),toggle.verbose); % C0 adjusted with lamp values
end
[visc0mod, nirc0mod, visc0modnote, nirc0modnote, visc0moderr, nirc0moderr,model_atmosphere]=starc0mod(nanmean(s.t),toggle.verbose);% this is for calling modified c0 file
s.c0mod = [visc0mod';nirc0mod'];% combine arrays
[visresp, nirresp, visnoteresp, nirnoteresp, ~, ~, visaeronetcols, niraeronetcols, visresperr, nirresperr] = starskyresp(nanmean(s.t(1)));
if ~isempty(strfind(lower(datatype),'vis'));
    s.w=visw;
    s.c0=visc0;
    s.c0err=visc0err;
    s.fwhm=visfwhm;
    s.aerosolcols=visaerosolcols;
    s.skyresp = visresp;
    s.aeronetcols = visaeronetcols;
    s.skyresperr = visresperr;
    s.note(end+1,1)={visnote}; s.note(end+1,1)={visnotec0};s.note(end+1,1)={visnoteresp};
elseif strmatch('nir', lower(datatype))
    s.raw=fliplr(s.raw); % ascending order of the wavelength (reverse of the wavenumber)
    s.w=nirw;
    s.c0=nirc0;
    s.c0err=nirc0err;
    s.fwhm=nirfwhm;
    s.aerosolcols=niraerosolcols;
    s.skyresp = nirresp;
    s.aeronetcols = niraeronetcols;
    s.skyresperr = nirresperr;
    s.note(end+1,1)={nirnote}; s.note(end+1,1)={nirnotec0}; s.note(end+1,1)={nirnoteresp};
end;
if size(s.raw,2)<1000
    sat_val = 32767;
else
    sat_val = 65535;
end
if toggle.verbose; disp('...calculating saturated points'); end;
s.sat_time = max(s.raw,[],2)==sat_val;
s.sat_pixel = max(s.raw,[],1)==sat_val;
s.sat_ij = (s.raw==sat_val);
if nargin>=2+nnarg
    if strmatch('vis', lower(datatype2));
        s2.w=visw;
        s2.c0=visc0;
        s2.c0err=visc0err;
        s2.fwhm=visfwhm;
        s2.aerosolcols=visaerosolcols;
        s2.skyresp = visresp;
        s2.aeronetcols = visaeronetcols;
        s2.skyresperr = visresperr;
        s2.note(end+1,1)={visnote}; s2.note(end+1,1)={visnotec0};s2.note(end+1,1)={visnoteresp};
    elseif strmatch('nir', lower(datatype2));
        s2.raw=fliplr(s2.raw); % ascending order of the wavelength (reverse of the wavenumber)
        s2.w=nirw;
        s2.c0=nirc0;
        s2.c0err=nirc0err;
        s2.fwhm=nirfwhm;
        s2.aerosolcols=niraerosolcols;
        s2.skyresp = nirresp;
        s2.aeronetcols = niraeronetcols;
        s2.skyresperr = nirresperr;
        s2.note(end+1,1)={nirnote}; s2.note(end+1,1)={nirnotec0}; s2.note(end+1,1)={nirnoteresp};
    end;
    if size(s2.raw,2)<1000
        sat_val = 32767;
    else
        sat_val = 65535;
    end
    s2.sat_time = max(s2.raw,[],2)==sat_val;
    s2.sat_pixel = max(s2.raw,[],1)==sat_val;
    s2.sat_ij = (s2.raw==sat_val);
end;

%% run nonlinear correction on raw counts
if toggle.applynonlinearcorr
    if toggle.verbose; disp('Applying nonlinear correction'), end;
    %if ~exist('vis_sun'), stophere; end;
    s_raw=correct_nonlinear(s.raw, toggle.verbose);
    if nargin>=2+nnarg;
        r_raw=correct_nonlinear(s2.raw, toggle.verbose);
    end;
    s.rawcorr=s_raw;
    if nargin>=2+nnarg;
        s2.rawcorr=r_raw;
    end;
    if toggle.verbose; disp('finished running nonlinear correction'), end;
else
    s.rawcorr=s.raw;
    if nargin>=2+nnarg;
        s2.rawcorr=s2.raw;
    end;
end;

%% subtract dark and divide by integration time
if toggle.verbose; disp('substract darks and divide by integration time'), end;
[s.rate, s.dark, s.darkstd, note]=starrate(s);

s.note(end+1,1)={note};
if nargin>=2+nnarg
    [s2.rate, s2.dark, s2.darkstd, note2]=starrate(s2);
    s2.note(end+1,1)={note};
end;
%sum_isnan=sum(isnan(s.rate(1,:)))
% combine two structures
if toggle.verbose; disp('out of starrate, combining two structures'), end;
drawnow;
pp=numel(s.t);
qq=size(s.raw,2);
if nargin>=2+nnarg
    % check whether the two structures share almost identical time arrays
    if pp~=length(s2.t);
        bad_t=find(diff(s.t)<=0);
        bad_t2=find(diff(s2.t)<=0);
        if length(bad_t2) > 0
            disp('bad_t2 larger than 0');
        end
        [ainb, bina] = nearest(s.t, s2.t);
        st_len = length(s.t);
        st2_len = length(s2.t);
        fld = fieldnames(s);
        for fd = 1:length(fld)
            [rr,col] = size(s.(fld{fd}));
            if rr == st_len && col==1
                s.(fld{fd}) = s.(fld{fd})(ainb);
                s2.(fld{fd}) = s2.(fld{fd})(bina);
            elseif rr==st_len && col == length(s.w)
                s.(fld{fd}) = s.(fld{fd})(ainb,:);
                s2.(fld{fd}) = s2.(fld{fd})(bina,:);
            end
        end
        
        %         error(['Different size of time arrays. starwrapper.m needs to be updated.']);
    end;
    pp=numel(s.t);
    qq=size(s.raw,2);
    ngap=numel(find(abs(s.t-s2.t)*86400>0.02));
    if ngap==0;
    elseif ngap<pp*0.2; % less than 20% of the data have time differences. warn and proceed.
        warning([num2str(ngap) ' rows have different time stamps between the two arrays by greater than 0.02s.']);
    else; % many differences. stop.
        error([num2str(ngap) ' rows have different time stamps between the two arrays by greater than 0.02s.']);
    end;
    % check whether the two structures come from separate spectrometers
    if isequal(lower(datatype(1:3)), lower(datatype2(1:3)))
        error('Two structures must be for separate spectrometers.');
    end;
    % discard the s2 variables for which s has duplicates
    if toggle.verbose, disp('discarding duplicate structures'), end;
    fn={'Str' 'Md' 'Zn' 'Lat' 'Lon' 'Alt' 'Headng' 'pitch' 'roll' 'Tst' 'Pst' 'RH' 'AZstep' 'Elstep' 'AZ_deg' 'El_deg' 'QdVlr' 'QdVtb' 'QdVtot' 'AZcorr' 'ELcorr'};...
        fn={fn{:} 'Tbox' 'Tprecon' 'RHprecon' 'Tplate' 'sat_time'};
    fnok=[]; % Yohei, 2012/11/27
    for ff=1:length(fn); % take the values from the s structure, and discard those in s2
        if isfield(s, fn{ff});
            fnok=[fnok; ff];
            if size(s.(fn{ff}),1)~=pp || size(s2.(fn{ff}),1)~=pp
                error(['Check ' fn{ff} '.']);
            end;
        end;
    end;
    drawnow;
    s2=rmfield(s2, fn(fnok));
    clear fnok; % Yohei, 2012/11/27
    % combine some of the remaining s2 variables into corresponding s variables
    fnc={'raw' 'rawcorr' 'w' 'c0' 'c0err' 'fwhm' 'rate' 'dark' 'darkstd' 'sat_ij' 'skyresp', 'skyresperr'};
    qq2=size(s2.raw,2);
    s.([lower(datatype(1:3)) 'cols'])=1:qq;
    s.([lower(datatype2(1:3)) 'cols'])=(1:qq2)+qq;
    for ff=length(fnc):-1:1;
        if size(s.(fnc{ff}),2)~=qq || size(s2.(fnc{ff}),2)~=qq2
            error(['Check ' fnc{ff} '.']);
        else
            s.(fnc{ff})=[s.(fnc{ff}) s2.(fnc{ff})];
        end;
    end;
    s.aerosolcols=[s.aerosolcols(:)' s2.aerosolcols(:)'];
    %     s.aeronetcols = [s.aeronetcols(:)' s2.aeronetcols(:)'];
    note_x = {[upper(datatype(1:3)) ' and ' upper(datatype2(1:3)) ' data were combined with starwrapper.m. ']};
    note_x(end+1,1) = {[upper(datatype2(1:3)) ' notes: ']};
    for L = 1:length(s.note)
        note_x(end+1,1) = {s.note{L}};
    end
    note_x(end+1,1) = {[upper(datatype(1:3)) ' notes: ']};
    for L = 1:length(s2.note)
        note_x(end+1,1) = {s2.note{L}};
    end
    s.note = note_x;
    %     s.note={[upper(datatype(1:3)) ' and ' upper(datatype2(1:3)) ' data were combined with starwrapper.m. ']; [upper(datatype(1:3)) ' notes: ']; s.note{:} ;...
    %         [upper(datatype2(1:3)) ' notes: ']; s2.note{:}};
    s.filename=[s.filename; s2.filename];
    s2=rmfield(s2, [fnc(:); 'aerosolcols';'aeronetcols'; 'note'; 'filename']);
    % store the remaining s2 variables separately in s
    fn=fieldnames(s2);
    for ff=1:length(fn);
        s.([lower(datatype(1:3)) fn{ff}])=s.(fn{ff});
        s.([lower(datatype2(1:3)) fn{ff}])=s2.(fn{ff});
    end;
    s=rmfield(s, setdiff(fn,'t'));
    qq=qq+qq2;
    clear qq2 s2;
    [daystr, filen, datatype]=starfilenames2daystr(s.filename, 1);
end

%% get solar zenith angle, airmass, temperatures, etc.
v=datevec(s.t);
[s.sunaz, s.sunel]=sun(s.Lon, s.Lat,v(:,3), v(:,2), v(:,1), rem(s.t,1)*24,s.Tst+273.15,s.Pst); % Beat's code
s.sza=90-s.sunel;
s.f=sundist(v(:,3), v(:,2), v(:,1)); % Beat's code
clear v;
[s.m_ray, s.m_aero, s.m_H2O]=airmasses(s.sza, s.Alt); % note ozone airmass will be computed in starsun.m after O3 height is entered.
if isfield(s, 'RHprecon'); % Yohei, 2012/10/19
    s.RHprecon_percent=s.RHprecon*20;
end;
if isfield(s, 'Tprecon'); % Yohei, 2012/10/19
    s.Tprecon_C=s.Tprecon*23-30;
end;
if isfield(s, 'Tbox'); % Yohei, 2012/10/19
    s.Tbox_C=s.Tbox*100-273.15;
end;
if isfield(s, 'Tplate'); % Yohei, 2012/11/27
    s.Tplate_C=s.Tplate*100-273.15;
end;
if isfield(s, 'visVdettemp'); % Yohei, 2013/07/23, from Livingston's plot_4STAR_various.m.
    B=3450;
    T2=298;
    R2=10000;
    R1=s.visVdettemp/1e-05;
    s.visVdettemp_C=1./(log(R1./R2)./B+1./T2)-273.17;
end;
if isfield(s, 'nirVdettemp'); % Yohei, 2013/07/23, from Livingston's plot_4STAR_various.m.
    Anir=1.2891e-03;
    Bnir=2.3561e-04;
    Cnir=9.4272e-08;
    Rnir=s.nirVdettemp/1e-05;  %divide by 10 microamps
    denom_nir=Anir + Bnir*log(Rnir) + Cnir*((log(Rnir)).^3);
    ig3=find(s.nirVdettemp>0);
    s.nirVdettemp_C=NaN(size(s.t));
    s.nirVdettemp_C(ig3)=1./denom_nir(ig3) - 273.16;
end;

%********************
%% adjust the count rate
%********************
if toggle.verbose; disp('adjusting the count rate'), end;
% apply forj correction for nearest forj test
% get correction values
% set toggle.applyforjcorr to 2 for a two-way correction accounting for
% the direction of az rotation, 1 for a one-way correction, 0 for no correction.
if toggle.applyforjcorr && isempty(strfind(lower(datatype),'forj')); % don't apply FORJ correction to FORJ test data, to avoid confusion.
    [forj_corr, detail] = get_forj_corr(s.t(1));
    % apply correction on s.rate
    AZ_deg_   = s.AZstep/(-50);
    AZ_deg    = mod(AZ_deg_,360); AZ_deg = round(AZ_deg);
    AZunique = unique(AZ_deg);
    s.rate=s.rate.*repmat(forj_corr.corr(AZ_deg+1)',1,qq);
    if toggle.applyforjcorr==2;
        dAZdt=diff(s.AZstep/(-50))./diff(s.t)/86400
        dAZdt=([dAZdt; 0]+[0; dAZdt])/2; % rotation rate
        positive_rotation=find(dAZdt>0); % data collected during positive rotation
        negative_rotation=find(dAZdt<0); % data collected during negative rotation
        s.rate(positive_rotation,:)=s.rate(positive_rotation,:).*repmat(forj_corr.corr_cw(AZ_deg(positive_rotation)+1)',1,qq);
        s.rate(negative_rotation,:)=s.rate(negative_rotation,:).*repmat(forj_corr.corr_cw(AZ_deg(negative_rotation)+1)',1,qq);
    end;
end;

%% apply temp correction to rate structs
if toggle.applytempcorr
    corr=startemperaturecorrection(daystr, s.t);
    s.rate  = s.rate.*repmat(corr,1,qq);
end

%% adjust for spectral interference (stray light)
% TO BE DEVELOPED.
if toggle.applystraycorr
    % this is constant correction (time dependent only)
    corr=straylightcorrection(serial2Hh(s.t),s.rate,s.w);
    s.rate  = s.rate - repmat(corr,1,qq);
end

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

s.toggle = toggle;
return
