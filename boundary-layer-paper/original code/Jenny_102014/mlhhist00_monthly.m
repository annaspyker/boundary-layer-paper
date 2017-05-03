%mlhhist00_monthly
%Find all 00:00 mlhs, then plot hist to get variables
%in principle run "plotmultiday" first

clear all;

% time_mlh_all00 = [];
% mlh_all00 = [];
% time_mlh_all06 = [];
% mlh_all06 = [];
% time_mlh_all12 = [];
% mlh_all12 = [];
% time_mlh_all18 = [];
% mlh_all18 = [];

%search for all mlh files
plotpath_mlh = 'd:\Neuseeland\uni\matfiles\inns_format\AK1304\';
%ppath_mlh_list = dir([plotpath_mlh 'AK13*']);
%m = length(ppath_mlh_list);
%for k = 3:m

    plotlist_mlh00 = dir([plotpath_mlh 'R*00mlh.mat']);
    plotlist_mlh06 = dir([plotpath_mlh 'R*06mlh.mat']);
    plotlist_mlh12 = dir([plotpath_mlh 'R*12mlh.mat']);
    plotlist_mlh18 = dir([plotpath_mlh 'R*18mlh.mat']);
    
    n1 = length(plotlist_mlh00);
    n2 = length(plotlist_mlh06);
    n3 = length(plotlist_mlh12);
    n4 = length(plotlist_mlh18);
    
    n = min([n1,n2,n3,n4]);
    
    time_mlh00 = [];
    mlh00 = [];
    time_mlh06 = [];
    mlh06 = [];
    time_mlh12 = [];
    mlh12 = [];
    time_mlh18 = [];
    mlh18 = [];
    
    for i = 1:n
        load([plotpath_mlh plotlist_mlh00(i).name])
        time_mlh00 = [time_mlh00, mlh_height(1,1:20)];
        mlh00 = [mlh00, mlh_height(2:5,1:20)];
        
        load([plotpath_mlh plotlist_mlh06(i).name])
        time_mlh06 = [time_mlh06, mlh_height(1,1:20)];
        mlh06 = [mlh06, mlh_height(2:5,1:20)];
        
        load([plotpath_mlh plotlist_mlh12(i).name])
        time_mlh12 = [time_mlh12, mlh_height(1,1:20)];
        mlh12 = [mlh12, mlh_height(2:5,1:20)];
        
        load([plotpath_mlh plotlist_mlh18(i).name])
        time_mlh18 = [time_mlh18, mlh_height(1,1:20)];
        mlh18 = [mlh18, mlh_height(2:5,1:20)];
    end

mlh00_reshape = reshape(mlh00,1,4*length(mlh00));
mlh06_reshape = reshape(mlh06,1,4*length(mlh06));
mlh12_reshape = reshape(mlh12,1,4*length(mlh12));
mlh18_reshape = reshape(mlh18,1,4*length(mlh18));

size(mlh00_reshape)
size(mlh06_reshape)
size(mlh12_reshape)
size(mlh18_reshape)

mlh_reshape = [mlh00_reshape;mlh06_reshape;mlh12_reshape;mlh18_reshape];
size(mlh_reshape)
[n_all,xout_all] = hist(mlh00',10);
[n_resh,xout_resh] = hist(mlh00_reshape',(0:250:3000));

pmon = datenum(plotpath_mlh(end-4:end-1),'yymm'); 
%--------------------------------------------------------------------------
%-plotting

clf;

%figure1 = figure(1);
%histfit(mlh_all',10)

figure2 = figure(2);
axes2 = axes('Parent',figure2,'FontWeight','demi','FontSize',14,...
    'XTick',[0 250 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000]);
hold(axes2,'all');
hist(mlh_reshape',(0:250:3000));
xlim(axes2,[-100 3100])
xlabel('Boundary Layer Height bins [m]','FontWeight','demi','FontSize',14);
ylabel('Number of occurences','FontWeight','demi','FontSize',14);
title(['Frequency Distribution of Bounday Layer Height for ' datestr(pmon,'mmm yyyy')],...
    'FontWeight','demi','FontSize',14);
legend(['00:00';'06:00';'12:00';'18:00'])

% ind00 = find(abs(time_mlh_all - fix(time_mlh_all)) < 1/385)
% hist(mlh_all(:,ind00)')
% mlh_reshape = reshape(mlh_all(:,ind00),1,4*length(mlh_all(:,ind00)))
% hist(mlh_reshape)