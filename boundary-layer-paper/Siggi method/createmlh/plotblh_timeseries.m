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
year = '13';
time = '12:00';
time_filename = '1200';
monthStart = 1;
monthEnd = 1;

% output options
createFigure = 1;
createTable = 1;
plotMiddayLine = 0;
displayStandardDev = 1;
displayHeightProbabilities = 1;

for j = monthStart:monthEnd
    
    if (j < 10)
        month = strcat('0', num2str(j))
    else
        month = num2str(j)
    end
    
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
    
    for i = 1:n %days
        
        %% load in data
        if (strcmp(listfolder(i).name, '.') ||  strcmp(listfolder(i).name, '..' ) || strcmp(listfolder(i).name, '.DS_Store'))
            continue;
        end

        file = ([mlhpath '/' year month '/mlh/' listfolder(i).name]);
        
        % read in each file one day at a time
        if exist(file)
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
            
            
            %plotdate = datestr(timemlhnew(midday))
            dateArray(i, :) = datestr(timemlhnew(midday));
            heightArray(i, :) = floor(mlhnew(midday));
            
            if (createFigure)
                
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
                
                xlabel('Time (hour)','FontWeight','demi','FontSize',30);
                
                xaxis = [0:25];
                xaxis = num2cell(xaxis);
                tickStep=2;
                xTickLabels = cell(1,numel(xaxis));
                xTickLabels(1:tickStep:numel(xaxis)) = xaxis(1:tickStep:numel(xaxis));   % Fills in only the values you want
                set(gca,'XTickLabel',xTickLabels);   % Update the tick labels


                ylim([42.5 3802.5]);
                set(gca,'FontSize',20)
                box('on');
                
            if (plotMiddayLine)
                    text(timemlhnew(ceil(end/2)),3400, strcat('Height = ', num2str(floor(mlhnew(midday)))),'HorizontalAlignment','center', 'FontSize',18 )
                    hline = refline([0 mlhnew(midday)]);
                    hline.Color = 'k';
                end
                
                % Create ylabel
                ylabel('Height(m)','FontWeight','demi','FontSize',30);
                title(['Timeseries of blh in ' datestr(timemlhnew(n),'dd mmm yyyy')],'FontWeight','demi','FontSize',30)
                
                % save plot to desired destination
                savefile = (['C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/data/Siggi/' year month '/plots/raw/']);
                cd(savefile)
                figname = [listfolder(i).name(2:7)];
                saveas(figure(1),figname,'png')
                cd('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Siggi method/createmlh')
            end
            
            
            %% get standard deviation of points from 11am-1pm
            
            % find 11am index
            for k = 1:length(timemlhnew)
                curr = datestr(timemlhnew(k));
                if (strcmp(curr(13:17), '23:00'))
                    am = k;
                    break;
                end
            end
            
            % find 1pm index
            for k = 1:length(timemlhnew)
                curr = datestr(timemlhnew(k));
                if (strcmp(curr(13:17), '01:00'))
                    pm = k;
                    break;
                end
            end
            
            % get std of mlh data from 11am-1pm
            dev(i) = nanstd(mlhnew(am:pm));
            
            %% find an array of heights where the BL lies
            
            % get array of values from 11am-1pm
            daytime = mlhnew(am:pm);
            
            % choose height step for probability analysis
            heightStep = 50;
            thresholdArray=0:heightStep:2000;
            probabilityArray=zeros(1, length(thresholdArray));
            
            % loop through midday values to find which threshold they
            % belong to
            for k=1:length(daytime)
                for l=1:length(thresholdArray)
                    if (daytime(k) <= thresholdArray(l))
                        probabilityArray(l-1) = probabilityArray(l-1)+1;
                        break;
                    end
                    
                end
                
            end
            
            % find index of largest amount of points in probArray
            [maxPoints, maxI] = max(probabilityArray);
            
            % print the height and percentage of points at that height
            percentage(i) = floor(maxPoints/length(daytime)*100);
            maxHeight(i) = thresholdArray(maxI);
            
            % reset variables
            timemlhnew = [];
            mlhnew = [];
            clf;
            
        end
    end
    
    if (displayStandardDev)
        dev
    end
    
    
    if (displayHeightProbabilities)
        maxHeight'
        percentage'
    end
    
    
    
    % you need MATLAB 2014a+ for this part to work
    percentageArray = transpose(percentage);
    maxHeightArray = transpose(maxHeight);
    
    if (createTable)
        T = table(heightArray, dateArray, dev, percentageArray, maxHeightArray, 'VariableNames', ...
            {'Height' 'DateTime' 'sd' 'percentage' 'maxHeight'})
        filen = ['C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/data/Siggi/' year month '/excel/']; 
        cd(filen)
        filename = [time_filename '_' year month 'Siggi.csv'];
        writetable(T, filename);
        cd('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Siggi method/createmlh/')
        
    end
    
    %reset
    dev = [];
    heightArray =[];
    dateArray = [];
    percentage = [];
    maxHeight = [];
end