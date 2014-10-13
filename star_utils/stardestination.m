function savematfile=stardestination(unconfirmed_savematfile)

% regulate destination for 4STAR codes including allstarmat.m.
% Yohei, 2012/04/11

if ~isstr(unconfirmed_savematfile);
    error('Destination must be given in a string.');
elseif size(unconfirmed_savematfile,1)~=1;
    error('One destination file must be given.');
end;
[folder0, file0, ext0]=fileparts(unconfirmed_savematfile);
if exist(folder0)==7; % looks like a full path is already given; do a minimum check and return the input
    if ~isequal(lower(ext0), '.mat');
        error('Destination must be a mat file.');
    else
        savematfile=unconfirmed_savematfile;
    end;
else; % ask for a full path
    if ~isempty(which('starpaths')); % look into pre-set path
        defaultsavefolder=starpaths;
        defaultsourcefolder=fullfile(defaultsavefolder, 'raw');
    else
        defaultsavefolder='';
    end;
    [savematfile, defaultsavefolder] = uiputfile(fullfile(defaultsavefolder, unconfirmed_savematfile), ...
        'Save file as');
    if ~isequal(savematfile,0);
        savematfile=fullfile(defaultsavefolder,savematfile);
    end;
end;