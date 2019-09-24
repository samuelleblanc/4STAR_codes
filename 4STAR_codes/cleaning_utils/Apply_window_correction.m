function s = Apply_window_correction(s,force_correct)
%% Details of the program:
% NAME:
%   Apply_window_correction
%
% PURPOSE:
%  Modifies the tau_aero based on the window correction files 'merge_mark'
%
% CALLING SEQUENCE:
%   s = Apply_window_correction(s,force_correct)
%
% INPUT:
%  s: starsun structure 
%  force_correct: boolean (defaults to false), if true forces the application of the window deposition correction
%
% OUTPUT:
%  s: starsun structure, with a modified tau_aero, tau_aero_noscreening
%  s.is_tau_aero_window_dep_corrected: True if corrected, False or non-existant if not corrected.
%
% DEPENDENCIES:
%  - version_set.m
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined
%  - merge_mark file
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames Research Center, 2019-05-07
%                 Based on large parts from SEmakearchive_ORACLES_2018_AOD
% -------------------------------------------------------------------------

%% Codes
version_set('v1.0')

%% Check if already window corrected
if ~isavar('force_correct'), force_correct=false; end
if ~isfield('is_tau_aero_window_dep_corrected',s), s.is_tau_aero_window_dep_corrected=false; end

if s.is_tau_aero_window_dep_corrected & ~force_correct
    return
end


%% Load the starinfo details
infofile_ = ['starinfo_' s.daystr '.m'];
infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
try
    s = infofnt(s);
catch
    eval([infofile_(1:end-2),'(s)']);
end

if ~isfield('deltatime_dAOD',s)
    s.deltatime_dAOD = 900.0; %time in seconds around the shift in AOD due to the window deposition
end
if ~isfield('dAOD_uncert_frac',s)
   s.dAOD_uncert_frac = 0.25; %fraction of the change in dAOD due to window deposition to be kept as extra uncertainty (default 20%, 0.2)
end

%% Update the uncertainties with merge marks file saved in the starinfo
add_uncert = false;
correct_aod = false;
if isfield(s,'AODuncert_mergemark_file')
    disp(['Loading the AOD uncertainty correction file: ' s.AODuncert_mergemark_file])
    d = load(s.AODuncert_mergemark_file);
    add_uncert = true; correct_aod = true;
elseif isfield(s,'AODuncert_constant_extra')
    disp(['Applying constant AOD factor to existing AOD'])
    d.dAODs = repmat(s.AODuncert_constant_extra,[length(s.t),length(s.w)]);
    add_uncert = true; correct_aod = false;
    d.time = s.t;
end



%% Now go through the times of measurements and correct 
if correct_aod
    d.dAODs(isnan(d.dAODs)) = 0.0;
    if ~strcmp(datestr(d.time(1),'YYYYmmDD'),s.daystr); error('Time array in delta AOD merge mark file not the same as starsun file'), end;
    
    % now interpolate the the wavelengths of tau_aero
    newdaod = interp1(d.wl_nm,d.dAODs',s.w.*1000.0,'pchip','extrap');
    newdaod = interp1(d.time,newdaod',s.t,'nearest');
    s.dAODs = interp1(d.time,d.dAODs,s.t,'nearest');
    newdaod(isnan(newdaod)) = 0.0;
    
    s.tau_aero_noscreening = s.tau_aero_noscreening - newdaod;
    s.tau_aero = s.tau_aero - newdaod;
    try
        s.tau_aero_subtract_all = s.tau_aero_subtract_all - newdaod; 
    catch
        disp('Problem Correcting tau_aero_subtract_all')
    end
    s.is_tau_aero_window_dep_corrected = true;
end

%% do the same but for uncertainty
if isfield('tau_aero_err',s)
    if add_uncert  % if the add uncertainty exists then run that also.
        if correct_aod
            ddCo = interp1(d.time,d.dCo(:,5),s.t,'nearest');
            it = find(diff(ddCo)<-0.0001);
            dAODs = newdaod.*0.0;
            for itt=1:length(it) % add uncertainty equivalent to the daod change for a period of +/- deltatime_dAOD seconds around the effect
                [nul,itm] = min(abs(s.t-(s.t(it(itt))-s.deltatime_dAOD/86400)));
                [nul,itp] = min(abs(s.t-(s.t(it(itt))+s.deltatime_dAOD/86400)));
                dAODs(itm:itp,:) = repmat(newdaod(it(itt)+1,:)-newdaod(it(itt),:),itp-itm+1,1);
            end
            % add the full correction AOD to the uncertainty for a period of time surrounding the correction  
            s.tau_aero_err = s.tau_aero_err + abs(dAODs);
            % add uncertainty equivalent to dAOD_uncert_frac of the correction
            s.tau_aero_err = s.tau_aero_err + abs(newaods).*s.dAOD_uncert_frac
        else % no AOD correction, just uncertainty
            newdaod = interp1(d.wl_nm,d.dAODs',s.w.*1000.0,'pchip','extrap');
            newdaod = interp1(d.time,newdaod',s.t,'nearest');
            newdaod(isnan(newdaod)) = 0.0;
            s.tau_aero_err = s.tau_aero_err + abs(newaods)
        end
    end
end

return

