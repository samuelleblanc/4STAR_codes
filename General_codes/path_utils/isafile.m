function TF = isafile(in)
% Returns TRUE if the contents of "in" matches an existing filename
% Intended to replace exist(var,'file') usage since it doesn't compile

TF = false;
if isavar('in')
    if length(in)==1 && iscell(in) && ischar(in{1}); in = in{1};end
    in_ = which(in); if ~isempty(in_); in = in_; end
    out = dir(in);
    if ~isempty(out)
%%% 10-2020: KP commented this out and replaced it with just
%%% fileparts(in),filesep in the out assignment below, because out.folder
%%% didn't want to write after out had been defined by a dir command. This
%%% may be because 2013b is problematic, but now this works.
%         if ~isfield(out,'folder') 
%             out.folder = [fileparts(in),filesep];
%         end
        out = fullfile(fileparts(in),filesep, out.name);
        TF =  ~isadir(in)&&~isempty(out)&&~isempty(strfind(out,in));
    end
end
    %nested function isavar
    % This fast version of isavar benefit from knowing the input is a char
    function TF = isavar(var)
            TF = ~isempty(who(var));
    end
end