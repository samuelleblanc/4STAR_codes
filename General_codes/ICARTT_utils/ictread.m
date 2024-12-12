function out=ictread(filename, adj_lines, delimiter)

% Reads an ICT data file.
% File format is based on ICARTT Data Management Implementation Plan
% (http://www-air.larc.nasa.gov/missions/intexna/DataManagement_plan.htm).
% 2010/02/01, changed the name from nasaread.m.
% 2008/10/31, "adj_lines" added as the second variable. This optional
% parameter, a 1x3 vector, adds the specified numbers to headerlines,
% number_of_special_comment_lines and number_of_normal_comment_lines.
% Yohei, 2004-06-07

% apply tweaks that should not be necessary if the file format is in accordance
% with the ICARTT Data Management Implementation Plan
if nargin<2 || isempty(adj_lines);
    adj_lines=[0 0 0];
    if nargin<1;
        [filename, pathname] = uigetfile({'*.*'},'Pick a submission file');
        filename=fullfile(pathname, filename);
    end;
end;
if nargin<3
    delimiter=' \t';
    delimiter=', '; % 2013/08/07 just noticed the ICARTT format now mandates delimiting with comma.
end;
% open the file
fid=fopen(filename);
% get the filename
out.misc.filename=filename;
% get the header information
l=fgetl(fid);
[out.misc.headerlines, out.misc.fileformatindex] = strread(l, '%n, %n', 'delimiter', ' '); % 2013/08/07 
out.misc.headerlines=out.misc.headerlines+adj_lines(1); 
if out.misc.fileformatindex~=1001 & out.misc.fileformatindex~=2310;
    error('ictread.m cannot read data with file format index other than 1001 and 2310.');
end;
out.misc.piname=fgetl(fid);
out.misc.organization=fgetl(fid);
out.misc.datasource=fgetl(fid);
out.misc.mission=fgetl(fid);
l=fgetl(fid);
[out.misc.filevolume, out.misc.number_of_file_volumes] = strread(l, '%n, %n', 'delimiter', ' ');
if out.misc.number_of_file_volumes~=1;
    disp(['This is Volume ' out.misc.filevolume ' of ' out.misc.number_of_file_volumes ' files.']);
end;
l=fgetl(fid);
% d=strread(l, '', 'delimiter', delimiter);
[yyyy1, mm1, dd1, yyyy2, mm2, dd2] =strread(l, '%u, %u, %u, %u, %u, %u');
out.misc.date_when_data_begin=datestr(datenum([yyyy1 mm1 dd1 0 0 0]), 29);
out.year=str2num_nocomm(out.misc.date_when_data_begin(1:4));
out.misc.date_when_data_begin(findstr(out.misc.date_when_data_begin, '-'))=' ';
out.misc.date_of_data_reduction_or_revision=datestr(datenum([yyyy1 mm1 dd1 0 0 0]), 29);
out.misc.date_of_data_reduction_or_revision(findstr(out.misc.date_of_data_reduction_or_revision, '-'))=' ';
clear d;
out.misc.datainterval=str2num_nocomm(fgetl(fid));
if out.misc.datainterval~=0;
    disp(['Time interval is ' num2str(out.misc.datainterval) ' second(s).']);
end;
out.misc.independent_variable=fgetl(fid);
out.misc.number_of_variables=str2num_nocomm(fgetl(fid));
out.misc.scale_factors=str2num_nocomm(fgetl(fid));
if any(out.misc.scale_factors-1);
    warning('Scale factor is not 1 for some/all of the data.');
end;
out.misc.missing_data_indicator=[];   
while length(out.misc.missing_data_indicator)<out.misc.number_of_variables
    out.misc.missing_data_indicator=[out.misc.missing_data_indicator str2num_nocomm(fgetl(fid))];
end;
for i=1:out.misc.number_of_variables
    out.misc.variable_names(i)={fgetl(fid)};
end;
out.misc.number_of_special_comment_lines=str2num_nocomm(fgetl(fid));
out.misc.number_of_special_comment_lines=out.misc.number_of_special_comment_lines+adj_lines(2);
out.misc.special_comments={};
for i=1:out.misc.number_of_special_comment_lines;
    out.misc.special_comments(i)={fgetl(fid)};
end;
out.misc.number_of_normal_comment_lines=str2num_nocomm(fgetl(fid));
out.misc.number_of_normal_comment_lines=out.misc.number_of_normal_comment_lines+adj_lines(3);
out.misc.normal_comments={};
out.misc.ulod_flag=NaN;
out.misc.llod_flag=NaN;
for i=1:out.misc.number_of_normal_comment_lines;
    l=fgetl(fid);
    out.misc.normal_comments(i)={l};
    if length(l)>=9;
        if strcmpi(l(1:9), 'ulod_flag')
            out.misc.ulod_flag=str2num_nocomm(l(12:end));
            if all(out.misc.ulod_flag==-7777); 
                out.misc.ulod_flag=-7777;
            end;
        elseif strcmpi(l(1:9), 'llod_flag')
            out.misc.llod_flag=str2num_nocomm(l(12:end));
            if all(out.misc.llod_flag==-8888)
                out.misc.llod_flag=-8888;
            end;
        end;
    end;
end;
% get the data
if out.misc.fileformatindex==2310; 
    disp('The fileformat 2310 is not supported by ictread.m.');
elseif out.misc.fileformatindex~=1001;
    disp('The fileformat must be 1001 or 2310.');
end;

data=dlmread(filename, delimiter(1), out.misc.headerlines, 0);
if size(data,2) ~= out.misc.number_of_variables+1 & size(data,2) ~= out.misc.number_of_variables+2; % the number of rows should be the same as the number of variables plus 1 or 2. If not, more than a space may be placed between numbers. If so, read the data with textread.m.
    data=textread(filename, '', 'headerlines', out.misc.headerlines,'delimiter',delimiter);
end;
for i=1:out.misc.number_of_variables+1
    fmt=[repmat('%*s', 1, i-1) '%s' repmat('%*s',1, out.misc.number_of_variables+1-i) '%*[^\n]'];
%     fmt=fmt(1:end-2);
    if ~isempty(data);
        data1=data(:,i);
    else;
        data1=[];
    end
    if i==1;
        doy=datenum([str2num_nocomm(out.misc.date_when_data_begin(1:4)) str2num_nocomm(out.misc.date_when_data_begin(6:7)) str2num_nocomm(out.misc.date_when_data_begin(9:10))]);
        doy=doy-datenum([str2num_nocomm(out.misc.date_when_data_begin(1:4))-1 12 31 0 0 0]);
        out.t=doy+data1/86400;
        firstdata=data1;
    elseif i>1;
        data1(find(data1==out.misc.missing_data_indicator(i-1) ...
            | data1==out.misc.ulod_flag | data1==out.misc.llod_flag))=NaN;
    end;
    if i==2;
        seconddata=data1;
    end;
    if i==3;
        if max(abs(data1-(firstdata+seconddata)/2))<=1;
            out.t=doy+data1/86400; % mid-time given; set this as "t".
        end;
    end;
    colname='';
    if ~isequal(l, -1);
        colname=strread(l, fmt, 'delimiter',', \t');
    end;
    if isempty(colname)
        try
            if i==1;
                colname={char(out.misc.independent_variable)};
            else
                colname={char(out.misc.variable_names(i-1))};
            end;
        catch;
            colname={['datafield' num2str(i)]};
        end;
    end;
    fieldname=char(colname(1));
    fieldname=fieldname(regexp(fieldname, '\w'));
    if regexp(fieldname(1), '[_0-9]'); % the first character is a number, which is not acceptable for a field name
        fieldname=['c' fieldname]; % add a character "c".  it does not have to be "c", though.
    end;
    out.(fieldname)=data1;
end;
fclose(fid);
out=orderfields(out, [3:length(fieldnames(out)) 2 1]);
out.note=['Data taken from ' filename ' using ictread.m on ' datestr(now,31) '.  The header lines are given in the "misc" field.'];


function sout = str2num_nocomm(s)
ss = split(s,';');
sout = str2num(ss{1});