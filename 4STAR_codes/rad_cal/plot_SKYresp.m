%% PURPOSE:
%   Plot the response function of the sky barrel from various inputs
%
% CALLING SEQUENCE:
%   resp=plot_SKYresp(cal,vis,nir,date,pname)
%
% INPUT:
%   cal: structure of raw 4STAR data taken while viewing the integrating sphere
%   vis: structure of information for the vis spectrometer (mostly only use
%        the .nm values corresponding to an array of wavelengths)
%   nir: structure of information for the nir spectrometer (mostly only use
%        the .nm values corresponding to an array of wavelengths)
%   date: date string corresponding to the current day
%   pname: path to where the plots will be stored
% 
% OUTPUT:
%  resp: response functions for specific calibrations (right now set for 9 lamps)
%  - plots of all vis and nir response functions for a given day with
%    corresponding variation to each other
%
% DEPENDENCIES:
%  - startup_plotting.m
%  - save_fig.m
%  - version_set.m : for version control of this file
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, date unknown, 2014
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, 2014-11-12
%                 - changed startup to startup_plotting
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, 2017-11-07
%                 - added handling of lamp subsets
% -------------------------------------------------------------------------

%% Start of function
function resp=plot_SKYresp(cal,vis,nir,date,pname)
startup_plotting;
version_set('1.2');
disp('Plotting the various SKY response functions');

figure(3);
cal_names = fieldnames(cal)

for ll=1:length(cal_names);
  switch cal_names{ll}
        case 'Lamps_12'
            fnum = '009';
        case 'Lamps_9'
            fnum = '010';
        case 'Lamps_6'
            fnum = '011';
        case 'Lamps_3'
            fnum = '012';
        case 'Lamps_2'
            fnum = '013';
        case 'Lamps_1'
            fnum = '014';
        case 'Lamps_0'
            fnum = '015';
  end
  lampstr = cal_names{ll};
  for iint=1:length(cal.(lampstr).vis.t_ms);
    plot(vis.nm,cal.(lampstr).vis.resp(iint,:),'DisplayName',['VIS ' lampstr ' - int time:' sprintf('%-d',cal.(lampstr).vis.t_ms(iint)) ' ms']);
    if iint==1 && ll==1;
        hold all;
        title(['Response functions for' date]);
        xlabel('Wavelength [nm]');
        ylabel('Response [Cts/ms (Wm^-^2sr^-^1um^-^1)^-^1]');
    end;
  end;
  for iint=1:length(cal.(lampstr).nir.t_ms);
    plot(nir.nm,cal.(lampstr).nir.resp(iint,:),'DisplayName',['NIR ' lampstr ' - int time:' sprintf('%-d',cal.(lampstr).nir.t_ms(iint)) ' ms']);
  end;
end;
hold off;
legend(gca,'show');
ff=[pname filesep date '_responses_vis'];
save_fig(3,ff,true);

%%%% now make the plot, but with seperate figures for nir and vis
%%%% plot every response functions
figure(4);
subplot(2,1,1);
for ll=1:length(cal_names);
  lampstr = cal_names{ll};
  for iint=1:length(cal.(lampstr).vis.t_ms);
    plot(vis.nm,cal.(lampstr).vis.resp(iint,:),'DisplayName',[lampstr ' - int time:' sprintf('%-d',cal.(lampstr).vis.t_ms(iint)) ' ms']);
    if iint==1 && ll==1;
        hold all;
        title('Response functions VIS');
        xlabel('Wavelength [nm]');
        ylabel('Response [Cts/ms (Wm^-^2sr^-^1um^-^1)^-^1]');
        axis([350 1000 0 6]);
    end;
  end;
end;
hold off; %legend(gca,'show');

subplot(2,1,2);
for ll=1:length(cal_names);
  lampstr = cal_names{ll};
  for iint=1:length(cal.(lampstr).nir.t_ms);
    plot(nir.nm,cal.(lampstr).nir.resp(iint,:),'DisplayName',[lampstr ' - int time:' sprintf('%-d',cal.(lampstr).nir.t_ms(iint)) ' ms']);
    if iint==1 && ll==1;
        hold all;
        title('Response functions NIR');
        xlabel('Wavelength [nm]');
        ylabel('Response [Cts/ms (Wm^-^2sr^-^1um^-^1)^-^1]');
        axis([950 1700 0 0.3]);
    end;
  end;
end;
hold off; %legend(gca,'show');
ff=[pname filesep date '_responses_nir'];
save_fig(4,ff,true);

%%%% Now make a plot that shows the variability of the response functions
%%%% as compared to the '9-lamps' usual calibration
figure(5); 
resp.vis=cal.Lamps_9.vis.resp(3,:);
resp.nir=cal.Lamps_9.nir.resp(3,:);
subplot(2,1,1);
for ll=1:length(cal_names);
  lampstr = cal_names{ll};
  for iint=1:length(cal.(lampstr).vis.t_ms);
    plot(vis.nm,cal.(lampstr).vis.resp(iint,:)./resp.vis*100,'DisplayName',[lampstr ' - int time:' sprintf('%-d',cal.(lampstr).vis.t_ms(iint)) ' ms']);
    if iint==1 && ll==1;
        hold all;
        title('Response functions change VIS');
        xlabel('Wavelength [nm]');
        ylabel('Response [%]');
        axis([350 1000 90 110]);
    end;
  end;
end;
hold off; %legend(gca,'show');

subplot(2,1,2);
for ll=1:length(cal_names);
  lampstr = cal_names{ll};
  for iint=1:length(cal.(lampstr).nir.t_ms);
    plot(nir.nm,cal.(lampstr).nir.resp(iint,:)./resp.nir*100,'DisplayName',[lampstr ' - int time:' sprintf('%-d',cal.(lampstr).nir.t_ms(iint)) ' ms']);
    if iint==1 && ll==1;
        hold all;
        title('Response functions change NIR');
        xlabel('Wavelength [nm]');
        ylabel('Response [%]');
        axis([950 1700 90 110]);
    end;
  end;
end;
hold off; %legend(gca,'show');
ff=[pname filesep date '_responses_diff'];
save_fig(5,ff,true);

disp('done plotting');
return
