%plot blh monthly time series

clear all;

%thresholds for noise profile

month = '01';
year = '13';

mlhpath = 'd:\Neuseeland\uni\matfiles\inns_format\';
listfolder = dir([mlhpath 'AK' year month '*']);

n = length(listfolder);

%k = 0;
timemlh = [];
timemlhnew = [];
mlhnew = [];

for i = 1:n
    mlhmpath = [mlhpath listfolder(i).name '\'];
    listpath = dir([mlhmpath 'R*29*mlh.mat']);
    m = length(listpath);
    for j = 1:m
       % k = k+1;
        
        %load mlh
        mlhfile = fullfile([mlhpath 'AK' year month '\' listpath(j).name(1:8) 'mlh.mat']);
        load(mlhfile);
        
        %timemlh(:,k) = mlh_height(1,:);
        timemlhnew = [timemlhnew; mlh_height(1,:)'];
                
        mlhnew = [mlhnew; mlh_height(2:5,:)'];
    end
end
%--------------------------------------------------------------------------
%load mlh from best-profile method

load('d:\Neuseeland\uni\data\MLH_bestprofile\MLHData_130129_a.mat');
bp_time = MLH{2};
bp_mlh = MLH{1};

MLH1 = load('d:\Neuseeland\uni\data\MLH_bestprofile\MLHData_130129.mat');
bp_time1 = MLH1.MLH{2}+datenum([2013,1,29,5,30,0]);
bp_mlh1 = MLH1.MLH{1};


%--------------------------------------------------------------------------
%find out , when mlh can be calculated unter clear conditions

tf = isnan(mlhnew);
mlh1 = find(tf(:,1) == 0);
mlh2 = find(tf(:,2) == 0);
mlh3 = find(tf(:,3) == 0);
mlh4 = find(tf(:,4) == 0);

%in how many per cent (%) of cases (clear and cloudy) it is possible to calculate mlh?
percentmlh = (length(mlh1)/length(timemlhnew))*100

%think about whether == 1 or ==0 makes more sense and how to find correct
%times

%--------------------------------------------------------------------------
% gap = find(diff(timelow)>0.0004);
% gl = length(gap);
%--------------------------------------------------------------------------

clf;

figure2 = figure(2);
 
axes2 = axes('Parent',figure2,'Layer','top',...
    'XTickLabel',{datestr(fix(timemlhnew(1)):1:fix(timemlhnew(end)),'dd')},...
    'XTick',(fix(timemlhnew(1)):1:fix(timemlhnew(end))),...
    'FontWeight','demi',...
    'FontSize',16);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes2,[fix(timemlhnew(1)) fix(timemlhnew(end))+1]);
 %datetick('x',19)
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes2,[42.5 3802.5]);
box(axes2,'on');
hold(axes2,'all');

% Create image

plot(timemlhnew,mlhnew(:,1),'m+')%,'markersize',3)
plot(timemlhnew,mlhnew(:,2),'r.','markersize',3)
plot(timemlhnew,mlhnew(:,3),'g.','markersize',3)
plot(timemlhnew,mlhnew(:,4),'c.','markersize',3)

%plot mlh aus best-profile method
plot(bp_time,bp_mlh,'kx')
plot(bp_time1,bp_mlh1,'yx')


% Create xlabel
xlabel(['Day in ' datestr(timemlhnew(1),'mmm yyyy')],'FontWeight','demi','FontSize',16);

% Create ylabel
ylabel('Height above ground (m)','FontWeight','demi','FontSize',16);
title(['Timeseries of mlh in ' datestr(timemlhnew(1),'mmm yyyy')])


