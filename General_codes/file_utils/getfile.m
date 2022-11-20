function [fid, fname, pname] = getfile(fspec,pathfile);
% function [fid, fname, pname] = getfile(fspec,pathfile)
% usage 1: [fid, fname, pname] = getfile(fspec,pathfile)
% usage 2: [fid, fname, pname] = getfile(fspec)
% usage 3: [fid, fname, pname] = getfile
% fspec is a string indicating the file mask to be used with uigetfile
% pathfile is a string indicating the filename stem of the mat-file to use
% containing the "filepath" desired.
% if successful, fid is a positive integer indicating the file identifier
% if unsuccessful, fid is -1

% 2009-01-08, CJF: Modified to discontinue use of getfile.  Using
% getfullname_ instead.

if ~isavar('pathfile')||isempty(pathfile)
   pathfile = 'lastpath.mat';
end
if ~isavar('fspec')||isempty(fspec)
   fspec = '*.*';
end
if isempty(fspec)
   fspec = '*.*';
end

[fullname] = getfullname(fspec,pathfile);
if ~isempty(fullname)&&isafile(fullname)
   [pname, fstem,ext] = fileparts(fullname);
   pname = [pname, filesep];
   fname = [fstem,ext];
   fid = fopen(fullname,'r+');
else
   pname = [];
   fname = [];
   fid = -1;
end