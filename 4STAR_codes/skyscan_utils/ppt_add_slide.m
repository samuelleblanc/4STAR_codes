function ppt_add_slide(pptname, fig_out)

if ~isavar('pptname')
   pptname = getfullname('*.*','ppt_files');
end

h_ppt = actxserver('PowerPoint.Application');
% open an existing presentation file
if isafile(pptname)
   Presentation =h_ppt.Presentations.Open(pptname);
else
   Presentation = h_ppt.Presentation.Add;
end

blankSlide = Presentation.SlideMaster.CustomLayouts.Item(6); % 7 refers to the Office Theme in PowerPoint 2010 a blank slide with no textbox etc.
Slide_n = Presentation.Slides.AddSlide(Presentation.Slides.Count+1, blankSlide);
[~,tmp] = fileparts(fig_out);
Slide_n.Shapes.Title.TextFrame.TextRange.Text=tmp; 
Slide_n.Shapes.Title.TextFrame.TextRange.Font.Size = 22;
Slide_n.Shapes.AddPicture([fig_out,'.png'],'msoFalse','msoTrue',125,100,680,440);
Presentation.SaveAs(pptname);
Presentation.Close;
return