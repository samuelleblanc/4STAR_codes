function    [forjcorr, forjunc, forjnote]=starFORJcorrection(t, Az_deg, spec)

% calculates 4STAR FORJ correction factor. spec must be either 'VIS' or
% 'NIR'. Changes in the FORJ correction factors should be reflected in this
% code, and all other 4STAR codes should obtain the correction factor from
% this code. 
% Yohei, 2012/04/04
% SL, v1.0, 2014/10/13, added version control of this m script via version_set
version_set('1.0');
!!! but how do you get the factor for non-AATS wavelengths?
!!! return uncertainty associated with this correction.

if t<inf;
    forjnote='No FORJ correction applied. The FORJ impact is either unpredictable or non-existent.';
    if isequal(lower(spec), 'vis');
        forjcorr=ones(length(t),1044);
    elseif isequal(lower(spec), 'nir');
        forjcorr=ones(length(t),512);
    else; % VIS and NIR combined
        forjcorr=ones(length(t),1044+512);
    end;
    forjunc=forjcorr*0;
else
    load(fullfile(paths, '4star','star20120307FORJcorrfactors.mat'));
    !!! this is being re-done, with sine curve fitting.
    [visc,nirc]=starchannelsatAATS; !! pre-save this info
    if isequal(lower(spec), 'vis');
        cc0=1:10; % exclude the noisy eleventh comparison from 20120307.
        cc=interp1(visc(cc0), cc0, 1:1044,'nearest');
        cc(1:(min(find(isfinite(cc)==1))-1))=min(cc0);
        cc((max(find(isfinite(cc)==1))+1):end)=max(cc0);
        corr=corrfac(:, cc);
    elseif isequal(lower(spec), 'nir');
        corr=ones(length(az),512);
        !!! I should have saved the NIR comparisons at two more channels.
    end;

pp=size(Az_deg,1);
qq=size(corr,2);
forjcorr=repmat(NaN,pp,qq);
forjunc=repmat(NaN,pp,qq);

multiplier0=interp1([az(1)*2-az(2) az az(end)*2-az(end-1)],0:length(az)+1,mod(Az_deg,360));
multiplier1=zeros(qq,length(az));
multiplier2=zeros(qq,length(az));
mflo=floor(multiplier0);
for ii=1:length(az);
    rr=find(mflo==ii);
    if ii==length(az);
        rr=find(mflo==0 | mflo==ii);
    end;
    multiplier1(rr,ii)=mflo(rr)+1-multiplier0(rr);
    multiplier2(rr,ii)=multiplier0(rr)-mflo(rr);
end;
clear ii rr;
multiplier2=multiplier2(:,[end 1:end-1]);
forjcorr=(multiplier1+multiplier2)*corr;
end;

% lines below represent a more straightforward but time-consuming method
% for cc=1:size(corr,2)
%     forjcorr(:,cc)=interp1(az,corr(:,cc),Az_deg);
% end;







% lines below are used one time for deriving correction factors from FORJ
% tests. First open a figure containing normalized 4STAR/AATS values averaged
% over AZ deg mod 360 bins.
% additionalanalysis=0;
% savefigure=0;
% if additionalanalysis
%     % get original data (binned averages)
%     xx=get(gco,'xdata');
%     yy=get(gco,'ydata');
%     
%     % get a collection of sine curves
%     A=0:0.001:0.02;
%     phase=(0:359)*2*pi./360;
%     k=2*pi/360;
%     offset=1;
%     yfit0=sin(repmat(-k.*xx,length(phase),1)+repmat(phase(:),1,length(xx)));
%     for i=1:length(A);
%         yfit=A(i)*yfit0+offset;
%         deltaysq=(repmat(yy,length(phase),1)-yfit).^2;
%         [sortdeltaysq, sorti]=sort(deltaysq,2);
%         cumsumdeltaysq=cumsum(sortdeltaysq')';
%         rmseall(:,:,i)=sqrt(cumsumdeltaysq./repmat(1:length(xx),length(phase),1));
%         xxall(:,:,i)=repmat(xx,length(phase),1);
%         phaseall(:,:,i)=repmat(phase(:),1,length(xx));
%         Aall(:,:,i)=repmat(A(i), length(phase),length(xx));
%     end;
%     
%     cc=length(xx)
%     rmsecc=reshape(rmseall(:,cc,:), [length(phase) length(A)]);
%     xxcc=reshape(xxall(:,cc,:),[length(phase) length(A)]);
%     phasecc=reshape(phaseall(:,cc,:),[length(phase) length(A)]);
%     Acc=reshape(Aall(:,cc,:),[length(phase) length(A)]);
%     
%     % plot
%     figure;
%     [minrmsecc,minr]=min(rmsecc(:));
%     minyfit=Acc(minr).*yfit0(find(phasecc(minr)==phase),:)+offset;
%     [sh,filename]=scattery(phasecc(:), 'Phase', ...
%         Acc(:), 'Amplitude', ...
%         ones(size(Acc(:)))*12, '', ...
%         rmsecc(:), 'RMSe', ...
%         'xlim',[0 2*pi], 'xtick', (0:0.25:1)*2*pi);
%     hold on
%     plot(phasecc(minr), Acc(minr), '.g', 'markersize',24);
%     if savefigure;
%         sssssas(['starfittingerrorat' 'cc' num2str(cc) '.fig, starFORJcorrection.m']);
%     end;
%     
%     figure;
%     ph=plot(xx,minyfit, 'og', xx,yy, '-or','linewidth',2);
%     set(ph(1), 'markersize',6);
%     ggla;
%     grid on;
%     lh=legend([num2str(Acc(minr)) 'sin(-2\pi/360(x-' num2str(phasecc(minr)*360/2/pi) '))+' num2str(offset) ', RMSe = ' num2str(minrmsecc, '%0.4f')]);
%     set(lh,'fontsize',12);
%     xlim([-5 365]);
%     set(gca,'xtick',0:90:360);
%     xlabel('AZ deg mod 360');
%     ylabel('4STAR/AATS Ratio, 0-10 deg = 1');
%     if savefigure;
%         sssssas(['starfitsanddata' 'cc' num2str(cc) 'minr' num2str(minr) '.fig, starFORJcorrection.m']);
%     end;
%     
%         figure;
%     ph=plot(xx,minyfit-yy, '-og', 'linewidth',2);
%     set(ph(1), 'markersize',6);
%     ggla;
%     grid on;
%     lh=legend(['fit=' num2str(Acc(minr)) 'sin(-2\pi/360(x-' num2str(phasecc(minr)*360/2/pi) '))+' num2str(offset) ', RMSe = ' num2str(minrmsecc, '%0.4f')]);
%     set(lh,'fontsize',12);
%     xlim([-5 365]);
%     hold on;
%     plot(xlim, [0 0], '-k');
%     set(gca,'xtick',0:90:360);
%     xlabel('AZ deg mod 360');
%     ylabel('Fit - Measurements');
%     if savefigure;
%         sssssas(['starfitsanddata' 'cc' num2str(cc) 'minr' num2str(minr) 'diff.fig, starFORJcorrection.m']);
%     end;
% end;