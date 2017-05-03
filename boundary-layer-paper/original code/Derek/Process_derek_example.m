% Read and plot Ceil data based on Derek's code
% set directory
path = 'C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Original code/Derek/';
cd(path)

clear all

% read in raw data (y,m,d,h,y,m,d,h)
CeilData = CeilRead(3, 1, 5, 0, 3, 1, 5, 23, 1, 3800, 'S:/env/Share/V_CL31/AK1301/')
  
% plot raw data
ceil_plot(CeilData)

% create Mat files
ceilReadCreateMatFiles(3, 1, 5, 0, 3, 1, 5, 23, 1, 'S:/env/Share/V_CL31/AK1305')

% clean data
[DataOut] = ceil_run_avg(CeilData,25,25);

% plot clean data
ceil_plot(DataOut)


