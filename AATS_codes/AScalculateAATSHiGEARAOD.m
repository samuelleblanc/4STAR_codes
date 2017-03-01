% for given starting and ending times in a variable "times", calculate the
% layer and column AODs from AATS and HiGEAR measurements during ARCTAS.
% For an older version of this code, see ASAATSHiGEARAODclosure_old2.m and
% ASAATSHiGEARAODclosure_old.m. See also ASAATSHiGEARAODclosure.m.
% Yohei, 2009/01/14

%***************************************
% set parameters
%***************************************
% parameters for the low and high ends of each profile, for taking the AOD
% difference
altallowance=50; % in meter
timeallowance=10/86400; % in day
choose_one_AATS_point=1;
maxdist=Inf; % maximum distance in meter allowed from the location of the end point of the profile.
maxdist=50000; % maximum distance in meter allowed from the location of the end point of the profile.
% parameters for the bottom and top layers of each profile, for assessing
% the spatial homogeneity
layerthickness=600;
layersampletime=120/86400;
layermaxdist=maxdist;
if ~exist('aeronetalt');
    aeronetalt=0;
end;

maxrng=km2deg(maxdist/1000);
layermaxrng=km2deg(layermaxdist/1000);

% uncertainties and spatial variability
higear.noise=0.0005; % used to be 0.001. THIS IS AN ABSOLUTE VALUE IN AOD. A rough estimate; I think the order of magnitude is correct. See ASTSInephnoisesimulation.m.
higear.meas_unc=0.02; % used to be 0.01 (Anderson et al. [1996?]) McNaughton et al. [2009] says 2% accuracy. Presumably due to gas calibration, etc. in the TSI measurement
higear.cor_unc=[0.010 0.007 0.004]; % about 1% uncertainty in the angular truncation correction, assuming most particles were submicron, Table 4b of Anderson and Ogren [1998].
estimate_ambunc=0;
if ~isfield(higear,'amb_unc');
    higear.amb_unc=Inf; 
    estimate_ambunc=1;
end; 
bottomuncfrac=1; % fraction of the bottom AOD that is uncertain
svfilename='AScovhorilegs20km.mat'; % 'AScovhorilegs10km.mat'
sv=load(fullfile(paths,'arctas', 'spatialvariability', svfilename)); % 10-km COV from HORIZONTAL legs. See ASAATShorizontalvariability.m.
sv.cov=sv.stdaod./sv.meanaod;
sv.layersampletime=360/86400;
sv.layersampletime=60/86400;
% sv.maxdist=20000; % maximum distance in meter allowed from the location of the end point of the profile.
sv.maxalt=2000;

%***************************************
% start the iteration through the profiles
%***************************************
asft=ASflighttimes;
flightnumber0=0;
i=1;
for i=1:size(times,1);
    flightnumber=find(asft(:,1)<=times(i,1)&asft(:,2)>=times(i,2));

    %***************************************
    % load the HiGEAR and AATS data
    %***************************************
    if flightnumber~=flightnumber0
        % HiGEAR
        % laod
        ASparam(flightnumber);
        load(char(matfilesv3(4)));
        load(char(matfilesv3(6)));
        higearver=3;
        horilegs=load(fullfile(paths, 'arctas', ['AS' foldername 'horilegs.txt'])); % time periods of horizontal legs
        % calculate ambient AOD
        AStypicalopticalcalculation;
        % calcualte missing AOD
        if isfield(air, 'C_CorrectRadarAlt') & ~isnan(air.C_CorrectRadarAlt);
            tsineph1.radaralt=interp1(air.t,air.C_CorrectRadarAlt,tsineph1.t);
            differentialAOD0=[tsineph1.ambcorTOTeB tsineph1.ambcorTOTeG tsineph1.ambcorTOTeR]/1e6.*repmat(tsineph1.radaralt,1,3);
        else
            tsineph1.radaralt=repmat(NaN,size(tsineph1.t));
            altok=ones(size(tsineph1.alt));
            altok(find(tsineph1.alt>2000))=NaN;
            differentialAOD0=[tsineph1.ambcorTOTeB tsineph1.ambcorTOTeG tsineph1.ambcorTOTeR]/1e6.*repmat(tsineph1.alt.*altok,1,3);
        end;
        % AATS
        aatsver=3;
        if aatsver==1;
            load(char(matfilesv1(7)));
        elseif aatsver==2;
            load(char(matfilesv2(7)));
            aats.lambda=[354 380 453 499 519 606 675 779 865 1019 1241 1559 2139]/1000;
            aats.aod=[aats.AOD354 aats.AOD380 aats.AOD453 aats.AOD499 aats.AOD519 aats.AOD606 aats.AOD675 aats.AOD779 aats.AOD865 aats.AOD1019 aats.AOD1241 aats.AOD1559 aats.AOD2139];
            aats.u_aod=[aats.u_AOD353 aats.u_AOD380 aats.u_AOD452 aats.u_AOD499 aats.u_AOD519 aats.u_AOD606 aats.u_AOD675 aats.u_AOD779 aats.u_AOD865 aats.u_AOD1019 aats.u_AOD1241 aats.u_AOD1559 aats.u_AOD2139];
        elseif aatsver==3;
            load(char(matfilesv3(7)));
        end;
        aats.lambda=aatslambda; % updated 2009/11/25
        if length(aats.lambda)==14;
            aats.lambda=aats.lambda([1:9 11:14]);
        end;
        aats.lon=interp1(air.t,air.lon,aats.t);
        aats.lat=interp1(air.t,air.lat,aats.t);
        aats.alt=interp1(air.t,air.alt,aats.t);
        if ~isempty(aats.aod);
            q=size(aats.aod,2);
        end;
        flightnumber0=flightnumber;
    end;

    %***************************************
    % ad-hoc adjustments of the time stamps to avoid clouds
    %***************************************
    !!! this should be implemented in the profile timetables.
    if times(i,1) < 182.8606 & times(i,2) > 182.8615
        ng=find(psap1.t>=182.8605 & psap1.t<=182.8627);
        psap1.TOTaB(ng)=NaN;
        psap1.TOTaG(ng)=NaN;
        psap1.TOTaR(ng)=NaN;
        psap1.TOTaB_Virk(ng)=NaN;
        psap1.TOTaG_Virk(ng)=NaN;
        psap1.TOTaR_Virk(ng)=NaN;
        AStypicalopticalcalculation;
    elseif tsineph1.t(1)>85.13 & tsineph1.t(end)<85.26; % flight #1
        tsineph1.t=tsineph1.t+0.5;
        tsineph2.t=tsineph2.t+0.5;
        rrneph3.t=rrneph3.t+0.5;
        rrneph4.t=rrneph4.t+0.5;
        psap1.t=psap1.t+0.5;
        psap2.t=psap2.t+0.5;
        AStypicalopticalcalculation;
    elseif tsineph1.t(1)>100 & tsineph1.t(end)<101; % flight #7
%         ng=find(psap1.t>=100.90152777777985 & psap1.t<=100.90178240742534); % humidity over ice > 95%
%         tsineph1.TOTtsB(ng)=NaN;
%         tsineph1.TOTtsG(ng)=NaN;
%         tsineph1.TOTtsR(ng)=NaN;
%         tsineph1.corTOTtsB(ng)=NaN;
%         tsineph1.corTOTtsG(ng)=NaN;
%         tsineph1.corTOTtsR(ng)=NaN;
%         psap1.TOTaB(ng)=NaN;
%         psap1.TOTaG(ng)=NaN;
%         psap1.TOTaR(ng)=NaN;
%         psap1.TOTaB_Virk(ng)=NaN;
%         psap1.TOTaG_Virk(ng)=NaN;
%         psap1.TOTaR_Virk(ng)=NaN;
%         AStypicalopticalcalculation;
    end;

    %***************************************
    % select the HiGEAR extinction data during each vertical profile
    %***************************************
    done=0;
    while done==0
        tsineph1.rr=find(tsineph1.t>=times(i,1) & tsineph1.t<=times(i,2) & isfinite(tsineph1.ambcorTOTeB)==1 & isfinite(tsineph1.ambcorTOTeG)==1 & isfinite(tsineph1.ambcorTOTeR)==1 & psap1.TOTaG<=1000);
        f.higearnos(i,1)=length(tsineph1.rr); % flag: the number of HiGEAR ambient extinction data
%         if f.higearnos(i,1)>0
        if f.higearnos(i,1)>1
            %***************************************
            % get the lowest and highest altitude with valid HiGEAR data
            %***************************************
            dalt(i,1)=max(diff(sort(tsineph1.alt(tsineph1.rr))));
            [minalt, minidx]=min(tsineph1.alt(tsineph1.rr));
            [maxalt, maxidx]=max(tsineph1.alt(tsineph1.rr));
            minlon=tsineph1.lon(tsineph1.rr(minidx));
            minlat=tsineph1.lat(tsineph1.rr(minidx));
            maxlon=tsineph1.lon(tsineph1.rr(maxidx));
            maxlat=tsineph1.lat(tsineph1.rr(maxidx));
            timeslohi=[tsineph1.t(tsineph1.rr(minidx)) tsineph1.t(tsineph1.rr(maxidx))];
            times(i,:)=sort(timeslohi);
            lorng=distance(repmat(minlat,size(aats.t)), repmat(minlon,size(aats.t)), aats.lat, aats.lon);
            hirng=distance(repmat(maxlat,size(aats.t)), repmat(maxlon,size(aats.t)), aats.lat, aats.lon);
            if isempty(aats.t)
                a.lorr=[];
                a.hirr=[];
                a.rr=[];
                tsineph1.lorr=[];
%                 tsineph1.hirr=[];
            else
                %                 a.lorr=find(aats.t>=timeslohi(1)-timeallowance/2 & aats.t<=timeslohi(1)+timeallowance/2 & aats.alt>=minalt-altallowance/2 & aats.alt<=minalt+altallowance/2 & sum(isfinite(aats.aod),2) & lorng<=maxrng);
                %                 a.hirr=find(aats.t>=timeslohi(2)-timeallowance/2 & aats.t<=timeslohi(2)+timeallowance/2 & aats.alt>=maxalt-altallowance/2 & aats.alt<=maxalt+altallowance/2 & sum(isfinite(aats.aod),2) & hirng<=maxrng);
                a.lorr=find(aats.t>=timeslohi(1)-timeallowance/2 & aats.t<=timeslohi(1)+timeallowance/2 & aats.alt>=minalt-altallowance/2 & aats.alt<=minalt+altallowance/2 & sum(isfinite(aats.aod),2) & lorng<=maxrng & hirng<=maxrng); % stay in a small column
                a.hirr=find(aats.t>=timeslohi(2)-timeallowance/2 & aats.t<=timeslohi(2)+timeallowance/2 & aats.alt>=maxalt-altallowance/2 & aats.alt<=maxalt+altallowance/2 & sum(isfinite(aats.aod),2) & hirng<=maxrng & lorng<=maxrng); % stay in a small column
%                 % 2009/11/09, (and 2010/01/01 reapplied) note stricter time requirements (first two terms) added
                a.lorr=find(aats.t>=times(i,1) & aats.t<=times(i,2) & aats.t>=timeslohi(1)-timeallowance/2 & aats.t<=timeslohi(1)+timeallowance/2 & aats.alt>=minalt-altallowance/2 & aats.alt<=minalt+altallowance/2 & sum(isfinite(aats.aod),2) & lorng<=maxrng & hirng<=maxrng); % stay in a small column
                a.hirr=find(aats.t>=times(i,1) & aats.t<=times(i,2) & aats.t>=timeslohi(2)-timeallowance/2 & aats.t<=timeslohi(2)+timeallowance/2 & aats.alt>=maxalt-altallowance/2 & aats.alt<=maxalt+altallowance/2 & sum(isfinite(aats.aod),2) & hirng<=maxrng & lorng<=maxrng); % stay in a small column
                a.rr=find(aats.t>=times(i,1) & aats.t<=times(i,2) & sum(isfinite(aats.aod),2));
                tsineph1.lorr=find(tsineph1.t>=timeslohi(1)-timeallowance/2 & tsineph1.t<=timeslohi(1)+timeallowance/2 & tsineph1.alt>=minalt-altallowance/2 & tsineph1.alt<=minalt+altallowance/2);
%                 tsineph1.hirr=find(tsineph1.t>=timeslohi(2)-timeallowance/2 & tsineph1.t<=timeslohi(2)+timeallowance/2 & tsineph1.alt>=maxalt-altallowance/2 & tsineph1.alt<=maxalt+altallowance/2);
            end;
            done=1;
            if ~isempty(a.rr)
                if isempty(a.hirr); % reset the hi time
                    [maxalt, maxidx]=max(aats.alt(a.rr));
                    timeslohi(2)=[aats.t(a.rr(maxidx))];
                    times(i,:)=sort(timeslohi);
                    done=0;
                end;
                if isempty(a.lorr); % reset the lo time
                    [minalt, minidx]=min(aats.alt(a.rr));
                    timeslohi(1)=[aats.t(a.rr(minidx))];
                    times(i,:)=sort(timeslohi);
                    done=0;
                end;
            end
%         elseif f.higearnos(i,1)==0
        elseif f.higearnos(i,1)<=1
            done=1;
        end;
    end;
    if choose_one_AATS_point==1
        if length(a.lorr)>1;
            [dummy,minidx]=min(abs(aats.t(a.lorr)-timeslohi(1)));
            a.lorr=a.lorr(minidx);
        end;
        if length(a.hirr)>1;
            [dummy,minidx]=min(abs(aats.t(a.hirr)-timeslohi(2)));
            a.hirr=a.hirr(minidx);
        end;
    end;
        
    %***************************************
    % calculate HiGEAR AOD
    %***************************************
    if f.higearnos(i,1)>0
        % ambient layer AOD
        altfactor=0.80;
        for wl=1:3;
            if wl==1;
                tambcorTOT=tsineph1.ambcorTOTeB;
                tambcorTOTts=tsineph1.ambcorTOTtsB;
                tcorTOTa=psap1.corTOTaB;
            elseif wl==2;
                tambcorTOT=tsineph1.ambcorTOTeG;
                tambcorTOTts=tsineph1.ambcorTOTtsG;
                tcorTOTa=psap1.corTOTaG;
            elseif wl==3;
                tambcorTOT=tsineph1.ambcorTOTeR;
                tambcorTOTts=tsineph1.ambcorTOTtsR;
                tcorTOTa=psap1.corTOTaR;
            end;
%             [higear.layeraod(i,wl), cumext]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tambcorTOT(tsineph1.rr)/1e6, 0);
            [higear.layerscaaod(i,wl), cumextdummy]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tambcorTOTts(tsineph1.rr)/1e6, 0);
            [higear.layerabsaod(i,wl), cumextdummy]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tcorTOTa(tsineph1.rr)/1e6, 0);
%             [dummy, maxidx1]=max(find(cumext(:,2)<higear.layeraod(i,wl)*altfactor));
%             aa=higear.layeraod(i,1)*altfactor-cumext(maxidx1,2);
%             bb=cumext(maxidx1+1,2)-higear.layeraod(i,1)*altfactor;
%             higear.altof80percent(i,wl)=(aa*cumext(maxidx1+1,1)+bb*cumext(maxidx1,1))/(aa+bb);
        end;
        % adjust the wavelength of AAOD
        corang=sca2angstrom(higear.layerabsaod(i,:),[47 53 66]);
        corangBG=sca2angstrom(higear.layerabsaod(i,1:2),[47 53]);
        corangGR=sca2angstrom(higear.layerabsaod(i,2:3),[53 66]);
        corang(find(imag(corang)~=0))=0;
        corangBG(find(imag(corangBG)~=0))=0;
        corangGR(find(imag(corangGR)~=0))=0;
        higear.layerabsaod_nephlambda(i,1)=higear.layerabsaod(i,1).*(470/450).^corangBG;
        higear.layerabsaod_nephlambda(i,2)=higear.layerabsaod(i,2).*(530/550).^corangBG;
        higear.layerabsaod_nephlambda(i,3)=higear.layerabsaod(i,3).*(660/700).^corangGR;
        higear.layeraod(i,:)=higear.layerscaaod(i,:)+higear.layerabsaod_nephlambda(i,:);
        % dry layer AOD, to calculate the column-integral f(RH)
        clear cumsca cumscaa cumsca2;
        [higear.layerdryaod(i,1), cumsca(:,:,1)]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tsineph1.corTOTtsB(tsineph1.rr)/1e6, 0);
        [higear.layerdryaod(i,2), cumsca(:,:,2)]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tsineph1.corTOTtsG(tsineph1.rr)/1e6, 0);
        [higear.layerdryaod(i,3), cumsca(:,:,3)]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tsineph1.corTOTtsR(tsineph1.rr)/1e6, 0);
%         [higear.layerdryaaod(i,1), cumscaa(:,:,1)]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, psap1.corTOTa450(tsineph1.rr)/1e6, 0);
%         [higear.layerdryaaod(i,2), cumscaa(:,:,2)]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, psap1.corTOTa550(tsineph1.rr)/1e6, 0);
%         [higear.layerdryaaod(i,3), cumscaa(:,:,3)]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, psap1.corTOTa700(tsineph1.rr)/1e6, 0);
        tsineph2.rr=find(tsineph2.t>=times(i,1) & tsineph2.t<=times(i,2) & isfinite(tsineph2.corSUBtsB)==1 & isfinite(tsineph2.corSUBtsG)==1 & isfinite(tsineph2.corSUBtsR)==1 & isfinite(tsineph1.ambcorTOTeB)==1 & isfinite(tsineph1.ambcorTOTeG)==1 & isfinite(tsineph1.ambcorTOTeR)==1 & psap1.TOTaG<=1000);
        [higear.layerdryaod2(i,1), cumsca2(:,:,1)]=vertsca2od(tsineph1.alt(tsineph2.rr)-minalt, tsineph1.corTOTtsB(tsineph2.rr)/1e6, 0);
        [higear.layerdryaod2(i,2), cumsca2(:,:,2)]=vertsca2od(tsineph1.alt(tsineph2.rr)-minalt, tsineph1.corTOTtsG(tsineph2.rr)/1e6, 0);
        [higear.layerdryaod2(i,3), cumsca2(:,:,3)]=vertsca2od(tsineph1.alt(tsineph2.rr)-minalt, tsineph1.corTOTtsR(tsineph2.rr)/1e6, 0);
        [higear.layerdryaod2(i,4), cumsca2(:,:,4)]=vertsca2od(tsineph1.alt(tsineph2.rr)-minalt, tsineph2.corSUBtsB(tsineph2.rr)/1e6, 0);
        [higear.layerdryaod2(i,5), cumsca2(:,:,5)]=vertsca2od(tsineph1.alt(tsineph2.rr)-minalt, tsineph2.corSUBtsG(tsineph2.rr)/1e6, 0);
        [higear.layerdryaod2(i,6), cumsca2(:,:,6)]=vertsca2od(tsineph1.alt(tsineph2.rr)-minalt, tsineph2.corSUBtsR(tsineph2.rr)/1e6, 0);
        clear aboveaircraftcumsca;
        if size(times,1)==1; % get the SMF at each altitude for the fractional AOD above the aircraft to the highest point reached during the time period
            for z=1:6;
                aboveaircraftcumsca(:,z)=cumsca2(end,2,z)-cumsca2(:,2,z);
            end;
            cumdryaodsmf=aboveaircraftcumsca(:,4:6)./aboveaircraftcumsca(:,1:3);
            clear z altc
        end;
        % effective ambient RH and gamma, used to estimate the uncertainty in
        % humidification
%         [higear.effambrh0, cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tsineph1.corTOTtsG(tsineph1.rr).*tsineph1.ambrh(tsineph1.rr)/1e6, 0);
%         higear.effambrh(i,1)=higear.effambrh0./higear.layerdryaod(i,2);
        [higear.effambrh0, cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tsineph1.ambcorTOTtsG(tsineph1.rr).*tsineph1.ambrh(tsineph1.rr)/1e6, 0);
        higear.effambrh(i,1)=higear.effambrh0./higear.layerscaaod(i,2);
%         [higear.efftsirh0, cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tsineph1.corTOTtsG(tsineph1.rr).*tsineph1.rh(tsineph1.rr)/1e6, 0);
%         higear.efftsirh(i,1)=higear.efftsirh0./higear.layerdryaod(i,2);
        [higear.efftsirh0, cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, tsineph1.ambcorTOTtsG(tsineph1.rr).*tsineph1.rh(tsineph1.rr)/1e6, 0);
        higear.efftsirh(i,1)=higear.efftsirh0./higear.layerscaaod(i,2);
        [higear.rrneph3(i,1), cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, rrneph3.TOTts(tsineph1.rr)/1e6, 0);
        [higear.rrneph4(i,1), cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, rrneph4.TOTts(tsineph1.rr)/1e6, 0);
        [higear.rrneph3rh0(i,1), cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, rrneph3.TOTts(tsineph1.rr).*rrneph3.rh(tsineph1.rr)/1e6, 0);
        [higear.rrneph4rh0(i,1), cumscad]=vertsca2od(tsineph1.alt(tsineph1.rr)-minalt, rrneph4.TOTts(tsineph1.rr).*rrneph4.rh(tsineph1.rr)/1e6, 0);
        f.highambrh(i,:)=[length(find(tsineph1.ambrh(tsineph1.rr)>99)) length(tsineph1.rr)];
        % ambient AOD below aircraft (the bottom layer)
        %         higear.bottomaod(i,:)=differentialAOD0(tsineph1.rr(minidx),:); I now think this is wrong.
        if length(tsineph1.lorr)>1
            higear.bottomaod(i,:)=nanmean(differentialAOD0(tsineph1.lorr,:));
            higear.bottomext(i,:)=nanmean([tsineph1.ambcorTOTeB(tsineph1.lorr) tsineph1.ambcorTOTeG(tsineph1.lorr) tsineph1.ambcorTOTeR(tsineph1.lorr)]);
        elseif length(tsineph1.lorr)==1
            higear.bottomaod(i,:)=differentialAOD0(tsineph1.lorr,:);
            higear.bottomext(i,:)=[tsineph1.ambcorTOTeB(tsineph1.lorr) tsineph1.ambcorTOTeG(tsineph1.lorr) tsineph1.ambcorTOTeR(tsineph1.lorr)];
        else
            higear.bottomaod(i,:)=repmat(NaN,1,3);
            higear.bottomext(i,:)=repmat(NaN,1,3);
        end;
        % Note that ambient AOD above aircraft (the top layer) is estimated
        % below from the AATS measurement, and called "a.topaodh" (the
        % uncertainty estimated "a.topaodh_unc").

        %***************************************
        % get the AATS AOD difference between the low and high ends
        %***************************************
        f.aatsnos(i,:)=[length(a.lorr) length(a.hirr) length(a.rr)]; % flag: the numbers of AATS data at the low and high ends
        if ~isempty(a.lorr)
            a.toppluslayeraod(i,:)=nanmean1(aats.aod(a.lorr,:));
            a.toppluslayeraod_unc(i,:)=nanmean1(aats.u_aod(a.lorr,:));
            a.minalt(i,1)=nanmean1(aats.alt(a.lorr));
        else
            a.toppluslayeraod(i,:)=repmat(NaN,1,q);
            a.toppluslayeraod_unc(i,:)=repmat(NaN,1,q);
            a.minalt(i,1)=NaN;
        end;
%         if length(a.lorr)>1
%             a.toppluslayeraod(i,:)=nanmean(aats.aod(a.lorr,:));
%             a.toppluslayeraod_unc(i,:)=nanmean(aats.u_aod(a.lorr,:));
%             a.minalt(i,1)=nanmean(aats.alt(a.lorr));
%         elseif length(a.lorr)==1
%             a.toppluslayeraod(i,:)=aats.aod(a.lorr,:);
%             a.toppluslayeraod_unc(i,:)=aats.u_aod(a.lorr,:);
%             a.minalt(i,1)=aats.alt(a.lorr);
%         else
%             a.toppluslayeraod(i,:)=repmat(NaN,1,q);
%             a.toppluslayeraod_unc(i,:)=repmat(NaN,1,q);
%             a.minalt(i,1)=NaN;
%         end;
        if ~isempty(a.hirr)
            a.topaod(i,:)=nanmean1(aats.aod(a.hirr,:));
            a.topaod_unc(i,:)=nanmean1(aats.u_aod(a.hirr,:));
        else
            a.topaod(i,:)=repmat(NaN,1,q);
            a.topaod_unc(i,:)=repmat(NaN,1,q);
        end;
%         if length(a.hirr)>1
%             a.topaod(i,:)=nanmean(aats.aod(a.hirr,:));
%             a.topaod_unc(i,:)=nanmean(aats.u_aod(a.hirr,:));
%         elseif length(a.hirr)==1
%             a.topaod(i,:)=aats.aod(a.hirr,:);
%             a.topaod_unc(i,:)=aats.u_aod(a.hirr,:);
%         else
%             a.topaod(i,:)=repmat(NaN,1,q);
%             a.topaod_unc(i,:)=repmat(NaN,1,q);
%         end;
        % differential AOD at the AATS wavelengths
        a.layeraod(i,:)=a.toppluslayeraod(i,:)-a.topaod(i,:);
        % find the wavelengths with data
        okw=find(isfinite(a.layeraod(i,:))==1);
        % differential AOD interpolated to the HiGEAR wavelengths
        a.layeraodh0(i,:)=repmat(NaN,1,3);
        if length(okw)>2 & max(diff(okw))<=3;
            a.layeraodh0(i,:)=exp(interp1(log(aats.lambda(okw)), log(a.layeraod(i,okw)), log([450 550 700]/1000)));
        end;
        % uncertainty in the differential AOD at the AATS wavelengths
        % this alone is not the overall uncertainty; for spatial
        % variability, see below
        a.layeraod_unc(i,:)=sqrt(a.toppluslayeraod_unc(i,:).^2+a.topaod_unc(i,:).^2)/2; % Eq. (6) of Redemann et al. ACE-Asia paper [2003 JGR], spatial variability not included.
%         !!!
%         THIS IS TO BE REVISED 2011/02/26, after receiving tau_aero_err from John.
%         layerAODunc0=(a.toppluslayeraod_unccomp(i, 1)-a.topaod_unccomp(i, 1)).^2 ...
%             +0 ...
%             +a.toppluslayeraod_unccomp(i, 3).^2+a.topaod_unccomp(i, 3).^2 ...
%             +a.toppluslayeraod_unccomp(i, 4)-a.topaod_unccomp(i, 4)).^2 ...
%             +a.toppluslayeraod_unccomp(i, 5)-a.topaod_unccomp(i, 5)).^2 ...
%             +a.toppluslayeraod_unccomp(i, 6)-a.topaod_unccomp(i, 6)).^2 ...
%             +a.toppluslayeraod_unccomp(i, 7)-a.topaod_unccomp(i, 7)).^2 ...
%             +a.toppluslayeraod_unccomp(i, 8)-a.topaod_unccomp(i, 8)).^2 ...
%             +a.toppluslayeraod_unccomp(i, 9).^2+a.topaod_unccomp(i, 9).^2 ...
%             +0 ...
%             +0;
%         a.layeraod_unc(i,:)=sqrt(layerAODunc0);
%         !!!
        
        % uncertainty in the differential AOD interpolated to the HiGEAR wavelengths
        a.layeraodh_unc(i,:)=repmat(NaN,1,3);
        if length(okw)>2 & max(diff(okw))<=2;
            a.layeraodh_unc(i,:)=exp(interp1(log(aats.lambda(okw)), log(a.layeraod_unc(i,okw)), log([450 550 700]/1000)));
        end;

        % find the wavelengths with data
        okw=find(isfinite(a.topaod(i,:))==1);
        % top AOD interpolated to the HiGEAR wavelengths
        a.topaodh(i,:)=repmat(NaN,1,3);
        a.topaodh_unc(i,:)=repmat(NaN,1,3);
        if length(okw)>2 & max(diff(okw))<=2;
            a.topaodh(i,:)=exp(interp1(log(aats.lambda(okw)), log(a.topaod(i,okw)), log([450 550 700]/1000)));
            % uncertainty in the top AOD interpolated to the HiGEAR wavelengths
            a.topaodh_unc(i,:)=exp(interp1(log(aats.lambda(okw)), log(a.topaod_unc(i,okw)), log([450 550 700]/1000)));
        end;
        
        %***************************************
        % calculate full column AOD from HiGEAR data and AATS-14 top
        %***************************************
        higear.columnaod(i,:)=higear.layeraod(i,:)+a.topaodh(i,:)+higear.bottomext(i,:).*minalt/1e6; % don't use mean(tsineph1.alt(tsineph1.lorr)) in lieu of minalt. Remember, the higear.layeraod accounts for the layer down to the lowest point with the neph data. 
        higear.columnaod_aeronet(i,:)=higear.layeraod(i,:)+a.topaodh(i,:)+higear.bottomext(i,:).*(minalt-aeronetalt)/1e6; % don't use mean(tsineph1.alt(tsineph1.lorr)) in lieu of minalt. Remember, the higear.layeraod accounts for the layer down to the lowest point with the neph data. 
        % uncertainties
        higear.ext_unc(i,:)=abs(higear.layerabsaod_nephlambda(i,:).*0.2./higear.layeraod(i,:)); % 20% of absorption given as an uncertainty

        %***************************************
        % assess the spatial homogeneity in the bottom and top layers
        %***************************************
%                 a.lorr=find(aats.t>=times(i,1) & aats.t<=times(i,2) & aats.t>=timeslohi(1)-timeallowance/2 & aats.t<=timeslohi(1)+timeallowance/2 & aats.alt>=minalt-altallowance/2 & aats.alt<=minalt+altallowance/2 & sum(isfinite(aats.aod),2) & lorng<=maxrng & hirng<=maxrng); % stay in a small column
%                 a.hirr=find(aats.t>=times(i,1) & aats.t<=times(i,2) & aats.t>=timeslohi(2)-timeallowance/2 & aats.t<=timeslohi(2)+timeallowance/2 & aats.alt>=maxalt-altallowance/2 & aats.alt<=maxalt+altallowance/2 & sum(isfinite(aats.aod),2) & hirng<=maxrng & lorng<=maxrng); % stay in a small column

%         a.brr=find(aats.t>=times(i,1) & aats.t<=times(i,2) ...
%             & aats.t>=timeslohi(1)-layersampletime/2 ...
%             & aats.t<=timeslohi(1)+layersampletime/2 ...
%             & aats.alt>=minalt-layerthickness/2 ...
%             & aats.alt<=minalt+layerthickness/2 ...
%             & hirng<=layermaxrng ...
%             & lorng<=layermaxrng);
%         a.trr=find(aats.t>=times(i,1) & aats.t<=times(i,2) ...
%             & aats.t>=timeslohi(2)-layersampletime/2 ...
%             & aats.t<=timeslohi(2)+layersampletime/2 ...
%             & aats.alt>=maxalt-layerthickness/2 ...
%             & aats.alt<=maxalt+layerthickness/2 ...
%             & hirng<=layermaxrng ...
%             & lorng<=layermaxrng);
        a.brr=find(aats.t>=timeslohi(1)-layersampletime/2 ...
            & aats.t<=timeslohi(1)+layersampletime/2 ...
            & aats.alt>=minalt-layerthickness/2 ...
            & aats.alt<=minalt+layerthickness/2 ...
            & hirng<=layermaxrng ...
            & lorng<=layermaxrng);
        a.trr=find(aats.t>=timeslohi(2)-layersampletime/2 ...
            & aats.t<=timeslohi(2)+layersampletime/2 ...
            & aats.alt>=maxalt-layerthickness/2 ...
            & aats.alt<=maxalt+layerthickness/2 ...
            & hirng<=layermaxrng ...
            & lorng<=layermaxrng);
        f.sv(i,:)=[length(a.brr) length(a.trr)]; % flag: the numbers of AATS data in the bottom and top layers
        aod0_b_low(i,:)=repmat(NaN,1,q);
        aod0_b_upp(i,:)=repmat(NaN,1,q);
        f.minbrralt(i,:)=repmat(NaN,1,q);
        f.maxbrralt(i,:)=repmat(NaN,1,q);
        if length(a.brr)>1
            aod0_b_mean(i,:)=nanmean(aats.aod(a.brr,:));
            aod0_b_var(i,:)=nanstd(aats.aod(a.brr,:));
            aod0_b_unc(i,:)=nanmean(aats.u_aod(a.brr,:));
            aod0_b_rms(i,:)=sqrt(nanmean((aats.aod(a.brr,:)-repmat(a.toppluslayeraod(i,:),size(a.brr))).^2));
            aod0_b_min(i,:)=min(aats.aod(a.brr,:));
            aod0_b_max(i,:)=max(aats.aod(a.brr,:));
            for w=1:13;
                brrok=find(isfinite(aats.aod(a.brr,w))==1);
                if length(brrok>1);
                    aod0_b_low(i,w)=prctile(aats.aod(a.brr(brrok),w),15.8655);
                    aod0_b_upp(i,w)=prctile(aats.aod(a.brr(brrok),w),100-15.8655);
                    f.minbrralt(i,w)=min(aats.alt(a.brr(brrok)));
                    f.maxbrralt(i,w)=max(aats.alt(a.brr(brrok)));
                end;
            end;
        else
            aod0_b_mean(i,:)=repmat(NaN,1,q);
            aod0_b_var(i,:)=repmat(NaN,1,q);
            aod0_b_min(i,:)=repmat(NaN,1,q);
            aod0_b_max(i,:)=repmat(NaN,1,q);
            if length(a.brr)==1
                aod0_b_unc(i,:)=aats.u_aod(a.brr,:);
                aod0_b_rms(i,:)=abs(aats.aod(a.brr,:)-a.toppluslayeraod(i,:));
            else
                aod0_b_unc(i,:)=repmat(NaN,1,q);
                aod0_b_rms(i,:)=repmat(NaN,1,q);
            end;
        end;
        if length(a.trr)>1
            aod0_t_mean(i,:)=nanmean(aats.aod(a.trr,:));
            aod0_t_var(i,:)=nanstd(aats.aod(a.trr,:));
            aod0_t_unc(i,:)=nanmean(aats.u_aod(a.trr,:));
            aod0_t_min(i,:)=min(aats.aod(a.trr,:));
            aod0_t_max(i,:)=max(aats.aod(a.trr,:));
        else
            aod0_t_mean(i,:)=repmat(NaN,1,q);
            aod0_t_var(i,:)=repmat(NaN,1,q);
            aod0_t_min(i,:)=repmat(NaN,1,q);
            aod0_t_max(i,:)=repmat(NaN,1,q);
            if length(a.trr)==1
                aod0_t_unc(i,:)=aats.u_aod(a.trr,:);
            else
                aod0_t_unc(i,:)=repmat(NaN,1,q);
            end;
        end;
        aod0_b_cov(i,:)=aod0_b_var(i,:)./aod0_b_mean(i,:);
        zz=find(aod0_b_cov(i,:)==0);
        aod0_b_cov(i,zz)=1e-10;
        aod_b_cov(i,:)=exp(interp1(log(aats.lambda), log(aod0_b_cov(i,:)), log([450 550 700]/1000)));
        aod_b_rms(i,:)=exp(interp1(log(aats.lambda), log(aod0_b_rms(i,:)), log([450 550 700]/1000)));
        aod0_var(i,:)=sqrt(aod0_b_var(i,:).^2+aod0_t_var(i,:).^2);
        aod0_cov(i,:)=aod0_var(i,:)./(aod0_b_mean(i,:)-aod0_t_mean(i,:));
        aod_cov(i,:)=exp(interp1(log(aats.lambda), log(aod0_cov(i,:)), log([450 550 700]/1000)));
        aod_min(i,:)=exp(interp1(log(aats.lambda), log(aod0_b_min(i,:)-aod0_t_max(i,:)), log([450 550 700]/1000)));
        aod_max(i,:)=exp(interp1(log(aats.lambda), log(aod0_b_max(i,:)-aod0_t_min(i,:)), log([450 550 700]/1000)));
        aod_low(i,:)=exp(interp1(log(aats.lambda), log(aod0_b_low(i,:)-aod0_t_mean(i,:)), log([450 550 700]/1000)));
        aod_upp(i,:)=exp(interp1(log(aats.lambda), log(aod0_b_upp(i,:)-aod0_t_mean(i,:)), log([450 550 700]/1000)));

        f.minalt(i,:)=[nanmean(aats.alt(a.lorr,:)) min(tsineph1.alt(tsineph1.rr)) nanmean(tsineph1.alt(tsineph1.lorr))];
        f.maxalt(i,:)=[nanmean(aats.alt(a.hirr,:)) max(tsineph1.alt(tsineph1.rr)) ];
        % 10-km COV or 20-km (see parameters)
%         rr=find(sv.times(:,1)>=times(i,1)-sv.layersampletime/2 ...
%             & sv.times(:,2)<=times(i,2)+sv.layersampletime/2 ...
%             & mean(sv.alt,2)<=sv.maxalt); % sv.maxalt set to Inf at some point
        rr=find(sv.times(:,1)>=times(i,1)-sv.layersampletime/2 ...
            & sv.times(:,2)<=times(i,2)+sv.layersampletime/2 ...
            & mean(sv.alt,2)>=minalt-1000 & mean(sv.alt,2)<=minalt+1000); % sv.maxalt set to Inf at some point
        lrr(i,1)=length(rr);
        if lrr(i)>0;
            horicov(i,:)=nanmean1(sv.cov(rr,:));
            horicovh(i,:)=exp(interp1(log(aats.lambda), log(horicov(i,:)), log([450 550 700]/1000)));
        else
            horicov(i,:)=repmat(NaN, 1, size(sv.cov,2));
            horicovh(i,:)=repmat(NaN,1,3);
        end;

        %***************************************
        % estimate the bottom AOD using AATS
        %***************************************
        a.bottomaod(i,:)=repmat(NaN,1,q);
        a.columnaod(i,:)=repmat(NaN,1,q);
        a.bottomaod_aeronet(i,:)=repmat(NaN,1,q);
        a.columnaod_aeronet(i,:)=repmat(NaN,1,q);
        if a.minalt(i,1)<=2000;
            targetalt=a.minalt(i,1)*2;
            targetalt_aeronet=(a.minalt(i,1)-aeronetalt)*2+aeronetalt;
            rr2=find(aats.alt(a.rr)>=targetalt-50 & aats.alt(a.rr)<=targetalt+50);
            rr2_aeronet=find(aats.alt(a.rr)>=targetalt_aeronet-50 & aats.alt(a.rr)<=targetalt_aeronet+50);
            a.rr2=a.rr(rr2);
            a.rr2_aeronet=a.rr(rr2_aeronet);
            if length(rr2)==1;
                a.bottomaod(i,:)=a.toppluslayeraod(i,:)-aats.aod(a.rr2,:);
            elseif length(rr2)>1;
%                 for cc=1:size(aats.aod,2);
%                     aodcc=aats.aod(a.rr2,cc);
%                     isf=find(isfinite(aodcc)==1);
%                     if length(isf)>1;
%                         a.bottomaod(i,cc)=a.toppluslayeraod(i,cc)-interp1(aats.alt(a.rr2(isf)), aodcc(isf), targetalt);
%                     end;
%                 end;
                        a.bottomaod(i,:)=a.toppluslayeraod(i,:)-nanmean(aats.aod(a.rr2,:));
            end;
            a.columnaod(i,:)=a.toppluslayeraod(i,:)+a.bottomaod(i,:);
%             if length(rr2_aeronet)==1;
%                 a.bottomaod_aeronet(i,:)=a.toppluslayeraod(i,:)-aats.aod(a.rr2_aeronet,:);
%             elseif length(rr2_aeronet)>1;
%                 a.bottomaod_aeronet(i,:)=a.toppluslayeraod(i,:)-interp1(aats.alt(a.rr2_aeronet), aats.aod(a.rr2_aeronet,:), targetalt_aeronet);
%             end;
            a.bottomaod_aeronet(i,:)=a.bottomaod(i,:)./a.minalt(i,1)*(a.minalt(i,1)-aeronetalt);
            a.columnaod_aeronet(i,:)=a.toppluslayeraod(i,:)+a.bottomaod_aeronet(i,:);
            a.columnaod_aeronet_unc(i,:)=sqrt(a.toppluslayeraod_unc(i,:).^2+(bottomuncfrac*abs(a.bottomaod_aeronet(i,:))).^2);
        end;

        %***************************************
        % record miscellaneous data
        %***************************************
        allalt(i,:)=[minalt maxalt];
        f.altdiff(i,:)=maxalt-minalt; % flag: altitude gain/loss
        if ~isempty(a.rr);
            f.maxrng(i,:)=[max(hirng(a.rr)) max(lorng(a.rr))];
        end
        f.maxscaG(i,:)=max(tsineph1.ambcorTOTeG(tsineph1.rr)); % flag: maximum scattering
    end;
end;

%***************************************
% estimate the f(RH) uncertainty
%***************************************
higear.effrhlo=higear.rrneph3rh0./higear.rrneph3;
higear.effrhhi=higear.rrneph4rh0./higear.rrneph4;
if estimate_ambunc==1;
    estimate_gamma_uncertainty2;
end;
p=size(higear.layeraod,1);
% higearlayeraod_unc0=sqrt(repmat(higear.meas_unc,p,3).^2+repmat(higear.cor_unc,p,1).^2+repmat(higear.amb_unc,1,3).^2+higear.ext_unc.^2).*higear.layeraod; % fraction of uncertainty proportional to the AOD
higearlayeraod_unclo0=sqrt(repmat(higear.meas_unc,p,3).^2+repmat(higear.cor_unc,p,1).^2+repmat(higear.amb_unclo',1,3).^2+higear.ext_unc.^2).*higear.layeraod; % fraction of uncertainty proportional to the AOD
higearlayeraod_unchi0=sqrt(repmat(higear.meas_unc,p,3).^2+repmat(higear.cor_unc,p,1).^2+repmat(higear.amb_unchi',1,3).^2+higear.ext_unc.^2).*higear.layeraod; % fraction of uncertainty proportional to the AOD
% higear.layeraod_unc=sqrt(repmat(higear.noise,p,3).^2+higearlayeraod_unc0.^2);
higear.layeraod_unclo=sqrt(repmat(higear.noise,p,3).^2+higearlayeraod_unclo0.^2);
higear.layeraod_unchi=sqrt(repmat(higear.noise,p,3).^2+higearlayeraod_unchi0.^2);
if p==1
%     higear.columnaod_aeronet_unc=sqrt(higear.layeraod_unc.^2+a.topaodh_unc.^2+(bottomuncfrac.*higear.bottomext.*(minalt-aeronetalt)/1e6).^2);
    higear.columnaod_aeronet_unclo=sqrt(higear.layeraod_unclo.^2+a.topaodh_unc.^2+(bottomuncfrac.*higear.bottomext.*(minalt-aeronetalt)/1e6).^2);
    higear.columnaod_aeronet_unchi=sqrt(higear.layeraod_unchi.^2+a.topaodh_unc.^2+(bottomuncfrac.*higear.bottomext.*(minalt-aeronetalt)/1e6).^2);
end;

%***************************************
% estimate the fine-mode fraction using AATS
%***************************************
[a2,a1,a0]=polyfitAATSaod(a.layeraod);
a.layera210=[a2 a1 a0];
a.layeraodh=exp(a.layera210(:,1)*log([0.45 0.55 0.70]).^2+a.layera210(:,2)*log([0.45 0.55 0.70]).^1+a.layera210(:,3)*log([0.45 0.55 0.70]).^0);
higear.ratio2aats=higear.layeraod./a.layeraodh;
[a.layeraodfmf500, a.layeraodAf500, a.layeraodAng500, Ap]=polyfit2FMF(0.5,a2,a1);
!!! Norm's updated algorithm
for ii=1:size(a.layeraod,1);
    yy=a.layeraod(ii,:);
    okyy=find(isfinite(yy)==1);
    okyy=intersect(okyy, [2 3 4 7 9]);
    [tau(ii,1), alpha, alphap, t, tau_f(ii,1), alpha_f, alphap_f, tau_c(ii,1), eta(ii), regression_dtau, ...
        Dalpha, Dalphap, Dtau_f, Dalpha_f, Dtau_c, Deta] = tauf_tauc(yy(okyy), aats.lambda(okyy), length(okyy),'stan',...
        'y','y',0.01,0.5,2);
    yy=a.toppluslayeraod(ii,:);
    okyy=find(isfinite(yy)==1);
    okyy=intersect(okyy, [2 3 4 7 9]);
    [tau_toppluslayer(ii,1), alpha_toppluslayer, alphap_toppluslayer, t_toppluslayer, tau_f_toppluslayer(ii,1), alpha_f_toppluslayer, alphap_f_toppluslayer, tau_c_toppluslayer, eta_toppluslayer(ii), regression_dtau_toppluslayer, ...
        Dalpha_toppluslayer, Dalphap_toppluslayer, Dtau_f_toppluslayer, Dalpha_f_toppluslayer, Dtau_c_toppluslayer, Deta_toppluslayer] = tauf_tauc(yy(okyy), aats.lambda(okyy), length(okyy),'stan',...
        'y','y',0.01,0.5,2);
        yy=a.topaod(ii,:);
    okyy=find(isfinite(yy)==1);
    okyy=intersect(okyy, [2 3 4 7 9]);
    [tau_top(ii,1), alpha_top, alphap_top, t_top, tau_f_top(ii,1), alpha_f_top, alphap_f_top, tau_c_top, eta_top(ii), regression_dtau_top, ...
        Dalpha_top, Dalphap_top, Dtau_f_top, Dalpha_f_top, Dtau_c_top, Deta_top] = tauf_tauc(yy(okyy), aats.lambda(okyy), length(okyy),'stan',...
        'y','y',0.01,0.5,2);
        yy=a.columnaod_aeronet(ii,:);
    okyy=find(isfinite(yy)==1);
    okyy=intersect(okyy, [2 3 4 7 9]);
    [tau_columnaod_aeronet(ii,1), alpha_columnaod_aeronet, alphap_columnaod_aeronet, t_columnaod_aeronet, tau_f_columnaod_aeronet(ii,1), alpha_f_columnaod_aeronet, alphap_f_columnaod_aeronet, tau_c_columnaod_aeronet, eta_columnaod_aeronet(ii), regression_dtau_columnaod_aeronet, ...
        Dalpha_columnaod_aeronet, Dalphap_columnaod_aeronet, Dtau_f_columnaod_aeronet, Dalpha_f_columnaod_aeronet, Dtau_c_columnaod_aeronet, Deta_columnaod_aeronet] = tauf_tauc(yy(okyy), aats.lambda(okyy), length(okyy),'stan',...
        'y','y',0.01,0.5,2);
end;
a.layeraodfmf500=eta;
a.layeraodfmf500subtr=(tau_f_toppluslayer-tau_f_top)./(tau_toppluslayer-tau_top);
a.columnaod_aeronetfmf500=eta_columnaod_aeronet;
!!!
[a2,a1,a0]=polyfitAATSaod(a.columnaod);
[a.columnaodfmf500, Af, A, Ap]=polyfit2FMF(0.5,a2,a1);
[a2,a1,a0]=polyfitAATSaod(a.columnaod_aeronet);
a.columnaod_aeronet_a210=[a2 a1 a0];
% [a.columnaod_aeronetfmf500, Af, A, Ap]=polyfit2FMF(0.5,a2,a1);
if size(times,1)==1;
    [a2l,a1l,a0l]=polyfitAATSaod(aats.aod(a.rr,:));
    [layeraodfmfh500, Afl, Al, Apl]=polyfit2FMF(0.5,a2l,a1l);
end;

%***************************************
% estimate the submicron mode fraction
%***************************************
higear.layerdryaodsmf=higear.layerdryaod2(:,4:6)./higear.layerdryaod2(:,1:3);
higear.layerfrh=higear.layeraod./higear.layerdryaod;