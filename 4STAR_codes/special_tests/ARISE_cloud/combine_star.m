%% PURPOSE:
%   Function to combine 4star data strcutures together
%   Returns combine time, lat, and lon
%
% CALLING SEQUENCE:
%   combine_star
%
% INPUT:
%   - star.mat data structure
%   - utc_range, range of data the be returned
% 
% OUTPUT:
%  - new data structure with the time lat and lon combined
%
% DEPENDENCIES:
%  - t2utch.m : function that returns utc hours from an array of matlab time stamps
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, Fairbanks, Alaska, Sep-27, 2014
%
% -------------------------------------------------------------------------

%% function to combine Z T P & RH of 4STAR modes 
% the altitude(Z), temperature(T), pressure(P), relative humidity(RH), from the different modes 
% of 4star.
function so=combine_star(s,utc_range);

disp('in combine_star, combining all the fields of aircraft data');

uu=fieldnames(s)
so.Tst=[0.];
so.Pst=[0.];
so.Z=[0.];
so.RH=[0.];
so.t=[0.];
so.lat=[0.];
so.lon=[0.];
for u=1:length(uu);
nn=findstr(uu{u},'vis');
    if nn; 
        kk=size(s.(uu{u}));
        if kk(2)==1;
          tt=s.(uu{u}).Tst;  
          so.Tst=[so.Tst,tt'];
          pp=s.(uu{u}).Pst;  
          so.Pst=[so.Pst,pp'];
          rr=s.(uu{u}).RH;   
          so.RH=[so.RH,rr'];
          zz=s.(uu{u}).Alt;  
          so.Z=[so.Z,zz'];
          ti=s.(uu{u}).t;    
          so.t=[so.t,ti'];
          lai=s.(uu{u}).Lat;
          so.lat=[so.lat,lai'];
          loi=s.(uu{u}).Lon;
          so.lon=[so.lon,loi'];
        else;
          for i=1:kk(2);
            tt=s.(uu{u})(i).Tst;  
            so.Tst=[so.Tst,tt'];
            pp=s.(uu{u})(i).Pst;  
            so.Pst=[so.Pst,pp'];
            rr=s.(uu{u})(i).RH;   
            so.RH=[so.RH,rr'];
            zz=s.(uu{u})(i).Alt;  
            so.Z=[so.Z,zz'];
            ti=s.(uu{u})(i).t;    
            so.t=[so.t,ti'];
            lai=s.(uu{u})(i).Lat;
            so.lat=[so.lat,lai'];
            loi=s.(uu{u})(i).Lon;
            so.lon=[so.lon,loi'];
          end;
        end;
    end;
end;
[so.t,is]=sort(so.t(2:end));
so.utc=t2utch(so.t);
if nargin >= 2; 
    it=find(so.utc >= utc_range(1) & so.utc <=utc_range(2));
    is=is(it);
    so.utc=so.utc(it);
    so.t=so.t(it);
end;
so.Tst=so.Tst(is);
so.Pst=so.Pst(is);
so.Z=so.Z(is);
so.RH=so.RH(is);
so.lat=so.lat(is);
so.lon=so.lon(is);
return;