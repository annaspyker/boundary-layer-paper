%function plot_relhum

%plot wind directions for three different locations
%18.04.2013

clear;

sodir = 'd:\Neuseeland\uni\data\Metdata\';
sofiles = dir(fullfile(sodir,'screenobs1_*'));
n = length(sofiles);

station_id = zeros(1,n);
time = zeros(4734,n);
rh = zeros(4734,n);
%wspeed = zeros(4734,n);

plottime = zeros(24,n);
plotrh = zeros(24,n);
%plotwspeed = zeros(24,n);

plottime_all = [];
plotrh_all = [];

day = 5:8;
month = 1;
year = 2013;

for j = 1:length(day)
    daynum = datenum(year, month, day(j));
    for i = 1:n
        sofile = fullfile(sodir, sofiles(i).name)
        fid=fopen(sofile,'r');
        sofield = textscan(fid,'%d %13c %f %*s %*s %f %f %f %*s %*s', 'headerlines', 9);
        fclose(fid);

        station_id(1,i) = sofield{1,1}(1,1);
        ind = length(sofield{1,4})
        size(datenum(sofield{1,2},'yyyymmdd:HHMM'))
        time(1:ind,i) = datenum(sofield{1,2},'yyyymmdd:HHMM');
        rh(1:ind,i) = sofield{1,5};
        %wspeed(1:ind,i) = windfield{1,4};

        switch 1 
            case max(time(1:ind,i) == daynum)
                first(i) = find(time(1:ind,i) == daynum);
            case max(time(1:ind,i) < daynum)
                first(i) = ind;
            otherwise
                first(i) = 1;
        end

        switch 1
            case max(time(1:ind,i) == daynum+1)
                last(i) = find(time(1:ind,i) == daynum+1);
            case max(time(1:ind,i) < daynum+1)
                last(i) = ind;
    %         case max(time(1:ind,i) < 735235)
    %             last(i) = 0;
            otherwise
                last(i) = 1;
        end
        last(i) = last(i)-1;
        plotind = length(time(first(i):last(i),i));
        plottime(1:plotind,i) = time(first(i):last(i),i);
        plotrh(1:plotind,i) = rh(first(i):last(i),i);
        %plotwspeed(1:plotind,i) = wspeed(first(i):last(i),i);
        legentry{i,:} = sofiles(i).name(11:end-4);
        %datestr(time(last(i),i))
    end
    plottime_all = [plottime_all;plottime];
    plotrh_all = [plotrh_all;plotrh];
end

%want to plot a specific day, so need to specify the date:

% first = find(time == 735235)    %muss die indizees in der Schleife von den einzelnen raussuchen, oder?? auf jeden Fall hier weiter machen!!!
% last = find(time == 735236)

% first
% last
% datestr(time(first(i):last(i),:))

% id = unique(station_id);
% 
% ind_id1 = find(station_id == id(1));
% ind_id2 = find(station_id == id(2));
% ind_id3 = find(station_id == id(3));

% windfile_auck = 'd:\Neuseeland\uni\data\Metdata\surface_wind_hourly_Auckland_Aero.txt';
% fid=fopen(windfile_auck,'r');
% windfield_auck = textscan(fid,'%d %13c %d %*s %f %*s %*s %*s %f %c %c', 'headerlines', 2);
% fclose(fid);
% 
% time_auck = datenum(windfield_auck{1,2},'yyyymmdd:HHMM');
% winddir_auck = windfield_auck{1,3};
% windspeed_auck = windfield_auck{1,4};

% datestr(time(ind_id3(1)))
% datestr(time(ind_id3(end)))
% winddir(ind_id3(1))
% winddir(ind_id3(end))

mark = {'+','x','*','.','o','v','square','>','<','diamond'};
clr = ['b','r','g','k'];

clf;
figure1 = figure(1);
axes1 = axes('Parent',figure1);
hold on
for i = 1:n 
    plot(plottime_all(:,i), plotrh_all(:,i),'marker',mark{i},'color',clr(i),'linestyle','none')
end
set(axes1, 'xtick',[plottime_all(1),plottime_all(1)+0.5,plottime_all(1)+1,plottime_all(1)+1.5,plottime_all(1)+2,...
    plottime_all(1)+2.5,plottime_all(1)+3,plottime_all(1)+3.5]);
set(axes1, 'XTickLabel',['23. 00:00';'23. 12:00';'24. 00:00';'24. 12:00';'25. 00:00';'25. 12:00';'26. 00:00';'26. 12:00']);
xlabel('Time')
ylabel('relative humidity [%]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([plottime_all(1) plottime_all(end)])
ylim([0 105])
legend(legentry)
hold off

figure2 = figure(2);
axes2 = axes('Parent',figure2,...
    'xtick',[plottime_all(1),plottime_all(1)+0.5,plottime_all(1)+1,plottime_all(1)+1.5,plottime_all(1)+2,...
    plottime_all(1)+2.5,plottime_all(1)+3,plottime_all(1)+3.5],...
    'XTickLabel',['23. 00:00';'23. 12:00';'24. 00:00';'24. 12:00';'25. 00:00';'25. 12:00';'26. 00:00';'26. 12:00']);
%'xtick',[plottime_all(1),plottime_all(1)+0.5,plottime_all(1)+1,plottime_all(1)+1.5,plottime_all(1)+2,plottime_all(1)+2.5],...
    %'XTickLabel',['09. 00:00';'09. 12:00';'10. 00:00';'10. 12:00';'11.
    %00:00';'11. 12:00']);
box(axes2,'on');
hold(axes2,'all');
%boxplot(axes4,plotwdir_all')
xlabel('Time')
ylabel('Relative Humidity [%]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([plottime_all(1) plottime_all(end)])
ylim([0 100])
boxplot(axes2,plotrh_all') 



% figure2 = figure(2);
% axes2 = axes('Parent',figure2);
% hold on
% for i = 1:n 
%     plot(plottime(:,i), plotwspeed(:,i),'marker','+','color',[0.9-0.025*i, 0.08*i, 1-0.1*i],'linestyle','none')
% end
% set(axes2, 'xtick',[daynum+0,daynum+0.125,daynum+0.25,daynum+0.375,daynum+0.5,daynum+0.625,daynum+0.75,daynum+0.875,daynum+1]);
% set(axes2, 'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'00:00']);
% xlabel('Time')
% ylabel('Wind speed [°]')
% title([num2str(day) '.' num2str(month) '.' num2str(year)])
% xlim([daynum daynum+1])
% %ylim([0 360])
% legend(legentry)
% hold off



% figure3 = figure(3);
% axes3 = axes('Parent',figure3 );
% plot(time(ind_id3), winddir(ind_id3),'*')
% set(axes3, 'xtick',[735235,735235.125,735235.25,735235.375,735235.5,735235.625,735235.75,735235.875,735236]);
% set(axes3, 'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'00:00']);
% xlim([735235 735236])
% ylim([0 360])
% xlabel('Time')
% ylabel('Wind direction [°]')
% title('Whenuapai')
% 
% 
% 
