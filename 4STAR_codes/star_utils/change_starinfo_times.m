function change_starinfo_times(starinfo_in,starinfo_out,time_start,time_end,force_overwrite);
%% PURPOSE:
%   Edit starinfo file such that it has start and end times in the  
%
% INPUT:
%  - starinfo_in: path of starinfo file to read from
%  - starinfo_out: path of starinfo file to write to (new file)
%  - time_start: datetime object for when to write out the start
%  - time_end: datetime object for when to write out the end
%  - force_overwrite: boolean, if force_overwrite is set, then will ignore existing file
% 
% OUTPUT:
%  - starinfo_out file, with modified start and end times
%
% DEPENDENCIES:
%  version_set.m : to have version control of this m-script
%
% NEEDED FILES:
%  - starinfo_in
%  
%
% EXAMPLE:
%  ....
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2017-10-20
% Modified (v1.1): Samuel LeBlanc, Santa Cruz, CA, 2020-09-21
%                  Changed pathing to use the getnamedpath starsun and
%                  starfig
%                  Added return of figure path files
% -------------------------------------------------------------------------
version_set('v1.1');

%% start of function
fidi=fopen(starinfo_in,'r');
if nargin <5
   force_overwrite = false; 
end
if exist(starinfo_out) & ~force_overwrite
    error(['File : ' starinfo_out ' Already exists'])
end
fido=fopen(starinfo_out,'w');
lines = {};
changed = false;
datenum_str_start = datestr(time_start,'yyyy,dd,mm,HH,MM,SS');
datenum_str_end = datestr(time_end,'yyyy,dd,mm,HH,MM,SS');
while ~feof(fidi)
  l=fgetl(fidi);   % read line
  if strfind(l,'s.ground') & ~startsWith(strtrim(l),'%')
    % modify line here
    l = ['s.ground = [datenum(' datenum_str_start ') datenum(' datenum_str_end ')];'];
    changed = true;
  end
  if strfind(l,'s.flight') & ~startsWith(strtrim(l),'%')
    % modify line here
    l = ['s.flight = [datenum(' datenum_str_start ') datenum(' datenum_str_end ')];'];
    changed = true;
  end
  if strfind(l, 's.langley1') & ~startsWith(strtrim(l),'%')
    % modifiy any langley values
    l = ['s.langley1 = [datenum(' datenum_str_start ') datenum(' datenum_str_end ')];'];
    changed = true;
  end
  lines = [lines; l];
%  fprintf(fido,'%s',l)  % 'fgetl returns \n so it's embedded
end

for i=1:length(lines)
    if ~changed & i>26
       l = ['s.ground = [datenum(' datenum_str_start ') datenum(' datenum_str_end ')];'];
       fprintf(fido,'%s',l);
       changed = true;
    end
    fprintf(fido,'%s\n',lines{i});
end
fidi=fclose(fidi);
fido=fclose(fido);

return
