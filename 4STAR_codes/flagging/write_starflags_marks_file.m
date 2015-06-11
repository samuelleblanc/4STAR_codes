function ng_str = write_starflag_marks_file(ng,flags_names,flag_tag,daystr, marks,by)
% ng_str = write_starflag_marks_file(ng,flags_names,flag_tag,daystr, marks,by)
%%
if ~exist('marks','var')
    marks = '_marks_all_';
else
    marks = ['_marks_',marks];
end
if exist('by','var')
    by = ['by_',by];
else
    by = [];
end
    [pname] = starpaths; % Not sure if this is right syntax for starpaths. 
starts = datevec(ng(1,:)); 
starts(:,4) = starts(:,4) +24.*(starts(:,3)-starts(1,3)); 
starts(:,6) = floor(starts(:,6));
ends = datevec(ng(2,:)); 
ends(:,4) = ends(:,4) +24.*(ends(:,3)-ends(1,3)); 
ends(:,6) = floor(ends(:,6));    
%%
 tmp_ = [starts(:,4:6), ends(:,4:6), ng(3,:)'];
ng_str = sprintf('%s \n ', 's.intervals=[');
ng_str = [ng_str, sprintf('datenum(''%02d:%02d:%02d'') datenum(''%02d:%02d:%02d'') %02d \n',...
    tmp_'  )];

ng_str = [ng_str, sprintf('%s \n', ']; ')];
    ng_str = [ng_str, 's.intervals(:,1:2)=s.ng(:,1:2)-datenum(''00:00:00'')+datenum([daystr(1:4) ''-'' daystr(5:6) ''-'' daystr(7:8)]);'];
    
f1=fopen([pname, filesep,daystr,'_starflags_man',marks,'_created_',datestr(now,'yyyymmdd_hhMM_'),by,'.m'],'w');

fprintf(f1,'%s', ng_str);
fclose(f1);

return