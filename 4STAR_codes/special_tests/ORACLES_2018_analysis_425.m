%% Script for easy running through 2018 data for plotting the anomaly at 425 nm

close all


days = ['0921';'0922';'0924';'0927';'0930';'1010';'1012';'1015'];
%    days = ['1002';'1003';'1005';'1007'];
days = ['0930';'1010';'1012';'1015'];
%    days = ['1017';'1019';'1021';'1023';'1025';'1026';'1027'];
    
  %      days = ['1017';'1019';'1021';'1023';'1025';'1026';'1027']
    
    

%% loop through days    
for i=1:length(days)
    disp(['Running the files from days: 2018' days(i,:)])
    
 %   starsun([getnamedpath('ORACLES_2018') '4STAR_2018' days(i,:) 'star.mat']);
    
    % load days
               s = load([getnamedpath('ORACLES_2018') '4STAR_2018' days(i,:) 'starsun.mat']);
    sm = load([getnamedpath('ORACLES_2018') '4STAR_2018' days(i,:) 'star.mat']);
    
    Analysis_425feature(s,sm);    
    %starsun([getnamedpath('ORACLES_2018') '4STAR_2018' days(i,:) 'star.mat']);
end
