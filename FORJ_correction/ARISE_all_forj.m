function ARISE_all_forj

vis = getfullname_('*_VIS_FORJ*.dat','ARISE','Select Forj Az dat file.');

[pname_, fname, ext] = fileparts(vis);
matdir = [pname_,filesep, 'mat']
if ~exist(matdir,'dir')
    mkdir(matdir);
end
% if exist([matdir,filesep,'forj_all.mat'],'file')
%     forj_out = load([matdir,filesep,'forj_all.mat']);
% end
files = dir([pname_, filesep,'*_VIS_FORJ*.dat']);
in = 0;
for f = 1:length(files)
    
    vis = [pname_, filesep, files(f).name];
    
    try
        forj_out_ = TCAPII_forj_az_v2(vis);
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
            
            save([matdir,filesep,'forj_all.mat'],'-struct','forj_out');
        end
        else
            disp('forj_out_ was empty')
        end
        
    catch
        %%
        [pn,fname,ext] = fileparts(vis);
        
        disp(['Bad file? ', [fname, ext]])
    end
    close('all')
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
save([matdir,filesep,'forj_all.mat'],'-struct','forj_out');
%%
return