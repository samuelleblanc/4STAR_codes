function sft = finite_el_der(tau_OD,wln,nm_startpca,nm_endpca)
% this function calculates first derivative numerically (finite elements)
% tau_OD is pca filtered in this case
% wln is wln indices for retrieval
% nm_start/endpca is wln indices withing pca filtered OD spectra
%
% written, Michal Segal, 2015-04-16, NASA Ames
%------------------------------------------------------------------------

% subset OD spectra +- 2 pixels from each side
    sub = tau_OD(:,nm_startpca-2:nm_endpca+2);
    
% make derivative der=(1/12*h)*(y_{-2} - 8*y_{-1} + 8*y_{1} - y_(2))
    der = zeros(size(tau_OD,1),length(wln));
    for i=3:size(sub,2)-2
        y_2 = sub(:,i-2);
        y_1 = sub(:,i-1);
        y1  = sub(:,i+1);
        y2  = sub(:,i+2);
        
        der(:,i-2) = (1/12*0.8)*(y_2 - 8*y_1 +8*y1 - y2);
    end
    
    sft = der./tau_OD(:,nm_startpca:nm_endpca);
    
% test plot
%     figure;
%     plot(s.w(wln),der(6,:));
%     xlabel('wavelength [nm]');ylabel('OD derivative');
%     figure;
%     plot(s.w(wln),sft(6,:));
%     xlabel('wavelength [nm]');ylabel('A_{shift} = OD derivative/OD');