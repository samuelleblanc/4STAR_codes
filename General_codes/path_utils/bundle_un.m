function [ output_args ] = bundle_un(inzip, outpath, over)
% [ output_args ] = bundlefun(inzip, outpath, over)
% inzip is an optional string containing the fname  of a bundlefnt zip file
% outpath is an optional string indicating the path to put new files
% over, if over==0, backup don't overwrite.  over==1 overwrite, over==2 overwrite if newer
% The default is 0, to overwrite if newer and backup existing function

% 2019-08-15, CJF: fixing filename construction problem with leftovers line 103
tmpdir = ['unzip_tmpdir_',datestr(now,'yyyy-mm-dd_HHMMSS')];
[status, msg] = mkdir(tmpdir);
if isempty(who('inzip')) || isempty(dir(inzip)) 
   inzip = getfullname('*.zip','bundle','Select a bundlefnt zipped file.');
end
while isempty(who('outpath'))||~isadir(outpath)
   outpath = getdir;
end
if strcmp(outpath(end),filesep)
   outpath(end) = [];
end
if ~isadir(outpath)
   mkdir(outpath);
end
outpath = [outpath, filesep];
if isempty(who('over'))
   over = 0;
end
if over<0
   over=0;
elseif over>2
   over=2
end
% unzips the supplied file into a temp directory
files = unzip(inzip, tmpdir);
supplied = fileparts(which('imagedemo')); 
[~,supplied] = strtok(fliplr(supplied),filesep); 
supplied = fliplr(supplied);
for f = length(files):-1:1
      [~, fun,ext] = fileparts(files{f});
   % for each file, run which to get the fullpath
   there = which([fun ext]);
   if ~isempty(strfind(there,supplied))
      disp('Trimming supplied dependency...')
      files(f) = [];      
   end
end
for f = length(files):-1:1
   [~, fun,ext] = fileparts(files{f});
   % for each file, run which to get the fullpath
   there = which([fun ext]);
   if ~isempty(there)
      % if exists on path, check if same
      if cmp_files(there, files{f})
         % if exists and same skip or delete from temp_dir
         delete(files{f});
      else
         there_file = dir(there);
         there_f = dir(files{f});
         if over==0            
            N = 1;
            [there_path,~,~] = fileparts(there); there_path = [there_path filesep];
            dstr = datestr(now,'yyyymmdd_');
            while ~isempty(dir([there_path,fun,dstr,num2str(N),ext]))
               N = N+1;
            end
            % if exists and not same, rename existing appending fname with datestamp + n
            status = movefile(there, [there_path,fun,dstr,num2str(N),ext]);
            status2 = movefile(files{f},there);
         elseif over==1
            %  then mv from temp_dir to exist_path
            status = movefile(files{f},there);
         elseif over==2
            if (there_f.datenum > there_file.datenum)
               try 
                  status = movefile(files{f},there);
               catch
                  status = movefile(files{f},outpath)
               end
            else
               delete(files{f});
            end
         end
      end
   else
      % if not exist then mv to outpath, creating if necessary
      status = movefile(files{f},[outpath,fun, ext]);
   end
   
end % end for each file
leftover = dir(tmpdir);
for L = length(leftover):-1:1
   if strcmp(leftover(L).name,'.')||strcmp(leftover(L).name,'..')
      leftover(L) = [];
   end
end
% If empty delete temp_dir
if isempty(leftover) % only . and .. in the directory listing
   rmdir(tmpdir)
else    % else warning that some files couldn't be moved.
   warning(['Some files could not be moved out of ',tmpdir, ' in place of existing files.']);
   warning(['Moving to ',outpath, ' instead...'])
   for L = length(leftover):-1:1
       [~,fun,ext] = fileparts(leftover(L).name);
      status = movefile([leftover(L).folder,filesep,leftover(L).name],[outpath,fun, ext]);
%       status = movefile(leftover{L},[outpath,fun, ext]);
   end
end
% add outpath to end of matlab path
PP = path;
if isempty(strfind(PP,outpath))
   path(outpath,path);
   savepath;
end

return

