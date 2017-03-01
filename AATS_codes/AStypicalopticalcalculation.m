tsineph1.ang=sca2angstrom([tsineph1.TOTtsB tsineph1.TOTtsG tsineph1.TOTtsR],[45 55 70]);
tsineph1.corang=sca2angstrom([tsineph1.corTOTtsB tsineph1.corTOTtsG tsineph1.corTOTtsR],[45 55 70]);
tsineph1.corangBG=sca2angstrom([tsineph1.corTOTtsB tsineph1.corTOTtsG], [450 550]);
tsineph1.corangGR=sca2angstrom([tsineph1.corTOTtsG tsineph1.corTOTtsR], [550 700]);
tsineph1.corTOTts470=tsineph1.corTOTtsB.*(450/470).^tsineph1.corangBG;
tsineph1.corTOTts530=tsineph1.corTOTtsG.*(550/530).^tsineph1.corangBG;
tsineph1.corTOTts660=tsineph1.corTOTtsR.*(700/660).^tsineph1.corangGR;
if length(tsineph1.t)==length(air.t) & max(abs(tsineph1.t-air.t))==0
    tsineph1.lon=air.lon;
    tsineph1.lat=air.lat;
    tsineph1.alt=air.alt;
    if isfield(air, 'C_RelHumidityWater____');
        tsineph1.ambrh=air.C_RelHumidityWater____;
    elseif isfield(air, 'C_RelHumidityWater_');
        tsineph1.ambrh=air.C_RelHumidityWater_;
    elseif isfield(air, 'C_RelHumidityWater');
        tsineph1.ambrh=air.C_RelHumidityWater;
    end;
    rrneph3.lon=air.lon;
    rrneph3.lat=air.lat;
    rrneph3.alt=air.alt;
    rrneph4.lon=air.lon;
    rrneph4.lat=air.lat;
    rrneph4.alt=air.alt;

else
    tsineph1.lon=interp1(air.t, air.lon, tsineph1.t);
    tsineph1.lat=interp1(air.t, air.lat, tsineph1.t);
    tsineph1.alt=interp1(air.t, air.alt, tsineph1.t);
    if isfield(air, 'C_RelHumidityWater____');
        tsineph1.ambrh=interp1(air.t, air.C_RelHumidityWater____, tsineph1.t);
    elseif isfield(air, 'C_RelHumidityWater_');
        tsineph1.ambrh=interp1(air.t, air.C_RelHumidityWater_, tsineph1.t);
    elseif isfield(air, 'C_RelHumidityWater');
        tsineph1.ambrh=interp1(air.t, air.C_RelHumidityWater, tsineph1.t);
    end;
    rrneph3.lon=interp1(air.t, air.lon, rrneph3.t);
    rrneph3.lat=interp1(air.t, air.lat, rrneph3.t);
    rrneph3.alt=interp1(air.t, air.alt, rrneph3.t);
    rrneph4.lon=interp1(air.t, air.lon, rrneph4.t);
    rrneph4.lat=interp1(air.t, air.lat, rrneph4.t);
    rrneph4.alt=interp1(air.t, air.alt, rrneph4.t);
end;
    
% scat humidity correction
%     method=1; !!!!!!!!!!!!!!!!!
    method=2; 
    nif=find(isfinite(rrneph3.TOTts)==0); % updated 2009/12/05 
    rrneph3.TOTts(nif)=rrneph3.SUBts(nif);
    nif=find(isfinite(rrneph4.TOTts)==0);
    rrneph4.TOTts(nif)=rrneph4.SUBts(nif);
    if method==2;
    bl=10/86400;
    scatratio=boxxfilt(rrneph4.t,rrneph4.TOTts,bl)./boxxfilt(rrneph3.t,rrneph3.TOTts,bl);
    elseif method==1;
    scatratio=rrneph4.TOTts./rrneph3.TOTts;
    end;
    %         if isfield(rrneph4, 'SUBts') & isfield(rrneph3, 'SUBts');
    %         scatratiosub=rrneph4.SUBts./rrneph3.SUBts; % use submicron ; for the day 174 (Flight #11) most of the day 184 also have submicron records only
    %         else
    %             scatratiosub=repmat(NaN,size(scatratio));
    %         end;
    %         swapthem=find(isnan(scatratio)==1 & isnan(scatratiosub)==0);
    %         if ~isempty(swapthem);
    %             warning('Use submicron gamma instead of total (this happens for Flights #11 and #18).');
    %             scatratio(swapthem)=scatratiosub(swapthem);
    %         end;
    if method==1;
        scatratio(find(scatratio<1))=1;
    end;
    pare=(1-rrneph4.rh/100)./(1-rrneph3.rh/100);
    gamma=-log10(scatratio)./log10(pare);
    if method==2;
        gammaok=find(scatratio>=1 & rrneph3.TOTts>=1 & rrneph4.TOTts>=1 & isfinite(tsineph1.t)==1);
        gamma=interp1(tsineph1.t(gammaok),gamma(gammaok),tsineph1.t);
    end;
    frh=((1-tsineph1.ambrh/100)./(1-tsineph1.rh/100)).^(-gamma);
    frh(find(tsineph1.ambrh>=100 | tsineph1.ambrh<=0))=NaN; 
    if method==2;
        frh(find(tsineph1.rh>tsineph1.ambrh))=1;
    elseif method==1;
        frh(find(scatratio<1 | tsineph1.rh>tsineph1.ambrh))=1;
    end;
    tsineph1.ambcorTOTtsB=tsineph1.corTOTtsB.*frh; % note that frh is assumed to be independent of wavelength, which is false for small particles under humid conditions
    tsineph1.ambcorTOTtsG=tsineph1.corTOTtsG.*frh; % note that frh is assumed to be independent of wavelength, which is false for small particles under humid conditions
    tsineph1.ambcorTOTtsR=tsineph1.corTOTtsR.*frh; % note that frh is assumed to be independent of wavelength, which is false for small particles under humid conditions
    tsineph1.angBG=sca2angstrom([tsineph1.ambcorTOTtsB tsineph1.ambcorTOTtsG], [450 550]);
    tsineph1.angGR=sca2angstrom([tsineph1.ambcorTOTtsG tsineph1.ambcorTOTtsR], [550 700]);
    tsineph1.ambcorTOTts470=tsineph1.ambcorTOTtsB.*(450/470).^tsineph1.angBG;
    tsineph1.ambcorTOTts530=tsineph1.ambcorTOTtsG.*(550/530).^tsineph1.angBG;
    tsineph1.ambcorTOTts660=tsineph1.ambcorTOTtsR.*(700/660).^tsineph1.angGR;
    
    % absorption wavelength adjustments
%     psap1.ang=sca2angstrom([psap1.TOTaB psap1.TOTaG psap1.TOTaR],[47 53 66]);
%     psap1.angBG=sca2angstrom([psap1.TOTaB psap1.TOTaG],[47 53]);
%     psap1.angGR=sca2angstrom([psap1.TOTaG psap1.TOTaR],[53 66]);
%     psap1.TOTa450=psap1.TOTaB.*(470/450).^psap1.angBG;
%     psap1.TOTa550=psap1.TOTaG.*(530/550).^psap1.angBG;
%     psap1.TOTa700=psap1.TOTaR.*(660/700).^psap1.angGR;
%     
    % dry uncorrected SSA
%     tsineph1.ssaB=tsineph1.TOTtsB./(tsineph1.TOTtsB+psap1.TOTa450);
%     tsineph1.ssaG=tsineph1.TOTtsG./(tsineph1.TOTtsG+psap1.TOTa550);
%     tsineph1.ssaR=tsineph1.TOTtsR./(tsineph1.TOTtsR+psap1.TOTa700);
%     tsineph1.ssaang=sca2angstrom([tsineph1.ssaB tsineph1.ssaG tsineph1.ssaR],[450 550 700]);
    
    % absorption filter and scattering corrections
    if ~exist('higearver');
        higearver=3;
    end;
    if higearver>=3;
        psap1.corTOTaB=psap1.TOTaB_Virk;
        psap1.corTOTaG=psap1.TOTaG_Virk;
        psap1.corTOTaR=psap1.TOTaR_Virk;
    elseif higearver==1; % a poor substitute for the Virkkula correction
        psap1.corTOTaB=psap1.TOTaB*0.75; !!!
        psap1.corTOTaG=psap1.TOTaG*0.7; !!!
        psap1.corTOTaR=psap1.TOTaR*0.7; !!!
    end;
    psap1.corang=sca2angstrom([psap1.corTOTaB psap1.corTOTaG psap1.corTOTaR],[47 53 66]);
    psap1.corangBG=sca2angstrom([psap1.corTOTaB psap1.corTOTaG],[47 53]);
    psap1.corangGR=sca2angstrom([psap1.corTOTaG psap1.corTOTaR],[53 66]);
    psap1.corangBG(find(imag(psap1.corangBG)~=0))=1.2;
    psap1.corangBG(find(psap1.corangBG>4))=4;
    psap1.corangBG(find(psap1.corangBG<0))=0;
    psap1.corangGR(find(imag(psap1.corangGR)~=0))=1.2;
    psap1.corangGR(find(psap1.corangGR>4))=4;
    psap1.corangGR(find(psap1.corangGR<0))=0;
    zeroitB=find(psap1.corTOTaB<0);
    zeroitG=find(psap1.corTOTaG<0);
    zeroitR=find(psap1.corTOTaR<0);
%     zeroitB=[]; !!! for taking integrating vertically. 2009/12/03.
%     zeroitG=[];
%     zeroitR=[];
    psap1.corTOTa450=psap1.corTOTaB.*(470/450).^psap1.corangBG;
    psap1.corTOTa550=psap1.corTOTaG.*(530/550).^psap1.corangBG;
    psap1.corTOTa700=psap1.corTOTaR.*(660/700).^psap1.corangGR;

    % dry corrected SSA
    tsineph1.corssaB=tsineph1.corTOTtsB./(tsineph1.corTOTtsB+psap1.corTOTa450);
    tsineph1.corssaB(zeroitB)=1;
    tsineph1.corssaG=tsineph1.corTOTtsG./(tsineph1.corTOTtsG+psap1.corTOTa550);
    tsineph1.corssaG(zeroitG)=1;
    tsineph1.corssaR=tsineph1.corTOTtsR./(tsineph1.corTOTtsR+psap1.corTOTa700);
    tsineph1.corssaR(zeroitR)=1;
%     tsineph1.corssaang=sca2angstrom([tsineph1.corssaB tsineph1.corssaG tsineph1.corssaR],[450 550 700]);

    % get extinction
    tsineph1.corTOTeB=tsineph1.corTOTtsB+psap1.corTOTa450;
    tsineph1.corTOTeB(zeroitB)=tsineph1.corTOTtsB(zeroitB);
    tsineph1.corTOTeG=tsineph1.corTOTtsG+psap1.corTOTa550;
    tsineph1.corTOTeG(zeroitG)=tsineph1.corTOTtsG(zeroitG);
    tsineph1.corTOTeR=tsineph1.corTOTtsR+psap1.corTOTa700;
    tsineph1.corTOTeR(zeroitR)=tsineph1.corTOTtsR(zeroitR);
    tsineph1.coreang=sca2angstrom([tsineph1.corTOTeB tsineph1.corTOTeG tsineph1.corTOTeR],[45 55 70]);
    tsineph1.corTOTe470=tsineph1.corTOTts470+psap1.corTOTaB;
    tsineph1.corTOTe530=tsineph1.corTOTts530+psap1.corTOTaG;
    tsineph1.corTOTe660=tsineph1.corTOTts660+psap1.corTOTaR;
    tsineph1.ambcorTOTeB=tsineph1.ambcorTOTtsB+psap1.corTOTa450;
    tsineph1.ambcorTOTeB(zeroitB)=tsineph1.ambcorTOTtsB(zeroitB);
    tsineph1.ambcorTOTeG=tsineph1.ambcorTOTtsG+psap1.corTOTa550;
    tsineph1.ambcorTOTeG(zeroitG)=tsineph1.ambcorTOTtsG(zeroitG);
    tsineph1.ambcorTOTeR=tsineph1.ambcorTOTtsR+psap1.corTOTa700;
    tsineph1.ambcorTOTeR(zeroitR)=tsineph1.ambcorTOTtsR(zeroitR);
    tsineph1.ambcorang=sca2angstrom([tsineph1.ambcorTOTeB tsineph1.ambcorTOTeG tsineph1.ambcorTOTeR],[45 55 70]);
    tsineph1.ambcorTOTe470=tsineph1.ambcorTOTts470+psap1.corTOTaB;
    tsineph1.ambcorTOTe530=tsineph1.ambcorTOTts530+psap1.corTOTaG;
    tsineph1.ambcorTOTe660=tsineph1.ambcorTOTts660+psap1.corTOTaR;

    % ambient corrected SSA
    tsineph1.ambcorssaB=tsineph1.ambcorTOTtsB./tsineph1.ambcorTOTeB;
    tsineph1.ambcorssaG=tsineph1.ambcorTOTtsG./tsineph1.ambcorTOTeG;
    tsineph1.ambcorssaR=tsineph1.ambcorTOTtsR./tsineph1.ambcorTOTeR;
    
    tsineph1.ambcorssa470=tsineph1.ambcorTOTts470./tsineph1.ambcorTOTe470;
    tsineph1.ambcorssa530=tsineph1.ambcorTOTts530./tsineph1.ambcorTOTe530;
    tsineph1.ambcorssa660=tsineph1.ambcorTOTts660./tsineph1.ambcorTOTe660;
