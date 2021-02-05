function s=starsky_2(mat_file,toggle)
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
% Connor, v1.2, 2020/05/02, adding capability to produce GRASP output
version_set('1.2');

%********************
% regulate input and read source
%********************
if ~isavar('mat_file');
    mat_file = getfullname(['4STAR_*sky*.dat;*vis_sky*.dat'],'stardat');% Default to last_path
    if iscell(mat_file)
        if length(mat_file)>1
            warning('Starsky is intended to process only a single sky scan.  Processing first file...');
        end
        mat_file = mat_file{1};
    end
end
if ~isavar('toggle')||isempty(toggle)
    toggle = update_toggle;
end
if ~isfield(toggle,'flip_toggle')||toggle.flip_toggle
    toggle = flip_toggle(toggle);
end
if isstruct(mat_file)
    % rename mat_file to s
    s = mat_file; clear mat_file;
    %    previous = true;
elseif isafile(mat_file)
    if ~isempty(strfind(mat_file,'.mat'))&&strcmp('.mat',mat_file(end-3:end))
        s = load(mat_file); if isfield(s,'s') s = s.s; end;
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
        toggle.gassubtract = true; toggle.runwatervapor = true;
        s=starwrapper(vis_sky, nir_sky,toggle);
        s.toggle = toggle; %overwrite changes to toggle from within starwrapper
        % which come from a re-load of update_toggle in starinfo
    end
end
if ~isfield(s,'t')&&(isfield(s,'track')||isfield(s,'vis_sun')||isfield(s,'vis_skya')||isfield(s,'vis_skyp'))
    warning(['Supplied input appears to be a *star.mat file, not a "SKY" mat file. Skipping...']);
else
    % the logic here is unclear.  This should augment s.toggle with
    % user-supplied toggles into s.toggle
    if ~isfield(s,'toggle')
        s.toggle = toggle;
    else
        s.toggle = merge_toggle(s.toggle, toggle);
    end
    
    if isfield(s.toggle,'rerun_skyscan')
        run_skyscan = s.toggle.rerun_skyscan;
    else
        run_skyscan = false;
    end
    % The "isPPL" field is added by star_skyscan. If this field doesn't exist,
    % need to run star_skyscan
    if ~isfield(s, 'isPPL')
        run_skyscan = true;
    end
    if isfield(s.toggle,'rerun_starsky_plus')
        run_starsky_plus = s.toggle.rerun_starsky_plus;
    else
        run_starsky_plus = false;
    end
    % The sfc_albedo field is added by starsky_plus.  If it doesn't exist yet,
    % then starsky_plus definitely needs to be run
    if ~isfield(s,'sfc_alb')
        run_starsky_plus = true;
    end
    % And then propagage user-flipped values in s.toggle back to toggle.
    disp('Ready for sky scan stuff')
    [~,fname,~] = fileparts(strrep(s.filename{1},'\',filesep));
    % This value of "out" will be overwritten unless prevented by
    % an error in the try-catch loop
    s.out = [strrep(fname,'_VIS_','_STAR')];
    
! Not 100% sure I should have commented this out on 2020-10-22    
%     if isfield(s.toggle,'flip_toggle')&&s.toggle.flip_toggle
%         s.toggle = flip_toggle(s.toggle,s.out);
%         toggle = s.toggle;
%     end
    % add variables and make adjustments common among all data types. Also
    % combine the two structures.
    paths = set_starpaths;
    skymat_dir = paths.starsky; img_dir = paths.starfig;
    s.toggle.gassubtract = true; s.toggle.runwatervapor = true;
    s.wl_ = false(size(s.w));
    s.wl_(s.aeronetcols) = true;
    s.wl_ii = find(s.wl_);
    
    if isfield(s.toggle,'use_last_wl')&&s.toggle.use_last_wl && isafile([getnamedpath('last_wl') 'last_wl.mat'])
        [wl_, wl_ii,sky_wl,w_fit_ii] = get_last_wl(s);
        s.aeronetcols = find(wl_); s.wl_ = wl_; s.wl_ii = find(wl_);
        s.w_isubset_for_polyfit = w_fit_ii;
    end
    
    if (sum(s.Str==0)>0)&&(sum(s.Str==1)>0)&&(sum(s.Str==2)>=5)
        try
            part = 1;
            if run_skyscan
                s= starsky_scan(s);      % vis_pix restrictions in here
            end
            part = 2;
            filen = s.filen;
            if run_starsky_plus
                s = starsky_plus(s);
            end
            part = 3;
            if isfield(s.toggle, 'skyscan_manual')&&s.toggle.skyscan_manual
                [s,changed] = handscreen_skyscan_menu(s);
                close('all'); 
                if changed.wl||changed.SA 
                    s= starsky_scan(s); s = starsky_plus(s);
                end
            end
            if isfield(s.toggle,'sky_tag')&&~isempty(s.toggle.sky_tag)
                tag_str = s.toggle.sky_tag; tag_str = tag_str{:};
                if ~isempty(tag_str) tag_str = strrep(['.',tag_str, '.'],'..','.'); tag_str = strrep(tag_str,'..','.');end
            else tag_str = '';
            end
            save(strrep([getnamedpath('starsky'),  s.fstem,tag_str, '.mat'],'..','.'),'s','-mat', '-v7.3');
            part = 4;
            if isfield(s.toggle,'grasp_out') && s.toggle.grasp_out
                [grasp_mat, grasp_csv] = gen_grasp_out(s);
            end
            part = 5;
            if ~isfield(s.toggle,'anet_out')||(isfield(s.toggle,'anet_out')&&s.toggle.anet_out)
                if isfield(s,'isPPL')&&s.isPPL
                    gen_sky_inp_4STAR(s,s.good_ppl);
                elseif isfield(s,'isALM')&&s.isALM
                    gen_sky_inp_4STAR(s, s.good_almA);
                    gen_sky_inp_4STAR(s, s.good_almB);
                    s_ =prep_ALM_avg(s);
                    if ~isempty(s_)&&length(s_.t)>10
                        gen_sky_inp_4STAR(s_, s_.good_sky);
                    end
                end
            end
        catch ME
            if isfield(s,'toggle')&&isfield(s.toggle,'debug')&&s.toggle.debug
                dbstop starsky_2
                if run_skyscan && part == 1
                    s= starsky_scan(s);      % vis_pix restrictions in here
                end
                filen = s.filen;
                if run_starsky_plus && part <=2
                    s = starsky_plus(s);
                end
                if isfield(s.toggle, 'skyscan_manual')&&s.toggle.skyscan_manual && part <= 3
%                     s = handscreen_skyscan_menu(s);                
                    [s,changed] = handscreen_skyscan_menu(s);
                    close('all');
                    if changed.wl||changed.SA
                        s= starsky_scan(s); s = starsky_plus(s);
                    end
                end
                if part <= 4 && isfield(s.toggle,'grasp_out') && s.toggle.grasp_out
                    grasp_fname = gen_grasp_out(s);
                elseif part <=5
                    if isfield(s,'isPPL')&&s.isPPL
                        % max sky_test=1.5 for non-symmetry test
                        gen_sky_inp_4STAR(s,s.good_ppl);
                    elseif isfield(s,'isALM')&&s.isALM
                        % max sky_test=1.5 for non-symmetry test
                        gen_sky_inp_4STAR(s, s.good_almA);
                        % max sky_test=1.5 for non-symmetry test
                        gen_sky_inp_4STAR(s, s.good_almB);
                        s_ =prep_ALM_avg(s);
                        if ~isempty(s_)&&length(s_.t)>10
                            % max sky_test=2 if symmetry test passed
                            gen_sky_inp_4STAR(s_, s_.good_sky);
                        end
                    end
                end
            end
            [pname,fstem,ext] = fileparts(strrep(s.filename{1},'\',filesep));
            badtime_str = ['.bad_on',datestr(now,'_yyyymmdd_HHMMSS.')];
            [~, skyscan, ~] = fileparts(s.out); skyscan = strrep(skyscan,'_STAR','_')
            figure; plot(0:1,0:1,'o'); title(['Crashed during ',skyscan], 'interp','none');
            text(0.1,0.8,ME.identifier,'color','red');
            text(0.1,0.6,ME.message,'color','red','fontsize',8);
            imgdir = getnamedpath('starimg');
            skyimgdir = [imgdir,skyscan,filesep];
            saveas(gcf,[skyimgdir,skyscan,badtime_str, '.png']);
            copyfile2([imgdir,skyscan,'.ppt'],[imgdir,'bad.',skyscan,'.ppt']);
            ppt_add_title([imgdir,'bad.',skyscan,'.ppt'], [fstem,': ',badtime_str]);
            ppt_add_slide([imgdir,'bad.',skyscan,'.ppt'], [skyimgdir,skyscan,badtime_str]);
            
            warning(['Crashed during ', s.out]);
        end
    end
end
close('all')
end
