% reads OMI O3 hdf L2 gridded O3 file
%------------------------------------
% MS, Feb-18,2015
%------------------------------------
function o3 = readOMIo3grid(o3infile)
            o3Time=double(hdf5read(o3infile,'/HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/Time'));
            o3Lat=double(hdf5read(o3infile,'/HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/Latitude'));
            o3Lon=double(hdf5read(o3infile,'/HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/Longitude'));
            o3col=double(hdf5read(o3infile,'/HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/ColumnAmountO3'));
            o3cldP=double(hdf5read(o3infile,'/HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/CloudPressure'));
            o3cldF=double(hdf5read(o3infile,'/HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/RadiativeCloudFraction'));
            o3uvAI  =double(hdf5read(o3infile,'HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/UVAerosolIndex'));
            o3.time=o3Time(:,:,1); 
            nanind = o3.time < 0;
            o3.lon =o3Lon(:,:,1);  o3.lon( nanind)=NaN;
            o3.lat =-o3Lat(:,:,1); o3.lat( nanind)=NaN;
            o3.o3col =o3col(:,:,1);o3.o3col(nanind)=NaN;
            o3.cldP  =o3cldP(:,:,1);o3.cldP(nanind)=NaN;
            o3.cldF  =o3cldF(:,:,1);o3.cldF(nanind)=NaN;
            o3.uvAI  =o3uvAI(:,:,1);o3.uvAI(nanind)=NaN;
            % close current file
            hdfml('closeall');
return;