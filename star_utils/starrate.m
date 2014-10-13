function [rate, dark, darkstd, note]=starrate(s, bounds)

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
version_set('1.0');

% development
% !!! allow interpolation, rather than simple averaging, within each bound
% !!! update the variable names and description after daq revision.
% !!! Consider details of sky scan sequence and implications on dark subt.

% control input variables
 [p,q]=size(s.rawcorr);
%[p,q]=size(s.raw);
if size(s.t,1)~=p | size(s.Str,1)~=p | size(s.Tint,1)~=p;
    error('Input variables must all have the same number of rows.');
end;
if nargin<2;
    bounds='bookends';
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
dark=s.rawcorr;
%dark=s.raw;
dark(s.Str~=0,:)=NaN;
% darkstd=s.rawFORJcorr+NaN;
darkstd=s.rawcorr+NaN;
[tintu, ui, uj]=unique(s.Tint);
for uu=1:length(tintu); % for each integration time
    rowsu=find(uj==uu);
    if isempty(bounds) | (~isnumeric(bounds) & isequal(lower(bounds), 'entireduration'));
        dark(rowsu,:)=repmat(nanmean(dark(rowsu,:),1),size(rowsu));
        darkstd(rowsu,:)=repmat(nanstd(dark(rowsu,:),1),size(rowsu));
        note='over entire duration.';
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
        end;
    end;
end;
if any(any(isnan(dark)));
    [ngtint,ngi]=unique(s.Tint(any(isnan(dark),2)==1));
    warning(['Dark not measured for ' num2str(sum(any(isnan(dark),2))) ' data points.']);
    warning('Integration times (ms) were:');
    for nn=1:length(ngtint);
        warning([num2str(ngtint(nn)) ' (e.g., ' datestr(s.t(ngi(nn)), 31) ', row #' num2str(ngi(nn)) ')']);
    end;
end;

% determine adjustment factor (for read-out time or something, TO BE UPDATED).
adj=1; 

% subtract dark and divide by integration time
% rate=(s.rawFORJcorr-dark)./repmat(s.Tint,1,q).*adj;
rate=(s.rawcorr-dark)./repmat(s.Tint,1,q).*adj;
rate(s.Str==0,:)=NaN; % exclude rate when shutter was closed
% dark(s.Str==0,:)=s.rawFORJcorr(s.Str==0,:); % give the direct dark measurements when available instead of extrapolated values
dark(s.Str==0,:)=s.rawcorr(s.Str==0,:); % give the direct dark measurements when available instead of extrapolated values