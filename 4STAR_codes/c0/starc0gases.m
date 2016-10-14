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
% Modified, MS, 2016-08-23, added June 2016 MLO gases c0
% Modified, MS, 2016-08-24, applied refSpec to c0gases
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

    %if t>=datenum([2016 1 09 0 0 0]) && t<=datenum([2016 4 18 0 0 0]); % use MLO Jan-2016
    if t>=datenum([2016 1 09 0 0 0]) && t<=datenum([2016 6 19 0 0 0]); % KORUS-AQ/SARP
        if now>=datenum([2016 1 19 0 0 0]);
             if strcmp(gas,'O3')
                if mode==0
                    % use MLO c0
                    try
                        tmp = importdata(['20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
                    catch
                    tmp = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
                    end
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    try
                        tmp = load(['20160113O3refspec.mat']);
                    catch
                        tmp = load([starpaths,'20160113O3refspec.mat']);
                    end
                    c0gases = tmp;%.o3refspec;
                end
            elseif strcmp(gas,'NO2')
                if mode==0
                    % use MLO c0
                    tmp = importdata(which(['20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat'])); % MLO-Jan-2016 mean
%                     try
%                         tmp = importdata(['20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
%                     catch
%                     tmp = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
%                     end
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    %tmp = load([starpaths,'20160113NO2refspec.mat']);
                    try
                        tmp = load(['20160702NO2refspec.mat']);
                    catch
                        tmp = load([starpaths,'20160702NO2refspec.mat']);
                    end
                    c0gases = tmp;%.no2refspec;
                end
                
            elseif strcmp(gas,'HCOH')
                if mode==0
                    % use lamp FEL?
                    try
                        tmp = importdata(['20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
                    catch
                        tmp = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']); % MLO-Jan-2016 mean
                    end
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    try
                        tmp = load(['20160702HCOHrefspec.mat']);
                    catch
                        tmp = load([starpaths,'20160702HCOHrefspec.mat']);
                    end
                    c0gases = tmp;%.hcohrefspec;
                end    
                
            end
        end; 
        
    %elseif t> datenum([2016 4 18 0 0 0]); % use MLO June-2016
    elseif t> datenum([2016 6 30 0 0 0]); % use MLO June-2016-ORACLES    
        if now>=datenum([2016 4 18 0 0 0]);
             if strcmp(gas,'O3')
                if mode==0
                    % use MLO c0
                    % tmp = importdata(which(['20160707_VIS_C0_Langley_MLO_June2016_mean.dat'])); % MLO-June-2016 mean
                    tmp = importdata(which(['20160825_VIS_C0_refined_Langley_ORACLES_transit2.dat'])); % ORACLES transit
%                     try
%                         tmp = importdata(['20160707_VIS_C0_Langley_MLO_June2016_mean.dat']); % MLO-Jan-2016 mean
%                     catch                       
%                     tmp = importdata([starpaths,'20160707_VIS_C0_Langley_MLO_June2016_mean.dat']); % MLO-Jan-2016 mean
%                     end
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    %tmp = load(which(['20160702O3refspec.mat']));
                    tmp = load(which(['20160825O3refspec.mat']));
%                     try
%                         tmp = load(['20160702O3refspec.mat']);
%                     catch
%                     tmp = load([starpaths,'20160702O3refspec.mat']);
%                     %tmp = load([starpaths,'20160825O3refspec.mat']);
%                     end
                    c0gases = tmp;%.o3refspec;
                end
            elseif strcmp(gas,'NO2')
                if mode==0
                    % use MLO c0
                    % tmp = importdata(which(['20160707_VIS_C0_Langley_MLO_June2016_mean.dat']));        % MLO-June-2016 mean
                    tmp = importdata(which(['20160825_VIS_C0_refined_Langley_ORACLES_transit2.dat'])); % ORACLES transit
%                     try
%                         tmp = importdata(['20160707_VIS_C0_Langley_MLO_June2016_mean.dat']); % MLO-Jan-2016 mean
%                     catch
%                         tmp = importdata([starpaths,'20160707_VIS_C0_Langley_MLO_June2016_mean.dat']); % MLO-Jan-2016 mean
%                     end
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20160702NO2refspec.mat']));
                    %tmp = load(which(['20160825NO2refspec.mat']));too low
%                     try
%                         tmp = load(['20160702NO2refspec.mat']);
%                     catch
%                         tmp = load([starpaths,'20160702NO2refspec.mat']);
%                     end
                    c0gases = tmp;%.no2refspec;
                    %c0gases.no2refspec = tmp.no2refspec - tmp.no2refspec*0.055;
                    % decrease MLO c0 in 5.5% relative
                    
                end
                
            elseif strcmp(gas,'HCOH')
                if mode==0
                    % use lamp FEL?
                    tmp = importdata(which(['20160707_VIS_C0_Langley_MLO_June2016_mean.dat'])); % MLO-Jan-2016 mean
%                     try
%                         tmp = importdata(['20160707_VIS_C0_Langley_MLO_June2016_mean.dat']); % MLO-Jan-2016 mean
%                     catch
%                         tmp = importdata([starpaths,'20160707_VIS_C0_Langley_MLO_June2016_mean.dat']); % MLO-Jan-2016 mean
%                     end
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20160702HCOHrefspec.mat']));
                    %tmp = load(which(['20160825HCOHrefspec.mat']));
%                     try
%                         tmp = load(['20160702HCOHrefspec.mat']);
%                     catch
%                         tmp = load([starpaths,'20160702HCOHrefspec.mat']);
%                     end
                    c0gases = tmp;%.hcohrefspec;
                end    
                
            end
        end;     
        
    end
    
    
    