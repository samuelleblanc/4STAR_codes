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
% Modified, MS, 2016-10-28, changed KORUS O3 c0 to 0702
% Modified, MS, 2017-07-22, added gases c0 for ORACLES 2017
% Modified, MS, 2018-09-12, fixed time bug related toORACLES 2016 c0
% Modified, MS, 2018-09-12, bug fix to starc0gases in NO2 refspec call
% Modified, MS, 2018-09-14, updated file with ORACLES 3 starc0gases
% Modified, MS, 2018-10-02, fixed bug in ingesting the correct refSpec for 
%                           ORACLES 2018 (took 2016 instead)
% Modified, MS, 2018-11-07, added MLO-Feb-2018 results to be applied
%                           on ORACLES 2018
% Modified, MS, 2018-11-08, changed refSpec of O3 to 20180212
% Modified, MS, 2018-11-08, changed bug of updating ORACLES 2018
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
                        %tmp = load(['20160113O3refspec.mat']);
                        tmp = load(['20160702O3refspec.mat']);
                    catch
                        %tmp = load([starpaths,'20160113O3refspec.mat']);
                        tmp = load([starpaths,'20160702O3refspec.mat']);
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
    elseif t> datenum([2016 6 30 0 0 0])&& t<=datenum([2016 11 01 0 0 0]) % use MLO June-2016-for ORACLES 2016    
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
                
             end % end of ORACLES 2016 option
        end
        % ORACLES 2017
        
        elseif t> datenum([2017 2 1 0 0 0]) && t<=datenum([2018 2 1 0 0 0]); % use MLO June-2017-ORACLES    
         if now>=datenum([2017 2 1 0 0 0]);
             if strcmp(gas,'O3')
                if mode==0
                    % use MLO c0
                    tmp = importdata(which(['20170527_VIS_C0_refined_Langley_MLO_May2017.dat'])); 
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    
                    tmp = load(which(['20170531O3refspec.mat']));
                    c0gases = tmp;%.o3refspec;
                end
            elseif strcmp(gas,'NO2')
                if mode==0
                    % use MLO c0
                   
                    tmp = importdata(which(['20170527_VIS_C0_refined_Langley_MLO_May2017.dat'])); 
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20170531NO2refspec.mat']));
                    c0gases = tmp;%.no2refspec;
                    
                    
                end
                
            elseif strcmp(gas,'HCOH')
                if mode==0
                    % use lamp FEL?
                    tmp = importdata(which(['20160707_VIS_C0_Langley_MLO_June2016_mean.dat'])); % MLO-Jan-2016 mean
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20170531HCOHrefspec.mat']));
                    
                    c0gases = tmp;%.hcohrefspec;
                end    
                
             end
            
         end % end of ORACLES 2017 option
         
         
         elseif t> datenum([2018 2 1 0 0 0]) && t<=datenum([2018 8 1 0 0 0]); % use for MLO-Feb-2018    
         if now>=datenum([2018 2 1 0 0 0]);
             if strcmp(gas,'O3')
                if mode==0
                    % use MLO c0
                    tmp = importdata(which(['20180212_VIS_C0_4STAR_refined_averaged_MLO_Feb2018.dat'])); 
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    
                    tmp = load(which(['20180212O3refspec.mat']));
                    c0gases = tmp;%.o3refspec;
                end
            elseif strcmp(gas,'NO2')
                if mode==0
                    % use MLO c0
                   
                    tmp = importdata(which(['20180212_VIS_C0_4STAR_refined_averaged_MLO_Feb2018.dat'])); 
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20180212NO2refspec.mat']));
                    c0gases = tmp;%.no2refspec;
                    
                    
                end
                
            elseif strcmp(gas,'HCOH')
                if mode==0
                    % use lamp FEL?
                    tmp = importdata(which(['20180212_VIS_C0_4STAR_refined_averaged_MLO_Feb2018.dat'])); % MLO-Jan-2016 mean
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20180212HCOHrefspec.mat']));
                    
                    c0gases = tmp;%.hcohrefspec;
                end    
                
             end
            
         end % end of MLO Feb-2018
        
        elseif t> datenum([2018 8 1 0 0 0]); % use MLO Feb-2018-ORACLES    
         if now>=datenum([2018 8 1 0 0 0]);
             if strcmp(gas,'O3')
                if mode==0
                    % use MLO c0
                    tmp = importdata(which(['20180812_VIS_C0_refined_langley_4STAR_ground_langleyam.dat'])); 
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    
                    tmp = load(which(['20180212O3refspec.mat']));
                    c0gases = tmp;%.o3refspec;
                end
            elseif strcmp(gas,'NO2')
                if mode==0
                    % use MLO c0
                   
                    tmp = importdata(which(['20180812_VIS_C0_refined_langley_4STAR_ground_langleyam.dat'])); 
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20180212NO2refspec.mat']));
                    c0gases = tmp;%.no2refspec;
                    
                    
                end
                
            elseif strcmp(gas,'HCOH')
                if mode==0
                    % use lamp FEL?
                    tmp = importdata(which(['20180812_VIS_C0_refined_langley_4STAR_ground_langleyam.dat'])); % MLO-Jan-2016 mean
                    c0gases = tmp.data(:,3);
                elseif mode==1
                    % use ref_spec
                    tmp = load(which(['20180212HCOHrefspec.mat']));
                    
                    c0gases = tmp;%.hcohrefspec;
                end    
                
             end
            
        end; % end of ORACLES 2018 option
        
    end; % end of c0 date options    
        
      %end
    
    
    
