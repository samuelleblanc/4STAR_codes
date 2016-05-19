function [c0gases]=starc0gases(t,verbose,gas,mode)

% returns the 4STAR c0 (TOA count rate) for the time (t) of the
% measurement for O3/NO2. t must be in the Matlab time format. 
% Leave blank and now is
% gas is gas str ('O3' or 'NO2');
% mode is c0 (0) or reference spectrum(1)
% assumed. New calibration files should be linked to this code, and all
% other 4STAR codes should obtain the c0 from this code. 
% MS, v1.0, 2016-05-05, KORUS-AQ
% Modified, MS, 2016-05-18, adding HCOH ref spec
%------------------------------------------------------------------------

version_set('1.0');
if ~exist('verbose','var')
    verbose=true;
end;

if verbose; disp('In starc0gases'), end;

% control the input
if nargin==0;
    t=now;
end;

% select a source file

    if t>=datenum([2016 1 09 0 0 0]); % MLO Jan-2016
        if now>=datenum([2016 1 19 0 0 0]);
             if strcmp(gas,'O3')
                if mode==0
                    % use MLO c0
                    tmp = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load([starpaths,'20160113O3refspec.mat']);
                    c0gases = tmp.o3refspec;
                end
            elseif strcmp(gas,'NO2')
                if mode==0
                    % use MLO c0
                    tmp = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load([starpaths,'20160113NO2refspec.mat']);
                    c0gases = tmp.no2refspec;
                end
                
            elseif strcmp(gas,'HCOH')
                if mode==0
                    % use lamp FEL?
                    tmp = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load([starpaths,'20160113HCOHrefspec.mat']);
                    c0gases = tmp.hcohrefspec;
                end    
                
            end
        end; 
    end
    
    
    