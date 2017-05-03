%
% CEILREADCREATEMATFILES reads in original .dat ceilometer data files and stores that
% data in Matlab data files (.mat files)
%
% CeilReadCreateMatFiles(YearI,monthI,dayI,hourI,Year2,month2,day2,...
%    hour2,FilteredTimeStep,InitialFolder,FinalFolder,MaxAltitude)
%
% Reads in the files located in the path INITIALFOLDER starting with the
% earliest file recorded on or after the date stipulated by the variables
% YEARI, MONTHI, DAYI, HOURI, and ending with the latest file on or before
% the date stipulated by YEAR2, MONTH2, DAY2, HOUR2.
%
% CEILREADCREATEMATFILES reads in either .dat files produced by CL-view or .mat files of
% ceilometer data which has already been produced by the function
% CEILREADCREATEMATFILES. It will check for the presence of
% either file types within the stipulated pathname. If both exist, the
% .dat file will be read in.
%
% The data is then sampled at the sampling period defined by FILTEREDTIMESTEP, and
% only the data below or equal to the input ALTMAX, which is given in
% metres is retained.
%
% The data from each original file is then stored as a .mat file in the
% directory FINALFOLDER
%
% The date information must be supplied
%
% Default values
% FilteredTimeStep = 1
% MaxAltitude = 3800
% InitialFolder =  Current Matlab Directory
% FinalFolder =  '/<<<Current Matlab Directory>>>/MatFiles/'
%
% Ceilometer functions called by CEILREAD:
%   CEILREADRAWFILE
%   CEIL_PLOT
%
% Current Version Created by Derek van der Kamp June 26, 2009.
% email: derek.vanderkamp@gmail.com
% -----------------------------------------------------------------------

function ceilReadCreateMatFiles(YearI,monthI,dayI,hourI,Year2,month2,day2,...
    hour2,FilteredTimeStep,InitialFolder, FinalFolder,MaxAltitude)

if (nargin < 9) | isempty(FilteredTimeStep) ,FilteredTimeStep = 1;end
if (nargin <10 | isempty(InitialFolder)) 
    InitialFolder = '';
end
if (nargin <11 | isempty(FinalFolder))
        FinalFolder = 'MatFiles/';
end
if (nargin <12), MaxAltitude = 3800;end;



%initialize LogLetter and File Status
LogLetter = 'A';
FileFound = 0;

% Convert Dates (initial and Final) to julien
DateString = ....
    sprintf('%02d/%02d/%02d %02d:00:00',YearI,monthI,dayI,hourI);
DateNum = datenum(DateString,'yy/mm/dd HH:MM:SS');

DateStringFinal = sprintf('%02d/%02d/%02d %02d:00:00',Year2,month2,day2,hour2);
DateNumFinal = datenum(DateStringFinal,'yy/mm/dd HH:MM:SS');


%  Check for sensible Dates
if DateNumFinal<DateNum;
    error('Final Date Earlier Than Initial Date');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Main Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while DateNum <= DateNumFinal

    % Pull out month, day and hour as seperate varis from julien date
    [DateVector] = sscanf(datestr(DateNum,'yy/mm/dd HH:MM:SS'),...
        '%02d/%02d/%02d %02d:%*02d:%*02d');
    Year = DateVector(1);
    month = DateVector(2);
    day = DateVector(3);
    hour = DateVector(4);

    % Construct Intial Filenames
    DatFilename = sprintf('%s%s%01d%02d%02d%02d.dat',InitialFolder,LogLetter,...
        Year,month,day,hour);
    MatFilename = sprintf('%s%s%01d%02d%02d%02d.mat',InitialFolder,LogLetter,...
        Year,month,day,hour);

    % Construct Final Filename
    FinalFilename = sprintf('%s%s%01d%02d%02d%02d.mat',FinalFolder,LogLetter,...
        Year,month,day,hour);

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
            % Read in Data from .dat file
            % read all data
            data = CeilReadRawFile(DatFilename,3800);
        end


        % Filter Data to required resolution 
        data = ceil_run_avg(...
            ceil_section(data,1,length(data{2}),-1,1,...
            0,MaxAltitude),...
            FilteredTimeStep,1);

        % Determine the Temporal Index for the Low Resolution subset
        StartIndex = floor(FilteredTimeStep/2)+1;
        EndIndex = length(data{2})-round(FilteredTimeStep/2+1);
        LowResIndex = linspace(StartIndex,EndIndex,...
            (EndIndex-StartIndex)/FilteredTimeStep);
        LowResIndex = round(LowResIndex);

        % Determine how high the data should go to
        AltIndex = 1:1:floor(MaxAltitude/5);

        %reduce resolution and Range
        data{1} = data{1}(LowResIndex,AltIndex);
        data{2} = data{2}(LowResIndex);
        data{3} = data{3}(AltIndex);

        % Save data to Final .Mat File
        save(FinalFilename,'data')

    end

    %%%%%%%%%%%%%%%%%%% ADVANCE TIME BY ONE HOUR  %%%%%%%%%%

    DateNum = DateNum+1/24;


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Main Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% If any file was read plot the data


if ~FileFound
    disp('No files not found within that range')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






