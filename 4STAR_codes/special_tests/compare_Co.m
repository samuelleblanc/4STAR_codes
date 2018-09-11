function compare_Co
%% Details of the program:
% NAME:
%   compare_Co
%
% PURPOSE:
%  Select Cos to identify "best" averaged value.
%
% INPUT:
%  Manual selection of a multiple Co files (produced from Quicklooks,
%  starLangley_fx)
%
% OUTPUT:
%  creates the averaged c0 file in user-selected folder with the
%  original Co files
%  creates images in a user-selected folder.
%
% NEEDED FILES:
%  - collection of Co files and optionally a reference Co file
%
% MODIFICATION HISTORY:
% Written (v1.0): Connor, MLO 2018 Aug and following, based on Compare_Co_* 
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

% Cheking some c0, and calculating the averages
% Select a bunch of Co files
% Display Cos in fig1.
% Select reference or avg.
% Display normalized Cos in fig2.
% Iteratively select Cos for avg.
% When done select output location, name/describe Co, and produce output.

vis_names = getfullname('*_VIS_C0_*.dat', 'C0s','Select VIS C0 files for comparison');
[pn,fn,~] = fileparts(vis_names{1}); pn = [pn,filesep];
if ~isempty(strfind(upper(fn),'_4STARB_'));
   inst = '4STARB';
else
   inst = '4STAR';
end
nir_names = strrep(vis_names,'_VIS_C0_','_NIR_C0_');
% nir_names = getfullname('*_NIR_C0_*.dat', 'C0s','Select NIR C0 files for comparison');
if ischar(vis_names)
   vis_names = {vis_names};
   nir_names = {nir_names};
end

Co_names = strrep(vis_names,'_VIS',''); Co_names =strrep(Co_names,pn,'');

%Use date of first supplied Co to label the output Co file
label_daystr = strtok(fn,'_');


n = length(vis_names);
cm = jet(n);
fig = figure_(100);
% Manually orient the window to fill the lower half of the screen.
% i_avg = [1:length(vis_names)];
for i=1:n;
   [vis, nir] = get_C0s(vis_names{i}, nir_names{i});
   visc0(i,:) = vis.c0; visc0err(i,:) = vis.c0err;
   nirc0(i,:) = nir.c0; nirc0err(i,:) = nir.c0err;
   w_vis = vis.w; w_nir = nir.w;
   l = plot(w_vis,visc0(i,:),'color',cm(i,:),'linewidth',4);hold('on');
   [~,fn,~] = fileparts(vis_names{i}); fn = strtok(fn, '_');
   if isempty(strfind(upper(vis_names{i}),'PM'))
      fn = [fn, ' AM'];
   else
      fn = [fn, ' PM'];
   end
   leg(i) = {fn};
end
plot([350,1000,1700],[0,0,0],'--k');logy;  zoom('on');
figure_(fig);
title([inst,' C0s from calibration set.  Dashed lines excluded from average.'])
lg = legend(leg{:}); set(lg,'interp','none');
for i=1:n;
   plot(w_nir,nirc0(i,:).*10,'color',cm(i,:),'linewidth',4);
end
hold('off');
all_done = false;
use_avg = true([1,length(vis_names)]);
visc0_avg = mean(visc0(use_avg,:));
visc0_std = std(visc0(use_avg,:));
nirc0_avg = mean(nirc0(use_avg,:));
nirc0_std = std(nirc0(use_avg,:));
co_ax(1) = gca;
while ~all_done
   avg_or_ref = menu('Compare C0s against AVERAGE or REFERENCE?', 'Compare to AVERAGE','Compare to REFERENCE');
   if avg_or_ref==2
      visref = getfullname(['*VIS_C0_*.dat'],'C0_ref','Select a VIS C0 file to use a reference.');
      nirref = strrep(visref,'_VIS_C0_','_NIR_C0_');
      [vis_ref, nir_ref] = get_C0s(visref, nirref);vis_ref = vis_ref.c0; nir_ref = nir_ref.c0;
      [~, title_tag] = fileparts(nirref);title_tag = strrep(title_tag,'_NIR_C0_','_*_');
   else
      vis_ref = visc0_avg;
      nir_ref =nirc0_avg;
      title_tag = ['Avg: [',sprintf('%1d ',use_avg(:)),']'];
   end
   
   % Picking an arbitrary number for the figure ID
   fig2 = figure_(101);hold('off'); zoom('on');
   % Manually orient the window to fill the upper half of the screen.
   for i=1:n;
      if use_avg(i);
         l2 = plot(w_vis,(visc0(i,:)./vis_ref-1).*100.0,'color',cm(i,:),'linewidth',4);
      else;
         l2 = plot(w_vis,(visc0(i,:)./vis_ref-1).*100.0,'--','color',cm(i,:));
      end;
      [~,fn,~] = fileparts(vis_names{i}); fn = strtok(fn, '_');
      if isempty(strfind(upper(vis_names{i}),'PM'))
         fn = [fn, ' AM'];
      else
         fn = [fn, ' PM'];
      end
      leg(i) = {fn};
      hold('on');
      p2(i) = l2;
   end;
   for i=1:n;
      if use_avg(i);
         l2 = plot(w_nir,(nirc0(i,:)./nir_ref-1).*100.0,'color',cm(i,:),'linewidth',4);
      else;
         l2 = plot(w_nir,(nirc0(i,:)./nir_ref-1).*100.0,'color',cm(i,:));
      end;
   end;
   plot([350,1000,1700],[0,0,0],'--k'); zoom('on');
   tl = title([inst,' Normalized c0s versus ',title_tag]); set(tl,'interp','none');
   lg = legend(leg{:});set(lg,'interp','none');
   co_ax(2) = gca;
   linkaxes(co_ax,'x');
   done_averaging = false;
   while ~done_averaging
      avg = menu('Toggle Cos for use in average',Co_names{:},'DONE');
      if avg>length(use_avg)
         done_averaging = true;
      else
         use_avg(avg) = ~use_avg(avg);
      end
      if sum(use_avg)>1
         visc0_avg = mean(visc0(use_avg,:));
         visc0_std = std(visc0(use_avg,:));
         nirc0_avg = mean(nirc0(use_avg,:));
         nirc0_std = std(nirc0(use_avg,:));
      elseif sum(use_avg)==1
         visc0_avg = visc0(use_avg,:);
         visc0_std = nan(size(visc0(1,:)));
         nirc0_avg = nirc0(use_avg,:);
         nirc0_std = nan(size(visc0(1,:)));
      else
         visc0_avg = nan(size(visc0(1,:)));
         visc0_std = nan(size(visc0(1,:)));
         nirc0_avg =nan(size(visc0(1,:)));
         nirc0_std = nan(size(visc0(1,:)));
      end
      if avg_or_ref==1
         vis_ref = visc0_avg;
         nir_ref =nirc0_avg;
         title_tag = [inst,' Avg: [',sprintf('%1d ',use_avg(:)),']'];
      end
      
      fig = figure_(fig);hold('off'); zoom('on');

      for i=1:n;
         if use_avg(i)
            l = plot(w_vis,visc0(i,:),'color',cm(i,:),'linewidth',4);
         else;
            l = plot(w_vis,visc0(i,:),'--','color',cm(i,:));
         end;
         hold('on')
      end
     title([inst,' C0s from calibration set.  Dashed lines excluded from average.'])
      for i=1:n
         if use_avg(i)
            plot(w_nir,nirc0(i,:).*10,'color',cm(i,:),'linewidth',4);
         else;
            plot(w_nir,nirc0(i,:).*10,'--','color',cm(i,:));
         end;
      end
      plot([350,1000,1700],[0,0,0],'--k');logy; hold('on');
      lg = legend(leg{:}); set(lg,'interp','none');
      fig2 = figure_(101);hold('off'); zoom('on'); 
      tl = title([inst,' Normalized c0s versus ',title_tag]); set(tl,'interp','none')
   % Manually orient the window to fill the upper half of the screen.
   for i=1:n;
      if use_avg(i);
         l2 = plot(w_vis,(visc0(i,:)./vis_ref-1).*100.0,'color',cm(i,:),'linewidth',4);
      else;
         l2 = plot(w_vis,(visc0(i,:)./vis_ref-1).*100.0,'--','color',cm(i,:));
      end;
      [~,fn,~] = fileparts(vis_names{i}); fn = strtok(fn, '_');
      if isempty(strfind(upper(vis_names{i}),'PM'))
         fn = [fn, ' AM'];
      else
         fn = [fn, ' PM'];
      end
      leg(i) = {fn};
      hold('on');
      p2(i) = l2;
   end;
   for i=1:n;
      if use_avg(i);
         plot(w_nir,(nirc0(i,:)./nir_ref-1).*100.0,'color',cm(i,:),'linewidth',4);
      else;
         l2 = plot(w_nir,(nirc0(i,:)./nir_ref-1).*100.0,'--','color',cm(i,:));
      end;
   end;
   plot([350,1000,1700],[0,0,0],'--k');
   lg = legend(leg{:});set(lg,'interp','none');
      tl = title([inst,' Normalized c0s versus ',title_tag]); set(tl,'interp','none')
   end

   if sum(use_avg)>0
      figure_(fig);
      plot(w_vis, visc0_avg,'k:','linewidth',4);
      plot(w_nir, nirc0_avg.*10,'k:','linewidth',4);
      if avg_or_ref==2
         figure_(fig2);
         plot(w_vis,(visc0_avg./nir_ref-1).*100.0,'k--','linewidth',4);
         plot(w_nir,(nirc0_avg./nir_ref-1).*100.0,'k--','linewidth',4);
      end
   end
   
   %%
   ref_done = menu('Select a different Co as reference, or all done?','Different Co','all done');
   if ref_done>1
      all_done = true;
   else
      all_done = false;
   end
end
%%
 
i_avg = find(use_avg);
[~,gdaystr] = fileparts(vis_names{i_avg(end)}(1:end));

ymax = ceil(max(visc0_avg(w_vis>400&w_vis<700))./1000).*1000;
   figure_(fig);
   % legend(p,leg);
   xlabel('Wavelength [nm]');
   ylabel('c0 (NIR c0 x10)');
   ylim([0,ymax]);
   
   figure_(fig2);
   % legend(p2,leg);
   xlabel('Wavelength [nm]');
   ylabel('%diff');
   ylim([-10,10]);


fp_out = getdir('C0_out','Select a location to save C0 plots.');
asktosave = 1; %set if ask to save the figures

fignames = [inst,'_MLO_2018_Aug'];
% Save the figures

fig3 = figure_(103);
ax(1) = subplot(3,1,1);
plot(w_vis,visc0_avg,'.-k'); hold on;
plot(w_nir,nirc0_avg.*10.0,'.-k');hold off;
ylabel('c0 (NIR c0 x10)'); ylim([0,ymax])
tl = title([inst,' C0 saved for good averages from ' fignames]); set(tl,'interp','none')
ax(2) = subplot(3,1,2);

plot(w_vis,visc0_std./visc0_avg.*100.0,'.-k'); hold on;
plot(w_nir,nirc0_std./nirc0_avg.*100.0,'.-k');hold off;
ylabel('Relative std of c0 [%]');ylim([0,20]);
ax(3) = subplot(3,1,3);
title('zoomed')
plot(w_vis,visc0_std./visc0_avg.*100.0,'.-k'); hold on;
plot(w_nir,nirc0_std./nirc0_avg.*100.0,'.-k');hold off;
ylabel('Relative std of c0 [%]');ylim([0,1]); grid;

linkaxes(ax,'x');
xlabel('Wavelength [nm]');

% Now save the new averaged c0 for use
days_cell = ''; i_avg = find(use_avg);
   c = char(leg{i_avg(1)});
   leg_cell = [ c(1:4) '-' c(5:6) '-' c(7:8)]; 
      if isempty(strfind(upper(c),'PM'))
         fn = [' AM'];
      else
         fn = [' PM'];
      end
      leg_cell = [leg_cell, fn];
   days_cell = leg_cell;
for i=2:length(i_avg);
   c = char(leg{i_avg(i)});
   leg_cell = [ c(1:4) '-' c(5:6) '-' c(7:8)]; 
      if isempty(strfind(upper(c),'PM'))
         fn = [' AM'];
      else
         fn = [' PM'];
      end
      leg_cell = [leg_cell, fn];
   days_cell = [days_cell ', ' leg_cell];
end

additionalnotes={'Langley at MLO outside of 1.8x the STD of 501 nm Langley residuals were screened out. ';...
   'c0 from best days at MLO';...
   ['Averages of c0 from multiple days including: ' days_cell '.']};
filesuffix=['refined_Langley_averaged_with_MLO_2018_Aug_11_12'];

disp({'Edit additionalnotes and filesuffix, then "Evaluate".';'Type "dbcont" to continue.'})
keyboard

daystr=label_daystr; %leg{i_avg(end)}(end-7:end);
visfilename=fullfile(pn, [daystr '_' inst '_VIS_C0_' filesuffix '.dat']);
nirfilename=fullfile(pn, [daystr '_' inst '_NIR_C0_' filesuffix '.dat']);

vissource_alt=cellstr(char(vis_names{i_avg}));
nirsource_alt=cellstr(char(nir_names{i_avg}));
vissource = '(SEE Original files for sources)';
nirsource = '(SEE Original files for sources)';

sav = menu('Save the resulting Co values to file?','Yes', 'No');
if sav ==1
disp(['Printing c0 file to :' visfilename])
starsavec0(visfilename, vissource, [additionalnotes; vissource_alt], w_vis, visc0_avg, visc0_std);
starsavec0(nirfilename, nirsource, [additionalnotes; nirsource_alt], w_nir, nirc0_avg, nirc0_std);

%Save the figures

save_fig(fig,[fp_out fignames '_cal_c0_' gdaystr],asktosave);
save_fig(fig2,[fp_out fignames '_cal_c0_relative_' gdaystr],asktosave);
figure_(fig2);
ylim([-4 4]);
save_fig(fig2,[fp_out fignames '_cal_c0_relative_zoom'],asktosave);
save_fig(fig3,[fp_out fignames '_cal_c0_avg_' gdaystr],asktosave);
end

return


function [vis, nir] = get_C0s(vis_,nir_)

try
   a=importdata(vis_);
catch
   [pn, fn,ext] = fileparts(vis_); fn = [fn, ext];
   disp(['*** Error unable to load file:' fn ' found at :' pn])
   vis = []; nir = [];
   return
end
vis.c0=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
vis.c0err=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
vis.w = a.data(:,strcmp(lower(a.colheaders),'wavelength'));

b=importdata(nir_);
nir.c0=b.data(:,strcmp(lower(b.colheaders), 'c0'))';
nir.c0err=b.data(:,strcmp(lower(b.colheaders), 'c0err'))';
nir.w = b.data(:,strcmp(lower(b.colheaders),'wavelength'));
return