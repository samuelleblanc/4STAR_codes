function rows=incl(varargin)

% returns the index of data included in all specified bounds.
% rows=incl(vector1, bounds1, [vector2, bounds2, vector3, bounds3, ...])
% All vectors must have an identical number of rows. All bounds must
% have 2 elements.
% Yohei, 2010/02/02

for ii = 1:2:length(varargin)
    data = varargin{ii};
    bounds = varargin{ii+1};
    % regulate the input dimensions
    if ii==1;
        p=size(data,1);
    elseif size(data,1)~=p;
        error('All vectors must have an identical number of rows.');
    end;
    [pb,qb]=size(bounds);
    if qb~=2;
        error('bounds must have 2 columns');
    end;
    % select the rows with data values within in the bounds
    rows0=[];
    for bb=1:pb;
        if ~isempty(data);
            rows0=[rows0;find(data(:,1)>=bounds(bb,1) & data(:,end)<=bounds(bb,2))];
        end;
    end;
    if ii==1;
        rows=rows0;
    else
        rows=intersect(rows,rows0);
    end;
end
