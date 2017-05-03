%funcion plot_upperair

%the upper air soundings are plotted
%Siggi 23.5.2013
%--------------------------------------------------------------------------

clear all;

plotdate = '20130113';
date = datenum(plotdate,'yyyymmdd');
upperairstation = 'Whenuapai';
metstation = 'WhenuapaiAWS';

upperpath = 'd:\Neuseeland\uni\data\Metdata\firsttries\';
upperfile = fullfile(upperpath, ['upper_air_' upperairstation '.txt']);

fid = fopen(upperfile,'r');
upperairfield = textscan(fid,'%d %13c %d %f %*s %*s %s %s %*c %*c %*c %*c %*c %c', 'headerlines', 10);
fclose(fid);

station_id = upperairfield{1,1}(1,1);
time = datenum(upperairfield{1,2},'yyyymmdd:HHMM');
pressure = upperairfield{1,4};
height = upperairfield{1,3};
wdir = upperairfield{1,5};
wspeed = upperairfield{1,6};

tf = strcmp('-',wdir);
wdirind = find(tf == 0);
wdir = wdir(wdirind);
wspeed = wspeed(wdirind);
time = time(wdirind);
pressure = pressure(wdirind);
height = height(wdirind);

winddir = char(wdir);
winddir = str2num(winddir);

timeind1 = find(time == date);
timeind2 = find(time == date+0.25);
timeind3 = find(time == date+0.5);
timeind4 = find(time == date+0.75);

if ~isempty(timeind1)
    plotwdir1 = winddir(timeind1);
    plotheight1 = height(timeind1);
    leg1 = datestr(time(timeind1(1)),'HH:MM');
else
    plotwdir1 = [];
    plotheight1 = [];
    leg1 = '';
end

if ~isempty(timeind2)
    plotwdir2 = winddir(timeind2);
    plotheight2 = height(timeind2);
    leg2 = datestr(time(timeind2(1)),'HH:MM');
else
    plotwdir2 = [];
    plotheight2 = [];
    leg2 = '';
end

if ~isempty(timeind3)
    plotwdir3 = winddir(timeind3);
    plotheight3 = height(timeind3);
    leg3 = datestr(time(timeind3(1)),'HH:MM');
else
    plotwdir3 = [];
    plotheight3 = [];
    leg3 = '';
end

if ~isempty(timeind4)
    plotwdir4 = winddir(timeind4);
    plotheight4 = height(timeind4);
    leg4 = datestr(time(timeind4(1)),'HH:MM');
else
    plotwdir4 = [];
    plotheight4 = [];
    leg4 = '';
end
% %--------------------------------------------------------------------------
% %plot the mast measurements of wind direction together with the upper air
% %soundings
% 
% winddir = 'd:\Neuseeland\uni\data\Metdata\';
% windfile = fullfile(winddir,['surface_wind_' metstation '.txt']);
% 
% fid=fopen(windfile,'r');
% windfield = textscan(fid,'%d %13c %d %*s %f %*s %*s %*s %f %c %c', 'headerlines', 9);
% fclose(fid);
% 
% station_id = windfield{1,1}(1,1);
% wtime = datenum(windfield{1,2},'yyyymmdd:HHMM');
% wdir = windfield{1,3};
% %wspeed = windfield{1,4};
% 
% wtimeind1 = find(wtime == date);
% %wtimeind2 = find(wtime == date+0.25);
% wtimeind3 = find(wtime == date+0.5);
% %wtimeind4 = find(wtime == date+0.75);
% 
% pwdir1 = wdir(wtimeind1)
% %pwdir2 = wdir(wtimeind2)
% pwdir3 = wdir(wtimeind3)
% %pwdir4 = wdir(wtimeind4)

%--------------------------------------------------------------------------
legentry = [leg1; leg2; leg3; leg4];
%wlegentry = [leg1; leg2; leg3; leg4;'00:00';'06:00';'12:00';'18:00'];
%wlegentry = [leg1; leg2; leg3; leg4;'00:00';'12:00';'12:00'];
%--------------------------------------------------------------------------
%plot upper air sounding

clf;
figure1 = figure(1);
axes1 = axes('Parent',figure1,'FontWeight','demi','FontSize',14);
hold on
plot(plotwdir1,plotheight1,'b-+')
plot(plotwdir2,plotheight2,'k-x')
plot(plotwdir3,plotheight3,'m-*')
plot(plotwdir4,plotheight4,'r-d')
xlim([0 360])
legend(legentry);
xlabel('Wind direction [°]','FontWeight','demi','FontSize',14);
ylabel('Height [m]','FontWeight','demi','FontSize',14);
hold off

% figure2 = figure(2);
% axes2 = axes('Parent',figure2,'FontWeight','demi','FontSize',14);
% hold on
% plot(plotwdir1,plotheight1,'b-+')
% plot(plotwdir2,plotheight2,'k-x')
% plot(plotwdir3,plotheight3,'m-*')
% plot(plotwdir4,plotheight4,'r-d')
% plot(pwdir1,10,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],...
%     'MarkerSize',10,'Marker','square','LineStyle','none','Color',[0 0 1])
% % plot(pwdir2,10,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
% %     'MarkerSize',10,'Marker','hexagram','LineStyle','none','Color',[0 0 0])
% plot(pwdir3,10,'MarkerFaceColor',[1 0 1],'MarkerEdgeColor',[1 0 1],...
%     'MarkerSize',10,'Marker','o','LineStyle','none','Color',[1 0 1])
%  plot(30,10,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
%      'MarkerSize',10,'Marker','diamond','LineStyle','none','Color',[1 0 0])
% xlim([0 360])
% legend(wlegentry);
% xlabel('Wind direction [°]','FontWeight','demi','FontSize',14);
% ylabel('Height [m]','FontWeight','demi','FontSize',14);
% hold off