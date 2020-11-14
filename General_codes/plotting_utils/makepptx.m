function makepptx(pptfilename, titletext, varargin)

% MAKEPPT    Export images to PowerPoint using not the activex server, but
% rather xml building. Is OS independent.
% 
% makepptx(pptfilename, titletext, contents2, contents3, contents4, ...)
% generates a PowerPoint 2010 file and saves it under the file path
% specified by pptfilename (a string). The first slide will have the title
% text specified by titletext, unless the input variable is empty ('').
% contents#, each a cell containing file paths, will appear in the #-th
% slide.         
%
% Example (modify the file paths to existing ones)
%     [matfolder, figurefolder]=starpaths;
%     pptfilename=fullfile(matfolder, 'test2013JulyMLO.ppt');
%     contents2={fullfile(figurefolder, 'July2013MLO_ATT00001.jpg')};
%     contents3={fullfile(figurefolder, 'star20130706thru20130712rateratiotoAATSvm_aero354nmonly.png')
%     fullfile(figurefolder, 'star20130706thru20130712rateratiotoAATSvm_aero500nmonly.png')
%     fullfile(figurefolder, 'star20130706thru20130712rateratiotoAATSvm_aero1019nmonly.png')
%     fullfile(figurefolder, 'star20130706thru20130712rateratiotoAATSvm_aero1236nmonly.png')};
%     makeppt(pptfilename, 'July 2013 MLO trip', contents2, contents3);
%
% This code is designed for batch processing. For a one-time pasting of
% multiple images, open PowerPoint and go to Insert -> Photo Album. 
% 
% Yohei, 2013/07/23, inspired by pptwrite.m.
% Samuel, 2020/11/13, Modified from Yohei's makeppt, but converted to use exportToPPTX


%% Start new presentation
isOpen  = exportToPPTX();
if ~isempty(isOpen),
    % If PowerPoint already started, then close first and then open a new one
    exportToPPTX('close');
end

%% Set title and author
if nargin<2
    try
        titletext = ['Automated presentation created by ' get_starauthor ' on ' date];
    catch
        titletext = ['Automated presentation created on ' date];
    end
end

try 
    auth = get_starauthor;
catch
    auth = getenv('username');
end

% start a new presentation file
exportToPPTX('new','Dimensions',[9 6], ...
    'Title',titletext, ...
    'Author',auth, ...
    'Subject','', ...
    'Comments',['Generated on' datestr(now)]);

%SlideNum = exportToPPTX('addslide');

% generate slides
pixtoin = 0.01;
for i=nargin:-1:3;
    if ischar(varargin{i-2});
        varargin{i-2}={varargin{i-2}};
    end;
    n=numel((varargin{i-2}));
    if n==1;
        left=0; top=0; width=900; height=600;
        n=1;
    elseif n<=4;
        left=[0; 450; 0; 450]; top=[0;0;300;300]; width=450*ones(4,1); height=300*ones(4,1);
    else
        error('makepptx.m accepts up to 4 images per slide.');
    end;
    SlideNum = exportToPPTX('addslide');
    for j=1:n;
        file=varargin{i-2}{j};
        if exist(file)==2;
            if n==1;
                ImageNum = exportToPPTX('addpicture',file,'Scale','max');
            else
                ImageNum = exportToPPTX('addpicture',file,'Position',[left(j)*pixtoin, top(j)*pixtoin, width(j)*pixtoin, height(j)*pixtoin]);
            end
            %Image1 = Slide1.Shapes.AddPicture(file,'msoFalse','msoTrue',left(j), top(j), width(j), height(j));
        end;
    end;
end;

% create a title page
if ~isempty(titletext);
    exportToPPTX('addslide','Position',1);
    exportToPPTX('addtext',titletext, ...
                'Position',[1.5 2.5 6 1], ...
                'VerticalAlignment','middle', ...
                'HorizontalAlignment','center', ...
                'FontSize',30);
    exportToPPTX('addtext',['Auto created by ' auth ' on ' datestr(now) ], ...
                'Position',[1.5 3.2 6 1], ...
                'VerticalAlignment','bottom', ...
                'HorizontalAlignment','center', ...
                'FontSize',18);
end;

% save
[path,name,ext]=fileparts(pptfilename);
if exist(path)==7;
    if exist(pptfilename)==2;
        ButtonName=questdlg(['File ' name ext ' already exists.  Do you want to overwrite?'], ...
            'Overwriting', 'OK','Cancel','Save Both','OK');
        switch ButtonName,
            case 'Cancel',
                return;
            case 'Save Both'
                dd=dir(pptfilename);
                disp(['Renaming existing file ' name '_' datestr(datenum(dd.date),30) ext]);
                copyfile(pptfilename, fullfile(path,[name '_' datestr(datenum(dd.date),30) ext]));
        end % switch
    end;
    newFile = exportToPPTX('saveandclose',pptfilename);
    %Presentation.SaveAs(pptfilename);
elseif ~isequal(pptfilename, false);
    warning([pptfilename ' not saved.']);
end;

