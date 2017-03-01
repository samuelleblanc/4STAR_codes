function prosas(project, filename, author)

% Stamps and saves the current figure.
% See also stamp.m and sas.m.
% Yohei, 2006-02-14

%!!!!!!!!!!!!!!!!!
% THIS CODE SAVES.
%!!!!!!!!!!!!!!!!!

% get the project prefix
prefix=project2prefix(project);

% set parameters
warning off;
if prefix=='IN';
    INparam;
else
    eval([prefix 'param('''');']);
end;
warning on;

% ask for input string for the stamp
if nargin<2
    % get the existing stamp string if any
    str0='.fig';
    gg=findobj(gcf, 'tag', 'stamp');
    if ~isempty(gg)
        chi=get(gg,'children');
        str0=get(chi, 'string');
        commam=findstr(str0, ',');
        if length(commam)>=2;
            str0=str0(1:(commam(end-1)-1));
        end;
        clear gg chi commam;
    end;
    cd0=cd;
    cd(figsavedir);
    [stampstr, pathname] = uiputfile({'*.fig';'*.*'}, 'Stamp for the current figure', str0);
    cd(cd0);
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
if nargin<3;
    stamp(stampstr); 
else
    stamp(stampstr, author); 
end;
% save
if exist(fullfile(pathname,[figurename '.fig']))==2;
    ButtonName=questdlg(['File ' figurename '.fig already exists.  Do you want to overwrite?'], ...
        'Overwriting', 'OK','Cancel','OK');
    switch ButtonName,
        case 'Cancel', 
            return;
    end % switch
end;
disp(['Saving ' figurename '.fig under ' pathname]);
saveas(gcf, fullfile(pathname, [figurename '.fig']), 'fig');
if datenum(now)-datenum([2007 12 31])>150 & datenum(now)-datenum([2007 12 31])<210; !!! I can't figure out why my Dell computer can't generate a png file for some matlab figures.
    d=dir(fullfile(pathname, [figurename '.fig']));
    if d.bytes>200000;
        disp('No PNG file generated.');
        return
    end;
end;
try
    saveas(gcf, fullfile(pngsavedir, [figurename '.png']), 'png');
catch; % patch figures do not seem to be converted to PNG.  try jpeg.
    saveas(gcf, fullfile(pngsavedir, [figurename '.jpg']), 'jpg');
end;
% make a smaller version
% set(gcf,'paperposition',get(gcf,'paperposition')/2);
% saveas(gcf, [pngsmallsavedir figurename '.png'], 'png', 'bitdepth',2);
method=2;
if method==1;
    a=imread(fullfile(pngsavedir, [figurename '.png']), 'png');  
    b=imresize(a,0.2);
    imwrite(b, fullfile(pngsmallsavedir, [figurename '.png']), 'png', 'XResolution',10000,'YResolution',10000);
elseif method==2;
    gg=get(gcf,'papersize');
    set(gcf,'papersize', gg/2);
    saveas(gcf,fullfile(pngsmallsavedir, [figurename '.png']), 'png');
    set(gcf,'papersize',gg);
    a=imread(fullfile(pngsmallsavedir, [figurename '.png']), 'png');  
    try
        b=imresize(a,0.2);
        imwrite(b, fullfile(pngsmallsavedir, [figurename '.png']), 'png', 'XResolution',10000,'YResolution',10000);
    end;
end;