function flags = merge_flags(flags, flags_new)
% Combines an existing flags fields with flags_new.  Attempts to use and
% respect the flag_struct fields if they exist.
% If they don't by default flags indicate "bad"

% Assemble a list of flags (excluding struct fields)

if isfield(flags,'t') && isfield(flags_new, 't')
    [ainb, bina] = nearest(flags.t, flags_new.t);
end
%  create empty flags for new flag_names if they don't already exist
if isfield(flags_new,'flag_struct') && isfield(flags_new.flag_struct, 'flag_names')
    new_flag_names = flags_new.flag_struct.flag_names;
    for nm = length(new_flag_names):-1:1
        field = new_flag_names{nm};
        if ~isfield(flags, field)
            flags.(field) = [];
        end
        if ~isfield(flags_new, field)
            flags_new.(field) = [];
        end
    end
end

%screen out empty new flags
new_flag_names = fieldnames(flags_new)';
for nm = length(new_flag_names):-1:1
    field = new_flag_names{nm};
    if ~islogical(flags_new.(field))
        new_flag_names(nm) = [];
    end
end

% Now, for any non-empty new flags, copy them across if existing empty
% Or them if same length or if t exists in old and new

% Add in any field identified in flag_struct.flag_names
if isfield(flags_new,'flag_struct')
    %     new_flag_names = unique([new_flag_names,flags_new.flag_struct.flag_names],'stable');
    % and also combine flag_noted fields.
    if isfield(flags_new.flag_struct, 'flag_noted')
        if ~isfield(flags.flag_struct, 'flag_noted')
            flags.flag_struct.flag_noted = flags_new.flag_struct.flag_noted;
        else
            flags.flag_struct.flag_noted= unique([flags.flag_struct.flag_noted,flags_new.flag_struct.flag_noted],'stable');
        end
    end
end

% Now go through the list of new_flag_names that aren't empty.
for nm = length(new_flag_names):-1:1
    field = new_flag_names{nm};
    if isempty(flags.(field))
        flags.(field) = flags_new.(field);
    elseif length(flags.(field))==length(flags_new.(field))
        flags.(field) = flags.(field)|flags_new.(field);
    elseif isfield(flags,'t') && isfield(flags_new, 't')
        flags.(field)(ainb) = flags.(field)(ainb) | flags_new.(field)(bina);
    end
end

return