%% Details of the program:
% NAME:
%   compare_response
% 
% PURPOSE:
%   Compare the zenith radiance calibrations taken from the lab cals.
%   Calibrations pertain to measurements of the HISS sphere
%
% CALLING SEQUENCE:
%   compare_response
%
% INPUT:
%  - none
% 
% OUTPUT:
%  - various plots
%
% DEPENDENCIES:
%  - save_fig.m 
%  - startup_plotting.m (for making good looking plots)
%  - version_set.m (for m script version tracking)
%
% NEEDED FILES:
%  - resp.mat files for the following calibrtion days:
%    - 20130506
%    - 20131120
%    - 20140624
%    - 20140716
%    - 20141024
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, August 1st, 2014
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, 2014-11-12
%                  - change startup to startup_plotting
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, 2015-01-08
%                  - added post ARISE rad cals
% Modified (v1.3): by Samuel LeBlanc, NASA Ames, 2015-05-06
%                  - change plotting limits of relative changes
% -------------------------------------------------------------------------

%% Start of function
function compare_response
startup_plotting
version_set('1.3');

% setting the standard variables
dir='C:\Users\sleblan2\Research\4STAR\cal\';
l='\';

dates=['20130506';'20131120';'20140624';'20140716';'20141024'];

%% Load files
d1=load([dir dates(1,:) l '20130507' '_rad_cal_corr.mat'],'cal','vis','nir');
d2=load([dir dates(2,:) l '20131121' '_rad_cal_corr.mat'],'cal');
d3=load([dir dates(3,:) l dates(3,:) '_rad_cal_corr.mat'],'cal');
d4=load([dir dates(4,:) l dates(4,:) '_rad_cal_corr.mat'],'cal');
d5=load([dir dates(5,:) l dates(5,:) '_rad_cal_corr.mat'],'cal');

%% Plotting of response functions per lamps
fields = fieldnames(d1.cal);
for f = length(fields):-1:1;
    if ~isempty(strfind(fields{f},'Lamps_'))
        Lamps(f) = sscanf(fields{f}(strfind(fields{f},'Lamps_')+length('Lamps_'):end),'%f');
    end
end
Lamps = unique(Lamps); 

for LL=Lamps
   lamp_str =['Lamps_',num2str(LL)];
   figure(LL);
   set(LL,'Position',[50 200 1400 800]);
   %vis resp
   ax1=subplot(2,2,1);
   plot(d1.vis.nm, d1.cal.(lamp_str).vis.mean_resp, ...
        d1.vis.nm, d2.cal.(lamp_str).vis.mean_resp, ...
        d1.vis.nm, d3.cal.(lamp_str).vis.mean_resp, ...
        d1.vis.nm, d4.cal.(lamp_str).vis.mean_resp, ...
        d1.vis.nm, d5.cal.(lamp_str).vis.mean_resp, '-');
   title(['VIS response for ' lamp_str]);
   xlabel('Wavelength [nm]');
   ylabel('Response [Cnts/(W m^{-2} \mum^{-1} sr^{-1})^{-1}]');
   xlim([300 1050]);
   legend(dates,'Location','Best');
   grid on;
   
   %nir resp
   ax2=subplot(2,2,2);
   plot(d1.nir.nm, d1.cal.(lamp_str).nir.mean_resp, ...
        d1.nir.nm, d2.cal.(lamp_str).nir.mean_resp, ...
        d1.nir.nm, d3.cal.(lamp_str).nir.mean_resp, ...
        d1.nir.nm, d4.cal.(lamp_str).nir.mean_resp, ...
        d1.nir.nm, d5.cal.(lamp_str).nir.mean_resp, '-');
   title(['NIR response for ' lamp_str]);
   xlabel('Wavelength [nm]');
   ylabel('Response [Cnts/(W m^{-2} \mum^{-1} sr^{-1})^{-1}]');
   legend(dates,'Location','Best');
   xlim([950 1700]);
   grid on;
   
   %vis resp differences
   ax3=subplot(2,2,3);
   ref_resp=d4.cal.(lamp_str).vis.mean_resp;
   plot(d1.vis.nm, (d1.cal.(lamp_str).vis.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.vis.nm, (d2.cal.(lamp_str).vis.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.vis.nm, (d3.cal.(lamp_str).vis.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.vis.nm, (d4.cal.(lamp_str).vis.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.vis.nm, (d5.cal.(lamp_str).vis.mean_resp-ref_resp)./ref_resp.*100., '-');
   title(['VIS response change for ' lamp_str]);
   xlabel('Wavelength [nm]');
   ylabel('Response Change [%]');
   xlim([300 1050]);
   ylim([-10,30]);
   grid on;
   
   %nir resp
   ax4=subplot(2,2,4);
   ref_resp=d4.cal.(lamp_str).nir.mean_resp;
   plot(d1.nir.nm, (d1.cal.(lamp_str).nir.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.nir.nm, (d2.cal.(lamp_str).nir.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.nir.nm, (d3.cal.(lamp_str).nir.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.nir.nm, (d4.cal.(lamp_str).nir.mean_resp-ref_resp)./ref_resp.*100., ...
        d1.nir.nm, (d5.cal.(lamp_str).nir.mean_resp-ref_resp)./ref_resp.*100., '-');
   title(['NIR response change for ' lamp_str]);
   xlabel('Wavelength [nm]');
   ylabel('Response Change [%]');
   xlim([950 1700]);
   ylim([-10,30]);
   grid on;
   
   linkaxes([ax1,ax3],'x');
   linkaxes([ax2,ax4],'x');
   
   fi=[dir 'resp_comp_' lamp_str];
   save_fig(LL,fi,true);
end
