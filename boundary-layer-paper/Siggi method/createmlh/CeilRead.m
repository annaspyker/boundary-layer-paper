%
% CEILREAD reads in ceilometer data files
%
%[final_data] = CeilRead(YearI,monthI,dayI,hourI,Year2,month2,day2,...
%    hour2,TimeStep,MaxAlt,directory,PlotFlag)
%
% Reads in the files located in the path DIRECTORY starting with the
% earliest file recorded on or after the date stipulated by the variables
% YEARI, MONTHI, DAYI, HOURI, and ending with the latest file on or before
% the date stipulated by YEAR2, MONTH2, DAY2, HOUR2.
%
% CEILREAD reads in either .dat files produced by CL-view or .mat files of
% ceilometer data which have been produced by the function
% CEILREADCREATEMATFILES. It will check for the presence of
% either file types within the stipulated pathname. If both exist, the
% .dat file will be read in.
%
% The data is then sampled at the sampling period defined by TIMESTEP, and
% only the data below or equal to the input ALTMAX, which is given in
% metres is retained.
%
% The data is then plotted if PLOTFLAG is set to true.
%
% The date information must be supplied
%
% Default values
% TimeStep = 1
% MaxAlt = 3800
% directory =  Current Matlab Directory
% PlotFlag = 0/FALSE
%
% Ceilometer functions called by CEILREAD:
%   CEILREADRAWFILE
%   CEIL_PLOT
%
% Output Value:
%
%   final_data (1x4 cell): Output data
%       final_data(1) = backscatter data (with a time resolution set by
%       TIMESTEP and altitude range set by MAXALT)
%       final_data(2) = Time Vector (julien (Days after Jan 1, 0000), LST)
%       final_data(1) = Altitude vector
%       final_data(1) = Information String
%
% Examples (Obviously, the directory information is dependent on which
% computer you're running the script on.
%
% CeilData = ...
%       ceilRead(8,8,14,0,8,8,15,1)
% This function call reads in original Cl-View .dat files stored in the
% Current Matlab Directory for August 14, 2008 00hr LST to August 15,2008, 
% 00h LST. The output is 15 sec resolution ceil data with an altitude range 
% of 5m to 3800m.
%
% CeilData = ...
%       ceilRead(8,8,14,0,8,8,15,1,[],[],'C:/Ceilometer/MatFiles10MinRes/')
%   As there are 10min resolution .mat files in the directory
%   'C:/Ceilometer/MatFiles10MinRes/', this function call will output 10min
%   resolution data for 5 to 3800m (the default altitude range) from Aug 14,
%   2008 00:00 to Aug. 15, 2008 00:00.
%
% CeilData = ...
%       ceilRead(8,8,14,0,8,8,15,1,10,1500,'C:/Ceilometer/MatFiles10MinRes/')
%       this function call will output ~100 min resolution data for 5 to 1500m
%       from Aug 14, 2008 00:00 to Aug. 15, 2008 00:00.
%
% Current Version Created by Derek van der Kamp June 26, 2009.
% email: derek.vanderkamp@gmail.com
% -----------------------------------------------------------------------

function [final_data] = CeilRead(YearI,monthI,dayI,hourI,Year2,month2,day2,...
    hour2,TimeStep,MaxAlt,directory,PlotFlag)

if (nargin < 9) | isempty(TimeStep) ,TimeStep = 1;end
if (nargin < 10)| isempty(MaxAlt),MaxAlt = 3800;end
if (nargin < 11)| isempty(directory),directory = '';end
if (nargin < 12)| isempty(TimeStep),PlotFlag = 0;end

%initialize Variables
LogLetter = 'A';
FileFound = 0;

% initialize Output Cell
final_data = cell(1,4);

% Convert Dates (initial and Final) to julien
DateString = ....
    sprintf('%02d/%02d/%02d %02d:00:00',YearI,monthI,dayI,hourI);
DateNum = datenum(DateString,'yy/mm/dd HH:MM:SS');

DateStringFinal = sprintf('%02d/%02d/%02d %02d:00:00',Year2,month2,day2,hour2);
DateNumFinal = datenum(DateStringFinal,'yy/mm/dd HH:MM:SS');

%  Check for sensible Dates
if DateNumFinal<DateNum; error('Final Date Earlier Than Initial Date'); end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Start of Main Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while DateNum <= DateNumFinal

    % Pull out month, day and hour as seperate varis from julien date
    [DateVector] = sscanf(datestr(DateNum,'yy/mm/dd HH:MM:SS'),...
        '%02d/%02d/%02d %02d:%*02d:%*02d');
    Year = DateVector(1);
    month = DateVector(2);
    day = DateVector(3);
    hour = DateVector(4);

    % Construct Filenames
    DatFilename = sprintf('%s%s%01d%02d%02d%02d.dat',directory,LogLetter,...
        Year,month,day,hour);
    MatFilename = sprintf('%s%s%01d%02d%02d%02d.mat',directory,LogLetter,...
        Year,month,day,hour)
    % add data to output cell "final_data" if the raw .dat file or .mat file
    % is found otherwise skip all the reading of data, advance the time by
    % one hour and check for a file again.
    if exist(MatFilename,'file') | exist(DatFilename,'file')

        FileFound = 1;

        if exist(MatFilename,'file')
            % if .mat file exist, open that file, and reduce to altitude
            % range and resolution is required.
            disp(['Reading .mat file: ' MatFilename])
            MatData = open(MatFilename);
            DataLabel = fieldnames(MatData);
            % These If statements are required because some of the
            % variables stored in the .mat files are valled 'data' and some
            % are called 'dataMean'
            if length(DataLabel{1}) == 4, data= MatData.data; disp('data'); end
            if length(DataLabel{1}) == 8, data= MatData.dataMean; disp('dataMean'); end



        elseif exist(DatFilename,'file')
            disp(['Reading .dat file: ' DatFilename])
            % if .mat file does not exist:
            % Read in Data from .dat file using older .m file
            % read all data
            data = CeilReadRawFile(DatFilename,3800);
        end

        % determine which profiles to keep
        TimeIndex = 1:TimeStep:length(data{2});

        % Determine how high the data should go to
        AltIndex = 1:1:floor(MaxAlt/5);

        %reduce resolution and Range
        data{1} = data{1}(TimeIndex,AltIndex);
        data{2} = data{2}(TimeIndex);
        data{3} = data{3}(AltIndex);


        % append data into output cell: "final_data"

        %Backscatter
        final_data{1} = [final_data{1};data{1}];
        % Time (In LST)
        final_data{2} = [final_data{2} data{2}];
        % altitude (metres AGL)
        final_data{3} = data{3};

    end

    %%%%%%%%%%%%%%%%%%% ADVANCE TIME BY ONE HOUR  %%%%%%%%%%

    DateNum = DateNum+1/24;


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    End of Main Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% If any file was read plot the data
if FileFound && PlotFlag
    ceil_plot(final_data);
elseif ~FileFound
    disp('No File Found')
end

% End of Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






