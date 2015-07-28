function V = ICARTTreader(ICTname)
% function V = ICARTTreader(ICTname)
% Parses an ICARTT-formatted file (.ict) into matlab variables.
%
% INPUTS:
% ICTname: name of .ict file to parse, INCLUDING extension.
%
% OUTPUTS:
% V: a structure containing all variables and the header info.
%    Use struct2var to put these variables into your workspace, if desired.
%
% 20130424 GMW

%%%%%OPEN FILE%%%%%
[fid,message] = fopen(ICTname);
if fid==-1
    error(message)
end

%%%%%GRAB HEADER%%%%%
numlines=fscanf(fid,'%f',1);
frewind(fid);
header = cell(numlines,1);
for i=1:numlines
    header{i} = fgetl(fid);
end
numvar = str2num(header{10})+1; %number of variables, including independent variable

%%%%%GRAB DATA, CLOSE FILE%%%%%
fstr = repmat('%f, ',1,numvar); %format string
fstr = fstr(1:end-2);
data=fscanf(fid,fstr,[numvar,inf]);
data=data';
[nrow,ncol] = size(data);

status = fclose(fid);
if status
    disp('Problem closing file.');
end

%%%%%PARSE HEADER%%%%%
scale = [1 str2num(header{11})]; %scaling factors
miss  = str2num(header{12}); %missing data indicators
miss = [-9999 miss]; %extend for independent variable
miss = repmat(miss,nrow,1);

i = strmatch('LLOD_FLAG',header); %lower detection limit
if ~isempty(i)
    llod = str2num(header{i}(12:end));
end

i = strmatch('ULOD_FLAG',header); %upper detection limit
if ~isempty(i)
    ulod = str2num(header{i}(12:end));
end

varnames = cell(numvar,1); %variable names
left = header{end};
for i=1:numvar
    [var,left] = strtok(left,', ');
    j = var=='(' | var==')' | var==' ' | var=='/' | var=='\' | var=='-' | var==','; %bad characters
    var(j)=[];
    varnames{i} = strrep(var,'.','_');
end

%%%%%PARSE DATA%%%%%
data(data==miss | data==llod | data==ulod) = NaN; %replace bad data
data = data.*repmat(scale,size(data,1),1); %scale

V.header = header;
for i=1:numvar
    V.(varnames{i}) = data(:,i);
end


