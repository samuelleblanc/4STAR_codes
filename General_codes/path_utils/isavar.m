function TF = isavar(var)
% TF = isavar(var)
% Returns True if char string in var is a variable in the caller workspace
% 'var' may be a single character array or a cell-array of char

TF = false;
if ~isempty(who('var'))
    if ischar(var)
        whovar = ['who(''',var, ''')'];
        TF = ~isempty(evalin('caller', whovar));
    elseif iscell(var)
        TF = false(size(var));
        for v = length(var):-1:1
            if ischar(var{v})
            whovar = ['who(''',var{v}, ''')'];
            TF(v) = ~isempty(evalin('caller', whovar));
            end
        end            
    end
end
return