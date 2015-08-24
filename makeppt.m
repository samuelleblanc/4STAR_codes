function makeppt(pptfilename, titletext, varargin)

% MAKEPPT    Export images to PowerPoint.
% 
% makeppt(pptfilename, titletext, contents2, contents3, contents4, ...)
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

h = actxserver('PowerPoint.Application');

% start a new presentation file
Presentation = h.Presentation.Add;
blankSlide = Presentation.SlideMaster.CustomLayouts.Item(7); % 7 refers to the Office Theme in PowerPoint 2010 a blank slide with no textbox etc.

% generate slides
for i=nargin:-1:3;
    if ischar(varargin{i-2});
        varargin{i-2}={varargin{i-2}};
    end;
    n=numel((varargin{i-2}));
    if n==1;
        left=0; top=0; width=720; height=540;
        n=1;
    elseif n<=4;
        left=[0; 360; 0; 360]; top=[0;0;270;270]; width=360*ones(4,1); height=270*ones(4,1);
    else
        error('makeppt.m accepts up to 4 images per slide.');
    end;
    Slide1 = Presentation.Slides.AddSlide(1, blankSlide);
    for j=1:n;
        file=varargin{i-2}{j};
        if exist(file)==2;
            Image1 = Slide1.Shapes.AddPicture(file,'msoFalse','msoTrue',left(j), top(j), width(j), height(j));
        end;
    end;
end;

% create a title page
if ~isempty(titletext);
    blankSlide = Presentation.SlideMaster.CustomLayouts.Item(1); % 1 refers to the Office Theme in PowerPoint 2010 a blank slide with two textboxs
    Slide1 = Presentation.Slides.AddSlide(1, blankSlide);
    Slide1.Shapes.Title.TextFrame.TextRange.Text = titletext;
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
    Presentation.SaveAs(pptfilename);
elseif ~isequal(pptfilename, false);
    warning([pptfilename ' not saved.']);
end;

% Terminate the server session to which the handle is atttached
% h.Quit;

% Release all interfaces derived from the server
h.delete;

