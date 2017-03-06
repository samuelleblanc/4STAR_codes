function [forj_corr, detail] = get_forj_corr(time)
% forj_corr = get_forj_corr(time)
% Returns the 
forj_all = load([getnamedpath('4STAR_Github_data_folder'),'forj_all.mat']);
lower = max([1, find(forj_all.time<time,1,'last')]);
upper = min([length(forj_all.time), find(forj_all.time>time,1,'first')]);
forj_corr.Az_deg = forj_all.Az_deg(1,:);
detail.Az_deg = forj_corr.Az_deg;
if upper==lower
    forj_corr.corr = forj_all.corr(lower,:);
    forj_corr.corr_std = forj_all.corr_std(lower,:);
    forj_corr.corr_cw = forj_all.corr_cw(lower,:);
    forj_corr.corr_ccw = forj_all.corr_ccw(lower,:);
else
    forj_corr.corr = interp1(forj_all.time(lower:upper), forj_all.corr(lower:upper,:),time,'nearest');
    forj_corr.corr_std = sqrt(std(forj_all.corr(lower:upper,:)).^2 + sum(forj_all.corr_std(lower:upper,:).^2));    
    forj_corr.corr_cw = interp1(forj_all.time(lower:upper), forj_all.corr_cw(lower:upper,:),time,'nearest');
    forj_corr.corr_ccw = interp1(forj_all.time(lower:upper), forj_all.corr_ccw(lower:upper,:),time,'nearest');
end
detail.meas = forj_all.meas(lower:upper);
forj_all = rmfield(forj_all,'time');
forj_all = rmfield(forj_all, 'meas');
flds = fieldnames(forj_all);
for fld = 1:length(flds)
    if ~strcmp(flds{fld},'Az_deg')
    detail.(flds{fld}) = forj_all.(flds{fld})(lower:upper,:);
    end
end


return
