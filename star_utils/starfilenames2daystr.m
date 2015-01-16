function [daystr, filen, datatype]=starfilenames2daystr(filenames, staysingle)

if nargin<2
    staysingle=1;
end;
daystr=[];
filen=[];
datatype={};
for i=1:length(filenames);
    filenames{i}(filenames{i}=='\' | filenames{i}=='/')=filesep; % let Mac run star.mat flies created on a PC.
    [folder0, file0, ext0]=fileparts(char(filenames(i)));
    if isequal(lower(ext0), '.mat') || (length(file0)>=14 && isequal(file0(9),'_') && isequal(file0(13),'_')); % look only at mat file or 4STAR-formatted files.
        daystr=[daystr; file0(1:8)];
        if ~isequal(lower(ext0), '.mat')
            filen=[filen; {file0(10:12)}];
            datatype=[datatype; {file0(14:end)}];
        end;
    end;
end;
if staysingle
    daystr=unique(daystr,'rows');
    if size(daystr,1)~=1; % if multiple dates are mixed, empty the daystr
        daystr=daystr[1];
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