function TF = isafile(in)
% Returns TRUE if the contents of "in" matches an existing filename
% Intended to replace exist(var,'file') usage since it doesn't compile

TF = false;
if isavar('in')&&~isempty(in)
    out = dir(in);
    if ~isempty(out)
        if ~isfield(out,'folder')
            [out.folder,~,~] = fileparts(in);
        end
        out = fullfile(out.folder, out.name);
        TF =  ~isdir(in)&&~isempty(out)&&~isempty(strfind(out,in));
    end
end
    %nested function isvar
    function TF = isavar(var)
        TF = false;
        if ~isempty(who('var'))
            TF = ~isempty(who(var));
        end
    end
end