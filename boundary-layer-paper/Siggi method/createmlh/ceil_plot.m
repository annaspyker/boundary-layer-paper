% ceil_plot plots ceilometer data
%
% ceil_plot(ALL_DATA,TILTCORRECT,CEIL_PLOT_TYPE)
%
% Plots the inputed ceilometer data, ALL_DATA, which must be in the proper
% ceilometer data format as created by the function CeilRead.
%
% The optional input, TILTCORRECT is a boolean indicating if the 15 degree
% tilt of the ceilmeter should be corrected for by adjusting the Y-Axis 
% label. NOTE: THE DATA ITSELF IS NOT CORRECTED, ONLY THE Y-Axis Label 
% Default is False
%
% the optional input, CEIL_PLOT_TYPE determines how the data is plotted:
%   CEIL_PLOT_TYPE = 1 (Default): Data is plotted as 2-D curtain plot
%   CEIL_PLOT_TYPE = 2: Data is plotted as time-series of
%       individual altitude bins
%   CEIL_PLOT_TYPE = 3: Data is plotted as backscatter profiles
%
% Current Version created by Derek van der Kamp on June 26, 2009.
% email: derek.vanderkamp@alumni.ubc.ca
%
%-------------------------------------------------------------------------

function ceil_plot(all_data,TiltCorrect,ceil_plot_type)

% Check to see if data is the proper format
if ~isCeilometerData(all_data)
    error('Inputed Ceilometer Data not properly formatted');
end

% defaults
if (nargin < 2 | isempty(TiltCorrect)),TiltCorrect = 0;,end
if (nargin < 3 | isempty(ceil_plot_type)),ceil_plot_type = 1;,end


% interpolate the data to a constant temproal resolution so the 'image'
% function can be used
all_data = CeilConstRes(all_data);

% intialize data and vectors
time = all_data{2};
alt = all_data{3};
data = all_data{1};


% plot the 2-d matrix using the 'image' function
if ceil_plot_type ==1

    % plot the data
    image(time,flipdim(alt,2),flipdim((data)',1),...
        'CDataMapping', 'scaled');
    if TiltCorrect
        % Adjust the Y-Axis LABELS to correct for tilt
        YTick = get(gca,'YTick');
        NewYTick = YTick/cosd(15);
        OrigYTickLabel = get(gca,'YTickLabel');
        set(gca,'YTick',NewYTick);
        set(gca,'YTickLabel',OrigYTickLabel);
        ylabel('Height above ground (m)')
    else
        ylabel('Height above ground (m, Uncorrected)')
    end

    % label axes, with certain fonts and sizes
    set(gca,'FontName', 'Times New Roman');
    set(gca,'FontSize', 20);
    set(gca,'YDir','normal');
    caxis([15 200])
    COLORH = colorbar;
    set(COLORH,'FontName', 'Times New Roman');
    set(COLORH,'FontSize', 20);
    ylabel('Height above ground (m)')
    xlabel('Time of Day (LST)')

    % plot time series of all altitude bins
elseif ceil_plot_type == 2
    plot(time,data)
    xlabel('Time of Day (LST)')
    ylabel('Backscatter (A.U.)')
    % plot backscatter profiles
elseif ceil_plot_type == 3
    plot(data,alt)
    xlabel('Backscatter (A.U.)')
    ylabel('Height above ground (m, Uncorrected)')
end

% Set the x-axis labels to nice intervals
CeilSetXLabel(time,gca)
xlim([time(1) time(end)]);

% Give it a title
title(['Ceilometer Data ',datestr(time(1),'yy/mm/dd HH'),' to ',...
    datestr(time(end),'yy/mm/dd HH')])

end

%----------------------------------------------------------------
%----------------------------------------------------------------
%----------------------------------------------------------------

function [data_out] = CeilConstRes(all_data)
% Sets all data to a constant time resolution for proper use of the 'image'
% function

data_out = all_data; % Initialize Output Data

time = all_data{2}; % Get Inputed Time vector

diff = time(2:end)- time(1:end-1); % Calc time step value for each profile

res = mode(diff); % Take the final resolution to be the most common resolution of the initial
% data

data_out{2}= [time(1):res:time(end)]; % Make A new time vector with the
% a constant resolution

data_out{1} = interp1(time,all_data{1},data_out{2}); % Interpolate all data
% to new constant resolution

end

%----------------------------------------------------------------
%----------------------------------------------------------------
%----------------------------------------------------------------

function [data_out] = CeilSetXLabel(time,gca)
% Sets the X-axis labels to a decent interval for nice plotting

time_start_hr = (round(time(1)*24))/24;
time_end_hr = round(time(end)*24)/24;

if (time(end)-time(1)) < (1/48)
    xtick_vector = [time(1):1/(24*6):time(end)];
elseif (time(end)-time(1)) < (3/24)
    xtick_vector = [time_start_hr:1/(24*6):time_end_hr];
elseif (time(end)-time(1)) < 6/24
    xtick_vector = [time_start_hr:1/24:time_end_hr];
elseif (time(end)-time(1)) < 5
    xtick_vector = [time_start_hr:0.25:time_end_hr];
elseif (time(end)-time(1)) < 15
    xtick_vector = [time_start_hr:0.5:time_end_hr];
else
    xtick_vector = [time_start_hr:1:time_end_hr];
end

set(gca,'XTick',xtick_vector)
datetick('x',15,'keepticks');


end