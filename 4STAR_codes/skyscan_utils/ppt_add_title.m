function pptname = ppt_add_title(pptname, titlestr)

h_ppt = actxserver('PowerPoint.Application');
% open an existing presentation file
if ~isavar('pptname')
   pptname = getfullname('*.*','ppt_files');
end
if isafile(pptname)
   Presentation =h_ppt.Presentations.Open(pptname);
else
   Presentation = h_ppt.Presentation.Add;
end
if ~isavar('titlestr')
   titlestr = 'Hey, title me!';
end

if ~isempty(titlestr);
    blankSlide = Presentation.SlideMaster.CustomLayouts.Item(1); % 1 refers to the Office Theme in PowerPoint 2010 a blank slide with two textboxs
    Slide1 = Presentation.Slides.AddSlide(Presentation.Slides.Count+1, blankSlide);
    Slide1.Shapes.Title.TextFrame.TextRange.Text=titlestr;    
end;

Presentation.SaveAs(pptname);
Presentation.Close;
return