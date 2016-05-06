function h = scatter2Pcolor(x,y,z,varargin)
% scatter2Pcolor(x,y,z,varargin) creates a pseudocolor (checkerboard) plot
% from a set of scattered data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x : float : vector :[1 x N]
% y : float : vector :[1 x N]
% z : float : vector :[1 x N]
% % varargin:
%             - fontSize: scalar:  gives font size for the whole figure
%             - display: 'yes' or 'no': shows original data points
%             - resolution: scalar: grid resolution: lorger means finer,
%                           but has a higher computaitonal cost.
%             - Xlabel: string: label for x axis
%             - Ylabel: string: label for y axis
%             - Zlabel: string: label for z axis (colorbar)
%             - YAxisLocation: position of the colorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% h: returns a handle to a SURFACE object (optional)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x = rand(300,1)*200-100;  %Lon coordinates
% y = rand(300,1)*200-100;  %Lat coordinates
% z = 10*sin((x*pi/180).^2+(y*pi/180).^2)+20;  %Faux-measured data
% [X,Y] = meshgrid(unique(x),unique(y));
% Z = griddata(x,y,z,X,Y);
% figure
% pcolor(X,Y,Z); shading flat; colorbar;
% hold on; plot(x,y,'k.')  %Original data points;
% figure
% scatter2Pcolor(x,y,z,'display','yes')
% Author: Etienne Cheynet  - last modified : 28/04/2016
% All credits go to : http://rucool.marine.rutgers.edu/manuals/tag/pcolor/
%% INPUT parser
p = inputParser();
p.CaseSensitive = false;
p.addOptional('fontSize',12);
p.addOptional('display','no');
p.addOptional('resolution',200);
p.addOptional('Xlabel','');
p.addOptional('Ylabel','');
p.addOptional('Zlabel','');
p.addOptional('YaxisLocation','left')
p.parse(varargin{:});
% shorthen the variables name
myFontSize = p.Results.fontSize ;
display = p.Results.display ;
resolution = p.Results.resolution ;
Xlabel = p.Results.Xlabel ;
Ylabel = p.Results.Ylabel ;
Zlabel = p.Results.Zlabel ;
YaxisLocation = p.Results.YaxisLocation ;
%% grid construction
if isempty(resolution),
    [X,Y] = meshgrid(unique(x),unique(y));
else
    x_grid = min(x):(max(x)-min(x))/(resolution-1):max(x);
    y_grid = min(y):(max(y)-min(y))/(resolution-1):max(y);
    [X,Y] = meshgrid(x_grid,y_grid);
end

Z = griddata(x,y,z,X,Y);

%% Plot data grid
hh = pcolor(X,Y,Z); shading flat;
hold on;box on;
if strcmp(display,'yes'),    plot(x,y,'k.');  end % Original data points
set(gca, 'Layer','top')
%% Pimp my figure !
xlabel(Xlabel,'fontSize',myFontSize)
ylabel(Ylabel,'fontSize',myFontSize)
set(gca,'YAxisLocation',YaxisLocation);
set(gca,'fontsize',myFontSize);
c=colorbar;
if strcmpi(YaxisLocation,'right'),
    set(c,'location','WestOutside')
else
    set(c,'location','EastOutside')
end
set(c,'fontSize',myFontSize)
set(get(c,'ylabel'),'string',Zlabel,'fontSize',myFontSize);
set(gca,'fontsize',myFontSize);
caxis([quantile(Z(:),0.01),quantile(Z(:),0.99)]); % In case of outliers
set(gcf,'color','w')
if nargout == 1
    h = hh;
end
end
