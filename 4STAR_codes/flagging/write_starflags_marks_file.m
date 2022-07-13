function [ng_str, marks_fname] = write_starflag_marks_file(ng,flags_names,flag_tag,daystr, marks,by, now_str)
% ng_str = write_starflag_marks_file(ng,flags_names,flag_tag,daystr, marks,by, now_str)
version_set('2016-02-17 16:30');

if ~exist('marks','var')
    marks = 'ALL';
end
   marks = ['marks_',upper(marks),'_'];
if ~exist('by','var')
    by = ['auto'];
end
by = [by,'_'];
  
if ~exist('now_str','var')
    now_str = datestr(now,'yyyymmdd_HHMM');
end
% end
starinfo_name = which(['starinfo_',daystr,'.m']); pname = fileparts(starinfo_name); pname = [pname, filesep];
% [pname] = starpaths; % Not sure if this is right syntax for starpaths. 
starts = datevec(ng(1,:)); 
starts(:,4) = starts(:,4) +24.*(starts(:,3)-starts(1,3)); 
starts(:,6) = floor(starts(:,6));
ends = datevec(ng(2,:)); 
ends(:,4) = ends(:,4) +24.*(ends(:,3)-ends(1,3)); 
ends(:,6) = floor(ends(:,6));    
%%
marks_fname = ['starflags_',daystr,'_',by,marks,now_str];
ng_str = ['function marks = ',marks_fname];
comment_str = ['% starflags file for ',daystr,' created by ', by(1:end-1), ' on ', now_str, ' to mark ',marks(7:end-1), ' conditions'];
ng_str = [sprintf('%s  \n ',ng_str), sprintf('%s \n ',comment_str)];
ng_str = [ng_str, sprintf('%s \n ', ['version_set(''', now_str ''');'])];
    
ng_str = [ng_str, sprintf('%s  \n ',['daystr = ''',daystr,''';'])];
tags = unique(ng(3,:));
for tag = 1:length(tags)
    ng_str = [ng_str,sprintf('%s \n ',['% tag = ',num2str(tags(tag)), ': ',flags_names{flag_tag==(tags(tag))}])];
end

 tmp_ = [starts(:,4:6), ends(:,4:6), ng(3,:)'];
% function ng = starflags_20151117_CF_marks_cloud_20160212_1439;
ng_str = [ng_str, sprintf('%s \n ', 'marks=[')];
ng_str = [ng_str, sprintf('datenum(''%02d:%02d:%02d'') datenum(''%02d:%02d:%02d'') %02d \n',...
    tmp_'  )];

ng_str = [ng_str, sprintf('%s \n', ']; ')];
    ng_str = [ng_str, 'marks(:,1:2)=marks(:,1:2)-datenum(''00:00:00'')+datenum([daystr(1:4) ''-'' daystr(5:6) ''-'' daystr(7:8)]);'];

ng_str = [sprintf('%s \n', ng_str),'return'];    
% mark_fname = [daystr,'_starflags_man',marks,'_created_',datestr(now,'yyyymmdd_hhMM_'),by,'.m'];    
disp(['...Writing marks flag file: ', marks_fname])
f1=fopen([pname, marks_fname,'.m'],'w');

fprintf(f1,'%s', ng_str);
fclose(f1);
pause(.05)
% disp(which(marks_fname))
return