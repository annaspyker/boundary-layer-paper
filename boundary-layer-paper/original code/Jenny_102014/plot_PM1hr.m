%function PM1hr

%plot hourly means of pm10 for all locations
%24.04.2013

clear;

 pmdir = 'd:\Neuseeland\uni\data\';
% pmfiles = dir(fullfile(pmdir,'PM1hr_201301*'));
% n = length(pmfiles);

% station_id = zeros(1,n);
% time = zeros(4734,n);
% rh = zeros(4734,n);
% %wspeed = zeros(4734,n);
% 
% plottime = zeros(24,n);
% plotrh = zeros(24,n);
% %plotwspeed = zeros(24,n);
% 
% day = 9;
% month = 1;
% year = 2013;
% daynum = datenum(year, month, day);


    pmfile = fullfile(pmdir, 'PM1hr_2012.txt')
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
    
    
legentry10 = {'Henderson','Penrose','Takapuna','Patumahohe','Pakuranga','Botany','Glen Eden','Orewa','Whangaparaoa','Mobile POAL','Khyber Pass','Kumeu'};
legentry25 = {'Penrose','Takpuna','Patumahohe','Whangaparaoa','Mobile - PAOL'};
legentry10s = {'Henderson','Penrose','Takapuna','Pakuranga','Botany','Glen Eden','Mobile POAL','Khyber Pass'};
legentry25s = {'Penrose','Takpuna','Mobile - PAOL'};
daynum = datenum('20130109','yyyymmdd');

%read grimm data
grimmfile = fullfile(pmdir, 'PM1hr_grimm_2012.txt');
fid=fopen(grimmfile,'r');
grimmfield = textscan(fid,'%10c %5c %d %d %d', 'headerlines', 3);
fclose(fid);

dateg = grimmfield{1,1};
timeg = grimmfield{1,2};
plottimeg = datenum([dateg,timeg],'dd.mm.yyyyHH:MM');
pm10grimm_Penrose = grimmfield{1,3};
pm25grimm_Penrose = grimmfield{1,4};
pm1grimm_Penrose = grimmfield{1,5};

legentryg = {'PM10','PM2.5','Grimm PM10','Grimm PM2.5','Grimm PM1'};
   

clf;
figure1 = figure(1);
axes1 = axes('Parent',figure1);
hold on
plot(plottime, pm10_Henderson,'marker','+','linestyle','none','color','b')
plot(plottime, pm10_Penrose,'marker','*','linestyle','none','color','g')
plot(plottime, pm10_Takapuna,'marker','.','linestyle','none','color',[0.6 0.2 0])
%plot(plottime, pm10_Patumahoe,'marker','x','linestyle','none','color','c')
plot(plottime, pm10_Pakuranga,'marker','o','linestyle','none','color','r')
plot(plottime, pm10_Botany,'marker','<','linestyle','none','color','m')
plot(plottime, pm10_GlenEden,'marker','>','linestyle','none','color','k')
%plot(plottime, pm10_Orewa,'marker','diamond','linestyle','none','color',[0.6 0.6 0.6])
%plot(plottime, pm10_Whangaparaoa,'marker','v','linestyle','none','color',[0.48 0.06 0.89])
plot(plottime, pm10_MobilePOAL,'marker','^','linestyle','none','color',[0 0.6 0])
plot(plottime, pm10_KhyberPass,'marker','s','linestyle','none','color','y')
%plot(plottime, pm10_Kumeu,'marker','p','linestyle','none','color',[1 0.5 0.5])
datetick('x','mmm/dd')
% set(axes1, 'xtick',[daynum+0,daynum+0.125,daynum+0.25,daynum+0.375,daynum+0.5,daynum+0.625,daynum+0.75,daynum+0.875,daynum+1]);
% set(axes1, 'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'00:00']);
xlabel('Month/day')
ylabel('[µg/m³]')
title('PM 10')
%title('PM10 on 09 Jan 2013')
%xlim([daynum daynum+1])
ylim([0 100])
legend(legentry10s)
hold off

figure2 = figure(2);
axes2 = axes('Parent',figure2);
hold on
plot(plottime, pm25_Penrose,'marker','*','linestyle','none','color','g')
plot(plottime, pm25_Takapuna,'marker','.','linestyle','none','color',[0.6 0.2 0])
%plot(plottime, pm25_Patumahoe,'marker','x','linestyle','none','color','c')
%plplot(plottime, pm25_Whangaparaoa,'marker','v','linestyle','none','color',[0.48 0.06 0.89])
plot(plottime, pm25_MobilePOAL,'marker','^','linestyle','none','color',[0 0.6 0])

datetick('x','mmm/dd')
% set(axes2, 'xtick',[daynum+0,daynum+0.125,daynum+0.25,daynum+0.375,daynum+0.5,daynum+0.625,daynum+0.75,daynum+0.875,daynum+1]);
% set(axes2, 'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'00:00']);
xlabel('Month/day')
ylabel('[µg/m³]')
title('PM 2.5')
%title('PM2.5 on 09 Jan 2013')
%xlim([daynum daynum+1])
ylim([0 50])
legend(legentry25s)
hold off

figure3 = figure(3);
axes3 = axes('Parent',figure3);
hold on
plot(plottime, pm10_Penrose,'marker','*','linestyle','none','color','g')
plot(plottime, pm25_Penrose,'marker','+','linestyle','none','color','b')
plot(plottimeg, pm10grimm_Penrose,'marker','d','linestyle','none','color','r')
plot(plottimeg, pm25grimm_Penrose,'marker','s','linestyle','none','color','m')
plot(plottimeg, pm1grimm_Penrose,'marker','o','linestyle','none','color','y')
datetick('x','mmm/dd')
% set(axes3, 'xtick',[daynum+0,daynum+0.125,daynum+0.25,daynum+0.375,daynum+0.5,daynum+0.625,daynum+0.75,daynum+0.875,daynum+1]);
% set(axes3, 'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'00:00']);
xlabel('Month/day')
ylabel('[µg/m³]')
title('PM at Penrose')
%title('PM at Penrose on 09 Jan 2013')
%xlim([daynum daynum+1])
ylim([0 50])
legend(legentryg)
hold off

figure4 = figure(4);
axes4 = axes('Parent',figure4);
hold on
plot(pm10_Penrose,pm10grimm_Penrose, 'marker','*','linestyle','none','color','g')
plot(pm25_Penrose,pm25grimm_Penrose, 'marker','+','linestyle','none','color','m')
line([0 60],[0 60])

xlabel('PM Penrose')
ylabel('PM Penrose Grimm')
xlim([0 60])
ylim([0 60])
legend(['PM 10 ';'PM 2.5'])
hold off