%function plot_wind

%plot wind direction for three different locations
%18.04.2013

clear;

winddir = 'd:\Neuseeland\uni\data\Metdata\';
windfiles = dir(fullfile(winddir,'surface_wind_*'));
n = length(windfiles);

station_id = zeros(1,n);
time = zeros(4734,n);
wdir = zeros(4734,n);
wspeed = zeros(4734,n);

plottime = zeros(24,n);
plotwdir = zeros(24,n);
plotwspeed = zeros(24,n);

day = 26;
month = 10;
year = 2012;
daynum = datenum(year, month, day);

for i = 1:n
   windfile = fullfile(winddir, windfiles(i).name)
    fid=fopen(windfile,'r');
    windfield = textscan(fid,'%d %13c %d %*s %f %*s %*s %*s %f %c %c', 'headerlines', 9);
    fclose(fid);

    station_id(1,i) = windfield{1,1}(1,1);
    ind = length(windfield{1,4});
    size(datenum(windfield{1,2},'yyyymmdd:HHMM'));
    time(1:ind,i) = datenum(windfield{1,2},'yyyymmdd:HHMM');
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
    plotind = length(time(first(i):last(i),i));
    plottime(1:plotind,i) = time(first(i):last(i),i);
    plotwdir(1:plotind,i) = wdir(first(i):last(i),i);
    plotwspeed(1:plotind,i) = wspeed(first(i):last(i),i);
    legentry{i,:} = windfiles(i).name(14:end-4);
    %datestr(time(last(i),i))
    
    [freq(:,i),xout] = hist(nonzeros(wdir(:,i)),[0:45:360]);
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
    plot(plottime(:,i), plotwdir(:,i),'marker','+','color',[0.9-0.025*i, 0.08*i, 1-0.1*i],'linestyle','none')
end
set(axes1, 'xtick',[daynum+0,daynum+0.125,daynum+0.25,daynum+0.375,daynum+0.5,daynum+0.625,daynum+0.75,daynum+0.875,daynum+1]);
set(axes1, 'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'00:00']);
xlabel('Time')
ylabel('Wind direction [°]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([daynum daynum+1])
ylim([0 360])
legend(legentry)
hold off

figure2 = figure(2);
axes2 = axes('Parent',figure2);
hold on
for i = 1:n 
    plot(plottime(:,i), plotwspeed(:,i),'marker','+','color',[0.9-0.025*i, 0.08*i, 1-0.1*i],'linestyle','none')
end
set(axes2, 'xtick',[daynum+0,daynum+0.125,daynum+0.25,daynum+0.375,daynum+0.5,daynum+0.625,daynum+0.75,daynum+0.875,daynum+1]);
set(axes2, 'XTickLabel',['00:00';'03:00';'06:00';'09:00';'12:00';'15:00';'18:00';'21:00';'00:00']);
xlabel('Time')
ylabel('Wind speed [°]')
title([num2str(day) '.' num2str(month) '.' num2str(year)])
xlim([daynum daynum+1])
%ylim([0 360])
legend(legentry)
hold off



% figure3 = figure(3);
%  bar(xout,freq)
%  legend(legentry)
%  title('frequency distribution of wind direction')
%  xtitle('bins of wind direction')
%  ytitle('number of occurences')
 
 figure4 = figure(4);
 rdir = (-plotwdir+90) * pi/180;
[x,y] = pol2cart(rdir,plotwspeed);
compass(x,y) 
 
annotation(figure4,'textbox',...
    [0.29 0.81 0.10 0.13],...
    'String',{'Wind Direction and Speed in Auckland on Nov 26'},...
    'FontWeight','demi',...
    'FontSize',14,...
    'FitBoxToText','off');

figure5 = figure(5);
axes5 = axes('Parent',figure5, 'Fontsize', 14, 'Fontweight', 'demi');
hold(axes5, 'all')
[u1,v1] = pol2cart(rdir(:,1),plotwspeed(:,1));
feather(axes5,u1,v1,'b');
[u4,v4] = pol2cart(rdir(:,4),plotwspeed(:,4));
feather(axes5,u4,v4,'r');
[u7,v7] = pol2cart(rdir(:,7),plotwspeed(:,7));
feather(axes5,u7,v7,'g');
[u8,v8] = pol2cart(rdir(:,8),plotwspeed(:,8));
feather(axes5,u8,v8,'k');
legend(axes5,'show')


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
