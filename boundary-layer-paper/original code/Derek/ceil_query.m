% ceil_query provides some basic information about the inputed ceilometer
% data
%
% ceil_query(all_data)
%
% Outputs information about the inputed ceilometer data ,ALL_DATA
%------------------------------------------------------------------------

function ceil_query(all_data)


% Check to see if data is the proper format
if ~isCeilometerData(all_data)
    error('Inputed Ceilometer Data not properly formatted');
end
    time = cell2mat(all_data(2));
    alt = cell2mat(all_data(3));
    data = cell2mat(all_data(1));

    
    
    
    Vertical_resolution = alt(2)-alt(1)
    Mean_temporal_resolution = (time(end)-time(1))*86400/length(time)
    Start_time = datestr(time(1),0)
    end_time = datestr(time(end),0)
    Maximum_Altitude = alt(end)


