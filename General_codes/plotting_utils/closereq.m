function closereq(fig)
%CLOSEREQ  Figure close request function.
%   CLOSEREQ deletes the current figure window.  By default, CLOSEREQ is
%   the CloseRequestFcn for new figures.
%   Copyright 1984-2012 The MathWorks, Inc.
%   Note that closereq now honors the user's ShowHiddenHandles setting
%   during figure deletion.  This means that deletion listeners and
%   DeleteFcns will now operate in an environment which is not guaranteed
%   to show hidden handles.
% 2017-04-27: CJF, modified to call savefigpos on close which in
% conjunction with figure_ and loadfigpos remembers figures positions.
if isavar('fig')&&isgraphics(fig)
    savefigpos(fig);
    delete(fig)
elseif isempty(gcbf)
    if length(dbstack) == 1
        warning(message('MATLAB:closereq:ObsoleteUsage'));
    end
    close('force');
else
    H = gcbf;
    savefigpos(H);
    delete(gcbf);
end

return