function [daystr, filen, datatype, instrumentname]=starfilenames2daystr(filenames, staysingle)

% Function to grab the day string from the filename. 
% Also grabs the file number, the datatype, the instrument name from the
% filename. Works for files spanning more than one day. 
%
%
% SL, v1.1, 2018-08-23, added the ability to use the new filename system which
% returns the instrument name and the version_set tracking
version_set('1.1')
if nargin<2
    staysingle=1;
end;
daystr=[];
filen=[];
datatype={};
instrumentname={};
for i=1:length(filenames);
    filenames{i}(filenames{i}=='\' | filenames{i}=='/')=filesep; % let Mac run star.mat flies created on a PC.
    [folder0, file0, ext0]=fileparts(char(filenames(i)));
    file0str = strsplit(file0,'_');
    if (isequal(lower(ext0), '.mat') && all(isstrprop(file0(1:8),'digit'))) || (length(file0)>=14 && isequal(file0(9),'_') && isequal(file0(13),'_')); % look only at mat file or old 4STAR-formatted files.
        daystr=[daystr; file0(1:8)];
        if ~isequal(lower(ext0), '.mat')
            filen=[filen; {file0(10:12)}];
            datatype=[datatype; {file0(14:end)}];
        end;
        instrumentname = [instrumentname; '4STAR'];
    elseif isequal(datestr(datenum(file0str{2},'yyyymmdd'),'yyyymmdd'),file0str{2});
        daystr = [daystr; file0str{2}];
        if ~isequal(lower(ext0), '.mat')
            filen=[filen; {file0str{3}}];
            if length(file0str)>4;
                datatype=[datatype; {[file0str{4} '_' file0str{5}]}];
            else;
                datatype=[datatype; {file0str{4}}];
            end;
        end;        
        instrumentname = [instrumentname; file0str{1}];
    elseif isequal(lower(ext0), '.mat'); %new mat file type
        daystr = [daystr; file0str{2}(1:8)];  
        instrumentname = [instrumentname; file0str{1}];        
    end;
end;

if length(unique(instrumentname))>1;
   error('The input files are from different instruments'); 
else;
    instrumentname = unique(instrumentname);
    try;
        instrumentname = instrumentname{1};
    catch;
        error('Cant subset the instrument name, possibly no file available')
    end;
end;

if staysingle
    daystr=unique(daystr,'rows');
    if size(daystr,1)~=1; % if multiple dates are mixed, empty the daystr
        daystr=daystr(1,:);
        disp('multiple days are combined, returning first day string')
    end;
    filen=char(unique(filen));
    if size(filen,1)~=1; % if multiple file numbers are mixed, empty the daystr
        filen=[];
    end;
    ud=unique(datatype);
    if numel(ud)==2 && ~isempty(strmatch('VIS', upper(ud))) &&  ~isempty(strmatch('NIR', upper(ud)));
        ud=unique([{ud{1}(5:end)};{ud{2}(5:end)}]);
    end;
    datatype=char(ud);
    if size(datatype,1)~=1; % if multiple datatypes are mixed, empty the daystr
        datatype=[];
    end;
end;