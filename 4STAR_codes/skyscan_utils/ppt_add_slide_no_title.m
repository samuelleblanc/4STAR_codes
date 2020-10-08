function ppt_add_slide_no_title(pptname, fig_out)

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
if isempty(strfind(fig_out,'.png'))
    fig_out = [fig_out,'.png'];
end
blankSlide = Presentation.SlideMaster.CustomLayouts.Item(7); % 7 refers to the Office Theme in PowerPoint 2010 a blank slide with no textbox etc.
Slide_n = Presentation.Slides.AddSlide(Presentation.Slides.Count+1, blankSlide);
[~,tmp] = fileparts(fig_out);
Slide_n.Shapes.AddPicture(fig_out,'msoFalse','msoTrue',0,0,980,540);
Presentation.SaveAs(pptname);
Presentation.Close;
return