function dateticky(varargin)

% Put date formatted tick labels, in a way Yohei likes.
% Yohei, 2013/02/19

pos=get(gcf,'position');
set(gcf,'position',[1 53 1280 590]); % expand the figure before placing the ticks
datetick(varargin{:});
set(gcf,'position',pos);
