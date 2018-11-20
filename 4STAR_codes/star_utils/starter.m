function s=starter(file)

% read a raw 4STAR file
% 
% For all files but "track", the raw file must have comment lines each
% starting with "%", a line filled with as many labels as the data columns,
% before the data. The first 7 columns of data are year, month, day, hour,
% minute, second, milisecond. The last columns labeled Pix# are the
% spectra.
% 
% Yohei, 2011/10/24, 2013/02/22, 2013/06/14
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set 
% Connor, v1.1, 2017/08/23, added code to insert spaces with negative signs 
%         and to catch zero-length or malformed spectra

version_set('1.1');

% control the input
if nargin<1;
    [filename,pathstr]=uigetfile({'*.dat','(*.dat)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Pick a file', '');
    file=fullfile(pathstr,filename);
else
    if iscell(file)
        file=char(file);
    end;
    if ~exist(file);
        error([file ' does not exist.']);
    end;
end;
[pathstr, filename]=fileparts(file);

% tell the type type
%type=lower(filename(14:end));

% read the file
if length(findstr(lower(filename),'track'))>0; %isequal(type, 'track'); % track file
    s = rd_tracking(file); % Connor's code
    s.t=s.time; % for consistency in nomenclature
else % all other types
    s.t=[];
    s.raw=[];
    fid = fopen(file,'r');
    tmp = fgetl(fid);
    tmpnext = fgetl(fid); % Yohei, 2013/02/22
    tmpnextnext = fgetl(fid); % Yohei, 2013/08/15, now accept up to two irregular lines
    i = 1;
    validheader=[]; % Yohei, 2013/02/22, an (imperfect) fix for irregular header lines
    while (~isempty(tmp) && isequal(tmp(1),'%')) || (~isempty(tmpnext) && isequal(tmpnext(1),'%')) || (~isempty(tmpnextnext) && isequal(tmpnextnext(1),'%')); % a fix for header file irregularity. before the fix this if-clause was as simple as findstr(tmp, '%'). Yohei, 2013/02/22.
        if isempty(tmp) || ~isequal(tmp(1),'%'); % a fix for irregular header. Yohei, 2013/02/22.
            header{validheader(end)}=[header{validheader(end)} ' ' tmp];
        else
            header{i} = tmp;
            validheader=[validheader;i];
        end
        i = i+1;
        tmp = tmpnext;
        tmpnext=tmpnextnext;
        tmpnextnext = fgetl(fid);
    end;
    header=header(validheader); % end of reading irregular lines Yohei, 2013/02/22.
    clear validheader
    row_labels = tmp;
    fseek(fid,0,-1);
    file = [file, '_'];fid_ = fopen(file,'w');
    while ~feof(fid)
       blah = fgetl(fid); blah = strrep(blah,'-',' -');
        fprintf(fid_,'%s \n',blah);
    end
    fclose(fid);
    fclose(fid_);    
    % read data
%     vals = textscan(file,'headerlines',i, 'commentstyle','matlab');
    vals=textread(file, '', 'headerlines',i, 'commentstyle','matlab');
    if ~isempty(vals);
        s.t=datenum([vals(:,1:5) vals(:,6)+vals(:,7)/1000]); % the first 7 columns have the time
        c=8; % read the 8th column
        label=char(strread(row_labels, [repmat('%*s',1,c-1) '%s%*[^\n]']));
        while ~strcmp(lower(label), 'pix0'); % keep reading the new column until hitting the label "Pix0".
            s.(label) = vals(:,c); %eval(['s.' label '=vals(:,c);']);
            c=c+1;
            label=char(strread(row_labels, [repmat('%*s',1,c-1) '%s%*[^\n]']));
        end;
        while all(vals(:,end)==0)
           vals(:,end) = [];
        end
        if size(vals,2)>(c+1)
            s.raw=vals(:,c:end); % read all the rest, presumably the raw counts
        else; % no spectrometer data, for example 20120722_001_VIS_SUN.dat.
            s.raw=[];
        end;
    end;
    s.header=header;
    s.row_labels={row_labels};
   if exist(file,'file')&&exist(file(1:end-1),'file')
      delete(file);
      disp(['Removed temprorary copy of ',file(1:end-1)])
   end
end;
