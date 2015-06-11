%% Details of the function:
%  NAME:
% genOMIo3no2mean
%----------------------------------
% PURPOSE:
%  - calcualte mean o3 and no2 values corresonding to mission flights
%  - averaged over the aircraft domain, based on OMI L2 gridded products
%  - NO2:OMI-Aura_L2G-OMNO2G_(2014m0830_v003-2014m1124t132504.he5)
%  - O3 :OMI-Aura_L2G-OMTO3G_(2014m0830_v003-2014m1124t132504.he5)
%
% CALLING SEQUENCE:
%  [o3 no2] = genOMIo3no2mean(domainbound)
%
% INPUT:
% domainbound is a vector of [(minLat,minLon),(maxLat,maxLon)]
% and covers the area of interest
% 
% OUTPUT:
%  mean columnar o3 and no2 values over the flight domain area
%  output.mat with o3/no2 variable summary
%
%
% DEPENDENCIES:
% - getfullname__
%
% NEEDED FILES/INPUT:
% 
% - OMI-Aura_L2G-OMNO2G_2014m0830_v003-2014m1124t132504.sub.he5
% - OMI-Aura_L2G-OMTO3G_2014m0830_v003-2014m1123t115021.sub.he5 
% - subset data according to research domain
%
% EXAMPLE:
%  - [o3 no2] = genOMIo3no2mean([62.5 -180 82.5 -115]);% bounds for ARISE
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MS), NASA Ames,Feb-06-2015
% MS, Feb-18-2015, created readOMI subroutines
% -------------------------------------------------------------------------
%% function routine
function [o3out no2out] = genOMIo3no2mean(domainbounds)

startup_plotting; 

dirOMI = 'F:\ARISE\OMI\Gridded\';
o3infile  = getfullname__('*L2G-OMTO3G*.he5','F:','Select o3  gridded file');
no2infile = getfullname__('*L2G-OMNO2G*.he5','F:','Select no2 gridded file');

[pname, fname, ext] = fileparts(o3infile);
date = fname(20:29);
o3fileinfo =hdf5info(o3infile);
no2fileinfo=hdf5info(no2infile);

minLat = domainbounds(1);
minLon = domainbounds(2);
maxLat = domainbounds(3);
maxLon = domainbounds(4);
% read o3 data
o3  = readOMIo3grid(o3infile);
% read no2 data
no2 = readOMIno2grid(no2infile);

% perform data mean
o3_goodidx = o3.lat > minLat    &...
             o3.lat < maxLat    &...
             o3.lon > minLon    &...
             o3.lon < maxLon    &...
             o3.o3col > 200     &...
             o3.cldF  < 0.2     ;
         
no2_goodidx = no2.lat > minLat    &...
             no2.lat < maxLat    &...
             no2.lon > minLon    &...
             no2.lon < maxLon    &...
             no2.cldF < 0.2     ;

o3.o3Latmean = nanmean(o3.lat(o3_goodidx));
o3.o3Latstd  =  nanstd(o3.lat(o3_goodidx));
o3.o3Lonmean = nanmean(o3.lon(o3_goodidx));
o3.o3Lonstd  =  nanstd(o3.lon(o3_goodidx));
o3.o3colmean = nanmean(o3.o3col(o3_goodidx));
o3.o3colstd  = nanstd(o3.o3col(o3_goodidx));

no2.no2Latmean = mean(no2.lat(no2_goodidx));
no2.no2Latstd  =  std(no2.lat(no2_goodidx));
no2.no2Lonmean = mean(no2.lon(no2_goodidx));
no2.no2Lonstd  =  std(no2.lon(no2_goodidx));
no2.no2colmean = nanmean(no2.no2col(no2_goodidx));
no2.no2colstd  = nanstd(no2.no2col(no2_goodidx));
no2.no2colTropmean = nanmean(no2.no2colTrop(no2_goodidx));
no2.no2colTropstd  = nanstd(no2.no2colTrop(no2_goodidx));
no2.no2colStratmean = nanmean(no2.no2colStrat(no2_goodidx));
no2.no2colStratstd  = nanstd(no2.no2colStrat(no2_goodidx));

% save out parameters
% correct for too low values
if o3.o3colmean < 250
    o3out  = o3.o3colmean + o3.o3colstd;
else
    o3out  = o3.o3colmean;
end
no2out = no2.no2colmean;
% save to omi struct
omi.o3  = o3;
omi.no2 = no2;
%% save processed struct
si = [pname,'\','omi_summary',date,'.mat'];
disp(['saving to ' si]);
save(si,'-struct','omi');




return;