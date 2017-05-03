%function plotmultiday

clear all;

timeR_all = [];
dataR_all = [];
time_mlh_all = [];
mlh_all = [];
pdate_all = [];

timetind1_all = [];
timetind2_all = [];
timetind3_all = [];
timetind4_all = [];

timetdind1_all = [];
timetdind2_all = [];
timetdind3_all = [];
timetdind4_all = [];

timetind1_a_all = [];
timetind2_a_all = [];
timetind3_a_all = [];
timetind4_a_all = [];

timetdind1_a_all = [];
timetdind2_a_all = [];
timetdind3_a_all = [];
timetdind4_a_all = [];

% plottair1_all = [];
% plottair2_all = [];
% plottair3_all = [];
% plottair4_all = [];
% 
% plottdew1_all = [];
% plottdew2_all = [];
% plottdew3_all = [];
% plottdew4_all = [];
% 
% plottair1_a_all = [];
% plottair2_a_all = [];
% plottair3_a_all = [];
% plottair4_a_all = [];
% 
% plottdew1_a_all = [];
% plottdew2_a_all = [];
% plottdew3_a_all = [];
% plottdew4_a_all = [];

year = '3';
month = '01';
day = ['11';'12';'13';'14'];

for k = 1:length(day)

    date = [ year month day(k,:)];
    plotpath = ['d:\Neuseeland\uni\matfiles\singleprofiles\AK1' date(1:3) '\']; % 'S:/env/Share/V_CL31/AK' date (1:3) '/'
    plotpath_mlh = ['d:\Neuseeland\uni\matfiles\inns_format\AK1' date(1:3) '\']; % what is inns_format?

    plotlistR = dir([plotpath 'R' date '*.mat'])
    plotlist_mlh = dir([plotpath_mlh 'r' date '*mlh.mat'])

    n = length(plotlistR);
    timeR = [];
    dataR = [];
    time_mlh = [];
    mlh = [];
    for i = 1:n
        load([plotpath plotlistR(i).name]);
        timeR = [timeR, time];
        altR = height;
        dataR = [dataR; profile_nonoise];

        load([plotpath_mlh plotlist_mlh(i).name]);
        time_mlh = [time_mlh, mlh_height(1,:)];
        mlh = [mlh, mlh_height(2:5,:)];
    end
    datestr(timeR(1))
    datestr(timeR(end))
    timeR_all = [timeR_all,timeR];
    dataR_all = [dataR_all,dataR'];
    time_mlh_all = [time_mlh_all,time_mlh];
    mlh_all = [mlh_all,mlh];
    %--------------------------------------------------------------------------
    %read upper air sounding
    %--------------------------------------------------------------------------

    plotdate = ['201' date];
    pdate = datenum(plotdate,'yyyymmdd');
    pdate_all = [pdate_all;pdate];

end
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


for l = 1:length(day)
    timetind1 = find(timet == pdate_all(l));
    anfind1(l) = length(timetind1_all)+1;
    timetind1_all = [timetind1_all;timetind1];
    endind1(l) = length(timetind1_all);
    timetind2 = find(timet == pdate_all(l)+0.25);
    timetind2_all = [timetind2_all;timetind2];
    timetind3 = find(timet == pdate_all(l)+0.5);
    anfind3(l) = length(timetind3_all)+1;
    timetind3_all = [timetind3_all;timetind3];
    endind3(l) = length(timetind3_all);
    timetind4 = find(timet == pdate_all(l)+0.75);
    timetind4_all = [timetind4_all;timetind4];

    timetdind1 = find(timetd == pdate_all(l));
    anfdind1(l) = length(timetdind1_all)+1;
    timetdind1_all = [timetdind1_all;timetdind1];
    enddind1(l) = length(timetdind1_all);
    timetdind2 = find(timetd == pdate_all(l)+0.25);
    timetdind2_all = [timetdind2_all;timetdind2];
    timetdind3 = find(timetd == pdate_all(l)+0.5);
    anfdind3(l) = length(timetdind3_all)+1;
    timetdind3_all = [timetdind3_all;timetdind3];
    enddind3(l) = length(timetdind3_all);
    timetdind4 = find(timetd == pdate_all(l)+0.75);
    timetdind4_all = [timetdind4_all;timetdind4];
end
%--------------------------------------------------------------------------
if ~isempty(timetind1_all)
    plottair1 = tempair(timetind1_all);
    plotheightt1 = heightt(timetind1_all);
    legt1 = ['Tair at ' datestr(timet(timetind1_all(1)),'HH:MM')];
else
    plottair1 = [];
    plotheightt1 = [];
    legt1 = '';
end

if ~isempty(timetind2_all)
    plottair2 = tempair(timetind2_all);
    plotheightt2 = heightt(timetind2_all);
    legt2 = ['Tair at ' datestr(timet(timetind2_all(1)),'HH:MM')];
else
    plottair2 = [];
    plotheightt2 = [];
    legt2 = '';
end

if ~isempty(timetind3_all)
    plottair3 = tempair(timetind3_all);
    plotheightt3 = heightt(timetind3_all);
    legt3 = ['Tair at ' datestr(timet(timetind3_all(1)),'HH:MM')];
else
    plottair3 = [];
    plotheightt3 = [];
    legt3 = '';
end

if ~isempty(timetind4_all)
    plottair4 = tempair(timetind4_all);
    plotheightt4 = heightt(timetind4_all);
    legt4 = ['Tair at ' datestr(timet(timetind4_all(1)),'HH:MM')];
else
    plottair4 = [];
    plotheightt4 = [];
    legt4 = '';
end
%--------------------------------------------------------------------------
if ~isempty(timetdind1_all)
    plottdew1 = tempdew(timetdind1_all);
    plotheighttd1 = heighttd(timetdind1_all);
    legtd1 = ['Tdew at ' datestr(timetd(timetdind1_all(1)),'HH:MM')];
else
    plottdew1 = [];
    plotheighttd1 = [];
    legtd1 = '';
end

if ~isempty(timetdind2_all)
    plottdew2 = tempdew(timetdind2_all);
    plotheighttd2 = heighttd(timetdind2_all);
    legtd2 = ['Tdew at ' datestr(timetd(timetdind2_all(1)),'HH:MM')];
else
    plottdew2 = [];
    plotheighttd2 = [];
    legtd2 = '';
end

if ~isempty(timetdind3_all)
    plottdew3 = tempdew(timetdind3_all);
    plotheighttd3 = heighttd(timetdind3_all);
    legtd3 = ['Tdew at ' datestr(timetd(timetdind3_all(1)),'HH:MM')];
else
    plottdew3 = [];
    plotheighttd3 = [];
    legtd3 = '';
end

if ~isempty(timetdind4_all)
    plottdew4 = tempdew(timetdind4_all);
    plotheighttd4 = heighttd(timetdind4_all);
    legtd4 = ['Tdew at ' datestr(timetd(timetdind4_all(1)),'HH:MM')];
else
    plottdew4 = [];
    plotheighttd4 = [];
    legtd4 = '';
end

% plottair1_all = [plottair1_all,plottair1];
% plottair2_all = [plottair2_all,plottair1];
% plottair3_all = [plottair3_all,plottair1];
% plottair4_all = [plottair4_all,plottair1];
% 
% plottdew1_all = [plottdew1_all,plottdew1];
% plottdew2_all = [plottdew2_all,plottdew1];
% plottdew3_all = [plottdew3_all,plottdew1];
% plottdew4_all = [plottdew4_all,plottdew1];
%--------------------------------------------------------------------------
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

tadjust1 = [-55,-20,25,35];
tadjust3 = [-45,-15,10,40];
figure3 = figure(3);
axes3 = axes('Parent',figure3,'YTick',[500 1000 1500 2000 2500 3000 3500],'YColor',[0 0 1],...
    'XTickLabel',{'5. 00:00','5. 12:00','6. 00:00','6. 12:00','7. 00:00','7. 12:00','8. 00:00','8. 12:00'},...
    'XTick',[fix(timeR_all(1)) fix(timeR_all(1))+.5 fix(timeR_all(1))+1 fix(timeR_all(1))+1.5 fix(timeR_all(1))+2 ...
    fix(timeR_all(1))+2.5 fix(timeR_all(1))+3 fix(timeR_all(1))+3.5],'Layer','top',...
    'FontWeight','demi',...
    'FontSize',16,...
    'CLim',[15 500]);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes3,[timeR_all(1) timeR_all(end)]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes3,[42.5 3802.5]);
box(axes3,'on');
hold(axes3,'all');

% Create image
image(timeR_all,flipdim(altR,2),flipdim((dataR_all),1),'Parent',axes3,'CDataMapping','scaled');
plot(time_mlh_all,mlh_all,'Parent',axes3,'Marker','+','Linestyle','none','color','m')

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
%    'DisplayName','Tair Whenuapai, 00:00 NZST')
%plot(plottair2,plotheightt2,'Parent',axes31,'k-x')
for l = 1:length(day)
    %plot(plottair1(anfind1(l):endind1(l))+tadjust1(l),plotheightt1(anfind1(l):endind1(l)),'Parent',axes31,'color','k','Linestyle','-','Linewidth',2,'Marker','*',...
    %'DisplayName','Tair Whenuapai, 00:00 NZST')
    plot(plottair3(anfind3(l):endind3(l))+tadjust3(l),plotheightt3(anfind3(l):endind3(l)),'Parent',axes31,'color','k','Linestyle','-','Linewidth',2,'Marker','*',...
    'DisplayName','Tair Whenuapai, 12:00 NZST')
end
%plot(plottair4,plotheightt4,'Parent',axes31,'r-d')

%plot(plottdew1-40,plotheighttd1,'Parent',axes31,'color','w','Linestyle','-
%','Linewidth',2,'Marker','^',...
%    'DisplayName','Tdew Whenuapai 00:00 NZST')
%plot(plottdew2,plotheighttd2,'Parent',axes31,'k-s')
for l = 1:length(day)
    %plot(plottdew1(anfdind1(l):enddind1(l))+tadjust1(l),plotheighttd1(anfdind1(l):enddind1(l)),'Parent',axes31,'color','w','Linestyle','-','Linewidth',2,'Marker','p',...
    %'DisplayName','Tdew Whenuapai 00:00 NZST')
    plot(plottdew3(anfdind3(l):enddind3(l))+tadjust3(l),plotheighttd3(anfdind3(l):enddind3(l)),'Parent',axes31,'color','w','Linestyle','-','Linewidth',2,'Marker','p',...
    'DisplayName','Tdew Whenuapai 12:00 NZST')
end
%plot(plottdew4,plotheighttd4,'Parent',axes31,'r-v')

% plot(plottair1_a-40,plotheightt1_a,'Parent',axes31,'color','k','Linestyle','--','Linewidth',2,'Marker','h',...
%     'DisplayName','Tair Auckland Airport 00:00 NZST')
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

% figure4 = figure(4);
% axes4 = axes('Parent',figure4,...
%     'XTickLabel',{'00:00','03:00','06:00','09:00','12:00','15:00','18:00','21:00','24:00'},...
%     'XTick',[fix(timeR(1)) fix(timeR(1))+.125 fix(timeR(1))+.25 fix(timeR(1))+.375 fix(timeR(1))+.5 ...
%     fix(timeR(1))+.625 fix(timeR(1))+.75 fix(timeR(1))+.875 fix(timeR(1))+1],...
%     'FontWeight','demi','FontSize',16);
% hold on
% %plot(dataA,altA,'r','LineWidth',2)
% plot(timeR, sum(dataR(:,10:20),2),'c','LineWidth',2)
% plot(timeR, mean(dataR(:,10:20),2),'b','LineWidth',2)
% plot(timeR, mean(dataR(:,10:750),2),'m','LineWidth',2)
% %ylim ([50 4000])
% %legend('original','noise corrected')
% xlabel('Time of Day (NZST)','FontWeight','demi','FontSize',16)
% ylabel('Mean backscatter between 50 and 100 m','FontWeight','demi','FontSize',16)
% title(['Time series of backscatter on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
% legend('Sum of backscatter from 50 to 100 m','Mean backscatter from 50 to 100 m','Mean backscatter from 50 to 1500 m')
% hold off
% 
% t_anfang = datenum(['201' date '0400'],'yyyymmddHHMM');
% [tmina,tmininda] = min(abs(timeR-t_anfang));
% t_ende = datenum(['201' date '1200'],'yyyymmddHHMM');
% [tmine,tmininde] = min(abs(timeR-t_ende));
% lentry = datestr(timeR(tmininda:240:tmininde),'HH:MM');
% 
% 
% figure5 = figure(5);
% axes5 = axes('Parent',figure5,'FontWeight','demi','FontSize',16);
% hold on
% %plot(dataA,altA,'r','LineWidth',2)
% plot(dataR(tmininda:240:tmininde,:),altR,'b','LineWidth',2)
% ylim ([50 4000])
% %legend('original','noise corrected')
% xlabel('backscatter','FontWeight','demi','FontSize',16)
% ylabel('height [m]','FontWeight','demi','FontSize',16)
% title(['Selected single profiles on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
% legend(lentry)
% hold off
% 
% 
