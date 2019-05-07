function [s,fig_paths] = Analysis_425feature(s,sm);
%% Details of the program:
% NAME:
%   Analysis_425feature
%
% PURPOSE:
%  Quantify the  impact of the feature at 425, and make a few figures
%  Correlate any impact
%
% CALLING SEQUENCE:
%   [s,fig_paths] = Analysis_425feature(s,starmat)
%
% INPUT:
%  s: starsun.mat full struct
%  sm: star.mat full struct, for getting full Az and El motions 
%
% OUTPUT:
%  s: starsun.mat full struct, with additional dtau400 and dtau425
%  variables, 
%  fig_paths: path of the saved files
%
% DEPENDENCIES:
%  - version_set.m
%  - get425feature.m
%
% NEEDED FILES:
%  - NA
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, May 1st, 2019
% -------------------------------------------------------------------------

%% codes
version_set('v1.0')

%% Get the dtau values
[dtau425,dtau400] = get425feature(s.tau_aero,s.w);

%% build the full array of Az and El motions
Az_deg_tmp = s.AZ_deg; % start with temp array from starsun
El_deg_tmp = s.El_deg;
t_tmp = s.t;

smf = fields(sm);
idf = cellfun(@isempty,strfind(smf,'nir')); %remove the nir fields
smff = smf(idf);

for i=1:numel(smff) %now go through arrays from starmat
    notazdeg=false;
    if isempty(strfind(smff{i},'sun')) & isempty(strfind(smff{i},'program'))& isempty(strfind(smff{i},'forj'))& isempty(strfind(smff{i},'track'))
        if ~isfield(sm.(smff{i}),'Az_deg'); notazdeg=true; end
        for ii=1:numel(sm.(smff{i}))
            if notazdeg
                try
                    sm.(smff{i})(ii).Az_deg = sm.(smff{i})(ii).Az_step ./ (-50.0);
                catch
                    sm.(smff{i})(ii).Az_deg = sm.(smff{i})(ii).AZstep ./ (-50.0);
                end
            end
            t_tmp = [t_tmp ;sm.(smff{i})(ii).t];
            Az_deg_tmp = [Az_deg_tmp ;sm.(smff{i})(ii).Az_deg];
            El_deg_tmp = [El_deg_tmp ;sm.(smff{i})(ii).El_deg];
            %disp([smff{i} num2str(ii) ' : ' num2str(length(t_tmp)) ', ' num2str(length(Az_deg_tmp)) ', ' num2str(length(El_deg_tmp))])
        end
    end
end

% now sort the arrays by time;
[t,it] = sort(t_tmp);
Az_deg = Az_deg_tmp(it);
El_deg = El_deg_tmp(it);

%and get some differentials
dAz = diff(Az_deg);
dEl = diff(El_deg);

%% Plot the resulting values
figt = figure;
ax1 = subplot(3,1,1);
plot(s.t,dtau425,'g.'); hold on;
plot(s.t,dtau400,'k.');
dynamicDateTicks;
grid on;
legend('425 nm','400 nm')
ylabel('AOD diff (actual-interpolated)')
title([s.instrumentname ' ' s.daystr ' - 425 nm feature analysis'])

ax2 = subplot(3,1,2);
plot(t,Az_deg,'b.'); hold on;
plot(t,El_deg,'r.');
dynamicDateTicks;
legend('Azimith','Elevation')
ylabel('Pointing position')

ax3 = subplot(3,1,3);
plot(t(1:end-1),dAz,'b.'); hold on;
plot(t(1:end-1),dEl,'r.');
dynamicDateTicks;
legend('Azimith','Elevation')
ylabel('delta move')
xlabel('UTC Time')
linkaxes([ax1,ax2,ax3],'x')

fig_paths = [getnamedpath('starfig') s.instrumentname '_' s.daystr '_425feature'];
save_fig(figt,fig_paths,false)

s.dtau425 = dtau425;
s.dtau400 = dtau400;
return
