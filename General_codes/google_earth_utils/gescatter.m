function gescatter(filename,lon,lat,c,varargin)
% GESCATTER - create a scatter plot in Google Earth
%
%   GESCATTER(FILENAME,LON,LAT,C) - creates a .kml file that
%   displays colored circles at the locations specified by the 
%   vectors LON and LAT similar to ML's builtin function, SCATTER.
%   The color of the circles is scaled relative to the
%   values provided in third input, C.
%
%   OPTIONS AND SYNTAX - Optional inputs are entered as 
%   property/value pairs.  Valid optional properties are:
%
%   GESCATTER(...,'colormap','hot') - uses Matlabs 'hot'
%   colormap instead of the default (jet). Also accepts function
%   handles (@hot), or custom colormaps (m x 3 matrices).
%
%   GESCATTER(...,'clims',[low high]) - limit the color
%   values to a specified values (similar to CAXIS on a ML
%   figure). Clims should be supplied as a 2-element array.
%
%   GESCATTER(...,'time',timevector) - assigns a time to each
%   point. The length of the timevector array should be the same
%   as LAT, LON, and C.
%
%   GESCATTER(...,'scale',size) - scales the size of the dots in the
%   Google Earth file.  Default value is 0.4.
%
%   GESCATTER(...,'altitude',altitudevector) - assigns an altitude to each
%   point. The length of the altitude array should be the same
%   as LAT, LON, and C. will make the points relative to ground with
%   extrusions
%
%   GESCATTER(...,'colorbarlabel','colorbarlabel') - if set, creates a
%   colorbar as a screenoverlay with the label defined by the string
%   colorbarlabel
%
%   GESCATTER(...,'icontarget') - if set, uses a target icon instead of
%   simple circle.
%
%   EXAMPLE
%
%   %generate some data
%   x=(0:0.05:6*pi);
%   lon = -122.170087 + cos(x)*0.01;
%   lat = 37.455697 + x*0.001;
%
%   %color the points according to their latitude
%   gescatter('foo.kml',lon,lat,lat)
%
% SEE ALSO scatter

% Modification history:
% Written (v1.0):  A. Stevens @ USGS 3/04/2009, astevens@usgs.gov
% Modified (v1.1): Samuel LeBlanc, NASA Ames, CA, 2016-10-27
%           Added colorbar plotting. Added the altitude vector. added
%           option for a target icon

%default values
version_set('v1.1')
clims=[min(c) max(c)];
cmap=fliplr(jet);
t=[];
scale=0.5;


%parse inputs and do some error-checking
if nargin>0
    [m,n]=size(varargin);
    opts={'clims','time','scale','colormap','altitude','colorbarlabel','icontarget'};
    put_altitude = false;
    make_colorbar = false;
    icon_target = false;
    for i=1:n;
        indi=strcmpi(varargin{i},opts);
        ind=find(indi==1);
        if isempty(ind)~=1
            switch ind
                case 1
                    clims=varargin{i+1};
                    if numel(clims)~=2
                        error('Clims should be a two-element array.')
                    end
                    
                case 2
                    t=varargin{i+1};
                    if any(isnan(t))
                        error('Time vector should not contain NaNs.')
                    end
                    if ~isnumeric(t)
                        error('Time should be entered in ML Datenum format.')
                    end
                case 3
                    scale=varargin{i+1};
                case 4
                    cmap=varargin{i+1};
                    %check size of numeric colormap input
                    if isa(cmap,'numeric')
                        [m,n]=size(cmap);
                        if n~=3
                            error('Custom colormap must have 3 columns.')
                        end
                        cmap=fliplr(cmap);
                    else
                        %if standard colormap is supplied
                        if isa(cmap,'function_handle')
                            cmap= func2str(cmap); 
                        end
                        cmap=fliplr(feval(cmap));
                    end
                case 5 % make the points altitude dependent with relative to ground
                    alt = varargin{i+1};
                    put_altitude = true;
                case 6 % make a colorbar to add as an overlay on the kml and sets the label
                    colorbarlabel = varargin{i+1};
                    make_colorbar = true;
                case 7 % change the icon for targets
                    icon_target = true;
                    
            end
        end
    end
end


[pathstr,namer] = fileparts(filename);

%get rid on nans
gind=(isfinite(lon) & isfinite(lat) & isfinite(c));
lon=lon(gind);
lat=lat(gind);
c=c(gind);
if put_altitude;
    alt = alt(gind);
end;

%figure out the rgb colors of each value
cvals=[-inf;linspace(clims(1),clims(2),...
    length(cmap(:,1))-2)';inf];
[n,bin]=histc(c,cvals);
colors=cmap(bin,:);

%convert to GE's hex format
rgb=cellfun(@(x)(dec2hex(floor(x.*255),2)),...
    num2cell(colors),'uni',0);

%write the GE file
header=['<?xml version="1.0" encoding="UTF-8"?>',...
    '<kml xmlns="http://www.opengis.net/kml/2.2">',...
    '<Document><name>',namer,'</name>'];
footer='</Document></kml>';

h = waitbar(0,'Creating file, Please wait...');
set(h,'name','Creating Google Earth file')

fid = fopen(filename, 'wt');
fprintf(fid, '%s \n',header);

for i=1:length(lon)
    
    %create a style to hide each point in one document
    fprintf(fid,'%s \n','<Style id="folderStyle">');
    fprintf(fid,'%s \n','<ListStyle>');
    fprintf(fid,'%s \n','<listItemType>checkHideChildren</listItemType>');
    fprintf(fid,'%s \n','</ListStyle>');
    fprintf(fid,'%s \n','</Style>');
    
    %define the point style
    fprintf(fid,'%s \n','<Style id="cpoint">');
    fprintf(fid,'%s \n','<IconStyle>');
    fprintf(fid,'%s \n',['<color>ff',[rgb{i,:}],'</color>']);
    fprintf(fid,'%s \n',['<scale>',sprintf('%.1f',scale),'</scale>']);
    if icon_target
        fprintf(fid,'%s \n',['<Icon><href>http://maps.google.com/mapfiles/kml/shapes/target.png</href></Icon>']);
    else
        fprintf(fid,'%s \n',['<Icon><href>http://engineering.arm.gov/~sleblanc/kml_fig/circle.png</href></Icon>']);
    end;
    fprintf(fid,'%s \n','</IconStyle>');
    fprintf(fid,'%s \n','</Style>');
    
    %add the placemark
    fprintf(fid, '%s \n','<Placemark>');
    fprintf(fid,'%s \n','<styleUrl>#cpoint</styleUrl>');
    
    %create a simple description for each point
    fprintf(fid, '%s \n','<description><![CDATA[<table width="200"></table>');
    fprintf(fid, '%s \n',['<h2>Filename: ',namer,'<br>']);
    fprintf(fid, '%s \n',['<h3>Value: ',sprintf('%.1f',c(i)),'<br>']);
    if ~isempty(t)
        fprintf(fid, '%s \n',['Time (GMT): ',datestr(t(i)),'<br>']);
    end
    if put_altitude;
        fprintf(fid, '%s \n',['Altitude (m): ',num2str(alt(i)),'<br>']);
    end
    fprintf(fid, '%s \n',']]></description>');
    
    
    fprintf(fid,'%s \n','<Point>');
    if put_altitude
        fprintf(fid, '%s \n','<extrude>1</extrude><altitudeMode>relativeToGround</altitudeMode>');
        fprintf(fid,'%s','<coordinates>');
        fprintf(fid, ' %.6f, %.6f, %.2f', [double(lon(i)) double(lat(i)) double(alt(i))*100.0]);
    else
        fprintf(fid,'%s','<coordinates>');
        fprintf(fid, ' %.6f, %.6f, %.2f', [lon(i) lat(i) c(i)]);
    end
    fprintf(fid,'%s \n','</coordinates>');
    fprintf(fid,'%s \n','</Point>');
    
    if ~isempty(t)
        fprintf(fid,'%s \n','<TimeSpan>');
        fprintf(fid,'%s \n',['<begin>',datestr(t(1),29),...
            'T',datestr(t(1),13),'Z</begin>']);
        fprintf(fid,'%s \n',['<end>',datestr(t(end),29),...
            'T',datestr(t(end),13),'Z</end>']);
        fprintf(fid,'%s \n','</TimeSpan>');
    end
    
    
    fprintf(fid, '%s \n','</Placemark>');
    
    waitbar(i/length(lon),h,sprintf('%d%% complete...',...
        round((i/length(lon))*100)));
    
end

if make_colorbar;
    fig = figure(10);
    left=100; bottom=100 ; width=18 ; height=500;
    pos=[left bottom width height];
    axis off;
    set(gca, 'CLim', clims);
    colormap(fliplr(cmap))
    cba = colorbar([0.05 0.05  0.35  0.9]);
    set(fig,'OuterPosition',pos); 
    ylabel(cba,colorbarlabel);
    
    set(fig,'PaperUnits','inches');
    po = get(fig,'Position');
    xwidth = po(3); ywidth = po(4); dpi = 150.0;
    set(fig,'PaperSize',[xwidth ywidth]./dpi,'PaperPosition',[0 0 xwidth ywidth]./dpi,'color','w');
    f = getframe(fig);
    imwrite(f.cdata,[pathstr filesep namer '_colorbar.png'],'png','transparency',[1 1 1]);
    close(fig)
    
    fprintf(fid, '%s \n','<ScreenOverlay>');
    fprintf(fid, '%s \n',['<name>Legend: ' colorbarlabel '</name>']);
    fprintf(fid, '%s \n',['<Icon><href>./' namer '_colorbar.png</href></Icon>']);
    fprintf(fid, '%s \n','<overlayXY x="0" y="0" xunits="fraction" yunits="fraction"/>');
    fprintf(fid, '%s \n','<screenXY x="20" y="80" xunits="pixels" yunits="pixels"/>');
    fprintf(fid, '%s \n','<rotationXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>');
    fprintf(fid, '%s \n','<size x="0" y="0" xunits="pixels" yunits="pixels"/>');
    fprintf(fid, '%s \n','</ScreenOverlay>');
end;

fprintf(fid, '%s \n','<styleUrl>#folderStyle</styleUrl>');
fprintf(fid, '%s \n',footer);

close(h);
fclose(fid);