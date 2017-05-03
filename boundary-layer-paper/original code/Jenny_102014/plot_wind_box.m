%function plot_wind_box

%plot wind directions for three different locations
%18.04.2013

clear;

winddir = 'd:\Neuseeland\uni\data\Metdata\';
windfiles = dir(fullfile(winddir,'surface_wind_*'));
n = length(windfiles);
%n = [1,3,4,5,6,7,8,10]
station_id = zeros(1,n);
time = zeros(4734,n);
wdir = zeros(4734,n);
wspeed = zeros(4734,n);

plottime = zeros(24,n);
plotwdir = zeros(24,n);
plotwspeed = zeros(24,n);

plottime_all = [];
plotwdir_all = [];
plotwspeed_all = [];

day = 11:14;
month = 1;
year = 2013;

for j = 1:length(day)
    daynum = datenum(year, month, day(j));
    for i = 1:n
       windfile = fullfile(winddir, windfiles(i).name)
        fid=fopen(windfile,'r');
        windfield = textscan(fid,'%d %13c %d %*s %f %*s %*s %*s %f %c %c', 'headerlines', 9);
        fclose(fid);

        station_id(1,i) = windfield{1,1}(1,1);
        ind = length(windfield{1,4});
        abwind = windfield{1,2};
        size(datenum(abwind,'yyyymmdd:HHMM'));
        time(1:ind,i) = datenum(abwind,'yyyymmdd:HHMM');
        wdir(1:ind,i) = windfield{1,3};
        wspeed(1:ind,i) = windfield{1,4};

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
        plotwdir(1:plotind,i) = wdir(first(i):last(i),i);
        plotwspeed(1:plotind,i) = wspeed(first(i):last(i),i);
        legentry{i,:} = windfiles(i).name(14:end-4)
        %datestr(time(last(i),i))

        [freq(:,i),xout] = hist(nonzeros(wdir(:,i)),[0:45:360]);
    end
    plottime_all = [plottime_all;plottime];
    plotwdir_all = [plotwdir_all;plotwdir];
    plotwspeed_all = [plotwspeed_all;plotwspeed];
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

clf;
figure1 = figure(1);
axes1 = axes('Parent',figure1);
hold on
for i = 1:n 
    plot(plottime_all(:,i), plotwdir_all(:,i),'marker','+','color',[0.9-0.025*i, 0.08*i, 1-0.1*i],'linestyle','none')
end
set(axes1, 'xtick',[plottime_all(1),plottime_all(1)+0.5,plottime_all(1)+1,plottime_all(1)+1.5,plottime_all(1)+2,...
    plottime_all(1)+2.5]);
set(axes1, 'XTickLabel',['09. 00:00';'09. 12:00';'10. 00:00';'10. 12:00';'11. 00:00';'11. 12:00']);
xlabel('Time')
ylabel('Wind direction [°]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([plottime_all(1) plottime_all(end)])
ylim([0 360])
legend(legentry)
hold off

figure2 = figure(2);
axes2 = axes('Parent',figure2);
hold on
for i = 1:n 
    plot(plottime_all(:,i), plotwspeed_all(:,i),'marker','+','color',[0.9-0.025*i, 0.08*i, 1-0.1*i],'linestyle','none')
end
set(axes2, 'xtick',[plottime_all(1),plottime_all(1)+0.5,plottime_all(1)+1,plottime_all(1)+1.5,plottime_all(1)+2,...
    plottime_all(1)+2.5]);
set(axes2, 'XTickLabel',['09. 00:00';'09. 12:00';'10. 00:00';'10. 12:00';'11. 00:00';'11. 12:00']);
xlabel('Time')
ylabel('Wind speed [m/s]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([plottime_all(1) plottime_all(end)])
%ylim([0 360])
legend(legentry)
hold off



% figure3 = figure(3);
%  bar(xout,freq)
%  legend(legentry)
%  title('frequency distribution of wind direction')
%  xtitle('bins of wind direction')
%  ytitle('number of occurences')
%  
 
figure4 = figure(4);

axes4 = axes('Parent',figure4,...
    'xtick',[plottime_all(1),plottime_all(1)+0.5,plottime_all(1)+1,plottime_all(1)+1.5,plottime_all(1)+2,...
    plottime_all(1)+2.5,plottime_all(1)+3,plottime_all(1)+4],...
    'XTickLabel',['23. 00:00';'23. 12:00';'24. 00:00';'24. 12:00';'25. 00:00';'25. 12:00';'26. 00:00';'26. 12:00']);
box(axes4,'on');
hold(axes4,'all');
%boxplot(axes4,plotwdir_all')
xlabel('Time')
ylabel('Wind direction [°]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([plottime_all(1) plottime_all(end)])
ylim([0 360])
boxplot(axes4,plotwdir_all') 

figure5 = figure(5);
axes5 = axes('Parent',figure5,...
    'xtick',[plottime_all(1),plottime_all(1)+0.5,plottime_all(1)+1,plottime_all(1)+1.5,plottime_all(1)+2,...
    plottime_all(1)+2.5,plottime_all(1)+3,plottime_all(1)+4],...
    'XTickLabel',['23. 00:00';'23. 12:00';'24. 00:00';'24. 12:00';'25. 00:00';'25. 12:00';'26. 00:00';'26. 12:00']);
box(axes5,'on');
hold(axes5,'all');

xlabel('Time')
ylabel('Wind Speed [m/s]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([plottime_all(1) plottime_all(end)])
boxplot(axes5,plotwspeed_all') 

figure6 = figure(6);
rdir = (-plotwdir_all+90) * pi/180;
[x,y] = pol2cart(rdir,plotwspeed_all);
compass(x,y) 
 
annotation(figure6,'textbox',...
    [0.29 0.81 0.10 0.13],...
    'String',{'Wind Direction and Speed in Auckland on Nov 26'},...
    'FontWeight','demi',...
    'FontSize',14,'Linestyle','none',...
    'FitBoxToText','off');

figure7 = figure(7);
axes7 = axes('Parent',figure7, 'Fontsize', 14, 'Fontweight', 'demi');
hold(axes7, 'all')
daspect([1 1 1])
[u1,v1] = pol2cart((-plotwdir_all(:,3)+90)*pi/180,plotwspeed_all(:,3));
feather(axes7,u1,v1,'b');
[u4,v4] = pol2cart((-plotwdir_all(:,6)+90)*pi/180,plotwspeed_all(:,6));
feather(axes7,u4,v4,'r');
[u2,v2] = pol2cart((-plotwdir_all(:,1)+90)*pi/180,plotwspeed_all(:,1));
feather(axes7,u2,v2,'c');
[u3,v3] = pol2cart((-plotwdir_all(:,2)+90)*pi/180,plotwspeed_all(:,2));
feather(axes7,u3,v3,'m');
[u5,v5] = pol2cart((-plotwdir_all(:,4)+90)*pi/180,plotwspeed_all(:,4));
feather(axes7,u5,v5,'k');
[u6,v6] = pol2cart((-plotwdir_all(:,5)+90)*pi/180,plotwspeed_all(:,5));
feather(axes7,u6,v6,'y');
% [u7,v7] = pol2cart(rdir(:,7),plotwspeed_all(:,7));
% feather(axes7,u7,v7,'g');
% [u8,v8] = pol2cart(rdir(:,8),plotwspeed_all(:,8));
% feather(axes7,u8,v8,'k');

figure8 = figure(8);
winkel = 15:15:360;
speed =  2*ones(size(winkel));
[u_a,v_a] = pol2cart(((-winkel+90)*pi/180),speed);
feather(u_a,v_a)
daspect([1 1 1])

figure9 = figure(9);
compass(u_a,v_a)
daspect([1 1 1])



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
