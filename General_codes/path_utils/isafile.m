function TF = isafile(in)
% Returns TRUE if the contents of "in" matches an existing filename
% Intended to replace exist(var,'file') usage since it doesn't compile
% Connor , v1.0, substitute for "isfile" which is now builtin but
% previously didn't exist.  Use "isafile" for back-compatibility
% Connor, v1.1, 2020/04/??, Added line 12 with "which" to capture full
% pathname of a file that exists in the matlab path but was not provided as
% full-path specified.  
% Connor, v1.2, 2020/05/03, Removed nexted function "isavar".  Caused
% problems with version_set to add a static field to function with a nexted
% function.  
% Connor, v1.3, 2020/06/03, Modified test of whether supplied name is found
% in reconstructed name to only test filename+ext.
version_set('1.2');

TF = false;
if isavar('in')
    if length(in)==1 && iscell(in) && ischar(in{1}); in = in{1};end
    in_ = which(in); if ~isempty(in_); in = in_; end
    out = dir(in);
    if ~isempty(out)
        if ~isfield(out,'folder')
            out.folder = [fileparts(in),filesep];
        end
        out = fullfile(out.folder, out.name);
        [~,in_,ex] = fileparts(in);in_ex = [in_ ex];
        TF =  ~isadir(in)&&~isempty(out)&&~isempty(strfind(out,in_ex));
    end
end
end
%     function TF = isavar(var)
%             TF = ~isempty(who(var));
%     end