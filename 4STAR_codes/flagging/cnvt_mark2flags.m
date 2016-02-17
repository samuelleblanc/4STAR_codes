function [flags,flag_info,t] = cnvt_mark2flags(marked,t)
% [flags,flag_info,t] = cnvt_mark2flags(t,marked)
%%
% daystr = datestr(t(1),'yyyymmdd');
%%
% daystr = ['20130906']
% ng=[datenum('15:58:50') datenum('15:58:51') 90 
%     datenum('16:22:00') datenum('16:30:40') 90 
% datenum('16:37:45') datenum('16:58:10') 10 
% datenum('17:10:55') datenum('17:14:40') 10 
% datenum('17:17:53') datenum('17:18:00') 10 
% datenum('17:18:10') datenum('17:18:20') 10 
% datenum('17:19:05') datenum('17:21:45') 10 
% datenum('17:24:35') datenum('17:25:40') 10 
% datenum('17:25:57') datenum('17:26:05') 10
% datenum('18:53:30') datenum('18:53:35') 90 
% datenum('18:54:30') datenum('18:55:50') 90 
% datenum('18:59:44') datenum('19:37:40') 90 
% datenum('20:03:50') datenum('20:16:15') 90 
% datenum('20:28:35') datenum('20:31:05') 90 
% datenum('20:40:55') datenum('20:51:27') 90]; 
% 
%  t = [min(marked.intervals(:,1)):(1./(24*60)):max(marked.intervals(:,2))];
% tt = unique([t;ng(:,1);ng(:,2)]);
if ~exist('marked','var')||~isstruct(marked)
    if ~exist('marked','var')||~exist(marked,'file')
      marked = getfullname('starflags_*_marks_*.m','star_marks','Select star mark file');
    end
    marked = get_starinfo_parts(marked);
end

if ~exist('t','var')
    t = [min(marked.intervals(:,1)):(1./(24*60)):max(marked.intervals(:,2))];
end

flag_info.flag_tags = marked.flag_tags;
flag_info.flag_names = marked.flag_names;

for flag = 1:length(flag_info.flag_names)    
    flags.(flag_info.flag_names{flag}) = false(size(t));
end

for N = 1:size(marked.intervals,1)
    flag_tag = marked.intervals(N,3);
    tag_ii = find(flag_info.flag_tags==flag_tag);
    t_ = t>=marked.intervals(N,1) & t<=marked.intervals(N,2);
    flags.(flag_info.flag_names{tag_ii})(t_) = true;
end

return                    