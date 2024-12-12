% function to switch the time array to 24hrs utc

function utc=t2utch(t)
%dd=datevec(t);
%utc=dd(:,4)+dd(:,5)./60.0+dd(:,6)./3600.0+(dd(:,3)-dd(1,3)).*24.0;
utc = (t-floor(t(1)))*24.0; %Change to better represent 24hours, by using matlab's day number
return
end
