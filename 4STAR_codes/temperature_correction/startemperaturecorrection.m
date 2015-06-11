function corr=startemperaturecorrection(daystr, t)
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set 
version_set('1.0');
% read track data
try
    load(fullfile(starpaths(daystr), [daystr 'star.mat']), 'track');
catch
    [fna pna]=uigetfile('*star.mat', 'star.mat file',starpaths(daystr));
    load([pna fna],'track');
end
    
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
