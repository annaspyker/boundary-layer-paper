%function plotsingleday

clear all;

timeR = [];
%altR = [];
dataR = [];

time_mlh = [];
mlh = [];

date = '30107';
plotpath = ['d:\Neuseeland\uni\matfiles\singleprofiles\AK1' date(1:3) '\'];
plotpath_mlh = ['d:\Neuseeland\uni\matfiles\inns_format\AK1' date(1:3) '\'];

plotlistR = dir([plotpath 'R' date '*.mat'])
plotlist_mlh = dir([plotpath_mlh 'r' date '*mlh.mat'])

n = length(plotlistR);
for i = 1:n
    load([plotpath plotlistR(i).name]);
    timeR = [timeR, time];
    altR = height;
    dataR = [dataR; profile_nonoise];
    
    load([plotpath_mlh plotlist_mlh(i).name]);
    time_mlh = [time_mlh, mlh_height(1,:)];
    mlh = [mlh, mlh_height(2:5,:)];
end
%--------------------------------------------------------------------------
%read upper air sounding
%--------------------------------------------------------------------------

plotdate = ['201' date];
pdate = datenum(plotdate,'yyyymmdd');
upperairstation = 'Whenuapai';
metstation = 'WhenuapaiAWS';

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

timetind1 = find(timet == pdate);
timetind2 = find(timet == pdate+0.25);
timetind3 = find(timet == pdate+0.5);
timetind4 = find(timet == pdate+0.75);

timetdind1 = find(timetd == pdate);
timetdind2 = find(timetd == pdate+0.25);
timetdind3 = find(timetd == pdate+0.5);
timetdind4 = find(timetd == pdate+0.75);

%--------------------------------------------------------------------------
if ~isempty(timetind1)
    plottair1 = tempair(timetind1);
    plotheightt1 = heightt(timetind1);
    legt1 = ['Tair at ' datestr(timet(timetind1(1)),'HH:MM')];
else
    plottair1 = [];
    plotheightt1 = [];
    legt1 = '';
end

if ~isempty(timetind2)
    plottair2 = tempair(timetind2);
    plotheightt2 = heightt(timetind2);
    legt2 = ['Tair at ' datestr(timet(timetind2(1)),'HH:MM')];
else
    plottair2 = [];
    plotheightt2 = [];
    legt2 = '';
end

if ~isempty(timetind3)
    plottair3 = tempair(timetind3);
    plotheightt3 = heightt(timetind3);
    legt3 = ['Tair at ' datestr(timet(timetind3(1)),'HH:MM')];
else
    plottair3 = [];
    plotheightt3 = [];
    legt3 = '';
end

if ~isempty(timetind4)
    plottair4 = tempair(timetind4);
    plotheightt4 = heightt(timetind4);
    legt4 = ['Tair at ' datestr(timet(timetind4(1)),'HH:MM')];
else
    plottair4 = [];
    plotheightt4 = [];
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

%--------------------------------------------------------------------------
%AUckland upper air
plotdate_a = ['201' date];
pdate_a = datenum(plotdate_a,'yyyymmdd');
upperairstation_a = 'Auck_airport';

upperpath = 'd:\Neuseeland\uni\data\Metdata\firsttries\';
upperfile_a = fullfile(upperpath, ['upper_air_' upperairstation_a '.txt']);

fid = fopen(upperfile_a,'r');
upperairfield_a = textscan(fid,'%d %13c %d %f %s %s %s %s %*c %*c %*c %*c %*c %c', 'headerlines', 10);
fclose(fid);

station_id_a = upperairfield_a{1,1}(1,1);
time_a = datenum(upperairfield_a{1,2},'yyyymmdd:HHMM');
pressure_a = upperairfield_a{1,4};
height_a = upperairfield_a{1,3};
tair_a = upperairfield_a{1,5};
tdew_a = upperairfield_a{1,6};
wdir_a = upperairfield_a{1,7};
wspeed_a = upperairfield_a{1,8};

tft_a = strcmp('-',tair_a);
tairind_a = find(tft_a == 0);
tair_a = tair_a(tairind_a);
timet_a = time_a(tairind_a);
pressuret_a = pressure_a(tairind_a);
heightt_a = height_a(tairind_a);

tftd_a = strcmp('-',tdew_a);
tdewind_a = find(tftd_a == 0);
tdew_a = tdew_a(tdewind_a);
timetd_a = time_a(tdewind_a);
pressuretd_a = pressure_a(tdewind_a);
heighttd_a = height_a(tdewind_a);

tempair_a = char(tair_a);
tempair_a = str2num(tempair_a);

tempdew_a = char(tdew_a);
tempdew_a = str2num(tempdew_a);

timetind1_a = find(timet_a == pdate_a);
timetind2_a = find(timet_a == pdate_a+0.25);
timetind3_a = find(timet_a == pdate_a+0.5);
timetind4_a = find(timet_a == pdate_a+0.75);

timetdind1_a = find(timetd_a == pdate_a);
timetdind2_a = find(timetd_a == pdate_a+0.25);
timetdind3_a = find(timetd_a == pdate_a+0.5);
timetdind4_a = find(timetd_a == pdate_a+0.75);

%--------------------------------------------------------------------------
if ~isempty(timetind1_a)
    plottair1_a = tempair_a(timetind1_a);
    plotheightt1_a = heightt_a(timetind1_a);
    legt1_a = ['Tair at ' datestr(timet_a(timetind1_a(1)),'HH:MM')];
else
    plottair1_a = [];
    plotheightt1_a = [];
    legt1_a = '';
end

if ~isempty(timetind2_a)
    plottair2_a = tempair_a(timetind2_a);
    plotheightt2_a = heightt_a(timetind2_a);
    legt2_a = ['Tair at ' datestr(timet_a(timetind2_a(1)),'HH:MM')];
else
    plottair2_a = [];
    plotheightt2_a = [];
    legt2_a = '';
end

if ~isempty(timetind3_a)
    plottair3_a = tempair_a(timetind3_a);
    plotheightt3_a = heightt_a(timetind3_a);
    legt3_a = ['Tair at ' datestr(timet_a(timetind3_a(1)),'HH:MM')];
else
    plottair3_a = [];
    plotheightt3_a = [];
    legt3_a = '';
end

if ~isempty(timetind4_a)
    plottair4_a = tempair_a(timetind4_a);
    plotheightt4_a = heightt_a(timetind4_a);
    legt4_a = ['Tair at ' datestr(timet_a(timetind4_a(1)),'HH:MM')];
else
    plottair4_a = [];
    plotheightt4_a = [];
    legt4_a = '';
end
%--------------------------------------------------------------------------
if ~isempty(timetdind1_a)
    plottdew1_a = tempdew_a(timetdind1_a);
    plotheighttd1_a = heighttd_a(timetdind1_a);
    legtd1_a = ['Tdew at ' datestr(timetd_a(timetdind1_a(1)),'HH:MM')];
else
    plottdew1_a = [];
    plotheighttd1_a = [];
    legtd1_a = '';
end

if ~isempty(timetdind2_a)
    plottdew2_a = tempdew_a(timetdind2_a);
    plotheighttd2_a = heighttd_a(timetdind2_a);
    legtd2_a = ['Tdew at ' datestr(timetd_a(timetdind2_a(1)),'HH:MM')];
else
    plottdew2_a = [];
    plotheighttd2_a = [];
    legtd2_a = '';
end

if ~isempty(timetdind3_a)
    plottdew3_a = tempdew_a(timetdind3_a);
    plotheighttd3_a = heighttd_a(timetdind3_a);
    legtd3_a = ['Tdew at ' datestr(timetd_a(timetdind3_a(1)),'HH:MM')];
else
    plottdew3_a = [];
    plotheighttd3_a = [];
    legtd3_a = '';
end

if ~isempty(timetdind4_a)
    plottdew4_a = tempdew_a(timetdind4_a);
    plotheighttd4_a = heighttd_a(timetdind4_a);
    legtd4_a = ['Tdew at ' datestr(timetd_a(timetdind4_a(1)),'HH:MM')];
else
    plottdew4_a = [];
    plotheighttd4_a = [];
    legtd4_a = '';
end

%--------------------------------------------------------------------------
legentryt = [legt1; legt2; legt3; legt4; legtd1; legtd2; legtd3; legtd4];

%--------------------------------------------------------------------------
%start plotting
%--------------------------------------------------------------------------
%plot upper air sounding

clf;
% figure1 = figure(1);
% axes1 = axes('Parent',figure1,'FontWeight','demi','FontSize',14);
% hold on
% plot(plotwdir1,plotheight1,'b-+')
% plot(plotwdir2,plotheight2,'k-x')
% plot(plotwdir3,plotheight3,'m-*')
% plot(plotwdir4,plotheight4,'r-d')
% xlim([0 360])
% legend(legentry);
% xlabel('Wind direction [°]','FontWeight','demi','FontSize',14);
% ylabel('Height [m]','FontWeight','demi','FontSize',14);
% hold off

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
legend(legentryt);
xlabel('Temperature [°C]','FontWeight','demi','FontSize',14);
ylabel('Height [m]','FontWeight','demi','FontSize',14);
hold off



figure3 = figure(3);
axes3 = axes('Parent',figure3,'YTick',[500 1000 1500 2000 2500 3000 3500],'YColor',[0 0 1],...
    'XTickLabel',{'00:00','03:00','06:00','09:00','12:00','15:00','18:00','21:00','24:00'},...
    'XTick',[fix(timeR(1)) fix(timeR(1))+.125 fix(timeR(1))+.25 fix(timeR(1))+.375 fix(timeR(1))+.5 ...
    fix(timeR(1))+.625 fix(timeR(1))+.75 fix(timeR(1))+.875 fix(timeR(1))+1],'Layer','top',...
    'FontWeight','demi',...
    'FontSize',16,...
    'CLim',[15 500]);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes3,[timeR(1) timeR(end)]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes3,[42.5 3802.5]);
box(axes3,'on');
hold(axes3,'all');

% Create image
image(timeR,flipdim(altR,2),flipdim((dataR)',1),'Parent',axes3,'CDataMapping','scaled');
plot(time_mlh,mlh,'Parent',axes3,'Marker','+','Linestyle','none','color','m')

% Create xlabel
xlabel({'Time of Day (NZST)'},'FontWeight','demi','FontSize',16);

% Create ylabel
ylabel({'Height above ground (m)'},'FontWeight','demi','FontSize',16);

% Create colorbar
colorbar('peer',axes3,'FontSize',16);

axes31 = axes('Parent',figure3,...
    'FontWeight','demi','FontSize',14,...
    'XTickLabel',{'-40','-20','0','20','40','60'},'XTick',(-40:20:60),'XAxisLocation','top','TickDir','out',...
    'YTick',[],'YTickLabel',{});
    
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes31,[-50 80]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes31,[42.5 3802.5]);
 set(gca,'color','none')
hold(axes31,'all');

% Create plot
%plot(plottair1-40,plotheightt1,'Parent',axes31,'color','k','Linestyle','-','Linewidth',2,'Marker','+',...
 %   'DisplayName','Tair Whenuapai, 00:00 NZST')
%plot(plottair2,plotheightt2,'Parent',axes31,'k-x')
plot(plottair3,plotheightt3,'Parent',axes31,'color','k','Linestyle','-','Linewidth',2,'Marker','*',...
    'DisplayName','Tair Whenuapai, 12:00 NZST')
%plot(plottair4,plotheightt4,'Parent',axes31,'r-d')

%plot(plottdew1-40,plotheighttd1,'Parent',axes31,'color','w','Linestyle','-','Linewidth',2,'Marker','^',...
%    'DisplayName','Tdew Whenuapai 00:00 NZST')
%plot(plottdew2,plotheighttd2,'Parent',axes31,'k-s')
plot(plottdew3,plotheighttd3,'Parent',axes31,'color','w','Linestyle','-','Linewidth',2,'Marker','p',...
    'DisplayName','Tdew Whenuapai 12:00 NZST')
%plot(plottdew4,plotheighttd4,'Parent',axes31,'r-v')

%plot(plottair1_a-40,plotheightt1_a,'Parent',axes31,'color','k','Linestyle','--','Linewidth',2,'Marker','h',...
%    'DisplayName','Tair Auckland Airport 00:00 NZST')
% plot(plottair3_a,plotheightt3_a,'Parent',axes31,'color','k','Linestyle','--','Linewidth',2,'Marker','d',...
%     'DisplayName','Tair Auckland Airport 12:00 NZST')
% plot(plottdew1_a-40,plotheighttd1_a,'Parent',axes31,'color','w','Linestyle','--','Linewidth',2,'Marker','s',...
%     'DisplayName','Tdew Auckland Airport 00:00 NZST')
% plot(plottdew3_a,plotheighttd3_a,'Parent',axes31,'color','w','Linestyle','--','Linewidth',2,'Marker','v',...
%     'DisplayName','Tdew Auckland Airport 12:00 NZST')

title({['Time Height Section with Profile of Air and Dew Point Temperature on ' date(4:5) '.' date(2:3) '.' plotdate(1:4)]},...
    'FontWeight','demi', 'FontSize',14);
legend(axes3,'mixed layer height');
legend(axes31,'show');

figure4 = figure(4);
axes4 = axes('Parent',figure4,...
    'XTickLabel',{'00:00','03:00','06:00','09:00','12:00','15:00','18:00','21:00','24:00'},...
    'XTick',[fix(timeR(1)) fix(timeR(1))+.125 fix(timeR(1))+.25 fix(timeR(1))+.375 fix(timeR(1))+.5 ...
    fix(timeR(1))+.625 fix(timeR(1))+.75 fix(timeR(1))+.875 fix(timeR(1))+1],...
    'FontWeight','demi','FontSize',16);
hold on
%plot(dataA,altA,'r','LineWidth',2)
plot(timeR, sum(dataR(:,10:20),2),'c','LineWidth',2)
plot(timeR, mean(dataR(:,10:20),2),'b','LineWidth',2)
plot(timeR, mean(dataR(:,10:750),2),'m','LineWidth',2)
%ylim ([50 4000])
%legend('original','noise corrected')
xlabel('Time of Day (NZST)','FontWeight','demi','FontSize',16)
ylabel('Mean backscatter between 50 and 100 m','FontWeight','demi','FontSize',16)
title(['Time series of backscatter on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
legend('Sum of backscatter from 50 to 100 m','Mean backscatter from 50 to 100 m','Mean backscatter from 50 to 1500 m')
hold off

t_anfang = datenum(['201' date '1530'],'yyyymmddHHMM');
[tmina,tmininda] = min(abs(timeR-t_anfang));
t_ende = datenum(['201' date '2230'],'yyyymmddHHMM');
[tmine,tmininde] = min(abs(timeR-t_ende));
lentry = datestr(timeR(tmininda:240:tmininde),'HH:MM');

pinda = tmininda-25
pinde = tmininde-25
tmininda
%pdataR = zeros(length(dataR),50)
for i = 1:5
    meana = pinda+50*(i-1)+240*(i-1);
    meane = pinda+50*i+240*(i-1);
    
    i
    %PD = mean(dataR(pinda+ipinde+i,:);
    
    pdataR(i,:) = mean(dataR(meana:meane,:));
    graddataR(i,:) = gradient(pdataR(i,:));
end

figure5 = figure(5);
axes5 = axes('Parent',figure5,'FontWeight','demi','FontSize',16);
hold on
%plot(dataA,altA,'r','LineWidth',2)
plot(dataR(tmininda:240:tmininde,:),altR,'b','LineWidth',2)
plot(pdataR,altR,'r','linewidth',2)
ylim ([50 4000])
%legend('original','noise corrected')
xlabel('backscatter','FontWeight','demi','FontSize',16)
ylabel('height [m]','FontWeight','demi','FontSize',16)
title(['Selected single profiles on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
legend(lentry)
hold off

figure6 = figure(6);
axes6 = axes('Parent',figure6,'FontWeight','demi','FontSize',16);
hold on
plot(graddataR,altR,'r','linewidth',2)
ylim ([50 4000])
%legend('original','noise corrected')
xlabel('backscatter','FontWeight','demi','FontSize',16)
ylabel('height [m]','FontWeight','demi','FontSize',16)
title(['Gradient of selected single profiles on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
legend(lentry)


hold off
