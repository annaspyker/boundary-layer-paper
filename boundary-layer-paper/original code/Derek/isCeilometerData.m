% isCeilometerData checks to see if inputed variable is the proper
% ceilometer data format
%
% [IsCeilData] = isCeilometerData(DataIn)
%
% Checks the inputed variable, DATAIN, to see if it is the standard format
% that is expected by the suite of ceilometer data analysis scripts:
% 
% The variable needs to be at least a 3 element cell with the 1st cell
% being a MxN data matrix, the 2nd element being a numeric vector of length M,
% (the Time vector) the 3rd element being a numeric vector of length N (The
% Altitude vector)
%
% Current Version created by Derek van der Kamp on April 15, 2009.
% email: derek.vanderkamp@gmail.com
%--------------------------------------------------------------------------

function [IsCeilData] = isCeilometerData(DataIn)

if (iscell(DataIn) && length(DataIn) >=3)
    
    [A, B]  = size(DataIn{1});
    
    if (A>0 && B>0 && ...
        length(DataIn{2}) == A && length(DataIn{3}) == B && ...
        isnumeric(DataIn{1}) && isnumeric(DataIn{2}) && ... 
        isnumeric(DataIn{3}))
       
        IsCeilData = true;
    else
        IsCeilData = false;
    end
else
    IsCeilData = false;
end



