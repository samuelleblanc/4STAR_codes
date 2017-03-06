function [filenames, ext, daystr, filen,instrumentname]=starsource(source, datatype)

% regulate source input for 4STAR codes including allstarmat.m.
% Yohei, 2012/04/11
% CJF: 2012/10/05, modified to output filen for use when datetype has "sky"
% regulate input and output of this code
% SL, v1.2, 2016/08/23, added instrument name to outputs and version_set to
% this file

version_set('1.2')
if nargin<1
    source='ask';
elseif isempty(source)
    source='ask';
end;
if nargin<2
    datatype='';
elseif isempty(datatype)
    datatype='';
end;
ext='';
daystr='';
filen=[];

% ask for source file(s), if requested or if source is not specified
if isequal(lower(source), 'ask');
    % prepare to ask
    % CJF: modified to include datatype in filespec mask
    filespec={['*',datatype,'*.*'],  'All Files (*.*), select one or more with a common ext.';
        '*.dat', 'dat files(*.dat), select one or more';
        '*.mat', 'mat files(*.mat), select one'};
    % Yohei: removed datatype screening so that, for example, starsun can select dat star.mat file as input.
    filespec={'*.*',  'All Files (*.*), select one or more with a common ext.';
        '*.dat', 'dat files(*.dat), select one or more';
        '*.mat', 'mat files(*.mat), select one'};
    multiselect='on';
    if isequal(lower(datatype), '.dat')
        filespec=filespec(2,:);
    elseif isequal(lower(datatype), '.mat')
        filespec=filespec(3,:);
        multiselect='off';
    end;
    if ~isempty(which('starpaths')); % look into pre-set path
        s=pwd;
        [defaultsourcefolder, figurefolder, askforsourcefolder]=starpaths;
        if exist(fullfile(defaultsourcefolder, 'raw'))==7;
            defaultsourcefolder=fullfile(defaultsourcefolder, 'raw');
            cd(defaultsourcefolder);
        elseif exist(defaultsourcefolder);
            cd(defaultsourcefolder);
        end;
    end;
    % ask now
    filenames={};
    if askforsourcefolder
       sourcefolder = getnamedpath('4STAR_raw_data','4STAR raw data');
%         sourcefolder = uigetdir(defaultsourcefolder, 'Pick a source directory (or cancel to pick files).');
        if ~isequal(sourcefolder,0);
            filenames0=struct2cell(dir(sourcefolder));
            for i=1:size(filenames0,2);
                cf=char(filenames0(1,i));
                [path0,name0,ext0]=fileparts(cf);
                if isequal('.dat',ext0); % select dat files only
                    filenames=[filenames; filenames0(1,i)];
                elseif length(cf)>2
                    warning(['Unable to read ' cf '.']);
                end;
            end;
            clear filenames0 path0 name0 ext0;
            if isempty(filenames)
                warning(['No dat files exist in ' sourcefolder '.']);
                return;
            end;
        end;
    end;
    if isempty(filenames)
        [filenames, sourcefolder] = uigetfile2(filespec, ...
            'Pick file(s)', 'multiselect',multiselect);
    end;
    if isequal(filenames,0);
        filenames={};
        return;
    elseif isstr(filenames) & size(filenames,1)==1;
        filenames={filenames};
    end;
    clear source
    for i=1:numel(filenames);
        source{i}=fullfile(sourcefolder, char(filenames(i)));
    end;
    clear i sourcefolder;
    if ~isempty(which('starpaths'));
        cd(s);
        clear defaultsourcefolder s
    end;
end;

% check the source file(s)
if isstr(source);
    for i=1:size(source,1);
        source1(i)={source(i,:)};
    end;
    source=source1;
    clear i source1
end;
filenames={};
for i=1:numel(source);
    [folder0, file0, ext0]=fileparts(char(source(i)));
    if exist(char(source(i)))~=2;
        error([char(source(i)) ' does not exist.']);
    elseif isempty(ext);
        sourcefolder=folder0;
        ext=ext0;
    elseif ~isequal(ext0, ext)
        error('Files with a single extension please.');
    elseif isequal(lower(ext0), '.mat') & ~isempty(filenames)
        error('A mat file must be selected singly without other file(s).');
    end
    if ~isequal(lower(ext), '.mat') && ~isempty(datatype) && isempty(findstr(lower([file0 ext0]),lower(datatype)))
        warning([file0 ext0 ' does not have "' datatype '" in the file name. Ignored.']);
    else 
        filenames=[filenames; {fullfile(folder0,[file0 ext0])}];
    end;
end;
%cjf include filen in output
[daystr,filen,nul,instrumentname]=starfilenames2daystr(filenames,1); % attempt to get the day string from the individual file names.
clear source folder0 file0 ext0 i;
return