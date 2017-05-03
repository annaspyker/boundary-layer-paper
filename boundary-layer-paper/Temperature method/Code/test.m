% this function plots the BLH 24 hour timeseries. There are several input
% and output options which can be changed depending on which month/year you
% would like to evaluate. This function takes in the *mlh.dat file created
% in func_calcall_auckinput.m

% Anna Spyker 12.2015, edited by Lena Weissert for PC use 4.2016
% set directory
path = 'C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Siggi method/createmlh/';
cd(path)

clear all

% parameters
year = '15';
time = '12:00';
time_filename = '0000';
month = '15';

% path to mlh file func_calcall_auckinput.m created
mlhpath = 'C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/data/Siggi/';
listfolder = dir([mlhpath year month '/mlh/'])
    
% get each day from the folder
n = length(listfolder)
    
%initalise
dev = zeros(n,1);
k = 0;
timemlhnew = [];
mlhnew = [];
    
       
%% load in data
 file = ([mlhpath '/' year month '/mlh/' listfolder(15).name]);
        
% read in each file one day at a time
mlhfile = fullfile([ file]);
load(mlhfile);
            
timemlhnew = [timemlhnew; mlh_height(1,:)'];
            
mlhnew = [mlhnew; mlh_height(2:5,:)'];

% find midday
            for k = 1:length(timemlhnew)
                curr = datestr(timemlhnew(k));
                if (strcmp(curr(13:17), time))
                    midday = k;
                    break;
                end
            end
            
% convert dates to readable format
            for k = 1:length(timemlhnew)
                readablemlh(k,:) = datestr(timemlhnew(k), 'dd mmm yyyy HH:MM');
            end
            
dateArray(19, :) = datestr(timemlhnew(midday));
heightArray(19, :) = floor(mlhnew(midday));
                               
%plotdate = datestr(timemlhnew(midday))
% plot raw data
figure(1); hold on;
                
plot(timemlhnew,mlhnew(:,1),'m+')
plot(timemlhnew,mlhnew(:,2),'r.','markersize',3)
plot(timemlhnew,mlhnew(:,3),'g.','markersize',3)
plot(timemlhnew,mlhnew(:,4),'c.','markersize',3)
                            
% Create xlabel
NumTicks = 25;
L = get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2), NumTicks))
                
xlabel('Time (hour)','FontWeight','demi','FontSize',20);
                
xaxis = [0:25];
xaxis = num2cell(xaxis);
tickStep=2;
xTickLabels = cell(1,numel(xaxis));
xTickLabels(1:tickStep:numel(xaxis)) = xaxis(1:tickStep:numel(xaxis));   % Fills in only the values you want
set(gca,'XTickLabel',xTickLabels);   % Update the tick labels

ylim([0 4000]);
set(gca,'FontSize',18)
box('on');
                    
% Create ylabel
ylabel('Height above ground (m)','FontWeight','demi','FontSize',20);
  title(['Timeseries of mlh in ' datestr(timemlhnew(n),'dd mmm yyyy')],'FontWeight','demi','FontSize',20)
                
               
            
            
          