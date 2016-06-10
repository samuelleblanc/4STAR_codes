function [flags,flag_info,t] = cnvt_ng2flags(ng,t)
%% Program to convert ng (no good) flags to flag format
% created by CJF
% Modification history:
% SL (v1.0): 2014-11-12: added versioning, and ng=3 for tracking errors
version_set('v1.0')
% [flags,flag_info,t] = cnvt_flags2ng(ng)
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
%  t = [min(ng(:,1)):(1./(24*60)):max(ng(:,2))];
% tt = unique([t;ng(:,1);ng(:,2)]);
if ~isempty(ng)
    tags = unique(ng(:,3));
    flag_tags = [1  ,2 ,3,10,90,100,200,300];
    flag_names = {'unknown','before_or_after_flight','tracking_errors','unspecified_clouds','cirrus','inst_trouble' ,'inst_tests' ,'frost'}
    if ~exist('t','var')
        t = [min(ng(:,1)):(1./(24*60)):max(ng(:,2))];
    end
    flag_info.flag_tags = tags;
    for tag = 1:length(tags)
        tag_ii = find(flag_tags==tags(tag));
        flags.(flag_names{tag_ii}) = false(size(t));
        flag_info.flag_names(tag) = {flag_names{tag_ii}}
    end
    
    for N = 1:size(ng,1)
        flag_tag = ng(N,3);
        tag_ii = find(flag_info.flag_tags==flag_tag);
        t_ = t>=ng(N,1) & t<=ng(N,2);
        flags.(flag_info.flag_names{tag_ii})(t_) = true;
    end
else
    flags = [];
    flag_info = [];
end;
flags.t = t;
% agricultural smoke [datenum('18:57:45') datenum('18:58:25')] is masked by
% the STD-based screening. A limitation of the automation.

return