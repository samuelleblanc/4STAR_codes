function modify_starinfo(sinfo)

while ~exist('sinfo','var')||~exist(sinfo,'file')
   sinfo = getfullname('starinfo*.m','starinfo','Select starinfo file to upgrade for starflag.');
end
[pname, fname, ext] = fileparts(sinfo); pname = [pname, filesep]; fname = [fname ext];

% open new starinfo file...
fid_new = fopen(strrep(sinfo,[filesep,'starinfo'],[filesep,'starinfo_']),'w');

% read and insert new functional stub stub at top
top_inname = which('starinfo_top.m');
fid_top = fopen(top_inname, 'r');
status = fwrite(fid_new, fread(fid_top,'uchar')); 
fclose(fid_top);

% read initial starinfo, skip initial line
fid_old = fopen(sinfo,'r'); 
while ~feof(fid_old)
   this = fgetl(fid_old);
   evalin_daystr = length(strfind(this,'daystr'))>0 && length(strfind(this,'evalin'))>0 ...
      && length(strfind(this,'caller'))>0;
   evalin_s = length(strfind(this,'evalin'))>0 && length(strfind(this,'caller'))>0 ...
      && length(strfind(this,'''s'''))>0 ;
   % daystr=evalin('caller','daystr');
   tok = strtok(this);
   if ~(strcmp(tok,'function')) && ~evalin_daystr && ~evalin_s
      status = fprintf(fid_new, '%s \n', this);
   end
end
fclose(fid_old);

% skipped = deblank(fgetl(fid_old));
% while ~strcmp(skipped(1),'%')
%    skipped = deblank(fgetl(fid_old));
% end


% insert main body   

% read and insert stub at bottom
bot_inname = which('starinfo_bot.m');
fid_bot = fopen(bot_inname, 'r');
status = fwrite(fid_new, fread(fid_bot,'uchar'));
fclose(fid_bot);

fclose(fid_new);

return