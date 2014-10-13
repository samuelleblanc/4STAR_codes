function legend_string=setspectrumcolor(plot_axes, wavelengths, prec)

% set the color of the existing plot (specified with the input plot_axes)
% to the corresponding wavelengths. Warning: for wavelengths close to each
% other, the resulting lines will be discernible.
% Yohei, 2012/04/22

% control input
if min(wavelengths)>=100; % assume nm as unit, not um
    lambda=wavelengths/1000;
    unit='nm';
    if nargin<3
        prec='%0.1f';
    end;
else
    lambda=wavelengths;
    unit='\mum';
    if nargin<3
        prec='%0.3f';
    end;
end;
p=size(wavelengths,2);
if numel(plot_axes)~=p && numel(plot_axes)~=p*2;
    error('Inconsistent numbers of elements betweee plot_axes and wavelengths.');
elseif numel(plot_axes)==p*2;
    if size(wavelengths,1)~=4;
        error('Inconsistent number of rows in wavelengths.');
    end;
    lambda=lambda(2,:);
end;

% load visible color data
int=10;
thr=[171 360 490 550 730 900 1100 2200];
nuv=(thr(1):int:(thr(2)-int))'/1000;
vis2=(thr(2):int:(thr(3)-int))'/1000;
vis3=(thr(3):int:(thr(4)-int))'/1000;
vis4=(thr(4):int:(thr(5)-int))'/1000;
nir1=(thr(5):int:(thr(6)-int))'/1000;
nir2=(thr(6):int:(thr(7)-int))'/1000;
ir=(thr(7):int:thr(8))'/1000;
lambda0=[nuv;vis2;vis3;vis4;nir1;nir2;ir];
j=jet(length(vis2)+length(vis3)+length(vis4));
rgb0=[nuv/nuv(end)*[1 0 1]; j(1:length(vis2),:); (((vis3(end)-vis3)/1.2)/(vis3(end)-vis3(1))+0.2)*[0 1 0]; j(length(vis2)+length(vis3)+(1:length(vis4)),:); copper(length(nir1)); flipud(1-copper(length(nir2)))/2+0.5; (1-flipud(jet(length(ir))))/2+0.5];
rgb0(:,[1 3])=rgb0(:,[1 3])-repmat(rgb0(:,2)/2,1,2);
rgb0(:,2)=rgb0(:,2)/1.5;
rgb0(rgb0<0)=0;
rgb0(rgb0>1)=1;

% change colors
clr=interp1(lambda0, rgb0, lambda);
for i=1:p;
    if numel(plot_axes)==p;
        set(plot_axes(i),'color', clr(i,:));
        legend_string(i)={[num2str(wavelengths(i), prec) ' ' unit]};
    elseif numel(plot_axes)==p*2;
        set(plot_axes(i),'color', clr(i,:));
        set(plot_axes(i+p), 'color',(clr(i,:)/2+0.5));
        legend_string(i)={[num2str(wavelengths(2,i), prec) ' (' num2str(wavelengths(1,i), prec) '-' num2str(wavelengths(3,i), prec) ') ' unit ', ' num2str(wavelengths(4,i), prec) ' ' unit]};
    end;
end;

% plot
% lambda=[visw nirw];
% figure;
% for i=1:length(lambda);
% plot(repmat(lambda(i),1,2), [0 1], '.-', 'color', clr(i,:));
% hold on;
% end;
% ylim([0 1]);
% gglwa;

% previous attempts to get visible spectrum
% cm0=[390	1.50E-03	-4.00E-04	6.20E-03
% 395	3.80E-03	-1.00E-03	1.61E-02
% 400	8.90E-03	-2.50E-03	4.00E-02
% 405	1.88E-02	-5.90E-03	9.06E-02
% 410	3.50E-02	-1.19E-02	1.80E-01
% 415	5.31E-02	-2.01E-02	3.09E-01
% 420	7.02E-02	-2.89E-02	4.67E-01
% 425	7.63E-02	-3.38E-02	6.15E-01
% 430	7.45E-02	-3.49E-02	7.64E-01
% 435	5.61E-02	-2.76E-02	8.78E-01
% 440	3.23E-02	-1.69E-02	9.76E-01
% 445	-4.40E-03	2.40E-03	1.00E+00
% 450	-4.78E-02	2.83E-02	1.00E+00
% 455	-9.70E-02	6.36E-02	9.14E-01
% 460	-1.59E-01	1.08E-01	8.30E-01
% 465	-2.24E-01	1.62E-01	7.42E-01
% 470	-2.85E-01	2.20E-01	6.13E-01
% 475	-3.35E-01	2.80E-01	4.72E-01
% 480	-3.78E-01	3.43E-01	3.50E-01
% 485	-4.14E-01	4.09E-01	2.56E-01
% 490	-4.32E-01	4.72E-01	1.82E-01
% 495	-4.45E-01	5.49E-01	1.31E-01
% 500	-4.35E-01	6.26E-01	9.10E-02
% 505	-4.14E-01	7.10E-01	5.80E-02
% 510	-3.67E-01	7.94E-01	3.57E-02
% 515	-2.85E-01	8.72E-01	2.00E-02
% 520	-1.86E-01	9.48E-01	9.50E-03
% 525	-4.35E-02	9.95E-01	7.00E-04
% 530	1.27E-01	1.02E+00	-4.30E-03
% 535	3.13E-01	1.04E+00	-6.40E-03
% 540	5.36E-01	1.05E+00	-8.20E-03
% 545	7.72E-01	1.04E+00	-9.40E-03
% 550	1.01E+00	1.00E+00	-9.70E-03
% 555	1.27E+00	9.70E-01	-9.70E-03
% 560	1.56E+00	9.16E-01	-9.30E-03
% 565	1.85E+00	8.57E-01	-8.70E-03
% 570	2.15E+00	7.82E-01	-8.00E-03
% 575	2.43E+00	6.95E-01	-7.30E-03
% 580	2.66E+00	5.97E-01	-6.30E-03
% 585	2.92E+00	5.06E-01	-5.37E-03
% 590	3.08E+00	4.20E-01	-4.45E-03
% 595	3.16E+00	3.36E-01	-3.57E-03
% 600	3.17E+00	2.59E-01	-2.77E-03
% 605	3.10E+00	1.92E-01	-2.08E-03
% 610	2.95E+00	1.37E-01	-1.50E-03
% 615	2.72E+00	9.38E-02	-1.03E-03
% 620	2.45E+00	6.11E-02	-6.80E-04
% 625	2.17E+00	3.71E-02	-4.42E-04
% 630	1.84E+00	2.15E-02	-2.72E-04
% 635	1.52E+00	1.12E-02	-1.41E-04
% 640	1.24E+00	4.40E-03	-5.49E-05
% 645	1.01E+00	7.80E-05	-2.20E-06
% 650	7.83E-01	-1.37E-03	2.37E-05
% 655	5.93E-01	-1.99E-03	2.86E-05
% 660	4.44E-01	-2.17E-03	2.61E-05
% 665	3.28E-01	-2.01E-03	2.25E-05
% 670	2.39E-01	-1.64E-03	1.82E-05
% 675	1.72E-01	-1.27E-03	1.39E-05
% 680	1.22E-01	-9.47E-04	1.03E-05
% 685	8.53E-02	-6.83E-04	7.38E-06
% 690	5.86E-02	-4.78E-04	5.22E-06
% 695	4.08E-02	-3.37E-04	3.67E-06
% 700	2.84E-02	-2.35E-04	2.56E-06
% 705	1.97E-02	-1.63E-04	1.76E-06
% 710	1.35E-02	-1.11E-04	1.20E-06
% 715	9.24E-03	-7.48E-05	8.17E-07
% 720	6.38E-03	-5.08E-05	5.55E-07
% 725	4.41E-03	-3.44E-05	3.75E-07
% 730	3.07E-03	-2.34E-05	2.54E-07
% 735	2.14E-03	-1.59E-05	1.71E-07
% 740	1.49E-03	-1.07E-05	1.16E-07
% 745	1.05E-03	-7.23E-06	7.85E-08
% 750	7.39E-04	-4.87E-06	5.31E-08
% 755	5.23E-04	-3.29E-06	3.60E-08
% 760	3.72E-04	-2.22E-06	2.44E-08
% 765	2.65E-04	-1.50E-06	1.65E-08
% 770	1.90E-04	-1.02E-06	1.12E-08
% 775	1.36E-04	-6.88E-07	7.53E-09
% 780	9.84E-05	-4.65E-07	5.07E-09
% 785	7.13E-05	-3.12E-07	3.40E-09
% 790	5.18E-05	-2.08E-07	2.27E-09
% 795	3.77E-05	-1.37E-07	1.50E-09
% 800	2.76E-05	-8.80E-08	9.86E-10
% 805	2.03E-05	-5.53E-08	6.39E-10
% 810	1.49E-05	-3.36E-08	4.07E-10
% 815	1.10E-05	-1.96E-08	2.53E-10
% 820	8.18E-06	-1.09E-08	1.52E-10
% 825	6.09E-06	-5.70E-09	8.64E-11
% 830	4.55E-06	-2.77E-09	4.42E-11]; % Stiles & Burch (1959) 10-deg, RGB CMFs  http://cvrl.ioo.ucl.ac.uk/cmfs.htm
% nuv=(200:5:385)'/1000;
% nir=(835:5:2200)'/1000;
% lambda0=[nuv; cm0(:,1)/1000; nir];
% rgb0=[nuv/nuv(end)*[1 0 0.2]; cm0(:,2:4); nir/nir(end)*[1 1 1]];
% rgb0(rgb0<0)=0;
% rgb0(rgb0>1)=1;