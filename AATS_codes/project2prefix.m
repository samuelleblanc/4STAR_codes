function prefix=project2prefix(project)

% Yohei, 2005-11-13
% Return prefix for the project.

switch lower(project);
    case {'in' 'intex-na' 'intex-a' 'intexa' '2004'}
        prefix='IN';
    case {'mi' 'mirage' 'milagro' 'mexico' 'mex'}
        prefix='MI';
    case {'ib' 'intex-b' 'intex-b1' 'intexb'}
        prefix='IB';
    case {'ip' 'impex' 'impex-c130'}
        prefix='IP';
    case {'as' 'arctas' 'arctas-p3b'}
        prefix='AS';
    case {'aa' 'aceasia' 'ace-asia'}
        prefix='AA';
    case {'ps' 'pase'}
        prefix='PS';
    case {'a2' 'ace2'}
        prefix='A2';
end;
