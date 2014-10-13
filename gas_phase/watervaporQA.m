function [QA watervapor800_1100] = watervaporQA(cwv)
% this function output QA for water vapor product
%------------------------------------------------
% MS, Mar 2014
%------------------------------------------------
% calc avg
watervapor800_1100 = nanmean([cwv.cwv800 cwv.cwv1100],2);
watervapor940_1100 = nanmean([cwv.cwv800 cwv.cwv1100],2);
wvstd              = nanstd ([cwv.cwv800 cwv.cwv1100],[],2);    % thershold=0.05/0.1
%wvrelstd           = (wvstd./watervapor800_1100)*100;
resirel800         = cwv.resi800./cwv.cwv800;                   % threshold = 0.05/0.1
resirel940         = cwv.resi940./cwv.cwv940;                   % threshold = 0.05/0.1
resirel1100        = cwv.resi1100./cwv.cwv1100;                 % threshold = 0.05/0.1
%
% QA flags
% QA=0: std<0.05 && threshold<0.05 (both bands)
% QA=1: std>0.05 && threshold<0.05 (both bands)
% QA=2: std>0.05 && threshold<0.05 (at least for one band)
% QA=3: std>0.05 && threshold>0.05 (both bands)
%--------------------------------------------------

QA = NaN(length(cwv.cwv800),1);
for i=1:length(cwv.cwv800)
    if isNaN(wvstd(i))
        QA(i) = NaN;
    elseif wvstd(i)<=0.05 && resirel800(i)<=0.05 && resirel1100(i)<=0.05
        QA(i)=0;
    elseif wvstd(i)>0.05 && resirel800(i)<=0.05 && resirel1100(i)<=0.05
        QA(i)=1;
    elseif (wvstd(i)>0.05 && resirel800(i)<=0.05) || (wvstd(i)>0.05 && resirel1100(i)<=0.05)
        QA(i)=2;
    elseif wvstd(i)>0.05 && resirel800(i)>0.05 && resirel1100(i)>0.05
        QA(i)=3;
    end
    
end