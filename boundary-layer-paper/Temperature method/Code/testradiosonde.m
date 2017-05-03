%% function TEMPERATUREPLOT
%
% Tair vs height and Tdew vs height are plotted
% upperairstation data pulled from CliFlo
%
% Siggi 23.5.2013
% Edited by Anna Spyker 30.07.2015, edited by Lena Weissert for PC use 4.2016
%%--------------------------------------------------------------------------

upperairstation = 'WhenuAirport';
plotstartdate = '20130101';
plotTime = 1;
numDays = 1;

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

format long;
clf;

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

% time variance
var = 0;
day = 1;
timeIndex = -1;
emptyFlag = 0;
    
% find where cliflo time and date variable match up
% also find which 6 hour time slots data contains.
dateTemp = date+var+day;
timeNewAIndex{1} = find(timeNewA == dateTemp);
timeNewDIndex{1} = find(timeNewD == dateTemp);
timeNewWSIndex{1} = find(timeNewA == dateTemp);
timeNewWDIndex{1} = find(timeNewD == dateTemp);
var = var + 0.25;
        
BLHDate(1) = dateTemp;
% new Tair time array evaluation
plotTair = tempair(timeNewAIndex{1});
plotheightNewA = heightNewA(timeNewAIndex{1});
legt = ['Tair at ' datestr(timeNewA(timeNewAIndex{1}(1)),'HH:MM')];
                              
% new Tdew time array evaluation
plotTdew = tempdew(timeNewDIndex{1});
plotheightNewD = heightNewD(timeNewDIndex{1});
legtd = ['Tdew at ' datestr(timeNewD(timeNewDIndex{1}(1)),'HH:MM')];
                
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
    
% convert datenum to readable datestr
BLHDateTime(1) = cellstr(datestr(BLHDate(1), 'yyyymmdd-HHMM'));
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

%individual plots
figure(1);
hold on;
plot(TairArray,TairHeightArray,'r-*');
plot(TdewArray,TdewHeightArray,'b-*');
          
ylim([0 4000])
xl = xlim;
set(gca, 'FontSize', 18);
xlabel('Temperature (°C)','FontWeight','demi','FontSize',18);
ylabel('Height (m)','FontWeight','demi','FontSize',18);
hold off;
    
    