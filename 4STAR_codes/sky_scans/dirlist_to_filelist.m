function [fulllist,flist] = dirlist_to_filelist(dlist,pname);
% Converts a directory list and pathname (returned by dir_) to a file list
% array of char with full path spec.
if ~isavar('pname')
   if isfield(dlist,'folder')
      pname = [dlist.folder,filesep]; pname = strrep(pname, [filesep filesep], filesep);
   end
end
% flist = string;fulllist = {};
if isempty(dlist)
    fulllist(1) = {[]};
    flist = string([]);
elseif length(dlist)==1
    fulllist(1) = {[pname, char(dlist(1).name)]};
    flist(1) = {string(dlist(1).name)};
else
   for d = length(dlist):-1:1
      if strcmp(dlist(d).name,'.')||strcmp(dlist(d).name,'..')
         dlist(d) = [];
      end
   end
   for d = length(dlist):-1:1
      fulllist(d) = {[pname, char(dlist(d).name)]};
      flist(d) = {string(dlist(d).name)};
   end
end
return
  