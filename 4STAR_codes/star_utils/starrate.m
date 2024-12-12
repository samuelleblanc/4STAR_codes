function [rate, dark, darkstd, note]=starrate(s, bounds,instrumentname)

% derives the count rate from 4STAR raw counts. The derivation is basically
% (raw-dark)/integration_time, but some adjustments are made to account for
% the non-linearity of the detector response - the latter task is under
% development as of April 2012.
% input s must be a structure containing the following fields
% t
% raw
% Str (shutter)
% Tint (integration time in ms)
% note
% As an optional input, bounds defines the range of data from which darks
% are determined, and is either 'bookends' (default), 'entireduration', or a
% time interval (a scalar) in the unit of day (e.g., 300/86400).  
% Yohei, 2012/02/07, 2012/04/10
% CJF: no code modification, just annotation
% MS: 2013/11/15 s.rawFORJcorr replaced s.raw
% Yohei, 2013/11/19 rawFORJcorr renamed rawcorr, anticipating corrections
% other than FORJ (e.g., temperature dependence).
% MS, 2014/04/24; renamed rawcorr to raw since now FORJ correction
% is applied on rate and not on raw
% SL: 2014/10/08: applied the rate calculation on rawcorr instead of raw, 
%                 to use linearly corrected data
% SL: v1.0, 2014/10/13: added version control to this m-script via version_set
% SL: v1.1, 2014/10/17: - added statements to use darks that have been interpolated from the
%                       darks at other integration times if none are available, 
%                       - added check on darks if they are too large,
%                         VIS @ 574 nm > 1000, NIR @ 1283.7 nm > 2000
% SL: v1.2, 2015/02/13: - added check in dark interpolation to skip if there is a
%                         dark count for a specific wavelength that is zero to skip
% SL: v1.3, 2015/03/04: - fixed bug of interpolating dark when there is
%                         only one unique dark
% SL: v1.4, 2015/05/06: - changed of calculating darks from rawcorr to raw
%                         (not corrected for nonlinearity)
%                       - added fix to dark interpolation when only single
%                         integration time of dark present, but not in
%                         right integration times of signal.
% SL: v2.0, 2017/05/28: - added instrumentname field for running other
%                         intruments, with special codes for 2STAR
% CJF: v2.1, 2017,08/10:- added test for rawcorr else use raw to permit
%                         processing of non-sun mode files.  Also replaced
%                         tests based on s.w with tests on q to eliminate
%                         need for w.
% SL: v2.2, 2021/04/01: - changed the highest value of darks permitted for
%                         4STAR vis. 
version_set('2.2');

% development
% !!! allow interpolation, rather than simple averaging, within each bound
% !!! update the variable names and description after daq revision.
% !!! Consider details of sky scan sequence and implications on dark subt.

% control input variables
if isfield(s,'rawcorr')
   [p,q]=size(s.rawcorr);
elseif isfield(s,'raw')
   [p,q]=size(s.raw);
end
%
if size(s.t,1)~=p | size(s.Str,1)~=p | size(s.Tint,1)~=p;
    error('Input variables must all have the same number of rows.');
end;
if nargin<2;
    bounds='bookends';
    instrumentname = '4STAR';
    if now<datenum([2012 09 29]); % record keeping
        bounds='bookends';
    end;
end;
% CJF: we may need to make special accommodation for how the darks are
% collected during the sky scans.  For example, given that the sky scans
% are pretty short we probably don't need to interpolate, but since the
% integration time changes for different sky zone we'll want to subtract
% the correct darks for each integration time.
% determine dark and its variability
dark=s.raw;
%dark=s.raw;
%% get all darks except for the ones with the shutter open
if strcmp(instrumentname,'2STAR'); % special code for 2STAR darks, since it does not have a shutter
    dark(s.Md~=0,:)=NaN;
else; % Default to 4STAR type processing with shutter
    dark(s.Str~=0,:)=NaN;
end;
% darkstd=s.rawFORJcorr+NaN;
darkstd=s.raw+NaN;
[tintu, ui, uj]=unique(s.Tint);
for uu=1:length(tintu); % for each integration time
    rowsu=find(uj==uu);
    if isempty(bounds) | (~isnumeric(bounds) & isequal(lower(bounds), 'entireduration'));
        dark(rowsu,:)=repmat(nanmean(dark(rowsu,:),1),size(rowsu));
        darkstd(rowsu,:)=repmat(nanstd(dark(rowsu,:),1),size(rowsu));
        note='over entire duration.';
        % check if the darks are too large
        if q==512; % it is the nir spectrometer
%         if length(s.w)==512; % it is the nir spectrometer
           if any(dark(rowsu,200) > 2000); 
               dark(rowsu(dark(rowsu,200)>2000),:)=NaN;
               note=[note ' Dark too high, therefore ignored.'];
           end;
        elseif q==256; % it is for the vis on 2STAR
%         elseif length(s.w)==256; % it is for the vis on 2STAR
            if any(dark(rowsu,50) > -70);
                dark(rowsu(dark(rowsu,50)>-70),:)=NaN;
                note=[note ' Dark for 2STAR too high, therefore ignored.'];
            end;
        else % for the VIS spectrometer
           if any(dark(rowsu,500) > 1250); 
               dark(rowsu(dark(rowsu,500)>1250),:)=NaN; 
               note=[note ' Dark too high, therefore ignored.'];
           end;
        end;
    else
        if isstr(bounds) & (isequal(lower(bounds), 'bookends') | isequal(lower(bounds), 'bookend') | isequal(lower(bounds), 'sandwich'));
            diffstr=diff(s.Str(rowsu));
            diffrowsu=diff(rowsu);
            darkbounds=[find(([1;diffstr]~=0 | [1; diffrowsu]>1) & s.Str(rowsu)==0) find(([diffstr;1]~=0 | [diffrowsu;1]>1) & s.Str(rowsu)==0)];
            if ~isempty(darkbounds)
                if size(darkbounds,1)==1;
                    index=repmat(darkbounds, size(rowsu));
                else
                    index=[floor(interp1(darkbounds(:,1), 1:size(darkbounds,1), 1:length(rowsu)))' ceil(interp1(darkbounds(:,2), 1:size(darkbounds,1), 1:length(rowsu)))'];
                    index(1:darkbounds(1,1),1)=1;
                    index(darkbounds(end,1):end,1)=size(darkbounds,1);
                    index(1:darkbounds(1,2),2)=1;
                    index(darkbounds(end,2):end,2)=size(darkbounds,1);
                    index=[darkbounds(index(:,1),1) darkbounds(index(:,2),2)];
                end;
            else
                index=[];
            end;
            note='over nearest (before and after) dark measurement blocks.';
            % check if the darks are too large
            if q==512; % it is the nir spectrometer
%             if length(s.w)==512; % it is the nir spectrometer
              if any(dark(rowsu,200) > 2000); 
                  dark(rowsu(dark(rowsu,200)>2000),:)=NaN; 
                  note=[note ' Dark too high, therefore ignored.'];
              end;
            elseif q==256; % it is for the vis on 2STAR
%             elseif length(s.w)==256; % it is for the vis on 2STAR
              if any(dark(rowsu,50) > -70);
                  dark(rowsu(dark(rowsu,50)>-70),:)=NaN; 
                  note=[note ' Dark for 2STAR too high, therefore ignored.'];
              end;
            else % for the VIS spectrometer
              if any(dark(rowsu,500) > 1250); 
                  dark(rowsu(dark(rowsu,500)>1250),:)=NaN; 
                  note=[note ' Dark too high, therefore ignored.'];
              end;
            end;
        elseif isstr(bounds)
            error([bounds ' is not an option.']);
        elseif numel(bounds)==1; % assume a time interval (in day) is given
            index=[ceil(interp1(s.t(rowsu), 1:length(rowsu), s.t(rowsu)-bounds/2)) floor(interp1(s.t(rowsu), 1:length(rowsu), s.t(rowsu)+bounds/2))];
            index(isnan(index(:,1)),1)=1;
            index(isnan(index(:,2)),2)=length(rowsu);
            note=['over dark measurements within +/- ' num2str(bounds/2*86400) ' seconds.']; 
        elseif size(bounds,1)==p & size(bounds,2)==2;
            index=bounds;
            note='over time periods of user''s choice';
        else
            error('Bounds?')
        end;
        if ~isempty(index);
            [dark0sum,snsum]=sumvec(dark(rowsu,:),index);
            [darkstd(rowsu,:),snstd]=stdvec(dark(rowsu,:),index);
            dark(rowsu,:)=dark0sum./snsum;            
            note=['Darks averaged ' note];
            % check if the darks are too large
            if q==512; % it is the nir spectrometer
%             if length(s.w)==512; % it is the nir spectrometer
              if any(dark(rowsu,200) > 2000); 
                  dark(rowsu(dark(rowsu,200)>2000),:)=NaN; 
                  note=[note ' Dark too high, therefore ignored.'];
              end;
            elseif q==256; % it is for the vis on 2STAR
%             elseif length(s.w)==256; % it is for the vis on 2STAR
              if any(dark(rowsu,50) > -70);
                  dark(rowsu(dark(rowsu,50)>-70),:)=NaN; 
                  note=[note ' Dark for 2STAR too high, therefore ignored.'];
              end;
            else % for the VIS spectrometer
              if any(dark(rowsu,500) > 1250); %Changed in 2021-04-01 for 4STAR high darks 
                  dark(rowsu(dark(rowsu,500)>1250),:)=NaN; 
                  note=[note ' Dark too high, therefore ignored.'];
              end;
            end;

        end;
    end;
end;

%% check if there are missing darks
if any(any(isnan(dark)));
    [ngtint,ngi]=unique(s.Tint(any(isnan(dark),2)==1));
    warning(['Dark not measured for ' num2str(sum(any(isnan(dark),2))) ' data points.']);
    warning('Integration times (ms) were:');
    for nn=1:length(ngtint);
        warning([num2str(ngtint(nn)) ' (e.g., ' datestr(s.t(ngi(nn)), 31) ', row #' num2str(ngi(nn)) ')']);
    end;
    if any(any(isfinite(dark))); % checking to see if there are any darks to use
        warning('.. Using darks interpolated/extrapolated from other integration times');
        inotemptydark=any(isfinite(dark'));
        for iw=1:q; % loop through each wavelength
        %for iw=1:length(s.w); % loop through each wavelength
          % calculate dark rate for non empty darks
          darkrate(:,iw)=dark(inotemptydark,iw)./s.Tint(inotemptydark);
          if any(~darkrate(:,iw)); continue, end; % make sure that the darkrate is not just zeros
          % double check for non-unique values
          [darkrate_unique,iunique,inonunique] = unique(darkrate(:,iw));
          inum_notemptydark = find(inotemptydark);
          [t_withdark_unique, i_withdark_unique] = unique(s.t(inum_notemptydark(iunique)));
          % check if there is only one darkrate (SL 2015-04-03)
          if length(t_withdark_unique)==1
              darkrate_filled(:,iw) = repmat(darkrate_unique(i_withdark_unique),[length(s.t),1]);
          else
              % interpolate the dark rate to all the available times
              darkrate_filled(:,iw)=interp1(t_withdark_unique,darkrate_unique(i_withdark_unique),s.t,'linear','extrap');
          end
          % repopulate the empty darks with the new interpolated/extrapolated dark_rate*Tint
          dark(~inotemptydark,iw)=darkrate_filled(~inotemptydark,iw).*s.Tint(~inotemptydark);
        end;
        clear darkrate darkrate_filled inotemptydark
        note=[note, '.. darks for Tint:' num2str(ngtint(nn)) ' were interpolated/extrapolated from darks of other integration times'];
    end;
end;

%% check darks for any problems
if q==512 % it is the nir spectrometer
% if length(s.w)==512; % it is the nir spectrometer
    if any(dark(:,200) > 2000);
        warning('NIR darks too large, please double check');
    end;
elseif q==256; % it is for the vis on 2STAR
% elseif length(s.w)==256; % it is for the vis on 2STAR
    if any(dark(:,50) > -70);
         warning('2STAR VIS darks too large, please double check');
    end;
else % for the VIS spectrometer
    if any(dark(:,500) > 1250);
        warning('VIS darks too large, please double check');
    end;
end;

%% final calculations of rate
% determine adjustment factor (for read-out time or something, TO BE UPDATED).
adj=1; 

% subtract dark and divide by integration time
% rate=(s.rawFORJcorr-dark)./repmat(s.Tint,1,q).*adj;
if isfield(s,'rawcorr')
   rate=(s.rawcorr-dark)./repmat(s.Tint,1,q).*adj;
else
   rate=(s.raw-dark)./repmat(s.Tint,1,q).*adj;
end
if strcmp(instrumentname,'2STAR'); %special processing for 2STAR without shutter and added a time lag
    irun = find(s.Md==1); d = find(diff(irun)~=1)+1;
    ii = []; for i=1:length(d); ii = [ii,irun(d(i))-1:irun(d(i))+10]; end;
    rate(ii,:)=NaN; 
    rate(s.Md==0,:)=NaN; 
    dark(s.Md==0,:)=s.raw(s.Md==0,:);
else;
    rate(s.Str==0,:)=NaN; % exclude rate when shutter was closed
    % dark(s.Str==0,:)=s.rawFORJcorr(s.Str==0,:); % give the direct dark measurements when available instead of extrapolated values
    dark(s.Str==0,:)=s.raw(s.Str==0,:); % give the direct dark measurements when available instead of extrapolated values
end;