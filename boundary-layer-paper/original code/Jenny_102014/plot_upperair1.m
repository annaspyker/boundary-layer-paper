%funcion plot_upperair1

%the upper air soundings are plotted
%Siggi 23.5.2013
%--------------------------------------------------------------------------

clear all;

plotdate = '20130113';
date = datenum(plotdate,'yyyymmdd');
upperairstation = 'Auck_airport';
metstation = 'Mangere';

upperpath = 'd:\Neuseeland\uni\data\Metdata\firsttries\';
upperfile = fullfile(upperpath, ['upper_air_' upperairstation '.txt']);

fid = fopen(upperfile,'r');
upperairfield = textscan(fid,'%d %13c %d %f %s %s %s %s %*c %*c %*c %*c %*c %c', 'headerlines', 10);
fclose(fid);

station_id = upperairfield{1,1}(1,1);
time = datenum(upperairfield{1,2},'yyyymmdd:HHMM');
pressure = upperairfield{1,4};
height = upperairfield{1,3};
tair = upperairfield{1,5};
tdew = upperairfield{1,6};
wdir = upperairfield{1,7};
wspeed = upperairfield{1,8};

tft = strcmp('-',tair);
tairind = find(tft == 0);
tair = tair(tairind);
timet = time(tairind);
pressuret = pressure(tairind);
heightt = height(tairind);

tftd = strcmp('-',tdew);
tdewind = find(tftd == 0);
tdew = tdew(tdewind);
timetd = time(tdewind);
pressuretd = pressure(tdewind);
heighttd = height(tdewind);

tempair = char(tair);
tempair = str2num(tempair);

tempdew = char(tdew);
tempdew = str2num(tempdew);

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

timetind1 = find(timet == date);
timetind2 = find(timet == date+0.25);
timetind3 = find(timet == date+0.5);
timetind4 = find(timet == date+0.75);

timetdind1 = find(timetd == date);
timetdind2 = find(timetd == date+0.25);
timetdind3 = find(timetd == date+0.5);
timetdind4 = find(timetd == date+0.75);

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
%--------------------------------------------------------------------------
if ~isempty(timetind1)
    plottair1 = tempair(timetind1);
    plotheightt1 = heightt(timetind1);
    pressuret1 = pressuret(timetind1);
    legt1 = ['Tair at ' datestr(timet(timetind1(1)),'HH:MM')];
else
    plottair1 = [];
    plotheightt1 = [];
    pressuret1 = [];
    legt1 = '';
end

if ~isempty(timetind2)
    plottair2 = tempair(timetind2);
    plotheightt2 = heightt(timetind2);
    pressuret2 = pressuret(timetind2);
    legt2 = ['Tair at ' datestr(timet(timetind2(1)),'HH:MM')];
else
    plottair2 = [];
    plotheightt2 = [];
    pressuret2 = [];
    legt2 = '';
end

if ~isempty(timetind3)
    plottair3 = tempair(timetind3);
    plotheightt3 = heightt(timetind3);
    pressuret3 = pressuret(timetind3);
    legt3 = ['Tair at ' datestr(timet(timetind3(1)),'HH:MM')];
else
    plottair3 = [];
    plotheightt3 = [];
    pressuret3 = [];
    legt3 = '';
end

if ~isempty(timetind4)
    plottair4 = tempair(timetind4);
    plotheightt4 = heightt(timetind4);
    pressuret4 = pressuret(timeind4);
    legt4 = ['Tair at ' datestr(timet(timetind4(1)),'HH:MM')];
else
    plottair4 = [];
    plotheightt4 = [];
    pressuret4 = [];
    legt4 = '';
end
%--------------------------------------------------------------------------
if ~isempty(timetdind1)
    plottdew1 = tempdew(timetdind1);
    plotheighttd1 = heighttd(timetdind1);
    legtd1 = ['Tdew at ' datestr(timetd(timetdind1(1)),'HH:MM')];
else
    plottdew1 = [];
    plotheighttd1 = [];
    legtd1 = '';
end

if ~isempty(timetdind2)
    plottdew2 = tempdew(timetdind2);
    plotheighttd2 = heighttd(timetdind2);
    legtd2 = ['Tdew at ' datestr(timetd(timetdind2(1)),'HH:MM')];
else
    plottdew2 = [];
    plotheighttd2 = [];
    legtd2 = '';
end

if ~isempty(timetdind3)
    plottdew3 = tempdew(timetdind3);
    plotheighttd3 = heighttd(timetdind3);
    legtd3 = ['Tdew at ' datestr(timetd(timetdind3(1)),'HH:MM')];
else
    plottdew3 = [];
    plotheighttd3 = [];
    legtd3 = '';
end

if ~isempty(timetdind4)
    plottdew4 = tempdew(timetdind4);
    plotheighttd4 = heighttd(timetdind4);
    legtd4 = ['Tdew at ' datestr(timetd(timetdind4(1)),'HH:MM')];
else
    plottdew4 = [];
    plotheighttd4 = [];
    legtd4 = '';
end

% %--------------------------------------------------------------------------
% plot the mast measurements of wind direction together with the upper air
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

%-------
% calculate potential temperature

kappa = 0.286;
p0 = 1000;
theta1 = ((plottair1+273.15).*(p0./pressuret1).^(kappa))-273.15;
theta2 = ((plottair2+273.15).*(p0./pressuret2).^(kappa))-273.15;
theta3 = ((plottair3+273.15).*(p0./pressuret3).^(kappa))-273.15;
theta4 = ((plottair4+273.15).*(p0./pressuret4).^(kappa))-273.15;

FX1 = gradient(theta1);
FX2 = gradient(theta2);
FX3 = gradient(theta3);
FX4 = gradient(theta4);

a0 = 6.107799961; 
a1 = 4.436518521*10^(-1);
a2 = 1.428945805*10^(-2);
a3 = 2.650648471*10^(-4);
a4 = 3.031240396*10^(-6);
a5 = 2.034080948*10^(-8);
a6 = 6.136820929*10^(-11);

%et1 = a0+plottair1(1:17).*(a1+plottair1(1:17).*(a2+plottair1(1:17).*(a3+plottair1(1:17).*(a4+plottair1(1:17).*(a5+plottair1(1:17).*a6)))));
%et3 = a0+plottair3(1:17).*(a1+plottair3(1:17).*(a2+plottair3(1:17).*(a3+plottair3(1:17).*(a4+plottair3(1:17).*(a5+plottair3(1:17).*a6)))));
%etd1 = a0+plottdew1(1:17).*(a1+plottdew1(1:17).*(a2+plottdew1(1:17).*(a3+plottdew1(1:17).*(a4+plottdew1(1:17).*(a5+plottdew1(1:17).*a6)))));
%etd3 = a0+plottdew1(1:17).*(a1+plottdew1(1:17).*(a2+plottdew1(1:17).*(a3+plottdew1(1:17).*(a4+plottdew1(1:17).*(a5+plottdew1(1:17).*a6)))));

%rh1 = (etd1./et1).*100;
%rh3 = (etd3./et3).*100;

%gradrh1 = gradient(rh1);
%gradrh3 = gradient(rh3);

%--------------------------------------------------------------------------
%get heights of interest

[minfx1,indfx1] = min(FX1);
%disp('minimaler Gradient von theta um 00:00: ', plotheight1(indfx1) )

%--------------------------------------------------------------------------
legentry = [leg1; leg2; leg3; leg4];
legentryt = [legt1; legt2; legt3; legt4; legtd1; legtd2; legtd3; legtd4];
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

figure2 = figure(2);
axes2 = axes('Parent',figure2,'FontWeight','demi','FontSize',14);
hold on
plot(plottair1,plotheightt1,'b-+')
plot(plottair2,plotheightt2,'k-x')
plot(plottair3,plotheightt3,'m-*')
plot(plottair4,plotheightt4,'r-d')

plot(plottdew1,plotheighttd1,'b-^')
plot(plottdew2,plotheighttd2,'k-s')
plot(plottdew3,plotheighttd3,'m-p')
plot(plottdew4,plotheighttd4,'r-v')

plot(theta1, plotheightt1,'b--')
plot(theta2, plotheightt2,'k--')
plot(theta3, plotheightt3,'m--')
plot(theta4, plotheightt4,'r--')

plot(FX1, plotheightt1,'b-.')
plot(FX2, plotheightt2,'k-.')
plot(FX3, plotheightt3,'m-.')
plot(FX4, plotheightt4,'r-.')

% plot(plottair1(1:17)-plottdew1(1:17), plotheight1(1:17),'b-o')
% plot(plottair3(1:17)-plottdew3(1:17),plotheight3(1:17),'m-o')

ylim([0 4000])

legend(legentryt);
xlabel('Temperature [°C]','FontWeight','demi','FontSize',14);
ylabel('Height [m]','FontWeight','demi','FontSize',14);
hold off

% figure3 = figure(3);
% 
% axes3 = axes('Parent',figure3,'YTick',[500 1000 1500 2000 2500 3000 3500],'YColor',[0 0 0],...
%     'XTickLabel',{'0','10','20','30','40','50','60','70','80','90','100'},...
%     'XTick',(0:10:100),'xcolor',[0 0 1],'Layer','top',...
%     'FontWeight','demi','FontSize',14,...
%     'position',[0.07 0.08 0.4 0.82]);
% xlim(axes3,[0 100]);
% ylim(axes3,[0 3500]);
% hold(axes3,'all');
% xlabel(axes3,'relative humidity [%]')
% ylabel(axes3,'height [m]')
% plot(rh1, plotheightt1(1:17),'Parent',axes3,'color','b','linestyle','-','Marker','v',...
%     'Displayname','relative humidity [%] at 00:00')
% 
% axes31 = axes('Parent',figure3,...
%     'FontWeight','demi','FontSize',14,...
%     'XTickLabel',{'0','10','20','30','40','50','60'},'XTick',(0:10:60),...
% 'XAxisLocation','top','TickDir','out','xcolor','r',...
%     'YTick',[],'YTickLabel',{},'position', [0.07 0.08 0.4 0.82]);
% xlim(axes31,[0 60]);
% ylim(axes31,[0 3500]);
% set(gca,'color','none')
% hold(axes31,'all');
% xlabel(axes31,'potential temperature [°C]')
% 
% plot(theta1(1:17),plotheightt1(1:17),'Parent',axes31,'color','r','linestyle','-','Marker','v',...
%     'Displayname','potential Temperature [°C] at 00:00')
% 
% legend(axes3,'show');
% legend(axes31,'show');

% axes3 = axes('Parent',figure3,'YTick',[500 1000 1500 2000 2500 3000 3500],'YColor',[0 0 0],...
%     'XTickLabel',{'0','10','20','30','40','50','60','70','80','90','100'},...
%     'XTick',(0:10:100),'XColor',[0 0 1],'Layer','top',...
%     'FontWeight','demi','FontSize',14,...
%     'position',[0.57 0.08 0.4 0.82]);
% xlim(axes3,[0 100]);
% ylim(axes3,[0 3500]);
% xlabel(axes3,'relative humidity [%]')
% ylabel(axes3,'height [m]')
% hold(axes3,'all');
% 
% plot(rh3, plotheightt3(1:17),'Parent',axes3,'color','b','linestyle','-','Marker','*',...
%     'Displayname','relative humidity [%] at 12:00')
% 
% axes31 = axes('Parent',figure3,...
%     'FontWeight','demi','FontSize',14,...
%     'XTickLabel',{'0','10','20','30','40','50','60'},'XTick',(0:10:60),...
% 'XAxisLocation','top','TickDir','out','XColor','r',...
%     'YTick',[],'YTickLabel',{},'position', [0.57 0.08 0.4 0.82]);
% xlim(axes31,[0 60]);
% ylim(axes31,[0 3500]);
% set(gca,'color','none')
% xlabel(axes31,'potential temperature [°C]')
% hold(axes31,'all');
% 
% plot(theta3(1:17),plotheightt3(1:17),'Parent',axes31,'color','r','linestyle','-','Marker','*',...
%     'Displayname','potential Temperature [°C] at 12:00')
% 
% legend(axes3,'show');
% legend(axes31,'show');

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