function TF = isafile(in)
% Returns TRUE if the contents of "in" matches an existing filename
% Intended to replace exist(var,'file') usage since it doesn't compile

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
        TF =  ~isadir(in)&&~isempty(out)&&~isempty(strfind(out,in));
    end
end
    %nested function isavar
    % This fast version of isavar benefit from knowing the input is a char
    function TF = isavar(var)
            TF = ~isempty(who(var));
    end
end