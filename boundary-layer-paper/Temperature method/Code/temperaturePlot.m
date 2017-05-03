%% function TEMPERATUREPLOT
%
% Tair vs height and Tdew vs height are plotted
% upperairstation data pulled from CliFlo
%
% Siggi 23.5.2013
% Edited by Anna Spyker 30.07.2015, edited by Lena Weissert for PC use 4.2016
%%--------------------------------------------------------------------------
function t = temperaturePlot(upperairstation, plotstartdate, plotTime, numDays)

%% INPUT
% upperairstation:  STRING (AuckAirport or WhenuAirport)
%                   select station
% plotstartdate:    STRING (yyyymmdd)
%                   select date to begin analysis
% plotTime:         INT
%                   choose which time you'd like to analyse
%                   1=midnight; 2=6am; 3=midday; 4=6pm;
% numDays:          INT
%                   number of days you would like to analyse from start date
%%

%% EXAMPLE INPUT
%
% temperaturePlot('WhenuAirport', '20150101', 3, 1)
%       Plots the boundary layer height at Whenuapai for 1st Jan 2015 at
%       midday only
%
% temperaturePlot('WhenuAirport', '20150101', 1, 31)
%       Plots the boundary layer height at Whenuapai from the 1st-31st Jan
%       2015 at midnight only
%
%%

format long;
clf;

% output options
createPlot = 1;
createTable = 1;
drawLine = 1;

date = datenum(plotstartdate,'yyyymmdd');

% path to cliflo file
upperpath = 'C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/Airport CliFlo Data/';
upperfile = fullfile(upperpath, [upperairstation '.txt']);

fid = fopen(upperfile,'r');
upperairfield = textscan(fid,'%d %13c %d %f %s %s %s %s %*c %*c %*c %*c %*c %c', 'headerlines', 1);
fclose(fid);

% get data from file
station_id = upperairfield{1,1};
time = datenum(upperairfield{1,2},'yyyymmdd:HHMM');
height = upperairfield{1,3};
Tair = upperairfield{1,5};
Tdew = upperairfield{1,6};
Wdir = upperairfield{1,7};
Wspd = upperairfield{1,8};

% find occurences of '-' or '0' in Tair
findTair = strcmp('-',Tair);
findTairZero = find(findTair == 0);

% remove these from other data sets
Tair = Tair(findTairZero);
timeNewA = time(findTairZero);
heightNewA = height(findTairZero);
winddirNewA = Wdir(findTairZero);
windspdNewA = Wspd(findTairZero);

% find occurences of '-' or '0' in Tdew
findTdew = strcmp('-',Tdew);
findTdewZero = find(findTdew == 0);

% remove these from other data sets
Tdew = Tdew(findTdewZero);
timeNewD = time(findTdewZero);
heightNewD = height(findTdewZero);
winddirNewA = Wdir(findTairZero);
windspdNewA = Wspd(findTairZero);

% convert Tair to double
tempair = char(Tair);
tempair = str2num(tempair);

% convert Tdew to double
tempdew = char(Tdew);
tempdew = str2num(tempdew);

%import kidson weathertype info
m = matfile('clusters_daily copy.mat');
kidson = m.clusters;

% convert kidson dates to strings
for j = 1:length(kidson.time)
    kidsonYear{j} = num2str(kidson.time(j,1));
    kidsonMonth{j} = num2str(kidson.time(j,2));
    kidsonDay{j} = num2str(kidson.time(j,3));
    kidsonHour{j} = num2str(kidson.time(j,4));
    
end

% loop through days
for i = 1:numDays
    
    % time variance
    var = 0;
    day = i-1;
    timeIndex = -1;
    emptyFlag = 0;
    
    for j = 1:4
        % find where cliflo time and date variable match up
        % also find which 6 hour time slots data contains.
        dateTemp = date+var+day;
        timeNewAIndex{j} = find(timeNewA == dateTemp);
        timeNewDIndex{j} = find(timeNewD == dateTemp);
        timeNewWSIndex{j} = find(timeNewA == dateTemp);
        timeNewWDIndex{j} = find(timeNewD == dateTemp);
        var = var + 0.25;
        
        if ~isempty(timeNewAIndex{j})
            
            % choose which time you'd like to plot
            % j=1 midnight; j=2 6am; j=3 midday; j=4 6pm;
            % Note: some times might be empty
            if (j == plotTime)
                timeIndex = j;
                BLHDate(i) = dateTemp;
                % new Tair time array evaluation
                plotTair = tempair(timeNewAIndex{j});
                plotheightNewA = heightNewA(timeNewAIndex{j});
                legt = ['Tair at ' datestr(timeNewA(timeNewAIndex{j}(1)),'HH:MM')];
                
                
                % new Tdew time array evaluation
                plotTdew = tempdew(timeNewDIndex{j});
                plotheightNewD = heightNewD(timeNewDIndex{j});
                legtd = ['Tdew at ' datestr(timeNewD(timeNewDIndex{j}(1)),'HH:MM')];
                
                
                % new Wind speed time array evaluation
                plotWspd = Wspd(timeNewWSIndex{j});
                plotheightNewWS = heightNewA(timeNewWSIndex{j});
                
                
                % new Wind direction time array evaluation
                plotWdir = Wdir(timeNewWDIndex{j});
                plotheightNewWD = heightNewA(timeNewWSIndex{j});
            end
        elseif isempty(timeNewAIndex{j})
            if (j == plotTime)
                emptyFlag = 1;
                BLHHour(i) = -1;
                BLHeight(i) = -1;
                BLHDate(i) = dateTemp;
                
            end
        end
    end
    
    
    % set preferred ylimit for BL
    ylimit = 3500;
    
    
    k = 1;
    % find points below y limit
    for j = 1:length(plotheightNewD)
        if (length(plotheightNewD) < 2)
            % no data - skip this iteration
            emptyFlag = 1;
            break;
        end
        if (plotheightNewA(j) < ylimit)
            TairHeightArray(k) = double(plotheightNewA(j));
            TairArray(k) = double(plotTair(j));
            TdewHeightArray(k) = double(plotheightNewD(j));
            TdewArray(k) = double(plotTdew(j));
            
            k = k + 1;
        end
    end
    
    % if there is no data for this specific time, skip this iteration
    if (emptyFlag)
        BLHeight(i) = -1;
        continue;
    end
    
    % convert datenum to readable datestr
    BLHDateTime(i) = cellstr(datestr(BLHDate(i), 'yyyymmdd-HHMM'));
    DateForFile = char(BLHDateTime(1));
    
    for j = 1:length(TairArray)-1
        diff = TairArray(j+1) - TairArray(j);
        if (diff >= 0)
            if (j > 2)
                minIndex = j;
            else
                minIndex = j+1;
            end
            break;
        else
            minIndex = -1;
        end
    end
    if (createPlot)
        %individual plots
        figure(i);
        hold on;
        plot(TairArray,TairHeightArray,'r-*');
        plot(TdewArray,TdewHeightArray,'b-*');
        
        % remove '-' values from Wdir and Wspd
        plotWdir = regexprep(plotWdir,'-','0');
        plotWspd = regexprep(plotWspd,'-','0');
        
        % convert all array to doubles
        % convert direction degrees to radians
        % divide speed by ten
        for var=1:length(plotWdir)
            
            plotWdirNew(var) = str2double(plotWdir(var));
            plotWspdNew(var) = str2double(plotWspd(var));
            
            plotWspdNew(var) = plotWspdNew(var)/10;
            plotWdirNew(var) = degtorad(plotWdirNew(var));
            
        end
        
        % transpose and remove values higher than ylimit
        plotWspdNew = plotWspdNew(1:length(TairHeightArray));
        plotWdirNew = plotWdirNew(1:length(TairHeightArray));
        
        
        % draw wind lines using x = r*sin(theta) and y = r*cos(theta)
        for m = 1:length(TairArray)
            x = [TairArray(m) , TairArray(m)+ plotWspdNew(m)*sin(plotWdirNew(m))];
            y = [TairHeightArray(m), TairHeightArray(m)+ plotWspdNew(m)*cos(plotWdirNew(m))];
            line(x, y , 'Color', 'k')
        end
        
        ylim([0 4000])
        xl = xlim;
        
        legend([legt; legtd], 'Location', 'SouthWest')
        title(BLHDateTime(i));
        set(gca, 'FontSize', 18);
        xlabel('Temperature (°C)','FontWeight','demi','FontSize',18);
        ylabel('Height (m)','FontWeight','demi','FontSize',18);
        hold off;
    end
    
    % find corresponding kidson weather type
    for j = 1:size(kidson.time)
        
        BLHTemp = char(BLHDateTime(i));
        year = BLHTemp(1:4);
        month = BLHTemp(5:6);
        day = BLHTemp(7:8);
        hour = BLHTemp(10:end);
        
        % match up dates from kidson and BLH
        % year
        if (strcmp(year, kidsonYear{j}))
            % check month
            monthFlag = compareMonth(month, kidsonMonth, j);
            if (monthFlag)
                % check day
                dayFlag = compareDay(day, kidsonDay, j);
                if (dayFlag)
                    % check hour
                    hourFlag = compareHour(hour, kidsonHour, j);
                    if (hourFlag)
                        % date match - save kidson weather type
                        kidsonType(i) = kidson.name(j);
                        break;
                    end
                end
            end
        end
    end
    
    cd('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/WhenuFigs');
    
    if (minIndex == -1)
        BLHeight(i) = -1;
        
        if (createPlot)
            %save graph
            filename = strcat(char(BLHDateTime(i)), '.png');
            saveas(figure(i), filename);
            cd('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/Code');
        end
        continue;
    end
    
    if (drawLine)
        line([TdewArray(minIndex),TairArray(minIndex)],[TdewHeightArray(minIndex); , TairHeightArray(minIndex)], 'color','g', 'linewidth', 1);
        
        figure(i)
        line([TdewArray(minIndex),TairArray(minIndex)],[TdewHeightArray(minIndex); , TairHeightArray(minIndex)], 'color','g', 'linewidth', 1);
        text(floor((xl(1)+xl(end))/2), ylimit-200, strcat('Height = ', num2str(floor(TairHeightArray(minIndex)))),'HorizontalAlignment','center')
    end
    
    if (createPlot)
        % save graph
        filename = strcat(char(BLHDateTime(i)), '.png');
        saveas(figure(i), filename);
        
        cd('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/Code');
    end
    
    % save inflection height
    if (minIndex ~= -1)
        BLHeight(i) = TairHeightArray(minIndex);
    else
        BLHeight(i) = -1;
    end
    
    
    
    % reset for next loop
    TairHeightArray = [];
    TdewHeightArray = [];
    TairArray = [];
    TdewArray = [];
    
    if (timeIndex == 1)
        BLHHour(i) = 0;
    elseif (timeIndex == 3)
        BLHHour(i) = 12;
    end
    
end

% you need MATLAB 2014a+ for this part to work
loopend = size(numDays);

if (createTable)
    cd('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/WhenuFigs');
  filename = strcat(DateForFile(1:6), '_1000');
    saveas(figure(loopend+1), filename, 'epsc');
    
    T = table(BLHeight', BLHDateTime', kidsonType', 'VariableNames', ...
        {'Height' 'DateTime' 'KidsonType'});
    
    filename = '0000_2015_Whenu.csv';
    writetable(T, filename);
end

