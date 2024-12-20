function hh = yerrorbar2(axestype,xmin, xmax, ymin, ymax, x, y, l,u,symbol,teewidth,colorsym)
%   ERRORBAR Error bar plot.
%   ERRORBAR(X,Y,L,U) plots the graph of vector X vs. vector Y with
%   error bars specified by the vectors L and U.  L and U contain the
%   lower and upper error ranges for each point in Y.  Each error bar
%   is L(i) + U(i) long and is drawn a distance of U(i) above and L(i)
%   below the points in (X,Y).  The vectors X,Y,L and U must all be
%   the same length.  If X,Y,L and U are matrices then each column
%   produces a separate line.
%
%   ERRORBAR(X,Y,E) or ERRORBAR(Y,E) plots Y with error bars [Y-E Y+E].
%   ERRORBAR(...,'LineSpec') uses the color and linestyle specified by
%   the string 'LineSpec'.  See PLOT for possibilities.
%
%   H = ERRORBAR(...) returns a vector of line handles.
%
%   For example,
%      x = 1:10;
%      y = sin(x);
%      e = std(y)*ones(size(x));
%      errorbar(x,y,e)
%   draws symmetric error bars of unit standard deviation.

%   L. Shure 5-17-88, 10-1-91 B.A. Jones 4-5-93
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.14 $  $Date: 1997/12/02 19:47:51 $

global symbsize linethick

if isempty(teewidth)==1
   teewidth=0.015;
end

if min(size(x))==1,
  npt = length(x);
  x = x(:);
  y = y(:);
    if nargin > 6,
        if ~isstr(l),  
            l = l(:);
        end
        if nargin > 7
            if ~isstr(u)
                u = u(:);
            end
        end
    end
else
  [npt,n] = size(x);
end

if nargin == 8
    if ~isstr(l)  
        u = l;
        symbol = '-';
    else
        symbol = l;
        l = y;
        u = y;
        y = x;
        [m,n] = size(y);
        x(:) = (1:npt)'*ones(1,n);;
    end
end

if nargin == 9
    if isstr(u),    
        symbol = u;
        u = l;
    else
        symbol = '-';
    end
end


if nargin == 7
    l = y;
    u = y;
    y = x;
    [m,n] = size(y);
    x(:) = (1:npt)'*ones(1,n);;
    symbol = '-';
end

u = abs(u);
l = abs(l);
    
if isstr(x) | isstr(y) | isstr(u) | isstr(l)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) | ~isequal(size(x),size(l)) | ~isequal(size(x),size(u)),
  error('The sizes of X, Y, L and U must be the same.');
end

switch axestype
	case {'semilogy','linlin'}
      tee = teewidth*(xmax-xmin);  % make tee .015 x-distance for error bars
      xl = x - tee;
      xr = x + tee;
   case {'semilogx','loglog'}   
      tee = teewidth*log(xmax/xmin)/100;  % make tee .0075 log(x-distance) for error bars
      xl = x*10^-tee;
      xr = x*10^tee;
end

ytop = y + u;
ybot = y - l;
m = size(y,1);
for i = 1:m,
   if(ybot(i)<ymin) ybot(i)=ymin; end	%set lower limit to ymin, if necessary
   if(ytop(i)>ymax) ytop(i)=ymax; end	%set upper limit to ymax, if necessary
end
n = size(y,2);

% Plot graph and bars
hold_state = ishold;
cax = newplot;
next = lower(get(cax,'NextPlot'));

% build up nan-separated vector for bars
xb = zeros(npt*9,n);
xb(1:9:end,:) = x;
xb(2:9:end,:) = x;
xb(3:9:end,:) = NaN;
xb(4:9:end,:) = xl;
xb(5:9:end,:) = xr;
xb(6:9:end,:) = NaN;
xb(7:9:end,:) = xl;
xb(8:9:end,:) = xr;
xb(9:9:end,:) = NaN;

yb = zeros(npt*9,n);
yb(1:9:end,:) = ytop;
yb(2:9:end,:) = ybot;
yb(3:9:end,:) = NaN;
yb(4:9:end,:) = ytop;
yb(5:9:end,:) = ytop;
yb(6:9:end,:) = NaN;
yb(7:9:end,:) = ybot;
yb(8:9:end,:) = ybot;
yb(9:9:end,:) = NaN;

[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

h = plot(xb,yb,esymbol); hold on
h = [h;plot(x,y,symbol)]; 

if symbsize>0  set(h,'MarkerSize',symbsize); end;
if linethick>0 set(h,'LineWidth',linethick); end;
if nargin==12 set(h,'color',colorsym); end


if ~hold_state, hold off; end

if nargout>0, hh = h; end
