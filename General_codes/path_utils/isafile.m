function TF = isafile(in,wild)
% TF = isafile(in,wild)
% Returns TRUE if the contents of "in" matches a unique existing filename
% Intended to replace exist(var,'file') usage since it doesn't compile
% One difference between isafile and isfile: isafile will expand a wildcard
% such that if the wildcard matches one and only one file it will register
% as "true" for isafile but "false" for isfile.
% Connor , v1.0, substitute for "isfile" which is now builtin but
% previously didn't exist.  Use "isafile" for back-compatibility
% Connor, v1.1, 2020/04/??, Added line 12 with "which" to capture full
% pathname of a file that exists in the matlab path but was not provided as
% full-path specified.
% Connor, v1.2, 2020/05/03, Removed nested function "isavar".  Caused
% problems with version_set to add a static field to function with a nested
% function.
% Connor, v1.3, 2020/06/03, Modified test of whether supplied name is found
% in reconstructed name to only test filename+ext.
% Connor, v1.4, 2020/06/03, Fixed error in numels mismatch with out.folder
% by not using out.folder
% Connor, v1.5, 2020/10/15, Modified logic to reflect successful fopen
version_set('1.5');

TF = false;
if isavar('in')&&~isadir(in)
    if length(in)==1 && iscell(in) && ischar(in{1}); in = in{1};end
    in_ = which(in); if ~isempty(in_); in = in_; end
    fid = fopen(in,'r+');
    if fid>0
        fclose(fid);
        TF = true;
    end
    
    % This block of code (now commented) recognizes a wildcard that
    % matches one unique file as a file.
    if isavar('wild')&&~(islogical(wild)&&~wild)
        
        out = dir(in);
        if ~isempty(out)&&length(out)==1
            %         if ~isfield(out,'folder')
            %             out.folder = [fileparts(in),filesep]*ones;
            %         end
            out = fullfile(fileparts(in),filesep, out.name);
            fid = fopen(out,'r+');
            fclose(fid);
            TF =  fid>0;
        end
    end
end
end
%     function TF = isavar(var)
%             TF = ~isempty(who(var));
%     end