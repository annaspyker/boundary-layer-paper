% ceil_run_avg applies a 2-D running average filter ceilometer data
%
% [DataOut] = ceil_run_avg(DataIn,TimeWindow,AltWindow)
%
% this function takes the ceilomter data DATAIN and performs a running average
% for both dimensions. The window size is determined by TIMEWINDOW and
% ALTWINDOW. 
%
% The function calls the function FilterD twice, which is a tappered end 
% running average function (This function is placed as a subfunction in
% this code)
%
% Default Values
% TimeWindow = 11
% AltWindow = 11
% Current Version created by Derek van der Kamp on June 1, 2009.
% email: derek.vanderkamp@alumni.ubc.ca
%--------------------------------------------------------------------------
function [DataOut] = ceil_run_avg(DataIn,TimeWindow,AltWindow)

if (nargin < 2),TimeWindow = 11;end
if (nargin < 3),AltWindow = 11;end
if (nargin < 4),PlotFlag = 0;end

% Check for proper Data Format
if (~isCeilometerData(DataIn)); error('Improper Data Format'); end

% initilize data matrices
DataOut = DataIn;
DataAvg = DataIn{1}*0;

% Filter Data along Temporal dimension with window size TimeWindow
DataAvg = FilterD(DataIn{1},TimeWindow);

% Rotate this time-filtered data, apply a filter with window size AltWindow
% and then rotate it back to the original orientation
DataAvg(:,11:end) = FilterD(DataAvg(:,11:end)',AltWindow)';
DataOut{1} = DataAvg;

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% -----------------------------------------------------------------------

% FilterD applys a running average with tappered ends
%
% DATAOUT = FilterD(DATAIN,WINDOW)
%
% FilterD applys a running average using the filter function to the vector
% DATAIN, which can be 1-D vector or 2-D matrix The window size of the
% running average is stipulated by WINDOW. If WINDOW is a even number it is
% converted closest greater odd number.
%
% For the first round(WINDOW/2) data points and last round(WINDOW/2) data points 
% the filtering window is reduced appropriatly. 
%
% This function filters the data WINDOW number of times, with each
% successive filter using a window size of one less, starting at the
% stipulated window size, WINDOW, and ending at 1. The middle section of
% the vector (the elements round(WINDOW/2) to length(DATAIN)-round(WINDOW/2))
% is assingned the data filtered using the window size WINDOW, while each
% succesive set of end points are assigned the endpoints of the data
% filtered using the smaller window sizes. 
%
% Current Version created by Derek van der Kamp on April 15, 2009.
% email: derek.vanderkamp@gmail.com
% -----------------------------------------------------------------------

function DataOut = FilterD(DataIn,Window)

% Make sure Window size is an odd number
Window = floor(Window/2)*2+1;

% Create Output vector
DataOut = DataIn;

% Initialize Temporary storage 
temp_data = cell(1,Window);

% Do multiple filtering of data for window sizes ranging from the inputed
% window size to a window size of 1
for I = Window:-1:1
    temp_data{I} = filter(ones(1,I)/I,1,DataIn);

    % For the filter using the stipulated window size assign this filtered 
    % data to the middle section of the output data
    if I == Window
        
         DataOut(round(I/2):end-round(I/2),:)= temp_data{I}(I:end-1,:);
    % if the filter is smaller than the stipulated Window size then just
    % assign the two end points of the filtered data to the output data 
    else
        DataOut(round(I/2),:)= temp_data{I}(I,:);
        DataOut(end-round(I/2),:)= temp_data{I}(end-1,:);
    end
end


