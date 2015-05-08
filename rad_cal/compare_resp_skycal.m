%% PURPOSE:
%   Compare the response function from 2 different files
%   Files must be identified in code
%
% CALLING SEQUENCE:
%   [vis_resp nir_resp]=compare_resp_skycal()
%
% INPUT:
%   none
% 
% OUTPUT:
%  - vis_resp: empty 
%  - nir_resp: empty
%  - plots of comparison between 2 different response functions creating
%  with write_SkyResp_files_2
%
% DEPENDENCIES:
%  - version_set.m : for version control of this file
%  - save_fig.m: for figure saving
%  - 
% 
% NEEDED FILES:
%  - SKYRESP for vis and nir files in .dat format
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, date unknown, 2014
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, 2015-03-16
%                  - changed for using pre and post cals of ARISE
%                  - Added toggle values for setting which field campaign
%                  to use.
%                  - cahnged labels for pre and post
% -------------------------------------------------------------------------

%% Start of function
function [vis_resp nir_resp]=compare_resp_skycal();
version_set('1.1');
toggle.campaign = 'ARISE';
folder='C:\Users\sleblan2\Research\4STAR\cal\';

spm='VIS';
switch toggle.campaign
    case {'SEAC4RS','seac4rs'}
        disp('Doing SEAC4RS campaign')
        file1=['20130506\20130506_' spm '_SKY_Resp_with_20130605124300HISS.dat'];
        file2=['20131120\2013_11_20.4STAR.NASA_Ames.Flynn\20131121_' spm '_SKY_RESP_from_20131121_010_' spm '_park_with_20130605124300HISS.dat'];
    case {'arise','ARISE'}
        disp('Doing ARISE campaign')
        file1=['20140716\20140716_' spm '_SKY_Resp_from_20140716_003_' spm '_park_with_20140606091700HISS.dat'];
        file2=['20141024\20141024_' spm '_SKY_Resp_from_20141024_005_' spm '_park_with_20140606091700HISS.dat'];
    otherwise
        disp(['No definitions for campaign :' toggle.campaign])
        error('No files defined for this campaign')
end

disp('Importing Sky barrel response functions')
[a_vis delima heada]=importdata([folder file1]);
[b_vis delimb headb]=importdata([folder file2]);

file1=strrep(file1,'VIS','NIR');%['20130506\20130506_' spm '_SKY_Resp_with_20130605124300HISS.dat'];
file2=strrep(file2,'VIS','NIR');%['20131120\2013_11_20.4STAR.NASA_Ames.Flynn\20131121_' spm '_SKY_RESP_from_20131121_010_' spm '_park_with_20130605124300HISS.dat'];
[a_nir delima heada]=importdata([folder file1]);
[b_nir delimb headb]=importdata([folder file2]);

%a format: Pix, Wavelength, resp, rate, rad

%now set up the plotting to compare response functions
disp('Plotting');
figure(1);
subplot(2,1,1);
%plot(a_vis.data(:,2),a_vis.data(:,3)','b-',a_nir.data(:,2),a_nir.data(:,3)*20','g-',...
%     b_vis.data(:,2),b_vis.data(:,3)','r-',b_nir.data(:,2),b_nir.data(:,3)*20','y-');
%axis([350 1700 0 6]);
[ax,h1,h2]=plotyy(a_vis.data(:,2),a_vis.data(:,3)',a_nir.data(:,2),a_nir.data(:,3)','plot');
hold(ax(1));
plot(ax(1),b_vis.data(:,2),b_vis.data(:,3)','Color',[0.5 0.5 1]);
hold(ax(2));
plot(ax(2),b_nir.data(:,2),b_nir.data(:,3)','Color',[0.5 1 0.5]);
set(ax(1), 'YLim',[0 6]);
set(ax(2),'YLim',[0 0.25]);
set(ax(1),'XLim',[350 1700]);
set(ax(2),'XLim',[350 1700]);
title('Response functions');
ylabel('Response [cts/ms (W/m^2 sr um)^-1]');
xlabel('Wavelength [nm]');
legend('VIS Post','VIS Pre','NIR Post','NIR Pre');
hold off;


subplot(2,1,2);
plot(a_vis.data(:,2),b_vis.data(:,3)./a_vis.data(:,3)*100,'b-',...
     a_nir.data(:,2),b_nir.data(:,3)./a_nir.data(:,3)*100,'r-');
hold on;
plot([350 1700],[100 100],'k:');
hold off;
 axis([350 1700 75 125]);
 grid;
 title('Relative change in response functions');
ylabel('Response change [%]');
xlabel('Wavelenght [nm]');
legend('VIS post/pre','NIR post/pre');

disp('Saving figure');
save_fig(1,[folder 'SKY_RESP_pre_post_compare_' toggle.campaign]);
return