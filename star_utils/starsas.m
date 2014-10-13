function starsas(filename, author)

% Stamps and saves the current figure under designated 4STAR figure paths.
% See also stamp.m and sas.m.
% Yohei, 2009/04/20, 2012/04/20

%!!!!!!!!!!!!!!!!!
% THIS CODE SAVES.
%!!!!!!!!!!!!!!!!!

% get directories
[matfolder, pngsavedir]=starpaths;
figsavedir=fullfile(pngsavedir, 'fig');
if ~exist(figsavedir);
    figsavedir=pngsavedir;
end;
pngsmallsavedir=fullfile(pngsavedir, 'small');
if ~exist(pngsmallsavedir);
    pngsmallsavedir='';
end;

% ask for input string for the stamp
if nargin<1
    % get the existing stamp string if any
    str0='.fig';
    gg=findobj(gcf, 'tag', 'stamp');
    if ~isempty(gg)
        chi=get(gg,'children');
        stampstr=get(chi, 'string');
        pathname=figsavedir; % not fileparts(get(gcf,'FileName'));
        clear gg chi commam;
    end;
else
    slam=findstr(filename, '\');
    if isempty(slam);
        slam=0;
    end;
    filepath0=filename(1:max(slam));
    if exist([figsavedir filepath0])==7;
        pathname=[figsavedir filepath0];
    else
        pathname=filepath0;
    end;
    stampstr=filename(max(slam)+1:end);
end;

% get the file name
fs=findstr(stampstr, '.fig');
if ~isempty(fs);
    figurename=stampstr(1:(fs-1));
    set(gcf, 'filename', figurename);
else
    errordlg('No figure saved.  The file name must contain ".fig".')
end;

% stamp
if nargin<2;
    try
        [~,~,~, author]=starpaths;
    catch;
        author='Yohei';
    end;
end;
stamp(stampstr, author);

% save
if exist(fullfile(pathname,[figurename '.fig']))==2;
    ButtonName=questdlg(['File ' figurename '.fig already exists.  Do you want to overwrite?'], ...
        'Overwriting', 'OK','Cancel','Save Both','OK');
    switch ButtonName,
        case 'Cancel', 
            return;
        case 'Save Both'
            dd=dir(fullfile(pathname,[figurename '.fig']));
            disp(['Renaming existing figure ' figurename '_' datestr(datenum(dd.date),30) '.fig']);
            copyfile(fullfile(pathname,[figurename '.fig']), fullfile(pathname,[figurename '_' datestr(datenum(dd.date),30) '.fig']));
            if exist(fullfile(pngsavedir,[figurename '.png']))==2
                copyfile(fullfile(pngsavedir,[figurename '.png']), fullfile(pngsavedir,[figurename '_' datestr(datenum(dd.date),30) '.png']));
            elseif exist(fullfile(pngsavedir,[figurename '.jpg']))==2
                ddj=dir(fullfile(pngsavedir,[figurename '.jpg']));
                if abs(datenum(ddj.date)-datenum(dd.date))<1/24;
                    copyfile(fullfile(pngsavedir,[figurename '.jpg']), fullfile(pngsavedir,[figurename '_' datestr(datenum(dd.date),30) '.jpg']));
                end;
            end;
    end % switch
end;
disp(['Saving ' figurename '.fig under ' pathname]);
saveas(gcf, fullfile(pathname, [figurename '.fig']), 'fig');
try
    saveas(gcf, fullfile(pngsavedir, [figurename '.png']), 'png');
catch; % patch figures do not seem to be converted to PNG.  try jpeg.
    saveas(gcf, fullfile(pngsavedir, [figurename '.jpg']), 'jpg');
end;
% make a smaller version
if exist(pngsmallsavedir)
    a=imread(fullfile(pngsavedir, [figurename '.png']), 'png');
    b=imresize(a,0.2);
    imwrite(b, fullfile(pngsmallsavedir, [figurename '.png']), 'png', 'XResolution',10000,'YResolution',10000);
end;