function file=starfinder(filetype, source)

if nargin<2;
    cd0=cd;
    cd(starpaths(source));
    [filename,pathname]=uigetfile(...
        {['*' filetype '.mat'], [filetype ' File (*' filetype ',mat)']; ...
        '*.mat', 'MATLAB File (*.mat)'; ...
        '*.*', 'All Files (*.*)'}, ...
        'Pick a file');
    cd(cd0);
    if isequal(filename,0)
        file='';
        return;
    end;
    file=fullfile(pathname,filename);
elseif exist(source)==2
    file=source;
elseif exist(fullfile(starpaths(source), [source filetype '.mat']))==2;
    file=fullfile(starpaths(source), [source filetype '.mat']);
elseif exist(fullfile(starpaths(source), [source '.mat']))==2;
    file=fullfile(starpaths(source), [source '.mat']);
elseif exist(fullfile(starpaths(source), source))==2;
    file=fullfile(starpaths(source), source);
else
    disp('Did not find the filetype: ' filetype ' for day: ' source)
    try
      [fna pna]=uigetfile(['*' filetype '*.mat'],['Searching for day: ' source],starpaths);
      file=[pna fna];
    catch
      error([source ' does not exist.']);
    end
end
if numel(file)<numel(filetype)+4 || ~isequal(lower(file(end-numel(filetype)-3:end)), [filetype '.mat']);
    error([file ' does not seem to be a ' filetype ' file.']);
end;