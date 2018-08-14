function s=starsky(mat_file,toggle)
% savematfile=starsky(mat_file,toggle)
% Process a single 4STAR sky scan from raw or starsky.mat
%
%   calls starwrapper to apply calibrations
%   and star_skyscan to balance sky scan legs, compute scattering angles,
%   and saves the results in a mat file ?STAR_yyyymmdd_NNN_STARSKY?.mat
%
% CJF, 2012/10/05, modified to load one pair of sky scans at a time, save
% one mat file per filen, placeholder for radiance cals, preparing for sky
% scan and aeronet inversion

% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set
% Connor, v1.1, 2018/06/02, adding capability to read raw .dat or single
% sky.mat file, and toggle.

version_set('1.1');
if ~isavar('toggle')||isempty(toggle)
   toggle = update_toggle;
end
%********************
% regulate input and read source
%********************
if ~isavar('mat_file');
   mat_file = getfullname('*.*');% Default to last_path
   if iscell(mat_file)
      if length(mat_file)>1
         warning('Starsky is intended to process only a single sky scan.  Processing first file...');
      end
      mat_file = mat_file{1};
   end
end
if isstruct(mat_file)
   % rename mat_file to s
   s = mat_file; clear mat_file;
elseif isafile(mat_file)
   if ~isempty(strfind(mat_file,'.mat'))&&strcmp('.mat',mat_file(end-3:end))
      s = load(mat_file); if isfield(s,'s') s = s.s; end
   else
      [sourcefile, contents0, savematfile, instr_name]=startupbusiness('sky',mat_file);
      disp(sourcefile)
      contents=[];
      if isempty(contents0);
         savematfile=[];
         disp('no sky files')
         disp('no sky files')         
         return;
      end;
      %********************
      % do the common tasks
      %********************
      % grab structures
      if numel(contents0)==1 && (~isempty(strfind(contents0{1},'vis_sky'))||~isempty(strfind(contents0{1},'nir_sky')))
         if ~isempty(strfind(contents0{1},'nir_sky'))
            contents0(2) = {strrep(contents0{1},'nir','vis')};
         elseif ~isempty(strfind(contents0{1},'vis_sky'))
            contents0(2) = {strrep(contents0{1},'vis','nir')};
         end
         contents0 = contents0';
      end
      if numel(contents0)==1;
         if ~isempty(strfind(contents0{1},'nir_sky'))
            contents0(1) = {strrep(contents0{1},'nir','vis')};
         elseif ~isempty(strfind(contents0{1},'vis_sky'))
            contents0(1) = {strrep(contents0{1},'vis','nir')};
         end
         error('This part of starsky.m to be developed. For now both vis and nir structures must be present.');
      elseif ~(any(~isempty(strfind(contents0,'nir_sky')))&any(~isempty(strfind(contents0,'nir_sky'))))
         ~isequal(sort(contents0), sort([{'vis_sky'};{'nir_sky'}]));
         error('vis_sun and nir_sun must be the sole contents for starsky.m.');
      end;
      load(sourcefile,contents0{:});
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
      % force gas and cwv retrievals true for sky scans
      toggle.gassubtract = true; toggle.runwatervapor = true
      s=starwrapper(vis_sky, nir_sky,toggle);
   end
end
% the logic here is unclear.  This should augment s.toggle with
% user-supplied toggles into s.toggle
if ~isfield(s,'toggle')
    s.toggle = toggle;
else
    s.toggle = catstruct(s.toggle, toggle);
end
% And then propagage user-flipped values in s.toggle back to toggle.
disp('Ready for sky scan stuff')
[~,fname,~] = fileparts(strrep(s.filename{1},'\',filesep));
% This value of "out" will be overwritten unless prevented by
% an error in the try-catch loop
s.out = [strrep(fname,'_VIS_','_STAR')];

if isfield(s.toggle,'flip_toggle')&&s.toggle.flip_toggle
   s.toggle = flip_toggle(s.toggle,s.out);
   toggle = s.toggle;
end
% add variables and make adjustments common among all data types. Also
% combine the two structures.
skymat_dir = getnamedpath('starsky');img_dir = getnamedpath('star_images');
s.toggle.gassubtract = true; s.toggle.runwatervapor = true;
s.wl_ = false(size(s.w));
s.wl_(s.aeronetcols) = true;
s.wl_ii = find(s.wl_);

if isfield(s.toggle,'use_last_wl')&&s.toggle.use_last_wl && isafile([getnamedpath('last_wl') 'last_wl.mat'])
   [wl_, wl_ii,sky_wl] = get_last_wl(s);
   s.aeronetcols = find(wl_); s.wl_ = wl_; s.wl_ii = find(wl_);
end
try
s= starsky_scan(s);      % vis_pix restrictions in here
filen = s.filen;
if isfield(s.toggle, 'skyscan_manual')&&s.toggle.skyscan_manual
  s = handscreen_skyscan_menu(s);
end
s = starsky_plus(s);
if isfield(s,'isPPL')&&s.isPPL
   gen_sky_inp_4STAR(s,s.good_ppl);
elseif isfield(s,'isALM')&&s.isALM
   gen_sky_inp_4STAR(s, s.good_almA);
   gen_sky_inp_4STAR(s, s.good_almB);
   s_ =prep_ALM_avg(s);
   if ~isempty(s_) 
       gen_sky_inp_4STAR(s_, s_.good_sky);
   end
end
save([getnamedpath('starsky'),  s.fstem, '.mat'],'s','-mat', '-v7.3');
catch ME
   [~, skyscan, ~] = fileparts(s.out); skyscan = strrep(skyscan,'_STAR','_')
   figure; plot(0:1,0:1,'o'); title(['Crashed during ',skyscan], 'interp','none');
   text(0.1,0.8,ME.identifier,'color','red');
   text(0.1,0.6,ME.message,'color','red','fontsize',8);
   imgdir = getnamedpath('star_images');
   skyimgdir = [imgdir,skyscan,filesep];
   saveas(gcf,[skyimgdir,skyscan, '.bad.png']);
   copyfile2([imgdir,skyscan,'.ppt'],[imgdir,'bad.',skyscan,'.ppt']);
   ppt_add_title([imgdir,'bad.',skyscan,'.ppt'], [s.fstem,': ',s.created_str]);
   ppt_add_slide([imgdir,'bad.',skyscan,'.ppt'], [skyimgdir,skyscan, '.bad']);
   
   warning(['Crashed during ', s.out]);
end
% close('all')
end
