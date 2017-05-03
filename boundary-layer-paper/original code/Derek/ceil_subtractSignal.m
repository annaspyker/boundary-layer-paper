% ceil_subtractSignal removes a single profile from the ceilometer data
%
% NEWCEILDATA = ceil_subtractSignal(CEILDATA,SIGNAL)
%
% Removes the profile, SIGNAL, from CEILDATA. SIGNAL must be a 1-d vector
% where length(SIGNAL) >= length(CEILDATA{3}).
%
% Current version created by Derek van der Kamp, June 1, 2009.
% email: derek.vanderkamp@alumni.ubc.ca
%-------------------------------------------------------------------------

function [NewCeilData] = ceil_subtractSignal(CeilData,Signal)

% Check to see if data is the proper format
if ~isCeilometerData(CeilData)
    error('Inputed Ceilometer Data not properly formatted');
end


NewCeilData = CeilData;


for J=1:length(CeilData{2})
    NewCeilData{1}(J,:) = CeilData{1}(J,:) ...
        - Signal(1:length(CeilData{3}));
end

