function [vis_sun, nir_sun, aats]=staraatscompare(daystr, noonrow,loadaatsmat)
%%
% Purpose:
%   Function to compare aats and 4STAR values
%
% Input:
%   daystr: string of the date in format yyyymmdd
%   noonrow: row index at which to compare
%   loadaatsmat: boolean, default to true, if set true, will load aats file from mat, else will load from raw files
%
% Output:
%   vis_sun: modified vis_sun structure from the starsun file
%   nir_sun: modified nir_sun structure from the starsun file
%   aats: aats structure
%
% Modified: Samuel LeBlanc, v2.0, 2017-05-29, Hilo, Hawaii
%           added loadaatsmat varaible and function
%           added version_set for version control
%           added instrumentname for multi-instrument support
version_set('2.0')

if nargin<3;
    loadaatsmat = true;
end;

% load 4STAR

if ~exist(fullfile(starpaths, [daystr 'starsun.mat']));
    [fname,pname] = uigetfile2(['*' daystr '*starsun.mat'],['Find the correct starsun file for day:' daystr]);
    fp = [pname fname];
    [daystr, filen, datatype, instrumentname]=starfilenames2daystr({fname});
else
    fp = fullfile(starpaths, [daystr 'starsun.mat']);
    instrumentname = '4STAR';
end;
try
    s=load(fp, 't', 'w', 'rate', 'm_ray','tau_ray','m_aero','tau_aero', 'Lon','Lat','Alt','Tst','Pst','AZ_deg', 'El_deg', 'flag', 'filename', 'Str');
    t=s.t;
catch;
    load(fp);
    t=vis_sun.t;
end;

s.rate_nonray = s.rate ./ tr(s.m_ray, s.tau_ray);
% load AATS

% load(fullfile(starpaths, [daystr 'aats.mat'])); % from prepare_COAST_Oct2011.m    %     load(fullfile(paths,'4star\data\v1mat', 'AATSdata_05Jan12AA_V02.mat'));
if loadaatsmat;
    aats = load(getfullname(['*' daystr '*aats*.mat'],'aats_mats'));
else;
    
    aats = aats2matx;
    aats = cataats(aats,aats2matx);
    if ~exist('aats','var')
        aats.t=UT'/24+datenum(year,month,day);
    end;
    if ~isfield(aats,'t')
        aats.t=UT'/24+datenum(year,month,day);
    end
    % if floor(t(end))-floor(t(1))==1; % the 4STAR ran into the next day
    %     nextdaystr=datestr(datenum(str2num(daystr(1:4)),str2num(daystr(5:6)),str2num(daystr(7:8)))+1,30);
    %     nextdaystr=nextdaystr(1:8);
    %     nextdayaatsfile=fullfile(starpaths, [nextdaystr 'aats.mat']);
    %     if exist(nextdayaatsfile);
    %         a=load(nextdayaatsfile); % from prepare_COAST_Oct2011.m    %     load(fullfile(paths,'4star\data\v1mat', 'AATSdata_05Jan12AA_V02.mat'));
    %         if ~isfield(a,'aats') || ~isfield(a.aats,'t')
    %             a.t=a.UT'/24+datenum(a.year,a.month,a.day);
    %         end;
    %         aats.t=[aats.t; a.t];
    %         data=[data a.data];
    %         m_aero=[m_aero a.m_aero];
    %         m_ray=[m_ray a.m_ray];
    %         if isfield(a, 'tau_aero');
    %         tau_aero=[tau_aero a.tau_aero];
    %         tau_ray=[tau_ray a.tau_ray];
    %         tau=[tau a.tau];
    %         end;
    %         clear a;
    %     end;
    % end;
    % if ~exist('aats') | ~isfield(aats,'t')
    %     aats.t=UT'/24+datenum(year,month,day);
    % end;
    % aats.data=data';
    
    % aats.m_ray=m_ray;
    % aats.m_aero=m_aero;
    if exist('tau_aero');
        aats.tau_aero=tau_aero;
        aats.tau_ray=tau_ray;
        aats.tau=tau;
    end;
end;
[aats.w, aats.fwhm, aats.V0]=aatslambda;
qq=size(aats.w,2);

% [aats.sza, aaz, asoldst, aha, adec, ael, aam] = sunae(repmat(ames_lat,size(aats.t)), repmat(ames_lon,size(aats.t)), aats.t);

% load PREDE
% predefile=fullfile(starpaths, [daystr(3:8) '00prede.mat']);
% if exist(predefile);
%     load(predefile);
% end;
% if floor(vis_sun.t(end))-floor(vis_sun.t(1))==1; % the 4STAR ran into the next day
%     nextdaystr=datestr(datenum(str2num(daystr(1:4)),str2num(daystr(5:6)),str2num(daystr(7:8)))+1,30);
%     nextdaystr=nextdaystr(1:8);
%     predefilenextday=fullfile(starpaths, [nextdaystr(3:8) '00prede.mat']);
%     if exist(predefilenextday);
%         a=load(predefilenextday);
%         prede.t=[prede.t; a.prede.t];
%         prede.local_t=[prede.local_t; a.prede.local_t];
%         prede.az=[prede.az; a.prede.az];
%         prede.el=[prede.el; a.prede.el];
%         prede.signal=[prede.signal; a.prede.signal];
%         clear a;
%     end;
% end;
% if exist(predefile);
%     prede.t=prede.t+datenum([str2num(daystr(1:4))-1 12 31]);
% end;

% match 4STAR wavelengths to AATS
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(t(1),instrumentname);
if ~exist('vis_sun')
    if ~strcmp(instrumentname,'2STAR');
        c=[visc(1:10) nirc(11:13)+1044 NaN];
        crange=[viscrange(:,1:10) nircrange(:,11:13)+1044 NaN(2,1)];
        end_num = 13;
    else;
        c=[visc(1:10) NaN NaN NaN NaN];
        crange=[viscrange(:,1:10) NaN(2,4)];
        end_num = 10;
    end;
    cok=find(isfinite(c)==1);
    
    % get the ratios without normalizing
    pp=size(s.rate,1);
    s.rateratiotoaats=repmat(NaN, pp, qq);
    s.rateratiorangetoaats=repmat(NaN, pp, qq);
    s.aatsw=aats.w;
    rateratio=repmat(NaN, size(aats.data,2), qq);
    rateratiorange=repmat(NaN, size(aats.data,2), qq);
    aatsrate=repmat(NaN, size(aats.data,2), qq); aats_tau_ray = aatsrate;
    combined=repmat(NaN, pp, qq);
    index(:,1)=ceil(interp1(s.t,1:pp,aats.t-3/86400/2));
    index(:,2)=floor(interp1(s.t,1:pp,aats.t+3/86400/2));
    s.rate(s.Str==0,:)=NaN; % Yohei, 2012/12/19
    aatsrate(:,cok)=avgvec(s.rate_nonray(:,c(cok)), index);
    aats_m_ray = interp1(s.t, s.m_ray,aats.t);
    for cc = 1:end_num
        aats_tau_ray(:,cc) = interp1(s.t, s.tau_ray(:,c(cc)), aats.t);
    end
    aats.data_noray = aats.data ./ tr(aats_m_ray',aats_tau_ray)';
    
    difft=[diff(aats.t)';1];
    for i=1:length(cok);
        wi=cok(i);
        combined(:,wi)=nanmean(s.rate_nonray(:,crange(1,wi):crange(2,wi))')'; % radiance averaged over adjacent pixels, to match the AATS wavelength width
        s.rateratiotoaats(:,wi)=s.rate_nonray(:,c(wi))./interp1(aats.t(difft>0),aats.data_noray(wi,difft>0)',s.t);
        s.rateratiorangetoaats(:,wi)=combined(:,wi)./interp1(aats.t(difft>0),aats.data_noray(wi,difft>0)',s.t);
        if isfield(s,'tau_aero') & isfield(aats, 'tau_aero');
            s.dtau_aero(:,wi)=s.tau_aero(:,c(wi))-interp1(aats.t(difft>0),aats.tau_aero(wi,difft>0)',s.t);
            s.trratio(:,wi)=exp(-s.dtau_aero(:,wi).*interp1(aats.t(difft>0), aats.m_aero(difft>0)', s.t));
        end;
    end;
    [aatsraterange, sn]=avgvec(combined, index);
    rateratio(:,cok)=aatsrate(:,cok)./aats.data(cok,:)';
    rateratiorange(:,cok)=aatsraterange(:,cok)./aats.data(cok,:)';
    s.c=[crange(1,:);c;crange(2,:)];
    
    % smooth, normalize and calculate OD differences
    %     s.bl=10/86400;
    s.bl=60/86400; !!!
    rateratiotoaats=s.rateratiotoaats;
    rateratiorangetoaats=s.rateratiorangetoaats;
    if s.bl>0;
        for i=1:qq;
            rateratiotoaats(:,i)=boxxfilt(s.t,s.rateratiotoaats(:,i),s.bl);
            rateratiorangetoaats(:,i)=boxxfilt(s.t,s.rateratiorangetoaats(:,i),s.bl);
        end;
    end;
    v=datevec(s.t);
    [s.sunaz, s.sunel, refract]=sun(s.Lon, s.Lat,v(:,3), v(:,2), v(:,1), rem(s.t,1)*24,s.Tst+273.15,s.Pst);
    s.sza=90-s.sunel;
    [s.m_ray, s.m_aero, s.m_H2O]=airmasses(s.sza, s.Alt);
    if nargin<2;
        isf=sum(isfinite(rateratiotoaats),2);
        isfok=find(isf==max(isf)); % This method does not always avoid NaN, but almost always.
        %         isfok=find(isf==max(isf) & sum(s.flag,2)==0); % This method does not always avoid NaN, but almost always.
        [dummy, s.noonrow]=min(s.m_ray(isfok)); % find solar noon
        s.noonrow=isfok(s.noonrow);
        clear isf isfok;
    else
        s.noonrow=noonrow;
    end;
    s.raterelativeratiotoaats=rateratiotoaats./repmat(rateratiotoaats(s.noonrow,:),pp,1);
    %     s.dod=-log(s.raterelativeratiotoaats)./repmat(s.m_aero,1,qq);
    s.raterelativeratiorangetoaats=rateratiorangetoaats./repmat(rateratiorangetoaats(s.noonrow,:),pp,1);
    %     s.dodrange=-log(s.raterelativeratiorangetoaats)./repmat(s.m_aero,1,qq);
    
    % store the new variables
    aats.starvisrate=aatsrate;
    aats.starvisrateratio=rateratio;
    aats.starvisrateratiorange=rateratiorange;
    
    vis_sun=s;
    nir_sun=[];
else
    for k=1:2;
        if k==1;
            s=vis_sun;
            c=visc;
            crange=viscrange;
        elseif k==2;
            s=nir_sun;
            c=nirc;
            crange=nircrange;
        end;
        cok=find(isfinite(c)==1);
        
        % get the ratios without normalizing
        pp=size(s.rate,1);
        s.rateratiotoaats=repmat(NaN, pp, qq);
        s.rateratiorangetoaats=repmat(NaN, pp, qq);
        s.aatsw=aats.w;
        rateratio=repmat(NaN, size(data,2), qq);
        rateratiorange=repmat(NaN, size(data,2), qq);
        aatsrate=repmat(NaN, size(data,2), qq);
        combined=repmat(NaN, pp, qq);
        index(:,1)=ceil(interp1(s.t,1:pp,aats.t-3/86400/2));
        index(:,2)=floor(interp1(s.t,1:pp,aats.t+3/86400/2));
        aatsrate(:,cok)=avgvec(s.rate(:,c(cok)), index);
        difft=[diff(aats.t)';1];
        for i=1:length(cok);
            wi=cok(i);
            combined(:,wi)=nanmean(s.rate(:,crange(1,wi):crange(2,wi))')'; % radiance averaged over adjacent pixels, to match the AATS wavelength width
            s.rateratiotoaats(:,wi)=s.rate(:,c(wi))./interp1(aats.t(:),data(wi,:)',s.t);
            s.rateratiorangetoaats(:,wi)=combined(:,wi)./interp1(aats.t(:),data(wi,:)',s.t);
            if isfield(s,'tau_aero') & isfield(aats, 'tau_aero');
                s.dtau_aero(:,wi)=s.tau_aero(:,c(wi))-interp1(aats.t(difft>0),aats.tau_aero(wi,difft>0)',s.t);
                s.trratio(:,wi)=exp(-s.dtau_aero(:,wi).*interp1(aats.t(difft>0), aats.m_aero(difft>0)', s.t));
            end;
        end;
        [aatsraterange, sn]=avgvec(combined, index);
        rateratio(:,cok)=aatsrate(:,cok)./data(cok,:)';
        rateratiorange(:,cok)=aatsraterange(:,cok)./data(cok,:)';
        s.c=[crange(1,:);c;crange(2,:)];
        
        % smooth, normalize and calculate OD differences
        s.bl=10/86400;
        rateratiotoaats=s.rateratiotoaats;
        rateratiorangetoaats=s.rateratiorangetoaats;
        if s.bl>0;
            for i=1:qq;
                rateratiotoaats(:,i)=boxxfilt(s.t,s.rateratiotoaats(:,i),s.bl);
                rateratiorangetoaats(:,i)=boxxfilt(s.t,s.rateratiorangetoaats(:,i),s.bl);
            end;
        end;
        v=datevec(s.t);
        [s.sunaz, s.sunel, refract]=sun(s.Lon, s.Lat,v(:,3), v(:,2), v(:,1), rem(s.t,1)*24,s.Tst+273.15,s.Pst);
        s.sza=90-s.sunel;
        [s.m_ray, s.m_aero, s.m_H2O]=airmasses(s.sza, s.Alt);
        if nargin<2;
            isf=sum(isfinite(rateratiotoaats),2);
            isfok=find(isf==max(isf)); % This method does not always avoid NaN, but almost always.
            %         isfok=find(isf==max(isf) & sum(s.flag,2)==0); % This method does not always avoid NaN, but almost always.
            [dummy, s.noonrow]=min(s.m_ray(isfok)); % find solar noon
            s.noonrow=isfok(s.noonrow);
            clear isf isfok;
        else
            s.noonrow=noonrow;
        end;
        s.raterelativeratiotoaats=rateratiotoaats./repmat(rateratiotoaats(s.noonrow,:),pp,1);
        s.dod=-log(s.raterelativeratiotoaats)./repmat(s.m_aero,1,qq);
        s.raterelativeratiorangetoaats=rateratiorangetoaats./repmat(rateratiorangetoaats(s.noonrow,:),pp,1);
        s.dodrange=-log(s.raterelativeratiorangetoaats)./repmat(s.m_aero,1,qq);
        
        %     if exist('prede')==1 & w==4;
        %         s.rateratiotoprede(:,w)=s.rate(:,c(4))./interp1(prede.t(prede.ok),prede.signal(prede.ok,3),s.t);
        %         s.rateratiorangetoprede=data(4,:)'./interp1(prede.t(prede.ok),prede.signal(prede.ok,3),aats.t);
        %     end;
        % store the new variables
        if k==1;
            vis_sun=s;
            aats.starvisrate=aatsrate;
            aats.starvisrateratio=rateratio;
            aats.starvisrateratiorange=rateratiorange;
        elseif k==2;
            nir_sun=s;
            aats.starnirrate=aatsrate;
            aats.starnirrateratio=rateratio;
            aats.starnirrateratiorange=rateratiorange;
        end;
    end
end;
