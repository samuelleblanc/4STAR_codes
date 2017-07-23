function [lambda, fwhm, V0, xsect]=aatslambda(t)

if nargin==0;
    t=now;
elseif t<725008; % a date before the year 1985
    error(['Give a date in the Matlab date format. (It is ' num2str(now) ' now.)']);
end;

fwhm=[];
V0=[];
xsect=[];
if t>=datenum([2016 10 30]); % filter swap (see AATS-14_Filter_ Use_20160305.xls); changes in the format of this function
    xsect_dir=getnamedpath('AATS_xsect');
%     if ~exist(xsect_dir);
%         xsect_dir = fullfile(starpaths, 'source', 'AATS');
%     end;
    CrossSec_name='Ames14#1_2012_05182012.asc' %'Ames14#1_2008_05142008.asc'; %'Ames14#1_20160307.asc';%'Ames14#1_2008_05142008.asc'(ARCATS-summer),'Ames14#1_2011_09222011.asc'(MLO-Sept2011),'Ames14#1_2012_05182012.asc' (MLO-May2012)
    fid=fopen(fullfile(xsect_dir, CrossSec_name));
    fgetl(fid);
    fgetl(fid);
    xsect=fscanf(fid,'%f',[11,inf]);
    xsect=xsect';
    fclose(fid);
    lambda=xsect(:,1)'/1000;
    fwhm=xsect(:,2)'/1000;
    V0=[]; % read V0 not in this code but from DefineV0Input.m.
elseif t>=datenum([2011 5 25]);
    lambda=[0.3535    0.3800    0.4520    0.5005    0.5204    0.6052    0.6751    0.7805    0.8645    0.9410    1.0191    1.2356    1.5585    2.1391];
    fwhm=[0.0020    0.0046    0.0047    0.0105    0.0052    0.0045    0.0052    0.0055    0.0050    0.0048    0.0051    0.0217    0.0047    0.0152];
    V0=[16.396 9.674 8.184 10.154 10.552 6.406 6.929 6.368 7.535 5.470 7.792 7.614 3.559 6.232]; %mean Sept. 2011 MLO
elseif t>=datenum([2008 5 10]);
    % updated 2009/11/25
    lambda=[353.5, 380.0, 451.2, 499.4, 520.4, 605.8, 675.1, 779.1, 864.5, 1019.1, 1241.3, 1558.5, 2139.1]/1000; % 940.6 removed
elseif t>=datenum([2008 1 10]);
    lambda=[353.5, 380.0, 452.6, 499.4, 519.4, 605.8, 675.1, 779.1, 864.5, 1019.1, 1241.3, 1557.8, 2139.3]/1000; % 940.6 removed
else
    error('Get the record from AATS-14_Filter_ Use_RRJJML_E.xls.');
end;