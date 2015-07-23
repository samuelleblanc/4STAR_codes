function corr=startemperaturecorrection(daystr, t)
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set
% Samuel, v1.1, 2015-07-22, check to see if there is need for more than one
%                           file for loading the track, and handle that
version_set('1.1');
% read track data
try
    load(fullfile(starpaths(daystr), [daystr 'star.mat']), 'track');
catch
    [fna pna]=uigetfile('*star.mat', ['star.mat file for temperature corrections on ' daystr],starpaths(daystr));
    load([pna fna],'track');
end

% check if more than one file is needed:
tvec = datevec(t);
[days, idays] = unique(tvec(:,3));
if length(days)>1;
    % read track data
    daystr2 = datestr(t(idays(2)),'yyyymmdd');
    try
        t2 = load(fullfile(starpaths(daystr), [daystr2 'star.mat']), 'track');
    catch
        [fna pna]=uigetfile(['*' daystr2 '*star.mat'], ['star.mat file for temperature corrections on ' daystr2],starpaths(daystr2));
        t2 = load([pna fna],'track');
    end
    %concatenate the track struct.
    tnames = fieldnames(track);
    for i=1:length(tnames);
        try;
            track.(tnames{i}) = [track.(tnames{i});t2.(tnames{i})];
        end;
    end;
end;
% smooth the temperature record
bl=60/86400;
track.tsm=boxxfilt(track.t, track.T4, bl);
[track.tsorted, ii]=unique(track.t);
difft=-2.0/60.0/24.0;
tsm=interp1(track.tsorted-difft, track.tsm(ii), t);
%stophere
% preliminary temperature dependence correction
% relative_surplus=(tsm-8)*0.0015; % 0.002/degc correction factor for transmittance
relative_surplus=(tsm)*0.0015; % 0.002/degc correction factor for transmittance
corr=1./(1+relative_surplus); % to be multiplied to raw counts, just like the FORJ correction.
