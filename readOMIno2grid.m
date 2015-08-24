% reads OMI NO2 hdf L2 gridded NO2 file
%--------------------------------------
% MS, Feb-18,2015
%--------------------------------------
function no2= readOMIno2grid(no2infile)
            no2Time=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Time'));
            no2Lat=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Latitude'));
            no2Lon=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/Longitude'));
            no2CloudP=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudPressure'));
            no2CloudF=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudFraction'));
            no2CloudFStd=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/CloudFractionStd'));
            no2col=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2'));
            no2colStd=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Std'));
            no2colTrop=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Trop'));
            no2colTropStd=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2TropStd'));
            no2colStrat=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Strat'));
            no2colStratStd=double(hdf5read(no2infile,'/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/ColumnAmountNO2StratStd'));
            no2.time=no2Time(:,:,1);
            nanind2 = no2.time < 0;
            no2.lon=no2Lon(:,:,1);                    no2.lon(           nanind2)=NaN;
            no2.lat=no2Lat(:,:,1);                    no2.lat(           nanind2)=NaN;
            no2.cldF = no2CloudF(:,:,1);              no2.cldF(          nanind2)=NaN;
            no2.cldP = no2CloudP(:,:,1);              no2.cldP(          nanind2)=NaN;
            no2.cldFstd = no2CloudFStd(:,:,1);        no2.cldFstd(       nanind2)=NaN;
            no2.no2col=no2col(:,:,1);                 no2.no2col(        nanind2)=NaN;
            no2.no2colStd=no2colStd(:,:,1);           no2.no2colStd(     nanind2)=NaN;
            no2.no2colTrop=no2colTrop(:,:,1);         no2.no2colTrop(    nanind2)=NaN;
            no2.no2colTropStd=no2colTropStd(:,:,1);   no2.no2colTropStd( nanind2)=NaN;
            no2.no2colStrat=no2colStrat(:,:,1);       no2.no2colStrat(   nanind2)=NaN;
            no2.no2colStratStd=no2colStratStd(:,:,1); no2.no2colStratStd(nanind2)=NaN;

            % close current file
            hdfml('closeall');
return;