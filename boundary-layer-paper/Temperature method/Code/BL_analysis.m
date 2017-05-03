% Boundary layer analysis
clear all

% set directory
path = 'C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/Code/';
cd(path)

% temperaturePlot
temperaturePlot('WhenuAirport', '20130806', 2, 1)

upperairstation = 'WhenuAirport';
plotstartdate = '20130101';
plotTime = 1;
numDays = 31;