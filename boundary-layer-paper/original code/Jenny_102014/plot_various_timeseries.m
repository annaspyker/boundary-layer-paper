%function plot_various_timeseries
%27.05.2013

clear all;

year = '2012';
month = '12';
day = '15';

ceilpath = 'd:\Neuseeland\uni\matfiles\singleprofiles\';
listfolder = dir([ceilpath 'AK*']);

n = length(listfolder);

orgsum_all = [];
orgsum_1500= [];
orgsum_500 = [];
orgsum_100 = [];
orgtime = [];
corsum_all = [];
corsum_1500= [];
corsum_500 = [];
corsum_100 = [];
cortime = [];

hourtime = [];
hourdata = [];
hourdata1500 = [];
hourdata500 = [];
hourdata100 = [];

hourtimec = [];
hourdatac = [];
hourdatac1500 = [];
hourdatac500 = [];
hourdatac100 = [];

legentry3 = [];

%--------------------------------------------------------------------------
%as a first try, find all times with relative humidity < 62% 
%(according to Münkel et al., 2004)

relhumpath = 'd:\Neuseeland\uni\data\Metdata\';
humfiles = dir([relhumpath 'screen*']);
l = length(humfiles);
station_id = zeros(1,l);
humtime = zeros(937,l);
relhum = zeros(937,l);
for h = 1:l
    humfile = [relhumpath humfiles(h).name];
    fid=fopen(humfile,'r');
    humfield = textscan(fid,'%d %13c %*f %*s %*s %*d %f %*f %*s %*s', 'headerlines', 9);
    fclose(fid);
    station_id(1,h) = humfield{1,1}(1,1);
    humdatenum = datenum(humfield{1,2},'yyyymmdd:HHMM');
    hum = humfield{1,3};
    u62 = find(hum<100);
    humind = length(hum(u62));
    %size(datenum(windfield{1,2},'yyyymmdd:HHMM'));
    humtime(1:humind,h) = humdatenum(u62);
    relhum(1:humind,h) = hum(u62);
    
    lenh = length(humfiles(h).name(11:end-4));
    space = 17-lenh;
    format = ['%' num2str(space) 'c%s'];
    singlelegentry = sprintf(format,' ',humfiles(h).name(11:end-4));
    
    legentry3 = [legentry3;singlelegentry];
    
    
    
end


%--------------------------------------------------------------------------
n = 1;
for i = 1:n
    %ceilmpath = [ceilpath listfolder(i).name '\']
    ceilmpath = [ceilpath 'AK' year(3:4) month '\']
%     listpath = dir([ceilmpath 'R*']);
%     m = length(listpath);
%     for j = 1:m
%         ceilfile = fullfile([ceilmpath listpath(j).name]);
%         load(ceilfile);
%         ze = find(data{1,1} < 0);
%         data{1,1}(ze) = 0;
%         
%         orgtimevec = datevec(data{1,2});
%         uni = unique(orgtimevec(:,4));
%         for u = 1:length(uni)
%             induni = find(orgtimevec(:,4) == uni(u));
%             hourtime = [hourtime; datenum(orgtimevec(induni(end),:))];
%             hourmean = mean(data{1,1}(induni,:));
%             hourdata = [hourdata; sum(hourmean(11:end))];
%             hourdata1500 = [hourdata1500;sum(hourmean(11:300),2)];
%             hourdata500 = [hourdata500;sum(hourmean(11:100),2)];
%             hourdata100 = [hourdata100;sum(hourmean(11:20),2)];
%         end
%         
%         orgsum = sum(data{1,1}(:,11:end),2);
%         orgsum_all = [orgsum_all;orgsum];
%         orgsum_1500= [orgsum_1500;sum(data{1,1}(:,11:300),2)];
%         orgsum_500 = [orgsum_500;sum(data{1,1}(:,11:100),2)];
%         orgsum_100 = [orgsum_100;sum(data{1,1}(:,11:20),2)];
%         orgtime = [orgtime,data{1,2}];
%         %create hourly mean profile
%         
%     end
    listpathc = dir([ceilmpath 'R' year(4) month day '*']);
    m = length(listpathc);
    for j = 1:m
        ceilfilec = fullfile([ceilmpath listpathc(j).name]);
        cdata = load(ceilfilec);
        
        cortimevec = datevec(cdata.time);
        unic = unique(cortimevec(:,4));
        for u = 1:length(unic)
            indunic = find(cortimevec(:,4) == unic(u));
            hourtimec = [hourtimec; datenum(cortimevec(indunic(end),:))];
            hourmeanc = mean(cdata.profile_nonoise(indunic,:));
            hourdatac = [hourdatac; sum(hourmeanc(11:end))];
            hourdatac1500 = [hourdatac1500;sum(hourmeanc(11:300))];
            hourdatac500 = [hourdatac500;sum(hourmeanc(11:100))];
            hourdatac100 = [hourdatac100;sum(hourmeanc(11:20))];
        end
        
        corsum_all = [corsum_all;sum(cdata.profile_nonoise(:,11:end),2)];
        corsum_1500= [corsum_1500;sum(cdata.profile_nonoise(:,11:300),2)];
        corsum_500 = [corsum_500;sum(cdata.profile_nonoise(:,11:100),2)];
        corsum_100 = [corsum_100;sum(cdata.profile_nonoise(:,11:20),2)];
        cortime = [cortime,cdata.time];
    end
end

% u62 = find(relhum <62);
% relhum = relhum(u62);
% humtime = humtime(u62);

[m,n] = size(humtime);
% loc = zeros(m,n);
 sametime = zeros(m,n);
 samehum100 = zeros(m,n);
 samehum500 = zeros(m,n);
 samehum1500 = zeros(m,n);
 samehumc100 = zeros(m,n);
 samehumc500 = zeros(m,n);
 samehumc1500 = zeros(m,n);
 for h = 1:n
    hround = round((hourtimec - floor(hourtimec)).*24);
    hourtimeh = floor(hourtimec)+hround/24;
    [tf,loc] = ismember(nonzeros(humtime(:,h)), hourtimeh);
   %size(loc(:,h))
    sametime(1:length(nonzeros(loc)),h) = hourtimeh(nonzeros(loc));
%     samehum100(1:length(nonzeros(loc)),h) = hourdata100(nonzeros(loc));
%     samehum500(1:length(nonzeros(loc)),h) = hourdata500(nonzeros(loc));
%     samehum1500(1:length(nonzeros(loc)),h) = hourdatac500(nonzeros(loc));
    samehumc100(1:length(nonzeros(loc)),h) = hourdatac100(nonzeros(loc));
    samehumc500(1:length(nonzeros(loc)),h) = hourdatac500(nonzeros(loc));
    samehumc1500(1:length(nonzeros(loc)),h) = hourdatac1500(nonzeros(loc));
 end
 
%--------------------------------------------------------------------------
%find out correct time of pm measurements for correlation with ceilometer
%data
pmdir = 'd:\Neuseeland\uni\data\';
pmfile = fullfile(pmdir, ['PM1hr_' year '.txt']);
fid=fopen(pmfile,'r');
pmfield = textscan(fid,'%10c %5c %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d', 'headerlines', 3);
fclose(fid);

date = pmfield{1,1};
time = pmfield{1,2};
plottime = datenum([date,time],'dd.mm.yyyyHH:MM');
    
pm10_Henderson = pmfield{1,3};
pm10_Penrose = pmfield{1,4};
pm25_Penrose = pmfield{1,5};
pm10_Takapuna = pmfield{1,6};
pm25_Takapuna = pmfield{1,7};
pm10_Patumahoe = pmfield{1,8};
pm10_Pakuranga = pmfield{1,9};
pm10_Botany = pmfield{1,10};
pm10_GlenEden = pmfield{1,11};
pm10_Orewa = pmfield{1,12};
pm25_Patumahoe = pmfield{1,13};
pm10_Whangaparaoa = pmfield{1,14};
pm25_Whangaparaoa = pmfield{1,15};
pm10_MobilePOAL = pmfield{1,16};
pm25_MobilePOAL = pmfield{1,17};
pm10_KhyberPass = pmfield{1,18};
pm10_Kumeu = pmfield{1,19};

nzsamet = nonzeros(sametime(:,4));
[tfpm,locpm] = ismember(nzsamet, plottime);
timepm = plottime(nonzeros(locpm));

pm25_Taka = pm25_Takapuna(nonzeros(locpm));
pm25_Pen = pm25_Penrose(nonzeros(locpm));
pm25_Patu = pm25_Patumahoe(nonzeros(locpm));
pm25_Whan = pm25_Whangaparaoa(nonzeros(locpm));
pm25_Mob = pm25_MobilePOAL(nonzeros(locpm));

pm25_all = [pm25_Taka,pm25_Pen,pm25_Patu,pm25_Whan,pm25_Mob];

pm10_Taka = pm10_Takapuna(nonzeros(locpm));
pm10_Pen = pm10_Penrose(nonzeros(locpm));
pm10_GE = pm10_GlenEden(nonzeros(locpm));
pm10_Hend = pm10_Henderson(nonzeros(locpm));
pm10_Pak = pm10_Pakuranga(nonzeros(locpm));
pm10_Khyb = pm10_KhyberPass(nonzeros(locpm));
pm10_Patu = pm10_Patumahoe(nonzeros(locpm));
pm10_Bot = pm10_Botany(nonzeros(locpm));
pm10_Ore = pm10_Orewa(nonzeros(locpm));
pm10_Whan = pm10_Whangaparaoa(nonzeros(locpm));
pm10_Mob = pm10_MobilePOAL(nonzeros(locpm));
pm10_Kum = pm10_Kumeu(nonzeros(locpm));

pm10_all = [pm10_Taka,pm10_Pen,pm10_GE,pm10_Hend,pm10_Pak,pm10_Khyb,pm10_Patu,pm10_Bot,pm10_Ore,pm10_Whan,pm10_Mob,pm10_Kum];
pm10_allA = [pm10_Taka,pm10_Pen,pm10_GE,pm10_Hend,pm10_Pak,pm10_Khyb,pm10_Bot];

indpm = find(tfpm ~=0);
sametimepm = nzsamet(indpm);
same500pm = samehumc100(indpm);
 
size(timepm)
size(sametimepm)

%--------------------------------------------------------------------------
%
time_mlh = [];
mlh = [];

date_mlh = [year(4) month day];
plotpath_mlh = ['d:\Neuseeland\uni\matfiles\inns_format\AK1' date_mlh(1:3) '\'];

plotlist_mlh = dir([plotpath_mlh 'r' date_mlh '*mlh.mat']);

n = length(plotlist_mlh);
for i = 1:n
    load([plotpath_mlh plotlist_mlh(i).name]);
    time_mlh = [time_mlh, mlh_height(1,:)];
    mlh = [mlh, mlh_height(2:5,:)];
end

%--------------------------------------------------------------------------
clf;
figure(1)
hold on
%plot(orgtime,orgsum_all,'r*')
% plot(orgtime,orgsum_1500,'r+')
% plot(orgtime,orgsum_500,'rx')
%plot(cortime,corsum_all,'b*')
plot(cortime,corsum_1500,'r+')
plot(cortime,corsum_500,'bx')
plot(cortime,corsum_100,'c*')
datetick('x',15)
%legend('original: 50-3600m', 'original: 50-1500m','original: 50-500m','corrected: 50-3600m','corrected: 50-1500m','corrected: 50-500m')
%legend('original: 50-1500m','original: 50-500m','corrected: 50-1500m','corrected: 50-500m')
legend('50-1500 m','50-500 m','50-100 m')
title([ day '.' month '.201' year(4)])
xlabel('HH:MM')
ylabel('vertical sum of backscatter')
title('Time series of various sums of backscatter profile')
hold off

figure(2)
hold on
%plot(orgtime,orgsum_all,'r*')
% plot(hourtime,hourdata1500,'r+')
% plot(hourtime,hourdata500,'rx')
%plot(cortime,corsum_all,'b*')
plot(hourtimec,hourdatac1500,'r+')
plot(hourtimec,hourdatac500,'bx')
plot(hourtimec,hourdatac100,'c*')
datetick('x',15)
%legend('original: 50-3600m', 'original: 50-1500m','original: 50-500m','corrected: 50-3600m','corrected: 50-1500m','corrected: 50-500m')
%legend('original: 50-1500m','original: 50-500m','corrected: 50-1500m','corrected: 50-500m')
legend('50-1500 m','50-500 m','50-100 m')
xlabel('HH:MM')
ylabel('vertical sum of backscatter')
title(['Time series of hourly mean sums of backscatter profile on ' day '.' month '.201' year(4)])
hold off

figure(3)
hold on
plot(humtime,relhum,'.')
datetick('x',15)
xlim([hourtimec(1) hourtimec(end)])
ylim([0 105])
title([day '.' month '.201' year(4)])
xlabel('HH:MM')
ylabel('relative humidity [%]')
legend(legentry3)
hold off

figure(4)
hold on
plot(sametime(:,3),samehumc500(:,3)./1000,'b+')
plot(sametime(:,3),samehumc100(:,3)./500,'c*')
%plot(sametime(:,3),samehumc1500(:,3),'cx')
plot(timepm,pm25_Taka,'md')
plot(timepm,pm10_Taka,'mo')
plot(timepm,pm25_Pen,'gd')
plot(timepm,pm10_Pen,'go')
plot(timepm,pm10_GE,'ro')
plot(timepm,pm10_Khyb,'bo')
plot(timepm,pm10_Hend,'yo')
plot(timepm,pm10_Pak,'co')
datetick('x',15)
xlim([hourtimec(1) hourtimec(end)])
xlabel('HH:MM')
ylabel('PM25 [µg/m³] (magenta); Sum of ceilometer signal (blue)')
title([day '.' month '.201' year(4)])
legend('CeiloSignal/1000 50-500 m','CeiloSignal/500 50-100m','PM2.5 Takapuna','PM10 Takapuna', ...
    'PM2.5 Penrose','PM10 Penrose','PM10 GlenEden','PM10 KhyberPass','PM10 Henderson','PM10 Pakuranga')
hold off

figure(5)
hold on
plot(same500pm,pm25_Taka,'.')
xlabel('sum of ceilometer signal')
ylabel('PM [µg/m³]')
title([day '.' month '.201' year(4)])
hold off


figure6 = figure(6);
%hold on 
% Create axes
axes1 = axes('Parent',figure6,'YTick',[0 5000 10000 15000 20000],'YColor',[0 0 1],...
    'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'24:00'],...
    'XTick',[fix(hourtimeh(1)) fix(hourtimeh(1))+.125 fix(hourtimeh(1))+.25 fix(hourtimeh(1))+.375 fix(hourtimeh(1))+.5 ...
        fix(hourtimeh(1))+.625 fix(hourtimeh(1))+.75 fix(hourtimeh(1))+.875 fix(hourtimeh(1))+1],...
    'FontWeight','demi','FontSize',14);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes1,[fix(hourtimeh(1)) fix(hourtimeh(1))+1]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes1,[0 20000]);
box(axes1,'on');
hold(axes1,'all');

% Create plot
plot(sametime(:,3),samehumc500(:,3),'Parent',axes1,'Marker','p','markerfacecolor','k','markeredgecolor','k','LineStyle','none',...
    'DisplayName','Sum of backscatter (50-500 m)');
plot(sametime(:,3),samehumc100(:,3),'Parent',axes1,'Marker','h','markerfacecolor','k','markeredgecolor','k','LineStyle','none',...
    'DisplayName','Sum of backscatter (50-100 m)');

% Create ylabel
ylabel({'Sum of backscatter'},'FontWeight','demi',...
    'FontSize',14,'Color',[0 0 1]);


% Create axes
axes2 = axes('Parent',figure6,'YTick',[0 10 20 30 40 50 60],'YAxisLocation','right',...
    'YColor',[0 0.5 0],...
    'ColorOrder',[0 0.5 0;1 0 0;0 0.75 0.75;0.75 0 0.75;0.75 0.75 0;0.25 0.25 0.25;0 0 1;0 1 0],...
    'Color','none',...
    'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'24:00'],...
    'XTick',[fix(hourtimeh(1)) fix(hourtimeh(1))+.125 fix(hourtimeh(1))+.25 fix(hourtimeh(1))+.375 fix(hourtimeh(1))+.5 ...
        fix(hourtimeh(1))+.625 fix(hourtimeh(1))+.75 fix(hourtimeh(1))+.875 fix(hourtimeh(1))+1],...
    'FontWeight','demi','FontSize',14);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes2,[fix(hourtimeh(1)) fix(hourtimeh(1))+1]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes2,[0 60]);
hold(axes2,'all');

% Create plot
plot(timepm,pm25_Taka,'Parent',axes2,'Marker','.','LineStyle','none','DisplayName','PM2.5 Takapuna');
plot(timepm,pm10_Taka,'Parent',axes2,'Marker','o','LineStyle','none','DisplayName','PM10 Takapuna');
plot(timepm,pm25_Pen,'Parent',axes2,'Marker','d','LineStyle','none','DisplayName','PM2.5 Penrose');
plot(timepm,pm10_Pen,'Parent',axes2,'Marker','<','LineStyle','none','DisplayName','PM10 Penrose');
plot(timepm,pm10_GE,'Parent',axes2,'Marker','>','LineStyle','none','DisplayName','PM10 Glen Eden');
plot(timepm,pm10_Khyb,'Parent',axes2,'Marker','v','LineStyle','none','DisplayName','PM10 Khyber Pass');
plot(timepm,pm10_Hend,'Parent',axes2,'Marker','^','LineStyle','none','DisplayName','PM10 Henderson');
plot(timepm,pm10_Pak,'Parent',axes2,'Marker','s','LineStyle','none','DisplayName','PM10 Pakuranga');
%hold off
% Create xlabel
xlabel({'NZST [HH:MM]'},'FontWeight','demi','FontSize',14);

% Create ylabel
ylabel({'PM [µg/m³]'},'VerticalAlignment','cap',...
    'FontWeight','demi','FontSize',14,'Color',[0 0.5 0]);

% Create title
title({['Sum of ceilometer backscatter and PM measurements on ' day '.' month '.' year]},...
    'FontWeight','demi', 'FontSize',14);
legend(axes1,'show');
legend(axes2,'show');

figure7 = figure(7);
axes7 = axes('Parent',figure7,'YTick',[0 10 20 30 40 50 60],'YColor',[0 0 1],...
    'XTickLabel',[],'XTick',[],...
    'FontWeight','demi','FontSize',14);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes7,[fix(hourtimeh(1)) fix(hourtimeh(1))+1]);
 ylim(axes7, [-5 50]);
hold(axes7,'all');

plot(hourtimeh,mean(pm10_allA,2),'parent',axes7,'color','k','marker','.','Linestyle','none') 

axes7r = axes('Parent',figure7,'YTick',[0 250 500 750 1000 1250 1500],...
    'YAxisLocation','right','YColor',[0 0.5 0],'color','none',...
    'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'24:00'],...
    'XTick',[fix(hourtimeh(1)) fix(hourtimeh(1))+.125 fix(hourtimeh(1))+.25 fix(hourtimeh(1))+.375 fix(hourtimeh(1))+.5 ...
        fix(hourtimeh(1))+.625 fix(hourtimeh(1))+.75 fix(hourtimeh(1))+.875 fix(hourtimeh(1))+1],...
    'FontWeight','demi','FontSize',14);
xlim(axes7r,[fix(hourtimeh(1)) fix(hourtimeh(1))+1]);
ylim(axes7r, [0 1500]);
hold(axes7r,'all');

plot(time_mlh,mlh,'parent',axes7r,'color','m','marker','+','linestyle','none')


corrcoef(same500pm,double(pm25_Taka))
corrcoef(same500pm,double(pm10_Taka))
corrcoef(same500pm,double(pm25_Pen))
corrcoef(same500pm,double(pm10_Pen))
corrcoef(same500pm,double(pm10_GE))
corrcoef(same500pm,double(pm10_Khyb))
corrcoef(same500pm,double(pm10_Hend))
corrcoef(same500pm,double(pm10_Pak))