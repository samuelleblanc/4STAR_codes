function create_all_forj(create_ppt)

% function to create FORJ test plots analysis and adds
% the FORJ corrected data to the forj_all.mat under 
% data_folder
%-----------------------------------------------------
% MS, 2016-05-19, modified to add to forj_all.mat under data_folder and not
% under individual folders
% MS, 2016-10-20, saving more plots
% SL, v2.0, Adding extra verbose to describe what it does and creation of a
% ppt file
%--------------------------------------------------------------------------

version_set('v2.0')

vis = getfullname('*_VIS_FORJ*.dat','Select Forj Az dat file.');
nir = getfullname('*_NIR_FORJ*.dat','Select Forj Az dat file.');

if ~exist('create_ppt','var')||isempty(dialog)
    create_ppt = true;
end

if create_ppt
    ppt_fname = fullfile([getnamedpath('starppt') filesep 'FORJ_created_on' datestr(now,'yyyymmdd_HHMMSS') '.ppt']); 
    pptcontents={}; % pairs of a figure file name and the number of figures per slide
    pptcontents0={};
end

[pname_, fname, ext] = fileparts(vis);
matdir = [pname_,filesep, 'mat']
if ~exist(matdir,'dir')
    mkdir(matdir);
end

plot_dir = [pname_,filesep,'plots']; 
if ~exist(plot_dir,'dir');
    mkdir(plot_dir);
end
plot_dir = [plot_dir,filesep];

% check if forj_all exist in forj dir
% if exist([matdir,filesep,'forj_all.mat'],'file')
%     forj_out = load([matdir,filesep,'forj_all.mat']);
% end

% check if forj_all exist in starpaths
if exist([starpaths,'forj_all.mat'],'file')
    forj_out = load([starpaths,'forj_all.mat']);
    save_to_mat_instead = false;
else
    warning(['forj_all.mat file not found! Looking in:',starpaths,'forj_all.mat']) 
    save_to_mat_instead = true;
end
files = dir([pname_, filesep,'*_VIS_FORJ*.dat']);
%files = dir([pname_, filesep,'*_NIR_FORJ*.dat']);

in = 0;
for f = 1:length(files)
    
    vis = [pname_, filesep, files(f).name];
    
    try
        [forj_out_,forj_vis_out,forj_fig_path] = TCAPII_forj_az_v2(vis);
        if ~isempty(forj_out_)
            if ~exist('forj_out','var')
                forj_out = forj_out_;
            else
                [forj_out.time, ij] = unique([forj_out.time, forj_out_.time]);
                flds = fieldnames(forj_out);
                for fld = 1:length(flds)
                    if ~strcmp(flds{fld},'meas')&&~strcmp(flds{fld},'time')&&~strcmp(flds{fld},'Az_deg')
                        tmp = [forj_out.(flds{fld}); forj_out_.(flds{fld})];
                        forj_out.(flds{fld}) = tmp(ij,:);
                    end
                end
                forj_out.meas(end+1) = forj_out_.meas;
                forj_out.meas = forj_out.meas(ij);
                if save_to_mat_instead
                    save([matdir,filesep,'forj_all.mat'],'-struct','forj_out');
                else
                    save([starpaths,'forj_all.mat'],'-struct','forj_out');
                end
                % save some more figures
                %LED stability
                f3 = [plot_dir,files(f).name(1:end-4), '_LEDstability'];
                save_fig(3,f3,false);
                % normalized signals
                f4 = [plot_dir,files(f).name(1:end-4), '_NormalizedSignal'];
                save_fig(4,f4,false);
                close all;
                pptcontents0=[pptcontents0; {forj_fig_path 1}];
            end
        else
            disp('forj_out_ was empty')
        end
        
    catch
        %%
        [pn,fname,ext] = fileparts(vis);
        
        disp(['Bad file? ', [fname, ext]])
    end
   % close('all')
end
%%
bad_time = (sum(isNaN(forj_out.corr'))>0);
forj_out.meas(bad_time) = [];
forj_out.time(bad_time) = [];
forj_out.corr(bad_time,:) = [];
forj_out.corr_std(bad_time,:) = [];
forj_out.corr_cw(bad_time,:) = [];
forj_out.corr_cw_std(bad_time,:) = [];
forj_out.corr_ccw(bad_time,:) = [];
forj_out.corr_ccw_std(bad_time,:) = [];
disp(['Saving new Forj all file to: ',matdir,filesep,'forj_all.mat'])
save([matdir,filesep,'forj_all.mat'],'-struct','forj_out');

if create_ppt
    % sort out the PowerPoint contents
    idx4=[];
    for ii=1:size(pptcontents0,1)
        if pptcontents0{ii,2}==1
            pptcontents=[pptcontents; {pptcontents0(ii,1)}];
        elseif pptcontents0{ii,2}==4
            idx4=[idx4 ii];
            if numel(idx4)==4 || ii==size(pptcontents0,1) || pptcontents0{ii+1,2}~=4
                if numel(idx4)>=3
                    pptcontents=[pptcontents; {pptcontents0(idx4,1)}];
                else
                    pptcontents=[pptcontents; {[pptcontents0(idx4,1);' ';' ']}];
                end;
                idx4=[];
            end
        else
            error('Paste either 1 or 4 figures per slide.');
        end
    end
    daystr1 = datestr(forj_out.time(1),'yyyymmdd');
    daystr2 = datestr(forj_out.time(end),'yyyymmdd');
    disp(['Saving FORJ ppt to:' ppt_fname])
    makeppt(ppt_fname, ['FORJ  - from '  daystr1 ' to ' daystr2], pptcontents{:});
end
%%
return