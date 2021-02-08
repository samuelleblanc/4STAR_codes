function [savematfile, contents]=starskies(toggle)
% [savematfile, contents] = starskies(toggle)
% Next-generation starskies supporting unattended/batch processing
% including anet data level tests, tau_abs_gas_fit, alb from SSFR or ?,
% splitting ALM into alma, almb, alm (avg). 
%
% Example
%   sstarskies; % this prompts user interfaces
%   [savematfile, contents]=starsun returns the path for the resulting mat-file and its contents.
%
% Modifications:
% SL, v1.1, 2019-03-20, added excel file writing 
% SL, v1.2, 2020-03-30, added powerpoint combining
version_set('1.2');
%********************
% regulate input and read source
%********************
if ~isavar('toggle')||isempty(toggle)
   toggle = update_toggle;
else % user has supplied some toggle values so incorporate them
   toggle = update_toggle(toggle);
end
if isfield(toggle, 'flip_toggle')&&toggle.flip_toggle
   toggle = flip_toggle(toggle);
end
infiles = getfullname('*star.mat','starmats','Select one or more star.mat files');
if ischar(infiles)
   infiles = {infiles};
end

[pname,fstem,ext] = fileparts(infiles{1});
xls_fname = [pname filesep fstem '_Skyscan_Summary.xls'];
if toggle.verbose; disp(['Excel Summary file saved to: ' xls_fname]), end;

skymat_dir = getnamedpath('starsky');img_dir = getnamedpath('starimg');
if isfield(toggle, 'skip_ppl')&&toggle.skip_ppl
   contentx = {'nir_skya';'vis_skya'};
elseif isfield(toggle,'skip_alm')&&toggle.skip_alm
   contentx = {'nir_skyp';'vis_skyp'};
else
   contentx = {'nir_skya';'nir_skyp';'vis_skya';'vis_skyp'};
end
% contentx = {'nir_skya';'vis_skya'}; % uncomment either of these to select only alm or ppl
% contentx = {'nir_skyp';'vis_skyp'};
if ~isfield(toggle, 'skip_lt_N'); toggle.skip_lt_N = 0; end
if ~isfield(toggle, 'skip_gt_N'); toggle.skip_gt_N = inf;   end
for in = 1:length(infiles)
   if toggle.verbose; [~,matfile,ext] = fileparts(infiles{in}); disp([matfile ext]); end
   [sourcefile, contents0, savematfile]=startupbusiness('sky', infiles{in});
   contents0 = intersect(contents0,contentx);
   if toggle.verbose; disp(sourcefile); end
   contents=[];
   if isempty(contents0);
      savematfile=[];
      disp('no sky files')

   else
      clear nir_skya nir_skyp vis_skya vis_skyp
      load(sourcefile,contents0{:});
      if numel(contents0)==1;
         error('This part of starsky.m to be developed. For now both vis and nir structures must be present.');
      elseif ~(any(~isempty(strfind(contents0,'nir_sky')))&any(~isempty(strfind(contents0,'nir_sky'))))
         ~isequal(sort(contents0), sort([{'vis_sky'};{'nir_sky'}]))
         error('vis_sun and nir_sun must be the sole contents for starsky.m.');
      end;
      if isavar('vis_skya')&&isavar('nir_skya')
         vis_sky = vis_skya; nir_sky = nir_skya;
         if isavar('vis_skyp')&&isavar('nir_skyp')
            vis_sky = [vis_sky, vis_skyp]; nir_sky = [nir_sky, nir_skyp];
         end
      else
         if isavar('vis_skyp')&&isavar('nir_skyp')
            vis_sky = vis_skyp; nir_sky = nir_skyp;
         end
      end
      for N = length(vis_sky):-1:1
         if ~isempty(vis_sky(N).t)
            ts(N) = vis_sky(N).t(1);
         else
            ts(N)= [];vis_sky(N) = []; nir_sky(N) = [];
         end
      end
      [~,ij] = unique(ts);
      vis_sky = vis_sky(ij); nir_sky = nir_sky(ij); clear ts ij    
      for si = 1:length(vis_sky)
         if ~isempty(vis_sky(si).t)
            filen = num2str(vis_sky(si).filen);
            if (vis_sky(si).filen>= toggle.skip_lt_N) ...
                  && (vis_sky(si).filen <= toggle.skip_gt_N)
               s=starwrapper(vis_sky(si), nir_sky(si),toggle);
               s.toggle = toggle; %overwrite changes to toggle from within starwrapper
               % which come from a re-load of update_toggle in starinfo
               s = starsky_2(s,s.toggle);
%             catch
%                close('all');
%                [~,fstem,~] = fileparts(s.filename{1}); fstem = strrep(fstem,'_VIS_','_*_');
%                warning(['Crashed while running ',fstem]);
%                pause(4);
%             end
                [xls_fname] = print_skyscan_details_to_xls(s,xls_fname);
            toggle = s.toggle; close('all');
            end
         end
      end
   end
end
if toggle.verbose; disp(['Excel Summary file saved to: ' xls_fname]), end;
ppt_out = merge_ppts_for_day(getnamedpath('starimg'),s.daystr,s.instrumentname,'_allSKY');
if toggle.verbose; disp(['Powerpoint combined file saved to: ' ppt_out]), end;
return
